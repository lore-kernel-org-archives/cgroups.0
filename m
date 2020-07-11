From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v16 07/22] mm/thp: remove code path which never got into
Date: Sat, 11 Jul 2020 08:58:41 +0800
Message-ID: <1594429136-20002-8-git-send-email-alex.shi@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name

split_huge_page() will never call on a page which isn't on lru list, so
this code never got a chance to run, and should not be run, to add tail
pages on a lru list which head page isn't there.

Although the bug was never triggered, it'better be removed for code
correctness.

BTW, it looks better to have BUG() or soem warning set in the wrong
path, but the path will be changed in incomming new page isolation
func. So just save it here.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/huge_memory.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b18f21da4dac..1fb4147ff854 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2357,16 +2357,6 @@ static void lru_add_page_tail(struct page *head, struct page *page_tail,
 		/* page reclaim is reclaiming a huge page */
 		get_page(page_tail);
 		list_add_tail(&page_tail->lru, list);
-	} else {
-		/*
-		 * Head page has not yet been counted, as an hpage,
-		 * so we must account for each subpage individually.
-		 *
-		 * Put page_tail on the list at the correct position
-		 * so they all end up in order.
-		 */
-		add_page_to_lru_list_tail(page_tail, lruvec,
-					  page_lru(page_tail));
 	}
 }
 
-- 
1.8.3.1

