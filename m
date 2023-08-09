From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Wed,  9 Aug 2023 04:58:10 +0000
Message-ID: <20230809045810.1659356-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691557093; x=1692161893;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OYG5lfEUc9Di0uttH2eztXJ8fv3suEABmVSMtUffIT0=;
        b=quGljRI4w1RP9FtvOGqFbpKn287sq8n8yZxrVoBE8wYYqcAnuV/TkVeOTn+wchwE3e
         SA1f2P2LImZukMa8s5iU0UG7r/m+VsFAhDaPuxOBo5H44wylZPOCSmJJdmS6ZEwAkh7/
         jtHAbR0qSA8Wob2+ggf6h8hpDEhUh3u4eGFPmDb/IOVbX9xuUcq7EC6ZVjShiepu1hoW
         07R9B8SdYm2fi/uW3sOuASuXA70UXL8GWT79a/55rkSb0DuEdo7MP7i9j37geWuXJNJV
         1x3tT+mEB5XmgsUnZmx4RN2R1qZDAJ3tUB2y22gEJq6H3iE26Oi58NHGVuPHKganuZDL
         Zs5A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Over time, the memcg code added multiple optimizations to the stats
flushing path that introduce a tradeoff between accuracy and
performance. In some contexts (e.g. dirty throttling, refaults, etc), a
full rstat flush of the stats in the tree can be too expensive. Such
optimizations include [1]:
(a) Introducing a periodic background flusher to keep the size of the
update tree from growing unbounded.
(b) Allowing only one thread to flush at a time, and other concurrent
flushers just skip the flush. This avoids a thundering herd problem
when multiple reclaim/refault threads attempt to flush the stats at
once.
(c) Only executing a flush if the magnitude of the stats updates exceeds
a certain threshold.

These optimizations were necessary to make flushing feasible in
performance-critical paths, and they come at the cost of some accuracy
that we choose to live without. On the other hand, for flushes invoked
when userspace is reading the stats, the tradeoff is less appealing
This code path is not performance-critical, and the inaccuracies can
affect userspace behavior. For example, skipping flushing when there is
another ongoing flush is essentially a coin flip. We don't know if the
ongoing flush is done with the subtree of interest or not.

If userspace asks for stats, let's give it accurate stats. Without this
patch, we see regressions in userspace workloads due to stats inaccuracy
in some cases.

Rework the do_flush_stats() helper to accept a "full" boolean argument.
For a "full" flush, if there is an ongoing flush, do not skip. Instead
wait for the flush to complete. Introduce a new
mem_cgroup_flush_stats_full() interface that use this full flush, and
also does not check if the magnitude of the updates exceeds the
threshold. Use mem_cgroup_flush_stats_full() in code paths where stats
are flushed due to a userspace read. This essentially undos optimzations
(b) and (c) above for flushes triggered by userspace reads.

[1] https://lore.kernel.org/lkml/20210716212137.1391164-2-shakeelb@google.com/

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---

I want to argue that this is what we should be doing for all flushing
contexts, not just userspace reads (i.e all flushes should be "full").
Skipping if a flush is ongoing is too brittle. There is a significant
chance that the stats of the cgroup we care about is not fully flushed.
Waiting for an ongoing flush to finish ensures correctness while still
avoiding the thundering herd problem on the rstat flush lock.

Having said that, there is a higher chance of regression if we add the
wait in more critical paths (e.g. reclaim, refaults), so I opt-ed to do
this for userspace reads for now. We have complaints about inaccuracy in
userspace reads, but no complaints about inaccuracy in other paths so
far (although it would be really difficult to tie a reclaim/refault
problem to a partial stats flush anyway).

---
 mm/memcontrol.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e041ba827e59..38e227f7127d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -630,7 +630,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 		/*
 		 * If stats_flush_threshold exceeds the threshold
 		 * (>num_online_cpus()), cgroup stats update will be triggered
-		 * in __mem_cgroup_flush_stats(). Increasing this var further
+		 * in mem_cgroup_flush_stats(). Increasing this var further
 		 * is redundant and simply adds overhead in atomic update.
 		 */
 		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
@@ -639,17 +639,24 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	}
 }
 
-static void do_flush_stats(void)
+static void do_flush_stats(bool full)
 {
+	if (!atomic_read(&stats_flush_ongoing) &&
+	    !atomic_xchg(&stats_flush_ongoing, 1))
+		goto flush;
+
 	/*
-	 * We always flush the entire tree, so concurrent flushers can just
-	 * skip. This avoids a thundering herd problem on the rstat global lock
-	 * from memcg flushers (e.g. reclaim, refault, etc).
+	 * We always flush the entire tree, so concurrent flushers can choose to
+	 * skip if accuracy is not critical. Otherwise, wait for the ongoing
+	 * flush to complete. This avoids a thundering herd problem on the rstat
+	 * global lock from memcg flushers (e.g. reclaim, refault, etc).
 	 */
-	if (atomic_read(&stats_flush_ongoing) ||
-	    atomic_xchg(&stats_flush_ongoing, 1))
-		return;
-
+	while (full && atomic_read(&stats_flush_ongoing) == 1) {
+		if (!cond_resched())
+			cpu_relax();
+	}
+	return;
+flush:
 	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
 
 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
@@ -661,7 +668,12 @@ static void do_flush_stats(void)
 void mem_cgroup_flush_stats(void)
 {
 	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
-		do_flush_stats();
+		do_flush_stats(false);
+}
+
+static void mem_cgroup_flush_stats_full(void)
+{
+	do_flush_stats(true);
 }
 
 void mem_cgroup_flush_stats_ratelimited(void)
@@ -676,7 +688,7 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	 * Always flush here so that flushing in latency-sensitive paths is
 	 * as cheap as possible.
 	 */
-	do_flush_stats();
+	do_flush_stats(false);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
@@ -1576,7 +1588,7 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_full();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4018,7 +4030,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_full();
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4093,7 +4105,7 @@ static void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_full();
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -6610,7 +6622,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats_full();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
-- 
2.41.0.640.ga95def55d0-goog

