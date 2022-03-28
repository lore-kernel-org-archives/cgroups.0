From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm/memcg: remove unneeded nr_scanned
Date: Mon, 28 Mar 2022 19:41:44 +0800
Message-ID: <20220328114144.53389-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

The local variable nr_scanned is unneeded as mem_cgroup_soft_reclaim always
does *total_scanned += nr_scanned. So we can pass total_scanned directly to
the mem_cgroup_soft_reclaim to simplify the code and save some cpu cycles
of adding nr_scanned to total_scanned.

Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b686ec4f42c6..79341365ec90 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3384,7 +3384,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	int loop = 0;
 	struct mem_cgroup_tree_per_node *mctz;
 	unsigned long excess;
-	unsigned long nr_scanned;
 
 	if (order > 0)
 		return 0;
@@ -3412,11 +3411,9 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		if (!mz)
 			break;
 
-		nr_scanned = 0;
 		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
-						    gfp_mask, &nr_scanned);
+						    gfp_mask, total_scanned);
 		nr_reclaimed += reclaimed;
-		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
 		__mem_cgroup_remove_exceeded(mz, mctz);
 
-- 
2.23.0

