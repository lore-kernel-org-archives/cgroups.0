From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH 4/7] memcg: sleep during flushing stats in safe contexts
Date: Thu, 23 Mar 2023 04:00:34 +0000
Message-ID: <20230323040037.2389095-5-yosryahmed@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xrG0SezuE3D1BzHk1bOIN+tOwhU+wFsyLck18RLDkiM=;
        b=cgw7YjSYw+yZCrYg4MWNWyL1ocWVlMfhI6U/IH5SNNI/KXZEirBQTnVHw1Jk19ca7x
         YZMRDXY2GIXRShVJyUBfGcwrm5OQ54Bn3XOEBif3BbHD9ArewU0b2vLyFm38bp8+NRx8
         4lwk3DHRAIpY5JhlVhZi+qJFnS5DTPOFtneU65+9wwMhEPN3ScjeohcSLADEGreopxgz
         hPSmYPd9gVS979yLkwNh9j+9QGCIU5M1yATespEadqsIAym+pG18x2O6VFUlYJCK8ejc
         v8yJF8c/6m0MiyUkNdlDzwM4KjC9ikuULQ0wGXuneSrTmETcMqRGnUz3Mhll67JgWKef
         njxw==
In-Reply-To: <20230323040037.2389095-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Currently, all contexts that flush memcg stats do so with sleeping not
allowed. Some of these contexts are perfectly safe to sleep in, such as
reading cgroup files from userspace or the background periodic flusher.

Enable choosing whether sleeping is allowed or not when flushing memcg
stats, and allow sleeping in safe contexts to avoid unnecessarily
performing a lot of work without sleeping.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 include/linux/memcontrol.h |  8 ++++----
 mm/memcontrol.c            | 35 ++++++++++++++++++++++-------------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  3 ++-
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b6eda2ab205d..0c7b286f2caf 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1036,8 +1036,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return x;
 }
 
-void mem_cgroup_flush_stats(void);
-void mem_cgroup_flush_stats_delayed(void);
+void mem_cgroup_flush_stats(bool may_sleep);
+void mem_cgroup_flush_stats_delayed(bool may_sleep);
 
 void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			      int val);
@@ -1531,11 +1531,11 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
-static inline void mem_cgroup_flush_stats(void)
+static inline void mem_cgroup_flush_stats(bool may_sleep)
 {
 }
 
-static inline void mem_cgroup_flush_stats_delayed(void)
+static inline void mem_cgroup_flush_stats_delayed(bool may_sleep)
 {
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 72cd44f88d97..39a9c7a978ae 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -634,7 +634,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 	}
 }
 
-static void __mem_cgroup_flush_stats(void)
+static void __mem_cgroup_flush_stats(bool may_sleep)
 {
 	/*
 	 * This lock can be acquired from interrupt context, but we only acquire
@@ -644,26 +644,26 @@ static void __mem_cgroup_flush_stats(void)
 		return;
 
 	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
-	cgroup_rstat_flush(root_mem_cgroup->css.cgroup, false);
+	cgroup_rstat_flush(root_mem_cgroup->css.cgroup, may_sleep);
 	atomic_set(&stats_flush_threshold, 0);
 	spin_unlock(&stats_flush_lock);
 }
 
-void mem_cgroup_flush_stats(void)
+void mem_cgroup_flush_stats(bool may_sleep)
 {
 	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
-		__mem_cgroup_flush_stats();
+		__mem_cgroup_flush_stats(may_sleep);
 }
 
-void mem_cgroup_flush_stats_delayed(void)
+void mem_cgroup_flush_stats_delayed(bool may_sleep)
 {
 	if (time_after64(jiffies_64, flush_next_time))
-		mem_cgroup_flush_stats();
+		mem_cgroup_flush_stats(may_sleep);
 }
 
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
-	__mem_cgroup_flush_stats();
+	__mem_cgroup_flush_stats(true);
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
@@ -1570,7 +1570,7 @@ static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(true);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3671,7 +3671,11 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		mem_cgroup_flush_stats();
+		/*
+		 * mem_cgroup_threshold() calls here from irqsafe context.
+		 * Don't sleep.
+		 */
+		mem_cgroup_flush_stats(false);
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -4014,7 +4018,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(true);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -4090,7 +4094,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(true);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4594,7 +4598,12 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	mem_cgroup_flush_stats();
+	/*
+	 * wb_writeback() takes a spinlock and calls
+	 * wb_over_bg_thresh()->mem_cgroup_wb_stats().
+	 * Do not sleep.
+	 */
+	mem_cgroup_flush_stats(false);
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -6596,7 +6605,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(true);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c1c5e8b24b8..59d1830d08ac 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
 	 * Flush the memory cgroup stats, so that we read accurate per-memcg
 	 * lruvec stats for heuristics.
 	 */
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(false);
 
 	/*
 	 * Determine the scan balance between anon and file LRUs.
diff --git a/mm/workingset.c b/mm/workingset.c
index 00c6f4d9d9be..042eabbb43f6 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -462,7 +462,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
-	mem_cgroup_flush_stats_delayed();
+	/* Do not sleep with RCU lock held */
+	mem_cgroup_flush_stats_delayed(false);
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.40.0.rc1.284.g88254d51c5-goog

