From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 7/8] mm: vmscan: split shrink_node() into node part and memcgs part
Date: Tue, 22 Oct 2019 10:48:02 -0400
Message-ID: <20191022144803.302233-8-hannes@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TcikxxhhZnd6YbZpIU4lRQd5AagmURIl+Vuyl9j6u4o=;
        b=FvZrlFyRQntoTimiufrW53mtj9qQm5Pfkmi6p9CvHGf4iR1aINMvfQGfKS5J6FOE6Q
         +a/mswPjs8yJdf44DISKKSp7pkEDXdEPHmpL5dPfkzMfKhGowvZmJntlFeptg/YT+M/4
         F1yyqrA4p/pPpGQwEYO5wWe4v1QX3CFT8wrfa/IjioJDCqvPCRNx912M+Xg1uvyLIba4
         UAI8qPBU/g32WGoLKqRcwfWhJ/8NtFsyvIIeW30mb8ztOxvbZzL7agXcNuzl+ePB6+7e
         nyCJPye+F9FgFZgkKIcjPyM7ig4P+P+beI6kZp4hAJ8urRBGbCg/vCRTdLEj/z9s2Ymk
         ndjA==
In-Reply-To: <20191022144803.302233-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

This function is getting long and unwieldy, split out the memcg bits.

The updated shrink_node() handles the generic (node) reclaim aspects:
  - global vmpressure notifications
  - writeback and congestion throttling
  - reclaim/compaction management
  - kswapd giving up on unreclaimable nodes

It then calls a new shrink_node_memcgs() which handles cgroup specifics:
  - the cgroup tree traversal
  - memory.low considerations
  - per-cgroup slab shrinking callbacks
  - per-cgroup vmpressure notifications

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index db073b40c432..65baa89740dd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2722,18 +2722,10 @@ static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
 		(memcg && memcg_congested(pgdat, memcg));
 }
 
-static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
+static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
-	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct mem_cgroup *root = sc->target_mem_cgroup;
-	unsigned long nr_reclaimed, nr_scanned;
-	bool reclaimable = false;
 	struct mem_cgroup *memcg;
-again:
-	memset(&sc->nr, 0, sizeof(sc->nr));
-
-	nr_reclaimed = sc->nr_reclaimed;
-	nr_scanned = sc->nr_scanned;
 
 	memcg = mem_cgroup_iter(root, NULL, NULL);
 	do {
@@ -2786,6 +2778,22 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 			   sc->nr_reclaimed - reclaimed);
 
 	} while ((memcg = mem_cgroup_iter(root, memcg, NULL)));
+}
+
+static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
+{
+	struct reclaim_state *reclaim_state = current->reclaim_state;
+	struct mem_cgroup *root = sc->target_mem_cgroup;
+	unsigned long nr_reclaimed, nr_scanned;
+	bool reclaimable = false;
+
+again:
+	memset(&sc->nr, 0, sizeof(sc->nr));
+
+	nr_reclaimed = sc->nr_reclaimed;
+	nr_scanned = sc->nr_scanned;
+
+	shrink_node_memcgs(pgdat, sc);
 
 	if (reclaim_state) {
 		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
@@ -2793,7 +2801,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	}
 
 	/* Record the subtree's reclaim efficiency */
-	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+	vmpressure(sc->gfp_mask, root, true,
 		   sc->nr_scanned - nr_scanned,
 		   sc->nr_reclaimed - nr_reclaimed);
 
-- 
2.23.0

