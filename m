From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] mm: memcg: make stats flushing threshold per-memcg
Date: Thu, 21 Sep 2023 08:10:55 +0000
Message-ID: <20230921081057.3440885-4-yosryahmed@google.com>
References: <20230921081057.3440885-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695317494; x=1695922294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DUC4W/ANoWKKbgrvdNHuDLy6cXEfVkGWJByczmAAxsQ=;
        b=cragJN3OlSenqpjl60WZ7bkIbCebL4xuLGtJZdDNJepzrSAHpBlpvbRkDCEV5af5Wu
         g8SFhGvJljVtAsybeeE8MRoF7EKDrSB95VRSVUFRY6d0xgMc9uBSDiXd0XLV48ze2EiC
         NNFKs+vk/dHjUvqSo+2vVsp7M5kEA9heNFmM6FNIWvfNQsqIbDOwnSZ0SGqlpzhI33Pi
         dlQYIaomZiqbrEBQGnyCAzO9GGnrufgksDYmACP4tgY94iHE8rdtcjst4xpR/Dg0Pz/d
         wM8OUU+5/UVbjHXUzUmvf1DsnIeP7aW0xzg9ZXsC9pC8nOCGjuIbYyaqEx96YFSIInfk
         Omiw==
In-Reply-To: <20230921081057.3440885-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org, Wei Xu <weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

A global counter for the magnitude of memcg stats update is maintained
on the memcg side to avoid invoking rstat flushes when the pending
updates are not significant. This avoids unnecessary flushes, which are
not very cheap even if there isn't a lot of stats to flush. It also
avoids unnecessary lock contention on the underlying global rstat lock.

Make this threshold per-memcg. The scheme is followed where percpu (now
also per-memcg) counters are incremented in the update path, and only
propagated to per-memcg atomics when they exceed a certain threshold.

This provides two benefits:
(a) On large machines with a lot of memcgs, the global threshold can be
reached relatively fast, so guarding the underlying lock becomes less
effective. Making the threshold per-memcg avoids this.

(b) Having a global threshold makes it hard to do subtree flushes, as we
cannot reset the global counter except for a full flush. Per-memcg
counters removes this as a blocker from doing subtree flushes, which
helps avoid unnecessary work when the stats of a small subtree are
needed.

Nothing is free, of course. This comes at a cost:
(a) A new per-cpu counter per memcg, consuming NR_CPUS * NR_MEMCGS * 4
bytes.

(b) More work on the update side, although in the common case it will
only be percpu counter updates. The amount of work scales with the
number of ancestors (i.e. tree depth). This is not a new concept, adding
a cgroup to the rstat tree involves a parent loop, so is charging.
Testing in a later patch shows this doesn't introduce significant
regressions.

(c) The error margin in the stats for the system as a whole increases
from NR_CPUS * MEMCG_CHARGE_BATCH to NR_CPUS * MEMCG_CHARGE_BATCH *
NR_MEMCGS. This is probably fine because we have a similar per-memcg
error in charges coming from percpu stocks, and we have a periodic
flusher that makes sure we always flush all the stats every 2s anyway.

This patch was tested to make sure no significant regressions are
introduced on the update path as follows. In a cgroup that is 4 levels
deep (/sys/fs/cgroup/a/b/c/d), the following benchmarks were ran:

(a) neper [1] with 1000 flows and 100 threads (single machine). The
values in the table are the average of server and client throughputs in
mbps after 30 iterations, each running for 30s:

				tcp_rr		tcp_stream
Base				9504218.56	357366.84
Patched				9656205.68	356978.39
Delta				+1.6%		-0.1%
Standard Deviation		0.95%		1.03%

An increase in the performance of tcp_rr doesn't really make sense, but
it's probably in the noise. The same tests were ran with 1 flow and 1
thread but the throughput was too noisy to make any conclusions (the
averages did not show regressions nonetheless).

Looking at perf for one iteration of the above test, __mod_memcg_state()
(which is where memcg_rstat_updated() is called) does not show up at all
without this patch, but it shows up with this patch as 1.06% for tcp_rr
and 0.36% for tcp_stream.

(b) Running "stress-ng --vm 0 -t 1m --times --perf". I don't understand
stress-ng very well, so I am not sure that's the best way to test this,
but it spawns 384 workers and spits a lot of metrics which looks nice :)
I picked a few ones that seem to be relevant to the stats update path. I
also included cache misses as this patch introduce more atomics that may
bounce between cpu caches:

Metric			Base		Patched		Delta
Cache Misses		3.394 B/sec 	3.433 B/sec	+1.14%
Cache L1D Read		0.148 T/sec	0.154 T/sec	+4.05%
Cache L1D Read Miss	20.430 B/sec	21.820 B/sec	+6.8%
Page Faults Total	4.304 M/sec	4.535 M/sec	+5.4%
Page Faults Minor	4.304 M/sec	4.535 M/sec	+5.4%
Page Faults Major	18.794 /sec	0.000 /sec
Kmalloc			0.153 M/sec	0.152 M/sec	-0.65%
Kfree			0.152 M/sec	0.153 M/sec	+0.65%
MM Page Alloc		4.640 M/sec	4.898 M/sec	+5.56%
MM Page Free		4.639 M/sec	4.897 M/sec	+5.56%
Lock Contention Begin	0.362 M/sec	0.479 M/sec	+32.32%
Lock Contention End	0.362 M/sec	0.479 M/sec	+32.32%
page-cache add		238.057 /sec	0.000 /sec
page-cache del		6.265 /sec	6.267 /sec	-0.03%

This is only using a single run in each case. I am not sure what to
make out of most of these numbers, but they mostly seem in the noise
(some better, some worse). The lock contention numbers are interesting.
I am not sure if higher is better or worse here. No new locks or lock
sections are introduced by this patch either way.

Looking at perf, __mod_memcg_state() shows up as 0.00% with and without
this patch. This is suspicious, but I verified while stress-ng is
running that all the threads are in the right cgroup.

[1]https://github.com/google/neper

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ef7ad66a9e4c..c273c65bb642 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -627,6 +627,9 @@ struct memcg_vmstats_percpu {
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
+
+	/* Stats updates since the last flush */
+	unsigned int		stats_updates;
 };
 
 struct memcg_vmstats {
@@ -641,6 +644,9 @@ struct memcg_vmstats {
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_NR_STAT];
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
+
+	/* Stats updates since the last flush */
+	atomic64_t		stats_updates;
 };
 
 /*
@@ -660,9 +666,7 @@ struct memcg_vmstats {
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
-static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
@@ -689,26 +693,37 @@ static void memcg_stats_unlock(void)
 	preempt_enable_nested();
 }
 
+
+static bool memcg_should_flush_stats(struct mem_cgroup *memcg)
+{
+	return atomic64_read(&memcg->vmstats->stats_updates) >
+		MEMCG_CHARGE_BATCH * num_online_cpus();
+}
+
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	int cpu = smp_processor_id();
 	unsigned int x;
 
 	if (!val)
 		return;
 
-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		x = __this_cpu_add_return(memcg->vmstats_percpu->stats_updates,
+					  abs(val));
+
+		if (x < MEMCG_CHARGE_BATCH)
+			continue;
 
-	x = __this_cpu_add_return(stats_updates, abs(val));
-	if (x > MEMCG_CHARGE_BATCH) {
 		/*
-		 * If stats_flush_threshold exceeds the threshold
-		 * (>num_online_cpus()), cgroup stats update will be triggered
-		 * in __mem_cgroup_flush_stats(). Increasing this var further
-		 * is redundant and simply adds overhead in atomic update.
+		 * If @memcg is already flush-able, increasing stats_updates is
+		 * redundant. Avoid the overhead of the atomic update.
 		 */
-		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
-			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
-		__this_cpu_write(stats_updates, 0);
+		if (!memcg_should_flush_stats(memcg))
+			atomic64_add(x, &memcg->vmstats->stats_updates);
+		__this_cpu_write(memcg->vmstats_percpu->stats_updates, 0);
 	}
 }
 
@@ -727,13 +742,12 @@ static void do_flush_stats(void)
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
 
-	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_flush_ongoing, 0);
 }
 
 void mem_cgroup_flush_stats(void)
 {
-	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+	if (memcg_should_flush_stats(root_mem_cgroup))
 		do_flush_stats();
 }
 
@@ -747,8 +761,8 @@ void mem_cgroup_flush_stats_ratelimited(void)
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	/*
-	 * Always flush here so that flushing in latency-sensitive paths is
-	 * as cheap as possible.
+	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
+	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	do_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
@@ -5622,6 +5636,9 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 			}
 		}
 	}
+	/* We are in a per-cpu loop here, only do the atomic write once */
+	if (atomic64_read(&memcg->vmstats->stats_updates))
+		atomic64_set(&memcg->vmstats->stats_updates, 0);
 }
 
 #ifdef CONFIG_MMU
-- 
2.42.0.459.ge4e396fd5e-goog

