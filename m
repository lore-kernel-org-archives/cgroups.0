From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] memcg: reduce size of memcg vmstats structures
Date: Wed,  7 Sep 2022 04:35:37 +0000
Message-ID: <20220907043537.3457014-4-shakeelb@google.com>
References: <20220907043537.3457014-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=khSX7Y4iv18onStJMmBrPhwF58VNn8i03Anirden96Q=;
        b=gemiZCbExV47bKx8wOek1aQ0u8hzbt+EnZzyGvpEX6V3hdl7+FzjhOMQFdg/BAePWs
         g1Phtex5qyjXcE0CH8qo/myIMYCKBorj4O/lYfXNAuZQE1nIXh6Y/UorToCbyrfqTc08
         w41m5Q1yfn7rEabS42x1kF04pr4Fz4DhfpdBQ7PAZvq2tOJI4kuvrPxvdDoYGIeFXtU7
         73wZp+rS4GUGDo8QZ9/BnYm7kUNxwjCsKt+VQJT//oAjo2bR/bpBZ7YFQnfETArjdfst
         yH5HuLvanOXbdhRwhVJR8If5nQVhIbTM14rXsNmexTs4BoP70k0Ts+2cN/b8E1sehylv
         kQmg==
In-Reply-To: <20220907043537.3457014-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The struct memcg_vmstats and struct memcg_vmstats_percpu contains two
arrays each for events of size NR_VM_EVENT_ITEMS which can be as large
as 110. However the memcg v1 only uses 4 of those while memcg v2 uses
15. The union of both is 17. On a 64 bit system, we are wasting
approximately ((110 - 17) * 8 * 2) * (nr_cpus + 1) bytes which is
significant on large machines.

This patch reduces the size of the given structures by adding one
indirection and only stores array of events which are actually used by
the memcg code. With this patch, the size of memcg_vmstats has reduced
from 2544 bytes to 1056 bytes while the size of memcg_vmstats_percpu has
reduced from 2568 bytes to 1080 bytes.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d0ccc16ed416..a60012be6140 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -671,6 +671,8 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
+	PGPGIN,
+	PGPGOUT,
 	PGSCAN_KSWAPD,
 	PGSCAN_DIRECT,
 	PGSTEAL_KSWAPD,
@@ -692,14 +694,30 @@ static const unsigned int memcg_vm_event_stat[] = {
 #endif
 };
 
+#define NR_MEMCG_EVENTS ARRAY_SIZE(memcg_vm_event_stat)
+static int mem_cgroup_events_index[NR_VM_EVENT_ITEMS] __read_mostly;
+
+static void init_memcg_events(void)
+{
+	int i;
+
+	for (i = 0; i < NR_MEMCG_EVENTS; ++i)
+		mem_cgroup_events_index[memcg_vm_event_stat[i]] = i + 1;
+}
+
+static inline int memcg_events_index(enum vm_event_item idx)
+{
+	return mem_cgroup_events_index[idx] - 1;
+}
+
 struct memcg_vmstats_percpu {
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
+	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Delta calculation for lockless upward propagation */
 	long			state_prev[MEMCG_NR_STAT];
-	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
+	unsigned long		events_prev[NR_MEMCG_EVENTS];
 
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
@@ -709,11 +727,11 @@ struct memcg_vmstats_percpu {
 struct memcg_vmstats {
 	/* Aggregated (CPU and subtree) page state & events */
 	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
+	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_NR_STAT];
-	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
+	unsigned long		events_pending[NR_MEMCG_EVENTS];
 };
 
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
@@ -873,24 +891,34 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			  unsigned long count)
 {
-	if (mem_cgroup_disabled())
+	int index = memcg_events_index(idx);
+
+	if (mem_cgroup_disabled() || index < 0)
 		return;
 
 	memcg_stats_lock();
-	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
+	__this_cpu_add(memcg->vmstats_percpu->events[index], count);
 	memcg_rstat_updated(memcg, count);
 	memcg_stats_unlock();
 }
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 {
-	return READ_ONCE(memcg->vmstats->events[event]);
+	int index = memcg_events_index(event);
+
+	if (index < 0)
+		return 0;
+	return READ_ONCE(memcg->vmstats->events[index]);
 }
 
 static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 {
 	long x = 0;
 	int cpu;
+	int index = memcg_events_index(event);
+
+	if (index < 0)
+		return 0;
 
 	for_each_possible_cpu(cpu)
 		x += per_cpu(memcg->vmstats_percpu->events[event], cpu);
@@ -1564,10 +1592,15 @@ static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 		       memcg_events(memcg, PGSTEAL_KSWAPD) +
 		       memcg_events(memcg, PGSTEAL_DIRECT));
 
-	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++)
+	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
+		if (memcg_vm_event_stat[i] == PGPGIN ||
+		    memcg_vm_event_stat[i] == PGPGOUT)
+			continue;
+
 		seq_buf_printf(&s, "%s %lu\n",
 			       vm_event_name(memcg_vm_event_stat[i]),
 			       memcg_events(memcg, memcg_vm_event_stat[i]));
+	}
 
 	/* The above should easily fit into one page */
 	WARN_ON_ONCE(seq_buf_has_overflowed(&s));
@@ -5309,6 +5342,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		page_counter_init(&memcg->kmem, &parent->kmem);
 		page_counter_init(&memcg->tcpmem, &parent->tcpmem);
 	} else {
+		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL);
 		page_counter_init(&memcg->swap, NULL);
 		page_counter_init(&memcg->kmem, NULL);
@@ -5477,7 +5511,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 			parent->vmstats->state_pending[i] += delta;
 	}
 
-	for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
+	for (i = 0; i < NR_MEMCG_EVENTS; i++) {
 		delta = memcg->vmstats->events_pending[i];
 		if (delta)
 			memcg->vmstats->events_pending[i] = 0;
-- 
2.37.2.789.g6183377224-goog

