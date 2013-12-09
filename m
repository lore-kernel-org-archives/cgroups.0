From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v13 05/16] vmscan: move call to shrink_slab() to shrink_zones()
Date: Mon, 9 Dec 2013 12:05:46 +0400
Message-ID: <71c7c5bbcad2e29f81eaf9eaad36c120815125c8.1386571280.git.vdavydov@parallels.com>
References: <cover.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1386571280.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This reduces the indentation level of do_try_to_free_pages() and removes
extra loop over all eligible zones counting the number of on-LRU pages.

Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/vmscan.c |   57 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 26 insertions(+), 31 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eea668d..035ab3a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2273,13 +2273,17 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
  * the caller that it should consider retrying the allocation instead of
  * further reclaim.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static bool shrink_zones(struct zonelist *zonelist,
+			 struct scan_control *sc,
+			 struct shrink_control *shrink)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	unsigned long lru_pages = 0;
 	bool aborted_reclaim = false;
+	struct reclaim_state *reclaim_state = current->reclaim_state;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2289,6 +2293,8 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	if (buffer_heads_over_limit)
 		sc->gfp_mask |= __GFP_HIGHMEM;
 
+	nodes_clear(shrink->nodes_to_scan);
+
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
 		if (!populated_zone(zone))
@@ -2300,6 +2306,10 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		if (global_reclaim(sc)) {
 			if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 				continue;
+
+			lru_pages += zone_reclaimable_pages(zone);
+			node_set(zone_to_nid(zone), shrink->nodes_to_scan);
+
 			if (sc->priority != DEF_PRIORITY &&
 			    !zone_reclaimable(zone))
 				continue;	/* Let kswapd poll it */
@@ -2336,6 +2346,20 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		shrink_zone(zone, sc);
 	}
 
+	/*
+	 * Don't shrink slabs when reclaiming memory from over limit
+	 * cgroups but do shrink slab at least once when aborting
+	 * reclaim for compaction to avoid unevenly scanning file/anon
+	 * LRU pages over slab pages.
+	 */
+	if (global_reclaim(sc)) {
+		shrink_slab(shrink, sc->nr_scanned, lru_pages);
+		if (reclaim_state) {
+			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+			reclaim_state->reclaimed_slab = 0;
+		}
+	}
+
 	return aborted_reclaim;
 }
 
@@ -2380,9 +2404,6 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 					struct shrink_control *shrink)
 {
 	unsigned long total_scanned = 0;
-	struct reclaim_state *reclaim_state = current->reclaim_state;
-	struct zoneref *z;
-	struct zone *zone;
 	unsigned long writeback_threshold;
 	bool aborted_reclaim;
 
@@ -2395,34 +2416,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		aborted_reclaim = shrink_zones(zonelist, sc);
-
-		/*
-		 * Don't shrink slabs when reclaiming memory from over limit
-		 * cgroups but do shrink slab at least once when aborting
-		 * reclaim for compaction to avoid unevenly scanning file/anon
-		 * LRU pages over slab pages.
-		 */
-		if (global_reclaim(sc)) {
-			unsigned long lru_pages = 0;
+		aborted_reclaim = shrink_zones(zonelist, sc, shrink);
 
-			nodes_clear(shrink->nodes_to_scan);
-			for_each_zone_zonelist(zone, z, zonelist,
-					gfp_zone(sc->gfp_mask)) {
-				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
-					continue;
-
-				lru_pages += zone_reclaimable_pages(zone);
-				node_set(zone_to_nid(zone),
-					 shrink->nodes_to_scan);
-			}
-
-			shrink_slab(shrink, sc->nr_scanned, lru_pages);
-			if (reclaim_state) {
-				sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-				reclaim_state->reclaimed_slab = 0;
-			}
-		}
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
 			goto out;
-- 
1.7.10.4
