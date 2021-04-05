From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH v1 08/11] mm: Add toptier option for mem_cgroup_soft_limit_reclaim()
Date: Mon,  5 Apr 2021 10:08:32 -0700
Message-ID: <babf74082f450ece2fd55bd5ca9a1857fd32c307.1617642417.git.tim.c.chen@linux.intel.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Add toptier relcaim type in mem_cgroup_soft_limit_reclaim().
This option reclaims top tier memory from cgroups in the order of its
excess usage of top tier memory.

Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 include/linux/memcontrol.h |  9 ++++---
 mm/memcontrol.c            | 48 ++++++++++++++++++++++++--------------
 mm/vmscan.c                |  4 ++--
 3 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0ed8ddfd5436..c494c4b11ba2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -21,6 +21,7 @@
 #include <linux/vmstat.h>
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
+#include <linux/nodemask.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -1003,7 +1004,8 @@ static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
-						unsigned long *total_scanned);
+						unsigned long *total_scanned,
+						enum node_states type);
 
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count);
@@ -1421,8 +1423,9 @@ static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
-					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
+						gfp_t gfp_mask,
+						unsigned long *total_scanned,
+						enum node_states type)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8a7648b79635..9f75475ae833 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1875,7 +1875,8 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
 				   pg_data_t *pgdat,
 				   gfp_t gfp_mask,
-				   unsigned long *total_scanned)
+				   unsigned long *total_scanned,
+				   enum node_states type)
 {
 	struct mem_cgroup *victim = NULL;
 	int total = 0;
@@ -1886,7 +1887,7 @@ static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
 		.pgdat = pgdat,
 	};
 
-	excess = soft_limit_excess(root_memcg, N_MEMORY);
+	excess = soft_limit_excess(root_memcg, type);
 
 	while (1) {
 		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
@@ -1915,7 +1916,7 @@ static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
 		total += mem_cgroup_shrink_node(victim, gfp_mask, false,
 					pgdat, &nr_scanned);
 		*total_scanned += nr_scanned;
-		if (!soft_limit_excess(root_memcg, N_MEMORY))
+		if (!soft_limit_excess(root_memcg, type))
 			break;
 	}
 	mem_cgroup_iter_break(root_memcg, victim);
@@ -3524,7 +3525,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
-					    unsigned long *total_scanned)
+					    unsigned long *total_scanned,
+					    enum node_states type)
 {
 	unsigned long nr_reclaimed = 0;
 	struct mem_cgroup_per_node *mz, *next_mz = NULL;
@@ -3534,12 +3536,24 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	unsigned long excess;
 	unsigned long nr_scanned;
 	int migration_nid;
+	enum node_states sibling_type;
 
 	if (order > 0)
 		return 0;
 
-	mctz = soft_limit_tree_node(pgdat->node_id, N_MEMORY);
-	mctz_sibling = soft_limit_tree_node(pgdat->node_id, N_TOPTIER);
+	if (type != N_MEMORY && type != N_TOPTIER)
+		return 0;
+
+	if (type == N_TOPTIER && !node_state(pgdat->node_id, N_TOPTIER))
+		return 0;
+
+	if (type == N_TOPTIER)
+		sibling_type = N_MEMORY;
+	else
+		sibling_type = N_TOPTIER;
+
+	mctz = soft_limit_tree_node(pgdat->node_id, type);
+	mctz_sibling = soft_limit_tree_node(pgdat->node_id, sibling_type);
 
 	/*
 	 * Do not even bother to check the largest node if the root
@@ -3558,11 +3572,11 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 	if (migration_nid != -1) {
 		struct mem_cgroup_tree_per_node *mmctz;
 
-		mmctz = soft_limit_tree_node(migration_nid);
+		mmctz = soft_limit_tree_node(migration_nid, type);
 		if (mmctz && !RB_EMPTY_ROOT(&mmctz->rb_root)) {
 			pgdat = NODE_DATA(migration_nid);
 			return mem_cgroup_soft_limit_reclaim(pgdat, order,
-				gfp_mask, total_scanned);
+				gfp_mask, total_scanned, type);
 		}
 	}
 
@@ -3575,17 +3589,17 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		if (next_mz)
 			mz = next_mz;
 		else
-			mz = mem_cgroup_largest_soft_limit_node(mctz, N_MEMORY);
+			mz = mem_cgroup_largest_soft_limit_node(mctz, type);
 		if (!mz)
 			break;
 
 		nr_scanned = 0;
 		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
-						    gfp_mask, &nr_scanned);
+						    gfp_mask, &nr_scanned, type);
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
 		spin_lock_irq(&mctz->lock);
-		__mem_cgroup_remove_exceeded(mz, mctz, N_MEMORY);
+		__mem_cgroup_remove_exceeded(mz, mctz, type);
 
 		/*
 		 * If we failed to reclaim anything from this memory cgroup
@@ -3594,9 +3608,9 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		next_mz = NULL;
 		if (!reclaimed)
 			next_mz =
-			   __mem_cgroup_largest_soft_limit_node(mctz, N_MEMORY);
+			   __mem_cgroup_largest_soft_limit_node(mctz, type);
 
-		excess = soft_limit_excess(mz->memcg, N_MEMORY);
+		excess = soft_limit_excess(mz->memcg, type);
 		/*
 		 * One school of thought says that we should not add
 		 * back the node to the tree if reclaim returns 0.
@@ -3606,17 +3620,17 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 		 * term TODO.
 		 */
 		/* If excess == 0, no tree ops */
-		__mem_cgroup_insert_exceeded(mz, mctz, excess, N_MEMORY);
+		__mem_cgroup_insert_exceeded(mz, mctz, excess, type);
 		spin_unlock_irq(&mctz->lock);
 
 		/* update both affected N_MEMORY and N_TOPTIER trees */
 		if (mctz_sibling) {
 			spin_lock_irq(&mctz_sibling->lock);
 			__mem_cgroup_remove_exceeded(mz, mctz_sibling,
-						     N_TOPTIER);
-			excess = soft_limit_excess(mz->memcg, N_TOPTIER);
+						     sibling_type);
+			excess = soft_limit_excess(mz->memcg, sibling_type);
 			__mem_cgroup_insert_exceeded(mz, mctz, excess,
-						     N_TOPTIER);
+						     sibling_type);
 			spin_unlock_irq(&mctz_sibling->lock);
 		}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3b200b7170a9..11bb0c6fa524 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3134,7 +3134,7 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 			nr_soft_scanned = 0;
 			nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone->zone_pgdat,
 						sc->order, sc->gfp_mask,
-						&nr_soft_scanned);
+						&nr_soft_scanned, N_MEMORY);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
 			/* need some check for avoid more shrink_zone() */
@@ -3849,7 +3849,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		sc.nr_scanned = 0;
 		nr_soft_scanned = 0;
 		nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(pgdat, sc.order,
-						sc.gfp_mask, &nr_soft_scanned);
+						sc.gfp_mask, &nr_soft_scanned, N_MEMORY);
 		sc.nr_reclaimed += nr_soft_reclaimed;
 
 		/*
-- 
2.20.1

