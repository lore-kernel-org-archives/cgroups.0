From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 7/8] mm: memcontrol: consolidate lruvec stat flushing
Date: Fri,  5 Feb 2021 13:28:05 -0500
Message-ID: <20210205182806.17220-8-hannes@cmpxchg.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NkGochaaRcmTlyZxkCgRxNgKhbX45qwASpGU1xNehx0=;
        b=0F6KH20bviGrQNM9hbNvSXi7Vk/KA9cDm/VECQSQnHEPGSsqEZRI0RBWRVQ6p7HnxD
         kC8C0UB7VSTJzFNjkBOtg4VH27hzXIAf2zYhcPeZ+v+UP273dW65hwzx7s1q0zHV9zuE
         6vfEBaxgqx27Nni6gCcAWoGeoPzLDvXiXlOZTA9n3Z6qpCthBOX9QIdwNhwPDX36/zpY
         bL4fcNoSLRdYjOitEDTdeTKEkerao0KI7iYwRLfbfjEzu0FaMeyPFq93DsS1foVkMa5C
         iVzRPcKT76qsfJIiN0d/uMOZ0uR77juU+76rJpaWEPDpmJM4ewdbqq1FxIf6bknXkOCX
         bD1g==
In-Reply-To: <20210205182806.17220-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

There are two functions to flush the per-cpu data of an lruvec into
the rest of the cgroup tree: when the cgroup is being freed, and when
a CPU disappears during hotplug. The difference is whether all CPUs or
just one is being collected, but the rest of the flushing code is the
same. Merge them into one function and share the common code.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 74 +++++++++++++++++++------------------------------
 1 file changed, 28 insertions(+), 46 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5dc0bd53b64a..490357945f2c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2410,39 +2410,39 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
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
+		unsigned long stat[NR_VM_NODE_STAT_ITEMS];
+		struct batched_lruvec_stat *lstatc;
 		int i;
 
+		lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			int nid;
+			stat[i] = lstatc->count[i];
+			lstatc->count[i] = 0;
+		}
 
-			for_each_node(nid) {
-				struct batched_lruvec_stat *lstatc;
-				struct mem_cgroup_per_node *pn;
-				long x;
+		do {
+			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
+				atomic_long_add(stat[i], &pn->lruvec_stat[i]);
+		} while ((pn = parent_nodeinfo(pn, nid)));
+	}
+}
 
-				pn = memcg->nodeinfo[nid];
-				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
+static int memcg_hotplug_cpu_dead(unsigned int cpu)
+{
+	struct memcg_stock_pcp *stock;
+	struct mem_cgroup *memcg;
 
-				x = lstatc->count[i];
-				lstatc->count[i] = 0;
+	stock = &per_cpu(memcg_stock, cpu);
+	drain_stock(stock);
 
-				if (x) {
-					do {
-						atomic_long_add(x, &pn->lruvec_stat[i]);
-					} while ((pn = parent_nodeinfo(pn, nid)));
-				}
-			}
-		}
-	}
+	for_each_mem_cgroup(memcg)
+		memcg_flush_lruvec_page_state(memcg, cpu);
 
 	return 0;
 }
@@ -3636,27 +3636,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	}
 }
 
-static void memcg_flush_lruvec_page_state(struct mem_cgroup *memcg)
-{
-	int node;
-
-	for_each_node(node) {
-		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
-		unsigned long stat[NR_VM_NODE_STAT_ITEMS] = { 0 };
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
@@ -5192,12 +5171,15 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
+	int cpu;
+
 	memcg_wb_domain_exit(memcg);
 	/*
 	 * Flush percpu lruvec stats to guarantee the value
 	 * correctness on parent's and all ancestor levels.
 	 */
-	memcg_flush_lruvec_page_state(memcg);
+	for_each_online_cpu(cpu)
+		memcg_flush_lruvec_page_state(memcg, cpu);
 	__mem_cgroup_free(memcg);
 }
 
-- 
2.30.0

