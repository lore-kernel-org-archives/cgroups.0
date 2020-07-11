From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v16 20/22] mm/vmscan: use relock for move_pages_to_lru
Date: Sat, 11 Jul 2020 08:58:54 +0800
Message-ID: <1594429136-20002-21-git-send-email-alex.shi@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>

From: Hugh Dickins <hughd@google.com>

Use the relock function to replace relocking action. And try to save few
lock times.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Jann Horn <jannh@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/vmscan.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bdb53a678e7e..078a1640ec60 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1854,15 +1854,15 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 	enum lru_list lru;
 
 	while (!list_empty(list)) {
-		struct lruvec *new_lruvec = NULL;
-
 		page = lru_to_page(list);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			spin_unlock_irq(&lruvec->lru_lock);
+			if (lruvec) {
+				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec = NULL;
+			}
 			putback_lru_page(page);
-			spin_lock_irq(&lruvec->lru_lock);
 			continue;
 		}
 
@@ -1876,12 +1876,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 		 *                                        list_add(&page->lru,)
 		 *     list_add(&page->lru,) //corrupt
 		 */
-		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
-		if (new_lruvec != lruvec) {
-			if (lruvec)
-				spin_unlock_irq(&lruvec->lru_lock);
-			lruvec = lock_page_lruvec_irq(page);
-		}
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 		SetPageLRU(page);
 
 		if (unlikely(put_page_testzero(page))) {
@@ -1890,8 +1885,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec = NULL;
 				destroy_compound_page(page);
-				spin_lock_irq(&lruvec->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
 
-- 
1.8.3.1

