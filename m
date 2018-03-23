From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v2 1/4] mm/vmscan: Update stale comments
Date: Fri, 23 Mar 2018 18:20:26 +0300
Message-ID: <20180323152029.11084-2-aryabinin@virtuozzo.com>
References: <20180323152029.11084-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rOmwoEJeRoQNROk2qpmhE7A/bvpvtLz4/Om5Kv7AgE0=;
 b=Ri1mH40YuqFhffik2vi3udv43XDZdJ/6Hxn2ETN7Zb95EdyOXh1F4ltJ14p3fWwD+wPEjHs6zMc6PIvNfojqNamZfc49iNsT4IMotB6dtP4VZOGJkwPcCIk6cdwjjyT1zF1BKmVM2hcKCGaVvivfltyGdF1d+xT/xqA6/FuQoec=
In-Reply-To: <20180323152029.11084-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Update some comments that become stale since transiton from per-zone
to per-node reclaim.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/vmscan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4390a8d5be41..6d74b12099bd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -926,7 +926,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		/*
-		 * The number of dirty pages determines if a zone is marked
+		 * The number of dirty pages determines if a node is marked
 		 * reclaim_congested which affects wait_iff_congested. kswapd
 		 * will stall and start writing pages if the tail of the LRU
 		 * is all dirty unqueued pages.
@@ -1764,7 +1764,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * as there is no guarantee the dirtying process is throttled in the
 	 * same way balance_dirty_pages() manages.
 	 *
-	 * Once a zone is flagged ZONE_WRITEBACK, kswapd will count the number
+	 * Once a node is flagged PGDAT_WRITEBACK, kswapd will count the number
 	 * of pages under pages flagged for immediate reclaim and stall if any
 	 * are encountered in the nr_immediate check below.
 	 */
@@ -1791,7 +1791,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 */
 	if (sane_reclaim(sc)) {
 		/*
-		 * Tag a zone as congested if all the dirty pages scanned were
+		 * Tag a node as congested if all the dirty pages scanned were
 		 * backed by a congested BDI and wait_iff_congested will stall.
 		 */
 		if (stat.nr_dirty && stat.nr_dirty == stat.nr_congested)
@@ -1812,7 +1812,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	}
 
 	/*
-	 * Stall direct reclaim for IO completions if underlying BDIs or zone
+	 * Stall direct reclaim for IO completions if underlying BDIs and node
 	 * is congested. Allow kswapd to continue until it starts encountering
 	 * unqueued dirty pages or cycling through the LRU too quickly.
 	 */
@@ -3808,7 +3808,7 @@ static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned in
 
 	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages) {
 		/*
-		 * Free memory by calling shrink zone with increasing
+		 * Free memory by calling shrink node with increasing
 		 * priorities until we have enough memory freed.
 		 */
 		do {
-- 
2.16.1

