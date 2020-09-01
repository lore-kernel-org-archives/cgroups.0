From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/27] blk-iocost: restructure surplus donation logic
Date: Tue,  1 Sep 2020 14:52:47 -0400
Message-ID: <20200901185257.645114-18-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K3TiqQ6XoBnoO+Au4OZsHz6VfSjY8XgXmAHVlPD4pKE=;
        b=hCgv4Sg/jsBTk4NVkOay3mp7QlI5e4hqnj91u6kgsrQHPvFpsZztMVghTYelPwRF5M
         SKPoSe57Z9aebw01UCHrdiRaLrTYYQHYly0y2IkaXrA2e+o74oNIMPvRZ14IEIVYfhKN
         AJXwWvl6vSCWmSjGoExdW2jgNOFNZLtkIwwDi0MP9INvgODvAn++h7ugv0imeVcqhFBF
         QB85GcjedsubivHx9fOTBPEZOSt7RPcqJlMaXn/Mmyoekcf1JavMOtkUUvNXVq/U2N6s
         qpXizaPDXWHF7d1zvmD4yEV47vKzDEjJDVRQ1TsXF90DMIek87maIsL7issKbeiMJjbS
         b0yA==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

The way the surplus donation logic is structured isn't great. There are two
separate paths for starting/increasing donations and decreasing them making
the logic harder to follow and is prone to unnecessary behavior differences.

In preparation for improved donation handling, this patch restructures the
code so that

* All donors - new, increasing and decreasing - are funneled through the
  same code path.

* The target donation calculation is factored into hweight_after_donation()
  which is called once from the same spot for all possible donors.

* Actual inuse adjustment is factored into trasnfer_surpluses().

This change introduces a few behavior differences - e.g. donation amount
reduction now uses the max usage of the recent three periods just like new
and increasing donations, and inuse now gets adjusted upwards the same way
it gets downwards. These differences are unlikely to have severely negative
implications and the whole logic will be revamped soon.

This patch also removes two tracepoints. The existing TPs don't quite fit
the new implementation. A later patch will update and reinstate them.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 179 ++++++++++++++++++++++++++-------------------
 1 file changed, 103 insertions(+), 76 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a3889a8b0a33..61b008d0801f 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -494,6 +494,7 @@ struct ioc_gq {
 	int				hweight_gen;
 	u32				hweight_active;
 	u32				hweight_inuse;
+	u32				hweight_after_donation;
 
 	struct list_head		walk_list;
 	struct list_head		surplus_list;
@@ -1070,6 +1071,32 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 		*hw_inusep = iocg->hweight_inuse;
 }
 
+/*
+ * Calculate the hweight_inuse @iocg would get with max @inuse assuming all the
+ * other weights stay unchanged.
+ */
+static u32 current_hweight_max(struct ioc_gq *iocg)
+{
+	u32 hwm = WEIGHT_ONE;
+	u32 inuse = iocg->active;
+	u64 child_inuse_sum;
+	int lvl;
+
+	lockdep_assert_held(&iocg->ioc->lock);
+
+	for (lvl = iocg->level - 1; lvl >= 0; lvl--) {
+		struct ioc_gq *parent = iocg->ancestors[lvl];
+		struct ioc_gq *child = iocg->ancestors[lvl + 1];
+
+		child_inuse_sum = parent->child_inuse_sum + inuse - child->inuse;
+		hwm = div64_u64((u64)hwm * inuse, child_inuse_sum);
+		inuse = DIV64_U64_ROUND_UP(parent->active * child_inuse_sum,
+					   parent->child_active_sum);
+	}
+
+	return max_t(u32, hwm, 1);
+}
+
 static void weight_updated(struct ioc_gq *iocg)
 {
 	struct ioc *ioc = iocg->ioc;
@@ -1488,20 +1515,58 @@ static void iocg_flush_stat(struct list_head *target_iocgs, struct ioc_now *now)
 	}
 }
 
-/* returns usage with margin added if surplus is large enough */
-static u32 surplus_adjusted_hweight_inuse(u32 usage, u32 hw_inuse)
+/*
+ * Determine what @iocg's hweight_inuse should be after donating unused
+ * capacity. @hwm is the upper bound and used to signal no donation. This
+ * function also throws away @iocg's excess budget.
+ */
+static u32 hweight_after_donation(struct ioc_gq *iocg, u32 hwm, u32 usage,
+				  struct ioc_now *now)
 {
+	struct ioc *ioc = iocg->ioc;
+	u64 vtime = atomic64_read(&iocg->vtime);
+	s64 excess;
+
+	/* see whether minimum margin requirement is met */
+	if (waitqueue_active(&iocg->waitq) ||
+	    time_after64(vtime, now->vnow - ioc->margins.min))
+		return hwm;
+
+	/* throw away excess above max */
+	excess = now->vnow - vtime - ioc->margins.max;
+	if (excess > 0) {
+		atomic64_add(excess, &iocg->vtime);
+		atomic64_add(excess, &iocg->done_vtime);
+		vtime += excess;
+	}
+
 	/* add margin */
 	usage = DIV_ROUND_UP(usage * SURPLUS_SCALE_PCT, 100);
 	usage += SURPLUS_SCALE_ABS;
 
 	/* don't bother if the surplus is too small */
-	if (usage + SURPLUS_MIN_ADJ_DELTA > hw_inuse)
-		return 0;
+	if (usage + SURPLUS_MIN_ADJ_DELTA > hwm)
+		return hwm;
 
 	return usage;
 }
 
+static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
+{
+	struct ioc_gq *iocg;
+
+	list_for_each_entry(iocg, surpluses, surplus_list) {
+		u32 old_hwi, new_hwi, new_inuse;
+
+		current_hweight(iocg, NULL, &old_hwi);
+		new_hwi = iocg->hweight_after_donation;
+
+		new_inuse = DIV64_U64_ROUND_UP((u64)iocg->inuse * new_hwi,
+					       old_hwi);
+		__propagate_weights(iocg, iocg->weight, new_inuse);
+	}
+}
+
 static void ioc_timer_fn(struct timer_list *timer)
 {
 	struct ioc *ioc = container_of(timer, struct ioc, timer);
@@ -1560,9 +1625,9 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	/* calc usages and see whether some weights need to be moved around */
 	list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
-		u64 vdone, vtime, usage_us, vmin;
+		u64 vdone, vtime, usage_us;
 		u32 hw_active, hw_inuse, usage;
-		int uidx;
+		int uidx, nr_valid;
 
 		/*
 		 * Collect unused and wind vtime closer to vnow to prevent
@@ -1618,92 +1683,54 @@ static void ioc_timer_fn(struct timer_list *timer)
 				started_at = ioc->period_at;
 
 			dur = max_t(u64, now.now - started_at, 1);
-			usage = clamp_t(u32,
+
+			iocg->usage_idx = uidx;
+			iocg->usages[uidx] = clamp_t(u32,
 				DIV64_U64_ROUND_UP(usage_us * WEIGHT_ONE, dur),
 				1, WEIGHT_ONE);
+		}
 
-			iocg->usage_idx = uidx;
-			iocg->usages[uidx] = usage;
-		} else {
-			usage = 0;
+		/* base the decision on max historical usage */
+		for (i = 0, usage = 0, nr_valid = 0; i < NR_USAGE_SLOTS; i++) {
+			if (iocg->usages[i]) {
+				usage = max(usage, iocg->usages[i]);
+				nr_valid++;
+			}
 		}
+		if (nr_valid < MIN_VALID_USAGES)
+			usage = WEIGHT_ONE;
 
 		/* see whether there's surplus vtime */
-		vmin = now.vnow - ioc->margins.max;
-
 		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
-		if (!waitqueue_active(&iocg->waitq) &&
-		    time_before64(vtime, vmin)) {
-			u64 delta = vmin - vtime;
-
-			/* throw away surplus vtime */
-			atomic64_add(delta, &iocg->vtime);
-			atomic64_add(delta, &iocg->done_vtime);
-			/* if usage is sufficiently low, maybe it can donate */
-			if (surplus_adjusted_hweight_inuse(usage, hw_inuse))
-				list_add(&iocg->surplus_list, &surpluses);
-		} else if (hw_inuse < hw_active) {
-			u32 new_hwi, new_inuse;
+		if (hw_inuse < hw_active ||
+		    (!waitqueue_active(&iocg->waitq) &&
+		     time_before64(vtime, now.vnow - ioc->margins.max))) {
+			u32 hwm, new_hwi;
 
-			/* was donating but might need to take back some */
-			if (waitqueue_active(&iocg->waitq)) {
-				new_hwi = hw_active;
+			/*
+			 * Already donating or accumulated enough to start.
+			 * Determine the donation amount.
+			 */
+			hwm = current_hweight_max(iocg);
+			new_hwi = hweight_after_donation(iocg, hwm, usage,
+							 &now);
+			if (new_hwi < hwm) {
+				iocg->hweight_after_donation = new_hwi;
+				list_add(&iocg->surplus_list, &surpluses);
 			} else {
-				new_hwi = max(hw_inuse,
-					      usage * SURPLUS_SCALE_PCT / 100 +
-					      SURPLUS_SCALE_ABS);
-			}
-
-			new_inuse = div64_u64((u64)iocg->inuse * new_hwi,
-					      hw_inuse);
-			new_inuse = clamp_t(u32, new_inuse, 1, iocg->active);
-
-			if (new_inuse > iocg->inuse) {
-				TRACE_IOCG_PATH(inuse_takeback, iocg, &now,
-						iocg->inuse, new_inuse,
-						hw_inuse, new_hwi);
-				__propagate_weights(iocg, iocg->weight,
-						    new_inuse);
+				__propagate_weights(iocg, iocg->active,
+						    iocg->active);
+				nr_shortages++;
 			}
 		} else {
-			/* genuninely out of vtime */
+			/* genuinely short on vtime */
 			nr_shortages++;
 		}
 	}
 
-	if (!nr_shortages || list_empty(&surpluses))
-		goto skip_surplus_transfers;
+	if (!list_empty(&surpluses) && nr_shortages)
+		transfer_surpluses(&surpluses, &now);
 
-	/* there are both shortages and surpluses, transfer surpluses */
-	list_for_each_entry(iocg, &surpluses, surplus_list) {
-		u32 usage, hw_active, hw_inuse, new_hwi, new_inuse;
-		int nr_valid = 0;
-
-		/* base the decision on max historical usage */
-		for (i = 0, usage = 0; i < NR_USAGE_SLOTS; i++) {
-			if (iocg->usages[i]) {
-				usage = max(usage, iocg->usages[i]);
-				nr_valid++;
-			}
-		}
-		if (nr_valid < MIN_VALID_USAGES)
-			continue;
-
-		current_hweight(iocg, &hw_active, &hw_inuse);
-		new_hwi = surplus_adjusted_hweight_inuse(usage, hw_inuse);
-		if (!new_hwi)
-			continue;
-
-		new_inuse = DIV64_U64_ROUND_UP((u64)iocg->inuse * new_hwi,
-					       hw_inuse);
-		if (new_inuse < iocg->inuse) {
-			TRACE_IOCG_PATH(inuse_giveaway, iocg, &now,
-					iocg->inuse, new_inuse,
-					hw_inuse, new_hwi);
-			__propagate_weights(iocg, iocg->weight, new_inuse);
-		}
-	}
-skip_surplus_transfers:
 	commit_weights(ioc);
 
 	/* surplus list should be dissolved after use */
-- 
2.26.2

