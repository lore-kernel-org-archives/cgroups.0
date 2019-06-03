From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 07/11] mm: vmscan: split shrink_node() into node part and memcgs part
Date: Mon,  3 Jun 2019 17:07:42 -0400
Message-ID: <20190603210746.15800-8-hannes@cmpxchg.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TqYkozLWwlwjh5tlY84d20KyoxNGzeaiPZCNbBAwhx4=;
        b=CfO5Ti2iu2mKkyrYwQLDB8QQe+3afMqMfaNa/wJWa+mXj+X31SmaTgT+uw/gY/rdTf
         jyGegdzwHQpljpHWA2wVsG+b+pBVziQt1WX1xTIGjq8MuGjOuPpGwAopHMkHZqKp3+Ui
         tIjfvPdEXyrjLHGUp3YnhPfJubq1kFYnfoDUBGlOpXwawLoXGpyTrhQT4Z9tXoIbW1ou
         FA5RvsNPdN/E2REMNh3zWT5ebiR0nab16veulDQZkupuNnzCdYJtcdh5eyxzTO6LIVCK
         7VRPrTbECquvW9jgMxA0+O34IrqMJjOL2ObDNuSMq/SrUHZlwsk4bT5BfEeNMBlTPcMO
         wkEw==
In-Reply-To: <20190603210746.15800-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

This function is getting long and unwieldy. The new shrink_node()
handles the generic (node) reclaim aspects:
  - global vmpressure notifications
  - writeback and congestion throttling
  - reclaim/compaction management
  - kswapd giving up on unreclaimable nodes

It then calls shrink_node_memcgs() which handles cgroup specifics:
  - the cgroup tree traversal
  - memory.low considerations
  - per-cgroup slab shrinking callbacks
  - per-cgroup vmpressure notifications

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b85111474ee2..ee79b39d0538 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2665,24 +2665,15 @@ static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
 		(memcg && memcg_congested(pgdat, memcg));
 }
 
-static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
+static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 {
-	struct reclaim_state *reclaim_state = current->reclaim_state;
 	struct mem_cgroup *root = sc->target_mem_cgroup;
 	struct mem_cgroup_reclaim_cookie reclaim = {
 		.pgdat = pgdat,
 		.priority = sc->priority,
 	};
-	unsigned long nr_reclaimed, nr_scanned;
-	bool reclaimable = false;
 	struct mem_cgroup *memcg;
 
-again:
-	memset(&sc->nr, 0, sizeof(sc->nr));
-
-	nr_reclaimed = sc->nr_reclaimed;
-	nr_scanned = sc->nr_scanned;
-
 	memcg = mem_cgroup_iter(root, NULL, &reclaim);
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -2750,6 +2741,22 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 			break;
 		}
 	} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
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
@@ -2757,7 +2764,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	}
 
 	/* Record the subtree's reclaim efficiency */
-	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+	vmpressure(sc->gfp_mask, root, true,
 		   sc->nr_scanned - nr_scanned,
 		   sc->nr_reclaimed - nr_reclaimed);
 
-- 
2.21.0

