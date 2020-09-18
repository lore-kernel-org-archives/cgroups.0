From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] iocost: recalculate delay after debt reduction
Date: Thu, 17 Sep 2020 20:44:54 -0400
Message-ID: <20200918004456.593983-4-tj@kernel.org>
References: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ESbogjuwusL6bG2HVAbKfWJT6Gw8rmatSqGwZlkX8AM=;
        b=KqiKjo8ece3zoqRHEClfRRBiJtjRdILsq3RELTwgDJTBWNqze7+GKFNAm9neqmm+OQ
         52HxffH349WPSwZiaNBwfEyEsEamhZjpUqxpN3ieLKeofn5LOBX6kxj0OKSY3m1LIbpd
         qFra6bKLan2OQC7JKa8wFCMbLb6T7x+36jvPnVfrzB6lP6q8/v9iqUYTrVZN9CQQY2Z+
         VEYXy9ugIPOGpmri/WTCKNgpvxYnK13V3F3GNtS86ZIS32JadBE4xJ1xqgMvvDpzqKbj
         b6EV/XPGPg8QCjW6+EX6jQRjJzQTTGGnngfemHP5O59D/yLoYAVvpv6g5C0C7juRoq87
         Sxhw==
In-Reply-To: <20200918004456.593983-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Debt sets the initial delay duration which is decayed over time. The current
debt reduction halved the debt but didn't change the delay. It prevented
future debts from increasing delay but didn't do anything to lower the
existing delay, limiting the mechanism's ability to reduce unnecessary
idling.

Reset iocg->delay to 0 after debt reduction so that iocg_kick_waitq()
recalculates new delay value based on the reduced debt amount.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c0499c294da9..ffcb78126ab7 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1984,7 +1984,8 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
  * up blocked paying its debt while the IO device is idle.
  *
  * The following protects against such cases. If the device has been
- * sufficiently idle for a while, the debts are halved.
+ * sufficiently idle for a while, the debts are halved and delays are
+ * recalculated.
  */
 static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
 			      struct ioc_now *now)
@@ -2002,6 +2003,7 @@ static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
 			if (iocg->abs_vdebt) {
 				spin_lock(&iocg->waitq.lock);
 				iocg->abs_vdebt /= 2;
+				iocg->delay = 0; /* kick_waitq will recalc */
 				iocg_kick_waitq(iocg, true, now);
 				spin_unlock(&iocg->waitq.lock);
 			}
-- 
2.26.2

