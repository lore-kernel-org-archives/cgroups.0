From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3 for-5.4/block] iocost: improve nr_lagging handling
Date: Wed, 25 Sep 2019 16:03:09 -0700
Message-ID: <20190925230309.GJ2233839@devbig004.ftw2.facebook.com>
References: <20190925230207.GI2233839@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+2s0oXR538dsUd5mHpXcur3xcbIHPtS2CMh60hp/fzM=;
        b=lirB5BC8U7A7hYKAMl7kBbxc6YJxcklp0YnCGMGTuWHyBImdAtixJC+AFZylYcBLG2
         g8hlcI40h40Ks1Y9AkE+Frij4whfpsgJzSBjJkQDI2LVIGiu+xxdPep+rQK7G2czxNPp
         bBCx1Vv+ddbACfvLlGig3qz6WPm5mJWE/8nm+uNcagUIluMY3PRYOPIkRzC5R8Pnmgz4
         tExhI0IiMCyAblozYrZ0X2Zdk32mmIjfckrx20gSLbRHYbFs+93Ga1G1+UFr5deF89Ta
         FBcaReTOPRiYyxAoVgH/pMHTmOp9w5zLvQ0Y8lnVKaNuj5J8HkvGZFa5Gd7SMQLVB5X6
         lUWQ==
Content-Disposition: inline
In-Reply-To: <20190925230207.GI2233839@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

Some IOs may span multiple periods.  As latencies are collected on
completion, the inbetween periods won't register them and may
incorrectly decide to increase vrate.  nr_lagging tracks these IOs to
avoid those situations.  Currently, whenever there are IOs which are
spanning from the previous period, busy_level is reset to 0 if
negative thus suppressing vrate increase.

This has the following two problems.

* When latency target percentiles aren't set, vrate adjustment should
  only be governed by queue depth depletion; however, the current code
  keeps nr_lagging active which pulls in latency results and can keep
  down vrate unexpectedly.

* When lagging condition is detected, it resets the entire negative
  busy_level.  This turned out to be way too aggressive on some
  devices which sometimes experience extended latencies on a small
  subset of commands.  In addition, a lagging IO will be accounted as
  latency target miss on completion anyway and resetting busy_level
  amplifies its impact unnecessarily.

This patch fixes the above two problems by disabling nr_lagging
counting when latency target percentiles aren't set and blocking vrate
increases when there are lagging IOs while leaving busy_level as-is.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1407,7 +1407,8 @@ static void ioc_timer_fn(struct timer_li
 		 * comparing vdone against period start.  If lagging behind
 		 * IOs from past periods, don't increase vrate.
 		 */
-		if (!atomic_read(&iocg_to_blkg(iocg)->use_delay) &&
+		if ((ppm_rthr != MILLION || ppm_wthr != MILLION) &&
+		    !atomic_read(&iocg_to_blkg(iocg)->use_delay) &&
 		    time_after64(vtime, vdone) &&
 		    time_after64(vtime, now.vnow -
 				 MAX_LAGGING_PERIODS * period_vtime) &&
@@ -1537,21 +1538,23 @@ skip_surplus_transfers:
 	    missed_ppm[WRITE] > ppm_wthr) {
 		ioc->busy_level = max(ioc->busy_level, 0);
 		ioc->busy_level++;
-	} else if (nr_lagging) {
-		ioc->busy_level = max(ioc->busy_level, 0);
-	} else if (nr_shortages && !nr_surpluses &&
-		   rq_wait_pct <= RQ_WAIT_BUSY_PCT * UNBUSY_THR_PCT / 100 &&
+	} else if (rq_wait_pct <= RQ_WAIT_BUSY_PCT * UNBUSY_THR_PCT / 100 &&
 		   missed_ppm[READ] <= ppm_rthr * UNBUSY_THR_PCT / 100 &&
 		   missed_ppm[WRITE] <= ppm_wthr * UNBUSY_THR_PCT / 100) {
-		ioc->busy_level = min(ioc->busy_level, 0);
-		ioc->busy_level--;
+		/* take action iff there is contention */
+		if (nr_shortages && !nr_lagging) {
+			ioc->busy_level = min(ioc->busy_level, 0);
+			/* redistribute surpluses first */
+			if (!nr_surpluses)
+				ioc->busy_level--;
+		}
 	} else {
 		ioc->busy_level = 0;
 	}
 
 	ioc->busy_level = clamp(ioc->busy_level, -1000, 1000);
 
-	if (ioc->busy_level) {
+	if (ioc->busy_level > 0 || (ioc->busy_level < 0 && !nr_lagging)) {
 		u64 vrate = atomic64_read(&ioc->vtime_rate);
 		u64 vrate_min = ioc->vrate_min, vrate_max = ioc->vrate_max;
 
