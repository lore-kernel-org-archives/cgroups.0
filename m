From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 4/6] mm: memcontrol: push down mem_cgroup_node_nr_lru_pages()
Date: Thu, 28 Feb 2019 11:30:18 -0500
Message-ID: <20190228163020.24100-5-hannes@cmpxchg.org>
References: <20190228163020.24100-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+fTCozRbLMGgETAnd6XOzTuCoFNGxxYSxApGaKudEvQ=;
        b=x12aerecO+G2Qi8DCMF2xSNAdXP6sBfvJQFyXJRVQZzC59w0Li6KJcU2pImtwibxdU
         jf1dSlSsVetoPQrYlc7ADovX4Z9ahMPqkLwaA10S6bLaHVLA0w9hGYX7L83qslBlCUmp
         yQyO2YHvfGJbtpNNJp4Jt1rHJvl3Pr7QmtLNylzcYOSY+44ehQkUBWAdlWVslNo6ftDg
         LJM1d+pyrMy9ErHzmV1drh8f3anJphXWFWrNeCPNNAOiRhhiNIVgIEMRO0MCXqL/o+wv
         tTccoxWk0I9ROwOYBJAZIuuupIO4nyL1sRD41Cfz+2izzbY8daIyH18gtRXknFFHxHoI
         6Gpg==
In-Reply-To: <20190228163020.24100-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

mem_cgroup_node_nr_lru_pages() is just a convenience wrapper around
lruvec_page_state() that takes bitmasks of lru indexes and aggregates
the counts for those.

Replace callsites where the bitmask is simple enough with direct
lruvec_page_state() calls.

This removes the last extern user of mem_cgroup_node_nr_lru_pages(),
so make that function private again, too.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 10 ----------
 mm/memcontrol.c            | 10 +++++++---
 mm/workingset.c            |  5 +++--
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5050d281f67d..57029eefd225 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -514,9 +514,6 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		int zid, int nr_pages);
 
-unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask);
-
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
@@ -979,13 +976,6 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 	return 0;
 }
 
-static inline unsigned long
-mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-			     int nid, unsigned int lru_mask)
-{
-	return 0;
-}
-
 static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
 {
 	return 0;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e702b67cde41..ad6214b3d20b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -725,7 +725,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	__this_cpu_add(memcg->vmstats_percpu->nr_page_events, nr_pages);
 }
 
-unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 					   int nid, unsigned int lru_mask)
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
@@ -1430,11 +1430,15 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
 		int nid, bool noswap)
 {
-	if (mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL_FILE))
+	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
+
+	if (lruvec_page_state(lruvec, NR_INACTIVE_FILE) ||
+	    lruvec_page_state(lruvec, NR_ACTIVE_FILE))
 		return true;
 	if (noswap || !total_swap_pages)
 		return false;
-	if (mem_cgroup_node_nr_lru_pages(memcg, nid, LRU_ALL_ANON))
+	if (lruvec_page_state(lruvec, NR_INACTIVE_ANON) ||
+	    lruvec_page_state(lruvec, NR_ACTIVE_ANON))
 		return true;
 	return false;
 
diff --git a/mm/workingset.c b/mm/workingset.c
index dcb994f2acc2..dbc333a21254 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -427,10 +427,11 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 #ifdef CONFIG_MEMCG
 	if (sc->memcg) {
 		struct lruvec *lruvec;
+		int i;
 
-		pages = mem_cgroup_node_nr_lru_pages(sc->memcg, sc->nid,
-						     LRU_ALL);
 		lruvec = mem_cgroup_lruvec(NODE_DATA(sc->nid), sc->memcg);
+		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
+			pages += lruvec_page_state(lruvec, NR_LRU_BASE + i);
 		pages += lruvec_page_state(lruvec, NR_SLAB_RECLAIMABLE);
 		pages += lruvec_page_state(lruvec, NR_SLAB_UNRECLAIMABLE);
 	} else
-- 
2.20.1

