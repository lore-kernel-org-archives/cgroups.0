From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v10 05/15] mm/thp: clean up lru_add_page_tail
Date: Mon, 27 Apr 2020 15:02:54 +0800
Message-ID: <1587970985-21629-6-git-send-email-alex.shi@linux.alibaba.com>
References: <1587970985-21629-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1587970985-21629-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>

Since the first parameter is only used by head page, it's better to make
it stright. And no needs to keep head checking:
	VM_BUG_ON_PAGE(!PageHead(page), page);

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/huge_memory.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ea60340a14c8..bd28d68ad3a8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2501,21 +2501,20 @@ static void remap_page(struct page *page)
 	}
 }
 
-void lru_add_page_tail(struct page *page, struct page *page_tail,
+void lru_add_page_tail(struct page *head, struct page *page_tail,
 		       struct lruvec *lruvec, struct list_head *list)
 {
 	const int file = 0;
 
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
-	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
+	VM_BUG_ON_PAGE(PageCompound(page_tail), head);
+	VM_BUG_ON_PAGE(PageLRU(page_tail), head);
 	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
 
 	if (!list)
 		SetPageLRU(page_tail);
 
-	if (likely(PageLRU(page)))
-		list_add_tail(&page_tail->lru, &page->lru);
+	if (likely(PageLRU(head)))
+		list_add_tail(&page_tail->lru, &head->lru);
 	else if (list) {
 		/* page reclaim is reclaiming a huge page */
 		get_page(page_tail);
@@ -2532,7 +2531,7 @@ void lru_add_page_tail(struct page *page, struct page *page_tail,
 					  page_lru(page_tail));
 	}
 
-	if (!PageUnevictable(page))
+	if (!PageUnevictable(head))
 		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
 }
 
-- 
1.8.3.1

