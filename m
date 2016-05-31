From: roy.qing.li@gmail.com
Subject: [PATCH][RFC] mm: memcontrol: fix a unbalance uncharged count
Date: Tue, 31 May 2016 17:38:32 +0800
Message-ID: <1464687512-10695-1-git-send-email-roy.qing.li@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-mm@kvack.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov@virtuozzo.com

From: Li RongQing <roy.qing.li@gmail.com>

I see the number of page of hpage_nr_pages(page) is charged if page is
transparent huge or hugetlbfs pages; but when uncharge a huge page,
(1<<compound_order) page is uncharged, and maybe hpage_nr_pages(page) is
not same as 1<<compound_order.

And remove VM_BUG_ON_PAGE(!PageTransHuge(page), page); since
PageTransHuge(page) always is true, when this VM_BUG_ON_PAGE is called.

Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
---
 mm/memcontrol.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 12aaadd..28c0137 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5453,8 +5453,7 @@ static void uncharge_list(struct list_head *page_list)
 		}
 
 		if (PageTransHuge(page)) {
-			nr_pages <<= compound_order(page);
-			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
+			nr_pages = hpage_nr_pages(page);
 			nr_huge += nr_pages;
 		}
 
-- 
2.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
