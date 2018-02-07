From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2] blk-throttle: fix race between blkcg_bio_issue_check and
 cgroup_rmdir
Date: Wed, 7 Feb 2018 16:40:02 +0800
Message-ID: <6f136c90-faa9-4bc0-b02f-3a112b4d8360@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: xuejiufei <jiufei.xue@linux.alibaba.com>, Caspar Zhang <caspar@linux.alibaba.com>, linux-block <linux-block@vger.kernel.org>, cgroups@vger.kernel.org

We've triggered a WARNING in blk_throtl_bio when throttling writeback
io, which complains blkg->refcnt is already 0 when calling blkg_get, and
then kernel crashes with invalid page request.
After investigating this issue, we've found there is a race between
blkcg_bio_issue_check and cgroup_rmdir. The race is described below.

writeback kworker
  blkcg_bio_issue_check
    rcu_read_lock
    blkg_lookup
    <<< *race window*
    blk_throtl_bio
      spin_lock_irq(q->queue_lock)
      spin_unlock_irq(q->queue_lock)
    rcu_read_unlock

cgroup_rmdir
  cgroup_destroy_locked
    kill_css
      css_killed_ref_fn
        css_killed_work_fn
          offline_css
            blkcg_css_offline
              spin_trylock(q->queue_lock)
              blkg_destroy
              spin_unlock(q->queue_lock)

Since rcu can only prevent blkg from releasing when it is being used,
the blkg->refcnt can be decreased to 0 during blkg_destroy and schedule
blkg release.
Then trying to blkg_get in blk_throtl_bio will complains the WARNING.
And then the corresponding blkg_put will schedule blkg release again,
which result in double free.
This race is introduced by commit ae1188963611 ("blkcg: consolidate blkg
creation in blkcg_bio_issue_check()"). Before this commit, it will lookup
first and then try to lookup/create again with queue_lock. So revive
this logic to fix the race.

v2: fix a potential NULL pointer dereference when stats

Fixes: ae1188963611 ("blkcg: consolidate blkg creation in blkcg_bio_issue_check()")
Reported-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: stable@vger.kernel.org
---
 block/blk-cgroup.c         |  2 +-
 block/blk-throttle.c       | 30 ++++++++++++++++++++++++++----
 block/cfq-iosched.c        | 33 +++++++++++++++++++++++----------
 include/linux/blk-cgroup.h | 27 +++++----------------------
 4 files changed, 55 insertions(+), 37 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4117524..b1d22e5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -162,7 +162,6 @@ struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
 
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(blkg_lookup_slowpath);
 
 /*
  * If @new_blkg is %NULL, this function tries to allocate a new one as
@@ -306,6 +305,7 @@ struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 			return blkg;
 	}
 }
+EXPORT_SYMBOL_GPL(blkg_lookup_create);
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c5a1316..decdd76 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2143,26 +2143,41 @@ static void blk_throtl_assoc_bio(struct throtl_grp *tg, struct bio *bio)
 #endif
 }
 
-bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
+bool blk_throtl_bio(struct request_queue *q, struct blkcg *blkcg,
 		    struct bio *bio)
 {
+	struct throtl_data *td = q->td;
 	struct throtl_qnode *qn = NULL;
-	struct throtl_grp *tg = blkg_to_tg(blkg ?: q->root_blkg);
+	struct throtl_grp *tg;
+	struct blkcg_gq *blkg;
 	struct throtl_service_queue *sq;
 	bool rw = bio_data_dir(bio);
 	bool throttled = false;
-	struct throtl_data *td = tg->td;
 
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
+	/*
+	 * If a group has no rules, just update the dispatch stats in lockless
+	 * manner and return.
+	 */
+	blkg = blkg_lookup(blkcg, q);
+	tg = blkg_to_tg(blkg);
+	if (tg && !tg->has_rules[rw])
+		goto out;
+
 	/* see throtl_charge_bio() */
-	if (bio_flagged(bio, BIO_THROTTLED) || !tg->has_rules[rw])
+	if (bio_flagged(bio, BIO_THROTTLED))
 		goto out;
 
 	spin_lock_irq(q->queue_lock);
 
 	throtl_update_latency_buckets(td);
 
+	blkg = blkg_lookup_create(blkcg, q);
+	if (IS_ERR(blkg))
+		blkg = q->root_blkg;
+	tg = blkg_to_tg(blkg);
+
 	if (unlikely(blk_queue_bypass(q)))
 		goto out_unlock;
 
@@ -2253,6 +2268,13 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 	if (throttled || !td->track_bio_latency)
 		bio->bi_issue_stat.stat |= SKIP_LATENCY;
 #endif
+	if (!throttled) {
+		blkg = blkg ?: q->root_blkg;
+		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_opf,
+				bio->bi_iter.bi_size);
+		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
+	}
+
 	return throttled;
 }
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9f342ef..60f53b5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1674,15 +1674,28 @@ static void cfq_pd_reset_stats(struct blkg_policy_data *pd)
 	cfqg_stats_reset(&cfqg->stats);
 }
 
-static struct cfq_group *cfq_lookup_cfqg(struct cfq_data *cfqd,
-					 struct blkcg *blkcg)
+/*
+ * Search for the cfq group current task belongs to. request_queue lock must
+ * be held.
+ */
+static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
+						struct blkcg *blkcg)
 {
-	struct blkcg_gq *blkg;
+	struct request_queue *q = cfqd->queue;
+	struct cfq_group *cfqg = NULL;
 
-	blkg = blkg_lookup(blkcg, cfqd->queue);
-	if (likely(blkg))
-		return blkg_to_cfqg(blkg);
-	return NULL;
+	/* avoid lookup for the common case where there's no blkcg */
+	if (blkcg == &blkcg_root) {
+		cfqg = cfqd->root_group;
+	} else {
+		struct blkcg_gq *blkg;
+
+		blkg = blkg_lookup_create(blkcg, q);
+		if (!IS_ERR(blkg))
+			cfqg = blkg_to_cfqg(blkg);
+	}
+
+	return cfqg;
 }
 
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
@@ -2178,8 +2191,8 @@ static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
 };
 
 #else /* GROUP_IOSCHED */
-static struct cfq_group *cfq_lookup_cfqg(struct cfq_data *cfqd,
-					 struct blkcg *blkcg)
+static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
+						struct blkcg *blkcg)
 {
 	return cfqd->root_group;
 }
@@ -3814,7 +3827,7 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 	struct cfq_group *cfqg;
 
 	rcu_read_lock();
-	cfqg = cfq_lookup_cfqg(cfqd, bio_blkcg(bio));
+	cfqg = cfq_lookup_create_cfqg(cfqd, bio_blkcg(bio));
 	if (!cfqg) {
 		cfqq = &cfqd->oom_cfqq;
 		goto out;
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 69bea82..e667841 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -428,8 +428,8 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 	 * or if either the blkcg or queue is going away.  Fall back to
 	 * root_rl in such cases.
 	 */
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(!blkg))
+	blkg = blkg_lookup_create(blkcg, q);
+	if (unlikely(IS_ERR(blkg)))
 		goto root_rl;
 
 	blkg_get(blkg);
@@ -672,10 +672,10 @@ static inline void blkg_rwstat_add_aux(struct blkg_rwstat *to,
 }
 
 #ifdef CONFIG_BLK_DEV_THROTTLING
-extern bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
+extern bool blk_throtl_bio(struct request_queue *q, struct blkcg *blkcg,
 			   struct bio *bio);
 #else
-static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
+static inline bool blk_throtl_bio(struct request_queue *q, struct blkcg *blkcg,
 				  struct bio *bio) { return false; }
 #endif
 
@@ -683,7 +683,6 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 					 struct bio *bio)
 {
 	struct blkcg *blkcg;
-	struct blkcg_gq *blkg;
 	bool throtl = false;
 
 	rcu_read_lock();
@@ -692,23 +691,7 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	/* associate blkcg if bio hasn't attached one */
 	bio_associate_blkcg(bio, &blkcg->css);
 
-	blkg = blkg_lookup(blkcg, q);
-	if (unlikely(!blkg)) {
-		spin_lock_irq(q->queue_lock);
-		blkg = blkg_lookup_create(blkcg, q);
-		if (IS_ERR(blkg))
-			blkg = NULL;
-		spin_unlock_irq(q->queue_lock);
-	}
-
-	throtl = blk_throtl_bio(q, blkg, bio);
-
-	if (!throtl) {
-		blkg = blkg ?: q->root_blkg;
-		blkg_rwstat_add(&blkg->stat_bytes, bio->bi_opf,
-				bio->bi_iter.bi_size);
-		blkg_rwstat_add(&blkg->stat_ios, bio->bi_opf, 1);
-	}
+	throtl = blk_throtl_bio(q, blkcg, bio);
 
 	rcu_read_unlock();
 	return !throtl;
-- 
1.9.4
