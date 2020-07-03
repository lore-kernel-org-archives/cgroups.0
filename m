From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v14 17/20] mm/lru: introduce the relock_page_lruvec function
Date: Fri,  3 Jul 2020 13:07:50 +0800
Message-ID: <1593752873-4493-18-git-send-email-alex.shi@linux.alibaba.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1593752873-4493-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Use this new function to replace repeated same code.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
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
index 80de8a5182ca..c4d8710c8957 100644
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
index 168c1659e430..bdb53a678e7e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4292,15 +4292,9 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 
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

