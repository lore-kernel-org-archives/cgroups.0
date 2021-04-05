From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 07/11] mm: Account the total top tier memory in use
Date: Mon,  5 Apr 2021 10:08:31 -0700
Message-ID: <9170c90b0f58dee05a2b2c1d3789d674df42ed65.1617642417.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Track the global top tier memory usage stats. They are used as the basis of
deciding when to start demoting pages from memory cgroups that have exceeded
their soft limit.  We start reclaiming top tier memory when the total
top tier memory is low.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/vmstat.h | 18 ++++++++++++++++++
 mm/vmstat.c            | 20 +++++++++++++++++---
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index e1a4fa9abb3a..a3ad5a937fd8 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -139,6 +139,7 @@ static inline void vm_events_fold_cpu(int cpu)
  * Zone and node-based page accounting with per cpu differentials.
  */
 extern atomic_long_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS];
+extern atomic_long_t vm_toptier_zone_stat[NR_VM_ZONE_STAT_ITEMS];
 extern atomic_long_t vm_numa_stat[NR_VM_NUMA_STAT_ITEMS];
 extern atomic_long_t vm_node_stat[NR_VM_NODE_STAT_ITEMS];
 
@@ -175,6 +176,8 @@ static inline void zone_page_state_add(long x, struct zone *zone,
 {
 	atomic_long_add(x, &zone->vm_stat[item]);
 	atomic_long_add(x, &vm_zone_stat[item]);
+	if (node_state(zone->zone_pgdat->node_id, N_TOPTIER))
+		atomic_long_add(x, &vm_toptier_zone_stat[item]);
 }
 
 static inline void node_page_state_add(long x, struct pglist_data *pgdat,
@@ -212,6 +215,17 @@ static inline unsigned long global_node_page_state(enum node_stat_item item)
 	return global_node_page_state_pages(item);
 }
 
+static inline unsigned long global_toptier_zone_page_state(enum zone_stat_item item)
+{
+	long x = atomic_long_read(&vm_toptier_zone_stat[item]);
+
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 static inline unsigned long zone_page_state(struct zone *zone,
 					enum zone_stat_item item)
 {
@@ -325,6 +339,8 @@ static inline void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	atomic_long_inc(&zone->vm_stat[item]);
 	atomic_long_inc(&vm_zone_stat[item]);
+	if (node_state(zone->zone_pgdat->node_id, N_TOPTIER))
+		atomic_long_inc(&vm_toptier_zone_stat[item]);
 }
 
 static inline void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -337,6 +353,8 @@ static inline void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 {
 	atomic_long_dec(&zone->vm_stat[item]);
 	atomic_long_dec(&vm_zone_stat[item]);
+	if (node_state(zone->zone_pgdat->node_id, N_TOPTIER))
+		atomic_long_dec(&vm_toptier_zone_stat[item]);
 }
 
 static inline void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f299d2e89acb..b59efbcaef4e 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -161,9 +161,11 @@ void vm_events_fold_cpu(int cpu)
  * vm_stat contains the global counters
  */
 atomic_long_t vm_zone_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
+atomic_long_t vm_toptier_zone_stat[NR_VM_ZONE_STAT_ITEMS] __cacheline_aligned_in_smp;
 atomic_long_t vm_numa_stat[NR_VM_NUMA_STAT_ITEMS] __cacheline_aligned_in_smp;
 atomic_long_t vm_node_stat[NR_VM_NODE_STAT_ITEMS] __cacheline_aligned_in_smp;
 EXPORT_SYMBOL(vm_zone_stat);
+EXPORT_SYMBOL(vm_toptier_zone_stat);
 EXPORT_SYMBOL(vm_numa_stat);
 EXPORT_SYMBOL(vm_node_stat);
 
@@ -695,7 +697,7 @@ EXPORT_SYMBOL(dec_node_page_state);
  * Returns the number of counters updated.
  */
 #ifdef CONFIG_NUMA
-static int fold_diff(int *zone_diff, int *numa_diff, int *node_diff)
+static int fold_diff(int *zone_diff, int *numa_diff, int *node_diff, int *toptier_diff)
 {
 	int i;
 	int changes = 0;
@@ -717,6 +719,11 @@ static int fold_diff(int *zone_diff, int *numa_diff, int *node_diff)
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
 			changes++;
 	}
+
+	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
+		if (toptier_diff[i]) {
+			atomic_long_add(toptier_diff[i], &vm_toptier_zone_stat[i]);
+	}
 	return changes;
 }
 #else
@@ -762,6 +769,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 	struct zone *zone;
 	int i;
 	int global_zone_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
+	int global_toptier_diff[NR_VM_ZONE_STAT_ITEMS] = { 0, };
 #ifdef CONFIG_NUMA
 	int global_numa_diff[NR_VM_NUMA_STAT_ITEMS] = { 0, };
 #endif
@@ -779,6 +787,9 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 
 				atomic_long_add(v, &zone->vm_stat[i]);
 				global_zone_diff[i] += v;
+				if (node_state(zone->zone_pgdat->node_id, N_TOPTIER)) {
+					global_toptier_diff[i] +=v;
+				}
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
 				__this_cpu_write(p->expire, 3);
@@ -846,7 +857,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
 
 #ifdef CONFIG_NUMA
 	changes += fold_diff(global_zone_diff, global_numa_diff,
-			     global_node_diff);
+			     global_node_diff, global_toptier_diff);
 #else
 	changes += fold_diff(global_zone_diff, global_node_diff);
 #endif
@@ -868,6 +879,7 @@ void cpu_vm_stats_fold(int cpu)
 	int global_numa_diff[NR_VM_NUMA_STAT_ITEMS] = { 0, };
 #endif
 	int global_node_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
+	int global_toptier_diff[NR_VM_NODE_STAT_ITEMS] = { 0, };
 
 	for_each_populated_zone(zone) {
 		struct per_cpu_pageset *p;
@@ -910,11 +922,13 @@ void cpu_vm_stats_fold(int cpu)
 				p->vm_node_stat_diff[i] = 0;
 				atomic_long_add(v, &pgdat->vm_stat[i]);
 				global_node_diff[i] += v;
+				if (node_state(pgdat->node_id, N_TOPTIER))
+					global_toptier_diff[i] +=v;
 			}
 	}
 
 #ifdef CONFIG_NUMA
-	fold_diff(global_zone_diff, global_numa_diff, global_node_diff);
+	fold_diff(global_zone_diff, global_numa_diff, global_node_diff, global_toptier_diff);
 #else
 	fold_diff(global_zone_diff, global_node_diff);
 #endif
-- 
2.20.1

