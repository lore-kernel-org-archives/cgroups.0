From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 09/11] mm: vmscan: move file exhaustion detection to the node level
Date: Mon,  3 Jun 2019 17:07:44 -0400
Message-ID: <20190603210746.15800-10-hannes@cmpxchg.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uM4S4y/Y5SrPdENg0QBPLDuc00s8nib+/ajfOkcZMik=;
        b=E5wKX75LYj21K7r3b5uPvJHFB3a+wonjs7ZsPnT7rqWS2Jj94E45SuqIpvC70AjZgc
         JIPqfhBiJe5qxRDHnW0a11OgkMQCZGxN/JgMiMb2uO+dp8dsS4hv+h8pIvllW6xzlqex
         2ajtI1YvJTzHyOEvFyG0WZ424MseQjErWrB1aHCv6+yd8mrPV/JSYvxp5kyasLqQo2Pf
         RCFBx4MsTkG80s0S4efJn9Fsp/kMF8ETw52Oxn7dHom+bNsgFQe2Z7qz52Aj2oZ8A3IN
         cQzPnohrFrwqFS/0osPnM8G9h7NO7drtGI+CLw2kKPFUoAAEjC2xRAV9cMROAgznBSCR
         4Dhg==
In-Reply-To: <20190603210746.15800-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

When file pages are lower than the watermark on a node, we try to
force scan anonymous pages to counter-act the balancing algorithms
preference for new file pages when they are likely thrashing. This is
node-level decision, but it's currently made each time we look at an
lruvec. This is unnecessarily expensive and also a layering violation
that makes the code harder to understand.

Clean this up by making the check once per node and setting a flag in
the scan_control.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 80 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 38 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index eb535c572733..cabf94dfa92d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -104,6 +104,9 @@ struct scan_control {
 	/* One of the zones is ready for compaction */
 	unsigned int compaction_ready:1;
 
+	/* The file pages on the current node are dangerously low */
+	unsigned int file_is_tiny:1;
+
 	/* Allocation order */
 	s8 order;
 
@@ -2219,45 +2222,16 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	}
 
 	/*
-	 * Prevent the reclaimer from falling into the cache trap: as
-	 * cache pages start out inactive, every cache fault will tip
-	 * the scan balance towards the file LRU.  And as the file LRU
-	 * shrinks, so does the window for rotation from references.
-	 * This means we have a runaway feedback loop where a tiny
-	 * thrashing file LRU becomes infinitely more attractive than
-	 * anon pages.  Try to detect this based on file LRU size.
+	 * If the system is almost out of file pages, force-scan anon.
+	 * But only if there are enough inactive anonymous pages on
+	 * the LRU. Otherwise, the small LRU gets thrashed.
 	 */
-	if (!cgroup_reclaim(sc)) {
-		unsigned long pgdatfile;
-		unsigned long pgdatfree;
-		int z;
-		unsigned long total_high_wmark = 0;
-
-		pgdatfree = sum_zone_node_page_state(pgdat->node_id, NR_FREE_PAGES);
-		pgdatfile = node_page_state(pgdat, NR_ACTIVE_FILE) +
-			   node_page_state(pgdat, NR_INACTIVE_FILE);
-
-		for (z = 0; z < MAX_NR_ZONES; z++) {
-			struct zone *zone = &pgdat->node_zones[z];
-			if (!managed_zone(zone))
-				continue;
-
-			total_high_wmark += high_wmark_pages(zone);
-		}
-
-		if (unlikely(pgdatfile + pgdatfree <= total_high_wmark)) {
-			/*
-			 * Force SCAN_ANON if there are enough inactive
-			 * anonymous pages on the LRU in eligible zones.
-			 * Otherwise, the small LRU gets thrashed.
-			 */
-			if (!inactive_list_is_low(lruvec, false, sc, false) &&
-			    lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, sc->reclaim_idx)
-					>> sc->priority) {
-				scan_balance = SCAN_ANON;
-				goto out;
-			}
-		}
+	if (sc->file_is_tiny &&
+	    !inactive_list_is_low(lruvec, false, sc, false) &&
+	    lruvec_lru_size(lruvec, LRU_INACTIVE_ANON,
+			    sc->reclaim_idx) >> sc->priority) {
+		scan_balance = SCAN_ANON;
+		goto out;
 	}
 
 	/*
@@ -2718,6 +2692,36 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	nr_reclaimed = sc->nr_reclaimed;
 	nr_scanned = sc->nr_scanned;
 
+	/*
+	 * Prevent the reclaimer from falling into the cache trap: as
+	 * cache pages start out inactive, every cache fault will tip
+	 * the scan balance towards the file LRU.  And as the file LRU
+	 * shrinks, so does the window for rotation from references.
+	 * This means we have a runaway feedback loop where a tiny
+	 * thrashing file LRU becomes infinitely more attractive than
+	 * anon pages.  Try to detect this based on file LRU size.
+	 */
+	if (!cgroup_reclaim(sc)) {
+		unsigned long file;
+		unsigned long free;
+		int z;
+		unsigned long total_high_wmark = 0;
+
+		free = sum_zone_node_page_state(pgdat->node_id, NR_FREE_PAGES);
+		file = node_page_state(pgdat, NR_ACTIVE_FILE) +
+			   node_page_state(pgdat, NR_INACTIVE_FILE);
+
+		for (z = 0; z < MAX_NR_ZONES; z++) {
+			struct zone *zone = &pgdat->node_zones[z];
+			if (!managed_zone(zone))
+				continue;
+
+			total_high_wmark += high_wmark_pages(zone);
+		}
+
+		sc->file_is_tiny = file + free <= total_high_wmark;
+	}
+
 	shrink_node_memcgs(pgdat, sc);
 
 	if (reclaim_state) {
-- 
2.21.0

