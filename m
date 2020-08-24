From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v18 28/32] mm/compaction: Drop locked from isolate_migratepages_block
Date: Mon, 24 Aug 2020 20:55:01 +0800
Message-ID: <1598273705-69124-29-git-send-email-alex.shi@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>, Stephen Rothwell <sfr@canb.auug.org.au>

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

We can drop the need for the locked variable by making use of the
lruvec_holds_page_lru_lock function. By doing this we can avoid some rcu
locking ugliness for the case where the lruvec is still holding the LRU
lock associated with the page. Instead we can just use the lruvec and if it
is NULL we assume the lock was released.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/compaction.c | 46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b724eacf6421..6bf5ccd8fcf6 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -803,9 +803,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 {
 	pg_data_t *pgdat = cc->zone->zone_pgdat;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
-	struct lruvec *lruvec;
+	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
-	struct lruvec *locked = NULL;
 	struct page *page = NULL, *valid_page = NULL;
 	unsigned long start_pfn = low_pfn;
 	bool skip_on_failure = false;
@@ -866,9 +865,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		 * a fatal signal is pending.
 		 */
 		if (!(low_pfn % SWAP_CLUSTER_MAX)) {
-			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
-				locked = NULL;
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec = NULL;
 			}
 
 			if (fatal_signal_pending(current)) {
@@ -949,9 +948,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			 */
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
-				if (locked) {
-					unlock_page_lruvec_irqrestore(locked, flags);
-					locked = NULL;
+				if (lruvec) {
+					unlock_page_lruvec_irqrestore(lruvec, flags);
+					lruvec = NULL;
 				}
 
 				if (!isolate_movable_page(page, isolate_mode))
@@ -992,16 +991,14 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
 
-		rcu_read_lock();
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-
 		/* If we already hold the lock, we can skip some rechecking */
-		if (lruvec != locked) {
-			if (locked)
-				unlock_page_lruvec_irqrestore(locked, flags);
+		if (!lruvec || !lruvec_holds_page_lru_lock(page, lruvec)) {
+			if (lruvec)
+				unlock_page_lruvec_irqrestore(lruvec, flags);
 
+			rcu_read_lock();
+			lruvec = mem_cgroup_page_lruvec(page, pgdat);
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
-			locked = lruvec;
 			rcu_read_unlock();
 
 			lruvec_memcg_debug(lruvec, page);
@@ -1023,8 +1020,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
-		} else
-			rcu_read_unlock();
+		}
 
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
@@ -1057,9 +1053,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
-		if (locked) {
-			unlock_page_lruvec_irqrestore(locked, flags);
-			locked = NULL;
+		if (lruvec) {
+			unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec = NULL;
 		}
 		put_page(page);
 
@@ -1073,9 +1069,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		 * page anyway.
 		 */
 		if (nr_isolated) {
-			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
-				locked = NULL;
+			if (lruvec) {
+				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec = NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
@@ -1102,8 +1098,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	page = NULL;
 
 isolate_abort:
-	if (locked)
-		unlock_page_lruvec_irqrestore(locked, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);
-- 
1.8.3.1

