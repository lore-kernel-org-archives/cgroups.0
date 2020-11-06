From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v21 18/19] mm/lru: introduce the relock_page_lruvec
 function
Date: Fri, 6 Nov 2020 15:50:22 +0800
Message-ID: <66d8e79d-7ec6-bfbc-1c82-bf32db3ae5b7@linux.alibaba.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-19-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1604566549-62481-19-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>



=D4=DA 2020/11/5 =CF=C2=CE=E74:55, Alex Shi =D0=B4=B5=C0:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>


update the patch on page_memcg() change:


From 6c142eb582e7d0dbf473572ad092eca07ab75221 Mon Sep 17 00:00:00 2001
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 26 May 2020 17:31:15 +0800
Subject: [PATCH v21 18/19] mm/lru: introduce the relock_page_lruvec function

Use this new function to replace repeated same code, no func change.

When testing for relock we can avoid the need for RCU locking if we simply
compare the page pgdat and memcg pointers versus those that the lruvec is
holding. By doing this we can avoid the extra pointer walks and accesses of
the memory cgroup.

In addition we can avoid the checks entirely if lruvec is currently NULL.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 include/linux/memcontrol.h | 52 ++++++++++++++++++++++++++++++++++++++++++=
++++
 mm/mlock.c                 | 11 +---------
 mm/swap.c                  | 33 +++++++----------------------
 mm/vmscan.c                | 12 ++---------
 4 files changed, 62 insertions(+), 46 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 6ecb08ff4ad1..8c57d6335ee4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -660,6 +660,22 @@ static inline struct lruvec *mem_cgroup_lruvec(struct =
mem_cgroup *memcg,
=20
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
=20
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+	pg_data_t *pgdat =3D page_pgdat(page);
+	const struct mem_cgroup *memcg;
+	struct mem_cgroup_per_node *mz;
+
+	if (mem_cgroup_disabled())
+		return lruvec =3D=3D &pgdat->__lruvec;
+
+	mz =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+	memcg =3D page_memcg(page) ? : root_mem_cgroup;
+
+	return lruvec->pgdat =3D=3D pgdat && mz->memcg =3D=3D memcg;
+}
+
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
=20
 struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
@@ -1221,6 +1237,14 @@ static inline struct lruvec *mem_cgroup_page_lruvec(=
struct page *page,
 	return &pgdat->__lruvec;
 }
=20
+static inline bool lruvec_holds_page_lru_lock(struct page *page,
+					      struct lruvec *lruvec)
+{
+	pg_data_t *pgdat =3D page_pgdat(page);
+
+	return lruvec =3D=3D &pgdat->__lruvec;
+}
+
 static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memc=
g)
 {
 	return NULL;
@@ -1663,6 +1687,34 @@ static inline void unlock_page_lruvec_irqrestore(str=
uct lruvec *lruvec,
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 }
=20
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
+		struct lruvec *locked_lruvec)
+{
+	if (locked_lruvec) {
+		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+			return locked_lruvec;
+
+		unlock_page_lruvec_irq(locked_lruvec);
+	}
+
+	return lock_page_lruvec_irq(page);
+}
+
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
+		struct lruvec *locked_lruvec, unsigned long *flags)
+{
+	if (locked_lruvec) {
+		if (lruvec_holds_page_lru_lock(page, locked_lruvec))
+			return locked_lruvec;
+
+		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+	}
+
+	return lock_page_lruvec_irqsave(page, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
=20
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
diff --git a/mm/mlock.c b/mm/mlock.c
index ab164a675c25..55b3b3672977 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -277,16 +277,7 @@ static void __munlock_pagevec(struct pagevec *pvec, st=
ruct zone *zone)
 			 * so we can spare the get_page() here.
 			 */
 			if (TestClearPageLRU(page)) {
-				struct lruvec *new_lruvec;
-
-				new_lruvec =3D mem_cgroup_page_lruvec(page,
-						page_pgdat(page));
-				if (new_lruvec !=3D lruvec) {
-					if (lruvec)
-						unlock_page_lruvec_irq(lruvec);
-					lruvec =3D lock_page_lruvec_irq(page);
-				}
-
+				lruvec =3D relock_page_lruvec_irq(page, lruvec);
 				del_page_from_lru_list(page, lruvec,
 							page_lru(page));
 				continue;
diff --git a/mm/swap.c b/mm/swap.c
index ed033f7c4f2d..c593ba596dea 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -210,19 +210,12 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct lruvec *new_lruvec;
=20
 		/* block memcg migration during page moving between lru */
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec !=3D new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irqrestore(lruvec, flags);
-			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
-		}
-
+		lruvec =3D relock_page_lruvec_irqsave(page, lruvec, &flags);
 		(*move_fn)(page, lruvec);
=20
 		SetPageLRU(page);
@@ -918,17 +911,12 @@ void release_pages(struct page **pages, int nr)
 		}
=20
 		if (PageLRU(page)) {
-			struct lruvec *new_lruvec;
-
-			new_lruvec =3D mem_cgroup_page_lruvec(page,
-							page_pgdat(page));
-			if (new_lruvec !=3D lruvec) {
-				if (lruvec)
-					unlock_page_lruvec_irqrestore(lruvec,
-									flags);
+			struct lruvec *prev_lruvec =3D lruvec;
+
+			lruvec =3D relock_page_lruvec_irqsave(page, lruvec,
+									&flags);
+			if (prev_lruvec !=3D lruvec)
 				lock_batch =3D 0;
-				lruvec =3D lock_page_lruvec_irqsave(page, &flags);
-			}
=20
 			VM_BUG_ON_PAGE(!PageLRU(page), page);
 			__ClearPageLRU(page);
@@ -1033,15 +1021,8 @@ void __pagevec_lru_add(struct pagevec *pvec)
=20
 	for (i =3D 0; i < pagevec_count(pvec); i++) {
 		struct page *page =3D pvec->pages[i];
-		struct lruvec *new_lruvec;
-
-		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec !=3D new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irqrestore(lruvec, flags);
-			lruvec =3D lock_page_lruvec_irqsave(page, &flags);
-		}
=20
+		lruvec =3D relock_page_lruvec_irqsave(page, lruvec, &flags);
 		__pagevec_lru_add_fn(page, lruvec);
 	}
 	if (lruvec)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2953ddec88a0..3b09a39de8cd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1884,8 +1884,7 @@ static unsigned noinline_for_stack move_pages_to_lru(=
struct lruvec *lruvec,
 		 * All pages were isolated from the same lruvec (and isolation
 		 * inhibits memcg migration).
 		 */
-		VM_BUG_ON_PAGE(mem_cgroup_page_lruvec(page, page_pgdat(page))
-							!=3D lruvec, page);
+		VM_BUG_ON_PAGE(!lruvec_holds_page_lru_lock(page, lruvec), page);
 		lru =3D page_lru(page);
 		nr_pages =3D thp_nr_pages(page);
=20
@@ -4277,7 +4276,6 @@ void check_move_unevictable_pages(struct pagevec *pve=
c)
 	for (i =3D 0; i < pvec->nr; i++) {
 		struct page *page =3D pvec->pages[i];
 		int nr_pages;
-		struct lruvec *new_lruvec;
=20
 		if (PageTransTail(page))
 			continue;
@@ -4289,13 +4287,7 @@ void check_move_unevictable_pages(struct pagevec *pv=
ec)
 		if (!TestClearPageLRU(page))
 			continue;
=20
-		new_lruvec =3D mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec !=3D new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irq(lruvec);
-			lruvec =3D lock_page_lruvec_irq(page);
-		}
-
+		lruvec =3D relock_page_lruvec_irq(page, lruvec);
 		if (page_evictable(page) && PageUnevictable(page)) {
 			enum lru_list lru =3D page_lru_base_type(page);
=20
--=20
1.8.3.1

