Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAA83E49E0;
	Fri, 24 Jul 2026 12:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896279; cv=none; b=PInQsDl6oTTG9eQxxGWQIWjy/D1ptZ+naZdC0fl6JEFWicAIUBw9tRVlB1aEQomqfhQ2WQ3/P4Ixffp7cqFgZYE4hZGRtVWgQabffVzSwzWVY+fxboYyiQ2KPpvtRAfHYdmso58pWvhGaukwCpo4+2YRk03pvfAlU1897eQgChE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896279; c=relaxed/simple;
	bh=rvrW7C7tDyJiJF5ktAFKP5dkTBaQHwKS5ktE+e4jJu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZ3B2sd7HVy1BHF0NonO2gXsbzK+dmIjq3DQVfH2ZPbInMSI3+XyduIk6Rkvr1nRebEZy1b8/8Z2zHcoLOA8skER/7GmrnayRrGy/GYxd7mPkIjvNKEKaKPR9rrH+3eFqn5saNjVuEnpCeSo5m+/iClfj1bKqquwoviNqXTfm74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3bLxa4V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3bLxa4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8601F00A3D;
	Fri, 24 Jul 2026 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896277;
	bh=YczTTpGyHlOpV8Q8v0EzdLg2gR4FA5wBVbjXroT6MWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U3bLxa4Vei41fbOLC+C+TCuCapMAhWriN6xLY8Bpd4G6Uxf7IICcTPrHpLZgz6psl
	 cDqZpYjWHosj86kRc1eORDReRSEzOIhUO/rzgD+CufybUeDfEaypYtZPD78m8nX38o
	 0ypy2uwC8viOnydPRbTnC7gf0lB5+Be6zb6OMfp81kqAPpGJBYBcXPUztPEA4dhe8h
	 8morVD0LlIveGPeQBTbXHFYHzBo++9UKHNK27hW03nwbTeKWuKPMek666fuWfhntY5
	 xL+d7vE3ki+slTk8F/VgbT05EA5WsN1jsE91MuMUQNA1xgwkVZACr/DJLuGkwS6DCF
	 JzT8cV0nwJGdg==
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
Subject: [RFC PATCH v2 5/8] blk-cgroup: allocate blkgs in blkg_create
Date: Fri, 24 Jul 2026 20:30:34 +0800
Message-ID: <20260724123037.3004560-6-yukuai@kernel.org>
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

Move blkg allocation into blkg_create() and have it take a gfp_t mask, so
that the caller controls whether creation may sleep. blkg_create() now
always allocates the blkg itself instead of sometimes receiving a
preallocated one, which lets the lookup and config paths drop their open-
coded preallocation and retry loops.

blkg_lookup_create() and the root-blkg setup use GFP_NOIO (or GFP_KERNEL
for the root) so they do not recurse into IO reclaim; the nowait submit
path, added later, will use GFP_ATOMIC.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 86 +++++++++-------------------------------------
 1 file changed, 16 insertions(+), 70 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8fdc42ab153b..345c02a4ac32 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -370,14 +370,10 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
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
@@ -388,15 +384,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
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
@@ -446,8 +438,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	return ERR_PTR(ret);
 
 err_free_blkg:
-	if (new_blkg)
-		blkg_free(new_blkg);
+	if (blkg)
+		blkg_free(blkg);
 	return ERR_PTR(ret);
 }
 
@@ -504,7 +496,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 		}
 		rcu_read_unlock();
 
-		blkg = blkg_create(pos, disk, NULL);
+		blkg = blkg_create(pos, disk, GFP_NOIO);
 		if (IS_ERR(blkg)) {
 			blkg = ret_blkg;
 			break;
@@ -857,7 +849,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	while (true) {
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent;
-		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
 		rcu_read_lock();
@@ -867,14 +858,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
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
@@ -882,10 +866,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
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
@@ -1435,7 +1417,7 @@ void blkg_init_queue(struct request_queue *q)
 int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	struct blkcg_gq *new_blkg, *blkg;
+	struct blkcg_gq *blkg;
 
 	/*
 	 * If the queue is shared across disk rebind (e.g., SCSI), the
@@ -1449,13 +1431,9 @@ int blkcg_init_disk(struct gendisk *disk)
 	 */
 	wait_var_event(&q->root_blkg, !READ_ONCE(q->root_blkg));
 
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
@@ -1558,8 +1536,7 @@ static void blkg_free_policy_data(struct blkcg_gq *blkg,
 int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 {
 	struct request_queue *q = disk->queue;
-	struct blkg_policy_data *pd_prealloc = NULL;
-	struct blkcg_gq *blkg, *pinned_blkg = NULL;
+	struct blkcg_gq *blkg;
 	unsigned int memflags;
 	int ret;
 
@@ -1577,7 +1554,6 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 	if (queue_is_mq(q))
 		memflags = blk_mq_freeze_queue(q);
 
-retry:
 	mutex_lock(&q->blkcg_mutex);
 
 	/* blkg_list is pushed at the head, reverse walk to initialize parents first */
@@ -1589,34 +1565,9 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 		if (hlist_unhashed(&blkg->blkcg_node))
 			continue;
 
-		/* If prealloc matches, use it; otherwise try GFP_NOWAIT. */
-		if (blkg == pinned_blkg) {
-			pd = pd_prealloc;
-			pd_prealloc = NULL;
-		} else {
-			pd = pol->pd_alloc_fn(disk, blkg->blkcg, GFP_NOWAIT);
-		}
-
-		if (!pd) {
-			/*
-			 * GFP_NOWAIT failed.  Free the existing one and
-			 * prealloc for @blkg w/ GFP_KERNEL.
-			 */
-			if (pinned_blkg)
-				blkg_put(pinned_blkg);
-			blkg_get(blkg);
-			pinned_blkg = blkg;
-
-			mutex_unlock(&q->blkcg_mutex);
-
-			if (pd_prealloc)
-				pol->pd_free_fn(pd_prealloc);
-			pd_prealloc = pol->pd_alloc_fn(disk, blkg->blkcg,
-						       GFP_KERNEL);
-			if (pd_prealloc)
-				goto retry;
+		pd = pol->pd_alloc_fn(disk, blkg->blkcg, GFP_NOIO);
+		if (!pd)
 			goto enomem;
-		}
 
 		spin_lock_irq(&blkg->blkcg->lock);
 
@@ -1641,15 +1592,10 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 	mutex_unlock(&q->blkcg_mutex);
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q, memflags);
-	if (pinned_blkg)
-		blkg_put(pinned_blkg);
-	if (pd_prealloc)
-		pol->pd_free_fn(pd_prealloc);
 	return ret;
 
 enomem:
 	/* alloc failed, take down everything */
-	mutex_lock(&q->blkcg_mutex);
 	list_for_each_entry(blkg, &q->blkg_list, q_node)
 		blkg_free_policy_data(blkg, pol);
 	ret = -ENOMEM;
-- 
2.51.0

