From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 07/14] lru/swap: using per lruvec lock in page_cache_release
Date: Tue, 20 Aug 2019 17:48:30 +0800
Message-ID: <1566294517-86418-8-git-send-email-alex.shi@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Matthew Wilcox <willy@infradead.org>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Peng Fan <peng.fan@nxp.com>, Nikolay Borisov <nborisov@suse.com>, Ira Weiny <ira.weiny@intel.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>

Also cares the lruvec->pgdat syncing.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/swap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 63f4782af57a..2a8fe6df08fc 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -63,12 +63,13 @@ static void __page_cache_release(struct page *page)
 		struct lruvec *lruvec;
 		unsigned long flags;
 
-		spin_lock_irqsave(&pgdat->lruvec.lru_lock, flags);
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		spin_lock_irqsave(&lruvec->lru_lock, flags);
+		sync_lruvec_pgdat(lruvec, pgdat);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
-		spin_unlock_irqrestore(&pgdat->lruvec.lru_lock, flags);
+		spin_unlock_irqrestore(&lruvec->lru_lock, flags);
 	}
 	__ClearPageWaiters(page);
 	mem_cgroup_uncharge(page);
-- 
1.8.3.1

