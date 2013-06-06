From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v11 13/25] shrinker: add node awareness
Date: Fri,  7 Jun 2013 00:34:46 +0400
Message-ID: <1370550898-26711-14-git-send-email-glommer@openvz.org>
References: <1370550898-26711-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370550898-26711-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mhocko-Y4LbUc7mvzI@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Pass the node of the current zone being reclaimed to shrink_slab(),
allowing the shrinker control nodemask to be set appropriately for
node aware shrinkers.

[ v3: update ashmem ]
Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
---
 drivers/staging/android/ashmem.c |  3 +++
 fs/drop_caches.c                 |  1 +
 include/linux/shrinker.h         |  3 +++
 mm/memory-failure.c              |  2 ++
 mm/vmscan.c                      | 11 ++++++++---
 5 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 21a3f72..65f36d7 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -692,6 +692,9 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				.gfp_mask = GFP_KERNEL,
 				.nr_to_scan = 0,
 			};
+
+			nodes_setall(sc.nodes_to_scan);
+
 			ret = ashmem_shrink(&ashmem_shrinker, &sc);
 			sc.nr_to_scan = ret;
 			ashmem_shrink(&ashmem_shrinker, &sc);
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c00e055..9fd702f 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -44,6 +44,7 @@ static void drop_slab(void)
 		.gfp_mask = GFP_KERNEL,
 	};
 
+	nodes_setall(shrink.nodes_to_scan);
 	do {
 		nr_objects = shrink_slab(&shrink, 1000, 1000);
 	} while (nr_objects > 10);
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 884e762..76f520c 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -16,6 +16,9 @@ struct shrink_control {
 
 	/* How many slab objects shrinker() should scan and try to reclaim */
 	unsigned long nr_to_scan;
+
+	/* shrink from these nodes */
+	nodemask_t nodes_to_scan;
 };
 
 #define SHRINK_STOP (~0UL)
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2c13aa7..09ae111 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -248,10 +248,12 @@ void shake_page(struct page *p, int access)
 	 */
 	if (access) {
 		int nr;
+		int nid = page_to_nid(p);
 		do {
 			struct shrink_control shrink = {
 				.gfp_mask = GFP_KERNEL,
 			};
+			node_set(nid, shrink.nodes_to_scan);
 
 			nr = shrink_slab(&shrink, 1000, 1000);
 			if (page_count(p) == 1)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index dfc5685..f39cae0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2385,12 +2385,16 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 */
 		if (global_reclaim(sc)) {
 			unsigned long lru_pages = 0;
+
+			nodes_clear(shrink->nodes_to_scan);
 			for_each_zone_zonelist(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask)) {
 				if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
 					continue;
 
 				lru_pages += zone_reclaimable_pages(zone);
+				node_set(zone_to_nid(zone),
+					 shrink->nodes_to_scan);
 			}
 
 			shrink_slab(shrink, sc->nr_scanned, lru_pages);
@@ -2847,6 +2851,8 @@ static bool kswapd_shrink_zone(struct zone *zone,
 		return true;
 
 	shrink_zone(zone, sc);
+	nodes_clear(shrink.nodes_to_scan);
+	node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 
 	reclaim_state->reclaimed_slab = 0;
 	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
@@ -3555,10 +3561,9 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * number of slab pages and shake the slab until it is reduced
 		 * by the same nr_pages that we used for reclaiming unmapped
 		 * pages.
-		 *
-		 * Note that shrink_slab will free memory on all zones and may
-		 * take a long time.
 		 */
+		nodes_clear(shrink.nodes_to_scan);
+		node_set(zone_to_nid(zone), shrink.nodes_to_scan);
 		for (;;) {
 			unsigned long lru_pages = zone_reclaimable_pages(zone);
 
-- 
1.8.1.4
