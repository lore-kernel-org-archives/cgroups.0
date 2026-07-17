Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E37418A3E
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784296710; cv=none; b=qr88P2UD5/9OjcqmmYgd55WyODeDLDA7niVYqFxJOHN+X+lWhZCkJOkZR+Ji1IujNc2DsHGeic/QK21PHf5rMbE+sCnY629CC475DaR/NHiPHWfKea4ay+vBrHK/VHvPr9cNYWbrlntw+4lvq9Xab0NLbKeUIbbBJmtmGBDtXZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784296710; c=relaxed/simple;
	bh=d/OPAPRzZEsIQbLvhjnddrbLMehjDSssUFDdqOWjAFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4nG/kbDTEzh6VixGuidLN7SvfXoDSG9QONewZYNU4cSUOjmyPV1I97AeMlUCRHizTPQhOYdWIb7ErC7OhiqHmhKb8gBn/5LwYZ35zWMCLElrKIbQFcapHlV/Dx2oZSOiESRY4JTOUaPytkYFVZ80r4HcutigkkpRtbq0VP5kkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NpX5IdEB; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NpX5IdEB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784296705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P959ZWV1wEGCZUtvMBgbLNqjJR/eDmNAV2WkUpF3dOM=;
	b=NpX5IdEBEQsTLEiplo5d+knGwVQgH2w1c2p9ylpMM4uhYsFp+lYBz86G05l01DQUniAXG0
	y3TR9w+ZCTYhvO0DMHBLNmfNnXBDWugNX1IP2bdIoklz3mv/5/Rdz5vjOiGZe4mHnlPqXQ
	r5gBPC1XCJ6WJATOglAcNbypxqoRh90=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 2/2] mm/vmscan: reduce lru_lock contention via vmstat-derived scan-balance cost
Date: Fri, 17 Jul 2026 06:57:32 -0700
Message-ID: <20260717135807.3476029-3-usama.arif@linux.dev>
In-Reply-To: <20260717135807.3476029-1-usama.arif@linux.dev>
References: <20260717135807.3476029-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The anon/file scan balance in get_scan_count() is driven by two scalars
in struct lruvec, anon_cost and file_cost, accumulated by every reclaim
producer under lruvec->lru_lock. The acquisition sites for cost work
specifically are:

  - shrink_inactive_list() re-takes lru_lock at function exit purely
    to call lru_note_cost_unlock_irq() with (nr_pageout, nr_scanned -
    nr_reclaimed). One acquisition per inactive shrink.
  - shrink_active_list() does the same with (0, nr_rotated). One
    acquisition per active shrink.
  - workingset_refault() takes the lock via folio_lruvec_lock_irq()
    purely to record the refault cost. One acquisition per refault.
  - prepare_scan_control() takes lru_lock just to snapshot the two
    scalars into sc->{anon,file}_cost.
  - lru_note_cost_unlock_irq() itself walks parent_lruvec and
    re-acquires lru_lock on each ancestor to propagate the update,
    adding O(memcg-depth) acquisitions per producer call.

This hurts because lru_lock is already a heavy contention point on
memory-heavy workloads: every isolate_lru_folios(), move_folios_to_lru()
and folio_add_lru() takes it. The cost work itself is trivial (two
scalar bumps and one comparison), but it contends with and causes
contention for actual LRU manipulation. The parent_lruvec() walk also
multiplies cost-update overhead by memcg hierarchy depth.

Replace the producer-side accumulators with a read-side accumulator fed
from per-LRU vmstat counters. The old producer formula was:

  cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated

Reuse NR_VMSCAN_WRITE for reclaim-driven anon pageout submissions. It is
already bumped by writeout() for the same successful outcome that fed
reclaim_stat.nr_pageout. Reclaim does not submit filesystem folios from
this path, so there is no file pageout term. Charge NR_VMSCAN_WRITE via
lruvec_stat_mod_folio() and include it in memcg_node_stat_items so it can
be sampled per lruvec and aggregated through the memcg hierarchy.

Add explicit PGROTATE_{ANON,FILE} node_stat counters for the remaining
producer-local input. They are bumped from shrink_inactive_list() by
nr_scanned - nr_reclaimed and from shrink_active_list() by nr_rotated.
WORKINGSET_RESTORE_{ANON,FILE} already captures the refault IO that
lru_note_cost_refault() used to bill.

In prepare_scan_control() the raw cost signals are recomputed without
lru_lock as:

  anon = PGROTATE_ANON +
         (NR_VMSCAN_WRITE + WORKINGSET_RESTORE_ANON) * SWAP_CLUSTER_MAX
  file = PGROTATE_FILE +
         WORKINGSET_RESTORE_FILE * SWAP_CLUSTER_MAX

The delta against a per-lruvec prev_cost[] snapshot is folded into
cost_accum[]. Since one vmstat delta can cover many producer events
between reclaim passes, halve cost_accum[] until the total is back
within the lrusize/4 bound instead of halving only once.

Moving accumulation and decay to the reclaim side also improves the cost
model across reclaim gaps. With producer-side decay, events that happen
while reclaim is idle still age each other before reclaim ever samples
the costs. If a workload refaults a large anon set and then a smaller
file set before reclaim runs again, the later file activity can age the
earlier anon activity out of the cost model. The new scheme observes the
whole between-reclaim delta and decays anon and file proportionally, so
the scan-balance history better represents what happened since the last
reclaim pass.

A dedicated per-lruvec spinlock, cost_lock, serialises the prev_cost RMW,
the accumulator update, and the halving check against concurrent
reclaimers in the same memcg+node.

Hierarchy aggregation is now implicit in the vmstat accounting. The
producer-side parent_lruvec() walk and lru_reparent_memcg() cost splice
existed only because anon_cost/file_cost were private lruvec fields. With
the cost expressed as lruvec vmstats, rstat propagates the underlying
counters through the memcg hierarchy and prepare_scan_control() consumes
the same ratelimited rstat view as the surrounding reclaim heuristics.

NR_VMSCAN_WRITE is accounted at writeout(), so reclaim_stat.nr_pageout is
no longer needed and is removed.

memcg-v1's memory.stat anon_cost/file_cost is now sourced from
cost_accum[] instead of the removed lruvec anon_cost/file_cost fields.
The reported values only refresh when prepare_scan_control() runs and
are bounded at ~lrusize/4 by the halving loop; the scan-balance signal
they express is unchanged.

Under pure MGLRU the scan-balance signal itself is not consumed (both
prepare_scan_control() and get_scan_count() are short-circuited on the
MGLRU paths, and MGLRU's own type/tier selection comes from read_ctrl_pos()
on lrugen->{avg_refaulted,avg_total,refaulted,evicted}, not from
anon_cost/file_cost). NR_VMSCAN_WRITE naturally covers writeout from
either reclaim implementation, and PGROTATE_{ANON,FILE} are bumped from
evict_folios() so per-memcg observability of rotation-driven reclaim work
stays consistent across both implementations.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/mmzone.h | 10 ++++-
 include/linux/swap.h   |  3 --
 include/linux/vmstat.h |  1 -
 mm/memcontrol-v1.c     |  4 +-
 mm/memcontrol.c        |  5 ++-
 mm/mmzone.c            |  1 +
 mm/swap.c              | 69 ----------------------------------
 mm/vmscan.c            | 84 +++++++++++++++++++++++++++++++++++-------
 mm/vmstat.c            |  2 +
 mm/workingset.c        |  5 ---
 10 files changed, 87 insertions(+), 97 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..3ac467959e34 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,8 @@ enum node_stat_item {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
@@ -763,9 +765,13 @@ struct lruvec {
 	 * These track the cost of reclaiming one LRU - file or anon -
 	 * over the other. As the observed cost of reclaiming one LRU
 	 * increases, the reclaim scan balance tips toward the other.
+	 * Updated and decayed at prepare_scan_control() time; cost_lock
+	 * serialises that update.
 	 */
-	unsigned long			anon_cost;
-	unsigned long			file_cost;
+	unsigned long			prev_cost[ANON_AND_FILE];
+	unsigned long			cost_accum[ANON_AND_FILE];
+	/* Protects prev_cost and cost_accum. */
+	spinlock_t			cost_lock;
 	/* Non-resident age, driven by LRU movement */
 	atomic_long_t			nonresident_age;
 	/* Refaults at the time of last reclaim cycle */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6d72778e6cc3..d35a4761ebd7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -309,9 +309,6 @@ extern unsigned long totalreserve_pages;
 
 
 /* linux/mm/swap.c */
-void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
-		unsigned int nr_io, unsigned int nr_rotated);
-void lru_note_cost_refault(struct folio *);
 void folio_add_lru(struct folio *);
 void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
 void mark_page_accessed(struct page *);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index fb8c76289e02..5b31d8e7ae40 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -20,7 +20,6 @@ struct reclaim_stat {
 	unsigned nr_congested;
 	unsigned nr_writeback;
 	unsigned nr_immediate;
-	unsigned nr_pageout;
 	unsigned nr_activate[ANON_AND_FILE];
 	unsigned nr_ref_keep;
 	unsigned nr_unmap_fail;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 765069211567..c7a52bb68f4c 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1988,8 +1988,8 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 		for_each_online_pgdat(pgdat) {
 			mz = memcg->nodeinfo[pgdat->node_id];
 
-			anon_cost += mz->lruvec.anon_cost;
-			file_cost += mz->lruvec.file_cost;
+			anon_cost += mz->lruvec.cost_accum[WORKINGSET_ANON];
+			file_cost += mz->lruvec.cost_accum[WORKINGSET_FILE];
 		}
 		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
 		seq_buf_printf(s, "file_cost %lu\n", file_cost);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b4a357c5f7e0..8693aad26ca2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -393,6 +393,7 @@ static const unsigned int memcg_node_stat_items[] = {
 	NR_SHMEM_THPS,
 	NR_FILE_THPS,
 	NR_ANON_THPS,
+	NR_VMSCAN_WRITE,
 	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,
 	NR_PAGETABLE,
@@ -419,6 +420,8 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
@@ -518,7 +521,7 @@ unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx)
  * reading from per-CPU delta skew must present as zero.
  *
  * XXX: This helper (and its node/global peers) exists because we place
- * monotonically-incremented event counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*)
+ * monotonically-incremented event counters (NR_VMSCAN_WRITE and PGROTATE_*)
  * into enum node_stat_item.
  */
 unsigned long lruvec_page_state_monotonic(struct lruvec *lruvec,
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 0c8f181d9d50..17139db4d291 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -78,6 +78,7 @@ void lruvec_init(struct lruvec *lruvec)
 
 	memset(lruvec, 0, sizeof(struct lruvec));
 	spin_lock_init(&lruvec->lru_lock);
+	spin_lock_init(&lruvec->cost_lock);
 	zswap_lruvec_state_init(lruvec);
 
 	for_each_lru(lru)
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..74b281778cbc 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -272,73 +272,6 @@ void folio_rotate_reclaimable(struct folio *folio)
 	folio_batch_add_and_move(folio, lru_move_tail);
 }
 
-void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
-		unsigned int nr_io, unsigned int nr_rotated)
-		__releases(lruvec->lru_lock)
-		__releases(rcu)
-{
-	unsigned long cost;
-
-	/*
-	 * Reflect the relative cost of incurring IO and spending CPU
-	 * time on rotations. This doesn't attempt to make a precise
-	 * comparison, it just says: if reloads are about comparable
-	 * between the LRU lists, or rotations are overwhelmingly
-	 * different between them, adjust scan balance for CPU work.
-	 */
-	cost = nr_io * SWAP_CLUSTER_MAX + nr_rotated;
-	if (!cost) {
-		spin_unlock_irq(&lruvec->lru_lock);
-		rcu_read_unlock();
-		return;
-	}
-
-	for (;;) {
-		unsigned long lrusize;
-
-		/* Record cost event */
-		if (file)
-			lruvec->file_cost += cost;
-		else
-			lruvec->anon_cost += cost;
-
-		/*
-		 * Decay previous events
-		 *
-		 * Because workloads change over time (and to avoid
-		 * overflow) we keep these statistics as a floating
-		 * average, which ends up weighing recent refaults
-		 * more than old ones.
-		 */
-		lrusize = lruvec_page_state(lruvec, NR_INACTIVE_ANON) +
-			  lruvec_page_state(lruvec, NR_ACTIVE_ANON) +
-			  lruvec_page_state(lruvec, NR_INACTIVE_FILE) +
-			  lruvec_page_state(lruvec, NR_ACTIVE_FILE);
-
-		if (lruvec->file_cost + lruvec->anon_cost > lrusize / 4) {
-			lruvec->file_cost /= 2;
-			lruvec->anon_cost /= 2;
-		}
-
-		spin_unlock_irq(&lruvec->lru_lock);
-		lruvec = parent_lruvec(lruvec);
-		if (!lruvec) {
-			rcu_read_unlock();
-			break;
-		}
-		spin_lock_irq(&lruvec->lru_lock);
-	}
-}
-
-void lru_note_cost_refault(struct folio *folio)
-{
-	struct lruvec *lruvec;
-
-	lruvec = folio_lruvec_lock_irq(folio);
-	lru_note_cost_unlock_irq(lruvec, folio_is_file_lru(folio),
-				folio_nr_pages(folio), 0);
-}
-
 static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
@@ -1164,8 +1097,6 @@ void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int
 
 	child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-	parent_lruvec->anon_cost += child_lruvec->anon_cost;
-	parent_lruvec->file_cost += child_lruvec->file_cost;
 
 	for_each_lru(lru)
 		lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..515d913ed5dc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -641,7 +641,7 @@ static pageout_t writeout(struct folio *folio, struct address_space *mapping,
 		folio_clear_reclaim(folio);
 
 	trace_mm_vmscan_write_folio(folio);
-	node_stat_add_folio(folio, NR_VMSCAN_WRITE);
+	lruvec_stat_mod_folio(folio, NR_VMSCAN_WRITE, folio_nr_pages(folio));
 	return PAGE_SUCCESS;
 }
 
@@ -1418,8 +1418,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					sc->nr_scanned -= (nr_pages - 1);
 					nr_pages = 1;
 				}
-				stat->nr_pageout += nr_pages;
-
 				if (folio_test_writeback(folio))
 					goto keep;
 				if (folio_test_dirty(folio))
@@ -2043,10 +2041,10 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
+	if (nr_scanned > nr_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file,
+				 nr_scanned - nr_reclaimed);
 
-	lruvec_lock_irq(lruvec);
-	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
-					nr_scanned - nr_reclaimed);
 	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
@@ -2152,9 +2150,9 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	if (nr_rotated)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
-	lruvec_lock_irq(lruvec);
-	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
 	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
 			nr_deactivate, nr_rotated, sc->priority, file);
 }
@@ -2303,12 +2301,63 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	mem_cgroup_flush_stats_ratelimited(sc->target_mem_cgroup);
 
 	/*
-	 * Determine the scan balance between anon and file LRUs.
+	 * Determine the scan balance between anon and file LRUs from per-LRU
+	 * vmstat counters. The raw cost per side is:
+	 *
+	 *	PGROTATE	   - reclaim-driven rotations, bumped from both
+	 *			     shrink_inactive_list and shrink_active_list
+	 *			     (CPU work).
+	 *	NR_VMSCAN_WRITE    - reclaim-driven anon pageout IO.
+	 *	WORKINGSET_RESTORE - refaults of previously-workingset pages.
+	 *
+	 * The two IO terms are weighted by SWAP_CLUSTER_MAX to reflect the
+	 * higher cost of an IO over a rotation.
+	 *
+	 * Reads are lock-free per-cpu sum collations, rstat-aggregated up
+	 * the memcg hierarchy by mem_cgroup_flush_stats_ratelimited() above.
+	 * Use lruvec_page_state_monotonic() so the unsigned subtraction
+	 * `now - prev_cost[f]` yields the correct delta across a signed-long
+	 * wraparound of the underlying counter (a real hazard on 32-bit that
+	 * the clamp in lruvec_page_state() would otherwise turn into a huge
+	 * spurious delta).
+	 *
+	 * The delta against prev_cost is folded into cost_accum, which is
+	 * halved on both sides until their sum is within lrusize/4.
+	 * cost_lock serialises concurrent reclaimers in the same memcg+node.
 	 */
-	spin_lock_irq(&target_lruvec->lru_lock);
-	sc->anon_cost = target_lruvec->anon_cost;
-	sc->file_cost = target_lruvec->file_cost;
-	spin_unlock_irq(&target_lruvec->lru_lock);
+	spin_lock(&target_lruvec->cost_lock);
+	for (int f = 0; f <= 1; f++) {
+		unsigned long now, delta;
+
+		now = lruvec_page_state_monotonic(target_lruvec, PGROTATE_ANON + f) +
+		      lruvec_page_state_monotonic(target_lruvec,
+						  WORKINGSET_RESTORE_BASE + f) *
+				SWAP_CLUSTER_MAX;
+		if (f == WORKINGSET_ANON)
+			now += lruvec_page_state_monotonic(target_lruvec,
+							   NR_VMSCAN_WRITE) *
+				SWAP_CLUSTER_MAX;
+		delta = now - target_lruvec->prev_cost[f];
+		target_lruvec->prev_cost[f] = now;
+		target_lruvec->cost_accum[f] += delta;
+	}
+	unsigned long lrusize =
+		lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
+		lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
+		lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
+		lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
+	unsigned long cost_limit = lrusize / 4;
+
+	while (target_lruvec->cost_accum[WORKINGSET_ANON] > cost_limit ||
+	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit ||
+	       target_lruvec->cost_accum[WORKINGSET_ANON] +
+	       target_lruvec->cost_accum[WORKINGSET_FILE] > cost_limit) {
+		target_lruvec->cost_accum[WORKINGSET_ANON] /= 2;
+		target_lruvec->cost_accum[WORKINGSET_FILE] /= 2;
+	}
+	sc->anon_cost = target_lruvec->cost_accum[WORKINGSET_ANON];
+	sc->file_cost = target_lruvec->cost_accum[WORKINGSET_FILE];
+	spin_unlock(&target_lruvec->cost_lock);
 
 	/*
 	 * Target desirable inactive:active list ratios for the anon
@@ -4815,7 +4864,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
-	int isolated = 0, type, type_scanned;
+	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	unsigned long total_reclaimed = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4827,6 +4877,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
+	nr_isolated = isolated;
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4839,6 +4890,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	total_reclaimed += reclaimed;
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
@@ -4892,6 +4944,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (nr_isolated > total_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
+				 nr_isolated - total_reclaimed);
+
 	return scanned;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c4364f0eb08a..87d4a6781367 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1300,6 +1300,8 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
+	[I(PGROTATE_ANON)]			= "pgrotate_anon",
+	[I(PGROTATE_FILE)]			= "pgrotate_file",
 	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723a..7ac2b88c80ae 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -584,11 +584,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 	/* Folio was active prior to eviction */
 	if (workingset) {
 		folio_set_workingset(folio);
-		/*
-		 * XXX: Move to folio_add_lru() when it supports new vs
-		 * putback
-		 */
-		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
 out:
-- 
2.53.0-Meta

