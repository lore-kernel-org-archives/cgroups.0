Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2438F651;
	Sun, 23 Aug 2026 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787498997; cv=none; b=pX8Y3Nc3RDXLFmKrECXaYP107mLhH2y4l2eoq5iRUXPlZC9Ztk7gEFMj/QRz1LdhKs6ZornCktWEZMly1kZoUhaCUzDF/3C7ACTGRhZE2Z0FZCDzjOyHijK6S1CBzTFgCX7QzHALlnJDcKc1ALf40bwsVW4fY4hytyNqM8h5BE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787498997; c=relaxed/simple;
	bh=1U4e9V38ZzDnZ/zD8kFocqVQ6dW4tN9HZ91X0pi6iO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NR2whJyzn3Cqil5f1DOZcL8UWh6gGrD4zMqL2LPI/dyrS6ssLoTOf9WxMVu05RbS/conzw5+/yMqkZ6wdyihRUJ5SfKl1fHNAVs75GVEb3T6GfrN+Cw6ves1afb1T5S6AlJR+6rLMAl3E9n1acmzS0tLHpa9CkkVsgX4gwUw3AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUciHw8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUciHw8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C755F1F000E9;
	Sun, 23 Aug 2026 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787498992;
	bh=El/XT7hdwqWl1/0Red4A0YufWLRO62Hp/16joI5fn1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUciHw8vR2Ek2Iou6QaO9HjG0c3x9ZPE5008+lNW6rUvK9JwxieMz6uj1I0LtbElZ
	 Epxd+dqqapdjjFYmVs2BnaxQ+9Uk12Rvb7aZqoPGxRIjlrUzYogmEwLn+YtSin3BsA
	 OOZTnE9eBaJlzFcgQZ3TuB/25GWP5FjBnq4lSf1uhbdDUc/eMTbm8VQkswq5n0GLvR
	 Zxju3pYFLWzWfOu23tQxwTILVWjWvekN4kRN7sgECgnMC98M90UCgi8+7dIvWBydma
	 cgPjwqB7cIN6rQ2ECMzQ3JxHd7Vu/fL1GHpoLTE3GrulkZJRs/pSixAralp2jKDfCH
	 y0NXSTya667/g==
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
Subject: [RFC PATCH v3 2/6] blk-throttle: protect throttle state with td lock
Date: Sun, 23 Aug 2026 23:29:21 +0800
Message-ID: <20260823152926.1043863-3-yukuai@kernel.org>
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

Throttle currently uses queue_lock for both blkcg topology and its own
runtime state. This blocks moving blkg topology protection to blkcg_mutex
cleanly.

Add a throttle-private spinlock and use it for throttle service queues,
pending timers, runtime counters and config updates. Keep queue_lock only
where the current intermediate code still walks blkcg topology.

blkg_destroy_all() offlines policy data, but the data is freed
asynchronously. A per-group pending timer can therefore outlive
blk_throtl_exit(), which frees td before the policy data is released.
Previously, the timer callback took queue_lock and checked q->root_blkg
before dereferencing td, so a late per-group callback exited after
teardown. Once the callback takes td->lock, it dereferences td before that
check and can access freed memory.

Shut down all per-group and top-level timers before freeing td. Use
timer_shutdown_sync() instead of timer_delete_sync() because this is final
teardown: it waits for active callbacks and prevents any later mod_timer()
from rearming the timer. Use the same shutdown semantics before freeing a
throtl_grp.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-throttle.c | 87 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 67 insertions(+), 20 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3828c3857900..2ff30700e84e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -28,10 +28,13 @@ static struct workqueue_struct *kthrotld_workqueue;
 
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
 
 struct throtl_data
 {
+	/* protects throttle service queues and group runtime state */
+	spinlock_t lock;
+
 	/* service tree for active throtl groups */
 	struct throtl_service_queue service_queue;
 
 	struct request_queue *queue;
 
@@ -344,15 +347,20 @@ static void tg_update_has_rules(struct throtl_grp *tg)
 }
 
 static void throtl_pd_online(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
+	struct throtl_data *td = tg->td;
+	unsigned long flags;
+
+	spin_lock_irqsave(&td->lock, flags);
 	/*
 	 * We don't want new groups to escape the limits of its ancestors.
 	 * Update has_rules[] after a new group is brought online.
 	 */
 	tg_update_has_rules(tg);
+	spin_unlock_irqrestore(&td->lock, flags);
 }
 
 static void tg_release(struct rcu_head *rcu)
 {
 	struct blkg_policy_data *pd =
@@ -366,11 +374,11 @@ static void tg_release(struct rcu_head *rcu)
 
 static void throtl_pd_free(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
 
-	timer_delete_sync(&tg->service_queue.pending_timer);
+	timer_shutdown_sync(&tg->service_queue.pending_timer);
 	call_rcu(&pd->rcu_head, tg_release);
 }
 
 static struct throtl_grp *
 throtl_rb_first(struct throtl_service_queue *parent_sq)
@@ -1140,13 +1148,13 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 	if (tg)
 		q = tg->pd.blkg->q;
 	else
 		q = td->queue;
 
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irq(&td->lock);
 
-	if (!q->root_blkg)
+	if (!READ_ONCE(q->root_blkg))
 		goto out_unlock;
 
 again:
 	parent_sq = sq->parent_sq;
 	dispatched = false;
@@ -1166,13 +1174,13 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 
 		if (throtl_schedule_next_dispatch(sq, false))
 			break;
 
 		/* this dispatch windows is still open, relax and repeat */
-		spin_unlock_irq(&q->queue_lock);
+		spin_unlock_irq(&td->lock);
 		cpu_relax();
-		spin_lock_irq(&q->queue_lock);
+		spin_lock_irq(&td->lock);
 	}
 
 	if (!dispatched)
 		goto out_unlock;
 
@@ -1191,11 +1199,11 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 	} else {
 		/* reached the top-level, queue issuing */
 		queue_work(kthrotld_workqueue, &td->dispatch_work);
 	}
 out_unlock:
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&td->lock);
 }
 
 /**
  * blk_throtl_dispatch_work_fn - work function for throtl_data->dispatch_work
  * @work: work item being executed
@@ -1207,23 +1215,22 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 {
 	struct throtl_data *td = container_of(work, struct throtl_data,
 					      dispatch_work);
 	struct throtl_service_queue *td_sq = &td->service_queue;
-	struct request_queue *q = td->queue;
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 	struct blk_plug plug;
 	int rw;
 
 	bio_list_init(&bio_list_on_stack);
 
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irq(&td->lock);
 	for (rw = READ; rw <= WRITE; rw++)
 		while ((bio = throtl_pop_queued(td_sq, NULL, rw)))
 			bio_list_add(&bio_list_on_stack, bio);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&td->lock);
 
 	if (!bio_list_empty(&bio_list_on_stack)) {
 		blk_start_plug(&plug);
 		while ((bio = bio_list_pop(&bio_list_on_stack)))
 			submit_bio_noacct_nocheck(bio, false);
@@ -1297,11 +1304,11 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 			continue;
 	}
 	rcu_read_unlock();
 
 	/*
-	 * We're already holding queue_lock and know @tg is valid.  Let's
+	 * We're already holding td->lock and know @tg is valid.  Let's
 	 * apply the new config directly.
 	 *
 	 * Restart the slices for both READ and WRITES. It might happen
 	 * that a group's limit are dropped suddenly and we don't want to
 	 * account recently dispatched IO with new low rate.
@@ -1325,10 +1332,11 @@ static int blk_throtl_init(struct gendisk *disk)
 	td = kzalloc_node(sizeof(*td), GFP_KERNEL, q->node);
 	if (!td)
 		return -ENOMEM;
 
 	INIT_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
+	spin_lock_init(&td->lock);
 	throtl_service_queue_init(&td->service_queue);
 
 	memflags = blk_mq_freeze_queue(disk->queue);
 	blk_mq_quiesce_queue(disk->queue);
 
@@ -1379,18 +1387,20 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 		goto unprep;
 	if (!v)
 		v = U64_MAX;
 
 	tg = blkg_to_tg(ctx.blkg);
+	spin_lock_irq(&tg->td->lock);
 	tg_update_carryover(tg);
 
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
 	else
 		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
 
 	tg_conf_updated(tg, false);
+	spin_unlock_irq(&tg->td->lock);
 	ret = 0;
 
 unprep:
 	blkg_conf_unprep(&ctx);
 
@@ -1561,10 +1571,11 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 	ret = blkg_conf_prep(blkcg, &blkcg_policy_throtl, &ctx);
 	if (ret)
 		goto close_bdev;
 
 	tg = blkg_to_tg(ctx.blkg);
+	spin_lock_irq(&tg->td->lock);
 	tg_update_carryover(tg);
 
 	v[0] = tg->bps[READ];
 	v[1] = tg->bps[WRITE];
 	v[2] = tg->iops[READ];
@@ -1584,15 +1595,15 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 
 		ret = -EINVAL;
 		p = tok;
 		strsep(&p, "=");
 		if (!p || (sscanf(p, "%llu", &val) != 1 && strcmp(p, "max")))
-			goto unprep;
+			goto unlock;
 
 		ret = -ERANGE;
 		if (!val)
-			goto unprep;
+			goto unlock;
 
 		ret = -EINVAL;
 		if (!strcmp(tok, "rbps"))
 			v[0] = val;
 		else if (!strcmp(tok, "wbps"))
@@ -1600,20 +1611,24 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 		else if (!strcmp(tok, "riops"))
 			v[2] = min_t(u64, val, UINT_MAX);
 		else if (!strcmp(tok, "wiops"))
 			v[3] = min_t(u64, val, UINT_MAX);
 		else
-			goto unprep;
+			goto unlock;
 	}
 
 	tg->bps[READ] = v[0];
 	tg->bps[WRITE] = v[1];
 	tg->iops[READ] = v[2];
 	tg->iops[WRITE] = v[3];
 
 	tg_conf_updated(tg, false);
+	spin_unlock_irq(&tg->td->lock);
 	ret = 0;
+	goto unprep;
+unlock:
+	spin_unlock_irq(&tg->td->lock);
 unprep:
 	blkg_conf_unprep(&ctx);
 close_bdev:
 	blkg_conf_close_bdev(&ctx);
 	return ret ?: nbytes;
@@ -1634,10 +1649,32 @@ static void throtl_shutdown_wq(struct request_queue *q)
 	struct throtl_data *td = q->td;
 
 	cancel_work_sync(&td->dispatch_work);
 }
 
+static void throtl_shutdown_timers(struct request_queue *q)
+{
+	struct throtl_data *td = q->td;
+	struct blkcg_gq *blkg;
+
+	/*
+	 * blkg_destroy_all() has already offlined the policy, but blkg policy
+	 * data is freed asynchronously.  Shut down per-group timers before
+	 * freeing td, as their callbacks still dereference tg->td.
+	 */
+	mutex_lock(&q->blkcg_mutex);
+	list_for_each_entry(blkg, &q->blkg_list, q_node) {
+		struct throtl_grp *tg = blkg_to_tg(blkg);
+
+		if (tg)
+			timer_shutdown_sync(&tg->service_queue.pending_timer);
+	}
+	mutex_unlock(&q->blkcg_mutex);
+
+	timer_shutdown_sync(&td->service_queue.pending_timer);
+}
+
 static void tg_flush_bios(struct throtl_grp *tg)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 
 	if (tg->flags & THROTL_TG_CANCELING)
@@ -1667,11 +1704,17 @@ static void tg_flush_bios(struct throtl_grp *tg)
 	throtl_schedule_next_dispatch(sq->parent_sq, true);
 }
 
 static void throtl_pd_offline(struct blkg_policy_data *pd)
 {
-	tg_flush_bios(pd_to_tg(pd));
+	struct throtl_grp *tg = pd_to_tg(pd);
+	struct throtl_data *td = tg->td;
+	unsigned long flags;
+
+	spin_lock_irqsave(&td->lock, flags);
+	tg_flush_bios(tg);
+	spin_unlock_irqrestore(&td->lock, flags);
 }
 
 struct blkcg_policy blkcg_policy_throtl = {
 	.dfl_cftypes		= throtl_files,
 	.legacy_cftypes		= throtl_legacy_files,
@@ -1723,19 +1766,21 @@ static void tg_cancel_writeback_bios(struct throtl_grp *tg,
 }
 
 void blk_throtl_cancel_bios(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
+	struct throtl_data *td = q->td;
 	struct cgroup_subsys_state *pos_css;
 	struct blkcg_gq *blkg;
 	struct bio_list cancel_bios[2] = { };
 	int rw;
 
 	if (!blk_throtl_activated(q))
 		return;
 
 	spin_lock_irq(&q->queue_lock);
+	spin_lock(&td->lock);
 	/*
 	 * queue_lock is held, rcu lock is not needed here technically.
 	 * However, rcu lock is still held to emphasize that following
 	 * path need RCU protection and to prevent warning from lockdep.
 	 */
@@ -1750,10 +1795,11 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
 		 * del_gendisk.
 		 */
 		tg_cancel_writeback_bios(blkg_to_tg(blkg), cancel_bios);
 	}
 	rcu_read_unlock();
+	spin_unlock(&td->lock);
 	spin_unlock_irq(&q->queue_lock);
 
 	for (rw = READ; rw <= WRITE; rw++) {
 		struct bio *bio;
 		while ((bio = bio_list_pop(&cancel_bios[rw])))
@@ -1789,21 +1835,20 @@ static bool tg_within_limit(struct throtl_grp *tg, struct bio *bio, bool rw)
 	return tg_dispatch_time(tg, bio) == 0;
 }
 
 bool __blk_throtl_bio(struct bio *bio)
 {
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	struct blkcg_gq *blkg = bio_blkg(bio);
 	struct throtl_qnode *qn = NULL;
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_service_queue *sq;
 	bool rw = bio_data_dir(bio);
 	bool throttled = false;
 	struct throtl_data *td = tg->td;
 
 	rcu_read_lock();
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irq(&td->lock);
 	sq = &tg->service_queue;
 
 	while (true) {
 		if (tg_within_limit(tg, bio, rw)) {
 			/* within limits, let's charge and dispatch directly */
@@ -1875,30 +1920,32 @@ bool __blk_throtl_bio(struct bio *bio)
 		tg_update_disptime(tg);
 		throtl_schedule_next_dispatch(tg->service_queue.parent_sq, true);
 	}
 
 out_unlock:
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&td->lock);
 
 	rcu_read_unlock();
 	return throttled;
 }
 
 void blk_throtl_exit(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
+	struct throtl_data *td = q->td;
 
 	/*
 	 * blkg_destroy_all() already deactivate throtl policy, just check and
 	 * free throtl data.
 	 */
-	if (!q->td)
+	if (!td)
 		return;
 
-	timer_delete_sync(&q->td->service_queue.pending_timer);
+	throtl_shutdown_timers(q);
 	throtl_shutdown_wq(q);
-	kfree(q->td);
+	q->td = NULL;
+	kfree(td);
 }
 
 static int __init throtl_init(void)
 {
 	kthrotld_workqueue = alloc_workqueue("kthrotld", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
-- 
2.51.0

