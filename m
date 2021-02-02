From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 7/7] mm: memcontrol: consolidate lruvec stat flushing
Date: Tue,  2 Feb 2021 13:47:46 -0500
Message-ID: <20210202184746.119084-8-hannes@cmpxchg.org>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wH4c6SXNdhNwh+C23BEFkUNz9OTjPe+NannGM5GtmrQ=;
        b=J29bxNRinL1CN+JqxD3H5YMXk5tmfxXkSEjOPJX/ssjGALv8pJGYjjR5KFiU19djZJ
         S6ZsrjzCu/7fjI1R9wGkp68lqh0Ham2Gkmos778PuL03eCfcX0NJrzAZdDt3IblYPUkg
         m+bR2gl8Du2Ksk+3F3P4Otlj2gPliOGcn9EL7zt/X9MOjB5pmNpc13Wp6wwl+p6vpN3R
         ETUpZrK5m+SFtwGy8cKknOGHSThCZWAXNgKzokTBTDb36plDldtYBXVfUWucOZO4abs/
         z7WaXx9SJRbFDMlQJNh08vgzpdCyFr4nbRhRFHVEc5AmJpfeG5ASg2LtbyD26zAjntrl
         NDOQ==
In-Reply-To: <20210202184746.119084-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

There are two functions to flush the per-cpu data of an lruvec into
the rest of the cgroup tree: when the cgroup is being freed, and when
a CPU disappears during hotplug. The difference is whether all CPUs or
just one is being collected, but the rest of the flushing code is the
same. Merge them into one function and share the common code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 88 +++++++++++++++++++++++--------------------------
 1 file changed, 42 insertions(+), 46 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b205b2413186..88e8afc49a46 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2410,39 +2410,56 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 	mutex_unlock(&percpu_charge_mutex);
 }
 
-static int memcg_hotplug_cpu_dead(unsigned int cpu)
+static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg, int cpu)
 {
-	struct memcg_stock_pcp *stock;
-	struct mem_cgroup *memcg;
-
-	stock = &per_cpu(memcg_stock, cpu);
-	drain_stock(stock);
+	int nid;
 
-	for_each_mem_cgroup(memcg) {
+	for_each_node(nid) {
+		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
+		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = { 0, };
+		struct batched_lruvec_stat *lstatc;
 		int i;
 
-		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			int nid;
-
-			for_each_node(nid) {
-				struct batched_lruvec_stat *lstatc;
-				struct mem_cgroup_per_node *pn;
-				long x;
-
-				pn = memcg->nodeinfo[nid];
+		if (cpu == -1) {
+			int cpui;
+			/*
+			 * The memcg is about to be freed, collect all
+			 * CPUs, no need to zero anything out.
+			 */
+			for_each_online_cpu(cpui) {
+				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpui);
+				for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+					stat[i] += lstatc->count[i];
+			}
+		} else {
+			/*
+			 * The CPU has gone away, collect and zero out
+			 * its stats, it may come back later.
+			 */
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
-
-				x = lstatc->count[i];
+				stat[i] = lstatc->count[i];
 				lstatc->count[i] = 0;
-
-				if (x) {
-					do {
-						atomic_long_add(x, &pn->lruvec_stat[i]);
-					} while ((pn = parent_nodeinfo(pn, nid)));
-				}
 			}
 		}
+
+		do {
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+				atomic_long_add(stat[i], &pn->lruvec_stat[i]);
+		} while ((pn = parent_nodeinfo(pn, nid)));
 	}
+}
+
+static int memcg_hotplug_cpu_dead(unsigned int cpu)
+{
+	struct memcg_stock_pcp *stock;
+	struct mem_cgroup *memcg;
+
+	stock = &per_cpu(memcg_stock, cpu);
+	drain_stock(stock);
+
+	for_each_mem_cgroup(memcg)
+		memcg_flush_lruvec_page_state(memcg, cpu);
 
 	return 0;
 }
@@ -3636,27 +3653,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	}
 }
 
-static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg)
-{
-	int node;
-
-	for_each_node(node) {
-		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
-		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = {0, };
-		struct mem_cgroup_per_node *pi;
-		int cpu, i;
-
-		for_each_online_cpu(cpu)
-			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-				stat[i] += per_cpu(
-					pn->lruvec_stat_cpu->count[i], cpu);
-
-		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
-			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
-				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
-	}
-}
-
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -5197,7 +5193,7 @@ static void mem_cgroup_free(struct mem_cgroup *memcg)
 	 * Flush percpu lruvec stats to guarantee the value
 	 * correctness on parent's and all ancestor levels.
 	 */
-	memcg_flush_lruvec_page_state(memcg);
+	memcg_flush_lruvec_page_state(memcg, -1);
 	__mem_cgroup_free(memcg);
 }
 
-- 
2.30.0

