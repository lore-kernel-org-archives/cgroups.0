From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/27] blk-iocost: replace iocg->has_surplus with ->surplus_list
Date: Tue,  1 Sep 2020 14:52:45 -0400
Message-ID: <20200901185257.645114-16-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0YDXgIA1K+ZfhGe/lwGuhu8ktkywG9yY1AryQl3mCGI=;
        b=IJmpZv9OQ33NuZ5oIRloUIYTVC+/7+sFOK4ttwgkljaMn7IlEN3iV9lyqBOcQqR0uC
         fwmhnl4FPImWoZiBbyHRJG7BhYHTcuwWeuA54PjTv94oC59xUbUSRaXZm0d1u0i0AgYu
         VFG9TRDpU+0m6LQncYEC0A5mt8TlqhsdiugpoKm41gZCnPKxSRU3IDDOcBMB1NblhHPK
         GVJnObVjUVwmT6IA68FmGkXSCc2OePwnWp3hj3w6ZBwRNA9cojz8L8AQrQabiMOi6+0q
         RA6z5tL8/qJ+Ijd6WL/WCnnAezrfV1dSNNTMG500KIQ8kqcLYJREcXLI1md16F1TUv9i
         gSxg==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

Instead of marking iocgs with surplus with a flag and filtering for them
while walking all active iocgs, build a surpluses list. This doesn't make
much difference now but will help implementing improved donation logic which
will iterate iocgs with surplus multiple times.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2496674bbbf4..c1cd66cfa2a8 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -494,9 +494,9 @@ struct ioc_gq {
 	int				hweight_gen;
 	u32				hweight_active;
 	u32				hweight_inuse;
-	bool				has_surplus;
 
 	struct list_head		walk_list;
+	struct list_head		surplus_list;
 
 	struct wait_queue_head		waitq;
 	struct hrtimer			waitq_timer;
@@ -1507,6 +1507,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	struct ioc *ioc = container_of(timer, struct ioc, timer);
 	struct ioc_gq *iocg, *tiocg;
 	struct ioc_now now;
+	LIST_HEAD(surpluses);
 	int nr_surpluses = 0, nr_shortages = 0, nr_lagging = 0;
 	u32 ppm_rthr = MILLION - ioc->params.qos[QOS_RPPM];
 	u32 ppm_wthr = MILLION - ioc->params.qos[QOS_WPPM];
@@ -1630,8 +1631,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 		/* see whether there's surplus vtime */
 		vmin = now.vnow - ioc->margins.max;
 
-		iocg->has_surplus = false;
-
+		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
 		if (!waitqueue_active(&iocg->waitq) &&
 		    time_before64(vtime, vmin)) {
 			u64 delta = vmin - vtime;
@@ -1641,7 +1641,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 			atomic64_add(delta, &iocg->done_vtime);
 			/* if usage is sufficiently low, maybe it can donate */
 			if (surplus_adjusted_hweight_inuse(usage, hw_inuse)) {
-				iocg->has_surplus = true;
+				list_add(&iocg->surplus_list, &surpluses);
 				nr_surpluses++;
 			}
 		} else if (hw_inuse < hw_active) {
@@ -1677,13 +1677,10 @@ static void ioc_timer_fn(struct timer_list *timer)
 		goto skip_surplus_transfers;
 
 	/* there are both shortages and surpluses, transfer surpluses */
-	list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
+	list_for_each_entry(iocg, &surpluses, surplus_list) {
 		u32 usage, hw_active, hw_inuse, new_hwi, new_inuse;
 		int nr_valid = 0;
 
-		if (!iocg->has_surplus)
-			continue;
-
 		/* base the decision on max historical usage */
 		for (i = 0, usage = 0; i < NR_USAGE_SLOTS; i++) {
 			if (iocg->usages[i]) {
@@ -1711,6 +1708,10 @@ static void ioc_timer_fn(struct timer_list *timer)
 skip_surplus_transfers:
 	commit_weights(ioc);
 
+	/* surplus list should be dissolved after use */
+	list_for_each_entry_safe(iocg, tiocg, &surpluses, surplus_list)
+		list_del_init(&iocg->surplus_list);
+
 	/*
 	 * If q is getting clogged or we're missing too much, we're issuing
 	 * too much IO and should lower vtime rate.  If we're not missing
@@ -2284,6 +2285,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	atomic64_set(&iocg->active_period, atomic64_read(&ioc->cur_period));
 	INIT_LIST_HEAD(&iocg->active_list);
 	INIT_LIST_HEAD(&iocg->walk_list);
+	INIT_LIST_HEAD(&iocg->surplus_list);
 	iocg->hweight_active = WEIGHT_ONE;
 	iocg->hweight_inuse = WEIGHT_ONE;
 
@@ -2320,6 +2322,7 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 		}
 
 		WARN_ON_ONCE(!list_empty(&iocg->walk_list));
+		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
 
 		spin_unlock_irqrestore(&ioc->lock, flags);
 
-- 
2.26.2

