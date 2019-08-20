From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 03/14] lru/memcg: using per lruvec lock in un/lock_page_lru
Date: Tue, 20 Aug 2019 17:48:26 +0800
Message-ID: <1566294517-86418-4-git-send-email-alex.shi@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

Now we repeatly assign the lruvec->pgdat in memcg. Will remove the
assignment in lruvec getting function after very points are protected.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memcontrol.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8a1b0d95ba8..19fd911e8098 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2550,12 +2550,12 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 static void lock_page_lru(struct page *page, int *isolated)
 {
 	pg_data_t *pgdat = page_pgdat(page);
+	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-	spin_lock_irq(&pgdat->lruvec.lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
+	sync_lruvec_pgdat(lruvec, pgdat);
 	if (PageLRU(page)) {
-		struct lruvec *lruvec;
 
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 		ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		*isolated = 1;
@@ -2566,16 +2566,14 @@ static void lock_page_lru(struct page *page, int *isolated)
 static void unlock_page_lru(struct page *page, int isolated)
 {
 	pg_data_t *pgdat = page_pgdat(page);
+	struct lruvec *lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
 	if (isolated) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		SetPageLRU(page);
 		add_page_to_lru_list(page, lruvec, page_lru(page));
 	}
-	spin_unlock_irq(&pgdat->lruvec.lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
 }
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
-- 
1.8.3.1

