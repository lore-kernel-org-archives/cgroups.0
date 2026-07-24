Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7418941A79E;
	Fri, 24 Jul 2026 12:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896270; cv=none; b=iu2yYoRufwqSW9W01SmpjeJUFmiTw6fU3TIPAJxjwmiLOPcEzDJB7yMipBouGUl59RKY3pR2ld5ITOm3tyleU2fwaCeLD4bSrLDPMTig7gmBADdpeMD9vwVGVx/7iq8BShGMUysJRpF7yg3q0nlyjaKsufIMR2Vqa+6qmT9MIK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896270; c=relaxed/simple;
	bh=WRs3Wy4CPIO++/SJevRiqiDE2z2Y4lYO66Y72V8QOCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/R4esoGy1uh6Jg1rAfuVm1yIG7vNZDtmRJ2KC8NjacMjF2kvbEvEX52f/2n/pMqo0U9COhDb015sY/0BlQpdrvUskDqbTSa9uy4LJ5MzzIDWLKeV/DMDQpsmVuu8Z3/77PBeWutdbeue0jJuGWIHZ0iAzHXuFPkd7Ic7vjrC2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d9cD67ay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d9cD67ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72291F00A3D;
	Fri, 24 Jul 2026 12:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896268;
	bh=3Na9IHn88i2EAdPVmZGVA18BWbrX2xrGGdO2CoD8ndQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d9cD67ayXbdL//+zbAblyo4t3Qy0IFXgakM0BmBzDxqo5wic/L5Ic8ESlsAWHhMNK
	 pxDjEHiUGgqgmQdhH4OvhVS8rWMWN30fJiGWvz66IUfVYZn3bVvGp5W8SlgiGi636M
	 xBE7d8J+ZiuSnyCFb3AcEy4tLxLO2KyRg7N9sEkdPgktvs5UyO55ZFutkA+TuUak5m
	 5dy0sqr3jqDI/va9wv7ASjW5ZgnyP51dBUqVoiGwdqNCmNHi5Z/EkCK0yy2xFY/Ywg
	 hGrgoOkaKAYgKBUpKd+kKBz7QNn9QieWQaX0epYj7S4N4pBNSPR7oPPYYKdzCzjNVq
	 l4f5i1dJ/vM3A==
From: Yu Kuai <yukuai@kernel.org>
To: axboe@kernel.dk,
	tj@kernel.org
Cc: hch@lst.de,
	dongsheng.yang@linux.dev,
	cengku@gmail.com,
	josef@toxicpanda.com,
	nilay@linux.ibm.com,
	ming.lei@redhat.com,
	yukuai@fygo.io,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 3/8] blk-cgroup: protect blkgs with blkcg_mutex
Date: Fri, 24 Jul 2026 20:30:32 +0800
Message-ID: <20260724123037.3004560-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260724123037.3004560-1-yukuai@kernel.org>
References: <20260724123037.3004560-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

queue_lock is still needed by block core users, but blkcg no longer needs
it for blkg topology now that throttle runtime state has a private lock.

Move queue-local blkg synchronization to q->blkcg_mutex.  Hold it while
looking up, creating and destroying blkgs, while preparing and undoing
configuration, and while activating or deactivating policies.

Update the BFQ, iocost, iolatency and throttle paths which walk
q->blkg_list or access per-blkg policy state to use the same lock.

blkcg->lock still protects blkcg-local radix tree and list updates.  Some
lookups under blkcg_mutex can race with blkcg updates done for other
queues, so keep those lookups in RCU read-side critical sections.  In
particular, protect the parent lookup in blkg_create() and the parent walk
in blkg_lookup_create().

Now that blkg association happens from the sleepable submit path, the
queue_lock -> blkcg_mutex conversion lets blkg creation sleep properly.
Nowait bio handling (failing submit instead of sleeping) is added in a
follow-up patch.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/bfq-cgroup.c    |  10 +--
 block/blk-cgroup.c    | 182 ++++++++++++++++++++++--------------------
 block/blk-cgroup.h    |  16 ++--
 block/blk-core.c      |   2 +
 block/blk-iocost.c    |   5 +-
 block/blk-iolatency.c |   7 +-
 block/blk-throttle.c  |  10 +--
 7 files changed, 121 insertions(+), 111 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index e82ff03bda02..42614aa78cd4 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -426,7 +426,7 @@ static void bfqg_stats_xfer_dead(struct bfq_group *bfqg)
 
 	parent = bfqg_parent(bfqg);
 
-	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->queue_lock);
+	lockdep_assert_held(&bfqg_to_blkg(bfqg)->q->blkcg_mutex);
 
 	if (unlikely(!parent))
 		return;
@@ -874,7 +874,7 @@ static void bfq_reparent_active_queues(struct bfq_data *bfqd,
  *		    and reparent its children entities.
  * @pd: descriptor of the policy going offline.
  *
- * blkio already grabs the queue_lock for us, so no need to use
+ * blkio already grabs the blkcg_mutex for us, so no need to use
  * RCU-based magic
  */
 static void bfq_pd_offline(struct blkg_policy_data *pd)
@@ -947,8 +947,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	struct blkcg_gq *blkg;
 
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
-	spin_lock(&bfqd->lock);
+	spin_lock_irq(&bfqd->lock);
 
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct bfq_group *bfqg = blkg_to_bfqg(blkg);
@@ -957,8 +956,7 @@ void bfq_end_wr_async(struct bfq_data *bfqd)
 	}
 	bfq_end_wr_async_queues(bfqd, bfqd->root_group);
 
-	spin_unlock(&bfqd->lock);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&bfqd->lock);
 	mutex_unlock(&q->blkcg_mutex);
 }
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 618e5566fa52..03e1d4d34921 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -131,9 +131,7 @@ static void blkg_free_workfn(struct work_struct *work)
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 	if (blkg->parent)
 		blkg_put(blkg->parent);
-	spin_lock_irq(&q->queue_lock);
 	list_del_init(&blkg->q_node);
-	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 
 	/*
@@ -382,7 +380,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	struct blkcg_gq *blkg;
 	int i, ret;
 
-	lockdep_assert_held(&disk->queue->queue_lock);
+	lockdep_assert_held(&disk->queue->blkcg_mutex);
 
 	/* request_queue is dying, do not create/recreate a blkg */
 	if (blk_queue_dying(disk->queue)) {
@@ -402,12 +400,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 
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
@@ -419,7 +420,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	}
 
 	/* insert */
-	spin_lock(&blkcg->lock);
+	spin_lock_irq(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
 	if (likely(!ret)) {
 		hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
@@ -436,7 +437,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 		}
 		blkg->online = true;
 	}
-	spin_unlock(&blkcg->lock);
+	spin_unlock_irq(&blkcg->lock);
 
 	if (!ret)
 		return blkg;
@@ -459,7 +460,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
  * Lookup blkg for the @blkcg - @disk pair.  If it doesn't exist, try to
  * create one.  blkg creation is performed recursively from blkcg_root such
  * that all non-root blkg's have access to the parent blkg.  This function
- * should be called under RCU read lock and takes @disk->queue->queue_lock.
+ * must be called with @disk->queue->blkcg_mutex held.
  *
  * Returns the blkg or the closest blkg if blkg_create() fails as it walks
  * down from root.
@@ -491,6 +492,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		struct blkcg *parent = blkcg_parent(blkcg);
 		struct blkcg_gq *ret_blkg = q->root_blkg;
 
+		rcu_read_lock();
 		while (parent) {
 			blkg = blkg_lookup(parent, q);
 			if (blkg) {
@@ -501,6 +503,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
+		rcu_read_unlock();
 
 		blkg = blkg_create(pos, disk, NULL);
 		if (IS_ERR(blkg)) {
@@ -519,7 +522,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	struct blkcg *blkcg = blkg->blkcg;
 	int i;
 
-	lockdep_assert_held(&blkg->q->queue_lock);
+	lockdep_assert_held(&blkg->q->blkcg_mutex);
 	lockdep_assert_held(&blkcg->lock);
 
 	/*
@@ -547,8 +550,8 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
 	/*
-	 * Both setting lookup hint to and clearing it from @blkg are done
-	 * under queue_lock.  If it's not pointing to @blkg now, it never
+	 * Both setting lookup hint to and clearing it from @blkg are done under
+	 * blkcg_mutex.  If it's not pointing to @blkg now, it never
 	 * will.  Hint assignment itself can race safely.
 	 */
 	if (rcu_access_pointer(blkcg->blkg_hint) == blkg)
@@ -569,24 +572,21 @@ static void blkg_destroy_all(struct gendisk *disk)
 	int i;
 
 restart:
-	spin_lock_irq(&q->queue_lock);
+	mutex_lock(&q->blkcg_mutex);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
 
 		if (hlist_unhashed(&blkg->blkcg_node))
 			continue;
 
-		spin_lock(&blkcg->lock);
+		spin_lock_irq(&blkcg->lock);
 		blkg_destroy(blkg);
-		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&blkcg->lock);
 
-		/*
-		 * in order to avoid holding the spin lock for too long, release
-		 * it when a batch of blkgs are destroyed.
-		 */
+		/* Avoid holding blkcg_mutex for too long. */
 		if (!(--count)) {
 			count = BLKG_DESTROY_BATCH_SIZE;
-			spin_unlock_irq(&q->queue_lock);
+			mutex_unlock(&q->blkcg_mutex);
 			cond_resched();
 			goto restart;
 		}
@@ -605,7 +605,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 	}
 
 	q->root_blkg = NULL;
-	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	wake_up_var(&q->root_blkg);
 }
@@ -822,8 +822,8 @@ EXPORT_SYMBOL_GPL(blkg_conf_open_bdev);
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
@@ -841,7 +841,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 
 	/* Prevent concurrent with blkcg_deactivate_policy() */
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
 
 	if (!blkcg_policy_enabled(q, pol)) {
 		ret = -EOPNOTSUPP;
@@ -862,35 +861,34 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
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
 
 		if (radix_tree_preload(GFP_KERNEL)) {
 			blkg_free(new_blkg);
 			ret = -ENOMEM;
-			goto fail_exit;
+			goto fail_unlock;
 		}
 
-		spin_lock_irq(&q->queue_lock);
-
 		if (!blkcg_policy_enabled(q, pol)) {
 			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
 			goto fail_preloaded;
 		}
 
+		rcu_read_lock();
 		blkg = blkg_lookup(pos, q);
+		rcu_read_unlock();
 		if (blkg) {
 			blkg_free(new_blkg);
 		} else {
@@ -907,15 +905,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto success;
 	}
 success:
-	mutex_unlock(&q->blkcg_mutex);
 	ctx->blkg = blkg;
 	return 0;
 
 fail_preloaded:
 	radix_tree_preload_end();
 fail_unlock:
-	spin_unlock_irq(&q->queue_lock);
-fail_exit:
 	mutex_unlock(&q->blkcg_mutex);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
@@ -938,7 +933,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_prep);
 void blkg_conf_unprep(struct blkg_conf_ctx *ctx)
 {
 	WARN_ON_ONCE(!ctx->blkg);
-	spin_unlock_irq(&ctx->bdev->bd_disk->queue->queue_lock);
+	mutex_unlock(&ctx->bdev->bd_disk->queue->blkcg_mutex);
 	ctx->blkg = NULL;
 }
 EXPORT_SYMBOL_GPL(blkg_conf_unprep);
@@ -1258,8 +1253,9 @@ static struct blkcg_gq *blkcg_get_first_blkg(struct blkcg *blkcg)
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
@@ -1274,13 +1270,13 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
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
@@ -1472,21 +1468,20 @@ int blkcg_init_disk(struct gendisk *disk)
 	preloaded = !radix_tree_preload(GFP_KERNEL);
 
 	/* Make sure the root blkg exists. */
-	/* spin_lock_irq can serve as RCU read-side critical section. */
-	spin_lock_irq(&q->queue_lock);
+	mutex_lock(&q->blkcg_mutex);
 	blkg = blkg_create(&blkcg_root, disk, new_blkg);
 	if (IS_ERR(blkg))
 		goto err_unlock;
 	q->root_blkg = blkg;
-	spin_unlock_irq(&q->queue_lock);
 
 	if (preloaded)
 		radix_tree_preload_end();
+	mutex_unlock(&q->blkcg_mutex);
 
 	return 0;
 
 err_unlock:
-	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 	if (preloaded)
 		radix_tree_preload_end();
 	return PTR_ERR(blkg);
@@ -1526,6 +1521,42 @@ struct cgroup_subsys io_cgrp_subsys = {
 };
 EXPORT_SYMBOL_GPL(io_cgrp_subsys);
 
+static void blkg_free_policy_data(struct blkcg_gq *blkg,
+				  const struct blkcg_policy *pol)
+{
+	struct blkcg *blkcg = blkg->blkcg;
+	struct blkg_policy_data *pd;
+	bool online = false;
+
+	lockdep_assert_held(&blkg->q->blkcg_mutex);
+
+	/*
+	 * ->pd_offline_fn() may need blkg->pd[] to stay installed, while
+	 * ->pd_free_fn() can sleep.  Mark offline under blkcg->lock, run
+	 * the offline callback, detach under blkcg->lock, then free.
+	 */
+	spin_lock_irq(&blkcg->lock);
+	pd = blkg->pd[pol->plid];
+	if (pd) {
+		online = pd->online;
+		pd->online = false;
+	}
+	spin_unlock_irq(&blkcg->lock);
+
+	if (!pd)
+		return;
+
+	if (online && pol->pd_offline_fn)
+		pol->pd_offline_fn(pd);
+
+	spin_lock_irq(&blkcg->lock);
+	WARN_ON_ONCE(blkg->pd[pol->plid] != pd);
+	WRITE_ONCE(blkg->pd[pol->plid], NULL);
+	spin_unlock_irq(&blkcg->lock);
+
+	pol->pd_free_fn(pd);
+}
+
 /**
  * blkcg_activate_policy - activate a blkcg policy on a gendisk
  * @disk: gendisk of interest
@@ -1535,9 +1566,9 @@ EXPORT_SYMBOL_GPL(io_cgrp_subsys);
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
@@ -1563,8 +1594,9 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 	if (queue_is_mq(q))
 		memflags = blk_mq_freeze_queue(q);
+
 retry:
-	spin_lock_irq(&q->queue_lock);
+	mutex_lock(&q->blkcg_mutex);
 
 	/* blkg_list is pushed at the head, reverse walk to initialize parents first */
 	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
@@ -1572,14 +1604,15 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 		if (blkg->pd[pol->plid])
 			continue;
+		if (hlist_unhashed(&blkg->blkcg_node))
+			continue;
 
-		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
+		/* If prealloc matches, use it; otherwise try GFP_NOWAIT. */
 		if (blkg == pinned_blkg) {
 			pd = pd_prealloc;
 			pd_prealloc = NULL;
 		} else {
-			pd = pol->pd_alloc_fn(disk, blkg->blkcg,
-					      GFP_NOWAIT);
+			pd = pol->pd_alloc_fn(disk, blkg->blkcg, GFP_NOWAIT);
 		}
 
 		if (!pd) {
@@ -1592,7 +1625,7 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 			blkg_get(blkg);
 			pinned_blkg = blkg;
 
-			spin_unlock_irq(&q->queue_lock);
+			mutex_unlock(&q->blkcg_mutex);
 
 			if (pd_prealloc)
 				pol->pd_free_fn(pd_prealloc);
@@ -1600,11 +1633,10 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 						       GFP_KERNEL);
 			if (pd_prealloc)
 				goto retry;
-			else
-				goto enomem;
+			goto enomem;
 		}
 
-		spin_lock(&blkg->blkcg->lock);
+		spin_lock_irq(&blkg->blkcg->lock);
 
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
@@ -1617,14 +1649,14 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 			pol->pd_online_fn(pd);
 		pd->online = true;
 
-		spin_unlock(&blkg->blkcg->lock);
+		spin_unlock_irq(&blkg->blkcg->lock);
 	}
 
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
-	spin_unlock_irq(&q->queue_lock);
 out:
+	mutex_unlock(&q->blkcg_mutex);
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
 	if (pinned_blkg)
@@ -1635,23 +1667,9 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 enomem:
 	/* alloc failed, take down everything */
-	spin_lock_irq(&q->queue_lock);
-	list_for_each_entry(blkg, &q->blkg_list, q_node) {
-		struct blkcg *blkcg = blkg->blkcg;
-		struct blkg_policy_data *pd;
-
-		spin_lock(&blkcg->lock);
-		pd = blkg->pd[pol->plid];
-		if (pd) {
-			if (pd->online && pol->pd_offline_fn)
-				pol->pd_offline_fn(pd);
-			pd->online = false;
-			pol->pd_free_fn(pd);
-			WRITE_ONCE(blkg->pd[pol->plid], NULL);
-		}
-		spin_unlock(&blkcg->lock);
-	}
-	spin_unlock_irq(&q->queue_lock);
+	mutex_lock(&q->blkcg_mutex);
+	list_for_each_entry(blkg, &q->blkg_list, q_node)
+		blkg_free_policy_data(blkg, pol);
 	ret = -ENOMEM;
 	goto out;
 }
@@ -1679,24 +1697,12 @@ void blkcg_deactivate_policy(struct gendisk *disk,
 		memflags = blk_mq_freeze_queue(q);
 
 	mutex_lock(&q->blkcg_mutex);
-	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
 
-	list_for_each_entry(blkg, &q->blkg_list, q_node) {
-		struct blkcg *blkcg = blkg->blkcg;
+	list_for_each_entry(blkg, &q->blkg_list, q_node)
+		blkg_free_policy_data(blkg, pol);
 
-		spin_lock(&blkcg->lock);
-		if (blkg->pd[pol->plid]) {
-			if (blkg->pd[pol->plid]->online && pol->pd_offline_fn)
-				pol->pd_offline_fn(blkg->pd[pol->plid]);
-			pol->pd_free_fn(blkg->pd[pol->plid]);
-			blkg->pd[pol->plid] = NULL;
-		}
-		spin_unlock(&blkcg->lock);
-	}
-
-	spin_unlock_irq(&q->queue_lock);
 	mutex_unlock(&q->blkcg_mutex);
 
 	if (queue_is_mq(q))
@@ -2087,11 +2093,11 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 	 * Fast path failed, we're probably issuing IO in this cgroup the first
 	 * time, hold lock to create new blkg.
 	 */
-	spin_lock_irq(&q->queue_lock);
+	mutex_lock(&q->blkcg_mutex);
 	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
 	if (blkg)
 		blkg = blkg_lookup_tryget(blkg);
-	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	return blkg;
 }
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 615390f751aa..5aaf2d54d17e 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -66,7 +66,7 @@ struct blkcg_gq {
 	/* reference count */
 	struct percpu_ref		refcnt;
 
-	/* is this blkg online? protected by both blkcg and q locks */
+	/* is this blkg online? protected by blkcg->lock and q->blkcg_mutex */
 	bool				online;
 
 	struct blkg_iostat_set __percpu	*iostat_cpu;
@@ -224,9 +224,9 @@ int blkg_conf_open_bdev(struct blkg_conf_ctx *ctx)
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
 
@@ -255,7 +255,7 @@ static inline bool bio_issue_as_root_blkg(struct bio *bio)
  *
  * Lookup blkg for the @blkcg - @q pair.
  *
- * Must be called in a RCU critical section.
+ * Must be called in a RCU critical section or with q->blkcg_mutex held.
  */
 static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 					   struct request_queue *q)
@@ -266,7 +266,7 @@ static inline struct blkcg_gq *blkg_lookup(struct blkcg *blkcg,
 		return q->root_blkg;
 
 	blkg = rcu_dereference_check(blkcg->blkg_hint,
-			lockdep_is_held(&q->queue_lock));
+			lockdep_is_held(&q->blkcg_mutex));
 	if (blkg && blkg->q == q)
 		return blkg;
 
@@ -350,9 +350,9 @@ static inline void blkg_put(struct blkcg_gq *blkg)
  * @p_blkg: target blkg to walk descendants of
  *
  * Walk @c_blkg through the descendants of @p_blkg.  Must be used with RCU
- * read locked.  If called under either blkcg or queue lock, the iteration
- * is guaranteed to include all and only online blkgs.  The caller may
- * update @pos_css by calling css_rightmost_descendant() to skip subtree.
+ * read locked.  If called under either blkcg->lock or q->blkcg_mutex, the
+ * iteration is guaranteed to include all and only online blkgs.  The caller
+ * may update @pos_css by calling css_rightmost_descendant() to skip subtree.
  * @p_blkg is included in the iteration and the first node to be visited.
  */
 #define blkg_for_each_descendant_pre(d_blkg, pos_css, p_blkg)		\
diff --git a/block/blk-core.c b/block/blk-core.c
index 8103643b39fc..0a1d2b09a5d9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -965,6 +965,8 @@ static void bio_set_ioprio(struct bio *bio)
  */
 void submit_bio(struct bio *bio)
 {
+	might_sleep();
+
 	if (bio_op(bio) == REQ_OP_READ) {
 		task_io_account_read(bio->bi_iter.bi_size);
 		count_vm_events(PGPGIN, bio_sectors(bio));
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..ae50d143e4fc 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3143,6 +3143,7 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 	struct blkg_conf_ctx ctx;
 	struct ioc_now now;
 	struct ioc_gq *iocg;
+	unsigned long flags;
 	u32 v;
 	int ret;
 
@@ -3195,11 +3196,11 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
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
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index cef02b6c5fa9..30e23fee4f15 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -639,6 +639,7 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 	timer_shutdown_sync(&blkiolat->timer);
 	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->disk, &blkcg_policy_iolatency);
+	flush_work(&blkiolat->enable_work);
 	kfree(blkiolat);
 }
 
@@ -811,16 +812,18 @@ static void iolatency_clear_scaling(struct blkcg_gq *blkg)
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
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7bca2805404f..ef3edd5a4785 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1777,10 +1777,10 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
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
@@ -1797,8 +1797,8 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
 		tg_cancel_writeback_bios(blkg_to_tg(blkg), cancel_bios);
 	}
 	rcu_read_unlock();
-	spin_unlock(&td->lock);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&td->lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	for (rw = READ; rw <= WRITE; rw++) {
 		struct bio *bio;
-- 
2.51.0

