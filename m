From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: vmscan: count slab shrinking results after each shrink_slab()
Date: Mon, 19 Oct 2015 14:13:35 -0400
Message-ID: <1445278415-21138-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cb731d6 ("vmscan: per memory cgroup slab shrinkers") sought to
optimize accumulating slab reclaim results in sc->nr_reclaimed only
once per zone, but the memcg hierarchy walk itself uses
sc->nr_reclaimed as an exit condition. This can lead to overreclaim.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/vmscan.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 27d580b..a02654e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2441,11 +2441,18 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
 			zone_lru_pages += lru_pages;
 
-			if (memcg && is_classzone)
+			if (memcg && is_classzone) {
 				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
 					    memcg, sc->nr_scanned - scanned,
 					    lru_pages);
 
+				if (reclaim_state) {
+					sc->nr_reclaimed +=
+						reclaim_state->reclaimed_slab;
+					reclaim_state->reclaimed_slab = 0;
+				}
+			}
+
 			/*
 			 * Direct reclaim and kswapd have to scan all memory
 			 * cgroups to fulfill the overall scan target for the
@@ -2467,14 +2474,16 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
-		if (global_reclaim(sc) && is_classzone)
+		if (global_reclaim(sc) && is_classzone) {
 			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
 				    sc->nr_scanned - nr_scanned,
 				    zone_lru_pages);
 
-		if (reclaim_state) {
-			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-			reclaim_state->reclaimed_slab = 0;
+			if (reclaim_state) {
+				sc->nr_reclaimed +=
+					reclaim_state->reclaimed_slab;
+				reclaim_state->reclaimed_slab = 0;
+			}
 		}
 
 		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
-- 
2.6.1
