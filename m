From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 1/3] mm: Drop locked from isolate_migratepages_block
Date: Wed, 12 Aug 2020 21:02:24 -0700
Message-ID: <20200813040224.13054.96724.stgit@localhost.localdomain>
References: <20200813035100.13054.25671.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XtxT1MTxM5ARJ+08eWr2bJ37iwug5sulaz41RNmMU7k=;
        b=p7aKYuuOYtZex8EmSHqns2ZVG6wtpk4+BJY6vTjOWkw9WYj2eijkenTtU70ZLdXWyE
         GQrZFDJrpyqGeq6kIv3KfpWbtPJ0thdDxLNyrRk32/WBCYNISKcCW1gOEnlUnynVrMY2
         unbACAKixzD21x1yKI8PZY26drlVM4slXcE4ZnTDk6FPDyy+BNskGWk2LNwClTmLWpAu
         UjT5Bc1jXlMXNnfJWxGeJA8NmE7vREmRF9Qo3Ym76m44t8HmrT4uKcB10SnYiSsdX/cE
         iy1vSkyE7G/EC5PmTx5uC0TRNuQGC48FnnYA5zPE0xjrCLLM1NZltN3VJwV6S0aaW5+/
         OkVA==
In-Reply-To: <20200813035100.13054.25671.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

We can drop the need for the locked variable by making use of the
lruvec_holds_page_lru_lock function. By doing this we can avoid some rcu
locking ugliness for the case where the lruvec is still holding the LRU
lock associated with the page. Instead we can just use the lruvec and if it
is NULL we assume the lock was released.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/compaction.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b99c96c4862d..5021a18ef722 100644
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
@@ -992,16 +991,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
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
 
+			lruvec = mem_cgroup_page_lruvec(page, pgdat);
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
-			locked = lruvec;
 			rcu_read_unlock();
 
 			lruvec_memcg_debug(lruvec, page);
@@ -1023,8 +1019,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
-		} else
-			rcu_read_unlock();
+		}
 
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
@@ -1057,9 +1052,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
 
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
 
@@ -1073,9 +1068,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
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
@@ -1102,8 +1097,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	page = NULL;
 
 isolate_abort:
-	if (locked)
-		unlock_page_lruvec_irqrestore(locked, flags);
+	if (lruvec)
+		unlock_page_lruvec_irqrestore(lruvec, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);

