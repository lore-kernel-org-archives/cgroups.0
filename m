From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3 for-5.4/block] iocost: better trace vrate changes
Date: Wed, 25 Sep 2019 16:02:07 -0700
Message-ID: <20190925230207.GI2233839@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=J6xx84NYBZMzyAcWsbF/M7RN9YSA/RHntuLBn1Nqazg=;
        b=SIfEzvpvUIu7/aCIY6SH2SkyCjOd9o0i5PqDvqyQHvE2InvTaTZQsVQCaxK5q1n/Cj
         yumJMyFWRX5aLUZd6WU9ijwVcG7VOjbiBe83nr6b6ydDBgYuXARTJf9DFAPC08+spzNo
         lUUQILezVaRYjlSnhG9eGY0RP1Hd2B2Vt9F8TaDReIT63toDYPKKzmTKEbTR868/tRhG
         AlAKT1UT4L82ewB5aZ1Sz017fFwxNLGqgxsyPmzjD7ZzoHFV7NWhiDpx9tVnBa86/yP+
         YgSGjq91jgvX1ZBsL/sJT2p9Dmg68iJXvjHCqi5Yt4gQ8UoZIivfDeKn7jA2r66/x0R5
         ou0g==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

vrate_adj tracepoint traces vrate changes; however, it does so only
when busy_level is non-zero.  busy_level turning to zero can sometimes
be as interesting an event.  This patch also enables vrate_adj
tracepoint on other vrate related events - busy_level changes and
non-zero nr_lagging.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello, Jens.

I've encountered vrate regulation issues while testing on a hard disk
machine.  These are three patches to improve vrate adj visibility and
fix the issue.

Thanks.

 block/blk-iocost.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1343,7 +1343,7 @@ static void ioc_timer_fn(struct timer_li
 	u32 ppm_wthr = MILLION - ioc->params.qos[QOS_WPPM];
 	u32 missed_ppm[2], rq_wait_pct;
 	u64 period_vtime;
-	int i;
+	int prev_busy_level, i;
 
 	/* how were the latencies during the period? */
 	ioc_lat_stat(ioc, missed_ppm, &rq_wait_pct);
@@ -1531,6 +1531,7 @@ skip_surplus_transfers:
 	 * and experiencing shortages but not surpluses, we're too stingy
 	 * and should increase vtime rate.
 	 */
+	prev_busy_level = ioc->busy_level;
 	if (rq_wait_pct > RQ_WAIT_BUSY_PCT ||
 	    missed_ppm[READ] > ppm_rthr ||
 	    missed_ppm[WRITE] > ppm_wthr) {
@@ -1592,6 +1593,10 @@ skip_surplus_transfers:
 		atomic64_set(&ioc->vtime_rate, vrate);
 		ioc->inuse_margin_vtime = DIV64_U64_ROUND_UP(
 			ioc->period_us * vrate * INUSE_MARGIN_PCT, 100);
+	} else if (ioc->busy_level != prev_busy_level || nr_lagging) {
+		trace_iocost_ioc_vrate_adj(ioc, atomic64_read(&ioc->vtime_rate),
+					   &missed_ppm, rq_wait_pct, nr_lagging,
+					   nr_shortages, nr_surpluses);
 	}
 
 	ioc_refresh_params(ioc, false);
