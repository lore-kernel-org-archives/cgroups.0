From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v11 13/16] mm/lru: introduce the relock_page_lruvec function
Date: Thu, 28 May 2020 19:00:55 +0800
Message-ID: <1590663658-184131-14-git-send-email-alex.shi@linux.alibaba.com>
References: <1590663658-184131-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1590663658-184131-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>

Use this new function to replace repeated same code.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
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
 include/linux/memcontrol.h | 36 ++++++++++++++++++++++++++++++++++++
 mm/mlock.c                 |  9 +--------
 mm/swap.c                  | 24 ++++++------------------
 mm/vmscan.c                |  8 +-------
 4 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a4601169bf7d..ed09bf53c70f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1313,6 +1313,42 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
 
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
+		struct lruvec *locked_lruvec)
+{
+	struct pglist_data *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
+	if (likely(locked_lruvec == lruvec))
+		return lruvec;
+
+	if (unlikely(locked_lruvec))
+		unlock_page_lruvec_irq(locked_lruvec);
+
+	return lock_page_lruvec_irq(page);
+}
+
+/* Don't lock again iff page's lruvec locked */
+static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
+		struct lruvec *locked_lruvec, unsigned long *flags)
+{
+	struct pglist_data *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+
+	if (likely(locked_lruvec == lruvec))
+		return lruvec;
+
+	if (unlikely(locked_lruvec))
+		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+
+	return lock_page_lruvec_irqsave(page, flags);
+}
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
diff --git a/mm/mlock.c b/mm/mlock.c
index c1ef4ac7a744..5b79757e5d02 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -289,17 +289,10 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 	/* Phase 1: page isolation */
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
-		struct lruvec *new_lruvec;
 		bool clearlru;
 
 		clearlru = TestClearPageLRU(page);
-
-		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (new_lruvec != lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irq(lruvec);
-			lruvec = lock_page_lruvec_irq(page);
-		}
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 
 		if (!TestClearPageMlocked(page)) {
 			delta_munlocked++;
diff --git a/mm/swap.c b/mm/swap.c
index 91ff3d4a7751..bea9497bbda3 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -190,15 +190,8 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
-		struct lruvec *new_lruvec;
-
-		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec != new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irqrestore(lruvec, flags);
-			lruvec = lock_page_lruvec_irqsave(page, &flags);
-		}
 
+		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
 		(*move_fn)(page, lruvec, arg);
 	}
 	if (lruvec)
@@ -821,17 +814,12 @@ void release_pages(struct page **pages, int nr)
 		}
 
 		if (TestClearPageLRU(page)) {
-			struct lruvec *new_lruvec;
-
-			new_lruvec = mem_cgroup_page_lruvec(page,
-							page_pgdat(page));
-			if (new_lruvec != lruvec) {
-				if (lruvec)
-					unlock_page_lruvec_irqrestore(lruvec,
-									flags);
+			struct lruvec *pre_lruvec = lruvec;
+
+			lruvec = relock_page_lruvec_irqsave(page, lruvec,
+									&flags);
+			if (pre_lruvec != lruvec)
 				lock_batch = 0;
-				lruvec = lock_page_lruvec_irqsave(page, &flags);
-			}
 
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c4c30b530876..7a0d4ac71558 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4291,15 +4291,9 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 
 	for (i = 0; i < pvec->nr; i++) {
 		struct page *page = pvec->pages[i];
-		struct lruvec *new_lruvec;
 
 		pgscanned++;
-		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (lruvec != new_lruvec) {
-			if (lruvec)
-				unlock_page_lruvec_irq(lruvec);
-			lruvec = lock_page_lruvec_irq(page);
-		}
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 
 		if (!PageLRU(page) || !PageUnevictable(page))
 			continue;
-- 
1.8.3.1

