From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/4] mm: memcontrol: make cgroup stats and events query API explicitly local
Date: Fri, 12 Apr 2019 11:15:04 -0400
Message-ID: <20190412151507.2769-2-hannes@cmpxchg.org>
References: <20190412151507.2769-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vYujH9ql2WWkJyoNj4zC7fKkltAGztxNOgJanRlBf/k=;
        b=PLL+ZIOovXrfX1wJ1YTZ6L+zDg1hjgBGzySqLyYncg5msMIkS5Ic2UAIQ46BtEetQO
         2XD1BaVaNpjylQD6A7WTKHPwz6kWz7EDemV/kgcnsT0tUXbK1G+pfy9D8VfT9BS1p66X
         FD+ZaoDb3EuL6yBgT+YGLTA0U/Ix4bUhu75FAuHncIA6p8Zn7C5w7sBs31iQR+VHOBh3
         6w3Nwx/SWTeMwaWvCyes6vQT3oV2sIvvzepgVFgTQxMwwXnTSq5V0ZUiEk5u5KTl6H/y
         AWYf4x/nbpo3NE1CAMpnujWd0d+NTo5PGRlmnVbBOXIc518OwHEjkW4S5aGtFyhlxoM3
         tNfA==
In-Reply-To: <20190412151507.2769-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

memcg_page_state(), lruvec_page_state(), memcg_sum_events() are
currently returning the state of the local memcg or lruvec, not the
recursive state.

In practice there is a demand for both versions, although the callers
that want the recursive counts currently sum them up by hand.

Per default, cgroups are considered recursive entities and generally
we expect more users of the recursive counters, with the local counts
being special cases. To reflect that in the name, add a _local suffix
to the current implementations.

The following patch will re-incarnate these functions with recursive
semantics, but with an O(1) implementation.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 16 +++++++--------
 mm/memcontrol.c            | 40 ++++++++++++++++++++------------------
 mm/vmscan.c                |  4 ++--
 mm/workingset.c            |  7 ++++---
 4 files changed, 35 insertions(+), 32 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 3823cb335b60..139be7d44c29 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -569,8 +569,8 @@ void unlock_page_memcg(struct page *page);
  * idx can be of type enum memcg_stat_item or node_stat_item.
  * Keep in sync with memcg_exact_page_state().
  */
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     int idx)
+static inline unsigned long memcg_page_state_local(struct mem_cgroup *memcg,
+						   int idx)
 {
 	long x = atomic_long_read(&memcg->vmstats[idx]);
 #ifdef CONFIG_SMP
@@ -639,8 +639,8 @@ static inline void mod_memcg_page_state(struct page *page,
 		mod_memcg_state(page->mem_cgroup, idx, val);
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
-					      enum node_stat_item idx)
+static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+						    enum node_stat_item idx)
 {
 	struct mem_cgroup_per_node *pn;
 	long x;
@@ -1043,8 +1043,8 @@ static inline void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
 {
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
-					     int idx)
+static inline unsigned long memcg_page_state_local(struct mem_cgroup *memcg,
+						   int idx)
 {
 	return 0;
 }
@@ -1073,8 +1073,8 @@ static inline void mod_memcg_page_state(struct page *page,
 {
 }
 
-static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
-					      enum node_stat_item idx)
+static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
+						    enum node_stat_item idx)
 {
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cd03b1181f7f..109608b8091f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -687,8 +687,8 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 	return mz;
 }
 
-static unsigned long memcg_sum_events(struct mem_cgroup *memcg,
-				      int event)
+static unsigned long memcg_events_local(struct mem_cgroup *memcg,
+					int event)
 {
 	return atomic_long_read(&memcg->vmevents[event]);
 }
@@ -1325,12 +1325,14 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 			if (memcg1_stats[i] == MEMCG_SWAP && !do_swap_account)
 				continue;
 			pr_cont(" %s:%luKB", memcg1_stat_names[i],
-				K(memcg_page_state(iter, memcg1_stats[i])));
+				K(memcg_page_state_local(iter,
+							 memcg1_stats[i])));
 		}
 
 		for (i = 0; i < NR_LRU_LISTS; i++)
 			pr_cont(" %s:%luKB", mem_cgroup_lru_names[i],
-				K(memcg_page_state(iter, NR_LRU_BASE + i)));
+				K(memcg_page_state_local(iter,
+							 NR_LRU_BASE + i)));
 
 		pr_cont("\n");
 	}
@@ -1401,13 +1403,13 @@ static bool test_mem_cgroup_node_reclaimable(struct mem_cgroup *memcg,
 {
 	struct lruvec *lruvec = mem_cgroup_lruvec(NODE_DATA(nid), memcg);
 
-	if (lruvec_page_state(lruvec, NR_INACTIVE_FILE) ||
-	    lruvec_page_state(lruvec, NR_ACTIVE_FILE))
+	if (lruvec_page_state_local(lruvec, NR_INACTIVE_FILE) ||
+	    lruvec_page_state_local(lruvec, NR_ACTIVE_FILE))
 		return true;
 	if (noswap || !total_swap_pages)
 		return false;
-	if (lruvec_page_state(lruvec, NR_INACTIVE_ANON) ||
-	    lruvec_page_state(lruvec, NR_ACTIVE_ANON))
+	if (lruvec_page_state_local(lruvec, NR_INACTIVE_ANON) ||
+	    lruvec_page_state_local(lruvec, NR_ACTIVE_ANON))
 		return true;
 	return false;
 
@@ -2976,16 +2978,16 @@ static void accumulate_vmstats(struct mem_cgroup *memcg,
 
 	for_each_mem_cgroup_tree(mi, memcg) {
 		for (i = 0; i < acc->vmstats_size; i++)
-			acc->vmstats[i] += memcg_page_state(mi,
+			acc->vmstats[i] += memcg_page_state_local(mi,
 				acc->vmstats_array ? acc->vmstats_array[i] : i);
 
 		for (i = 0; i < acc->vmevents_size; i++)
-			acc->vmevents[i] += memcg_sum_events(mi,
+			acc->vmevents[i] += memcg_events_local(mi,
 				acc->vmevents_array
 				? acc->vmevents_array[i] : i);
 
 		for (i = 0; i < NR_LRU_LISTS; i++)
-			acc->lru_pages[i] += memcg_page_state(mi,
+			acc->lru_pages[i] += memcg_page_state_local(mi,
 							      NR_LRU_BASE + i);
 	}
 }
@@ -2998,10 +3000,10 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 		struct mem_cgroup *iter;
 
 		for_each_mem_cgroup_tree(iter, memcg) {
-			val += memcg_page_state(iter, MEMCG_CACHE);
-			val += memcg_page_state(iter, MEMCG_RSS);
+			val += memcg_page_state_local(iter, MEMCG_CACHE);
+			val += memcg_page_state_local(iter, MEMCG_RSS);
 			if (swap)
-				val += memcg_page_state(iter, MEMCG_SWAP);
+				val += memcg_page_state_local(iter, MEMCG_SWAP);
 		}
 	} else {
 		if (!swap)
@@ -3343,7 +3345,7 @@ static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3357,7 +3359,7 @@ static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3442,17 +3444,17 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "%s %lu\n", memcg1_stat_names[i],
-			   memcg_page_state(memcg, memcg1_stats[i]) *
+			   memcg_page_state_local(memcg, memcg1_stats[i]) *
 			   PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
 		seq_printf(m, "%s %lu\n", memcg1_event_names[i],
-			   memcg_sum_events(memcg, memcg1_events[i]));
+			   memcg_events_local(memcg, memcg1_events[i]));
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "%s %lu\n", mem_cgroup_lru_names[i],
-			   memcg_page_state(memcg, NR_LRU_BASE + i) *
+			   memcg_page_state_local(memcg, NR_LRU_BASE + i) *
 			   PAGE_SIZE);
 
 	/* Hierarchical information */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index c9f8afe61ae3..6e99a8b9b2ad 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -346,7 +346,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
 	int zid;
 
 	if (!mem_cgroup_disabled())
-		lru_size = lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		lru_size = lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	else
 		lru_size = node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
 
@@ -2163,7 +2163,7 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 	 * is being established. Disable active list protection to get
 	 * rid of the stale workingset quickly.
 	 */
-	refaults = lruvec_page_state(lruvec, WORKINGSET_ACTIVATE);
+	refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
 	if (file && actual_reclaim && lruvec->refaults != refaults) {
 		inactive_ratio = 0;
 	} else {
diff --git a/mm/workingset.c b/mm/workingset.c
index 6419baebd306..e0b4edcb88c8 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -430,9 +430,10 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		lruvec = mem_cgroup_lruvec(NODE_DATA(sc->nid), sc->memcg);
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_page_state(lruvec, NR_LRU_BASE + i);
-		pages += lruvec_page_state(lruvec, NR_SLAB_RECLAIMABLE);
-		pages += lruvec_page_state(lruvec, NR_SLAB_UNRECLAIMABLE);
+			pages += lruvec_page_state_local(lruvec,
+							 NR_LRU_BASE + i);
+		pages += lruvec_page_state_local(lruvec, NR_SLAB_RECLAIMABLE);
+		pages += lruvec_page_state_local(lruvec, NR_SLAB_UNRECLAIMABLE);
 	} else
 #endif
 		pages = node_present_pages(sc->nid);
-- 
2.21.0

