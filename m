From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 7/7] memcg: remove drain_all_stock_sync.
Date: Thu, 12 Apr 2012 20:31:36 +0900
Message-ID: <4F86BD18.4010505@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Because a function moving pages to ancestor works asynchronously now,
drain_all_stock_sync() is unnecessary.

Signed-off-by: KAMEAZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e466809..d42811b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2053,7 +2053,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
  * of the hierarchy under it. sync flag says whether we should block
  * until the work is done.
  */
-static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
+static void drain_all_stock(struct mem_cgroup *root_memcg)
 {
 	int cpu, curcpu;
 
@@ -2077,16 +2077,6 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 		}
 	}
 	put_cpu();
-
-	if (!sync)
-		goto out;
-
-	for_each_online_cpu(cpu) {
-		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
-		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
-			flush_work(&stock->work);
-	}
-out:
  	put_online_cpus();
 }
 
@@ -2103,15 +2093,7 @@ static void drain_all_stock_async(struct mem_cgroup *root_memcg)
 	 */
 	if (!mutex_trylock(&percpu_charge_mutex))
 		return;
-	drain_all_stock(root_memcg, false);
-	mutex_unlock(&percpu_charge_mutex);
-}
-
-static void drain_all_stock_sync(struct mem_cgroup *root_memcg)
-{
-	/* called when force_empty is called */
-	mutex_lock(&percpu_charge_mutex);
-	drain_all_stock(root_memcg, true);
+	drain_all_stock(root_memcg);
 	mutex_unlock(&percpu_charge_mutex);
 }
 
-- 
1.7.4.1

