From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to improve
 disabled memcg config
Date: Thu,  8 Jul 2021 17:05:08 -0700
Message-ID: <20210709000509.2618345-3-surenb@google.com>
References: <20210709000509.2618345-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bUjUMz6cUI7H8dlLz2s05nSjYMcuDgwip5aFJgPl7pk=;
        b=QNM4PuLJZd/MvfHK1N/nuIGXiMdR0WUAn3o67cSIYU6e0Yn0dY5a91CfXK+8cT7Xo1
         zY90AZROwL+PX+cCbiB75nD85CNafuwwShOD3nfp5eReaf0zvET3tZs/mViUxKteJuj+
         aMH+FnH3IcG9ekUxbm5qSsVTNQ2VPqPp5FPFA62WJNUkRrgLP75omKOyaP64Wf6QhYji
         je3qLPwDa2Z4XjKck3xbCe+sbEvEhc5Kx5Y1Aw7XFFCrG2Xp/hBZw3O56fqZHfh+fw9U
         Fk7QB5Kd5Qfs9NWPXYBXJb/gBlIbcMSU8dGCCfsUgYbCHOQXLvLGNtnzP9lWMu/JrdrM
         e85A==
In-Reply-To: <20210709000509.2618345-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
functions to perform mem_cgroup_disabled static key check inline before
calling the main body of the function. This minimizes the memcg overhead
in the pagefault and exit_mmap paths when memcgs are disabled using
cgroup_disable=memory command-line option.
This change results in ~0.4% overhead reduction when running PFT test
comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
configurationon on an 8-core ARM64 Android device.

Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 54 ++++++++++++++++++++++++++++++++++----
 mm/memcontrol.c            | 43 +++---------------------------
 2 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bfe5c486f4ad..480815feb116 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -693,13 +693,59 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
 		page_counter_read(&memcg->memory);
 }
 
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
+struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
+
+int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
+			gfp_t gfp);
+/**
+ * mem_cgroup_charge - charge a newly allocated page to a cgroup
+ * @page: page to charge
+ * @mm: mm context of the victim
+ * @gfp_mask: reclaim mode
+ *
+ * Try to charge @page to the memcg that @mm belongs to, reclaiming
+ * pages according to @gfp_mask if necessary. if @mm is NULL, try to
+ * charge to the active memcg.
+ *
+ * Do not use this for pages allocated for swapin.
+ *
+ * Returns 0 on success. Otherwise, an error code is returned.
+ */
+static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
+				    gfp_t gfp_mask)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	if (mem_cgroup_disabled())
+		return 0;
+
+	memcg = get_mem_cgroup_from_mm(mm);
+	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
 int mem_cgroup_swapin_charge_page(struct page *page, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 void mem_cgroup_swapin_uncharge_swap(swp_entry_t entry);
 
-void mem_cgroup_uncharge(struct page *page);
-void mem_cgroup_uncharge_list(struct list_head *page_list);
+void __mem_cgroup_uncharge(struct page *page);
+static inline void mem_cgroup_uncharge(struct page *page)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge(page);
+}
+
+void __mem_cgroup_uncharge_list(struct list_head *page_list);
+static inline void mem_cgroup_uncharge_list(struct list_head *page_list)
+{
+	if (mem_cgroup_disabled())
+		return;
+	__mem_cgroup_uncharge_list(page_list);
+}
 
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage);
 
@@ -756,8 +802,6 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page)
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
-struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
-
 struct lruvec *lock_page_lruvec(struct page *page);
 struct lruvec *lock_page_lruvec_irq(struct page *page);
 struct lruvec *lock_page_lruvec_irqsave(struct page *page,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a228cd51c4bd..da677b55b2fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6701,8 +6701,8 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 			atomic_long_read(&parent->memory.children_low_usage)));
 }
 
-static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
-			       gfp_t gfp)
+int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
+			gfp_t gfp)
 {
 	unsigned int nr_pages = thp_nr_pages(page);
 	int ret;
@@ -6722,35 +6722,6 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
 	return ret;
 }
 
-/**
- * mem_cgroup_charge - charge a newly allocated page to a cgroup
- * @page: page to charge
- * @mm: mm context of the victim
- * @gfp_mask: reclaim mode
- *
- * Try to charge @page to the memcg that @mm belongs to, reclaiming
- * pages according to @gfp_mask if necessary. if @mm is NULL, try to
- * charge to the active memcg.
- *
- * Do not use this for pages allocated for swapin.
- *
- * Returns 0 on success. Otherwise, an error code is returned.
- */
-int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
-{
-	struct mem_cgroup *memcg;
-	int ret;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	memcg = get_mem_cgroup_from_mm(mm);
-	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
-	css_put(&memcg->css);
-
-	return ret;
-}
-
 /**
  * mem_cgroup_swapin_charge_page - charge a newly allocated page for swapin
  * @page: page to charge
@@ -6921,13 +6892,10 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
  *
  * Uncharge a page previously charged with mem_cgroup_charge().
  */
-void mem_cgroup_uncharge(struct page *page)
+void __mem_cgroup_uncharge(struct page *page)
 {
 	struct uncharge_gather ug;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	/* Don't touch page->lru of any random page, pre-check: */
 	if (!page_memcg(page))
 		return;
@@ -6944,14 +6912,11 @@ void mem_cgroup_uncharge(struct page *page)
  * Uncharge a list of pages previously charged with
  * mem_cgroup_charge().
  */
-void mem_cgroup_uncharge_list(struct list_head *page_list)
+void __mem_cgroup_uncharge_list(struct list_head *page_list)
 {
 	struct uncharge_gather ug;
 	struct page *page;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	uncharge_gather_clear(&ug);
 	list_for_each_entry(page, page_list, lru)
 		uncharge_page(page, &ug);
-- 
2.32.0.93.g670b81a890-goog

