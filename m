From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/27] blk-iocost: rename propagate_active_weights() to propagate_weights()
Date: Tue,  1 Sep 2020 14:52:34 -0400
Message-ID: <20200901185257.645114-5-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Abijl0OmP6VYSflgQEhNpTgXbVq6GxdxWWrhkCH99jc=;
        b=BYrK0zSLvPdaANXkzCXqODMBDKe5h7ipVdn2xiRVWxu7y4qoGlbLsat7aKgGV2NzAX
         uA9xTg2W43pbV3T1KFcjp4McIbz8C7Z9y+4lVi0pNw5/4LtQdhb95BWCEs+uWaml2W9j
         QvwuHJONksBt2KE09l+I1qkK15+vvKFyOd6venv28WwjFQaNa1WW0wUIiCKkvCB1qLG7
         MIWBSC3WrHgH3Wa2mh62XUb7i74iR0JuJMWm91KrNQIIlLW7d/CPJhKqVvICdX41A4eB
         UjHfd1CFFydEXixQ5tAReP0xL5GurO/+lMrr530F1YkcYn1cpAO3ght+hgZFzYk4wj5x
         xFGw==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

It already propagates two weights - active and inuse - and there will be
another soon. Let's drop the confusing misnomers. Rename
[__]propagate_active_weights() to [__]propagate_weights() and
commit_active_weights() to commit_weights().

This is pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e2266e7692b4..78e6919153d8 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -479,7 +479,7 @@ struct ioc_gq {
 	atomic64_t			active_period;
 	struct list_head		active_list;
 
-	/* see __propagate_active_weight() and current_hweight() for details */
+	/* see __propagate_weights() and current_hweight() for details */
 	u64				child_active_sum;
 	u64				child_inuse_sum;
 	int				hweight_gen;
@@ -890,7 +890,7 @@ static void ioc_start_period(struct ioc *ioc, struct ioc_now *now)
  * Update @iocg's `active` and `inuse` to @active and @inuse, update level
  * weight sums and propagate upwards accordingly.
  */
-static void __propagate_active_weight(struct ioc_gq *iocg, u32 active, u32 inuse)
+static void __propagate_weights(struct ioc_gq *iocg, u32 active, u32 inuse)
 {
 	struct ioc *ioc = iocg->ioc;
 	int lvl;
@@ -935,7 +935,7 @@ static void __propagate_active_weight(struct ioc_gq *iocg, u32 active, u32 inuse
 	ioc->weights_updated = true;
 }
 
-static void commit_active_weights(struct ioc *ioc)
+static void commit_weights(struct ioc *ioc)
 {
 	lockdep_assert_held(&ioc->lock);
 
@@ -947,10 +947,10 @@ static void commit_active_weights(struct ioc *ioc)
 	}
 }
 
-static void propagate_active_weight(struct ioc_gq *iocg, u32 active, u32 inuse)
+static void propagate_weights(struct ioc_gq *iocg, u32 active, u32 inuse)
 {
-	__propagate_active_weight(iocg, active, inuse);
-	commit_active_weights(iocg->ioc);
+	__propagate_weights(iocg, active, inuse);
+	commit_weights(iocg->ioc);
 }
 
 static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep)
@@ -966,9 +966,9 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 		goto out;
 
 	/*
-	 * Paired with wmb in commit_active_weights().  If we saw the
-	 * updated hweight_gen, all the weight updates from
-	 * __propagate_active_weight() are visible too.
+	 * Paired with wmb in commit_weights(). If we saw the updated
+	 * hweight_gen, all the weight updates from __propagate_weights() are
+	 * visible too.
 	 *
 	 * We can race with weight updates during calculation and get it
 	 * wrong.  However, hweight_gen would have changed and a future
@@ -1018,7 +1018,7 @@ static void weight_updated(struct ioc_gq *iocg)
 
 	weight = iocg->cfg_weight ?: iocc->dfl_weight;
 	if (weight != iocg->weight && iocg->active)
-		propagate_active_weight(iocg, weight,
+		propagate_weights(iocg, weight,
 			DIV64_U64_ROUND_UP(iocg->inuse * weight, iocg->weight));
 	iocg->weight = weight;
 }
@@ -1090,8 +1090,8 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 	 */
 	iocg->hweight_gen = atomic_read(&ioc->hweight_gen) - 1;
 	list_add(&iocg->active_list, &ioc->active_iocgs);
-	propagate_active_weight(iocg, iocg->weight,
-				iocg->last_inuse ?: iocg->weight);
+	propagate_weights(iocg, iocg->weight,
+			  iocg->last_inuse ?: iocg->weight);
 
 	TRACE_IOCG_PATH(iocg_activate, iocg, now,
 			last_period, cur_period, vtime);
@@ -1384,13 +1384,13 @@ static void ioc_timer_fn(struct timer_list *timer)
 		} else if (iocg_is_idle(iocg)) {
 			/* no waiter and idle, deactivate */
 			iocg->last_inuse = iocg->inuse;
-			__propagate_active_weight(iocg, 0, 0);
+			__propagate_weights(iocg, 0, 0);
 			list_del_init(&iocg->active_list);
 		}
 
 		spin_unlock(&iocg->waitq.lock);
 	}
-	commit_active_weights(ioc);
+	commit_weights(ioc);
 
 	/* calc usages and see whether some weights need to be moved around */
 	list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
@@ -1483,8 +1483,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 				TRACE_IOCG_PATH(inuse_takeback, iocg, &now,
 						iocg->inuse, new_inuse,
 						hw_inuse, new_hwi);
-				__propagate_active_weight(iocg, iocg->weight,
-							  new_inuse);
+				__propagate_weights(iocg, iocg->weight,
+						    new_inuse);
 			}
 		} else {
 			/* genuninely out of vtime */
@@ -1524,11 +1524,11 @@ static void ioc_timer_fn(struct timer_list *timer)
 			TRACE_IOCG_PATH(inuse_giveaway, iocg, &now,
 					iocg->inuse, new_inuse,
 					hw_inuse, new_hwi);
-			__propagate_active_weight(iocg, iocg->weight, new_inuse);
+			__propagate_weights(iocg, iocg->weight, new_inuse);
 		}
 	}
 skip_surplus_transfers:
-	commit_active_weights(ioc);
+	commit_weights(ioc);
 
 	/*
 	 * If q is getting clogged or we're missing too much, we're issuing
@@ -1753,7 +1753,7 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 		TRACE_IOCG_PATH(inuse_reset, iocg, &now,
 				iocg->inuse, iocg->weight, hw_inuse, hw_active);
 		spin_lock_irq(&ioc->lock);
-		propagate_active_weight(iocg, iocg->weight, iocg->weight);
+		propagate_weights(iocg, iocg->weight, iocg->weight);
 		spin_unlock_irq(&ioc->lock);
 		current_hweight(iocg, &hw_active, &hw_inuse);
 	}
@@ -2114,7 +2114,7 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 	if (ioc) {
 		spin_lock_irqsave(&ioc->lock, flags);
 		if (!list_empty(&iocg->active_list)) {
-			propagate_active_weight(iocg, 0, 0);
+			propagate_weights(iocg, 0, 0);
 			list_del_init(&iocg->active_list);
 		}
 		spin_unlock_irqrestore(&ioc->lock, flags);
-- 
2.26.2

