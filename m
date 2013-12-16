From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v14 12/18] vmscan: shrink slab on memcg pressure
Date: Mon, 16 Dec 2013 16:17:01 +0400
Message-ID: <e77563b423f5d4675133548c4275af3c850390c7.1387193771.git.vdavydov@parallels.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1387193771.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

This patch makes direct reclaim path shrink slab not only on global
memory pressure, but also when we reach the user memory limit of a
memcg. To achieve that, it makes shrink_slab() walk over the memcg
hierarchy and run shrinkers marked as memcg-aware on the target memcg
and all its descendants. The memcg to scan is passed in a shrink_control
structure; memcg-unaware shrinkers are still called only on global
memory pressure with memcg=NULL. It is up to the shrinker how to
organize the objects it is responsible for to achieve per-memcg reclaim.

Note that we do not intend to have true per memcg per node reclaim.
Since most memcgs are small and typically confined to a single NUMA node
or two by external means and therefore do not need the scalability NUMA
aware shrinkers provide, we actually call per node shrinking only for
the global list (memcg=NULL), while per-memcg lists are always scanned
only once irrespective of the nodemask with nid=0.

The idea lying behind the patch as well as the initial implementation
belong to Glauber Costa.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/memcontrol.h |   22 ++++++++++
 include/linux/shrinker.h   |   10 ++++-
 mm/memcontrol.c            |   37 ++++++++++++++++-
 mm/vmscan.c                |   95 ++++++++++++++++++++++++++++++++++----------
 4 files changed, 142 insertions(+), 22 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e3efab2..6001b31 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -95,6 +95,9 @@ extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
 
+unsigned long mem_cgroup_zone_reclaimable_pages(struct zone *,
+						struct mem_cgroup *);
+
 /* For coalescing uncharge for reducing memcg' overhead*/
 extern void mem_cgroup_uncharge_start(void);
 extern void mem_cgroup_uncharge_end(void);
@@ -304,6 +307,12 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
 	return &zone->lruvec;
 }
 
+static inline unsigned long mem_cgroup_zone_reclaimable_pages(struct zone *zone,
+							struct mem_cgroup *)
+{
+	return 0;
+}
+
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	return NULL;
@@ -494,6 +503,9 @@ static inline bool memcg_kmem_enabled(void)
 	return static_key_false(&memcg_kmem_enabled_key);
 }
 
+bool memcg_kmem_is_active(struct mem_cgroup *memcg);
+bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg);
+
 /*
  * In general, we'll do everything in our power to not incur in any overhead
  * for non-memcg users for the kmem functions. Not even a function call, if we
@@ -635,6 +647,16 @@ static inline bool memcg_kmem_enabled(void)
 	return false;
 }
 
+static inline bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static inline bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 static inline bool
 memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
 {
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 68c0970..ab79b17 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -20,8 +20,15 @@ struct shrink_control {
 
 	/* shrink from these nodes */
 	nodemask_t nodes_to_scan;
+
+	/* shrink from this memory cgroup hierarchy (if not NULL) */
+	struct mem_cgroup *target_mem_cgroup;
+
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
+
+	/* current memcg being shrunk (for memcg aware shrinkers) */
+	struct mem_cgroup *memcg;
 };
 
 #define SHRINK_STOP (~0UL)
@@ -63,7 +70,8 @@ struct shrinker {
 #define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
 
 /* Flags */
-#define SHRINKER_NUMA_AWARE (1 << 0)
+#define SHRINKER_NUMA_AWARE	(1 << 0)
+#define SHRINKER_MEMCG_AWARE	(1 << 1)
 
 extern int register_shrinker(struct shrinker *);
 extern void unregister_shrinker(struct shrinker *);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f2372b0..13b3131 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -353,7 +353,7 @@ static inline void memcg_kmem_set_active(struct mem_cgroup *memcg)
 	set_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
 
-static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
+bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 {
 	return test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags);
 }
@@ -1303,6 +1303,26 @@ out:
 	return lruvec;
 }
 
+unsigned long mem_cgroup_zone_reclaimable_pages(struct zone *zone,
+						struct mem_cgroup *memcg)
+{
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
+	unsigned long nr = 0;
+	struct mem_cgroup *iter;
+
+	iter = memcg;
+	do {
+		nr += mem_cgroup_zone_nr_lru_pages(iter, nid, zid,
+						   LRU_ALL_FILE);
+		if (do_swap_account)
+			nr += mem_cgroup_zone_nr_lru_pages(iter, nid, zid,
+							   LRU_ALL_ANON);
+		iter = mem_cgroup_iter(memcg, iter, NULL);
+	} while (iter);
+	return nr;
+}
+
 /*
  * Following LRU functions are allowed to be used without PCG_LOCK.
  * Operations are called by routine of global LRU independently from memcg.
@@ -2932,6 +2952,21 @@ static inline bool memcg_can_account_kmem(struct mem_cgroup *memcg)
 		memcg_kmem_is_active(memcg);
 }
 
+bool memcg_kmem_should_reclaim(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *iter;
+
+	iter = memcg;
+	do {
+		if (memcg_kmem_is_active(iter)) {
+			mem_cgroup_iter_break(memcg, iter);
+			return true;
+		}
+		iter = mem_cgroup_iter(memcg, iter, NULL);
+	} while (iter);
+	return false;
+}
+
 /*
  * helper for acessing a memcg's index. It will be used as an index in the
  * child cache array in kmem_cache, and also to derive its name. This function
diff --git a/mm/vmscan.c b/mm/vmscan.c
index d98f272..67c1950 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -311,6 +311,34 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	return freed;
 }
 
+static unsigned long
+run_shrinker(struct shrink_control *shrinkctl, struct shrinker *shrinker,
+	     unsigned long nr_pages_scanned, unsigned long lru_pages)
+{
+	unsigned long freed = 0;
+
+	/*
+	 * Since most memory cgroups are small and typically confined to a
+	 * single NUMA node or two by external means and therefore do not need
+	 * the scalability NUMA aware shrinkers provide, we implement per node
+	 * shrinking only for the global list.
+	 */
+	if (!(shrinker->flags & SHRINKER_NUMA_AWARE) ||
+	    shrinkctl->memcg) {
+		shrinkctl->nid = 0;
+		return shrink_slab_node(shrinkctl, shrinker,
+					nr_pages_scanned, lru_pages);
+	}
+
+	for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
+		if (node_online(shrinkctl->nid))
+			freed += shrink_slab_node(shrinkctl, shrinker,
+						  nr_pages_scanned, lru_pages);
+
+	}
+	return freed;
+}
+
 /*
  * Call the shrink functions to age shrinkable caches
  *
@@ -352,20 +380,34 @@ unsigned long shrink_slab(struct shrink_control *shrinkctl,
 	}
 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
-		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
-			shrinkctl->nid = 0;
-			freed += shrink_slab_node(shrinkctl, shrinker,
-					nr_pages_scanned, lru_pages);
+		/*
+		 * Call memcg-unaware shrinkers only on global pressure.
+		 */
+		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE)) {
+			if (!shrinkctl->target_mem_cgroup) {
+				shrinkctl->memcg = NULL;
+				freed += run_shrinker(shrinkctl, shrinker,
+						nr_pages_scanned, lru_pages);
+			}
 			continue;
 		}
 
-		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
-			if (node_online(shrinkctl->nid))
-				freed += shrink_slab_node(shrinkctl, shrinker,
+		/*
+		 * For memcg-aware shrinkers iterate over the target memcg
+		 * hierarchy and run the shrinker on each kmem-active memcg
+		 * found in the hierarchy.
+		 */
+		shrinkctl->memcg = shrinkctl->target_mem_cgroup;
+		do {
+			if (!shrinkctl->memcg ||
+			    memcg_kmem_is_active(shrinkctl->memcg))
+				freed += run_shrinker(shrinkctl, shrinker,
 						nr_pages_scanned, lru_pages);
-
-		}
+		} while ((shrinkctl->memcg =
+			  mem_cgroup_iter(shrinkctl->target_mem_cgroup,
+					  shrinkctl->memcg, NULL)) != NULL);
 	}
+
 	up_read(&shrinker_rwsem);
 out:
 	cond_resched();
@@ -2286,6 +2328,7 @@ static bool shrink_zones(struct zonelist *zonelist,
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct shrink_control shrink = {
 		.gfp_mask = sc->gfp_mask,
+		.target_mem_cgroup = sc->target_mem_cgroup,
 	};
 
 	/*
@@ -2302,17 +2345,22 @@ static bool shrink_zones(struct zonelist *zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
 			continue;
+
+		if (global_reclaim(sc) &&
+		    !cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
+			continue;
+
+		lru_pages += global_reclaim(sc) ?
+				zone_reclaimable_pages(zone) :
+				mem_cgroup_zone_reclaimable_pages(zone,
+						sc->target_mem_cgroup);
+		node_set(zone_to_nid(zone), shrink.nodes_to_scan);
+
 		/*
 		 * Take care memory controller reclaiming has small influence
 		 * to global LRU.
 		 */
 		if (global_reclaim(sc)) {
-			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-				continue;
-
-			lru_pages += zone_reclaimable_pages(zone);
-			node_set(zone_to_nid(zone), shrink.nodes_to_scan);
-
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
@@ -2350,12 +2398,11 @@ static bool shrink_zones(struct zonelist *zonelist,
 	}
 
 	/*
-	 * Don't shrink slabs when reclaiming memory from over limit
-	 * cgroups but do shrink slab at least once when aborting
-	 * reclaim for compaction to avoid unevenly scanning file/anon
-	 * LRU pages over slab pages.
+	 * Shrink slabs at least once when aborting reclaim for compaction
+	 * to avoid unevenly scanning file/anon LRU pages over slab pages.
 	 */
-	if (global_reclaim(sc)) {
+	if (global_reclaim(sc) ||
+	    memcg_kmem_should_reclaim(sc->target_mem_cgroup)) {
 		shrink_slab(&shrink, sc->nr_scanned, lru_pages);
 		if (reclaim_state) {
 			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -2649,6 +2696,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist;
 	unsigned long nr_reclaimed;
 	int nid;
+	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
@@ -2671,6 +2719,10 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 
 	zonelist = NODE_DATA(nid)->node_zonelists;
 
+	lockdep_set_current_reclaim_state(sc.gfp_mask);
+	reclaim_state.reclaimed_slab = 0;
+	current->reclaim_state = &reclaim_state;
+
 	trace_mm_vmscan_memcg_reclaim_begin(0,
 					    sc.may_writepage,
 					    sc.gfp_mask);
@@ -2679,6 +2731,9 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
+	current->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
+
 	return nr_reclaimed;
 }
 #endif
-- 
1.7.10.4
