Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0938331B;
	Sun, 23 Aug 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787499008; cv=none; b=f5MCwCw/45e1NFrIw7vurm38NJ+F9SFulz7tTN9qAS2BK89Dw2uwQT2y71clJGfQ9//IZEtLH0JiosZgpkR2q5bDs6bzpeVV50XBAlNugZ/mQc+ncQCnGv2buxWpxfA8Nvqmg3lSUOgX/VIR+XMZ0mxjT/Nol1AgTtIQJZpfhE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787499008; c=relaxed/simple;
	bh=1H++vHCuZ3wTy09c/SM9msODiffQlxRb89vI7PIU3DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9VJL1Cp5zUz3olEHnv6G7BtiujKt9CZo5jOHTagWk0hdURgP641uPtXMFhXegFnInhYc9v6nlLLq2jZm/Dkh9H2SXnWk75VG2eGd3LyAu6AiT1Es4oQB8FLRRoNHi9f9PFrxodWftJbpAf355PtHrs1fFZE6xebfZxocYgueA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i032EMwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i032EMwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5611F000E9;
	Sun, 23 Aug 2026 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787499003;
	bh=1IQwcC3opStUF2dM1dI8wiAomf7Ot1O3sOeHkKWVCi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i032EMwafzEf+D5w6IFnJ0vDy+/9eY4EsGscTOg7iIlppboJjnP3/Y9bS5eb0yVq7
	 vNCoCqMWP87dLb9/KToAe5RbbnbUoNmX3jmBZBOB5F4aRsYYkWsxcQKY6WXT/6Soh1
	 BDvb/pgJlPlqnpftDkyraBgdBEvRliXtwUazLWVtJdrTEm62jH65rHS7fy0XWQ/yMv
	 keLfJXsGQdf+7+TLXTawYFuihg1y5ORc1sthz6mltBs51s5CE/9iqdqVMEoub+KlBy
	 4BkiK2dgLbIiOlexALS89b1nRL6mH75b83rkjiOPmO+DPXC45pd9r5s8jzc81Xw/7v
	 KFwJubfoGDaOQ==
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
Subject: [RFC PATCH v3 4/6] blk-cgroup: allocate blkgs in blkg_create
Date: Sun, 23 Aug 2026 23:29:23 +0800
Message-ID: <20260823152926.1043863-5-yukuai@kernel.org>
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

Move blkg allocation into blkg_create() and have it take a gfp_t mask, so
that the caller controls whether creation may sleep. blkg_create() now
always allocates the blkg itself instead of sometimes receiving a
preallocated one, which lets the lookup and config paths drop their open-
coded preallocation and retry loops.

blkg_lookup_create() and the root-blkg setup use GFP_NOIO (or GFP_KERNEL
for the root) so they do not recurse into IO reclaim; the nowait policy
path added later will use GFP_ATOMIC.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 48 +++++++++++++---------------------------------
 1 file changed, 13 insertions(+), 35 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0f34a80a726d..33fba781017b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -383,37 +383,29 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 out_free_blkg:
 	kfree(blkg);
 	return NULL;
 }
 
-/*
- * If @new_blkg is %NULL, this function tries to allocate a new one as
- * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return.
- */
 static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
-				    struct blkcg_gq *new_blkg)
+				    gfp_t gfp_mask)
 {
-	struct blkcg_gq *blkg;
+	struct blkcg_gq *blkg = NULL;
 	int i, ret;
 
 	lockdep_assert_held(&disk->queue->blkcg_mutex);
 
 	/* request_queue is dying, do not create/recreate a blkg */
 	if (blk_queue_dying(disk->queue)) {
 		ret = -ENODEV;
 		goto err_free_blkg;
 	}
 
-	/* allocate */
-	if (!new_blkg) {
-		new_blkg = blkg_alloc(blkcg, disk, GFP_NOWAIT);
-		if (unlikely(!new_blkg)) {
-			ret = -ENOMEM;
-			goto err_free_blkg;
-		}
+	blkg = blkg_alloc(blkcg, disk, gfp_mask);
+	if (unlikely(!blkg)) {
+		ret = -ENOMEM;
+		goto err_free_blkg;
 	}
-	blkg = new_blkg;
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
 		rcu_read_lock();
 		blkg->parent = blkg_lookup(blkcg_parent(blkcg), disk->queue);
@@ -461,12 +453,12 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	/* @blkg failed fully initialized, use the usual release path */
 	percpu_ref_kill(&blkg->refcnt);
 	return ERR_PTR(ret);
 
 err_free_blkg:
-	if (new_blkg)
-		blkg_free(new_blkg);
+	if (blkg)
+		blkg_free(blkg);
 	return ERR_PTR(ret);
 }
 
 /*
  * The root blkg holds a live reference while the disk is active, so walking
@@ -531,11 +523,11 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
 		rcu_read_unlock();
 
-		blkg = blkg_create(pos, disk, NULL);
+		blkg = blkg_create(pos, disk, GFP_NOIO);
 		if (IS_ERR(blkg)) {
 			blkg = ret_blkg;
 			break;
 		}
 		if (pos == blkcg)
@@ -865,39 +857,29 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	 * non-root blkgs have access to their parents.
 	 */
 	while (true) {
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent;
-		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
 		rcu_read_lock();
 		while (parent && !blkg_lookup(parent, q)) {
 			pos = parent;
 			parent = blkcg_parent(parent);
 		}
 		rcu_read_unlock();
 
-		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
-		if (unlikely(!new_blkg)) {
-			ret = -ENOMEM;
-			goto fail_unlock;
-		}
-
 		if (!blkcg_policy_enabled(q, pol)) {
-			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
 			goto fail_unlock;
 		}
 
 		rcu_read_lock();
 		blkg = blkg_lookup(pos, q);
 		rcu_read_unlock();
-		if (blkg) {
-			blkg_free(new_blkg);
-		} else {
-			blkg = blkg_create(pos, disk, new_blkg);
+		if (!blkg) {
+			blkg = blkg_create(pos, disk, GFP_NOIO);
 			if (IS_ERR(blkg)) {
 				ret = PTR_ERR(blkg);
 				goto fail_unlock;
 			}
 		}
@@ -1466,27 +1448,23 @@ void blkg_exit_queue(struct request_queue *q)
 }
 
 int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	struct blkcg_gq *new_blkg, *blkg;
+	struct blkcg_gq *blkg;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
 	 * previous disk's blkcg state is cleaned up asynchronously via
 	 * disk_release() -> blkcg_exit_disk(). Wait for all old blkgs to be
 	 * removed from the queue list before setting up new blkcg state.
 	 */
 	wait_var_event(&q->blkg_list, list_empty_careful(&q->blkg_list));
 
-	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
-	if (!new_blkg)
-		return -ENOMEM;
-
 	/* Make sure the root blkg exists. */
 	mutex_lock(&q->blkcg_mutex);
-	blkg = blkg_create(&blkcg_root, disk, new_blkg);
+	blkg = blkg_create(&blkcg_root, disk, GFP_KERNEL);
 	if (IS_ERR(blkg))
 		goto err_unlock;
 	q->root_blkg = blkg;
 	mutex_unlock(&q->blkcg_mutex);
 
-- 
2.51.0

