From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v9 12/20] mm/mlock: clean up __munlock_isolate_lru_page
Date: Mon,  2 Mar 2020 19:00:22 +0800
Message-ID: <1583146830-169516-13-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org

clean up __munlock_isolate_lru_page func for later lru lock change.
No functional change.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/mlock.c | 47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 7ddc52ca14b1..a43b3da78541 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -103,25 +103,6 @@ void mlock_vma_page(struct page *page)
 }
 
 /*
- * Isolate a page from LRU with optional get_page() pin.
- * Assumes lru_lock already held and page already pinned.
- */
-static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
-{
-	if (TestClearPageLRU(page)) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (getpage)
-			get_page(page);
-		del_page_from_lru_list(page, lruvec, page_lru(page));
-		return true;
-	}
-
-	return false;
-}
-
-/*
  * Finish munlock after successful page isolation
  *
  * Page must be locked. This is a wrapper for try_to_munlock()
@@ -311,26 +292,34 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 	spin_lock_irq(&zone->zone_pgdat->lru_lock);
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
+		struct lruvec *lruvec;
 
-		if (TestClearPageMlocked(page)) {
-			/*
-			 * We already have pin from follow_page_mask()
-			 * so we can spare the get_page() here.
-			 */
-			if (__munlock_isolate_lru_page(page, false))
-				continue;
-			else
-				__munlock_isolation_failed(page);
-		} else {
+		if (!TestClearPageMlocked(page)) {
 			delta_munlocked++;
+			goto putback;
+		}
+
+		if (!TestClearPageLRU(page)) {
+			__munlock_isolation_failed(page);
+			goto putback;
 		}
 
 		/*
+		 * Isolate this page.
+		 * We already have pin from follow_page_mask()
+		 * so we can spare the get_page() here.
+		 */
+		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+		del_page_from_lru_list(page, lruvec, page_lru(page));
+		continue;
+
+		/*
 		 * We won't be munlocking this page in the next phase
 		 * but we still need to release the follow_page_mask()
 		 * pin. We cannot do it under lru_lock however. If it's
 		 * the last pin, __page_cache_release() would deadlock.
 		 */
+putback:
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] = NULL;
 	}
-- 
1.8.3.1

