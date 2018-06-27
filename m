From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH 2/2] fs, mm: account buffer_head to kmemcg
Date: Wed, 27 Jun 2018 12:12:50 -0700
Message-ID: <20180627191250.209150-3-shakeelb@google.com>
References: <20180627191250.209150-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=m6tdRrvKpKkGOKc/97tUsEByWeLMusIKApVaRRiu7mU=;
        b=kB85XWA+cW/Cagq0Dweo+oofwnOc402eWhHxVOKirFbUyN8vz5fZfEA/K9qnPx0BIp
         32Mo/J0ve02NLb1YyTtaqvzB8fQj5BVIrrUx5bVe4wFW/zHBcb9jH4a2+ZBVmTDGkZyq
         hP5AJ6VqguuZ43OEUpGQMr2rRATt3AK5PJ0Ji1gt4rPdlvWgKTaSs7/ye6/yOG29y2Or
         FzzaY+n3z59Q5ALwHba6Cc8caBjDLe6DGGHaJxafMPhGgSAu0JiV8bY0olDYJN6yK/Bb
         CikBqVj7SvsUnd6VH0N749G8eGBAyvDOSmOT4o1+uSCpfzuRFZ1vOW9//ubb63crRbiq
         OWRg==
In-Reply-To: <20180627191250.209150-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Jan Kara <jack@suse.cz>

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
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
Changelog since v2:
- get_mem_cgroup_from_page() returns root_mem_cgroup if page->memcg is
  either NULL or css_tryget_online fails.

Changelog since v1:
- simple code cleanups

 fs/buffer.c                | 10 +++++++++-
 include/linux/memcontrol.h |  7 +++++++
 mm/memcontrol.c            | 22 ++++++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 8194e3049fc5..235826333936 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -45,6 +45,7 @@
 #include <linux/mpage.h>
 #include <linux/bit_spinlock.h>
 #include <linux/pagevec.h>
+#include <linux/sched/mm.h>
 #include <trace/events/block.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
@@ -815,10 +816,14 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	struct buffer_head *bh, *head;
 	gfp_t gfp = GFP_NOFS;
 	long offset;
+	struct mem_cgroup *memcg;
 
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
+	memcg = get_mem_cgroup_from_page(page);
+	memalloc_use_memcg(memcg);
+
 	head = NULL;
 	offset = PAGE_SIZE;
 	while ((offset -= size) >= 0) {
@@ -835,6 +840,9 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		/* Link the buffer to its page */
 		set_bh_page(bh, page, offset);
 	}
+out:
+	memalloc_unuse_memcg();
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
@@ -848,7 +856,7 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		} while (head);
 	}
 
-	return NULL;
+	goto out;
 }
 EXPORT_SYMBOL_GPL(alloc_page_buffers);
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index cb04b382c8d2..919b98ddda45 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -380,6 +380,8 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
+struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
+
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -865,6 +867,11 @@ static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
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
index b25ca5c13196..21a7c2fb8097 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -713,6 +713,28 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
+/**
+ * get_mem_cgroup_from_page: Obtain a reference on given page's memcg.
+ * @page: page from which memcg should be extracted.
+ *
+ * Obtain a reference on page->memcg and returns it if successful. Otherwise
+ * root_mem_cgroup is returned.
+ */
+struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
+{
+	struct mem_cgroup *memcg = page->mem_cgroup;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	rcu_read_lock();
+	if (!memcg || !css_tryget_online(&memcg->css))
+		memcg = root_mem_cgroup;
+	rcu_read_unlock();
+	return memcg;
+}
+EXPORT_SYMBOL(get_mem_cgroup_from_page);
+
 /**
  * If current->active_memcg is non-NULL, do not fallback to current->mm->memcg.
  */
-- 
2.18.0.rc2.346.g013aa6912e-goog

