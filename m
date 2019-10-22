From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/8] mm: vmscan: simplify lruvec_lru_size()
Date: Tue, 22 Oct 2019 10:47:56 -0400
Message-ID: <20191022144803.302233-2-hannes@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iFBKqmL/4fnTvQgxpmecsW4xlCLftKHwTd8yhraPD9Y=;
        b=po3EgEl1Mfcj8YgbJhdpnDMRmpW8tzAaBeWPxhTAU12MmtccZL11JGUkwiGCxgb3xA
         QjdEo7R/vlHoX3wx55XWp85atLxaGk+SyRuTtJRtL93CNS+tRpuJrui+/9PKaa7yN3ii
         JLNR+sQ8cffNhgL+fm6oIOASPG2kRusL/cs1itJ4EqXdId40uJ9ocUAIThgUAPxylvbj
         MObUpe5nqGUYyuW0YRa7+wCtibgztGJg5dkHeW5ZpttdFZ1zN86nHgyeiLiVBtPJvEU2
         rNzOnZd29An6Kf7sEkGGYMYqrq9BBDH/jts3v2801jiVF9o7199dTnfCZ1scCLknemwz
         ViqQ==
In-Reply-To: <20191022144803.302233-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

This function currently takes the node or lruvec size and subtracts
the zones that are excluded by the classzone index of the
allocation. It uses four different types of counters to do this.

Just add up the eligible zones.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1154b3a2b637..57f533b808f2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -351,32 +351,21 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
  */
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
-	unsigned long lru_size = 0;
+	unsigned long size = 0;
 	int zid;
 
-	if (!mem_cgroup_disabled()) {
-		for (zid = 0; zid < MAX_NR_ZONES; zid++)
-			lru_size += mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
-	} else
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
-
+	return size;
 }
 
 /*
-- 
2.23.0

