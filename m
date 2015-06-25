From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] blkcg: move io_service_bytes and io_serviced stats into blkcg_gq
Date: Thu, 25 Jun 2015 17:38:56 -0400
Message-ID: <1435268337-1738-6-git-send-email-tj@kernel.org>
References: <1435268337-1738-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zIdkRHagdLEeguPIIyA04YQwCFTIvqRXKoUVxaUnKTM=;
        b=smL0mnOsEzjN4+35UpjqwaGfptLUOLjnZc+5vJy1EUJfGshbstBwQcDWJzVs4qRhFU
         Rsyf7wz6Qu9IkZtjJkFvMtX5j4nFmG+FpBpazxuhskCT4AO+qIcBxS9wllgP58sHKorP
         QXdtIvWtK9ksw7/JbRrxwjk4ZeQNoHhVFNCU1jy41QneN5pi4T540gcajnsVv0V8Thn7
         Bble+rv4Gs4PEwPhvTme3+MriktprG4OVg8+q5v4aKSg7Wc2gu2iA7aU8sTzxJ5uGFwO
         S0kwiZzwMzqlv0FMnjivQtcLgmnJ2L0GZO9MPyiNKfGWnPBS7tS3FH2ADfL6RvxgsGPg
         fRDA==
In-Reply-To: <1435268337-1738-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Currently, both cfq-iosched and blk-throttle keep track of
io_service_bytes and io_serviced stats.  While keeping track of them
separately may be useful during development, it doesn't make much
sense otherwise.  Also, blkcg stats are collected at different points
and ignoring blk_do_io_stat() which can lead to subtly different
results which are more confusing than helpful.

This patch adds ->stat_bytes and ->stat_ios to blkg (blkcg_gq),
removes the counterparts from cfq-iosched and blk-throttle and let
them print from the common blkg counters.

The outputs are still filtered by whether the policy has
blkg_policy_data on a given blkg, so cfq's output won't show up if it
has never been used for a given blkg.  The only times when the outputs
would differ significantly are when policies are attached on the fly
or elevators are switched back and forth.  Those are quite exceptional
operations and I don't think they warrant keeping separate counters.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c         | 98 ++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-core.c           |  4 ++
 block/blk-throttle.c       | 82 ++++----------------------------------
 block/cfq-iosched.c        | 32 +++++----------
 include/linux/blk-cgroup.h | 26 ++++++++++++
 5 files changed, 145 insertions(+), 97 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 899232e..67211a4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -60,6 +60,9 @@ static void blkg_free(struct blkcg_gq *blkg)
 
 	if (blkg->blkcg != &blkcg_root)
 		blk_exit_rl(&blkg->rl);
+
+	blkg_rwstat_exit(&blkg->stat_ios);
+	blkg_rwstat_exit(&blkg->stat_bytes);
 	kfree(blkg);
 }
 
@@ -82,6 +85,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 	if (!blkg)
 		return NULL;
 
+	if (blkg_rwstat_init(&blkg->stat_bytes, gfp_mask) ||
+	    blkg_rwstat_init(&blkg->stat_ios, gfp_mask))
+		goto err_free;
+
 	blkg->q = q;
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
@@ -321,6 +328,7 @@ EXPORT_SYMBOL_GPL(blkg_lookup_create);
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
 	struct blkcg *blkcg = blkg->blkcg;
+	struct blkcg_gq *parent = blkg->parent;
 	int i;
 
 	lockdep_assert_held(blkg->q->queue_lock);
@@ -336,6 +344,12 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		if (blkg->pd[i] && pol->pd_offline_fn)
 			pol->pd_offline_fn(blkg->pd[i]);
 	}
+
+	if (parent) {
+		blkg_rwstat_add_aux(&parent->stat_bytes, &blkg->stat_bytes);
+		blkg_rwstat_add_aux(&parent->stat_ios, &blkg->stat_ios);
+	}
+
 	blkg->online = false;
 
 	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
@@ -465,6 +479,9 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 	 * anyway.  If you get hit by a race, retry.
 	 */
 	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
+		blkg_rwstat_reset(&blkg->stat_bytes);
+		blkg_rwstat_reset(&blkg->stat_ios);
+
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
 
@@ -613,6 +630,87 @@ u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 }
 EXPORT_SYMBOL_GPL(blkg_prfill_rwstat);
 
+static u64 blkg_prfill_rwstat_field(struct seq_file *sf,
+				    struct blkg_policy_data *pd, int off)
+{
+	struct blkg_rwstat rwstat = blkg_rwstat_read((void *)pd->blkg + off);
+
+	return __blkg_prfill_rwstat(sf, pd, &rwstat);
+}
+
+/**
+ * blkg_print_stat_bytes - seq_show callback for blkg->stat_bytes
+ * @sf: seq_file to print to
+ * @v: unused
+ *
+ * To be used as cftype->seq_show to print blkg->stat_bytes.
+ * cftype->private must be set to the blkcg_policy.
+ */
+int blkg_print_stat_bytes(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
+			  offsetof(struct blkcg_gq, stat_bytes), true);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blkg_print_stat_bytes);
+
+/**
+ * blkg_print_stat_bytes - seq_show callback for blkg->stat_ios
+ * @sf: seq_file to print to
+ * @v: unused
+ *
+ * To be used as cftype->seq_show to print blkg->stat_ios.  cftype->private
+ * must be set to the blkcg_policy.
+ */
+int blkg_print_stat_ios(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  blkg_prfill_rwstat_field, (void *)seq_cft(sf)->private,
+			  offsetof(struct blkcg_gq, stat_ios), true);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blkg_print_stat_ios);
+
+static u64 blkg_prfill_rwstat_field_recursive(struct seq_file *sf,
+					      struct blkg_policy_data *pd,
+					      int off)
+{
+	struct blkg_rwstat rwstat = blkg_rwstat_recursive_sum(pd->blkg,
+							      NULL, off);
+	return __blkg_prfill_rwstat(sf, pd, &rwstat);
+}
+
+/**
+ * blkg_print_stat_bytes_recursive - recursive version of blkg_print_stat_bytes
+ * @sf: seq_file to print to
+ * @v: unused
+ */
+int blkg_print_stat_bytes_recursive(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  blkg_prfill_rwstat_field_recursive,
+			  (void *)seq_cft(sf)->private,
+			  offsetof(struct blkcg_gq, stat_bytes), true);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blkg_print_stat_bytes_recursive);
+
+/**
+ * blkg_print_stat_ios_recursive - recursive version of blkg_print_stat_ios
+ * @sf: seq_file to print to
+ * @v: unused
+ */
+int blkg_print_stat_ios_recursive(struct seq_file *sf, void *v)
+{
+	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)),
+			  blkg_prfill_rwstat_field_recursive,
+			  (void *)seq_cft(sf)->private,
+			  offsetof(struct blkcg_gq, stat_ios), true);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blkg_print_stat_ios_recursive);
+
 /**
  * blkg_stat_recursive_sum - collect hierarchical blkg_stat
  * @blkg: blkg of interest
diff --git a/block/blk-core.c b/block/blk-core.c
index a4a2dbe..c369b22 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2170,6 +2170,8 @@ void blk_account_io_completion(struct request *req, unsigned int bytes)
 		part = req->part;
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
+
+		blkcg_account_io_completion(req, bytes);
 	}
 }
 
@@ -2196,6 +2198,8 @@ void blk_account_io_done(struct request *req)
 
 		hd_struct_put(part);
 		part_stat_unlock();
+
+		blkcg_account_io_done(req);
 	}
 }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ff7b6bb..0dd7fe0 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -133,11 +133,6 @@ struct throtl_grp {
 	/* When did we start a new slice */
 	unsigned long slice_start[2];
 	unsigned long slice_end[2];
-
-	/* total bytes transferred */
-	struct blkg_rwstat		service_bytes;
-	/* total IOs serviced, post merge */
-	struct blkg_rwstat		serviced;
 };
 
 struct throtl_data
@@ -340,11 +335,7 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 
 	tg = kzalloc_node(sizeof(*tg), gfp, node);
 	if (!tg)
-		goto err;
-
-	if (blkg_rwstat_init(&tg->service_bytes, gfp) ||
-	    blkg_rwstat_init(&tg->serviced, gfp))
-		goto err_free_tg;
+		return NULL;
 
 	throtl_service_queue_init(&tg->service_queue);
 
@@ -360,13 +351,6 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 	tg->iops[WRITE] = -1;
 
 	return &tg->pd;
-
-err_free_tg:
-	blkg_rwstat_exit(&tg->serviced);
-	blkg_rwstat_exit(&tg->service_bytes);
-	kfree(tg);
-err:
-	return NULL;
 }
 
 static void throtl_pd_init(struct blkg_policy_data *pd)
@@ -424,19 +408,9 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 	struct throtl_grp *tg = pd_to_tg(pd);
 
 	del_timer_sync(&tg->service_queue.pending_timer);
-	blkg_rwstat_exit(&tg->serviced);
-	blkg_rwstat_exit(&tg->service_bytes);
 	kfree(tg);
 }
 
-static void throtl_pd_reset_stats(struct blkg_policy_data *pd)
-{
-	struct throtl_grp *tg = pd_to_tg(pd);
-
-	blkg_rwstat_reset(&tg->service_bytes);
-	blkg_rwstat_reset(&tg->serviced);
-}
-
 static struct throtl_grp *throtl_lookup_tg(struct throtl_data *td,
 					   struct blkcg *blkcg)
 {
@@ -884,25 +858,6 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	return 0;
 }
 
-static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
-					 int rw)
-{
-	struct throtl_grp *tg = blkg_to_tg(blkg);
-	unsigned long flags;
-
-	/*
-	 * Disabling interrupts to provide mutual exclusion between two
-	 * writes on same cpu. It probably is not needed for 64bit. Not
-	 * optimizing that case yet.
-	 */
-	local_irq_save(flags);
-
-	blkg_rwstat_add(&tg->serviced, rw, 1);
-	blkg_rwstat_add(&tg->service_bytes, rw, bytes);
-
-	local_irq_restore(flags);
-}
-
 static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
@@ -916,17 +871,9 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	 * more than once as a throttled bio will go through blk-throtl the
 	 * second time when it eventually gets issued.  Set it when a bio
 	 * is being charged to a tg.
-	 *
-	 * Dispatch stats aren't recursive and each @bio should only be
-	 * accounted by the @tg it was originally associated with.  Let's
-	 * update the stats when setting REQ_THROTTLED for the first time
-	 * which is guaranteed to be for the @bio's original tg.
 	 */
-	if (!(bio->bi_rw & REQ_THROTTLED)) {
+	if (!(bio->bi_rw & REQ_THROTTLED))
 		bio->bi_rw |= REQ_THROTTLED;
-		throtl_update_dispatch_stats(tg_to_blkg(tg),
-					     bio->bi_iter.bi_size, bio->bi_rw);
-	}
 }
 
 /**
@@ -1206,13 +1153,6 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 	}
 }
 
-static int tg_print_rwstat(struct seq_file *sf, void *v)
-{
-	blkcg_print_blkgs(sf, css_to_blkcg(seq_css(sf)), blkg_prfill_rwstat,
-			  &blkcg_policy_throtl, seq_cft(sf)->private, true);
-	return 0;
-}
-
 static u64 tg_prfill_conf_u64(struct seq_file *sf, struct blkg_policy_data *pd,
 			      int off)
 {
@@ -1349,13 +1289,13 @@ static struct cftype throtl_files[] = {
 	},
 	{
 		.name = "throttle.io_service_bytes",
-		.private = offsetof(struct throtl_grp, service_bytes),
-		.seq_show = tg_print_rwstat,
+		.private = (unsigned long)&blkcg_policy_throtl,
+		.seq_show = blkg_print_stat_bytes,
 	},
 	{
 		.name = "throttle.io_serviced",
-		.private = offsetof(struct throtl_grp, serviced),
-		.seq_show = tg_print_rwstat,
+		.private = (unsigned long)&blkcg_policy_throtl,
+		.seq_show = blkg_print_stat_ios,
 	},
 	{ }	/* terminate */
 };
@@ -1374,7 +1314,6 @@ static struct blkcg_policy blkcg_policy_throtl = {
 	.pd_init_fn		= throtl_pd_init,
 	.pd_online_fn		= throtl_pd_online,
 	.pd_free_fn		= throtl_pd_free,
-	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
 
 bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
@@ -1399,13 +1338,8 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	rcu_read_lock();
 	blkcg = bio_blkcg(bio);
 	tg = throtl_lookup_tg(td, blkcg);
-	if (tg) {
-		if (!tg->has_rules[rw]) {
-			throtl_update_dispatch_stats(tg_to_blkg(tg),
-					bio->bi_iter.bi_size, bio->bi_rw);
-			goto out_unlock_rcu;
-		}
-	}
+	if (tg && !tg->has_rules[rw])
+		goto out_unlock_rcu;
 
 	/*
 	 * Either group has not been allocated yet or it is not an unlimited
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 86ae2ea..a6dd941 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -172,10 +172,6 @@ enum wl_type_t {
 
 struct cfqg_stats {
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-	/* total bytes transferred */
-	struct blkg_rwstat		service_bytes;
-	/* total IOs serviced, post merge */
-	struct blkg_rwstat		serviced;
 	/* number of ios merged */
 	struct blkg_rwstat		merged;
 	/* total time spent on device in ns, may not be accurate w/ queueing */
@@ -671,8 +667,6 @@ static inline void cfqg_stats_update_dispatch(struct cfq_group *cfqg,
 					      uint64_t bytes, int rw)
 {
 	blkg_stat_add(&cfqg->stats.sectors, bytes >> 9);
-	blkg_rwstat_add(&cfqg->stats.serviced, rw, 1);
-	blkg_rwstat_add(&cfqg->stats.service_bytes, rw, bytes);
 }
 
 static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
@@ -692,8 +686,6 @@ static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 static void cfqg_stats_reset(struct cfqg_stats *stats)
 {
 	/* queued stats shouldn't be cleared */
-	blkg_rwstat_reset(&stats->service_bytes);
-	blkg_rwstat_reset(&stats->serviced);
 	blkg_rwstat_reset(&stats->merged);
 	blkg_rwstat_reset(&stats->service_time);
 	blkg_rwstat_reset(&stats->wait_time);
@@ -713,8 +705,6 @@ static void cfqg_stats_reset(struct cfqg_stats *stats)
 static void cfqg_stats_add_aux(struct cfqg_stats *to, struct cfqg_stats *from)
 {
 	/* queued stats shouldn't be cleared */
-	blkg_rwstat_add_aux(&to->service_bytes, &from->service_bytes);
-	blkg_rwstat_add_aux(&to->serviced, &from->serviced);
 	blkg_rwstat_add_aux(&to->merged, &from->merged);
 	blkg_rwstat_add_aux(&to->service_time, &from->service_time);
 	blkg_rwstat_add_aux(&to->wait_time, &from->wait_time);
@@ -1519,8 +1509,6 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static void cfqg_stats_exit(struct cfqg_stats *stats)
 {
-	blkg_rwstat_exit(&stats->service_bytes);
-	blkg_rwstat_exit(&stats->serviced);
 	blkg_rwstat_exit(&stats->merged);
 	blkg_rwstat_exit(&stats->service_time);
 	blkg_rwstat_exit(&stats->wait_time);
@@ -1541,9 +1529,7 @@ static void cfqg_stats_exit(struct cfqg_stats *stats)
 
 static int cfqg_stats_init(struct cfqg_stats *stats, gfp_t gfp)
 {
-	if (blkg_rwstat_init(&stats->service_bytes, gfp) ||
-	    blkg_rwstat_init(&stats->serviced, gfp) ||
-	    blkg_rwstat_init(&stats->merged, gfp) ||
+	if (blkg_rwstat_init(&stats->merged, gfp) ||
 	    blkg_rwstat_init(&stats->service_time, gfp) ||
 	    blkg_rwstat_init(&stats->wait_time, gfp) ||
 	    blkg_rwstat_init(&stats->queued, gfp) ||
@@ -1926,13 +1912,13 @@ static struct cftype cfq_blkcg_files[] = {
 	},
 	{
 		.name = "io_service_bytes",
-		.private = offsetof(struct cfq_group, stats.service_bytes),
-		.seq_show = cfqg_print_rwstat,
+		.private = (unsigned long)&blkcg_policy_cfq,
+		.seq_show = blkg_print_stat_bytes,
 	},
 	{
 		.name = "io_serviced",
-		.private = offsetof(struct cfq_group, stats.serviced),
-		.seq_show = cfqg_print_rwstat,
+		.private = (unsigned long)&blkcg_policy_cfq,
+		.seq_show = blkg_print_stat_ios,
 	},
 	{
 		.name = "io_service_time",
@@ -1968,13 +1954,13 @@ static struct cftype cfq_blkcg_files[] = {
 	},
 	{
 		.name = "io_service_bytes_recursive",
-		.private = offsetof(struct cfq_group, stats.service_bytes),
-		.seq_show = cfqg_print_rwstat_recursive,
+		.private = (unsigned long)&blkcg_policy_cfq,
+		.seq_show = blkg_print_stat_bytes_recursive,
 	},
 	{
 		.name = "io_serviced_recursive",
-		.private = offsetof(struct cfq_group, stats.serviced),
-		.seq_show = cfqg_print_rwstat_recursive,
+		.private = (unsigned long)&blkcg_policy_cfq,
+		.seq_show = blkg_print_stat_ios_recursive,
 	},
 	{
 		.name = "io_service_time_recursive",
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 67eeb27..115cc90 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -123,6 +123,9 @@ struct blkcg_gq {
 	/* is this blkg online? protected by both blkcg and q locks */
 	bool				online;
 
+	struct blkg_rwstat		stat_bytes;
+	struct blkg_rwstat		stat_ios;
+
 	struct blkg_policy_data		*pd[BLKCG_MAX_POLS];
 
 	struct rcu_head			rcu_head;
@@ -178,6 +181,10 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 u64 blkg_prfill_stat(struct seq_file *sf, struct blkg_policy_data *pd, int off);
 u64 blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
 		       int off);
+int blkg_print_stat_bytes(struct seq_file *sf, void *v);
+int blkg_print_stat_ios(struct seq_file *sf, void *v);
+int blkg_print_stat_bytes_recursive(struct seq_file *sf, void *v);
+int blkg_print_stat_ios_recursive(struct seq_file *sf, void *v);
 
 u64 blkg_stat_recursive_sum(struct blkcg_gq *blkg,
 			    struct blkcg_policy *pol, int off);
@@ -605,6 +612,23 @@ static inline void blkg_rwstat_add_aux(struct blkg_rwstat *to,
 			     &to->aux_cnt[i]);
 }
 
+static inline void blkcg_account_io_completion(struct request *rq,
+					       unsigned int bytes)
+{
+	struct request_list *rl = blk_rq_rl(rq);
+	struct blkcg_gq *blkg = rl ? rl->blkg : rq->q->root_blkg;
+
+	blkg_rwstat_add(&blkg->stat_bytes, rq->cmd_flags, bytes);
+}
+
+static inline void blkcg_account_io_done(struct request *rq)
+{
+	struct request_list *rl = blk_rq_rl(rq);
+	struct blkcg_gq *blkg = rl ? rl->blkg : rq->q->root_blkg;
+
+	blkg_rwstat_add(&blkg->stat_ios, rq->cmd_flags, 1);
+}
+
 #else	/* CONFIG_BLK_CGROUP */
 
 struct blkcg {
@@ -654,6 +678,8 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 static inline void blk_put_rl(struct request_list *rl) { }
 static inline void blk_rq_set_rl(struct request *rq, struct request_list *rl) { }
 static inline struct request_list *blk_rq_rl(struct request *rq) { return &rq->q->root_rl; }
+static inline void blkcg_account_io_completion(struct request *rq, unsigned int bytes) { }
+static inline void blkcg_account_io_done(struct request *rq) { }
 
 #define blk_queue_for_each_rl(rl, q)	\
 	for ((rl) = &(q)->root_rl; (rl); (rl) = NULL)
-- 
2.4.3
