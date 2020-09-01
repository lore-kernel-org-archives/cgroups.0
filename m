From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/27] blk-iocost: move iocg_kick_delay() above iocg_kick_waitq()
Date: Tue,  1 Sep 2020 14:52:36 -0400
Message-ID: <20200901185257.645114-7-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=amdTNvVUod/ZAMwArtcpxqunrtULsg3CQCH6qJ0Kar8=;
        b=E7OQY/ZUcbJ82owa00eBiNWVR1HIGMW4MQdIXIQY1scLftcxLCgAii3l726ITeWKKK
         lnzFqYDNByOjTEYnJGkWVI715cM7T/tnN1hIduLu0HnSnC5+oXJSbLhnbUVIN+LbgtzS
         av7C3eGwknL2vhtYCs6LcMLqXKogImxvhAuNfuM6CO+jugBZeF4zHj/lQZY+wHlX6mB+
         6BdSyOIXb2DnxENTNn9uHI5cELCpucTO4zUDx61781/LYLikyLKzBPiexYxxQIPp1w3z
         P91On/L40LcRDZhQVGoLW8CJwOJoZTNHEmr4il3F2GStdJCElR2Umbwffv+xpYZs6r2g
         I7Dg==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>

We'll make iocg_kick_waitq() call iocg_kick_delay(). Reorder them in
preparation. This is pure code reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 120 ++++++++++++++++++++++-----------------------
 1 file changed, 60 insertions(+), 60 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8dfe73dde2a8..ac22d761a350 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1115,6 +1115,66 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 	return false;
 }
 
+static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
+{
+	struct ioc *ioc = iocg->ioc;
+	struct blkcg_gq *blkg = iocg_to_blkg(iocg);
+	u64 vtime = atomic64_read(&iocg->vtime);
+	u64 vmargin = ioc->margin_us * now->vrate;
+	u64 margin_ns = ioc->margin_us * NSEC_PER_USEC;
+	u64 delta_ns, expires, oexpires;
+	u32 hw_inuse;
+
+	lockdep_assert_held(&iocg->waitq.lock);
+
+	/* debt-adjust vtime */
+	current_hweight(iocg, NULL, &hw_inuse);
+	vtime += abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
+
+	/*
+	 * Clear or maintain depending on the overage. Non-zero vdebt is what
+	 * guarantees that @iocg is online and future iocg_kick_delay() will
+	 * clear use_delay. Don't leave it on when there's no vdebt.
+	 */
+	if (!iocg->abs_vdebt || time_before_eq64(vtime, now->vnow)) {
+		blkcg_clear_delay(blkg);
+		return false;
+	}
+	if (!atomic_read(&blkg->use_delay) &&
+	    time_before_eq64(vtime, now->vnow + vmargin))
+		return false;
+
+	/* use delay */
+	delta_ns = DIV64_U64_ROUND_UP(vtime - now->vnow,
+				      now->vrate) * NSEC_PER_USEC;
+	blkcg_set_delay(blkg, delta_ns);
+	expires = now->now_ns + delta_ns;
+
+	/* if already active and close enough, don't bother */
+	oexpires = ktime_to_ns(hrtimer_get_softexpires(&iocg->delay_timer));
+	if (hrtimer_is_queued(&iocg->delay_timer) &&
+	    abs(oexpires - expires) <= margin_ns / 4)
+		return true;
+
+	hrtimer_start_range_ns(&iocg->delay_timer, ns_to_ktime(expires),
+			       margin_ns / 4, HRTIMER_MODE_ABS);
+	return true;
+}
+
+static enum hrtimer_restart iocg_delay_timer_fn(struct hrtimer *timer)
+{
+	struct ioc_gq *iocg = container_of(timer, struct ioc_gq, delay_timer);
+	struct ioc_now now;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iocg->waitq.lock, flags);
+	ioc_now(iocg->ioc, &now);
+	iocg_kick_delay(iocg, &now);
+	spin_unlock_irqrestore(&iocg->waitq.lock, flags);
+
+	return HRTIMER_NORESTART;
+}
+
 static int iocg_wake_fn(struct wait_queue_entry *wq_entry, unsigned mode,
 			int flags, void *key)
 {
@@ -1211,66 +1271,6 @@ static enum hrtimer_restart iocg_waitq_timer_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
-{
-	struct ioc *ioc = iocg->ioc;
-	struct blkcg_gq *blkg = iocg_to_blkg(iocg);
-	u64 vtime = atomic64_read(&iocg->vtime);
-	u64 vmargin = ioc->margin_us * now->vrate;
-	u64 margin_ns = ioc->margin_us * NSEC_PER_USEC;
-	u64 delta_ns, expires, oexpires;
-	u32 hw_inuse;
-
-	lockdep_assert_held(&iocg->waitq.lock);
-
-	/* debt-adjust vtime */
-	current_hweight(iocg, NULL, &hw_inuse);
-	vtime += abs_cost_to_cost(iocg->abs_vdebt, hw_inuse);
-
-	/*
-	 * Clear or maintain depending on the overage. Non-zero vdebt is what
-	 * guarantees that @iocg is online and future iocg_kick_delay() will
-	 * clear use_delay. Don't leave it on when there's no vdebt.
-	 */
-	if (!iocg->abs_vdebt || time_before_eq64(vtime, now->vnow)) {
-		blkcg_clear_delay(blkg);
-		return false;
-	}
-	if (!atomic_read(&blkg->use_delay) &&
-	    time_before_eq64(vtime, now->vnow + vmargin))
-		return false;
-
-	/* use delay */
-	delta_ns = DIV64_U64_ROUND_UP(vtime - now->vnow,
-				      now->vrate) * NSEC_PER_USEC;
-	blkcg_set_delay(blkg, delta_ns);
-	expires = now->now_ns + delta_ns;
-
-	/* if already active and close enough, don't bother */
-	oexpires = ktime_to_ns(hrtimer_get_softexpires(&iocg->delay_timer));
-	if (hrtimer_is_queued(&iocg->delay_timer) &&
-	    abs(oexpires - expires) <= margin_ns / 4)
-		return true;
-
-	hrtimer_start_range_ns(&iocg->delay_timer, ns_to_ktime(expires),
-			       margin_ns / 4, HRTIMER_MODE_ABS);
-	return true;
-}
-
-static enum hrtimer_restart iocg_delay_timer_fn(struct hrtimer *timer)
-{
-	struct ioc_gq *iocg = container_of(timer, struct ioc_gq, delay_timer);
-	struct ioc_now now;
-	unsigned long flags;
-
-	spin_lock_irqsave(&iocg->waitq.lock, flags);
-	ioc_now(iocg->ioc, &now);
-	iocg_kick_delay(iocg, &now);
-	spin_unlock_irqrestore(&iocg->waitq.lock, flags);
-
-	return HRTIMER_NORESTART;
-}
-
 static void ioc_lat_stat(struct ioc *ioc, u32 *missed_ppm_ar, u32 *rq_wait_pct_p)
 {
 	u32 nr_met[2] = { };
-- 
2.26.2

