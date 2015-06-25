From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/6] blkcg: make blkcg_[rw]stat per-cpu
Date: Thu, 25 Jun 2015 17:38:54 -0400
Message-ID: <1435268337-1738-4-git-send-email-tj@kernel.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CmITKAtWEM2C8/BqNCtYqx2YB1/clv/Jfq1qO0bmz+M=;
        b=MhI3UKCONQJ7M4V/tLhzdmFoqZL5L6iRma7KlnT2JweNZROsEjoCpTm5qBW2XLfAMv
         GR/h5yoVlM2iNjd4L6bcFSQZkU+Y+bIRJCCPjPX+qR5QncOvm9HpNdncFfprI8cviT9r
         842m1FGKgwjs+GvvT+chn9+CY5o8X8q4/qDG05tMTqB8D0Pl6RBls/pWL9rxqcSLPYIr
         MU32K/LpIOSuZJsVtyC7gTHUTjFkatQZuRteVshA4T+vIvUitsHjmNFDt3uLM18zBHI0
         9TwdQJz6c+At7vPCjQXB9MkIAlT0iLt3/p7EKOc1FNW3UNEiqE0VA0u4cU3YxkolV7+3
         CL5g==
In-Reply-To: <1435268337-1738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

blkcg_[rw]stat are used as stat counters for blkcg policies.  It isn't
per-cpu by itself and blk-throttle makes it per-cpu by wrapping around
it.  This patch makes blkcg_[rw]stat per-cpu and drop the ad-hoc
per-cpu wrapping in blk-throttle.

* blkg_[rw]stat->cnt is replaced with cpu_cnt which is struct
  percpu_counter.  This makes syncp unnecessary as remote accesses are
  handled by percpu_counter itself.

* blkg_[rw]stat_init() can now fail due to percpu allocation failure
  and thus are updated to return int.

* percpu_counters need explicit freeing.  blkg_[rw]stat_exit() added.

* As blkg_rwstat->cpu_cnt[] can't be read directly anymore, reading
  and summing results are stored in ->aux_cnt[] instead.

* Custom per-cpu stat implementation in blk-throttle is removed.

This makes all blkcg stat counters per-cpu without complicating policy
implmentations.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c         |  10 ++--
 block/blk-throttle.c       |  89 +++++++++++----------------------
 block/cfq-iosched.c        |  70 +++++++++++++++++++-------
 include/linux/blk-cgroup.h | 120 +++++++++++++++++++++++++--------------------
 4 files changed, 153 insertions(+), 136 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b7d22b2..bc90b5b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -573,9 +573,10 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 
 	for (i = 0; i < BLKG_RWSTAT_NR; i++)
 		seq_printf(sf, "%s %s %llu\n", dname, rwstr[i],
-			   (unsigned long long)rwstat->cnt[i]);
+			   (unsigned long long)atomic64_read(&rwstat->aux_cnt[i]));
 
-	v = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
+	v = atomic64_read(&rwstat->aux_cnt[BLKG_RWSTAT_READ]) +
+		atomic64_read(&rwstat->aux_cnt[BLKG_RWSTAT_WRITE]);
 	seq_printf(sf, "%s Total %llu\n", dname, (unsigned long long)v);
 	return v;
 }
@@ -677,8 +678,9 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
 		tmp = blkg_rwstat_read(rwstat);
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
-			sum.cnt[i] += tmp.cnt[i] +
-				atomic64_read(&rwstat->aux_cnt[i]);
+			atomic64_add(atomic64_read(&tmp.aux_cnt[i]) +
+				     atomic64_read(&rwstat->aux_cnt[i]),
+				     &sum.aux_cnt[i]);
 	}
 	rcu_read_unlock();
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c2c7547..ff7b6bb 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -83,14 +83,6 @@ enum tg_state_flags {
 
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
 
-/* Per-cpu group stats */
-struct tg_stats_cpu {
-	/* total bytes transferred */
-	struct blkg_rwstat		service_bytes;
-	/* total IOs serviced, post merge */
-	struct blkg_rwstat		serviced;
-};
-
 struct throtl_grp {
 	/* must be the first member */
 	struct blkg_policy_data pd;
@@ -142,8 +134,10 @@ struct throtl_grp {
 	unsigned long slice_start[2];
 	unsigned long slice_end[2];
 
-	/* Per cpu stats pointer */
-	struct tg_stats_cpu __percpu *stats_cpu;
+	/* total bytes transferred */
+	struct blkg_rwstat		service_bytes;
+	/* total IOs serviced, post merge */
+	struct blkg_rwstat		serviced;
 };
 
 struct throtl_data
@@ -342,17 +336,15 @@ static void throtl_service_queue_init(struct throtl_service_queue *sq)
 static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 {
 	struct throtl_grp *tg;
-	int rw, cpu;
+	int rw;
 
 	tg = kzalloc_node(sizeof(*tg), gfp, node);
 	if (!tg)
-		return NULL;
+		goto err;
 
-	tg->stats_cpu = alloc_percpu_gfp(struct tg_stats_cpu, gfp);
-	if (!tg->stats_cpu) {
-		kfree(tg);
-		return NULL;
-	}
+	if (blkg_rwstat_init(&tg->service_bytes, gfp) ||
+	    blkg_rwstat_init(&tg->serviced, gfp))
+		goto err_free_tg;
 
 	throtl_service_queue_init(&tg->service_queue);
 
@@ -367,14 +359,14 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 	tg->iops[READ] = -1;
 	tg->iops[WRITE] = -1;
 
-	for_each_possible_cpu(cpu) {
-		struct tg_stats_cpu *stats_cpu = per_cpu_ptr(tg->stats_cpu, cpu);
-
-		blkg_rwstat_init(&stats_cpu->service_bytes);
-		blkg_rwstat_init(&stats_cpu->serviced);
-	}
-
 	return &tg->pd;
+
+err_free_tg:
+	blkg_rwstat_exit(&tg->serviced);
+	blkg_rwstat_exit(&tg->service_bytes);
+	kfree(tg);
+err:
+	return NULL;
 }
 
 static void throtl_pd_init(struct blkg_policy_data *pd)
@@ -432,21 +424,17 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 	struct throtl_grp *tg = pd_to_tg(pd);
 
 	del_timer_sync(&tg->service_queue.pending_timer);
-	free_percpu(tg->stats_cpu);
+	blkg_rwstat_exit(&tg->serviced);
+	blkg_rwstat_exit(&tg->service_bytes);
 	kfree(tg);
 }
 
 static void throtl_pd_reset_stats(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
-	int cpu;
 
-	for_each_possible_cpu(cpu) {
-		struct tg_stats_cpu *sc = per_cpu_ptr(tg->stats_cpu, cpu);
-
-		blkg_rwstat_reset(&sc->service_bytes);
-		blkg_rwstat_reset(&sc->serviced);
-	}
+	blkg_rwstat_reset(&tg->service_bytes);
+	blkg_rwstat_reset(&tg->serviced);
 }
 
 static struct throtl_grp *throtl_lookup_tg(struct throtl_data *td,
@@ -900,7 +888,6 @@ static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
 					 int rw)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
-	struct tg_stats_cpu *stats_cpu;
 	unsigned long flags;
 
 	/*
@@ -910,10 +897,8 @@ static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
 	 */
 	local_irq_save(flags);
 
-	stats_cpu = this_cpu_ptr(tg->stats_cpu);
-
-	blkg_rwstat_add(&stats_cpu->serviced, rw, 1);
-	blkg_rwstat_add(&stats_cpu->service_bytes, rw, bytes);
+	blkg_rwstat_add(&tg->serviced, rw, 1);
+	blkg_rwstat_add(&tg->service_bytes, rw, bytes);
 
 	local_irq_restore(flags);
 }
@@ -1221,27 +1206,9 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 	}
 }
 
-static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
-				struct blkg_policy_data *pd, int off)
-{
-	struct throtl_grp *tg = pd_to_tg(pd);
-	struct blkg_rwstat rwstat = { }, tmp;
-	int i, cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct tg_stats_cpu *sc = per_cpu_ptr(tg->stats_cpu, cpu);
-
-		tmp = blkg_rwstat_read((void *)sc + off);
-		for (i = 0; i < BLKG_RWSTAT_NR; i++)
-			rwstat.cnt[i] += tmp.cnt[i];
-	}
-
-	return __blkg_prfill_rwstat(sf, pd, &rwstat);
-}
-
-static int tg_print_cpu_rwstat(struct seq_file *sf, void *v)
+static int tg_print_rwstat(struct seq_file *sf, void *v)
 {
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), tg_prfill_cpu_rwstat,
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_rwstat,
 			  &blkcg_policy_throtl, seq_cft(sf)->private, true);
 	return 0;
 }
@@ -1382,13 +1349,13 @@ static struct cftype throtl_files[] = {
 	},
 	{
 		.name = "throttle.io_service_bytes",
-		.private = offsetof(struct tg_stats_cpu, service_bytes),
-		.seq_show = tg_print_cpu_rwstat,
+		.private = offsetof(struct throtl_grp, service_bytes),
+		.seq_show = tg_print_rwstat,
 	},
 	{
 		.name = "throttle.io_serviced",
-		.private = offsetof(struct tg_stats_cpu, serviced),
-		.seq_show = tg_print_cpu_rwstat,
+		.private = offsetof(struct throtl_grp, serviced),
+		.seq_show = tg_print_rwstat,
 	},
 	{ }	/* terminate */
 };
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cf49914..3bdef38 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1517,27 +1517,55 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-static void cfqg_stats_init(struct cfqg_stats *stats)
+static void cfqg_stats_exit(struct cfqg_stats *stats)
 {
-	blkg_rwstat_init(&stats->service_bytes);
-	blkg_rwstat_init(&stats->serviced);
-	blkg_rwstat_init(&stats->merged);
-	blkg_rwstat_init(&stats->service_time);
-	blkg_rwstat_init(&stats->wait_time);
-	blkg_rwstat_init(&stats->queued);
+	blkg_rwstat_exit(&stats->service_bytes);
+	blkg_rwstat_exit(&stats->serviced);
+	blkg_rwstat_exit(&stats->merged);
+	blkg_rwstat_exit(&stats->service_time);
+	blkg_rwstat_exit(&stats->wait_time);
+	blkg_rwstat_exit(&stats->queued);
 
-	blkg_stat_init(&stats->sectors);
-	blkg_stat_init(&stats->time);
+	blkg_stat_exit(&stats->sectors);
+	blkg_stat_exit(&stats->time);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
+	blkg_stat_exit(&stats->unaccounted_time);
+	blkg_stat_exit(&stats->avg_queue_size_sum);
+	blkg_stat_exit(&stats->avg_queue_size_samples);
+	blkg_stat_exit(&stats->dequeue);
+	blkg_stat_exit(&stats->group_wait_time);
+	blkg_stat_exit(&stats->idle_time);
+	blkg_stat_exit(&stats->empty_time);
+#endif
+}
+
+static int cfqg_stats_init(struct cfqg_stats *stats, gfp_t gfp)
+{
+	if (blkg_rwstat_init(&stats->service_bytes, gfp) ||
+	    blkg_rwstat_init(&stats->serviced, gfp) ||
+	    blkg_rwstat_init(&stats->merged, gfp) ||
+	    blkg_rwstat_init(&stats->service_time, gfp) ||
+	    blkg_rwstat_init(&stats->wait_time, gfp) ||
+	    blkg_rwstat_init(&stats->queued, gfp) ||
+
+	    blkg_stat_init(&stats->sectors, gfp) ||
+	    blkg_stat_init(&stats->time, gfp))
+		goto err;
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-	blkg_stat_init(&stats->unaccounted_time);
-	blkg_stat_init(&stats->avg_queue_size_sum);
-	blkg_stat_init(&stats->avg_queue_size_samples);
-	blkg_stat_init(&stats->dequeue);
-	blkg_stat_init(&stats->group_wait_time);
-	blkg_stat_init(&stats->idle_time);
-	blkg_stat_init(&stats->empty_time);
+	if (blkg_stat_init(&stats->unaccounted_time, gfp) ||
+	    blkg_stat_init(&stats->avg_queue_size_sum, gfp) ||
+	    blkg_stat_init(&stats->avg_queue_size_samples, gfp) ||
+	    blkg_stat_init(&stats->dequeue, gfp) ||
+	    blkg_stat_init(&stats->group_wait_time, gfp) ||
+	    blkg_stat_init(&stats->idle_time, gfp) ||
+	    blkg_stat_init(&stats->empty_time, gfp))
+		goto err;
 #endif
+	return 0;
+err:
+	cfqg_stats_exit(stats);
+	return -ENOMEM;
 }
 
 static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
@@ -1549,7 +1577,10 @@ static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
 		return NULL;
 
 	cfq_init_cfqg_base(cfqg);
-	cfqg_stats_init(&cfqg->stats);
+	if (cfqg_stats_init(&cfqg->stats, gfp)) {
+		kfree(cfqg);
+		return NULL;
+	}
 
 	return &cfqg->pd;
 }
@@ -1589,7 +1620,10 @@ static void cfq_pd_offline(struct blkg_policy_data *pd)
 
 static void cfq_pd_free(struct blkg_policy_data *pd)
 {
-	return kfree(pd);
+	struct cfq_group *cfqg = pd_to_cfqg(pd);
+
+	cfqg_stats_exit(&cfqg->stats);
+	return kfree(cfqg);
 }
 
 static void cfq_pd_reset_stats(struct blkg_policy_data *pd)
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 8ae1fc4..8d53fbc 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -14,12 +14,15 @@
  */
 
 #include <linux/cgroup.h>
-#include <linux/u64_stats_sync.h>
+#include <linux/percpu_counter.h>
 #include <linux/seq_file.h>
 #include <linux/radix-tree.h>
 #include <linux/blkdev.h>
 #include <linux/atomic.h>
 
+/* percpu_counter batch for blkg_[rw]stats, per-cpu drift doesn't matter */
+#define BLKG_STAT_CPU_BATCH	(INT_MAX / 2)
+
 /* Max limits for throttle policy */
 #define THROTL_IOPS_MAX		UINT_MAX
 
@@ -61,17 +64,16 @@ struct blkcg {
 
 /*
  * blkg_[rw]stat->aux_cnt is excluded for local stats but included for
- * recursive.  Used to carry stats of dead children.
+ * recursive.  Used to carry stats of dead children, and, for blkg_rwstat,
+ * to carry result values from read and sum operations.
  */
 struct blkg_stat {
-	struct u64_stats_sync		syncp;
-	uint64_t			cnt;
+	struct percpu_counter		cpu_cnt;
 	atomic64_t			aux_cnt;
 };
 
 struct blkg_rwstat {
-	struct u64_stats_sync		syncp;
-	uint64_t			cnt[BLKG_RWSTAT_NR];
+	struct percpu_counter		cpu_cnt[BLKG_RWSTAT_NR];
 	atomic64_t			aux_cnt[BLKG_RWSTAT_NR];
 };
 
@@ -420,10 +422,21 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = __blk_queue_next_rl((rl), (q)))
 
-static inline void blkg_stat_init(struct blkg_stat *stat)
+static inline int blkg_stat_init(struct blkg_stat *stat, gfp_t gfp)
 {
-	u64_stats_init(&stat->syncp);
+	int ret;
+
+	ret = percpu_counter_init(&stat->cpu_cnt, 0, gfp);
+	if (ret)
+		return ret;
+
 	atomic64_set(&stat->aux_cnt, 0);
+	return 0;
+}
+
+static inline void blkg_stat_exit(struct blkg_stat *stat)
+{
+	percpu_counter_destroy(&stat->cpu_cnt);
 }
 
 /**
@@ -431,35 +444,21 @@ static inline void blkg_stat_init(struct blkg_stat *stat)
  * @stat: target blkg_stat
  * @val: value to add
  *
- * Add @val to @stat.  The caller is responsible for synchronizing calls to
- * this function.
+ * Add @val to @stat.  The caller must ensure that IRQ on the same CPU
+ * don't re-enter this function for the same counter.
  */
 static inline void blkg_stat_add(struct blkg_stat *stat, uint64_t val)
 {
-	u64_stats_update_begin(&stat->syncp);
-	stat->cnt += val;
-	u64_stats_update_end(&stat->syncp);
+	__percpu_counter_add(&stat->cpu_cnt, val, BLKG_STAT_CPU_BATCH);
 }
 
 /**
  * blkg_stat_read - read the current value of a blkg_stat
  * @stat: blkg_stat to read
- *
- * Read the current value of @stat.  The returned value doesn't include the
- * aux count.  This function can be called without synchroniztion and takes
- * care of u64 atomicity.
  */
 static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 {
-	unsigned int start;
-	uint64_t v;
-
-	do {
-		start = u64_stats_fetch_begin_irq(&stat->syncp);
-		v = stat->cnt;
-	} while (u64_stats_fetch_retry_irq(&stat->syncp, start));
-
-	return v;
+	return percpu_counter_sum_positive(&stat->cpu_cnt);
 }
 
 /**
@@ -468,7 +467,7 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
  */
 static inline void blkg_stat_reset(struct blkg_stat *stat)
 {
-	stat->cnt = 0;
+	percpu_counter_set(&stat->cpu_cnt, 0);
 	atomic64_set(&stat->aux_cnt, 0);
 }
 
@@ -486,14 +485,28 @@ static inline void blkg_stat_add_aux(struct blkg_stat *to,
 		     &to->aux_cnt);
 }
 
-static inline void blkg_rwstat_init(struct blkg_rwstat *rwstat)
+static inline int blkg_rwstat_init(struct blkg_rwstat *rwstat, gfp_t gfp)
 {
-	int i;
+	int i, ret;
+
+	for (i = 0; i < BLKG_RWSTAT_NR; i++) {
+		ret = percpu_counter_init(&rwstat->cpu_cnt[i], 0, gfp);
+		if (ret) {
+			while (--i >= 0)
+				percpu_counter_destroy(&rwstat->cpu_cnt[i]);
+			return ret;
+		}
+		atomic64_set(&rwstat->aux_cnt[i], 0);
+	}
+	return 0;
+}
 
-	u64_stats_init(&rwstat->syncp);
+static inline void blkg_rwstat_exit(struct blkg_rwstat *rwstat)
+{
+	int i;
 
 	for (i = 0; i < BLKG_RWSTAT_NR; i++)
-		atomic64_set(&rwstat->aux_cnt[i], 0);
+		percpu_counter_destroy(&rwstat->cpu_cnt[i]);
 }
 
 /**
@@ -508,39 +521,38 @@ static inline void blkg_rwstat_init(struct blkg_rwstat *rwstat)
 static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
 				   int rw, uint64_t val)
 {
-	u64_stats_update_begin(&rwstat->syncp);
+	struct percpu_counter *cnt;
 
 	if (rw & REQ_WRITE)
-		rwstat->cnt[BLKG_RWSTAT_WRITE] += val;
+		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_WRITE];
 	else
-		rwstat->cnt[BLKG_RWSTAT_READ] += val;
+		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_READ];
+
+	__percpu_counter_add(cnt, val, BLKG_STAT_CPU_BATCH);
+
 	if (rw & REQ_SYNC)
-		rwstat->cnt[BLKG_RWSTAT_SYNC] += val;
+		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_SYNC];
 	else
-		rwstat->cnt[BLKG_RWSTAT_ASYNC] += val;
+		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_ASYNC];
 
-	u64_stats_update_end(&rwstat->syncp);
+	__percpu_counter_add(cnt, val, BLKG_STAT_CPU_BATCH);
 }
 
 /**
  * blkg_rwstat_read - read the current values of a blkg_rwstat
  * @rwstat: blkg_rwstat to read
  *
- * Read the current snapshot of @rwstat and return it as the return value.
- * This function can be called without synchronization and takes care of
- * u64 atomicity.
+ * Read the current snapshot of @rwstat and return it in the aux counts.
  */
 static inline struct blkg_rwstat blkg_rwstat_read(struct blkg_rwstat *rwstat)
 {
-	unsigned int start;
-	struct blkg_rwstat tmp;
-
-	do {
-		start = u64_stats_fetch_begin_irq(&rwstat->syncp);
-		tmp = *rwstat;
-	} while (u64_stats_fetch_retry_irq(&rwstat->syncp, start));
+	struct blkg_rwstat result;
+	int i;
 
-	return tmp;
+	for (i = 0; i < BLKG_RWSTAT_NR; i++)
+		atomic64_set(&result.aux_cnt[i],
+			     percpu_counter_sum_positive(&rwstat->cpu_cnt[i]));
+	return result;
 }
 
 /**
@@ -555,7 +567,8 @@ static inline uint64_t blkg_rwstat_total(struct blkg_rwstat *rwstat)
 {
 	struct blkg_rwstat tmp = blkg_rwstat_read(rwstat);
 
-	return tmp.cnt[BLKG_RWSTAT_READ] + tmp.cnt[BLKG_RWSTAT_WRITE];
+	return atomic64_read(&tmp.aux_cnt[BLKG_RWSTAT_READ]) +
+		atomic64_read(&tmp.aux_cnt[BLKG_RWSTAT_WRITE]);
 }
 
 /**
@@ -566,10 +579,10 @@ static inline void blkg_rwstat_reset(struct blkg_rwstat *rwstat)
 {
 	int i;
 
-	memset(rwstat->cnt, 0, sizeof(rwstat->cnt));
-
-	for (i = 0; i < BLKG_RWSTAT_NR; i++)
+	for (i = 0; i < BLKG_RWSTAT_NR; i++) {
+		percpu_counter_set(&rwstat->cpu_cnt[i], 0);
 		atomic64_set(&rwstat->aux_cnt[i], 0);
+	}
 }
 
 /**
@@ -586,7 +599,8 @@ static inline void blkg_rwstat_add_aux(struct blkg_rwstat *to,
 	int i;
 
 	for (i = 0; i < BLKG_RWSTAT_NR; i++)
-		atomic64_add(v.cnt[i] + atomic64_read(&from->aux_cnt[i]),
+		atomic64_add(atomic64_read(&v.aux_cnt[i]) +
+			     atomic64_read(&from->aux_cnt[i]),
 			     &to->aux_cnt[i]);
 }
 
-- 
2.4.3
