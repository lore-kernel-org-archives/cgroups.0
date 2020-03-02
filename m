From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v9 02/20] mm/memcg: fold lock_page_lru into commit_charge
Date: Mon,  2 Mar 2020 19:00:12 +0800
Message-ID: <1583146830-169516-3-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org

As Konstantin Khlebnikov mentioned:

	Also I don't like these functions:
	- called lock/unlock but actually also isolates
	- used just once
	- pgdat evaluated twice

Cleanup and fold these functions into commit_charge. It also reduces
lock time while lrucare && !PageLRU.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 57 ++++++++++++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d09776cd6e10..875e2aebcde7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2572,41 +2572,11 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 	css_put_many(&memcg->css, nr_pages);
 }
 
-static void lock_page_lru(struct page *page, int *isolated)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-
-	spin_lock_irq(&pgdat->lru_lock);
-	if (PageLRU(page)) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		ClearPageLRU(page);
-		del_page_from_lru_list(page, lruvec, page_lru(page));
-		*isolated = 1;
-	} else
-		*isolated = 0;
-}
-
-static void unlock_page_lru(struct page *page, int isolated)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-
-	if (isolated) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		VM_BUG_ON_PAGE(PageLRU(page), page);
-		SetPageLRU(page);
-		add_page_to_lru_list(page, lruvec, page_lru(page));
-	}
-	spin_unlock_irq(&pgdat->lru_lock);
-}
-
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 			  bool lrucare)
 {
-	int isolated;
+	struct lruvec *lruvec = NULL;
+	pg_data_t *pgdat;
 
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 
@@ -2614,9 +2584,17 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
 	 * may already be on some other mem_cgroup's LRU.  Take care of it.
 	 */
-	if (lrucare)
-		lock_page_lru(page, &isolated);
-
+	if (lrucare) {
+		pgdat = page_pgdat(page);
+		spin_lock_irq(&pgdat->lru_lock);
+
+		if (PageLRU(page)) {
+			lruvec = mem_cgroup_page_lruvec(page, pgdat);
+			ClearPageLRU(page);
+			del_page_from_lru_list(page, lruvec, page_lru(page));
+		} else
+			spin_unlock_irq(&pgdat->lru_lock);
+	}
 	/*
 	 * Nobody should be changing or seriously looking at
 	 * page->mem_cgroup at this point:
@@ -2633,8 +2611,13 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 	 */
 	page->mem_cgroup = memcg;
 
-	if (lrucare)
-		unlock_page_lru(page, isolated);
+	if (lrucare && lruvec) {
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		VM_BUG_ON_PAGE(PageLRU(page), page);
+		SetPageLRU(page);
+		add_page_to_lru_list(page, lruvec, page_lru(page));
+		spin_unlock_irq(&pgdat->lru_lock);
+	}
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-- 
1.8.3.1

