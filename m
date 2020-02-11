From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 3/9] hugetlb_cgroup: add reservation accounting for
 private mappings
Date: Tue, 11 Feb 2020 13:31:22 -0800
Message-ID: <20200211213128.73302-3-almasrymina@google.com>
References: <20200211213128.73302-1-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kGkCsRCXCke3LD6wVlrVVYkJSRxB78g6/0L4LHQ32rE=;
        b=mUJSPgUAtI2pZ72EeYVZn1R9j3GF6Zp3ABkPoxmE5SW8nmYAfuNM9HBfLaRsfrKleC
         okdLIMyHTLehZJ9z4e3W/9dUwlqAZ9m0JEhNOQgVt2aHlHKYBlHCDNtdQEbUa+LQKF4c
         Bl96ZkdGFO1J87Vog3yEk7yVD3XvJH8ps3s30fsp54WV2epHKqfw44CbWhKIin3VU0N/
         XsfXcNEIO7I4P67FLES9WXIiTGkJwFVSDIuOi1QyKdro6UZ+aghERNJ08w5oW0BYeTEL
         dfXfl9Qv0zg+CopSbbL8HDU8ZgtCGl9uvvLAG/B4wLiYuqTTahX1W5AATD2zGj9r0JrJ
         Q2xQ==
In-Reply-To: <20200211213128.73302-1-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Normally the pointer to the cgroup to uncharge hangs off the struct
page, and gets queried when it's time to free the page. With
hugetlb_cgroup reservations, this is not possible. Because it's possible
for a page to be reserved by one task and actually faulted in by another
task.

The best place to put the hugetlb_cgroup pointer to uncharge for
reservations is in the resv_map. But, because the resv_map has different
semantics for private and shared mappings, the code patch to
charge/uncharge shared and private mappings is different. This patch
implements charging and uncharging for private mappings.

For private mappings, the counter to uncharge is in
resv_map->reservation_counter. On initializing the resv_map this is set
to NULL. On reservation of a region in private mapping, the tasks
hugetlb_cgroup is charged and the hugetlb_cgroup is placed is
resv_map->reservation_counter.

On hugetlb_vm_op_close, we uncharge resv_map->reservation_counter.

Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

---

Changes in v12:
- Very minor interface update for readability.

Changes in v11:
- Refactored hugetlb_cgroup_uncharge_conuter a bit to eliminate
unnecessary #ifdefs.
- Added resv_map_set_hugetlb_cgroup_uncharge_info() to eliminate #ifdefs
in the middle of hugetlb logic.

Changes in v10:
- Fixed cases where the mapping is private but cgroup accounting is disabled.

Changes in V9:
- Updated for reparenting of hugetlb reservation accounting.

---
 include/linux/hugetlb.h        | 10 ++++++++
 include/linux/hugetlb_cgroup.h | 39 +++++++++++++++++++++++++---
 mm/hugetlb.c                   | 47 +++++++++++++++++++++++++++++++---
 mm/hugetlb_cgroup.c            | 41 +++++------------------------
 4 files changed, 97 insertions(+), 40 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index dea6143aa0685..5491932ea5758 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -46,6 +46,16 @@ struct resv_map {
 	long adds_in_progress;
 	struct list_head region_cache;
 	long region_cache_count;
+#ifdef CONFIG_CGROUP_HUGETLB
+	/*
+	 * On private mappings, the counter to uncharge reservations is stored
+	 * here. If these fields are 0, then either the mapping is shared, or
+	 * cgroup accounting is disabled for this resv_map.
+	 */
+	struct page_counter *reservation_counter;
+	unsigned long pages_per_hpage;
+	struct cgroup_subsys_state *css;
+#endif
 };
 extern struct resv_map *resv_map_alloc(void);
 void resv_map_release(struct kref *ref);
diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
index 5443f4548d523..9974817eb995f 100644
--- a/include/linux/hugetlb_cgroup.h
+++ b/include/linux/hugetlb_cgroup.h
@@ -27,6 +27,33 @@ struct hugetlb_cgroup;
 #define HUGETLB_CGROUP_MIN_ORDER	2

 #ifdef CONFIG_CGROUP_HUGETLB
+enum hugetlb_memory_event {
+	HUGETLB_MAX,
+	HUGETLB_NR_MEMORY_EVENTS,
+};
+
+struct hugetlb_cgroup {
+	struct cgroup_subsys_state css;
+
+	/*
+	 * the counter to account for hugepages from hugetlb.
+	 */
+	struct page_counter hugepage[HUGE_MAX_HSTATE];
+
+	/*
+	 * the counter to account for hugepage reservations from hugetlb.
+	 */
+	struct page_counter rsvd_hugepage[HUGE_MAX_HSTATE];
+
+	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
+	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
+
+	/* Handle for "hugetlb.events" */
+	struct cgroup_file events_file[HUGE_MAX_HSTATE];
+
+	/* Handle for "hugetlb.events.local" */
+	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
+};

 static inline struct hugetlb_cgroup *
 __hugetlb_cgroup_from_page(struct page *page, bool rsvd)
@@ -102,9 +129,9 @@ extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
 					   struct hugetlb_cgroup *h_cg);
 extern void hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
 						struct hugetlb_cgroup *h_cg);
-extern void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
-					    unsigned long nr_pages,
-					    struct cgroup_subsys_state *css);
+extern void hugetlb_cgroup_uncharge_counter(struct resv_map *resv,
+					    unsigned long start,
+					    unsigned long end);

 extern void hugetlb_cgroup_file_init(void) __init;
 extern void hugetlb_cgroup_migrate(struct page *oldhpage,
@@ -193,6 +220,12 @@ hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
 {
 }

+static inline void hugetlb_cgroup_uncharge_counter(struct resv_map *resv,
+						   unsigned long start,
+						   unsigned long end)
+{
+}
+
 static inline void hugetlb_cgroup_file_init(void)
 {
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 357817e33fb34..ac7bab0afafe7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -650,6 +650,25 @@ static void set_vma_private_data(struct vm_area_struct *vma,
 	vma->vm_private_data = (void *)value;
 }

+static void
+resv_map_set_hugetlb_cgroup_uncharge_info(struct resv_map *resv_map,
+					  struct hugetlb_cgroup *h_cg,
+					  struct hstate *h)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	if (!h_cg || !h) {
+		resv_map->reservation_counter = NULL;
+		resv_map->pages_per_hpage = 0;
+		resv_map->css = NULL;
+	} else {
+		resv_map->reservation_counter =
+			&h_cg->rsvd_hugepage[hstate_index(h)];
+		resv_map->pages_per_hpage = pages_per_huge_page(h);
+		resv_map->css = &h_cg->css;
+	}
+#endif
+}
+
 struct resv_map *resv_map_alloc(void)
 {
 	struct resv_map *resv_map = kmalloc(sizeof(*resv_map), GFP_KERNEL);
@@ -666,6 +685,13 @@ struct resv_map *resv_map_alloc(void)
 	INIT_LIST_HEAD(&resv_map->regions);

 	resv_map->adds_in_progress = 0;
+	/*
+	 * Initialize these to 0. On shared mappings, 0's here indicate these
+	 * fields don't do cgroup accounting. On private mappings, these will be
+	 * re-initialized to the proper values, to indicate that hugetlb cgroup
+	 * reservations are to be un-charged from here.
+	 */
+	resv_map_set_hugetlb_cgroup_uncharge_info(resv_map, NULL, NULL);

 	INIT_LIST_HEAD(&resv_map->region_cache);
 	list_add(&rg->link, &resv_map->region_cache);
@@ -3190,9 +3216,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 	end = vma_hugecache_offset(h, vma, vma->vm_end);

 	reserve = (end - start) - region_count(resv, start, end);
-
-	kref_put(&resv->refs, resv_map_release);
-
+	hugetlb_cgroup_uncharge_counter(resv, start, end);
 	if (reserve) {
 		/*
 		 * Decrement reserve counts.  The global reserve count may be
@@ -3201,6 +3225,8 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 		gbl_reserve = hugepage_subpool_put_pages(spool, reserve);
 		hugetlb_acct_memory(h, -gbl_reserve);
 	}
+
+	kref_put(&resv->refs, resv_map_release);
 }

 static int hugetlb_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
@@ -4547,6 +4573,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	struct hstate *h = hstate_inode(inode);
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	struct resv_map *resv_map;
+	struct hugetlb_cgroup *h_cg;
 	long gbl_reserve;

 	/* This should never happen */
@@ -4580,12 +4607,26 @@ int hugetlb_reserve_pages(struct inode *inode,
 		chg = region_chg(resv_map, from, to);

 	} else {
+		/* Private mapping. */
 		resv_map = resv_map_alloc();
 		if (!resv_map)
 			return -ENOMEM;

 		chg = to - from;

+		if (hugetlb_cgroup_charge_cgroup_rsvd(
+			    hstate_index(h), chg * pages_per_huge_page(h),
+			    &h_cg)) {
+			kref_put(&resv_map->refs, resv_map_release);
+			return -ENOMEM;
+		}
+
+		/*
+		 * Since this branch handles private mappings, we attach the
+		 * counter to uncharge for this reservation off resv_map.
+		 */
+		resv_map_set_hugetlb_cgroup_uncharge_info(resv_map, h_cg, h);
+
 		set_vma_resv_map(vma, resv_map);
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index b8246389fb153..bae7bf6b8372f 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -23,34 +23,6 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>

-enum hugetlb_memory_event {
-	HUGETLB_MAX,
-	HUGETLB_NR_MEMORY_EVENTS,
-};
-
-struct hugetlb_cgroup {
-	struct cgroup_subsys_state css;
-
-	/*
-	 * the counter to account for hugepages from hugetlb.
-	 */
-	struct page_counter hugepage[HUGE_MAX_HSTATE];
-
-	/*
-	 * the counter to account for hugepage reservations from hugetlb.
-	 */
-	struct page_counter rsvd_hugepage[HUGE_MAX_HSTATE];
-
-	atomic_long_t events[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
-	atomic_long_t events_local[HUGE_MAX_HSTATE][HUGETLB_NR_MEMORY_EVENTS];
-
-	/* Handle for "hugetlb.events" */
-	struct cgroup_file events_file[HUGE_MAX_HSTATE];
-
-	/* Handle for "hugetlb.events.local" */
-	struct cgroup_file events_local_file[HUGE_MAX_HSTATE];
-};
-
 #define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
 #define MEMFILE_IDX(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
@@ -408,15 +380,16 @@ void hugetlb_cgroup_uncharge_cgroup_rsvd(int idx, unsigned long nr_pages,
 	__hugetlb_cgroup_uncharge_cgroup(idx, nr_pages, h_cg, true);
 }

-void hugetlb_cgroup_uncharge_counter(struct page_counter *p,
-				     unsigned long nr_pages,
-				     struct cgroup_subsys_state *css)
+void hugetlb_cgroup_uncharge_counter(struct resv_map *resv, unsigned long start,
+				     unsigned long end)
 {
-	if (hugetlb_cgroup_disabled() || !p || !css)
+	if (hugetlb_cgroup_disabled() || !resv || !resv->reservation_counter ||
+	    !resv->css)
 		return;

-	page_counter_uncharge(p, nr_pages);
-	css_put(css);
+	page_counter_uncharge(resv->reservation_counter,
+			      (end - start) * resv->pages_per_hpage);
+	css_put(resv->css);
 }

 enum {
