From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 08/14] lru/swap: uer lruvec lock in activate_page
Date: Tue, 20 Aug 2019 17:48:31 +0800
Message-ID: <1566294517-86418-9-git-send-email-alex.shi@linux.alibaba.com>
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

to replace pgdat lru_lock.

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
 mm/swap.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 2a8fe6df08fc..d2dad08fcfd0 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -325,11 +325,14 @@ static inline void activate_page_drain(int cpu)
 void activate_page(struct page *page)
 {
 	pg_data_t *pgdat = page_pgdat(page);
+	struct lruvec *lruvec;
 
 	page = compound_head(page);
-	spin_lock_irq(&pgdat->lruvec.lru_lock);
+	lruvec = mem_cgroup_page_lruvec(page, pgdat);
+	spin_lock_irq(&lruvec->lru_lock);
+	sync_lruvec_pgdat(lruvec, pgdat);
 	__activate_page(page, mem_cgroup_page_lruvec(page, pgdat), NULL);
-	spin_unlock_irq(&pgdat->lruvec.lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
 }
 #endif
 
-- 
1.8.3.1

