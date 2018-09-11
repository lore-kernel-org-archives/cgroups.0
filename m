From: Dennis Zhou <dennisszhou@gmail.com>
Subject: [PATCH 01/12] blkcg: fix ref count issue with bio_blkcg using task_css
Date: Tue, 11 Sep 2018 14:41:26 -0400
Message-ID: <20180911184137.35897-2-dennisszhou@gmail.com>
References: <20180911184137.35897-1-dennisszhou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TOgagscrlT9jC7QBTZg6gKdyqWBEv1N3Mq6bLuVx1Cc=;
        b=tOANTxBN2ph6yUNSyope2AvZccq5ScvmJBZ4f0VSOirYQkPxnNWaSnmx9+Y2gQUYpm
         qqnDOgjPQ2iukgzQbH0Q8WcpTi0HLh+F/LIq7fVgh4LX56CK8X7YheFARVo7HA7vqW2g
         fjUlZr9cqBzd5t7Vs9c0G9Lxq9CqQ3jNTWFy64wM3ZBr20hqdfzwoevv2w5V+/FWVACS
         IrZ7Xnt6dt3iEhqc+6KtcSqMa4RzgNO8uCRGnjHcULc7wLSjDVDVzqXXk26Par/SHwVi
         HGToZr2BKyzBBI0aD8kGjkOnrgPqRAeTyq4LeSjGqrUXEbHkteTbtG0UwmvhajW7YINE
         c+/g==
In-Reply-To: <20180911184137.35897-1-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

The accessor function bio_blkcg either returns the blkcg associated with
the bio or finds one in the current context. This can cause an issue
when trying to associate a bio with a blkcg. Particularly, it's the
third case that is problematic:

	return css_to_blkcg(task_css(current, io_cgrp_id));

As the above may race against task migration and the cgroup exiting, it
is not always ok to take a reference on the blkcg returned from
bio_blkcg.

This patch adds association ahead of calling bio_blkcg rather than
after. This makes association a required and explicit step along the
code paths for calling bio_blkcg. blk_get_rl is modified as well to get
a reference to the blkcg it may use and blk_put_rl will always put the
reference back. Association is also moved above the bio_blkcg call to
ensure it will not return NULL in blk-iolatency.

BFQ and CFQ utilize this flaw, but due to the complexity, I do not want
to address this in this series. I've created a private version of the
function with notes not to use it describing the flaw. Hopefully soon,
that code can be cleaned up.

Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/bfq-cgroup.c         |   4 +-
 block/bfq-iosched.c        |   2 +-
 block/bio.c                |  10 +++-
 block/blk-iolatency.c      |   2 +-
 block/cfq-iosched.c        |   4 +-
 include/linux/blk-cgroup.h | 101 ++++++++++++++++++++++++++++++++++---
 6 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 9fe5952d117d..d9a7916ff0ab 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -642,7 +642,7 @@ void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
 	uint64_t serial_nr;
 
 	rcu_read_lock();
-	serial_nr = bio_blkcg(bio)->css.serial_nr;
+	serial_nr = __bio_blkcg(bio)->css.serial_nr;
 
 	/*
 	 * Check whether blkcg has changed.  The condition may trigger
@@ -651,7 +651,7 @@ void bfq_bic_update_cgroup(struct bfq_io_cq *bic, struct bio *bio)
 	if (unlikely(!bfqd) || likely(bic->blkcg_serial_nr == serial_nr))
 		goto out;
 
-	bfqg = __bfq_bic_change_cgroup(bfqd, bic, bio_blkcg(bio));
+	bfqg = __bfq_bic_change_cgroup(bfqd, bic, __bio_blkcg(bio));
 	/*
 	 * Update blkg_path for bfq_log_* functions. We cache this
 	 * path, and update it here, for the following
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 653100fb719e..6647355c901c 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -4297,7 +4297,7 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 
 	rcu_read_lock();
 
-	bfqg = bfq_find_set_group(bfqd, bio_blkcg(bio));
+	bfqg = bfq_find_set_group(bfqd, __bio_blkcg(bio));
 	if (!bfqg) {
 		bfqq = &bfqd->oom_bfqq;
 		goto out;
diff --git a/block/bio.c b/block/bio.c
index f685e762809d..6ca4dda481ca 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1989,13 +1989,19 @@ int bio_associate_blkcg_from_page(struct bio *bio, struct page *page)
  *
  * This function takes an extra reference of @blkcg_css which will be put
  * when @bio is released.  The caller must own @bio and is responsible for
- * synchronizing calls to this function.
+ * synchronizing calls to this function.  If @blkcg_css is NULL, a call to
+ * blkcg_get_css finds the current css from the kthread or task.
  */
 int bio_associate_blkcg(struct bio *bio, struct cgroup_subsys_state *blkcg_css)
 {
 	if (unlikely(bio->bi_css))
 		return -EBUSY;
-	css_get(blkcg_css);
+
+	if (blkcg_css)
+		css_get(blkcg_css);
+	else
+		blkcg_css = blkcg_get_css();
+
 	bio->bi_css = blkcg_css;
 	return 0;
 }
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 19923f8a029d..62fdd9002c29 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -404,8 +404,8 @@ static void blkcg_iolatency_throttle(struct rq_qos *rqos, struct bio *bio,
 		return;
 
 	rcu_read_lock();
+	bio_associate_blkcg(bio, NULL);
 	blkcg = bio_blkcg(bio);
-	bio_associate_blkcg(bio, &blkcg->css);
 	blkg = blkg_lookup(blkcg, q);
 	if (unlikely(!blkg)) {
 		if (!lock)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 2eb87444b157..d219e9a1af65 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3753,7 +3753,7 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 	uint64_t serial_nr;
 
 	rcu_read_lock();
-	serial_nr = bio_blkcg(bio)->css.serial_nr;
+	serial_nr = __bio_blkcg(bio)->css.serial_nr;
 	rcu_read_unlock();
 
 	/*
@@ -3818,7 +3818,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	struct cfq_group *cfqg;
 
 	rcu_read_lock();
-	cfqg = cfq_lookup_cfqg(cfqd, bio_blkcg(bio));
+	cfqg = cfq_lookup_cfqg(cfqd, __bio_blkcg(bio));
 	if (!cfqg) {
 		cfqq = &cfqd->oom_cfqq;
 		goto out;
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 6d766a19f2bb..24067a1f8b36 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -230,22 +230,100 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   char *input, struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
 
+/**
+ * blkcg_css - find the current css
+ *
+ * Find the css associated with either the kthread or the current task.
+ * This may return a dying css, so it is up to the caller to use tryget logic
+ * to confirm it is alive and well.
+ */
+static inline struct cgroup_subsys_state *blkcg_css(void)
+{
+	struct cgroup_subsys_state *css;
+
+	css = kthread_blkcg();
+	if (css)
+		return css;
+	return task_css(current, io_cgrp_id);
+}
+
+/**
+ * blkcg_get_css - find and get a reference to the css
+ *
+ * Find the css associated with either the kthread or the current task.
+ * This takes a reference on the blkcg which will need to be managed by the
+ * caller.
+ */
+static inline struct cgroup_subsys_state *blkcg_get_css(void)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+
+	css = kthread_blkcg();
+	if (css) {
+		css_get(css);
+	} else {
+		/*
+		 * This is a bit complicated.  It is possible task_css is seeing
+		 * an old css pointer here.  This is caused by the current
+		 * thread migrating away from this cgroup and this cgroup dying.
+		 * css_tryget() will fail when trying to take a ref on a cgroup
+		 * that's ref count has hit 0.
+		 *
+		 * Therefore, if it does fail, this means current must have
+		 * been swapped away already and this is waiting for it to
+		 * propagate on the polling cpu.  Hence the use of cpu_relax().
+		 */
+		while (true) {
+			css = task_css(current, io_cgrp_id);
+			if (likely(css_tryget(css)))
+				break;
+			cpu_relax();
+		}
+	}
+
+	rcu_read_unlock();
+
+	return css;
+}
 
 static inline struct blkcg *css_to_blkcg(struct cgroup_subsys_state *css)
 {
 	return css ? container_of(css, struct blkcg, css) : NULL;
 }
 
-static inline struct blkcg *bio_blkcg(struct bio *bio)
+/**
+ * __bio_blkcg - internal version of bio_blkcg for bfq and cfq
+ *
+ * DO NOT USE.
+ * There is a flaw using this version of the function.  In particular, this was
+ * used in a broken paradigm where association was called on the given css.  It
+ * is possible though that the returned css from task_css() is in the process
+ * of dying due to migration of the current task.  So it is improper to assume
+ * *_get() is going to succeed.  Both BFQ and CFQ rely on this logic and will
+ * take additional work to handle more gracefully.
+ */
+static inline struct blkcg *__bio_blkcg(struct bio *bio)
 {
-	struct cgroup_subsys_state *css;
+	if (bio && bio->bi_css)
+		return css_to_blkcg(bio->bi_css);
+	return css_to_blkcg(blkcg_css());
+}
 
+/**
+ * bio_blkcg - grab the blkcg associated with a bio
+ * @bio: target bio
+ *
+ * This returns the blkcg associated with a bio, NULL if not associated.
+ * Callers are expected to either handle NULL or know association has been
+ * done prior to calling this.
+ */
+static inline struct blkcg *bio_blkcg(struct bio *bio)
+{
 	if (bio && bio->bi_css)
 		return css_to_blkcg(bio->bi_css);
-	css = kthread_blkcg();
-	if (css)
-		return css_to_blkcg(css);
-	return css_to_blkcg(task_css(current, io_cgrp_id));
+	return NULL;
 }
 
 static inline bool blk_cgroup_congested(void)
@@ -534,6 +612,10 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
 	rcu_read_lock();
 
 	blkcg = bio_blkcg(bio);
+	if (blkcg)
+		css_get(&blkcg->css);
+	else
+		blkcg = css_to_blkcg(blkcg_get_css());
 
 	/* bypass blkg lookup and use @q->root_rl directly for root */
 	if (blkcg == &blkcg_root)
@@ -565,6 +647,8 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
  */
 static inline void blk_put_rl(struct request_list *rl)
 {
+	/* an additional ref is always taken for rl */
+	css_put(&rl->blkg->blkcg->css);
 	if (rl->blkg->blkcg != &blkcg_root)
 		blkg_put(rl->blkg);
 }
@@ -805,10 +889,10 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	bool throtl = false;
 
 	rcu_read_lock();
-	blkcg = bio_blkcg(bio);
 
 	/* associate blkcg if bio hasn't attached one */
-	bio_associate_blkcg(bio, &blkcg->css);
+	bio_associate_blkcg(bio, NULL);
+	blkcg = bio_blkcg(bio);
 
 	blkg = blkg_lookup(blkcg, q);
 	if (unlikely(!blkg)) {
@@ -930,6 +1014,7 @@ static inline int blkcg_activate_policy(struct request_queue *q,
 static inline void blkcg_deactivate_policy(struct request_queue *q,
 					   const struct blkcg_policy *pol) { }
 
+static inline struct blkcg *__bio_blkcg(struct bio *bio) { return NULL; }
 static inline struct blkcg *bio_blkcg(struct bio *bio) { return NULL; }
 
 static inline struct blkg_policy_data *blkg_to_pd(struct blkcg_gq *blkg,
-- 
2.17.1

