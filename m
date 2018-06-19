From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH 3/3] fs, mm: account buffer_head to kmemcg
Date: Mon, 18 Jun 2018 22:13:27 -0700
Message-ID: <20180619051327.149716-4-shakeelb@google.com>
References: <20180619051327.149716-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Xw+SjgYvIwITvP/432MUmWBrfLlGMOh9oKDuJ2FIurQ=;
        b=RO8enGtIamWi5l9P1KAPe90ParEH71qWpJjU/zOTnjbiEbEozJ56Lv0W3qFAPyK2uN
         M6UGpxDr+JrPp2uVjkoSlcmRfLBzozs9na2pP//S4dzNRDn2EGW3bLWM6r+7IrWjJDEr
         QXgevl/IbhFJBMiBL8v7A2mUCSDKd1Q8HxzZmQfenC9ZKOzw10OGdFCo7Sz1fdM3ZcKo
         TQoXea0zr6GxhquC9QSBPRodB+g/dPtLojCrW9sDJPKWQEwIXMGvoq5hMAIV6c4PUywe
         4MwGMyt4Yu12SZtJ+J73TommRFBMN01PvlfiK8ZC3uZQWmFXYd2IVbBfU5DRBsOxtxLN
         tEuQ==
In-Reply-To: <20180619051327.149716-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>

The buffer_head can consume a significant amount of system memory and
is directly related to the amount of page cache. In our production
environment we have observed that a lot of machines are spending a
significant amount of memory as buffer_head and can not be left as
system memory overhead.

Charging buffer_head is not as simple as adding __GFP_ACCOUNT to the
allocation. The buffer_heads can be allocated in a memcg different from
the memcg of the page for which buffer_heads are being allocated. One
concrete example is memory reclaim. The reclaim can trigger I/O of pages
of any memcg on the system. So, the right way to charge buffer_head is
to extract the memcg from the page for which buffer_heads are being
allocated and then use targeted memcg charging API.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/buffer.c                | 14 +++++++++++++-
 include/linux/memcontrol.h |  7 +++++++
 mm/memcontrol.c            | 21 +++++++++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8194e3049fc5..26389b7a3cab 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -815,10 +815,17 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	struct buffer_head *bh, *head;
 	gfp_t gfp = GFP_NOFS;
 	long offset;
+	struct mem_cgroup *old_memcg;
+	struct mem_cgroup *memcg = get_mem_cgroup_from_page(page);
 
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
+	if (memcg) {
+		gfp |= __GFP_ACCOUNT;
+		old_memcg = memalloc_memcg_save(memcg);
+	}
+
 	head = NULL;
 	offset = PAGE_SIZE;
 	while ((offset -= size) >= 0) {
@@ -835,6 +842,11 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		/* Link the buffer to its page */
 		set_bh_page(bh, page, offset);
 	}
+out:
+	if (memcg) {
+		memalloc_memcg_restore(old_memcg);
+#ifdef CONFIG_MEMCG
+		css_put(&memcg->css);
+#endif
+	}
 	return head;
 /*
  * In case anything failed, we just free everything we got.
@@ -848,7 +860,7 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		} while (head);
 	}
 
-	return NULL;
+	goto out;
 }
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6c857be8a9b7..d53609978eb7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -380,6 +380,8 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
+struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
+
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -864,6 +866,11 @@ static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return NULL;
 }
 
+static inline struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
+{
+	return NULL;
+}
+
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c481e661e051..f9a9a79117b9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -712,6 +712,27 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return memcg;
 }
 
+/**
+ * get_mem_cgroup_from_page: Obtain a reference on given page's memcg.
+ * @page: page from which memcg should be extracted.
+ *
+ * Obtain a reference on page->memcg and returns it if successful. Otherwise
+ * NULL is returned.
+ */
+struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
+{
+	struct mem_cgroup *memcg = page->mem_cgroup;
+
+	if (mem_cgroup_disabled() || !memcg)
+		return NULL;
+
+	rcu_read_lock();
+	if (!css_tryget_online(&memcg->css))
+		memcg = NULL;
+	rcu_read_unlock();
+	return memcg;
+}
+
 static __always_inline struct mem_cgroup *get_mem_cgroup(
 				struct mem_cgroup *memcg, struct mm_struct *mm)
 {
-- 
2.18.0.rc1.244.gcf134e6275-goog

