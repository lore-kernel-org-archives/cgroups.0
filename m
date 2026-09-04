Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E01242910
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788504784; cv=none; b=olQqjQ1hEP1WcoUlBmf6KLuW+Q5cNZow4Hexf/Fvay8NgGLZqLtw27tgqcFTDDkXsW3cynnnYdfc26Djcr2RJQssuy6sGV+iJT3wEe0DF3+RdErZBmuF7QIrXqDWdCwoIaJVLYbjYdXkCiLzXVYd54RLiv3ERhIrsZrKitdmWhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788504784; c=relaxed/simple;
	bh=5P4+yAimay9rXn16I7RLLt8o0DISyKwAhNWtwc/Yd6k=;
	h=Message-Id:Mime-Version:From:Date:Cc:In-Reply-To:References:
	 Content-Type:To:Subject; b=a30l4JHdRyXjM/j6uoXEeXwjiKpFebmB4KipHXfEIdMT/SNnlSlBC0cEp7+pBKCczUJiA6Ohb7fXeyI1wfdpvBcBBDcRtw0fElha9FsMDCB2SWGNZXW/e6C3bGUwi72kjWuyEohSMnLfXEOlyCy6zxV8295m+Wq3kV4lNlgknxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GXFyrjGY; arc=none smtp.client-ip=209.127.231.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GXFyrjGY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788504771; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=4bwsx8xw1uGSa604nTul98ImcISUH3wPbbepzNoJwis=;
 b=GXFyrjGYuyXi5uSSzzXrQI8CxNNPFtrUNHiwu6DjgR+hLMqR1PNMT6QPIyRDmz1Or4hLaF
 TVx3oTbjGH63k36L0x/hjwxrlBICSFMktXYj4eZJllEIUkAhD9556HRzsn6j0wtUj7aEv7
 3D5rqHpId493sSi/Cs91AESDbEnFuHbep/oQGyGevBhJHQoF2Sm6Dg8Hbtx5fMvlaYLAaW
 M2socuZmq5JTapJMmbp1WSrKTt+UzUCPNFtbfi/BPZzu2tp0gTvMQAVz00x2G+aYD05LWC
 jfx6W5AMH/bai8cNHLKdFgUsw2hUq2+WaIDlqhwNZNqQhk/+hEdq187lbLwUZg==
Message-Id: <20260904065159.34409-2-lizhe.67@bytedance.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Fri,  4 Sep 2026 14:51:58 +0800
X-Mailer: git-send-email 2.45.2
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
In-Reply-To: <20260904065159.34409-1-lizhe.67@bytedance.com>
References: <20260904065159.34409-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <qi.zheng@linux.dev>
Subject: [RFC 1/2] mm: add goal=evict to memory.reclaim
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a9a6ac1+630135+vger.kernel.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit

On tiered memory systems, reclaim can demote cold folios from a faster
memory tier to a slower memory tier before they are eventually evicted.
This is part of the aging pipeline: reclaiming directly from a faster
source tier can skip colder folios that have already aged into lower tiers.
Counting demotion as reclaim progress keeps the default memory.reclaim
behavior aligned with that tiered aging model.

However, this makes memory.reclaim completion observably different from
systems without demotion. Without demotion, completing a proactive memcg
reclaim request usually means that the charged footprint was reduced by
eviction. With memory tiering enabled, the same request can complete on
successful demotion alone: folios move to a lower tier, but memory.current
does not drop. Callers that use memory.reclaim to drive memcg footprint
reduction then have to issue repeated short requests to make eviction
progress.

Add goal=evict as an explicit opt-in for eviction-oriented memcg proactive
reclaim. Demotion remains enabled and can still happen as part of reclaim
aging, but successfully demoted folios do not count toward completing the
requested reclaim amount. The default remains goal=progress, preserving
the existing tiered aging behavior and using the existing nr_reclaimed
accounting unchanged. nr_demoted is a subset of nr_reclaimed and is
subtracted only for the evict-goal stop condition.

If the target cgroup has no usable demotion target, treat goal=evict as
goal=progress before reclaim starts. In that case demotion cannot satisfy
the request anyway, so the new key does not need special completion
accounting and reclaim keeps the same behavior as today's memory.reclaim.

goal=evict does not change folio selection or disable demotion. When a
selected folio has an allowed lower-tier target, shrink_folio_list() still
tries to demote it first. The new accounting only prevents those demoted
folios from satisfying an eviction-oriented request by themselves.

The scan limit is deliberately narrow. After an inner reclaim batch has
already demoted at least the batch target, reclaim skips only the top
tier(s) in the cgroup's allowed demotion hierarchy: tiers that can demote
to a lower allowed tier, but are not themselves targets of any higher
allowed tier. Intermediate tiers continue to be scanned so pages already
demoted there can age further downward, and the lowest tier(s) continue
to be scanned so eviction can satisfy the request.

goal=evict is only accepted for memcg memory.reclaim. The per-node
proactive reclaim path uses the same parser, but its reclaim target is a
node capacity target where demotion progress can be the desired outcome.
Reject the new goal key there rather than giving it a different meaning.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  15 ++++
 include/linux/memory-tiers.h            |  13 +++
 mm/internal.h                           |   1 +
 mm/memory-tiers.c                       |  35 +++++++-
 mm/vmscan.c                             | 110 ++++++++++++++++++++++--
 5 files changed, 166 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7c2a8ed80071..ed87d45cfe21 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1448,6 +1448,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  goal                  Reclaim request goal
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1458,6 +1459,20 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	The goal key controls what kind of progress satisfies the requested
+	reclaim amount. The default is goal=progress, which uses the kernel's
+	normal reclaim progress accounting. On tiered memory systems this can
+	include both eviction and demotion progress.
+
+	goal=evict keeps memory tier demotion enabled as part of reclaim aging,
+	but does not count successfully demoted pages toward completing the
+	requested reclaim amount. Demotion may still be performed on the way,
+	but demotion-only progress is not sufficient to satisfy the request.
+	If no demotion target is available to the cgroup, this behaves like
+	goal=progress. This does not select source or target memory tiers and
+	does not disable demotion. This is best-effort and does not bypass memory
+	protection or other reclaim constraints.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629ee..5d869f74deab 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -55,6 +55,7 @@ void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
+void node_get_allowed_sources(pg_data_t *pgdat, nodemask_t *sources);
 bool node_is_toptier(int node);
 #else
 static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
@@ -67,6 +68,12 @@ static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *target
 	*targets = NODE_MASK_NONE;
 }
 
+static inline void node_get_allowed_sources(pg_data_t *pgdat,
+					    nodemask_t *sources)
+{
+	*sources = NODE_MASK_NONE;
+}
+
 static inline bool node_is_toptier(int node)
 {
 	return true;
@@ -111,6 +118,12 @@ static inline void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *target
 	*targets = NODE_MASK_NONE;
 }
 
+static inline void node_get_allowed_sources(pg_data_t *pgdat,
+					    nodemask_t *sources)
+{
+	*sources = NODE_MASK_NONE;
+}
+
 static inline bool node_is_toptier(int node)
 {
 	return true;
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..40cb5900f857 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -74,6 +74,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
+#define MEMCG_RECLAIM_GOAL_EVICT (1 << 3)
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200
 
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..ec0560228b62 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -24,6 +24,8 @@ struct memory_tier {
 	struct device dev;
 	/* All the nodes that are part of all the lower memory tiers. */
 	nodemask_t lower_tier_mask;
+	/* All the nodes that are part of all the higher memory tiers. */
+	nodemask_t higher_tier_mask;
 };
 
 struct demotion_nodes {
@@ -317,6 +319,22 @@ void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 	rcu_read_unlock();
 }
 
+void node_get_allowed_sources(pg_data_t *pgdat, nodemask_t *sources)
+{
+	struct memory_tier *memtier;
+
+	/*
+	 * See node_get_allowed_targets() for the lifetime rules.
+	 */
+	rcu_read_lock();
+	memtier = rcu_dereference(pgdat->memtier);
+	if (memtier)
+		*sources = memtier->higher_tier_mask;
+	else
+		*sources = NODE_MASK_NONE;
+	rcu_read_unlock();
+}
+
 /**
  * next_demotion_node() - Get the next node in the demotion path
  * @node: The starting node to lookup the next node
@@ -385,8 +403,10 @@ static void disable_all_demotion_targets(void)
 		 * to access pgda->memtier.
 		 */
 		memtier = __node_get_memory_tier(node);
-		if (memtier)
+		if (memtier) {
 			memtier->lower_tier_mask = NODE_MASK_NONE;
+			memtier->higher_tier_mask = NODE_MASK_NONE;
+		}
 	}
 	/*
 	 * Ensure that the "disable" is visible across the system.
@@ -428,7 +448,7 @@ static void establish_demotion_targets(void)
 	struct demotion_nodes *nd;
 	int target = NUMA_NO_NODE, node;
 	int distance, best_distance;
-	nodemask_t tier_nodes, lower_tier;
+	nodemask_t tier_nodes, lower_tier, higher_tier;
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
@@ -514,6 +534,17 @@ static void establish_demotion_targets(void)
 		memtier->lower_tier_mask = lower_tier;
 	}
 
+	/*
+	 * Build the higher_tier mask for each node collecting node mask from
+	 * all memory tiers above it.
+	 */
+	higher_tier = NODE_MASK_NONE;
+	list_for_each_entry(memtier, &memory_tiers, list) {
+		tier_nodes = get_memtier_nodemask(memtier);
+		memtier->higher_tier_mask = higher_tier;
+		nodes_or(higher_tier, higher_tier, tier_nodes);
+	}
+
 	dump_demotion_targets();
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..cdaab8ad54ac 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -123,6 +123,9 @@ struct scan_control {
 	/* Proactive reclaim invoked by userspace */
 	unsigned int proactive:1;
 
+	/* Eviction-oriented proactive reclaim goal */
+	unsigned int evict_goal:1;
+
 	/*
 	 * Cgroup memory below memory.low is protected as long as we
 	 * don't threaten to OOM. If any cgroup is reclaimed at
@@ -166,9 +169,12 @@ struct scan_control {
 	/* Incremented by the number of inactive pages that were scanned */
 	unsigned long nr_scanned;
 
-	/* Number of pages freed so far during a call to shrink_zones() */
+	/* Number of pages reclaimed, including demotions */
 	unsigned long nr_reclaimed;
 
+	/* Number of reclaimed pages that were demoted */
+	unsigned long nr_demoted;
+
 	struct {
 		unsigned int dirty;
 		unsigned int congested;
@@ -181,6 +187,17 @@ struct scan_control {
 	struct reclaim_state reclaim_state;
 };
 
+static unsigned long reclaim_progress(struct scan_control *sc)
+{
+	if (!sc->evict_goal)
+		return sc->nr_reclaimed;
+
+	if (WARN_ON_ONCE(sc->nr_demoted > sc->nr_reclaimed))
+		return 0;
+
+	return sc->nr_reclaimed - sc->nr_demoted;
+}
+
 #ifdef ARCH_HAS_PREFETCHW
 #define prefetchw_prev_lru_folio(_folio, _base, _field)			\
 	do {								\
@@ -342,6 +359,53 @@ static bool can_demote(int nid, struct scan_control *sc,
 	return !nodes_empty(allowed_mask);
 }
 
+static bool memcg_has_demotion_target(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (can_demote(nid, NULL, memcg))
+			return true;
+	}
+
+	return false;
+}
+
+static bool memcg_node_is_demotion_target(int target_nid,
+					  struct mem_cgroup *memcg)
+{
+	struct pglist_data *pgdat = NODE_DATA(target_nid);
+	nodemask_t source_mask, target_mask;
+
+	if (!pgdat || !numa_demotion_enabled)
+		return false;
+
+	target_mask = nodemask_of_node(target_nid);
+	mem_cgroup_node_filter_allowed(memcg, &target_mask);
+	if (nodes_empty(target_mask))
+		return false;
+
+	node_get_allowed_sources(pgdat, &source_mask);
+	mem_cgroup_node_filter_allowed(memcg, &source_mask);
+	return !nodes_empty(source_mask);
+}
+
+static bool reclaim_skip_node(pg_data_t *pgdat, struct scan_control *sc)
+{
+	if (!sc->evict_goal || sc->nr_demoted < sc->nr_to_reclaim)
+		return false;
+	if (!can_demote(pgdat->node_id, sc, sc->target_mem_cgroup))
+		return false;
+
+	/*
+	 * Skip tiers that can demote but are not demotion targets from any
+	 * higher tier allowed to the cgroup once this batch's demotion work is
+	 * done. Other tiers keep aging toward lower tiers or eviction.
+	 */
+	return !memcg_node_is_demotion_target(pgdat->node_id,
+					      sc->target_mem_cgroup);
+}
+
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
 					  int nid,
 					  struct scan_control *sc)
@@ -1546,6 +1610,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
+	sc->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
 	if (!list_empty(&demote_folios)) {
 		/* Folios which weren't demoted go back on @folio_list */
@@ -5022,7 +5087,11 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (unlikely(sc->proactive && signal_pending(current)))
 		return true;
 
-	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
+	if (reclaim_progress(sc) >=
+	    max(sc->nr_to_reclaim, compact_gap(sc->order)))
+		return true;
+
+	if (reclaim_skip_node(lruvec_pgdat(lruvec), sc))
 		return true;
 
 	/* check the order to exclude compaction-induced reclaim */
@@ -6228,8 +6297,13 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
+		if (reclaim_skip_node(pgdat, sc)) {
+			mem_cgroup_iter_break(target_memcg, memcg);
+			break;
+		}
+
 		/* If partial walks are allowed, bail once goal is reached */
-		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
+		if (partial && reclaim_progress(sc) >= sc->nr_to_reclaim) {
 			mem_cgroup_iter_break(target_memcg, memcg);
 			break;
 		}
@@ -6500,6 +6574,8 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		if (zone->zone_pgdat == last_pgdat)
 			continue;
 		last_pgdat = zone->zone_pgdat;
+		if (reclaim_skip_node(last_pgdat, sc))
+			continue;
 		shrink_node(zone->zone_pgdat, sc);
 	}
 
@@ -6564,7 +6640,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		shrink_zones(zonelist, sc);
 
-		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
+		if (reclaim_progress(sc) >= sc->nr_to_reclaim)
 			break;
 
 		if (sc->compaction_ready)
@@ -6591,8 +6667,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 
 	delayacct_freepages_end();
 
-	if (sc->nr_reclaimed)
-		return sc->nr_reclaimed;
+	if (reclaim_progress(sc))
+		return reclaim_progress(sc);
 
 	/* Aborted reclaim to try compaction? don't OOM, then */
 	if (sc->compaction_ready)
@@ -6872,6 +6948,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.evict_goal = !!(reclaim_options &
+					MEMCG_RECLAIM_GOAL_EVICT),
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -7947,11 +8025,15 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_GOAL_PROGRESS,
+	MEMORY_RECLAIM_GOAL_EVICT,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_GOAL_PROGRESS, "goal=progress"},
+	{ MEMORY_RECLAIM_GOAL_EVICT, "goal=evict"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
@@ -7960,6 +8042,7 @@ int user_proactive_reclaim(char *buf,
 {
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	bool evict_goal = false;
 	int swappiness = -1;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
@@ -7991,11 +8074,24 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_GOAL_PROGRESS:
+			if (!memcg)
+				return -EINVAL;
+			evict_goal = false;
+			break;
+		case MEMORY_RECLAIM_GOAL_EVICT:
+			if (!memcg)
+				return -EINVAL;
+			evict_goal = true;
+			break;
 		default:
 			return -EINVAL;
 		}
 	}
 
+	if (nr_to_reclaim && evict_goal && !memcg_has_demotion_target(memcg))
+		evict_goal = false;
+
 	while (nr_reclaimed < nr_to_reclaim) {
 		/* Will converge on zero, but reclaim enforces a minimum */
 		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
@@ -8027,6 +8123,8 @@ int user_proactive_reclaim(char *buf,
 
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
+			if (evict_goal)
+				reclaim_options |= MEMCG_RECLAIM_GOAL_EVICT;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-- 
2.20.1
