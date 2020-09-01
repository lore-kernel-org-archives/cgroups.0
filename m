From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/27] blk-iocost: grab ioc->lock for debt handling
Date: Tue,  1 Sep 2020 14:52:42 -0400
Message-ID: <20200901185257.645114-13-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SS4MWJ4/XFRWZ111xGt7boFuHdhcJQ+ioHm3dskasW8=;
        b=aLzLHjIw3l5Y/zlJrrHpxgwVyA9EN030ZQbfbIo3PBVwwTgPkmMOdf2lHRGRx/2Oi8
         idOJ3H1mbEU1lLN6LBjA5Mt2jXrmoWPiqxTY4/xh2gpBLDetXWS3s8noEQ1FZqgOrqAB
         fTNTZWN7xcg6f5w0l1hsm8kqAdUbkzvn9jYJXCiBRsyhPqePSFVTQgy3Rl/hnpzQepp3
         yLedbrzxfCElwnwJFLppHckD4N0/gnFDQ5y5gwIcV2KKj2aToa89KQ+qtUAGoNI3RxAd
         RQvW+HLM160JH1h2k9JglmwA5bDn7f0Zm2CT/fibZk3uavdltl7XPsFbK3zAdqYx+vXZ
         zMlw==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

Currently, debt handling requires only iocg->waitq.lock. In the future, we
want to adjust and propagate inuse changes depending on debt status. Let's
grab ioc->lock in debt handling paths in preparation.

* Because ioc->lock nests outside iocg->waitq.lock, the decision to grab
  ioc->lock needs to be made before entering the critical sections.

* Add and use iocg_[un]lock() which handles the conditional double locking.

* Add @pay_debt to iocg_kick_waitq() so that debt payment happens only when
  the caller grabbed both locks.

This patch is prepatory and the comments contain references to future
changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 92 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 19 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index f36988657594..23b173e34591 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -680,6 +680,26 @@ static void iocg_commit_bio(struct ioc_gq *iocg, struct bio *bio, u64 cost)
 	atomic64_add(cost, &iocg->vtime);
 }
 
+static void iocg_lock(struct ioc_gq *iocg, bool lock_ioc, unsigned long *flags)
+{
+	if (lock_ioc) {
+		spin_lock_irqsave(&iocg->ioc->lock, *flags);
+		spin_lock(&iocg->waitq.lock);
+	} else {
+		spin_lock_irqsave(&iocg->waitq.lock, *flags);
+	}
+}
+
+static void iocg_unlock(struct ioc_gq *iocg, bool unlock_ioc, unsigned long *flags)
+{
+	if (unlock_ioc) {
+		spin_unlock(&iocg->waitq.lock);
+		spin_unlock_irqrestore(&iocg->ioc->lock, *flags);
+	} else {
+		spin_unlock_irqrestore(&iocg->waitq.lock, *flags);
+	}
+}
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/iocost.h>
 
@@ -1215,11 +1235,17 @@ static int iocg_wake_fn(struct wait_queue_entry *wq_entry, unsigned mode,
 	return 0;
 }
 
-static void iocg_kick_waitq(struct ioc_gq *iocg, struct ioc_now *now)
+/*
+ * Calculate the accumulated budget, pay debt if @pay_debt and wake up waiters
+ * accordingly. When @pay_debt is %true, the caller must be holding ioc->lock in
+ * addition to iocg->waitq.lock.
+ */
+static void iocg_kick_waitq(struct ioc_gq *iocg, bool pay_debt,
+			    struct ioc_now *now)
 {
 	struct ioc *ioc = iocg->ioc;
 	struct iocg_wake_ctx ctx = { .iocg = iocg };
-	u64 vdebt, vshortage, expires, oexpires;
+	u64 vshortage, expires, oexpires;
 	s64 vbudget;
 	u32 hw_inuse;
 
@@ -1229,25 +1255,39 @@ static void iocg_kick_waitq(struct ioc_gq *iocg, struct ioc_now *now)
 	vbudget = now->vnow - atomic64_read(&iocg->vtime);
 
 	/* pay off debt */
-	vdebt = abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
-	if (vdebt && vbudget > 0) {
+	if (pay_debt && iocg->abs_vdebt && vbudget > 0) {
+		u64 vdebt = abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
 		u64 delta = min_t(u64, vbudget, vdebt);
 		u64 abs_delta = min(cost_to_abs_cost(delta, hw_inuse),
 				    iocg->abs_vdebt);
 
+		lockdep_assert_held(&ioc->lock);
+
 		atomic64_add(delta, &iocg->vtime);
 		atomic64_add(delta, &iocg->done_vtime);
 		iocg->abs_vdebt -= abs_delta;
+		vbudget -= vdebt;
 
 		iocg_kick_delay(iocg, now);
 	}
 
+	/*
+	 * Debt can still be outstanding if we haven't paid all yet or the
+	 * caller raced and called without @pay_debt. Shouldn't wake up waiters
+	 * under debt. Make sure @vbudget reflects the outstanding amount and is
+	 * not positive.
+	 */
+	if (iocg->abs_vdebt) {
+		s64 vdebt = abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
+		vbudget = min_t(s64, 0, vbudget - vdebt);
+	}
+
 	/*
 	 * Wake up the ones which are due and see how much vtime we'll need
 	 * for the next one.
 	 */
 	ctx.hw_inuse = hw_inuse;
-	ctx.vbudget = vbudget - vdebt;
+	ctx.vbudget = vbudget;
 	__wake_up_locked_key(&iocg->waitq, TASK_NORMAL, &ctx);
 	if (!waitqueue_active(&iocg->waitq))
 		return;
@@ -1273,14 +1313,15 @@ static void iocg_kick_waitq(struct ioc_gq *iocg, struct ioc_now *now)
 static enum hrtimer_restart iocg_waitq_timer_fn(struct hrtimer *timer)
 {
 	struct ioc_gq *iocg = container_of(timer, struct ioc_gq, waitq_timer);
+	bool pay_debt = READ_ONCE(iocg->abs_vdebt);
 	struct ioc_now now;
 	unsigned long flags;
 
 	ioc_now(iocg->ioc, &now);
 
-	spin_lock_irqsave(&iocg->waitq.lock, flags);
-	iocg_kick_waitq(iocg, &now);
-	spin_unlock_irqrestore(&iocg->waitq.lock, flags);
+	iocg_lock(iocg, pay_debt, &flags);
+	iocg_kick_waitq(iocg, pay_debt, &now);
+	iocg_unlock(iocg, pay_debt, &flags);
 
 	return HRTIMER_NORESTART;
 }
@@ -1396,7 +1437,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 		if (waitqueue_active(&iocg->waitq) || iocg->abs_vdebt) {
 			/* might be oversleeping vtime / hweight changes, kick */
-			iocg_kick_waitq(iocg, &now);
+			iocg_kick_waitq(iocg, true, &now);
 		} else if (iocg_is_idle(iocg)) {
 			/* no waiter and idle, deactivate */
 			iocg->last_inuse = iocg->inuse;
@@ -1743,6 +1784,8 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	struct iocg_wait wait;
 	u32 hw_active, hw_inuse;
 	u64 abs_cost, cost, vtime;
+	bool use_debt, ioc_locked;
+	unsigned long flags;
 
 	/* bypass IOs if disabled or for root cgroup */
 	if (!ioc->enabled || !iocg->level)
@@ -1786,15 +1829,26 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	}
 
 	/*
-	 * We activated above but w/o any synchronization. Deactivation is
-	 * synchronized with waitq.lock and we won't get deactivated as long
-	 * as we're waiting or has debt, so we're good if we're activated
-	 * here. In the unlikely case that we aren't, just issue the IO.
+	 * We're over budget. This can be handled in two ways. IOs which may
+	 * cause priority inversions are punted to @ioc->aux_iocg and charged as
+	 * debt. Otherwise, the issuer is blocked on @iocg->waitq. Debt handling
+	 * requires @ioc->lock, waitq handling @iocg->waitq.lock. Determine
+	 * whether debt handling is needed and acquire locks accordingly.
 	 */
-	spin_lock_irq(&iocg->waitq.lock);
+	use_debt = bio_issue_as_root_blkg(bio) || fatal_signal_pending(current);
+	ioc_locked = use_debt || READ_ONCE(iocg->abs_vdebt);
 
+	iocg_lock(iocg, ioc_locked, &flags);
+
+	/*
+	 * @iocg must stay activated for debt and waitq handling. Deactivation
+	 * is synchronized against both ioc->lock and waitq.lock and we won't
+	 * get deactivated as long as we're waiting or has debt, so we're good
+	 * if we're activated here. In the unlikely cases that we aren't, just
+	 * issue the IO.
+	 */
 	if (unlikely(list_empty(&iocg->active_list))) {
-		spin_unlock_irq(&iocg->waitq.lock);
+		iocg_unlock(iocg, ioc_locked, &flags);
 		iocg_commit_bio(iocg, bio, cost);
 		return;
 	}
@@ -1816,12 +1870,12 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	 * clear them and leave @iocg inactive w/ dangling use_delay heavily
 	 * penalizing the cgroup and its descendants.
 	 */
-	if (bio_issue_as_root_blkg(bio) || fatal_signal_pending(current)) {
+	if (use_debt) {
 		iocg->abs_vdebt += abs_cost;
 		if (iocg_kick_delay(iocg, &now))
 			blkcg_schedule_throttle(rqos->q,
 					(bio->bi_opf & REQ_SWAP) == REQ_SWAP);
-		spin_unlock_irq(&iocg->waitq.lock);
+		iocg_unlock(iocg, ioc_locked, &flags);
 		return;
 	}
 
@@ -1845,9 +1899,9 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	wait.committed = false;	/* will be set true by waker */
 
 	__add_wait_queue_entry_tail(&iocg->waitq, &wait.wait);
-	iocg_kick_waitq(iocg, &now);
+	iocg_kick_waitq(iocg, ioc_locked, &now);
 
-	spin_unlock_irq(&iocg->waitq.lock);
+	iocg_unlock(iocg, ioc_locked, &flags);
 
 	while (true) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-- 
2.26.2

