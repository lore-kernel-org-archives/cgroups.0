From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] memcg: extract memcg_vmstats from struct mem_cgroup
Date: Wed,  7 Sep 2022 04:35:35 +0000
Message-ID: <20220907043537.3457014-2-shakeelb@google.com>
References: <20220907043537.3457014-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=+ENncUdfOxJ4q/8LZk6DI50+XMWx6BeUwv0z4tw0gRY=;
        b=ZequgtabdjcCJmJYwHcuirxjXWYVxqBEGoqYBTddWUrFGxayaRDdkPPL35s5tGIzQ7
         oohJe3ane8IE/6VPhwguj78pXQyNyZra47KKc+c8xJKEHGorIcMzWmrmRlwLoA2dHS95
         NKjaOI9d+CsoGs/PtD5hTrcJmdjy8ugZzPcm9WEnuiDhAQdfC8LPWQBoQHOijfpRjQwf
         z49WK7LH8anfLpxSIpaWSL7mxkmp44ZTKIN3Eyolkfra/wn0h5geUklvCLjRgu/NHGQX
         q+Fnut9idgOpogDkYMQfi517Q0/kauc+cWYzh2xco62FeXGuOpev9tG1hUyiyQYR/ABl
         2HFw==
In-Reply-To: <20220907043537.3457014-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This is a preparatory patch to reduce the memory overhead of memory
cgroup. The struct memcg_vmstats is the largest object embedded into the
struct mem_cgroup. This patch extracts struct memcg_vmstats from struct
mem_cgroup to ease the following patches in reducing the size of struct
memcg_vmstats.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h | 37 +++----------------------
 mm/memcontrol.c            | 57 ++++++++++++++++++++++++++++++++------
 2 files changed, 52 insertions(+), 42 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ca0df42662ad..dc7d40e575d5 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -80,29 +80,8 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_NTARGETS,
 };
 
-struct memcg_vmstats_percpu {
-	/* Local (CPU and cgroup) page state & events */
-	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
-
-	/* Delta calculation for lockless upward propagation */
-	long			state_prev[MEMCG_NR_STAT];
-	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
-
-	/* Cgroup1: threshold notifications & softlimit tree updates */
-	unsigned long		nr_page_events;
-	unsigned long		targets[MEM_CGROUP_NTARGETS];
-};
-
-struct memcg_vmstats {
-	/* Aggregated (CPU and subtree) page state & events */
-	long			state[MEMCG_NR_STAT];
-	unsigned long		events[NR_VM_EVENT_ITEMS];
-
-	/* Pending child counts during tree propagation */
-	long			state_pending[MEMCG_NR_STAT];
-	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
-};
+struct memcg_vmstats_percpu;
+struct memcg_vmstats;
 
 struct mem_cgroup_reclaim_iter {
 	struct mem_cgroup *position;
@@ -298,7 +277,7 @@ struct mem_cgroup {
 	CACHELINE_PADDING(_pad1_);
 
 	/* memory.stat */
-	struct memcg_vmstats	vmstats;
+	struct memcg_vmstats	*vmstats;
 
 	/* memory.events */
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
@@ -1001,15 +980,7 @@ static inline void mod_memcg_page_state(struct page *page,
 	rcu_read_unlock();
 }
 
-static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
-{
-	long x = READ_ONCE(memcg->vmstats.state[idx]);
-#ifdef CONFIG_SMP
-	if (x < 0)
-		x = 0;
-#endif
-	return x;
-}
+unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
 
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0a1a8a846870..b195d4ca2a72 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -669,6 +669,40 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
+struct memcg_vmstats_percpu {
+	/* Local (CPU and cgroup) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_VM_EVENT_ITEMS];
+
+	/* Delta calculation for lockless upward propagation */
+	long			state_prev[MEMCG_NR_STAT];
+	unsigned long		events_prev[NR_VM_EVENT_ITEMS];
+
+	/* Cgroup1: threshold notifications & softlimit tree updates */
+	unsigned long		nr_page_events;
+	unsigned long		targets[MEM_CGROUP_NTARGETS];
+};
+
+struct memcg_vmstats {
+	/* Aggregated (CPU and subtree) page state & events */
+	long			state[MEMCG_NR_STAT];
+	unsigned long		events[NR_VM_EVENT_ITEMS];
+
+	/* Pending child counts during tree propagation */
+	long			state_pending[MEMCG_NR_STAT];
+	unsigned long		events_pending[NR_VM_EVENT_ITEMS];
+};
+
+unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
+{
+	long x = READ_ONCE(memcg->vmstats->state[idx]);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
+}
+
 /**
  * __mod_memcg_state - update cgroup memory statistics
  * @memcg: the memory cgroup
@@ -827,7 +861,7 @@ void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 
 static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 {
-	return READ_ONCE(memcg->vmstats.events[event]);
+	return READ_ONCE(memcg->vmstats->events[event]);
 }
 
 static unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
@@ -5170,6 +5204,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
+	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
 	kfree(memcg);
 }
@@ -5199,6 +5234,10 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 		goto fail;
 	}
 
+	memcg->vmstats = kzalloc(sizeof(struct memcg_vmstats), GFP_KERNEL);
+	if (!memcg->vmstats)
+		goto fail;
+
 	memcg->vmstats_percpu = alloc_percpu_gfp(struct memcg_vmstats_percpu,
 						 GFP_KERNEL_ACCOUNT);
 	if (!memcg->vmstats_percpu)
@@ -5418,9 +5457,9 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		 * below us. We're in a per-cpu loop here and this is
 		 * a global counter, so the first cycle will get them.
 		 */
-		delta = memcg->vmstats.state_pending[i];
+		delta = memcg->vmstats->state_pending[i];
 		if (delta)
-			memcg->vmstats.state_pending[i] = 0;
+			memcg->vmstats->state_pending[i] = 0;
 
 		/* Add CPU changes on this level since the last flush */
 		v = READ_ONCE(statc->state[i]);
@@ -5433,15 +5472,15 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 			continue;
 
 		/* Aggregate counts on this level and propagate upwards */
-		memcg->vmstats.state[i] += delta;
+		memcg->vmstats->state[i] += delta;
 		if (parent)
-			parent->vmstats.state_pending[i] += delta;
+			parent->vmstats->state_pending[i] += delta;
 	}
 
 	for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
-		delta = memcg->vmstats.events_pending[i];
+		delta = memcg->vmstats->events_pending[i];
 		if (delta)
-			memcg->vmstats.events_pending[i] = 0;
+			memcg->vmstats->events_pending[i] = 0;
 
 		v = READ_ONCE(statc->events[i]);
 		if (v != statc->events_prev[i]) {
@@ -5452,9 +5491,9 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		if (!delta)
 			continue;
 
-		memcg->vmstats.events[i] += delta;
+		memcg->vmstats->events[i] += delta;
 		if (parent)
-			parent->vmstats.events_pending[i] += delta;
+			parent->vmstats->events_pending[i] += delta;
 	}
 
 	for_each_node_state(nid, N_MEMORY) {
-- 
2.37.2.789.g6183377224-goog

