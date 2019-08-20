From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH 13/14] lru/vmscan: using per lruvec lru_lock in get_scan_count
Date: Tue, 20 Aug 2019 17:48:36 +0800
Message-ID: <1566294517-86418-14-git-send-email-alex.shi@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Johannes Weiner <hannes@cmpxchg.org>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yafang Shao <laoar.shao@gmail.com>, Yang Shi <yang.shi@linux.alibaba.com>

The lruvec is passed as parameter, so no lruvec->pgdat syncing needed.

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 123447b9beda..ea5c2f3f2567 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2372,7 +2372,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 	file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES) +
 		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES);
 
-	spin_lock_irq(&pgdat->lruvec.lru_lock);
+	spin_lock_irq(&lruvec->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		reclaim_stat->recent_scanned[0] /= 2;
 		reclaim_stat->recent_rotated[0] /= 2;
@@ -2393,7 +2393,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
 
 	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
-	spin_unlock_irq(&pgdat->lruvec.lru_lock);
+	spin_unlock_irq(&lruvec->lru_lock);
 
 	fraction[0] = ap;
 	fraction[1] = fp;
-- 
1.8.3.1

