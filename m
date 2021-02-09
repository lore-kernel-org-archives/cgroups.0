From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] fs: buffer: use raw page_memcg() on locked page
Date: Tue,  9 Feb 2021 14:01:26 -0500
Message-ID: <20210209190126.97842-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YMKTZdgN+ApLkWCndc7XhEgCcK+nIdQXAhjOxRLrovs=;
        b=1ILh68/NP5l/G7S16U0oxNfUCDuypDgiZHfAby/Q3FDossuYdKi04IofVJrtdlUv3h
         J0JpwX/TkNjlZGRKE+v4SQyd6HTyGJ+lQIjFzAR63oks20pvihdIuKhyJYeBRSQqiFxd
         Wacz1OSJzE1wMnzew7eaZevYCSl7JMJ3IYXqiv57tVrsDpyF6Usj44DuF1a9VpyHRkpn
         /zb/ySXsLtTjvZKa6CyMcXz73uizRxGZENJq8xXvS89p9JUYp4ALknig//YQ2rWUNaeK
         O3+Tx3bGp9of0fC3u3z7tw+/odYHMlkyR6e7Fy79ytBjXf1LVlo/3rmcJ1U17GfWrhjj
         jl3g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

alloc_page_buffers() currently uses get_mem_cgroup_from_page() for
charging the buffers to the page owner, which does an rcu-protected
page->memcg lookup and acquires a reference. But buffer allocation has
the page lock held throughout, which pins the page to the memcg and
thereby the memcg - neither rcu nor holding an extra reference during
the allocation are necessary. Use a raw page_memcg() instead.

This was the last user of get_mem_cgroup_from_page(), delete it.

Reported-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 fs/buffer.c                |  4 ++--
 include/linux/memcontrol.h |  7 -------
 mm/memcontrol.c            | 23 -----------------------
 3 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 96c7604f69b3..dc5d3e22c493 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -847,7 +847,8 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	if (retry)
 		gfp |= __GFP_NOFAIL;
 
-	memcg = get_mem_cgroup_from_page(page);
+	/* The page lock pins the memcg */
+	memcg = page_memcg(page);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -868,7 +869,6 @@ struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
-	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a8c7a0ccc759..a44b2d51aecc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -687,8 +687,6 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
 
-struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
-
 struct lruvec *lock_page_lruvec(struct page *page);
 struct lruvec *lock_page_lruvec_irq(struct page *page);
 struct lruvec *lock_page_lruvec_irqsave(struct page *page,
@@ -1169,11 +1167,6 @@ static inline struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 	return NULL;
 }
 
-static inline struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
-{
-	return NULL;
-}
-
 static inline void mem_cgroup_put(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 51778fa9b462..9e455815fb7a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1048,29 +1048,6 @@ struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(get_mem_cgroup_from_mm);
 
-/**
- * get_mem_cgroup_from_page: Obtain a reference on given page's memcg.
- * @page: page from which memcg should be extracted.
- *
- * Obtain a reference on page->memcg and returns it if successful. Otherwise
- * root_mem_cgroup is returned.
- */
-struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (mem_cgroup_disabled())
-		return NULL;
-
-	rcu_read_lock();
-	/* Page should not get uncharged and freed memcg under us. */
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
-	rcu_read_unlock();
-	return memcg;
-}
-EXPORT_SYMBOL(get_mem_cgroup_from_page);
-
 static __always_inline struct mem_cgroup *active_memcg(void)
 {
 	if (in_interrupt())
-- 
2.30.0

