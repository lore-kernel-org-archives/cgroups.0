From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] iocost: replace nr_shortages cond in ioc_forgive_debts() with busy_level one
Date: Thu, 17 Sep 2020 20:44:53 -0400
Message-ID: <20200918004456.593983-3-tj@kernel.org>
References: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/zKXBEr6TfdKAVuGNBQ0JBMHe4IOIVvKgYa0IBCbeM=;
        b=V+eukaeBQ9EymY1UpurIpKChUF9k/7A5HpI5/TyACkajuXTHx7jxGZYyFFS4HHakSz
         nZTlahmQZU2BrlkbxdryiyrNSNTZYN4Q3cS8mMllkeSjCt7+ygWZm+WBsRa96E22GKe5
         xwSeNq6ftFaRDQL7gHjJLdFHKBTbIBQVfGKbckFdEYSDxBglwYcWuQKTeYHWD088XX0S
         gMX2DCEaHHGym14WixlbHcyFItlTD+EccCdxeRR0xJrR0LL6iCVD/CPf6FbLcnIIm7sN
         FGQH5TccRjAysF7Tn9HalVYbLkFf/Mp6HIuH1N2SbQevxwTI9QZPdSBR/24ktpX2WpAk
         SkPg==
In-Reply-To: <20200918004456.593983-1-tj@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Debt reduction was blocked if any iocg was short on budget in the past
period to avoid reducing debts while some iocgs are saturated. However, this
ends up unnecessarily blocking debt reduction due to temporary local
imbalances when the device is generally being underutilized, while also
failing to block when the underlying device is overwhelmed and the usage
becomes low from high latency.

Given that debt accumulation mostly happens with swapout bursts which can
significantly deteriorate the underlying device's latency response, the
current logic is not great.

Let's replace it with ioc->busy_level based condition so that we block debt
reduction when the underlying device is being saturated. ioc_forgive_debts()
call is moved after busy_level determination.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index bbf30bb06c07..c0499c294da9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -287,10 +287,7 @@ enum {
 	MIN_DELAY		= 250,
 	MAX_DELAY		= 250 * USEC_PER_MSEC,
 
-	/*
-	 * Halve debts if total usage keeps staying under 25% w/o any shortages
-	 * for over 100ms.
-	 */
+	/* halve debts if total usage keeps staying under 25% for over 100ms */
 	DEBT_BUSY_USAGE_PCT	= 25,
 	DEBT_REDUCTION_IDLE_DUR	= 100 * USEC_PER_MSEC,
 
@@ -1990,9 +1987,9 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
  * sufficiently idle for a while, the debts are halved.
  */
 static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
-			      int nr_shortages, struct ioc_now *now)
+			      struct ioc_now *now)
 {
-	if (nr_shortages ||
+	if (ioc->busy_level < 0 ||
 	    div64_u64(100 * usage_us_sum, now->now - ioc->period_at) >=
 	    DEBT_BUSY_USAGE_PCT)
 		ioc->debt_busy_at = now->now;
@@ -2205,8 +2202,6 @@ static void ioc_timer_fn(struct timer_list *timer)
 	list_for_each_entry_safe(iocg, tiocg, &surpluses, surplus_list)
 		list_del_init(&iocg->surplus_list);
 
-	ioc_forgive_debts(ioc, usage_us_sum, nr_debtors, nr_shortages, &now);
-
 	/*
 	 * If q is getting clogged or we're missing too much, we're issuing
 	 * too much IO and should lower vtime rate.  If we're not missing
@@ -2301,6 +2296,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 
 	ioc_refresh_params(ioc, false);
 
+	ioc_forgive_debts(ioc, usage_us_sum, nr_debtors, &now);
+
 	/*
 	 * This period is done.  Move onto the next one.  If nothing's
 	 * going on with the device, stop the timer.
-- 
2.26.2

