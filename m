From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mm: vmpressure: don't count userspace-induced reclaim as
 memory pressure
Date: Thu, 23 Jun 2022 00:05:30 +0000
Message-ID: <20220623000530.1194226-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NE26KXmlK1GCxA+we6/9NzWq7J22ckFu4u4+VdYg2g0=;
        b=r5PfAqTHW1+T6eTREWuKgkPYre45Fy4dE9Hr7AM/h2v3qwivgM0VJxxGoNGXeqcvL8
         xrx7CMnYQGvo8pwjhZ6Wphc2ztn8ve+EcDIbJmb4o5n8gkDuZXlKKvmLlgIdtsH/JStF
         USw9OKgnrNfvua1L30T6TYHfon94pDOSXwrsnpx8lvK/G4+cKypgjwV8GQLPPheNF1lE
         Y/xwicw0s4+XgS53X0V1ROQ3wzzgXRQbjCSVngr4EwkGgdnjmHlXgVDdwlk0KDh2AumW
         Uf8v5GhwmfD+kR6LmJ/d5tD0fMxnvdUTvaT8EnbMgxIvnKvXnHr8H8yuunER3mqg3cVi
         EL0w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
as memory pressure") made sure that memory reclaim that is induced by
userspace (limit-setting, proactive reclaim, ..) is not counted as
memory pressure for the purposes of psi.

Instead of counting psi inside try_to_free_mem_cgroup_pages(), callers
from try_charge() and reclaim_high() wrap the call to
try_to_free_mem_cgroup_pages() with psi handlers.

However, vmpressure is still counted in these cases where reclaim is
directly induced by userspace. This patch makes sure vmpressure is not
counted in those operations, in the same way as psi. Since vmpressure
calls need to happen deeper within the reclaim path, the same approach
could not be followed. Hence, a new "controlled" flag is added to struct
scan_control to flag a reclaim operation that is controlled by
userspace. This flag is set by limit-setting and proactive reclaim
operations, and is used to count vmpressure correctly.

To prevent future divergence of psi and vmpressure, commit e22c6ed90aa9
("mm: memcontrol: don't count limit-setting reclaim as memory pressure")
is effectively reverted and the same flag is used to control psi as
well.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/swap.h |  5 ++++-
 mm/memcontrol.c      | 40 ++++++++++++++++++++++------------------
 mm/vmscan.c          | 40 ++++++++++++++++++++++++++++++----------
 3 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0c0fed1b348f2..5a6766e417afe 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -411,10 +411,13 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
+
+#define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
+#define MEMCG_RECLAIM_CONTROLLED (1 << 2)
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
-						  bool may_swap);
+						  unsigned int reclaim_options);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index abec50f31fe64..a76bb7ae76f73 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2319,20 +2319,16 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 				  gfp_t gfp_mask)
 {
 	unsigned long nr_reclaimed = 0;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 
 	do {
-		unsigned long pflags;
-
 		if (page_counter_read(&memcg->memory) <=
 		    READ_ONCE(memcg->memory.high))
 			continue;
-
 		memcg_memory_event(memcg, MEMCG_HIGH);
-
-		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
-							     gfp_mask, true);
-		psi_memstall_leave(&pflags);
+							     gfp_mask,
+							     reclaim_options);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
 
@@ -2576,9 +2572,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
-	bool may_swap = true;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	bool drained = false;
-	unsigned long pflags;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
@@ -2593,7 +2588,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		mem_over_limit = mem_cgroup_from_counter(counter, memory);
 	} else {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
-		may_swap = false;
+		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 	}
 
 	if (batch > nr_pages) {
@@ -2618,10 +2613,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	memcg_memory_event(mem_over_limit, MEMCG_MAX);
 
-	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, may_swap);
-	psi_memstall_leave(&pflags);
+						    gfp_mask, reclaim_options);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
 		goto retry;
@@ -3369,7 +3362,9 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 	int ret;
 	bool limits_invariant;
 	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
+	unsigned int reclaim_options = memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP;
 
+	reclaim_options |= MEMCG_RECLAIM_CONTROLLED;
 	do {
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -3403,7 +3398,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1,
-					GFP_KERNEL, !memsw)) {
+					GFP_KERNEL, reclaim_options)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -3502,6 +3497,8 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
 	int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned int reclaim_options = MEMCG_RECLAIM_CONTROLLED |
+		MEMCG_RECLAIM_MAY_SWAP;
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
@@ -3513,7 +3510,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 		if (signal_pending(current))
 			return -EINTR;
 
-		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true))
+		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
+						  reclaim_options))
 			nr_retries--;
 	}
 
@@ -6215,6 +6213,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	bool drained = false;
 	unsigned long high;
+	unsigned int reclaim_options = MEMCG_RECLAIM_CONTROLLED |
+		MEMCG_RECLAIM_MAY_SWAP;
 	int err;
 
 	buf = strstrip(buf);
@@ -6241,7 +6241,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-							 GFP_KERNEL, true);
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -6264,6 +6264,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	unsigned int nr_reclaims = MAX_RECLAIM_RETRIES;
 	bool drained = false;
 	unsigned long max;
+	unsigned int reclaim_options = MEMCG_RECLAIM_CONTROLLED |
+		MEMCG_RECLAIM_MAY_SWAP;
 	int err;
 
 	buf = strstrip(buf);
@@ -6290,7 +6292,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-							  GFP_KERNEL, true))
+						GFP_KERNEL, reclaim_options))
 				nr_reclaims--;
 			continue;
 		}
@@ -6419,6 +6421,8 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
+	unsigned int reclaim_options = MEMCG_RECLAIM_CONTROLLED |
+		MEMCG_RECLAIM_MAY_SWAP;
 	int err;
 
 	buf = strstrip(buf);
@@ -6442,7 +6446,7 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						nr_to_reclaim - nr_reclaimed,
-						GFP_KERNEL, true);
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f7d9a683e3a7d..6efe7660f7f78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -102,6 +102,9 @@ struct scan_control {
 	/* Can pages be swapped as part of reclaim? */
 	unsigned int may_swap:1;
 
+	/* Reclaim is controlled by userspace */
+	unsigned int controlled:1;
+
 	/*
 	 * Cgroup memory below memory.low is protected as long as we
 	 * don't threaten to OOM. If any cgroup is reclaimed at
@@ -3125,9 +3128,10 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 			    sc->priority);
 
 		/* Record the group's reclaim efficiency */
-		vmpressure(sc->gfp_mask, memcg, false,
-			   sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
+		if (!sc->controlled)
+			vmpressure(sc->gfp_mask, memcg, false,
+				   sc->nr_scanned - scanned,
+				   sc->nr_reclaimed - reclaimed);
 
 	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
 }
@@ -3250,9 +3254,10 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	}
 
 	/* Record the subtree's reclaim efficiency */
-	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
-		   sc->nr_scanned - nr_scanned,
-		   sc->nr_reclaimed - nr_reclaimed);
+	if (!sc->controlled)
+		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+			   sc->nr_scanned - nr_scanned,
+			   sc->nr_reclaimed - nr_reclaimed);
 
 	if (sc->nr_reclaimed - nr_reclaimed)
 		reclaimable = true;
@@ -3534,8 +3539,9 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		__count_zid_vm_events(ALLOCSTALL, sc->reclaim_idx, 1);
 
 	do {
-		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
-				sc->priority);
+		if (!sc->controlled)
+			vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
+					sc->priority);
 		sc->nr_scanned = 0;
 		shrink_zones(zonelist, sc);
 
@@ -3751,6 +3757,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
 		.may_swap = 1,
+		.controlled = 0,
 	};
 
 	/*
@@ -3825,10 +3832,12 @@ unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-					   bool may_swap)
+					   unsigned int reclaim_options)
 {
 	unsigned long nr_reclaimed;
+	unsigned long pflags;
 	unsigned int noreclaim_flag;
+	bool controlled_reclaim = reclaim_options & MEMCG_RECLAIM_CONTROLLED;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
 		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
@@ -3838,7 +3847,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.priority = DEF_PRIORITY,
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
-		.may_swap = may_swap,
+		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
+		.controlled = controlled_reclaim,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -3848,12 +3858,19 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
+
 	trace_mm_vmscan_memcg_reclaim_begin(0, sc.gfp_mask);
+
+	if (!controlled_reclaim)
+		psi_memstall_enter(&pflags);
 	noreclaim_flag = memalloc_noreclaim_save();
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
+	if (!controlled_reclaim)
+		psi_memstall_leave(&pflags);
+
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 	set_task_reclaim_state(current, NULL);
 
@@ -4095,6 +4112,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 		.gfp_mask = GFP_KERNEL,
 		.order = order,
 		.may_unmap = 1,
+		.controlled = 0,
 	};
 
 	set_task_reclaim_state(current, &sc.reclaim_state);
@@ -4555,6 +4573,7 @@ unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 		.may_unmap = 1,
 		.may_swap = 1,
 		.hibernation_mode = 1,
+		.controlled = 0,
 	};
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 	unsigned long nr_reclaimed;
@@ -4707,6 +4726,7 @@ static int __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned in
 		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
 		.may_swap = 1,
 		.reclaim_idx = gfp_zone(gfp_mask),
+		.controlled = 0,
 	};
 	unsigned long pflags;
 
-- 
2.37.0.rc0.104.g0611611a94-goog

