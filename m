From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-5.5-fixes] iocost: over-budget forced IOs should
 schedule async delay
Date: Mon, 16 Dec 2019 13:34:00 -0800
Message-ID: <20191216213400.GA2914998@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=gilqVXjewwhIA+/H+uhFEXgFGjhc0Nb4bpY0xnskfZw=;
        b=p8mPv5jm1Qu39lGJzVKgWbKLmF4XT3ywrXoYnisUT6RfJ3zxPyPFFlGcq3BlKpjqCV
         iFxOM697VUQ2O/DZE08qCIvNPUcb3ADyUfKCFflVwrPBKrJB2B5Lh/Pf9umEqDrccOGI
         5fyTNR4QcPWVWGyGs1+xMsb10wIYRC2gX1iSX3/55XdW28jU602keEhwTNuF3lx3vzGk
         OQF2mqjNz3WYv393+dcMviQJCxLu1cQtNLCHkW4xU/J0no/uhHkXqDHZJZ1+z6pJp4l0
         RuqwUkI6BglPfm61QEnznU0lPzRWxUPUVRMcT8uML+Vwae7spIo7s11Z1Drl5+Op2cuP
         fuDA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>

When over-budget IOs are force-issued through root cgroup,
iocg_kick_delay() adjusts the async delay accordingly but doesn't
actually schedule async throttle for the issuing task.  This bug is
pretty well masked because sooner or later the offending threads are
gonna get directly throttled on regular IOs or have async delay
scheduled by mem_cgroup_throttle_swaprate().

However, it can affect control quality on filesystem metadata heavy
operations.  Let's fix it by invoking blkcg_schedule_throttle() when
iocg_kick_delay() says async delay is needed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
---
 block/blk-iocost.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e01267f99183..27ca68621137 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1212,7 +1212,7 @@ static enum hrtimer_restart iocg_waitq_timer_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now, u64 cost)
+static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now, u64 cost)
 {
 	struct ioc *ioc = iocg->ioc;
 	struct blkcg_gq *blkg = iocg_to_blkg(iocg);
@@ -1229,11 +1229,11 @@ static void iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now, u64 cost)
 	/* clear or maintain depending on the overage */
 	if (time_before_eq64(vtime, now->vnow)) {
 		blkcg_clear_delay(blkg);
-		return;
+		return false;
 	}
 	if (!atomic_read(&blkg->use_delay) &&
 	    time_before_eq64(vtime, now->vnow + vmargin))
-		return;
+		return false;
 
 	/* use delay */
 	if (cost) {
@@ -1250,10 +1250,11 @@ static void iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now, u64 cost)
 	oexpires = ktime_to_ns(hrtimer_get_softexpires(&iocg->delay_timer));
 	if (hrtimer_is_queued(&iocg->delay_timer) &&
 	    abs(oexpires - expires) <= margin_ns / 4)
-		return;
+		return true;
 
 	hrtimer_start_range_ns(&iocg->delay_timer, ns_to_ktime(expires),
 			       margin_ns / 4, HRTIMER_MODE_ABS);
+	return true;
 }
 
 static enum hrtimer_restart iocg_delay_timer_fn(struct hrtimer *timer)
@@ -1739,7 +1740,9 @@ static void ioc_rqos_throttle(struct rq_qos *rqos, struct bio *bio)
 	 */
 	if (bio_issue_as_root_blkg(bio) || fatal_signal_pending(current)) {
 		atomic64_add(abs_cost, &iocg->abs_vdebt);
-		iocg_kick_delay(iocg, &now, cost);
+		if (iocg_kick_delay(iocg, &now, cost))
+			blkcg_schedule_throttle(rqos->q,
+					(bio->bi_opf & REQ_SWAP) == REQ_SWAP);
 		return;
 	}
 
