From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 28 Jul 2020 23:39:31 +0800
Message-ID: <1fd45e69-3a50-aae8-bcc4-47d891a5e263@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>



在 2020/7/28 上午7:34, Alexander Duyck 写道:
> It might make more sense to look at modifying
> compact_unlock_should_abort and compact_lock_irqsave (which always
> returns true so should probably be a void) to address the deficiencies
> they have that make them unusable for you.

One of possible reuse for the func compact_unlock_should_abort, could be
like the following, the locked parameter reused different in 2 places.
but, it's seems no this style usage in kernel, isn't it?

Thanks
Alex

From 41d5ce6562f20f74bc6ac2db83e226ac28d56e90 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Tue, 28 Jul 2020 21:19:32 +0800
Subject: [PATCH] compaction polishing

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/compaction.c | 71 ++++++++++++++++++++++++---------------------------------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index c28a43481f01..36fce988de3e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -479,20 +479,20 @@ static bool test_and_set_skip(struct compact_control *cc, struct page *page,
  *
  * Always returns true which makes it easier to track lock state in callers.
  */
-static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
+static void compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
 						struct compact_control *cc)
 	__acquires(lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
 		if (spin_trylock_irqsave(lock, *flags))
-			return true;
+			return;
 
 		cc->contended = true;
 	}
 
 	spin_lock_irqsave(lock, *flags);
-	return true;
+	return;
 }
 
 /*
@@ -511,11 +511,11 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
  *		scheduled)
  */
 static bool compact_unlock_should_abort(spinlock_t *lock,
-		unsigned long flags, bool *locked, struct compact_control *cc)
+		unsigned long flags, void **locked, struct compact_control *cc)
 {
 	if (*locked) {
 		spin_unlock_irqrestore(lock, flags);
-		*locked = false;
+		*locked = NULL;
 	}
 
 	if (fatal_signal_pending(current)) {
@@ -543,7 +543,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor;
 	unsigned long flags = 0;
-	bool locked = false;
+	struct compact_control *locked = NULL;
 	unsigned long blockpfn = *start_pfn;
 	unsigned int order;
 
@@ -565,7 +565,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		 */
 		if (!(blockpfn % SWAP_CLUSTER_MAX)
 		    && compact_unlock_should_abort(&cc->zone->lock, flags,
-								&locked, cc))
+							(void**)&locked, cc))
 			break;
 
 		nr_scanned++;
@@ -599,8 +599,8 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 		 * recheck as well.
 		 */
 		if (!locked) {
-			locked = compact_lock_irqsave(&cc->zone->lock,
-								&flags, cc);
+			compact_lock_irqsave(&cc->zone->lock, &flags, cc);
+			locked = cc;
 
 			/* Recheck this is a buddy page under lock */
 			if (!PageBuddy(page))
@@ -787,7 +787,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct lruvec *lruvec;
 	unsigned long flags = 0;
-	struct lruvec *locked_lruvec = NULL;
+	struct lruvec *locked = NULL;
 	struct page *page = NULL, *valid_page = NULL;
 	unsigned long start_pfn = low_pfn;
 	bool skip_on_failure = false;
@@ -847,21 +847,11 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		 * contention, to give chance to IRQs. Abort completely if
 		 * a fatal signal is pending.
 		 */
-		if (!(low_pfn % SWAP_CLUSTER_MAX)) {
-			if (locked_lruvec) {
-				unlock_page_lruvec_irqrestore(locked_lruvec,
-									flags);
-				locked_lruvec = NULL;
-			}
-
-			if (fatal_signal_pending(current)) {
-				cc->contended = true;
-
-				low_pfn = 0;
-				goto fatal_pending;
-			}
-
-			cond_resched();
+		if (!(low_pfn % SWAP_CLUSTER_MAX)
+		    && compact_unlock_should_abort(&locked->lru_lock, flags,
+						(void**)&locked, cc)) {
+			low_pfn = 0;
+			goto fatal_pending;
 		}
 
 		if (!pfn_valid_within(low_pfn))
@@ -932,9 +922,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			 */
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
-				if (locked_lruvec) {
-					unlock_page_lruvec_irqrestore(locked_lruvec, flags);
-					locked_lruvec = NULL;
+				if (locked) {
+					unlock_page_lruvec_irqrestore(locked, flags);
+					locked = NULL;
 				}
 
 				if (!isolate_movable_page(page, isolate_mode))
@@ -979,13 +969,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 		/* If we already hold the lock, we can skip some rechecking */
-		if (lruvec != locked_lruvec) {
-			if (locked_lruvec)
-				unlock_page_lruvec_irqrestore(locked_lruvec,
+		if (lruvec != locked) {
+			if (locked)
+				unlock_page_lruvec_irqrestore(locked,
 									flags);
 
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
-			locked_lruvec = lruvec;
+			locked = lruvec;
 			rcu_read_unlock();
 
 			lruvec_memcg_debug(lruvec, page);
@@ -1041,9 +1031,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
-		if (locked_lruvec) {
-			unlock_page_lruvec_irqrestore(locked_lruvec, flags);
-			locked_lruvec = NULL;
+		if (locked) {
+			unlock_page_lruvec_irqrestore(locked, flags);
+			locked = NULL;
 		}
 		put_page(page);
 
@@ -1057,10 +1047,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		 * page anyway.
 		 */
 		if (nr_isolated) {
-			if (locked_lruvec) {
-				unlock_page_lruvec_irqrestore(locked_lruvec,
-									flags);
-				locked_lruvec = NULL;
+			if (locked) {
+				unlock_page_lruvec_irqrestore(locked, flags);
+				locked = NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
@@ -1087,8 +1076,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	page = NULL;
 
 isolate_abort:
-	if (locked_lruvec)
-		unlock_page_lruvec_irqrestore(locked_lruvec, flags);
+	if (locked)
+		unlock_page_lruvec_irqrestore(locked, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);
-- 
1.8.3.1

