From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 1/2] mm: Rename ambiguously named memory.stat counters and
 functions
Date: Fri, 8 Feb 2019 22:43:19 +0000
Message-ID: <20190208224319.GA23801@chrisdown.name>
References: <20190123223144.GA10798@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=qEhiWB+rK/9iHqqYezdOKf30G2VGfrb5M4E9rdjBBZo=;
        b=EsAfVVn21c36p+RKUj/nyiAKhHhCN1k7pZTYmI1j5aAHwgtIqxXdQ44fVRJX1+mFpU
         dP7gDZ2he3FOkRudxQAfs7LVhUt7jfnl1nhR/wqBpXL20K0b1EKk2dfjHN9JBbIb3jQV
         m+Wd+UdyFAU28CYgkUAbOapi44LwwLSXl7vt8=
Content-Disposition: inline
In-Reply-To: <20190123223144.GA10798@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

I spent literally an hour trying to work out why an earlier version of
my memory.events aggregation code doesn't work properly, only to find
out I was calling memcg->events instead of memcg->memory_events, which
is fairly confusing.

This naming seems in need of reworking, so make it harder to do the
wrong thing by using vmevents instead of events, which makes it more
clear that these are vm counters rather than memcg-specific counters.

There are also a few other inconsistent names in both the percpu and
aggregated structs, so these are all cleaned up to be more coherent and
easy to understand.

This commit contains code cleanup only: there are no logic changes.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 include/linux/memcontrol.h |  24 +++----
 mm/memcontrol.c            | 144 +++++++++++++++++++------------------
 2 files changed, 86 insertions(+), 82 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 1803abfd7c00..94f9c5bc26ff 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -94,8 +94,8 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-struct mem_cgroup_stat_cpu {
-	long count[MEMCG_NR_STAT];
+struct memcg_vmstats_percpu {
+	long stat[MEMCG_NR_STAT];
 	unsigned long events[NR_VM_EVENT_ITEMS];
 	unsigned long nr_page_events;
 	unsigned long targets[MEM_CGROUP_NTARGETS];
@@ -274,12 +274,12 @@ struct mem_cgroup {
 	struct task_struct	*move_lock_task;
 
 	/* memory.stat */
-	struct mem_cgroup_stat_cpu __percpu *stat_cpu;
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
 	MEMCG_PADDING(_pad2_);
 
-	atomic_long_t		stat[MEMCG_NR_STAT];
-	atomic_long_t		events[NR_VM_EVENT_ITEMS];
+	atomic_long_t		vmstats[MEMCG_NR_STAT];
+	atomic_long_t		vmevents[NR_VM_EVENT_ITEMS];
 	atomic_long_t memory_events[MEMCG_NR_MEMORY_EVENTS];
 
 	unsigned long		socket_pressure;
@@ -585,7 +585,7 @@ void unlock_page_memcg(struct page *page);
 static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
 					     int idx)
 {
-	long x = atomic_long_read(&memcg->stat[idx]);
+	long x = atomic_long_read(&memcg->vmstats[idx]);
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -602,12 +602,12 @@ static inline void __mod_memcg_state(struct mem_cgroup *memcg,
 	if (mem_cgroup_disabled())
 		return;
 
-	x = val + __this_cpu_read(memcg->stat_cpu->count[idx]);
+	x = val + __this_cpu_read(memcg->vmstats_percpu->stat[idx]);
 	if (unlikely(abs(x) > MEMCG_CHARGE_BATCH)) {
-		atomic_long_add(x, &memcg->stat[idx]);
+		atomic_long_add(x, &memcg->vmstats[idx]);
 		x = 0;
 	}
-	__this_cpu_write(memcg->stat_cpu->count[idx], x);
+	__this_cpu_write(memcg->vmstats_percpu->stat[idx], x);
 }
 
 /* idx can be of type enum memcg_stat_item or node_stat_item */
@@ -745,12 +745,12 @@ static inline void __count_memcg_events(struct mem_cgroup *memcg,
 	if (mem_cgroup_disabled())
 		return;
 
-	x = count + __this_cpu_read(memcg->stat_cpu->events[idx]);
+	x = count + __this_cpu_read(memcg->vmstats_percpu->events[idx]);
 	if (unlikely(x > MEMCG_CHARGE_BATCH)) {
-		atomic_long_add(x, &memcg->events[idx]);
+		atomic_long_add(x, &memcg->vmevents[idx]);
 		x = 0;
 	}
-	__this_cpu_write(memcg->stat_cpu->events[idx], x);
+	__this_cpu_write(memcg->vmstats_percpu->events[idx], x);
 }
 
 static inline void count_memcg_events(struct mem_cgroup *memcg,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6464de2648b2..5fc2e1a7d4d2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -690,7 +690,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
 static unsigned long memcg_sum_events(struct mem_cgroup *memcg,
 				      int event)
 {
-	return atomic_long_read(&memcg->events[event]);
+	return atomic_long_read(&memcg->vmevents[event]);
 }
 
 static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
@@ -722,7 +722,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 		nr_pages = -nr_pages; /* for event */
 	}
 
-	__this_cpu_add(memcg->stat_cpu->nr_page_events, nr_pages);
+	__this_cpu_add(memcg->vmstats_percpu->nr_page_events, nr_pages);
 }
 
 unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
@@ -758,8 +758,8 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
 {
 	unsigned long val, next;
 
-	val = __this_cpu_read(memcg->stat_cpu->nr_page_events);
-	next = __this_cpu_read(memcg->stat_cpu->targets[target]);
+	val = __this_cpu_read(memcg->vmstats_percpu->nr_page_events);
+	next = __this_cpu_read(memcg->vmstats_percpu->targets[target]);
 	/* from time_after() in jiffies.h */
 	if ((long)(next - val) < 0) {
 		switch (target) {
@@ -775,7 +775,7 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
 		default:
 			break;
 		}
-		__this_cpu_write(memcg->stat_cpu->targets[target], next);
+		__this_cpu_write(memcg->vmstats_percpu->targets[target], next);
 		return true;
 	}
 	return false;
@@ -2117,9 +2117,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 			int nid;
 			long x;
 
-			x = this_cpu_xchg(memcg->stat_cpu->count[i], 0);
+			x = this_cpu_xchg(memcg->vmstats_percpu->stat[i], 0);
 			if (x)
-				atomic_long_add(x, &memcg->stat[i]);
+				atomic_long_add(x, &memcg->vmstats[i]);
 
 			if (i >= NR_VM_NODE_STAT_ITEMS)
 				continue;
@@ -2137,9 +2137,9 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
 			long x;
 
-			x = this_cpu_xchg(memcg->stat_cpu->events[i], 0);
+			x = this_cpu_xchg(memcg->vmstats_percpu->events[i], 0);
 			if (x)
-				atomic_long_add(x, &memcg->events[i]);
+				atomic_long_add(x, &memcg->vmevents[i]);
 		}
 	}
 
@@ -2979,30 +2979,34 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
 	return retval;
 }
 
-struct accumulated_stats {
-	unsigned long stat[MEMCG_NR_STAT];
-	unsigned long events[NR_VM_EVENT_ITEMS];
+struct accumulated_vmstats {
+	unsigned long vmstats[MEMCG_NR_STAT];
+	unsigned long vmevents[NR_VM_EVENT_ITEMS];
 	unsigned long lru_pages[NR_LRU_LISTS];
-	const unsigned int *stats_array;
-	const unsigned int *events_array;
-	int stats_size;
-	int events_size;
+
+	/* overrides for v1 */
+	const unsigned int *vmstats_array;
+	const unsigned int *vmevents_array;
+
+	int vmstats_size;
+	int vmevents_size;
 };
 
-static void accumulate_memcg_tree(struct mem_cgroup *memcg,
-				  struct accumulated_stats *acc)
+static void accumulate_vmstats(struct mem_cgroup *memcg,
+			       struct accumulated_vmstats *acc)
 {
 	struct mem_cgroup *mi;
 	int i;
 
 	for_each_mem_cgroup_tree(mi, memcg) {
-		for (i = 0; i < acc->stats_size; i++)
-			acc->stat[i] += memcg_page_state(mi,
-				acc->stats_array ? acc->stats_array[i] : i);
+		for (i = 0; i < acc->vmstats_size; i++)
+			acc->vmstats[i] += memcg_page_state(mi,
+				acc->vmstats_array ? acc->vmstats_array[i] : i);
 
-		for (i = 0; i < acc->events_size; i++)
-			acc->events[i] += memcg_sum_events(mi,
-				acc->events_array ? acc->events_array[i] : i);
+		for (i = 0; i < acc->vmevents_size; i++)
+			acc->vmevents[i] += memcg_sum_events(mi,
+				acc->vmevents_array
+				? acc->vmevents_array[i] : i);
 
 		for (i = 0; i < NR_LRU_LISTS; i++)
 			acc->lru_pages[i] +=
@@ -3417,7 +3421,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 	unsigned long memory, memsw;
 	struct mem_cgroup *mi;
 	unsigned int i;
-	struct accumulated_stats acc;
+	struct accumulated_vmstats acc;
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
@@ -3451,22 +3455,22 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 			   (u64)memsw * PAGE_SIZE);
 
 	memset(&acc, 0, sizeof(acc));
-	acc.stats_size = ARRAY_SIZE(memcg1_stats);
-	acc.stats_array = memcg1_stats;
-	acc.events_size = ARRAY_SIZE(memcg1_events);
-	acc.events_array = memcg1_events;
-	accumulate_memcg_tree(memcg, &acc);
+	acc.vmstats_size = ARRAY_SIZE(memcg1_stats);
+	acc.vmstats_array = memcg1_stats;
+	acc.vmevents_size = ARRAY_SIZE(memcg1_events);
+	acc.vmevents_array = memcg1_events;
+	accumulate_vmstats(memcg, &acc);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
 			continue;
 		seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
-			   (u64)acc.stat[i] * PAGE_SIZE);
+			   (u64)acc.vmstats[i] * PAGE_SIZE);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
 		seq_printf(m, "total_%s %llu\n", memcg1_event_names[i],
-			   (u64)acc.events[i]);
+			   (u64)acc.vmevents[i]);
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i],
@@ -4431,7 +4435,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
-	free_percpu(memcg->stat_cpu);
+	free_percpu(memcg->vmstats_percpu);
 	kfree(memcg);
 }
 
@@ -4460,8 +4464,8 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	if (memcg->id.id < 0)
 		goto fail;
 
-	memcg->stat_cpu = alloc_percpu(struct mem_cgroup_stat_cpu);
-	if (!memcg->stat_cpu)
+	memcg->vmstats_percpu = alloc_percpu(struct memcg_vmstats_percpu);
+	if (!memcg->vmstats_percpu)
 		goto fail;
 
 	for_each_node(node)
@@ -5547,7 +5551,7 @@ static int memory_events_show(struct seq_file *m, void *v)
 static int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-	struct accumulated_stats acc;
+	struct accumulated_vmstats acc;
 	int i;
 
 	/*
@@ -5562,30 +5566,30 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	 */
 
 	memset(&acc, 0, sizeof(acc));
-	acc.stats_size = MEMCG_NR_STAT;
-	acc.events_size = NR_VM_EVENT_ITEMS;
-	accumulate_memcg_tree(memcg, &acc);
+	acc.vmstats_size = MEMCG_NR_STAT;
+	acc.vmevents_size = NR_VM_EVENT_ITEMS;
+	accumulate_vmstats(memcg, &acc);
 
 	seq_printf(m, "anon %llu\n",
-		   (u64)acc.stat[MEMCG_RSS] * PAGE_SIZE);
+		   (u64)acc.vmstats[MEMCG_RSS] * PAGE_SIZE);
 	seq_printf(m, "file %llu\n",
-		   (u64)acc.stat[MEMCG_CACHE] * PAGE_SIZE);
+		   (u64)acc.vmstats[MEMCG_CACHE] * PAGE_SIZE);
 	seq_printf(m, "kernel_stack %llu\n",
-		   (u64)acc.stat[MEMCG_KERNEL_STACK_KB] * 1024);
+		   (u64)acc.vmstats[MEMCG_KERNEL_STACK_KB] * 1024);
 	seq_printf(m, "slab %llu\n",
-		   (u64)(acc.stat[NR_SLAB_RECLAIMABLE] +
-			 acc.stat[NR_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
+		   (u64)(acc.vmstats[NR_SLAB_RECLAIMABLE] +
+			 acc.vmstats[NR_SLAB_UNRECLAIMABLE]) * PAGE_SIZE);
 	seq_printf(m, "sock %llu\n",
-		   (u64)acc.stat[MEMCG_SOCK] * PAGE_SIZE);
+		   (u64)acc.vmstats[MEMCG_SOCK] * PAGE_SIZE);
 
 	seq_printf(m, "shmem %llu\n",
-		   (u64)acc.stat[NR_SHMEM] * PAGE_SIZE);
+		   (u64)acc.vmstats[NR_SHMEM] * PAGE_SIZE);
 	seq_printf(m, "file_mapped %llu\n",
-		   (u64)acc.stat[NR_FILE_MAPPED] * PAGE_SIZE);
+		   (u64)acc.vmstats[NR_FILE_MAPPED] * PAGE_SIZE);
 	seq_printf(m, "file_dirty %llu\n",
-		   (u64)acc.stat[NR_FILE_DIRTY] * PAGE_SIZE);
+		   (u64)acc.vmstats[NR_FILE_DIRTY] * PAGE_SIZE);
 	seq_printf(m, "file_writeback %llu\n",
-		   (u64)acc.stat[NR_WRITEBACK] * PAGE_SIZE);
+		   (u64)acc.vmstats[NR_WRITEBACK] * PAGE_SIZE);
 
 	/*
 	 * TODO: We should eventually replace our own MEMCG_RSS_HUGE counter
@@ -5594,43 +5598,43 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	 * where the page->mem_cgroup is set up and stable.
 	 */
 	seq_printf(m, "anon_thp %llu\n",
-		   (u64)acc.stat[MEMCG_RSS_HUGE] * PAGE_SIZE);
+		   (u64)acc.vmstats[MEMCG_RSS_HUGE] * PAGE_SIZE);
 
 	for (i = 0; i < NR_LRU_LISTS; i++)
 		seq_printf(m, "%s %llu\n", mem_cgroup_lru_names[i],
 			   (u64)acc.lru_pages[i] * PAGE_SIZE);
 
 	seq_printf(m, "slab_reclaimable %llu\n",
-		   (u64)acc.stat[NR_SLAB_RECLAIMABLE] * PAGE_SIZE);
+		   (u64)acc.vmstats[NR_SLAB_RECLAIMABLE] * PAGE_SIZE);
 	seq_printf(m, "slab_unreclaimable %llu\n",
-		   (u64)acc.stat[NR_SLAB_UNRECLAIMABLE] * PAGE_SIZE);
+		   (u64)acc.vmstats[NR_SLAB_UNRECLAIMABLE] * PAGE_SIZE);
 
 	/* Accumulated memory events */
 
-	seq_printf(m, "pgfault %lu\n", acc.events[PGFAULT]);
-	seq_printf(m, "pgmajfault %lu\n", acc.events[PGMAJFAULT]);
+	seq_printf(m, "pgfault %lu\n", acc.vmevents[PGFAULT]);
+	seq_printf(m, "pgmajfault %lu\n", acc.vmevents[PGMAJFAULT]);
 
 	seq_printf(m, "workingset_refault %lu\n",
-		   acc.stat[WORKINGSET_REFAULT]);
+		   acc.vmstats[WORKINGSET_REFAULT]);
 	seq_printf(m, "workingset_activate %lu\n",
-		   acc.stat[WORKINGSET_ACTIVATE]);
+		   acc.vmstats[WORKINGSET_ACTIVATE]);
 	seq_printf(m, "workingset_nodereclaim %lu\n",
-		   acc.stat[WORKINGSET_NODERECLAIM]);
-
-	seq_printf(m, "pgrefill %lu\n", acc.events[PGREFILL]);
-	seq_printf(m, "pgscan %lu\n", acc.events[PGSCAN_KSWAPD] +
-		   acc.events[PGSCAN_DIRECT]);
-	seq_printf(m, "pgsteal %lu\n", acc.events[PGSTEAL_KSWAPD] +
-		   acc.events[PGSTEAL_DIRECT]);
-	seq_printf(m, "pgactivate %lu\n", acc.events[PGACTIVATE]);
-	seq_printf(m, "pgdeactivate %lu\n", acc.events[PGDEACTIVATE]);
-	seq_printf(m, "pglazyfree %lu\n", acc.events[PGLAZYFREE]);
-	seq_printf(m, "pglazyfreed %lu\n", acc.events[PGLAZYFREED]);
+		   acc.vmstats[WORKINGSET_NODERECLAIM]);
+
+	seq_printf(m, "pgrefill %lu\n", acc.vmevents[PGREFILL]);
+	seq_printf(m, "pgscan %lu\n", acc.vmevents[PGSCAN_KSWAPD] +
+		   acc.vmevents[PGSCAN_DIRECT]);
+	seq_printf(m, "pgsteal %lu\n", acc.vmevents[PGSTEAL_KSWAPD] +
+		   acc.vmevents[PGSTEAL_DIRECT]);
+	seq_printf(m, "pgactivate %lu\n", acc.vmevents[PGACTIVATE]);
+	seq_printf(m, "pgdeactivate %lu\n", acc.vmevents[PGDEACTIVATE]);
+	seq_printf(m, "pglazyfree %lu\n", acc.vmevents[PGLAZYFREE]);
+	seq_printf(m, "pglazyfreed %lu\n", acc.vmevents[PGLAZYFREED]);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	seq_printf(m, "thp_fault_alloc %lu\n", acc.events[THP_FAULT_ALLOC]);
+	seq_printf(m, "thp_fault_alloc %lu\n", acc.vmevents[THP_FAULT_ALLOC]);
 	seq_printf(m, "thp_collapse_alloc %lu\n",
-		   acc.events[THP_COLLAPSE_ALLOC]);
+		   acc.vmevents[THP_COLLAPSE_ALLOC]);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	return 0;
@@ -6066,7 +6070,7 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 	__mod_memcg_state(ug->memcg, MEMCG_RSS_HUGE, -ug->nr_huge);
 	__mod_memcg_state(ug->memcg, NR_SHMEM, -ug->nr_shmem);
 	__count_memcg_events(ug->memcg, PGPGOUT, ug->pgpgout);
-	__this_cpu_add(ug->memcg->stat_cpu->nr_page_events, nr_pages);
+	__this_cpu_add(ug->memcg->vmstats_percpu->nr_page_events, nr_pages);
 	memcg_check_events(ug->memcg, ug->dummy_page);
 	local_irq_restore(flags);
 
-- 
2.20.1

