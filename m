From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 03/11] mm: vmscan: simplify lruvec_lru_size()
Date: Mon,  3 Jun 2019 17:07:38 -0400
Message-ID: <20190603210746.15800-4-hannes@cmpxchg.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hW9XEaleHf0fxFzrzaLu3/5nxBFHbI/f8wU4NVTruL4=;
        b=GiZl3I0/1nrhXFLsEYVx8i8I4at3od658KebcT8wvAtJDzTnhyqemuN29q2/fcr3KW
         tDsgy9TzZFg8DTfH/bgCfQ9DMl4vc7J4plUg5mA9cty9aXI8rxvDidvnbUu121RWDy3r
         e1RxDwqqABcmlJXwZaGPTzP0keY1G2zSdow7H3XEkR3F49wcmjR9HuHqyQb5DFvxXdrE
         L+ebT5LxPIX7aGWwOApYSGaixnBATTA3AvWr+WjSjHJsz0lxIbyDxEPuHK3xJkUAPctk
         yP5msqE7q+xLnKa1SZBpeRAnKA5wg+rgZtDOy4sVffJyMyZx1w3RUzvp12AR2PMSm3mf
         jkdA==
In-Reply-To: <20190603210746.15800-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

This function currently takes the node or lruvec size and subtracts
the zones that are excluded by the classzone index of the
allocation. It uses four different types of counters to do this.

Just add up the eligible zones.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 853be16ee5e2..69c4c82a9b5a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -342,30 +342,21 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
  */
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
-	unsigned long lru_size;
+	unsigned long size = 0;
 	int zid;
 
-	if (!mem_cgroup_disabled())
-		lru_size = lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
-	else
-		lru_size = node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
-
-	for (zid = zone_idx + 1; zid < MAX_NR_ZONES; zid++) {
+	for (zid = 0; zid <= zone_idx; zid++) {
 		struct zone *zone = &lruvec_pgdat(lruvec)->node_zones[zid];
-		unsigned long size;
 
 		if (!managed_zone(zone))
 			continue;
 
 		if (!mem_cgroup_disabled())
-			size = mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
+			size += mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
 		else
-			size = zone_page_state(&lruvec_pgdat(lruvec)->node_zones[zid],
-				       NR_ZONE_LRU_BASE + lru);
-		lru_size -= min(size, lru_size);
+			size += zone_page_state(zone, NR_ZONE_LRU_BASE + lru);
 	}
-
-	return lru_size;
+	return size;
 
 }
 
-- 
2.21.0

