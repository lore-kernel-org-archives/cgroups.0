From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 05/11] mm: vmscan: replace shrink_node() loop with a retry jump
Date: Mon,  3 Jun 2019 17:07:40 -0400
Message-ID: <20190603210746.15800-6-hannes@cmpxchg.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xjW+KHnHD//MqYRxY0A82usCY+qgrBu78W4ErXk80GU=;
        b=bc7TrWgTSGZgsPvNADkSHVc76wW+ddItC6br4BoP2u6J2Pd8x17XCsWC3tGSkAaHij
         oDcMSFJAURwkI1EsRGyUV04wA/UtJNTcgot7wyikPKZfLvqoi6mEr5mnVocvC0sTBFhE
         g0b3BThoDChYC55UwB0tCBNdqej7Q0Yz1Gli7Xn8kG9PLT/OKEki2zZyQkfL6rGKUnYs
         IhBE+6SRBybCA4Z4ALlC/2E8iG4/Lj7Ku4+nALz8YwsvMit9wJIScjmbYbcNW8nNdZNK
         TPuwsI7mqRB+pFgEWLd8ALXu3vRcJfmSXTvT9yk7gHuUaX/0bTi7PuDMoT/E+qB+7sUQ
         gyaw==
In-Reply-To: <20190603210746.15800-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Most of the function body is inside a loop, which imposes an
additional indentation and scoping level that makes the code a bit
hard to follow and modify.

The looping only happens in case of reclaim-compaction, which isn't
the common case. So rather than adding yet another function level to
the reclaim path and have every reclaim invocation go through a level
that only exists for one specific cornercase, use a retry goto.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 266 ++++++++++++++++++++++++++--------------------------
 1 file changed, 133 insertions(+), 133 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index afd5e2432a8e..304974481146 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2672,164 +2672,164 @@ static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
 static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 {
 	struct reclaim_state *reclaim_state = current->reclaim_state;
+	struct mem_cgroup *root = sc->target_mem_cgroup;
+	struct mem_cgroup_reclaim_cookie reclaim = {
+		.pgdat = pgdat,
+		.priority = sc->priority,
+	};
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
+	struct mem_cgroup *memcg;
 
-	do {
-		struct mem_cgroup *root = sc->target_mem_cgroup;
-		struct mem_cgroup_reclaim_cookie reclaim = {
-			.pgdat = pgdat,
-			.priority = sc->priority,
-		};
-		struct mem_cgroup *memcg;
-
-		memset(&sc->nr, 0, sizeof(sc->nr));
+again:
+	memset(&sc->nr, 0, sizeof(sc->nr));
 
-		nr_reclaimed = sc->nr_reclaimed;
-		nr_scanned = sc->nr_scanned;
+	nr_reclaimed = sc->nr_reclaimed;
+	nr_scanned = sc->nr_scanned;
 
-		memcg = mem_cgroup_iter(root, NULL, &reclaim);
-		do {
-			unsigned long reclaimed;
-			unsigned long scanned;
+	memcg = mem_cgroup_iter(root, NULL, &reclaim);
+	do {
+		unsigned long reclaimed;
+		unsigned long scanned;
 
-			switch (mem_cgroup_protected(root, memcg)) {
-			case MEMCG_PROT_MIN:
-				/*
-				 * Hard protection.
-				 * If there is no reclaimable memory, OOM.
-				 */
+		switch (mem_cgroup_protected(root, memcg)) {
+		case MEMCG_PROT_MIN:
+			/*
+			 * Hard protection.
+			 * If there is no reclaimable memory, OOM.
+			 */
+			continue;
+		case MEMCG_PROT_LOW:
+			/*
+			 * Soft protection.
+			 * Respect the protection only as long as
+			 * there is an unprotected supply
+			 * of reclaimable memory from other cgroups.
+			 */
+			if (!sc->memcg_low_reclaim) {
+				sc->memcg_low_skipped = 1;
 				continue;
-			case MEMCG_PROT_LOW:
-				/*
-				 * Soft protection.
-				 * Respect the protection only as long as
-				 * there is an unprotected supply
-				 * of reclaimable memory from other cgroups.
-				 */
-				if (!sc->memcg_low_reclaim) {
-					sc->memcg_low_skipped = 1;
-					continue;
-				}
-				memcg_memory_event(memcg, MEMCG_LOW);
-				break;
-			case MEMCG_PROT_NONE:
-				/*
-				 * All protection thresholds breached. We may
-				 * still choose to vary the scan pressure
-				 * applied based on by how much the cgroup in
-				 * question has exceeded its protection
-				 * thresholds (see get_scan_count).
-				 */
-				break;
 			}
-
-			reclaimed = sc->nr_reclaimed;
-			scanned = sc->nr_scanned;
-			shrink_node_memcg(pgdat, memcg, sc);
-
-			if (sc->may_shrinkslab) {
-				shrink_slab(sc->gfp_mask, pgdat->node_id,
-				    memcg, sc->priority);
-			}
-
-			/* Record the group's reclaim efficiency */
-			vmpressure(sc->gfp_mask, memcg, false,
-				   sc->nr_scanned - scanned,
-				   sc->nr_reclaimed - reclaimed);
-
+			memcg_memory_event(memcg, MEMCG_LOW);
+			break;
+		case MEMCG_PROT_NONE:
 			/*
-			 * Kswapd have to scan all memory cgroups to fulfill
-			 * the overall scan target for the node.
-			 *
-			 * Limit reclaim, on the other hand, only cares about
-			 * nr_to_reclaim pages to be reclaimed and it will
-			 * retry with decreasing priority if one round over the
-			 * whole hierarchy is not sufficient.
+			 * All protection thresholds breached. We may
+			 * still choose to vary the scan pressure
+			 * applied based on by how much the cgroup in
+			 * question has exceeded its protection
+			 * thresholds (see get_scan_count).
 			 */
-			if (!current_is_kswapd() &&
-					sc->nr_reclaimed >= sc->nr_to_reclaim) {
-				mem_cgroup_iter_break(root, memcg);
-				break;
-			}
-		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
+			break;
+		}
+
+		reclaimed = sc->nr_reclaimed;
+		scanned = sc->nr_scanned;
+		shrink_node_memcg(pgdat, memcg, sc);
 
-		if (reclaim_state) {
-			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
-			reclaim_state->reclaimed_slab = 0;
+		if (sc->may_shrinkslab) {
+			shrink_slab(sc->gfp_mask, pgdat->node_id,
+				    memcg, sc->priority);
 		}
 
-		/* Record the subtree's reclaim efficiency */
-		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
-			   sc->nr_scanned - nr_scanned,
-			   sc->nr_reclaimed - nr_reclaimed);
+		/* Record the group's reclaim efficiency */
+		vmpressure(sc->gfp_mask, memcg, false,
+			   sc->nr_scanned - scanned,
+			   sc->nr_reclaimed - reclaimed);
 
-		if (sc->nr_reclaimed - nr_reclaimed)
-			reclaimable = true;
+		/*
+		 * Kswapd have to scan all memory cgroups to fulfill
+		 * the overall scan target for the node.
+		 *
+		 * Limit reclaim, on the other hand, only cares about
+		 * nr_to_reclaim pages to be reclaimed and it will
+		 * retry with decreasing priority if one round over the
+		 * whole hierarchy is not sufficient.
+		 */
+		if (!current_is_kswapd() &&
+		    sc->nr_reclaimed >= sc->nr_to_reclaim) {
+			mem_cgroup_iter_break(root, memcg);
+			break;
+		}
+	} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
 
-		if (current_is_kswapd()) {
-			/*
-			 * If reclaim is isolating dirty pages under writeback,
-			 * it implies that the long-lived page allocation rate
-			 * is exceeding the page laundering rate. Either the
-			 * global limits are not being effective at throttling
-			 * processes due to the page distribution throughout
-			 * zones or there is heavy usage of a slow backing
-			 * device. The only option is to throttle from reclaim
-			 * context which is not ideal as there is no guarantee
-			 * the dirtying process is throttled in the same way
-			 * balance_dirty_pages() manages.
-			 *
-			 * Once a node is flagged PGDAT_WRITEBACK, kswapd will
-			 * count the number of pages under pages flagged for
-			 * immediate reclaim and stall if any are encountered
-			 * in the nr_immediate check below.
-			 */
-			if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
-				set_bit(PGDAT_WRITEBACK, &pgdat->flags);
+	if (reclaim_state) {
+		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
+		reclaim_state->reclaimed_slab = 0;
+	}
 
-			/*
-			 * Tag a node as congested if all the dirty pages
-			 * scanned were backed by a congested BDI and
-			 * wait_iff_congested will stall.
-			 */
-			if (sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
-				set_bit(PGDAT_CONGESTED, &pgdat->flags);
+	/* Record the subtree's reclaim efficiency */
+	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+		   sc->nr_scanned - nr_scanned,
+		   sc->nr_reclaimed - nr_reclaimed);
 
-			/* Allow kswapd to start writing pages during reclaim.*/
-			if (sc->nr.unqueued_dirty == sc->nr.file_taken)
-				set_bit(PGDAT_DIRTY, &pgdat->flags);
+	if (sc->nr_reclaimed - nr_reclaimed)
+		reclaimable = true;
 
-			/*
-			 * If kswapd scans pages marked marked for immediate
-			 * reclaim and under writeback (nr_immediate), it
-			 * implies that pages are cycling through the LRU
-			 * faster than they are written so also forcibly stall.
-			 */
-			if (sc->nr.immediate)
-				congestion_wait(BLK_RW_ASYNC, HZ/10);
-		}
+	if (current_is_kswapd()) {
+		/*
+		 * If reclaim is isolating dirty pages under writeback,
+		 * it implies that the long-lived page allocation rate
+		 * is exceeding the page laundering rate. Either the
+		 * global limits are not being effective at throttling
+		 * processes due to the page distribution throughout
+		 * zones or there is heavy usage of a slow backing
+		 * device. The only option is to throttle from reclaim
+		 * context which is not ideal as there is no guarantee
+		 * the dirtying process is throttled in the same way
+		 * balance_dirty_pages() manages.
+		 *
+		 * Once a node is flagged PGDAT_WRITEBACK, kswapd will
+		 * count the number of pages under pages flagged for
+		 * immediate reclaim and stall if any are encountered
+		 * in the nr_immediate check below.
+		 */
+		if (sc->nr.writeback && sc->nr.writeback == sc->nr.taken)
+			set_bit(PGDAT_WRITEBACK, &pgdat->flags);
 
 		/*
-		 * Legacy memcg will stall in page writeback so avoid forcibly
-		 * stalling in wait_iff_congested().
+		 * Tag a node as congested if all the dirty pages
+		 * scanned were backed by a congested BDI and
+		 * wait_iff_congested will stall.
 		 */
-		if (cgroup_reclaim(sc) && writeback_working(sc) &&
-		    sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
-			set_memcg_congestion(pgdat, root, true);
+		if (sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
+			set_bit(PGDAT_CONGESTED, &pgdat->flags);
+
+		/* Allow kswapd to start writing pages during reclaim.*/
+		if (sc->nr.unqueued_dirty == sc->nr.file_taken)
+			set_bit(PGDAT_DIRTY, &pgdat->flags);
 
 		/*
-		 * Stall direct reclaim for IO completions if underlying BDIs
-		 * and node is congested. Allow kswapd to continue until it
-		 * starts encountering unqueued dirty pages or cycling through
-		 * the LRU too quickly.
+		 * If kswapd scans pages marked marked for immediate
+		 * reclaim and under writeback (nr_immediate), it
+		 * implies that pages are cycling through the LRU
+		 * faster than they are written so also forcibly stall.
 		 */
-		if (!sc->hibernation_mode && !current_is_kswapd() &&
-		   current_may_throttle() && pgdat_memcg_congested(pgdat, root))
-			wait_iff_congested(BLK_RW_ASYNC, HZ/10);
+		if (sc->nr.immediate)
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
+	}
+
+	/*
+	 * Legacy memcg will stall in page writeback so avoid forcibly
+	 * stalling in wait_iff_congested().
+	 */
+	if (cgroup_reclaim(sc) && writeback_working(sc) &&
+	    sc->nr.dirty && sc->nr.dirty == sc->nr.congested)
+		set_memcg_congestion(pgdat, root, true);
+
+	/*
+	 * Stall direct reclaim for IO completions if underlying BDIs
+	 * and node is congested. Allow kswapd to continue until it
+	 * starts encountering unqueued dirty pages or cycling through
+	 * the LRU too quickly.
+	 */
+	if (!sc->hibernation_mode && !current_is_kswapd() &&
+	    current_may_throttle() && pgdat_memcg_congested(pgdat, root))
+		wait_iff_congested(BLK_RW_ASYNC, HZ/10);
 
-	} while (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
-					 sc->nr_scanned - nr_scanned, sc));
+	if (should_continue_reclaim(pgdat, sc->nr_reclaimed - nr_reclaimed,
+				    sc->nr_scanned - nr_scanned, sc))
+		goto again;
 
 	/*
 	 * Kswapd gives up on balancing particular nodes after too
-- 
2.21.0

