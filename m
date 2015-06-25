From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/6] blkcg: add blkg_[rw]stat->aux_cnt and replace cfq_group->dead_stats with it
Date: Thu, 25 Jun 2015 17:38:53 -0400
Message-ID: <1435268337-1738-3-git-send-email-tj@kernel.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NcUuWe2ns/M99wDigJ6YDgpZRe9lJRddVZkyScX/p6A=;
        b=fOeErdsAsNXkeXAepkS90s8QY8Fd/5mRxdkrzX0wElBc2b2RFbR6PImEDWLZNvxODH
         5dtcq7Hoe2w1oCsIUYg1HR2mtT6lmOpxJuXxZQjl5nQkE5MH2HP2OMfGa1E9DxPAJEGl
         f+IlMdeT6sSja5mQOFStbyrUvV/FEHHM3nlp404bSDCzYUdXU2SKxiK7UovuwrRpYGvf
         55tKx8wCuzE9ndaE802L3C29jFvAAYT1faqHE7uj95uk/MMq853TEWEqeCNamtaX4s4e
         kl+Cj6u/Bqu8xIAY4QyyUks63T2ek0nc0lk7umK25KohXjkznRID/cNEmIV1EGybGsSX
         KyUg==
In-Reply-To: <1435268337-1738-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup stats are local to each cgroup and doesn't propagate to
ancestors by default.  When recursive stats are necessary, the sum is
calculated over all the descendants.  This initially was for backward
compatibility to support both group-local and recursive stats but this
mode of operation makes general sense as stat update is much hotter
thafn reporting those stats.

This however ends up losing recursive stats when a child is removed.
To work around this, cfq-iosched adds its stats to its parent
cfq_group->dead_stats which is summed up together when calculating
recursive stats.

It's planned that the core stats will be moved to blkcg_gq, so we want
to move the mechanism for keeping track of the stats of dead children
from cfq to blkcg core.  This patch adds blkg_[rw]stat->aux_cnt which
are atomic64_t's keeping track of auxiliary counts which are excluded
when reading local counts but included for recursive.

blkg_[rw]stat_merge() which were used by cfq to implement dead_stats
are replaced by blkg_[rw]stat_add_aux(), and cfq now forwards stats of
a dead cgroup to the aux counts of parent->stats instead of separate
->dead_stats.

This will also help making blkg_[rw]stats per-cpu.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c         | 10 ++++---
 block/cfq-iosched.c        | 67 +++++++++++++---------------------------------
 include/linux/blk-cgroup.h | 46 ++++++++++++++++++++++---------
 3 files changed, 57 insertions(+), 66 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 15d9628b..b7d22b2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -618,7 +618,7 @@ EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
  * @off: offset to the blkg_stat in @pd
  *
  * Collect the blkg_stat specified by @off from @pd and all its online
- * descendants and return the sum.  The caller must be holding the queue
+ * descendants and their aux counts.  The caller must be holding the queue
  * lock for online tests.
  */
 u64 blkg_stat_recursive_sum(struct blkg_policy_data *pd, int off)
@@ -636,7 +636,8 @@ u64 blkg_stat_recursive_sum(struct blkg_policy_data *pd, int off)
 		struct blkg_stat *stat = (void *)pos_pd + off;
 
 		if (pos_blkg->online)
-			sum += blkg_stat_read(stat);
+			sum += blkg_stat_read(stat) +
+				atomic64_read(&stat->aux_cnt);
 	}
 	rcu_read_unlock();
 
@@ -650,7 +651,7 @@ EXPORT_SYMBOL_GPL(blkg_stat_recursive_sum);
  * @off: offset to the blkg_stat in @pd
  *
  * Collect the blkg_rwstat specified by @off from @pd and all its online
- * descendants and return the sum.  The caller must be holding the queue
+ * descendants and their aux counts.  The caller must be holding the queue
  * lock for online tests.
  */
 struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
@@ -676,7 +677,8 @@ struct blkg_rwstat blkg_rwstat_recursive_sum(struct blkg_policy_data *pd,
 		tmp = blkg_rwstat_read(rwstat);
 
 		for (i = 0; i < BLKG_RWSTAT_NR; i++)
-			sum.cnt[i] += tmp.cnt[i];
+			sum.cnt[i] += tmp.cnt[i] +
+				atomic64_read(&rwstat->aux_cnt[i]);
 	}
 	rcu_read_unlock();
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d2bc961..cf49914 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -290,7 +290,6 @@ struct cfq_group {
 	int dispatched;
 	struct cfq_ttime ttime;
 	struct cfqg_stats stats;	/* stats for this cfqg */
-	struct cfqg_stats dead_stats;	/* stats pushed from dead children */
 
 	/* async queue for each priority case */
 	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
@@ -711,28 +710,28 @@ static void cfqg_stats_reset(struct cfqg_stats *stats)
 }
 
 /* @to += @from */
-static void cfqg_stats_merge(struct cfqg_stats *to, struct cfqg_stats *from)
+static void cfqg_stats_add_aux(struct cfqg_stats *to, struct cfqg_stats *from)
 {
 	/* queued stats shouldn't be cleared */
-	blkg_rwstat_merge(&to->service_bytes, &from->service_bytes);
-	blkg_rwstat_merge(&to->serviced, &from->serviced);
-	blkg_rwstat_merge(&to->merged, &from->merged);
-	blkg_rwstat_merge(&to->service_time, &from->service_time);
-	blkg_rwstat_merge(&to->wait_time, &from->wait_time);
-	blkg_stat_merge(&from->time, &from->time);
+	blkg_rwstat_add_aux(&to->service_bytes, &from->service_bytes);
+	blkg_rwstat_add_aux(&to->serviced, &from->serviced);
+	blkg_rwstat_add_aux(&to->merged, &from->merged);
+	blkg_rwstat_add_aux(&to->service_time, &from->service_time);
+	blkg_rwstat_add_aux(&to->wait_time, &from->wait_time);
+	blkg_stat_add_aux(&from->time, &from->time);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-	blkg_stat_merge(&to->unaccounted_time, &from->unaccounted_time);
-	blkg_stat_merge(&to->avg_queue_size_sum, &from->avg_queue_size_sum);
-	blkg_stat_merge(&to->avg_queue_size_samples, &from->avg_queue_size_samples);
-	blkg_stat_merge(&to->dequeue, &from->dequeue);
-	blkg_stat_merge(&to->group_wait_time, &from->group_wait_time);
-	blkg_stat_merge(&to->idle_time, &from->idle_time);
-	blkg_stat_merge(&to->empty_time, &from->empty_time);
+	blkg_stat_add_aux(&to->unaccounted_time, &from->unaccounted_time);
+	blkg_stat_add_aux(&to->avg_queue_size_sum, &from->avg_queue_size_sum);
+	blkg_stat_add_aux(&to->avg_queue_size_samples, &from->avg_queue_size_samples);
+	blkg_stat_add_aux(&to->dequeue, &from->dequeue);
+	blkg_stat_add_aux(&to->group_wait_time, &from->group_wait_time);
+	blkg_stat_add_aux(&to->idle_time, &from->idle_time);
+	blkg_stat_add_aux(&to->empty_time, &from->empty_time);
 #endif
 }
 
 /*
- * Transfer @cfqg's stats to its parent's dead_stats so that the ancestors'
+ * Transfer @cfqg's stats to its parent's aux counts so that the ancestors'
  * recursive stats can still account for the amount used by this cfqg after
  * it's gone.
  */
@@ -745,10 +744,8 @@ static void cfqg_stats_xfer_dead(struct cfq_group *cfqg)
 	if (unlikely(!parent))
 		return;
 
-	cfqg_stats_merge(&parent->dead_stats, &cfqg->stats);
-	cfqg_stats_merge(&parent->dead_stats, &cfqg->dead_stats);
+	cfqg_stats_add_aux(&parent->stats, &cfqg->stats);
 	cfqg_stats_reset(&cfqg->stats);
-	cfqg_stats_reset(&cfqg->dead_stats);
 }
 
 #else	/* CONFIG_CFQ_GROUP_IOSCHED */
@@ -1553,7 +1550,6 @@ static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
 
 	cfq_init_cfqg_base(cfqg);
 	cfqg_stats_init(&cfqg->stats);
-	cfqg_stats_init(&cfqg->dead_stats);
 
 	return &cfqg->pd;
 }
@@ -1596,38 +1592,11 @@ static void cfq_pd_free(struct blkg_policy_data *pd)
 	return kfree(pd);
 }
 
-/* offset delta from cfqg->stats to cfqg->dead_stats */
-static const int dead_stats_off_delta = offsetof(struct cfq_group, dead_stats) -
-					offsetof(struct cfq_group, stats);
-
-/* to be used by recursive prfill, sums live and dead stats recursively */
-static u64 cfqg_stat_pd_recursive_sum(struct blkg_policy_data *pd, int off)
-{
-	u64 sum = 0;
-
-	sum += blkg_stat_recursive_sum(pd, off);
-	sum += blkg_stat_recursive_sum(pd, off + dead_stats_off_delta);
-	return sum;
-}
-
-/* to be used by recursive prfill, sums live and dead rwstats recursively */
-static struct blkg_rwstat cfqg_rwstat_pd_recursive_sum(struct blkg_policy_data *pd,
-						       int off)
-{
-	struct blkg_rwstat a, b;
-
-	a = blkg_rwstat_recursive_sum(pd, off);
-	b = blkg_rwstat_recursive_sum(pd, off + dead_stats_off_delta);
-	blkg_rwstat_merge(&a, &b);
-	return a;
-}
-
 static void cfq_pd_reset_stats(struct blkg_policy_data *pd)
 {
 	struct cfq_group *cfqg = pd_to_cfqg(pd);
 
 	cfqg_stats_reset(&cfqg->stats);
-	cfqg_stats_reset(&cfqg->dead_stats);
 }
 
 /*
@@ -1815,7 +1784,7 @@ static int cfqg_print_rwstat(struct seq_file *sf, void *v)
 static u64 cfqg_prfill_stat_recursive(struct seq_file *sf,
 				      struct blkg_policy_data *pd, int off)
 {
-	u64 sum = cfqg_stat_pd_recursive_sum(pd, off);
+	u64 sum = blkg_stat_recursive_sum(pd, off);
 
 	return __blkg_prfill_u64(sf, pd, sum);
 }
@@ -1823,7 +1792,7 @@ static u64 cfqg_prfill_stat_recursive(struct seq_file *sf,
 static u64 cfqg_prfill_rwstat_recursive(struct seq_file *sf,
 					struct blkg_policy_data *pd, int off)
 {
-	struct blkg_rwstat sum = cfqg_rwstat_pd_recursive_sum(pd, off);
+	struct blkg_rwstat sum = blkg_rwstat_recursive_sum(pd, off);
 
 	return __blkg_prfill_rwstat(sf, pd, &sum);
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index cafc54a..8ae1fc4 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -59,14 +59,20 @@ struct blkcg {
 #endif
 };
 
+/*
+ * blkg_[rw]stat->aux_cnt is excluded for local stats but included for
+ * recursive.  Used to carry stats of dead children.
+ */
 struct blkg_stat {
 	struct u64_stats_sync		syncp;
 	uint64_t			cnt;
+	atomic64_t			aux_cnt;
 };
 
 struct blkg_rwstat {
 	struct u64_stats_sync		syncp;
 	uint64_t			cnt[BLKG_RWSTAT_NR];
+	atomic64_t			aux_cnt[BLKG_RWSTAT_NR];
 };
 
 /*
@@ -417,6 +423,7 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
 static inline void blkg_stat_init(struct blkg_stat *stat)
 {
 	u64_stats_init(&stat->syncp);
+	atomic64_set(&stat->aux_cnt, 0);
 }
 
 /**
@@ -438,8 +445,9 @@ static inline void blkg_stat_add(struct blkg_stat *stat, uint64_t val)
  * blkg_stat_read - read the current value of a blkg_stat
  * @stat: blkg_stat to read
  *
- * Read the current value of @stat.  This function can be called without
- * synchroniztion and takes care of u64 atomicity.
+ * Read the current value of @stat.  The returned value doesn't include the
+ * aux count.  This function can be called without synchroniztion and takes
+ * care of u64 atomicity.
  */
 static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 {
@@ -461,23 +469,31 @@ static inline uint64_t blkg_stat_read(struct blkg_stat *stat)
 static inline void blkg_stat_reset(struct blkg_stat *stat)
 {
 	stat->cnt = 0;
+	atomic64_set(&stat->aux_cnt, 0);
 }
 
 /**
- * blkg_stat_merge - merge a blkg_stat into another
+ * blkg_stat_add_aux - add a blkg_stat into another's aux count
  * @to: the destination blkg_stat
  * @from: the source
  *
- * Add @from's count to @to.
+ * Add @from's count including the aux one to @to's aux count.
  */
-static inline void blkg_stat_merge(struct blkg_stat *to, struct blkg_stat *from)
+static inline void blkg_stat_add_aux(struct blkg_stat *to,
+				     struct blkg_stat *from)
 {
-	blkg_stat_add(to, blkg_stat_read(from));
+	atomic64_add(blkg_stat_read(from) + atomic64_read(&from->aux_cnt),
+		     &to->aux_cnt);
 }
 
 static inline void blkg_rwstat_init(struct blkg_rwstat *rwstat)
 {
+	int i;
+
 	u64_stats_init(&rwstat->syncp);
+
+	for (i = 0; i < BLKG_RWSTAT_NR; i++)
+		atomic64_set(&rwstat->aux_cnt[i], 0);
 }
 
 /**
@@ -548,26 +564,30 @@ static inline uint64_t blkg_rwstat_total(struct blkg_rwstat *rwstat)
  */
 static inline void blkg_rwstat_reset(struct blkg_rwstat *rwstat)
 {
+	int i;
+
 	memset(rwstat->cnt, 0, sizeof(rwstat->cnt));
+
+	for (i = 0; i < BLKG_RWSTAT_NR; i++)
+		atomic64_set(&rwstat->aux_cnt[i], 0);
 }
 
 /**
- * blkg_rwstat_merge - merge a blkg_rwstat into another
+ * blkg_rwstat_add_aux - add a blkg_rwstat into another's aux count
  * @to: the destination blkg_rwstat
  * @from: the source
  *
- * Add @from's counts to @to.
+ * Add @from's count including the aux one to @to's aux count.
  */
-static inline void blkg_rwstat_merge(struct blkg_rwstat *to,
-				     struct blkg_rwstat *from)
+static inline void blkg_rwstat_add_aux(struct blkg_rwstat *to,
+				       struct blkg_rwstat *from)
 {
 	struct blkg_rwstat v = blkg_rwstat_read(from);
 	int i;
 
-	u64_stats_update_begin(&to->syncp);
 	for (i = 0; i < BLKG_RWSTAT_NR; i++)
-		to->cnt[i] += v.cnt[i];
-	u64_stats_update_end(&to->syncp);
+		atomic64_add(v.cnt[i] + atomic64_read(&from->aux_cnt[i]),
+			     &to->aux_cnt[i]);
 }
 
 #else	/* CONFIG_BLK_CGROUP */
-- 
2.4.3
