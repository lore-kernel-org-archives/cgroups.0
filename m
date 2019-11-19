From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v4 6/9] mm/vmscan: only change the lru_lock iff page's lruvec is different
Date: Tue, 19 Nov 2019 20:23:20 +0800
Message-ID: <1574166203-151975-7-git-send-email-alex.shi@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, swkhack <swkhack@gmail.com>, "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Peng Fan <peng.fan@nxp.com>, Nikolay Borisov <nborisov@suse.com>, Ira Weiny <ira.weiny@intel.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Yafang Shao <laoar.shao@gmail.com>

Used relock_page_lruvec in more places for spin_lock reducing.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: swkhack <swkhack@gmail.com>
Cc: "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Nikolay Borisov <nborisov@suse.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/vmscan.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3cdf343e7a27..ba57c55a6a41 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1825,22 +1825,25 @@ static int too_many_isolated(struct pglist_data *pgdat, int file,
  * Returns the number of pages moved to the given lruvec.
  */
 
-static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
+static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *llvec,
 						     struct list_head *list)
 {
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
 	struct page *page;
 	enum lru_list lru;
+	struct lruvec *lruvec = llvec;
 
 	while (!list_empty(list)) {
 		page = lru_to_page(list);
+		lruvec = relock_page_lruvec_irq(page, lruvec);
+
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		if (unlikely(!page_evictable(page))) {
 			list_del(&page->lru);
 			spin_unlock_irq(&lruvec->lru_lock);
+			lruvec = NULL;
 			putback_lru_page(page);
-			spin_lock_irq(&lruvec->lru_lock);
 			continue;
 		}
 
@@ -1858,8 +1861,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&lruvec->lru_lock);
+				lruvec = NULL;
 				(*get_compound_page_dtor(page))(page);
-				spin_lock_irq(&lruvec->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
 		} else {
@@ -1867,6 +1870,11 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 		}
 	}
 
+	if (lruvec != llvec) {
+		if (lruvec)
+			spin_unlock_irq(&lruvec->lru_lock);
+		spin_lock_irq(&llvec->lru_lock);
+	}
 	/*
 	 * To save our caller's stack, now use input list for pages to free.
 	 */
@@ -4289,18 +4297,10 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 
 	for (i = 0; i < pvec->nr; i++) {
 		struct page *page = pvec->pages[i];
-		struct pglist_data *pgdat = page_pgdat(page);
-		struct lruvec *new_lruvec = mem_cgroup_page_lruvec(page, pgdat);
-
 
 		pgscanned++;
 
-		if (lruvec != new_lruvec) {
-			if (lruvec)
-				spin_unlock_irq(&lruvec->lru_lock);
-			lruvec = new_lruvec;
-			spin_lock_irq(&lruvec->lru_lock);
-		}
+		lruvec = relock_page_lruvec_irq(page, lruvec);
 
 		if (!PageLRU(page) || !PageUnevictable(page))
 			continue;
-- 
1.8.3.1

