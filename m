From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: memcg: make sure memory.events is uptodate when waking
 pollers
Date: Thu, 5 Apr 2018 13:55:16 -0400
Message-ID: <20180405175507.GA24817@cmpxchg.org>
References: <20180324160901.512135-1-tj@kernel.org>
 <20180324160901.512135-2-tj@kernel.org>
 <20180404140855.GA28966@cmpxchg.org>
 <20180404141850.GC28966@cmpxchg.org>
 <20180404143447.GJ6312@dhcp22.suse.cz>
 <20180404165829.GA3126663@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SBvcwuUXXP0nnTNMzGSVHzpT/TERq69YQ2Gtb2SnwuM=; b=euWM+39R5XACjTtLN/a2TFC7Qx
        0a8KjICixTuejOTRecTlfBZXWHNLqQ69aF8R94ivxpAKfsP8HVFGdvd/LoPCfcyUsYinx5GsQMcwy
        TEW/bIPgSTthJO0EWsGJOcQJg/4luVoscw28r/QLtcPlUUZNR6S/6+S+YCclxvm2WVc8=;
Content-Disposition: inline
In-Reply-To: <20180404165829.GA3126663@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, Apr 04, 2018 at 09:58:29AM -0700, Tejun Heo wrote:
> On Wed, Apr 04, 2018 at 04:34:47PM +0200, Michal Hocko wrote:
> > > > The lazy updates are neat, but I'm a little concerned at the memory
> > > > footprint. On a 64-cpu machine for example, this adds close to 9000
> > > > words to struct mem_cgroup. And we really only need the accuracy for
> > > > the 4 cgroup items in memory.events, not all VM events and stats.
> > > > 
> > > > Why not restrict the patch to those? It would also get rid of the
> > > > weird sharing between VM and cgroup enums.
> > > 
> > > In fact, I wonder if we need per-cpuness for MEMCG_LOW, MEMCG_HIGH
> > > etc. in the first place. They describe super high-level reclaim and
> > > OOM events, so they're not nearly as hot as other VM events and
> > > stats. We could probably just have a per-memcg array of atomics.
> > 
> > Agreed!
> 
> Ah, yeah, if we aren't worried about the update frequency of
> MEMCG_HIGH, which likely is the highest freq, we can just switch to
> atomic_t.  I'm gonna apply the cgroup stat refactoring patches to
> cgroup, so if we ever wanna switch the counter to rstat, we can easily
> do that later.

Yeah, that's still great to have as generalized infrastructure.

For memory.events, how about this instead?

---

From 4369ce161a9085aa408f2eca54f9de72909ee1b1 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 5 Apr 2018 11:53:55 -0400
Subject: [PATCH] mm: memcg: make sure memory.events is uptodate when waking
 pollers

a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat
reporting") added per-cpu drift to all memory cgroup stats and events
shown in memory.stat and memory.events.

For memory.stat this is acceptable. But memory.events issues file
notifications, and somebody polling the file for changes will be
confused when the counters in it are unchanged after a wakeup.

Luckily, the events in memory.events - MEMCG_LOW, MEMCG_HIGH,
MEMCG_MAX, MEMCG_OOM - are sufficiently rare and high-level that we
don't need per-cpu buffering for them: MEMCG_HIGH and MEMCG_MAX would
be the most frequent, but they're counting invocations of reclaim,
which is a complex operation that touches many shared cachelines.

This splits memory.events from the generic VM events and tracks them
in their own, unbuffered atomic counters. That's also cleaner, as it
eliminates the ugly enum nesting of VM and cgroup events.

Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 35 ++++++++++++++++++-----------------
 mm/memcontrol.c            | 31 ++++++++++++++++++-------------
 mm/vmscan.c                |  2 +-
 3 files changed, 37 insertions(+), 31 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c46016bb25eb..6503a9ca27c1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -48,13 +48,12 @@ enum memcg_stat_item {
 	MEMCG_NR_STAT,
 };
 
-/* Cgroup-specific events, on top of universal VM events */
-enum memcg_event_item {
-	MEMCG_LOW = NR_VM_EVENT_ITEMS,
+enum memcg_memory_event {
+	MEMCG_LOW,
 	MEMCG_HIGH,
 	MEMCG_MAX,
 	MEMCG_OOM,
-	MEMCG_NR_EVENTS,
+	MEMCG_NR_MEMORY_EVENTS,
 };
 
 struct mem_cgroup_reclaim_cookie {
@@ -88,7 +87,7 @@ enum mem_cgroup_events_target {
 
 struct mem_cgroup_stat_cpu {
 	long count[MEMCG_NR_STAT];
-	unsigned long events[MEMCG_NR_EVENTS];
+	unsigned long events[NR_VM_EVENT_ITEMS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
 };
@@ -202,7 +201,8 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
-	/* handle for "memory.events" */
+	/* memory.events */
+	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
 	struct cgroup_file events_file;
 
 	/* protect arrays of thresholds */
@@ -231,9 +231,10 @@ struct mem_cgroup {
 	struct task_struct	*move_lock_task;
 	unsigned long		move_lock_flags;
 
+	/* memory.stat */
 	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
 	atomic_long_t		stat[MEMCG_NR_STAT];
-	atomic_long_t		events[MEMCG_NR_EVENTS];
+	atomic_long_t		events[NR_VM_EVENT_ITEMS];
 
 	unsigned long		socket_pressure;
 
@@ -645,9 +646,9 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 						gfp_t gfp_mask,
 						unsigned long *total_scanned);
 
-/* idx can be of type enum memcg_event_item or vm_event_item */
 static inline void __count_memcg_events(struct mem_cgroup *memcg,
-					int idx, unsigned long count)
+					enum vm_event_item idx,
+					unsigned long count)
 {
 	unsigned long x;
 
@@ -663,7 +664,8 @@ static inline void __count_memcg_events(struct mem_cgroup *memcg,
 }
 
 static inline void count_memcg_events(struct mem_cgroup *memcg,
-				      int idx, unsigned long count)
+				      enum vm_event_item idx,
+				      unsigned long count)
 {
 	unsigned long flags;
 
@@ -672,9 +674,8 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
 	local_irq_restore(flags);
 }
 
-/* idx can be of type enum memcg_event_item or vm_event_item */
 static inline void count_memcg_page_event(struct page *page,
-					  int idx)
+					  enum vm_event_item idx)
 {
 	if (page->mem_cgroup)
 		count_memcg_events(page->mem_cgroup, idx, 1);
@@ -698,10 +699,10 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	rcu_read_unlock();
 }
 
-static inline void mem_cgroup_event(struct mem_cgroup *memcg,
-				    enum memcg_event_item event)
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
 {
-	count_memcg_events(memcg, event, 1);
+	atomic_long_inc(&memcg->memory_events[event]);
 	cgroup_file_notify(&memcg->events_file);
 }
 
@@ -721,8 +722,8 @@ static inline bool mem_cgroup_disabled(void)
 	return true;
 }
 
-static inline void mem_cgroup_event(struct mem_cgroup *memcg,
-				    enum memcg_event_item event)
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9ec024b862ac..e29c80b4a9ee 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1839,7 +1839,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 			}
 		}
 
-		for (i = 0; i < MEMCG_NR_EVENTS; i++) {
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
 			long x;
 
 			x = this_cpu_xchg(memcg->stat_cpu->events[i], 0);
@@ -1858,7 +1858,7 @@ static void reclaim_high(struct mem_cgroup *memcg,
 	do {
 		if (page_counter_read(&memcg->memory) <= memcg->high)
 			continue;
-		mem_cgroup_event(memcg, MEMCG_HIGH);
+		memcg_memory_event(memcg, MEMCG_HIGH);
 		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 }
@@ -1949,7 +1949,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	mem_cgroup_event(mem_over_limit, MEMCG_MAX);
+	memcg_memory_event(mem_over_limit, MEMCG_MAX);
 
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
 						    gfp_mask, may_swap);
@@ -1992,7 +1992,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (fatal_signal_pending(current))
 		goto force;
 
-	mem_cgroup_event(mem_over_limit, MEMCG_OOM);
+	memcg_memory_event(mem_over_limit, MEMCG_OOM);
 
 	mem_cgroup_oom(mem_over_limit, gfp_mask,
 		       get_order(nr_pages * PAGE_SIZE));
@@ -2688,10 +2688,10 @@ static void tree_events(struct mem_cgroup *memcg, unsigned long *events)
 	struct mem_cgroup *iter;
 	int i;
 
-	memset(events, 0, sizeof(*events) * MEMCG_NR_EVENTS);
+	memset(events, 0, sizeof(*events) * NR_VM_EVENT_ITEMS);
 
 	for_each_mem_cgroup_tree(iter, memcg) {
-		for (i = 0; i < MEMCG_NR_EVENTS; i++)
+		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
 			events[i] += memcg_sum_events(iter, i);
 	}
 }
@@ -5178,7 +5178,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		mem_cgroup_event(memcg, MEMCG_OOM);
+		memcg_memory_event(memcg, MEMCG_OOM);
 		if (!mem_cgroup_out_of_memory(memcg, GFP_KERNEL, 0))
 			break;
 	}
@@ -5191,11 +5191,16 @@ static int memory_events_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 
-	seq_printf(m, "low %lu\n", memcg_sum_events(memcg, MEMCG_LOW));
-	seq_printf(m, "high %lu\n", memcg_sum_events(memcg, MEMCG_HIGH));
-	seq_printf(m, "max %lu\n", memcg_sum_events(memcg, MEMCG_MAX));
-	seq_printf(m, "oom %lu\n", memcg_sum_events(memcg, MEMCG_OOM));
-	seq_printf(m, "oom_kill %lu\n", memcg_sum_events(memcg, OOM_KILL));
+	seq_printf(m, "low %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_LOW]));
+	seq_printf(m, "high %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_HIGH]));
+	seq_printf(m, "max %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_MAX]));
+	seq_printf(m, "oom %lu\n",
+		   atomic_long_read(&memcg->memory_events[MEMCG_OOM]));
+	seq_printf(m, "oom_kill %lu\n",
+		   atomic_long_read(&memcg->memory_events[OOM_KILL]));
 
 	return 0;
 }
@@ -5204,7 +5209,7 @@ static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
 	unsigned long stat[MEMCG_NR_STAT];
-	unsigned long events[MEMCG_NR_EVENTS];
+	unsigned long events[NR_VM_EVENT_ITEMS];
 	int i;
 
 	/*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index cd5dc3faaa57..7cdace56222f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2544,7 +2544,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 					sc->memcg_low_skipped = 1;
 					continue;
 				}
-				mem_cgroup_event(memcg, MEMCG_LOW);
+				memcg_memory_event(memcg, MEMCG_LOW);
 			}
 
 			reclaimed = sc->nr_reclaimed;
-- 
2.16.3

