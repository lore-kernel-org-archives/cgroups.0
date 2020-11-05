From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v21 17/19] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Thu, 5 Nov 2020 21:43:40 +0800
Message-ID: <5b085715-292a-4b43-50b3-d73dc90d1de5@linux.alibaba.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-18-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1604566549-62481-18-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>



=D4=DA 2020/11/5 =CF=C2=CE=E74:55, Alex Shi =D0=B4=B5=C0:
>  /**
> + * lock_page_lruvec - lock and return lruvec for a given page.
> + * @page: the page
> + *
> + * This series functions should be used in either conditions:
> + * PageLRU is cleared or unset
> + * or page is locked.
      or page->_refcount is zero.
Ops, here is a typo, we need to add back above line.
so the patch updated here:


From 9f187d04c7ba62bb7e07c07733b2848f155961f6 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Tue, 18 Aug 2020 16:44:21 +0800
Subject: [PATCH v21 17/19] mm/lru: replace pgdat lru_lock with lruvec lock

This patch moves per node lru_lock into lruvec, thus bring a lru_lock for
each of memcg per node. So on a large machine, each of memcg don't
have to suffer from per node pgdat->lru_lock competition. They could go
fast with their self lru_lock.

After move memcg charge before lru inserting, page isolation could
serialize page's memcg, then per memcg lruvec lock is stable and could
replace per node lru lock.

In func isolate_migratepages_block, compact_unlock_should_abort and
lock_page_lruvec_irqsave are open coded to work with compact_control.
Also add a debug func in locking which may give some clues if there are
sth out of hands.

Daniel Jordan's testing show 62% improvement on modified readtwice case
on his 2P * 10 core * 2 HT broadwell box.
https://lore.kernel.org/lkml/20200915165807.kpp7uhiw7l3loofu-S51bK0XF4qpuJJ=
ETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/

On a large machine with memcg enabled but not used, the page's lruvec
seeking pass a few pointers, that may lead to lru_lock holding time
increase and a bit regression.

Hugh Dickins helped on the patch polish, thanks!

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.g=
mane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.o=
rg>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/linux/memcontrol.h |  58 +++++++++++++++++++++++
 include/linux/mmzone.h     |   3 +-
 mm/compaction.c            |  56 ++++++++++++++--------
 mm/huge_memory.c           |  11 ++---
 mm/memcontrol.c            |  74 +++++++++++++++++++++++++++--
 mm/mlock.c                 |  22 ++++++---
 mm/mmzone.c                |   1 +
 mm/page_alloc.c            |   1 -
 mm/swap.c                  | 116 ++++++++++++++++++++++-------------------=
----
 mm/vmscan.c                |  55 ++++++++++-----------
 10 files changed, 271 insertions(+), 126 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0f4dd7829fb2..6ecb08ff4ad1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -666,6 +666,19 @@ static inline struct lruvec *mem_cgroup_lruvec(struct =
mem_cgroup *memcg,
=20
 struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
=20
+struct lruvec *lock_page_lruvec(struct page *page);
+struct lruvec *lock_page_lruvec_irq(struct page *page);
+struct lruvec *lock_page_lruvec_irqsave(struct page *page,
+						unsigned long *flags);
+
+#ifdef CONFIG_DEBUG_VM
+void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page);
+#else
+static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *=
page)
+{
+}
+#endif
+
 static inline
 struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
 	return css ? container_of(css, struct mem_cgroup, css) : NULL;
@@ -1233,6 +1246,31 @@ static inline void mem_cgroup_put(struct mem_cgroup =
*memcg)
 {
 }
=20
+static inline struct lruvec *lock_page_lruvec(struct page *page)
+{
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	spin_lock(&pgdat->__lruvec.lru_lock);
+	return &pgdat->__lruvec;
+}
+
+static inline struct lruvec *lock_page_lruvec_irq(struct page *page)
+{
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	spin_lock_irq(&pgdat->__lruvec.lru_lock);
+	return &pgdat->__lruvec;
+}
+
+static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
+		unsigned long *flagsp)
+{
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);
+	return &pgdat->__lruvec;
+}
+
 static inline struct mem_cgroup *
 mem_cgroup_iter(struct mem_cgroup *root,
 		struct mem_cgroup *prev,
@@ -1476,6 +1514,10 @@ static inline void count_memcg_page_event(struct pag=
e *page,
 void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
 {
 }
+
+static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *=
page)
+{
+}
 #endif /* CONFIG_MEMCG */
=20
 /* idx can be of type enum memcg_stat_item or node_stat_item */
@@ -1605,6 +1647,22 @@ static inline struct lruvec *parent_lruvec(struct lr=
uvec *lruvec)
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
=20
+static inline void unlock_page_lruvec(struct lruvec *lruvec)
+{
+	spin_unlock(&lruvec->lru_lock);
+}
+
+static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
+{
+	spin_unlock_irq(&lruvec->lru_lock);
+}
+
+static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
+		unsigned long flags)
+{
+	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
=20
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fb3bf696c05e..0afba4ea2a21 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -276,6 +276,8 @@ enum lruvec_flags {
=20
 struct lruvec {
 	struct list_head		lists[NR_LRU_LISTS];
+	/* per lruvec lru_lock for memcg */
+	spinlock_t			lru_lock;
 	/*
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
@@ -796,7 +798,6 @@ struct deferred_split {
=20
 	/* Write-intensive fields used by page reclaim */
 	ZONE_PADDING(_pad1_)
-	spinlock_t		lru_lock;
=20
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	/*
diff --git a/mm/compaction.c b/mm/compaction.c
index 7b1cf48884dd..9cfe90961493 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -804,7 +804,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	unsigned long nr_scanned =3D 0, nr_isolated =3D 0;
 	struct lruvec *lruvec;
 	unsigned long flags =3D 0;
-	bool locked =3D false;
+	struct lruvec *locked =3D NULL;
 	struct page *page =3D NULL, *valid_page =3D NULL;
 	unsigned long start_pfn =3D low_pfn;
 	bool skip_on_failure =3D false;
@@ -864,11 +864,20 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		 * contention, to give chance to IRQs. Abort completely if
 		 * a fatal signal is pending.
 		 */
-		if (!(low_pfn % SWAP_CLUSTER_MAX)
-		    && compact_unlock_should_abort(&pgdat->lru_lock,
-					    flags, &locked, cc)) {
-			low_pfn =3D 0;
-			goto fatal_pending;
+		if (!(low_pfn % SWAP_CLUSTER_MAX)) {
+			if (locked) {
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked =3D NULL;
+			}
+
+			if (fatal_signal_pending(current)) {
+				cc->contended =3D true;
+
+				low_pfn =3D 0;
+				goto fatal_pending;
+			}
+
+			cond_resched();
 		}
=20
 		if (!pfn_valid_within(low_pfn))
@@ -940,9 +949,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
 				if (locked) {
-					spin_unlock_irqrestore(&pgdat->lru_lock,
-									flags);
-					locked =3D false;
+					unlock_page_lruvec_irqrestore(locked, flags);
+					locked =3D NULL;
 				}
=20
 				if (!isolate_movable_page(page, isolate_mode))
@@ -983,10 +991,19 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
=20
+		rcu_read_lock();
+		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+
 		/* If we already hold the lock, we can skip some rechecking */
-		if (!locked) {
-			locked =3D compact_lock_irqsave(&pgdat->lru_lock,
-								&flags, cc);
+		if (lruvec !=3D locked) {
+			if (locked)
+				unlock_page_lruvec_irqrestore(locked, flags);
+
+			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
+			locked =3D lruvec;
+			rcu_read_unlock();
+
+			lruvec_memcg_debug(lruvec, page);
=20
 			/* Try get exclusive access under lock */
 			if (!skip_updated) {
@@ -1005,9 +1022,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
-		}
-
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		} else
+			rcu_read_unlock();
=20
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
@@ -1041,8 +1057,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
 		if (locked) {
-			spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-			locked =3D false;
+			unlock_page_lruvec_irqrestore(locked, flags);
+			locked =3D NULL;
 		}
 		put_page(page);
=20
@@ -1057,8 +1073,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		 */
 		if (nr_isolated) {
 			if (locked) {
-				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-				locked =3D false;
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked =3D NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages =3D 0;
@@ -1086,7 +1102,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
=20
 isolate_abort:
 	if (locked)
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+		unlock_page_lruvec_irqrestore(locked, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b70ec0c6076b..94e42dba052a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2354,7 +2354,7 @@ static void lru_add_page_tail(struct page *head, stru=
ct page *tail,
 	VM_BUG_ON_PAGE(!PageHead(head), head);
 	VM_BUG_ON_PAGE(PageCompound(tail), head);
 	VM_BUG_ON_PAGE(PageLRU(tail), head);
-	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
+	lockdep_assert_held(&lruvec->lru_lock);
=20
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
@@ -2438,7 +2438,6 @@ static void __split_huge_page(struct page *page, stru=
ct list_head *list,
 		pgoff_t end)
 {
 	struct page *head =3D compound_head(page);
-	pg_data_t *pgdat =3D page_pgdat(head);
 	struct lruvec *lruvec;
 	struct address_space *swap_cache =3D NULL;
 	unsigned long offset =3D 0;
@@ -2456,10 +2455,8 @@ static void __split_huge_page(struct page *page, str=
uct list_head *list,
 		xa_lock(&swap_cache->i_pages);
 	}
=20
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock(&pgdat->lru_lock);
-
-	lruvec =3D mem_cgroup_page_lruvec(head, pgdat);
+	/* lock lru list/PageCompound, ref freezed by page_ref_freeze */
+	lruvec =3D lock_page_lruvec(head);
=20
 	for (i =3D nr - 1; i >=3D 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
@@ -2480,7 +2477,7 @@ static void __split_huge_page(struct page *page, stru=
ct list_head *list,
 	}
=20
 	ClearPageCompound(head);
-	spin_unlock(&pgdat->lru_lock);
+	unlock_page_lruvec(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
=20
 	split_page_owner(head, nr);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 157b745031a4..591f9f9ca8b2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -20,6 +20,9 @@
  * Lockless page tracking & accounting
  * Unified hierarchy configuration model
  * Copyright (C) 2015 Red Hat, Inc., Johannes Weiner
+ *
+ * Per memcg lru locking
+ * Copyright (C) 2020 Alibaba, Inc, Alex Shi
  */
=20
 #include <linux/page_counter.h>
@@ -1305,6 +1308,19 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 	return ret;
 }
=20
+#ifdef CONFIG_DEBUG_VM
+void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!page->mem_cgroup)
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D root_mem_cgroup, page);
+	else
+		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) !=3D page->mem_cgroup, page);
+}
+#endif
+
 /**
  * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
  * @page: the page
@@ -1343,6 +1359,60 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *p=
age, struct pglist_data *pgd
 }
=20
 /**
+ * lock_page_lruvec - lock and return lruvec for a given page.
+ * @page: the page
+ *
+ * This series functions should be used in either conditions:
+ * PageLRU is cleared or unset
+ * or page->_refcount is zero
+ * or page is locked.
+ */
+struct lruvec *lock_page_lruvec(struct page *page)
+{
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	rcu_read_lock();
+	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock(&lruvec->lru_lock);
+	rcu_read_unlock();
+
+	lruvec_memcg_debug(lruvec, page);
+
+	return lruvec;
+}
+
+struct lruvec *lock_page_lruvec_irq(struct page *page)
+{
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	rcu_read_lock();
+	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock_irq(&lruvec->lru_lock);
+	rcu_read_unlock();
+
+	lruvec_memcg_debug(lruvec, page);
+
+	return lruvec;
+}
+
+struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *=
flags)
+{
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat =3D page_pgdat(page);
+
+	rcu_read_lock();
+	lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock_irqsave(&lruvec->lru_lock, *flags);
+	rcu_read_unlock();
+
+	lruvec_memcg_debug(lruvec, page);
+
+	return lruvec;
+}
+
+/**
  * mem_cgroup_update_lru_size - account for adding or removing an lru page
  * @lruvec: mem_cgroup per zone lru vector
  * @lru: index of lru list the page is sitting on
@@ -3245,10 +3315,8 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, s=
ize_t size)
 #endif /* CONFIG_MEMCG_KMEM */
=20
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
 /*
- * Because tail pages are not marked as "used", set it. We're under
- * pgdat->lru_lock and migration entries setup in all page mappings.
+ * Because page->mem_cgroup is not set on compound tails, set it now.
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
diff --git a/mm/mlock.c b/mm/mlock.c
index 7b0e6334be6f..ab164a675c25 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -262,12 +262,12 @@ static void __munlock_pagevec(struct pagevec *pvec, s=
truct zone *zone)
 	int nr =3D pagevec_count(pvec);
 	int delta_munlocked =3D -nr;
 	struct pagevec pvec_putback;
+	struct lruvec *lruvec =3D NULL;
 	int pgrescued =3D 0;
=20
 	pagevec_init(&pvec_putback);
=20
 	/* Phase 1: page isolation */
-	spin_lock_irq(&zone->zone_pgdat->lru_lock);
 	for (i =3D 0; i < nr; i++) {
 		struct page *page =3D pvec->pages[i];
=20
@@ -277,10 +277,16 @@ static void __munlock_pagevec(struct pagevec *pvec, s=
truct zone *zone)
 			 * so we can spare the get_page() here.
 			 */
 			if (TestClearPageLRU(page)) {
-				struct lruvec *lruvec;
+				struct lruvec *new_lruvec;
+
+				new_lruvec =3D mem_cgroup_page_lruvec(page,
+						page_pgdat(page));
+				if (new_lruvec !=3D lruvec) {
+					if (lruvec)
+						unlock_page_lruvec_irq(lruvec);
+					lruvec =3D lock_page_lruvec_irq(page);
+				}
=20
-				lruvec =3D mem_cgroup_page_lruvec(page,
-							page_pgdat(page));
 				del_page_from_lru_list(page, lruvec,
 							page_lru(page));
 				continue;
@@ -299,8 +305,12 @@ static void __munlock_pagevec(struct pagevec *pvec, st=
ruct zone *zone)
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] =3D NULL;
 	}
-	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
-	spin_unlock_irq(&zone->zone_pgdat->lru_lock);
+	if (lruvec) {
+		__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
+		unlock_page_lruvec_irq(lruvec);
+	} else if (delta_munlocked) {
+		mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
+	}
=20
 	/* Now we can release pins of pages that we are not munlocking */
 	pagevec_release(&pvec_putback);
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 4686fdc23bb9..3750a90ed4a0 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -91,6 +91,7 @@ void lruvec_init(struct lruvec *lruvec)
 	enum lru_list lru;
=20
 	memset(lruvec, 0, sizeof(struct lruvec));
+	spin_lock_init(&lruvec->lru_lock);
=20
 	for_each_lru(lru)
 		INIT_LIST_HEAD(&lruvec->lists[lru]);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d77220615fd5..74bf7f4c6317 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6808,7 +6808,6 @@ static void __meminit pgdat_init_internals(struct pgl=
ist_data *pgdat)
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
=20
 	pgdat_page_ext_init(pgdat);
-	spin_lock_init(&pgdat->lru_lock);
 	lruvec_init(&pgdat->__lruvec);
 }
=20
diff --git a/mm/swap.c b/mm/swap.c
index 1838a9535703..ed033f7c4f2d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -79,16 +79,14 @@ static DEFINE_PER_CPU(struct lru_pvecs, lru_pvecs) =3D {
 static void __page_cache_release(struct page *page)
 {
 	if (PageLRU(page)) {
-		pg_data_t *pgdat =3D page_pgdat(page);
 		struct lruvec *lruvec;
 		unsigned long flags;
=20
-		spin_lock_irqsave(&pgdat->lru_lock, flags);
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		lruvec =3D lock_page_lruvec_irqsave(page, &flags);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	}
 	__ClearPageWaiters(page);
 }
@@ -207,32 +205,30 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 	void (*move_fn)(struct page *page, struct lruvec *lruvec))
 {
 	int i;
-	struct pglist_data *pgdat =3D NULL;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec =3D NULL;
 	unsigned long flags =3D 0;
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct pglist_data *pagepgdat =3D page_pgdat(page);
-
-		if (pagepgdat !=3D pgdat) {
-			if (pgdat)
-				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-			pgdat =3D pagepgdat;
-			spin_lock_irqsave(&pgdat->lru_lock, flags);
-		}
+		struct lruvec *new_lruvec;
=20
 		/* block memcg migration during page moving between lru */
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
+		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
+		if (lruvec !=3D new_lruvec) {
+			if (lruvec)
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
+		}
+
 		(*move_fn)(page, lruvec);
=20
 		SetPageLRU(page);
 	}
-	if (pgdat)
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
@@ -274,9 +270,15 @@ void lru_note_cost(struct lruvec *lruvec, bool file, u=
nsigned int nr_pages)
 {
 	do {
 		unsigned long lrusize;
-		struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
=20
-		spin_lock_irq(&pgdat->lru_lock);
+		/*
+		 * Hold lruvec->lru_lock is safe here, since
+		 * 1) The pinned lruvec in reclaim, or
+		 * 2) From a pre-LRU page during refault (which also holds the
+		 *    rcu lock, so would be safe even if the page was on the LRU
+		 *    and could move simultaneously to a new lruvec).
+		 */
+		spin_lock_irq(&lruvec->lru_lock);
 		/* Record cost event */
 		if (file)
 			lruvec->file_cost +=3D nr_pages;
@@ -300,7 +302,7 @@ void lru_note_cost(struct lruvec *lruvec, bool file, un=
signed int nr_pages)
 			lruvec->file_cost /=3D 2;
 			lruvec->anon_cost /=3D 2;
 		}
-		spin_unlock_irq(&pgdat->lru_lock);
+		spin_unlock_irq(&lruvec->lru_lock);
 	} while ((lruvec =3D parent_lruvec(lruvec)));
 }
=20
@@ -364,13 +366,15 @@ static inline void activate_page_drain(int cpu)
=20
 static void activate_page(struct page *page)
 {
-	pg_data_t *pgdat =3D page_pgdat(page);
+	struct lruvec *lruvec;
=20
 	page =3D compound_head(page);
-	spin_lock_irq(&pgdat->lru_lock);
-	if (PageLRU(page))
-		__activate_page(page, mem_cgroup_page_lruvec(page, pgdat));
-	spin_unlock_irq(&pgdat->lru_lock);
+	if (TestClearPageLRU(page)) {
+		lruvec =3D lock_page_lruvec_irq(page);
+		__activate_page(page, lruvec);
+		unlock_page_lruvec_irq(lruvec);
+		SetPageLRU(page);
+	}
 }
 #endif
=20
@@ -860,8 +864,7 @@ void release_pages(struct page **pages, int nr)
 {
 	int i;
 	LIST_HEAD(pages_to_free);
-	struct pglist_data *locked_pgdat =3D NULL;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec =3D NULL;
 	unsigned long flags;
 	unsigned int lock_batch;
=20
@@ -871,11 +874,11 @@ void release_pages(struct page **pages, int nr)
 		/*
 		 * Make sure the IRQ-safe lock-holding time does not get
 		 * excessive with a continuous string of pages from the
-		 * same pgdat. The lock is held only if pgdat !=3D NULL.
+		 * same lruvec. The lock is held only if lruvec !=3D NULL.
 		 */
-		if (locked_pgdat && ++lock_batch =3D=3D SWAP_CLUSTER_MAX) {
-			spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
-			locked_pgdat =3D NULL;
+		if (lruvec && ++lock_batch =3D=3D SWAP_CLUSTER_MAX) {
+			unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec =3D NULL;
 		}
=20
 		page =3D compound_head(page);
@@ -883,10 +886,9 @@ void release_pages(struct page **pages, int nr)
 			continue;
=20
 		if (is_zone_device_page(page)) {
-			if (locked_pgdat) {
-				spin_unlock_irqrestore(&locked_pgdat->lru_lock,
-						       flags);
-				locked_pgdat =3D NULL;
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec =3D NULL;
 			}
 			/*
 			 * ZONE_DEVICE pages that return 'false' from
@@ -907,27 +909,27 @@ void release_pages(struct page **pages, int nr)
 			continue;
=20
 		if (PageCompound(page)) {
-			if (locked_pgdat) {
-				spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
-				locked_pgdat =3D NULL;
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec =3D NULL;
 			}
 			__put_compound_page(page);
 			continue;
 		}
=20
 		if (PageLRU(page)) {
-			struct pglist_data *pgdat =3D page_pgdat(page);
+			struct lruvec *new_lruvec;
=20
-			if (pgdat !=3D locked_pgdat) {
-				if (locked_pgdat)
-					spin_unlock_irqrestore(&locked_pgdat->lru_lock,
+			new_lruvec =3D mem_cgroup_page_lruvec(page,
+							page_pgdat(page));
+			if (new_lruvec !=3D lruvec) {
+				if (lruvec)
+					unlock_page_lruvec_irqrestore(lruvec,
 									flags);
 				lock_batch =3D 0;
-				locked_pgdat =3D pgdat;
-				spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
+				lruvec =3D lock_page_lruvec_irqsave(page, &flags);
 			}
=20
-			lruvec =3D mem_cgroup_page_lruvec(page, locked_pgdat);
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
@@ -937,8 +939,8 @@ void release_pages(struct page **pages, int nr)
=20
 		list_add(&page->lru, &pages_to_free);
 	}
-	if (locked_pgdat)
-		spin_unlock_irqrestore(&locked_pgdat->lru_lock, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
=20
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_unref_page_list(&pages_to_free);
@@ -1026,26 +1028,24 @@ static void __pagevec_lru_add_fn(struct page *page,=
 struct lruvec *lruvec)
 void __pagevec_lru_add(struct pagevec *pvec)
 {
 	int i;
-	struct pglist_data *pgdat =3D NULL;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec =3D NULL;
 	unsigned long flags =3D 0;
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct pglist_data *pagepgdat =3D page_pgdat(page);
+		struct lruvec *new_lruvec;
=20
-		if (pagepgdat !=3D pgdat) {
-			if (pgdat)
-				spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-			pgdat =3D pagepgdat;
-			spin_lock_irqsave(&pgdat->lru_lock, flags);
+		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
+		if (lruvec !=3D new_lruvec) {
+			if (lruvec)
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
 		}
=20
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
 		__pagevec_lru_add_fn(page, lruvec);
 	}
-	if (pgdat)
-		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0be55d875fde..2953ddec88a0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1765,14 +1765,12 @@ int isolate_lru_page(struct page *page)
 	WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
=20
 	if (TestClearPageLRU(page)) {
-		pg_data_t *pgdat =3D page_pgdat(page);
 		struct lruvec *lruvec;
=20
 		get_page(page);
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
-		spin_lock_irq(&pgdat->lru_lock);
+		lruvec =3D lock_page_lruvec_irq(page);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
-		spin_unlock_irq(&pgdat->lru_lock);
+		unlock_page_lruvec_irq(lruvec);
 		ret =3D 0;
 	}
=20
@@ -1839,7 +1837,6 @@ static int too_many_isolated(struct pglist_data *pgda=
t, int file,
 static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 						     struct list_head *list)
 {
-	struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
 	int nr_pages, nr_moved =3D 0;
 	LIST_HEAD(pages_to_free);
 	struct page *page;
@@ -1850,9 +1847,9 @@ static unsigned noinline_for_stack move_pages_to_lru(=
struct lruvec *lruvec,
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			spin_unlock_irq(&pgdat->lru_lock);
+			spin_unlock_irq(&lruvec->lru_lock);
 			putback_lru_page(page);
-			spin_lock_irq(&pgdat->lru_lock);
+			spin_lock_irq(&lruvec->lru_lock);
 			continue;
 		}
=20
@@ -1874,9 +1871,9 @@ static unsigned noinline_for_stack move_pages_to_lru(=
struct lruvec *lruvec,
 			__ClearPageActive(page);
=20
 			if (unlikely(PageCompound(page))) {
-				spin_unlock_irq(&pgdat->lru_lock);
+				spin_unlock_irq(&lruvec->lru_lock);
 				destroy_compound_page(page);
-				spin_lock_irq(&pgdat->lru_lock);
+				spin_lock_irq(&lruvec->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
=20
@@ -1953,7 +1950,7 @@ static int current_may_throttle(void)
=20
 	lru_add_drain();
=20
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
=20
 	nr_taken =3D isolate_lru_pages(nr_to_scan, lruvec, &page_list,
 				     &nr_scanned, sc, lru);
@@ -1965,7 +1962,7 @@ static int current_may_throttle(void)
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
 	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
=20
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	if (nr_taken =3D=3D 0)
 		return 0;
@@ -1973,7 +1970,7 @@ static int current_may_throttle(void)
 	nr_reclaimed =3D shrink_page_list(&page_list, pgdat, sc, 0,
 				&stat, false);
=20
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
 	move_pages_to_lru(lruvec, &page_list);
=20
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
@@ -1982,7 +1979,7 @@ static int current_may_throttle(void)
 		__count_vm_events(item, nr_reclaimed);
 	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
 	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	lru_note_cost(lruvec, file, stat.nr_pageout);
 	mem_cgroup_uncharge_list(&page_list);
@@ -2035,7 +2032,7 @@ static void shrink_active_list(unsigned long nr_to_sc=
an,
=20
 	lru_add_drain();
=20
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
=20
 	nr_taken =3D isolate_lru_pages(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, lru);
@@ -2046,7 +2043,7 @@ static void shrink_active_list(unsigned long nr_to_sc=
an,
 		__count_vm_events(PGREFILL, nr_scanned);
 	__count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
=20
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	while (!list_empty(&l_hold)) {
 		cond_resched();
@@ -2092,7 +2089,7 @@ static void shrink_active_list(unsigned long nr_to_sc=
an,
 	/*
 	 * Move pages back to the lru list.
 	 */
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
=20
 	nr_activate =3D move_pages_to_lru(lruvec, &l_active);
 	nr_deactivate =3D move_pages_to_lru(lruvec, &l_inactive);
@@ -2103,7 +2100,7 @@ static void shrink_active_list(unsigned long nr_to_sc=
an,
 	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
=20
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
=20
 	mem_cgroup_uncharge_list(&l_active);
 	free_unref_page_list(&l_active);
@@ -2693,10 +2690,10 @@ static void shrink_node(pg_data_t *pgdat, struct sc=
an_control *sc)
 	/*
 	 * Determine the scan balance between anon and file LRUs.
 	 */
-	spin_lock_irq(&pgdat->lru_lock);
+	spin_lock_irq(&target_lruvec->lru_lock);
 	sc->anon_cost =3D target_lruvec->anon_cost;
 	sc->file_cost =3D target_lruvec->file_cost;
-	spin_unlock_irq(&pgdat->lru_lock);
+	spin_unlock_irq(&target_lruvec->lru_lock);
=20
 	/*
 	 * Target desirable inactive:active list ratios for the anon
@@ -4272,16 +4269,15 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t g=
fp_mask, unsigned int order)
  */
 void check_move_unevictable_pages(struct pagevec *pvec)
 {
-	struct lruvec *lruvec;
-	struct pglist_data *pgdat =3D NULL;
+	struct lruvec *lruvec =3D NULL;
 	int pgscanned =3D 0;
 	int pgrescued =3D 0;
 	int i;
=20
 	for (i =3D 0; i < pvec->nr; i++) {
 		struct page *page =3D pvec->pages[i];
-		struct pglist_data *pagepgdat =3D page_pgdat(page);
 		int nr_pages;
+		struct lruvec *new_lruvec;
=20
 		if (PageTransTail(page))
 			continue;
@@ -4293,13 +4289,12 @@ void check_move_unevictable_pages(struct pagevec *p=
vec)
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		if (pagepgdat !=3D pgdat) {
-			if (pgdat)
-				spin_unlock_irq(&pgdat->lru_lock);
-			pgdat =3D pagepgdat;
-			spin_lock_irq(&pgdat->lru_lock);
+		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
+		if (lruvec !=3D new_lruvec) {
+			if (lruvec)
+				unlock_page_lruvec_irq(lruvec);
+			lruvec =3D lock_page_lruvec_irq(page);
 		}
-		lruvec =3D mem_cgroup_page_lruvec(page, pgdat);
=20
 		if (page_evictable(page) && PageUnevictable(page)) {
 			enum lru_list lru =3D page_lru_base_type(page);
@@ -4313,10 +4308,10 @@ void check_move_unevictable_pages(struct pagevec *p=
vec)
 		SetPageLRU(page);
 	}
=20
-	if (pgdat) {
+	if (lruvec) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		spin_unlock_irq(&pgdat->lru_lock);
+		unlock_page_lruvec_irq(lruvec);
 	} else if (pgscanned) {
 		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
--=20
1.8.3.1

