Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DF825C804;
	Sun, 23 Aug 2026 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787499004; cv=none; b=cdxeOaByJZyTtoSWp5sZ9e6l1nnLg/7mIvtS/00Y+PgvbgmHbpoecyNYEKI+LaMSJOVZUgjFOhAaa7CvC1AohfofO7WuaTvrZc1nN9usuIcoKn17mrPBg/bR4v7nmbw4aIh2CFmY+jVkKQwXU8ZUee/3crXLaCrL8aksq8QvpLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787499004; c=relaxed/simple;
	bh=cXMMhSiywBOMMr7eQqERnj5XwBgqPgSFkFehkaXMIr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agffq8cAKwwn5Jn0qVLqwM3RW3YT28Jzi0OSq/h98tnMQBeO5o4lEFD09hTEifUfsGIFcRiAOgH1WpUtaoyAVS7KOt3NZbpsqqCkrQfi+LrzmXz58AzmGoe2lLa2Hi6Bc6+oyDjTMGSiLeD8i5ysTmM6uC7AFUfJyNbOtKS3Qi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuVQZf7v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuVQZf7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F241F00A3A;
	Sun, 23 Aug 2026 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787498998;
	bh=hyG3XfLInuMHvbuGa7WkSBQFReMcSCRzPSASGqxw0Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VuVQZf7vq7nZ05LTJMmvItO8e2X/OEeptkuXIqX7glTOVvStT0ewu7SZAsBA3P0e/
	 hAFrtBBVRHSAEooMqAmXC4pZovq0cNq0XWgfXEPIQrhmbFRYDePpppSrS2FOBukKAT
	 C2qFSQFy+3o6rtKnVoNHuNnlDmCq8aZWtLlT7JL5TkgAA2/wbF4HZME4clk/xbGxDM
	 AgX5DNFw63pl4MMp3PSJnpxEHLzQseJYyHR5pX1w3gAEDxhJKiWMcJZkr4HYoDMa3/
	 XFjL7ES+Vq4DFd2t+JIowcUMwsY1m3RSuftTMue+NQbXDaXQJp46CI4FS6ntzRnWDg
	 5Wk+DLCOBTzCw==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
	Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 3/6] blk-cgroup: protect blkgs with blkcg_mutex
Date: Sun, 23 Aug 2026 23:29:22 +0800
Message-ID: <20260823152926.1043863-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260823152926.1043863-1-yukuai@kernel.org>
References: <20260823152926.1043863-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

queue_lock is still needed by block core users, but blkcg no longer
needs it for blkg topology now that throttle runtime state has a private
lock.

Move queue-local blkg topology synchronization to q->blkcg_mutex. Hold
it while creating and destroying blkgs, while preparing and undoing
configuration, and while activating or deactivating policies.

Keep the common bio_blkg() lookup on an RCU fast path so I/O for an
existing blkg does not acquire blkcg_mutex. Only take the mutex when the
blkg hierarchy needs to be created.

Update the BFQ, iocost, iolatency and throttle paths which walk
q->blkg_list or access per-blkg policy state to use the same lock.

blkcg->lock still protects blkcg-local list updates. Some lookups under
blkcg_mutex can race with blkcg updates done for other queues, so keep
those lookups in RCU read-side critical sections. In particular, protect
the parent lookup in blkg_create() and the parent walk in
blkg_lookup_create().

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c    |  10 ++-
 block/blk-cgroup.c    | 153 +++++++++++++++++-------------------------
 block/blk-cgroup.h    |  11 ++-
 block/blk-iocost.c    |   8 ++-
 block/blk-iolatency.c |   7 +-
 block/blk-throttle.c  |  10 +--
 6 files changed, 87 insertions(+), 112 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 4a3975f9ff74..d64cea475d7b 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -426,11 +426,11 @@ static void bfqg_stats_xfer_dead(struct bfq_group *bfqg)
 	if (!bfqg) /* root_group */
 		return;
 
 	parent = bfqg_parent(bfqg);
 
-	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->queue_lock);
+	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->blkcg_mutex);
 
 	if (unlikely(!parent))
 		return;
 
 	bfqg_stats_add_aux(&parent->stats, &bfqg->stats);
@@ -876,11 +876,11 @@ static void bfq_reparent_active_queues(struct bfq_data *bfqd,
 /**
  * bfq_pd_offline - deactivate the entity associated with @pd,
  *		    and reparent its children entities.
  * @pd: descriptor of the policy going offline.
  *
- * blkio already grabs the queue_lock for us, so no need to use
+ * blkio already grabs the blkcg_mutex for us, so no need to use
  * RCU-based magic
  */
 static void bfq_pd_offline(struct blkg_policy_data *pd)
 {
 	struct bfq_service_tree *st;
@@ -949,22 +949,20 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 {
 	struct request_queue *q = bfqd->queue;
 	struct blkcg_gq *blkg;
 
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
-	spin_lock(&bfqd->lock);
+	spin_lock_irq(&bfqd->lock);
 
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct bfq_group *bfqg = blkg_to_bfqg(blkg);
 
 		bfq_end_wr_async_queues(bfqd, bfqg);
 	}
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 
-	spin_unlock(&bfqd->lock);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&bfqd->lock);
 	mutex_unlock(&q->blkcg_mutex);
 }
 
 static int bfq_io_show_weight_legacy(struct seq_file *sf, void *v)
 {
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5b51be2fefc1..0f34a80a726d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -62,12 +62,10 @@ static LIST_HEAD(all_blkcgs);		/* protected by blkcg_pol_mutex */
 
 bool blkcg_debug_stats = false;
 
 static DEFINE_RAW_SPINLOCK(blkg_stat_lock);
 
-#define BLKG_DESTROY_BATCH_SIZE  64
-
 const struct rhashtable_params blkg_hash_params = {
 	.key_len		= sizeof_field(struct blkcg_gq, blkcg_id),
 	.key_offset		= offsetof(struct blkcg_gq, blkcg_id),
 	.head_offset		= offsetof(struct blkcg_gq, q_hash_node),
 	.automatic_shrinking	= true,
@@ -139,15 +137,13 @@ static void blkg_free_workfn(struct work_struct *work)
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
-	spin_lock_irq(&q->queue_lock);
 	list_del_init(&blkg->q_node);
 	if (list_empty(&q->blkg_list))
 		wake_up_var(&q->blkg_list);
-	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 
 	/*
 	 * Release blkcg css ref only after blkg is removed from q->blkg_list,
 	 * so concurrent iterators won't see a blkg with a freed blkcg.
@@ -397,11 +393,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 				    struct blkcg_gq *new_blkg)
 {
 	struct blkcg_gq *blkg;
 	int i, ret;
 
-	lockdep_assert_held(&disk->queue->queue_lock);
+	lockdep_assert_held(&disk->queue->blkcg_mutex);
 
 	/* request_queue is dying, do not create/recreate a blkg */
 	if (blk_queue_dying(disk->queue)) {
 		ret = -ENODEV;
 		goto err_free_blkg;
@@ -417,16 +413,19 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	}
 	blkg = new_blkg;
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
+		rcu_read_lock();
 		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk->queue);
 		if (WARN_ON_ONCE(!blkg->parent)) {
+			rcu_read_unlock();
 			ret = -ENODEV;
 			goto err_free_blkg;
 		}
 		blkg_get(blkg->parent);
+		rcu_read_unlock();
 	}
 
 	/* invoke per-policy init */
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -434,11 +433,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 		if (blkg->pd[i] && pol->pd_init_fn)
 			pol->pd_init_fn(blkg->pd[i]);
 	}
 
 	/* insert */
-	spin_lock(&blkcg->lock);
+	spin_lock_irq(&blkcg->lock);
 	ret = rhashtable_insert_fast(&disk->queue->blkg_hash,
 				     &blkg->q_hash_node, blkg_hash_params);
 	if (likely(!ret)) {
 		hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
 		list_add(&blkg->q_node, &disk->queue->blkg_list);
@@ -452,11 +451,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 				blkg->pd[i]->online = true;
 			}
 		}
 		blkg->online = true;
 	}
-	spin_unlock(&blkcg->lock);
+	spin_unlock_irq(&blkcg->lock);
 
 	if (!ret)
 		return blkg;
 
 	/* @blkg failed fully initialized, use the usual release path */
@@ -485,13 +484,12 @@ static struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
  * @blkcg: blkcg of interest
  * @disk: gendisk of interest
  *
  * Lookup blkg for the @blkcg - @disk pair.  If it doesn't exist, try to
  * create one.  blkg creation is performed recursively from blkcg_root such
- * that all non-root blkg's have access to the parent blkg.
- *
- * Must be called with @disk->queue->queue_lock held.
+ * that all non-root blkg's have access to the parent blkg.  This function
+ * must be called with @disk->queue->blkcg_mutex held.
  *
  * Returns the closest blkg with an extra reference acquired.  If
  * blkg_create() fails while walking down from root, the returned blkg may
  * belong to an ancestor of @blkcg.  This function never returns %NULL.
  */
@@ -499,11 +497,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
 
-	lockdep_assert_held(&q->queue_lock);
+	lockdep_assert_held(&q->blkcg_mutex);
 
 	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
 		blkg = blkg_lookup_tryget(blkg);
@@ -520,20 +518,22 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 	while (true) {
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent = blkcg_parent(blkcg);
 		struct blkcg_gq *ret_blkg = q->root_blkg;
 
+		rcu_read_lock();
 		while (parent) {
 			blkg = blkg_lookup(parent, q);
 			if (blkg) {
 				/* remember closest blkg */
 				ret_blkg = blkg;
 				break;
 			}
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
+		rcu_read_unlock();
 
 		blkg = blkg_create(pos, disk, NULL);
 		if (IS_ERR(blkg)) {
 			blkg = ret_blkg;
 			break;
@@ -548,11 +548,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
 	struct blkcg *blkcg = blkg->blkcg;
 	int i;
 
-	lockdep_assert_held(&blkg->q->queue_lock);
+	lockdep_assert_held(&blkg->q->blkcg_mutex);
 	lockdep_assert_held(&blkcg->lock);
 
 	/*
 	 * blkg stays on the queue list until blkg_free_workfn(), see details in
 	 * blkg_free_workfn(), hence this function can be called from
@@ -585,37 +585,22 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 
 static void blkg_destroy_all(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
-	int count = BLKG_DESTROY_BATCH_SIZE;
 	int i;
 
-restart:
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
 
 		if (hlist_unhashed(&blkg->blkcg_node))
 			continue;
 
-		spin_lock(&blkcg->lock);
+		spin_lock_irq(&blkcg->lock);
 		blkg_destroy(blkg);
-		spin_unlock(&blkcg->lock);
-
-		/*
-		 * in order to avoid holding the spin lock for too long, release
-		 * it when a batch of blkgs are destroyed.
-		 */
-		if (!(--count)) {
-			count = BLKG_DESTROY_BATCH_SIZE;
-			spin_unlock_irq(&q->queue_lock);
-			mutex_unlock(&q->blkcg_mutex);
-			cond_resched();
-			goto restart;
-		}
+		spin_unlock_irq(&blkcg->lock);
 	}
 
 	/*
 	 * Mark policy deactivated since policy offline has been done, and
 	 * the free is scheduled, so future blkcg_deactivate_policy() can
@@ -627,11 +612,10 @@ static void blkg_destroy_all(struct gendisk *disk)
 		if (pol)
 			__clear_bit(pol->plid, q->blkcg_pols);
 	}
 
 	q->root_blkg = NULL;
-	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 }
 
 static void blkg_iostat_set(struct blkg_iostat *dst, struct blkg_iostat *src)
 {
@@ -843,12 +827,12 @@ EXPORT_SYMBOL_GPL(blkg_conf_open_bdev);
  * accordingly. On success, @ctx->body points to the part of @ctx->input
  * following MAJ:MIN, @ctx->bdev points to the target block device and
  * @ctx->blkg to the blkg being configured.
  *
  * blkg_conf_open_bdev() must be called on @ctx beforehand. On success, this
- * function returns with queue lock held and must be followed by
- * blkg_conf_close_bdev().
+ * function returns with blkcg_mutex held and must be followed by
+ * blkg_conf_unprep().
  */
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   struct blkg_conf_ctx *ctx)
 {
 	struct gendisk *disk;
@@ -862,18 +846,19 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	disk = ctx->bdev->bd_disk;
 	q = disk->queue;
 
 	/* Prevent concurrent with blkcg_deactivate_policy() */
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
 
 	if (!blkcg_policy_enabled(q, pol)) {
 		ret = -EOPNOTSUPP;
 		goto fail_unlock;
 	}
 
+	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
+	rcu_read_unlock();
 	if (blkg)
 		goto success;
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
@@ -883,33 +868,32 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent;
 		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
+		rcu_read_lock();
 		while (parent && !blkg_lookup(parent, q)) {
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
-
-		/* Drop locks to do new blkg allocation with GFP_KERNEL. */
-		spin_unlock_irq(&q->queue_lock);
+		rcu_read_unlock();
 
 		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
 		if (unlikely(!new_blkg)) {
 			ret = -ENOMEM;
-			goto fail_exit;
+			goto fail_unlock;
 		}
 
-		spin_lock_irq(&q->queue_lock);
-
 		if (!blkcg_policy_enabled(q, pol)) {
 			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
 			goto fail_unlock;
 		}
 
+		rcu_read_lock();
 		blkg = blkg_lookup(pos, q);
+		rcu_read_unlock();
 		if (blkg) {
 			blkg_free(new_blkg);
 		} else {
 			blkg = blkg_create(pos, disk, new_blkg);
 			if (IS_ERR(blkg)) {
@@ -920,17 +904,14 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 
 		if (pos == blkcg)
 			goto success;
 	}
 success:
-	mutex_unlock(&q->blkcg_mutex);
 	ctx->blkg = blkg;
 	return 0;
 
 fail_unlock:
-	spin_unlock_irq(&q->queue_lock);
-fail_exit:
 	mutex_unlock(&q->blkcg_mutex);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
 	 * short msleep().  It isn't strictly necessary but queue
 	 * can be bypassing for some time and it's always nice to
@@ -949,11 +930,11 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
  * @ctx: blkg_conf_ctx initialized with blkg_conf_init()
  */
 void blkg_conf_unprep(struct blkg_conf_ctx *ctx)
 {
 	WARN_ON_ONCE(!ctx->blkg);
-	spin_unlock_irq(&ctx->bdev->bd_disk->queue->queue_lock);
+	mutex_unlock(&ctx->bdev->bd_disk->queue->blkcg_mutex);
 	ctx->blkg = NULL;
 }
 EXPORT_SYMBOL_GPL(blkg_conf_unprep);
 
 /**
@@ -1269,12 +1250,13 @@ static struct blkcg_gq *blkcg_get_first_blkg(struct blkcg *blkcg)
 
 /**
  * blkcg_destroy_blkgs - responsible for shooting down blkgs
  * @blkcg: blkcg of interest
  *
- * blkgs should be removed while holding both q and blkcg locks.  As blkcg lock
- * is nested inside q lock, this function performs reverse double lock dancing.
+ * blkgs should be removed while holding both q->blkcg_mutex and blkcg->lock.
+ * As blkcg->lock is nested inside q->blkcg_mutex, this function performs
+ * reverse double lock dancing.
  * Destroying the blkgs releases the reference held on the blkcg's css allowing
  * blkcg_css_free to eventually be called.
  *
  * This is the blkcg counterpart of ioc_release_fn().
  */
@@ -1285,17 +1267,17 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 	might_sleep();
 
 	while ((blkg = blkcg_get_first_blkg(blkcg))) {
 		struct request_queue *q = blkg->q;
 
-		spin_lock_irq(&q->queue_lock);
-		spin_lock(&blkcg->lock);
+		mutex_lock(&q->blkcg_mutex);
+		spin_lock_irq(&blkcg->lock);
 
 		blkg_destroy(blkg);
 
-		spin_unlock(&blkcg->lock);
-		spin_unlock_irq(&q->queue_lock);
+		spin_unlock_irq(&blkcg->lock);
+		mutex_unlock(&q->blkcg_mutex);
 
 		blkg_put(blkg);
 		cond_resched();
 	}
 }
@@ -1499,22 +1481,21 @@ int blkcg_init_disk(struct gendisk *disk)
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
 
 	/* Make sure the root blkg exists. */
-	/* spin_lock_irq can serve as RCU read-side critical section. */
-	spin_lock_irq(&q->queue_lock);
+	mutex_lock(&q->blkcg_mutex);
 	blkg = blkg_create(&blkcg_root, disk, new_blkg);
 	if (IS_ERR(blkg))
 		goto err_unlock;
 	q->root_blkg = blkg;
-	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	return 0;
 
 err_unlock:
-	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 	return PTR_ERR(blkg);
 }
 
 void blkcg_exit_disk(struct gendisk *disk)
 {
@@ -1548,51 +1529,37 @@ struct cgroup_subsys io_cgrp_subsys = {
 	.depends_on = 1 << memory_cgrp_id,
 #endif
 };
 EXPORT_SYMBOL_GPL(io_cgrp_subsys);
 
-static struct blkg_policy_data *
-blkcg_policy_detach_pd(struct request_queue *q,
-		       const struct blkcg_policy *pol)
+/*
+ * Tear down per-blkg policy data for @pol on @q.
+ */
+static void blkcg_policy_teardown_pds(struct request_queue *q,
+				      const struct blkcg_policy *pol)
 {
-	struct blkg_policy_data *pd = NULL;
 	struct blkcg_gq *blkg;
 
 	lockdep_assert_held(&q->blkcg_mutex);
 
-	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
+		struct blkg_policy_data *pd;
 
-		spin_lock(&blkcg->lock);
+		spin_lock_irq(&blkcg->lock);
 		pd = blkg->pd[pol->plid];
 		if (pd) {
 			if (pd->online && pol->pd_offline_fn)
 				pol->pd_offline_fn(pd);
 			pd->online = false;
 			WRITE_ONCE(blkg->pd[pol->plid], NULL);
 		}
-		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&blkcg->lock);
 
 		if (pd)
-			break;
+			pol->pd_free_fn(pd);
 	}
-	spin_unlock_irq(&q->queue_lock);
-
-	return pd;
-}
-
-/*
- * Tear down per-blkg policy data for @pol on @q.
- */
-static void blkcg_policy_teardown_pds(struct request_queue *q,
-				      const struct blkcg_policy *pol)
-{
-	struct blkg_policy_data *pd;
-
-	while ((pd = blkcg_policy_detach_pd(q, pol)))
-		pol->pd_free_fn(pd);
 }
 
 /**
  * blkcg_activate_policy - activate a blkcg policy on a gendisk
  * @disk: gendisk of interest
@@ -1600,13 +1567,13 @@ static void blkcg_policy_teardown_pds(struct request_queue *q,
  *
  * Activate @pol on @disk.  Requires %GFP_KERNEL context.  @disk goes through
  * bypass mode to populate its blkgs with policy_data for @pol.
  *
  * Activation happens with @disk bypassed, so nobody would be accessing blkgs
- * from IO path.  Update of each blkg is protected by both queue and blkcg
- * locks so that holding either lock and testing blkcg_policy_enabled() is
- * always enough for dereferencing policy data.
+ * from IO path.  Update of each blkg is protected by q->blkcg_mutex and
+ * blkcg->lock so that holding either lock and testing blkcg_policy_enabled()
+ * is always enough for dereferencing policy data.
  *
  * The caller is responsible for synchronizing [de]activations and policy
  * [un]registerations.  Returns 0 on success, -errno on failure.
  */
 int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
@@ -1631,12 +1598,10 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 	if (queue_is_mq(q))
 		memflags = blk_mq_freeze_queue(q);
 
 	mutex_lock(&q->blkcg_mutex);
 retry:
-	spin_lock_irq(&q->queue_lock);
-
 	/* blkg_list is pushed at the head, reverse walk to initialize parents first */
 	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
 		struct blkg_policy_data *pd;
 
 		if (blkg->pd[pol->plid])
@@ -1661,23 +1626,24 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 			if (pinned_blkg)
 				blkg_put(pinned_blkg);
 			blkg_get(blkg);
 			pinned_blkg = blkg;
 
-			spin_unlock_irq(&q->queue_lock);
+			mutex_unlock(&q->blkcg_mutex);
 
 			if (pd_prealloc)
 				pol->pd_free_fn(pd_prealloc);
 			pd_prealloc = pol->pd_alloc_fn(disk, blkg->blkcg,
 						       GFP_KERNEL);
+			mutex_lock(&q->blkcg_mutex);
 			if (pd_prealloc)
 				goto retry;
 			else
 				goto enomem;
 		}
 
-		spin_lock(&blkg->blkcg->lock);
+		spin_lock_irq(&blkg->blkcg->lock);
 
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
 		WRITE_ONCE(blkg->pd[pol->plid], pd);
 
@@ -1686,17 +1652,16 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 		if (pol->pd_online_fn)
 			pol->pd_online_fn(pd);
 		pd->online = true;
 
-		spin_unlock(&blkg->blkcg->lock);
+		spin_unlock_irq(&blkg->blkcg->lock);
 	}
 
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
-	spin_unlock_irq(&q->queue_lock);
 out:
 	mutex_unlock(&q->blkcg_mutex);
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
 	if (pinned_blkg)
@@ -1732,15 +1697,12 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 
 	if (queue_is_mq(q))
 		memflags = blk_mq_freeze_queue(q);
 
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
-	spin_unlock_irq(&q->queue_lock);
-
 	blkcg_policy_teardown_pds(q, pol);
 	mutex_unlock(&q->blkcg_mutex);
 
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
@@ -2162,23 +2124,34 @@ struct blkcg_gq *bio_blkg(struct bio *bio)
 {
 	struct blkcg *blkcg = bio_blkcg(bio);
 	struct gendisk *disk;
 	struct request_queue *q;
 	struct blkcg_gq *blkg;
+	int ret;
 
 	if (!blkcg || !bio->bi_bdev)
 		return NULL;
 
 	if (bio_flagged(bio, BIO_BLKG_REF))
 		return bio_pinned_blkg(bio);
 
 	disk = bio->bi_bdev->bd_disk;
 	q = disk->queue;
 
-	spin_lock_irq(&q->queue_lock);
+	rcu_read_lock();
+	blkg = blkg_lookup(blkcg, q);
+	if (blkg)
+		blkg = blkg_lookup_tryget(blkg);
+	rcu_read_unlock();
+	if (blkg) {
+		bio_set_blkg_ref(bio, blkg);
+		return blkg;
+	}
+
+	mutex_lock(&q->blkcg_mutex);
 	blkg = blkg_lookup_create(blkcg, disk);
-	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	bio_set_blkg_ref(bio, blkg);
 	return blkg;
 }
 EXPORT_SYMBOL_GPL(bio_blkg);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1925420154c1..dcba4eda9826 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -68,11 +68,11 @@ struct blkcg_gq {
 	struct blkcg_gq			*parent;
 
 	/* reference count */
 	struct percpu_ref		refcnt;
 
-	/* is this blkg online? protected by both blkcg and q locks */
+	/* is this blkg online? protected by blkcg->lock and q->blkcg_mutex */
 	bool				online;
 
 	struct blkg_iostat_set __percpu	*iostat_cpu;
 	struct blkg_iostat_set		iostat;
 
@@ -229,13 +229,13 @@ struct blkg_conf_ctx {
 void blkg_conf_init(struct blkg_conf_ctx *ctx, char *input);
 int blkg_conf_open_bdev(struct blkg_conf_ctx *ctx)
 	__cond_acquires(0, &ctx->bdev->bd_queue->rq_qos_mutex);
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   struct blkg_conf_ctx *ctx)
-	__cond_acquires(0, &ctx->bdev->bd_disk->queue->queue_lock);
+	__cond_acquires(0, &ctx->bdev->bd_disk->queue->blkcg_mutex);
 void blkg_conf_unprep(struct blkg_conf_ctx *ctx)
-	__releases(ctx->bdev->bd_disk->queue->queue_lock);
+	__releases(ctx->bdev->bd_disk->queue->blkcg_mutex);
 void blkg_conf_close_bdev(struct blkg_conf_ctx *ctx)
 	__releases(&ctx->bdev->bd_queue->rq_qos_mutex);
 
 /**
  * bio_issue_as_root_blkg - see if this bio needs to be issued as root blkg
@@ -388,13 +388,12 @@ static inline void bio_clear_blkcg(struct bio *bio)
  * @d_blkg: loop cursor pointing to the current descendant
  * @pos_css: used for iteration
  * @p_blkg: target blkg to walk descendants of
  *
  * Walk @c_blkg through the descendants of @p_blkg.  Must be used with RCU
- * read locked.  If called under either blkcg or queue lock, the iteration
- * is guaranteed to include all and only online blkgs.  The caller may
- * update @pos_css by calling css_rightmost_descendant() to skip subtree.
+ * read locked.  The caller may update @pos_css by calling
+ * css_rightmost_descendant() to skip subtree.
  * @p_blkg is included in the iteration and the first node to be visited.
  */
 #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
 	css_for_each_descendant_pre((pos_css), &(p_blkg)->blkcg->css)	\
 		if (((d_blkg) = blkg_lookup(css_to_blkcg(pos_css),	\
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 57f2b4d4af20..31419add4340 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2773,11 +2773,12 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 }
 
 static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
-	struct ioc_gq *iocg = blkg_to_iocg(bio_blkg(bio));
+	struct blkcg_gq *blkg = bio_blkg_lookup(rq->bio);
+	struct ioc_gq *iocg = blkg_to_iocg(blkg);
 	struct ioc *ioc = rqos_to_ioc(rqos);
 	sector_t bio_end = bio_end_sector(bio);
 	struct ioc_now now;
 	u64 vtime, abs_cost, cost;
 	unsigned long flags;
@@ -3152,10 +3153,11 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 	struct blkcg *blkcg = css_to_blkcg(of_css(of));
 	struct ioc_cgrp *iocc = blkcg_to_iocc(blkcg);
 	struct blkg_conf_ctx ctx;
 	struct ioc_now now;
 	struct ioc_gq *iocg;
+	unsigned long flags;
 	u32 v;
 	int ret;
 
 	if (!strchr(buf, ':')) {
 		struct blkcg_gq *blkg;
@@ -3204,15 +3206,15 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 			goto unprep;
 		if (v < CGROUP_WEIGHT_MIN || v > CGROUP_WEIGHT_MAX)
 			goto unprep;
 	}
 
-	spin_lock(&iocg->ioc->lock);
+	spin_lock_irqsave(&iocg->ioc->lock, flags);
 	iocg->cfg_weight = v * WEIGHT_ONE;
 	ioc_now(iocg->ioc, &now);
 	weight_updated(iocg, &now);
-	spin_unlock(&iocg->ioc->lock);
+	spin_unlock_irqrestore(&iocg->ioc->lock, flags);
 
 	ret = 0;
 
 unprep:
 	blkg_conf_unprep(&ctx);
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 7220edafd72b..b4bed73b645b 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -640,10 +640,11 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 
 	timer_shutdown_sync(&blkiolat->timer);
 	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iolatency);
+	flush_work(&blkiolat->enable_work);
 	kfree(blkiolat);
 }
 
 static const struct rq_qos_ops blkcg_iolatency_ops = {
 	.throttle = blkcg_iolatency_throttle,
@@ -812,20 +813,22 @@ static void iolatency_set_min_lat_nsec(struct blkcg_gq *blkg, u64 val)
 static void iolatency_clear_scaling(struct blkcg_gq *blkg)
 {
 	if (blkg->parent) {
 		struct iolatency_grp *iolat = blkg_to_lat(blkg->parent);
 		struct child_latency_info *lat_info;
+		unsigned long flags;
+
 		if (!iolat)
 			return;
 
 		lat_info = &iolat->child_lat;
-		spin_lock(&lat_info->lock);
+		spin_lock_irqsave(&lat_info->lock, flags);
 		atomic_set(&lat_info->scale_cookie, DEFAULT_SCALE_COOKIE);
 		lat_info->last_scale_event = 0;
 		lat_info->scale_grp = NULL;
 		lat_info->scale_lat = 0;
-		spin_unlock(&lat_info->lock);
+		spin_unlock_irqrestore(&lat_info->lock, flags);
 	}
 }
 
 static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
 			     size_t nbytes, loff_t off)
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 2ff30700e84e..045eeab38646 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1775,14 +1775,14 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
 	int rw;
 
 	if (!blk_throtl_activated(q))
 		return;
 
-	spin_lock_irq(&q->queue_lock);
-	spin_lock(&td->lock);
+	mutex_lock(&q->blkcg_mutex);
+	spin_lock_irq(&td->lock);
 	/*
-	 * queue_lock is held, rcu lock is not needed here technically.
+	 * blkcg_mutex is held, rcu lock is not needed here technically.
 	 * However, rcu lock is still held to emphasize that following
 	 * path need RCU protection and to prevent warning from lockdep.
 	 */
 	rcu_read_lock();
 	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
@@ -1795,12 +1795,12 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
 		 * del_gendisk.
 		 */
 		tg_cancel_writeback_bios(blkg_to_tg(blkg), cancel_bios);
 	}
 	rcu_read_unlock();
-	spin_unlock(&td->lock);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&td->lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	for (rw = READ; rw <= WRITE; rw++) {
 		struct bio *bio;
 		while ((bio = bio_list_pop(&cancel_bios[rw])))
 			bio_io_error(bio);
-- 
2.51.0

