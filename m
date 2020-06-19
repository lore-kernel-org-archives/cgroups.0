From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v13 15/18] mm/lru: introduce the relock_page_lruvec function
Date: Fri, 19 Jun 2020 16:33:53 +0800
Message-ID: <1592555636-115095-16-git-send-email-alex.shi@linux.alibaba.com>
References: <1592555636-115095-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1592555636-115095-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>

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
 mm/mlock.c  |  9 +--------
 mm/swap.c   | 25 ++++++-------------------
 mm/vmscan.c |  8 +-------
 3 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 97a8667b4c2c..fa976a5b91c7 100644
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
index 6abdd950b045..f81d710bccb9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -209,20 +209,12 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 
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
 
 		/* new page add to lru or page moving between lru */
 		if (!add && !TestClearPageLRU(page))
 			continue;
 
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
 		(*move_fn)(page, lruvec);
 
 		if (!add)
@@ -868,17 +860,12 @@ void release_pages(struct page **pages, int nr)
 		}
 
 		if (PageLRU(page)) {
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
 
 			__ClearPageLRU(page);
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e489817275f3..e461cd087ad3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4290,15 +4290,9 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 
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

