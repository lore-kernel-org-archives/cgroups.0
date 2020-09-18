From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] iocost: factor out ioc_forgive_debts()
Date: Thu, 17 Sep 2020 20:44:52 -0400
Message-ID: <20200918004456.593983-2-tj@kernel.org>
References: <20200918004456.593983-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fpm0/fWCrM1vVyvEQSMysbCeUT3o5wyc4wLO+mMphzI=;
        b=EAkqxPk9U1A/FBgCCtf77AqQVFTNOOZPp+CyRxx9IQl/l8Lmbav99naCkjEybqG8Ra
         4KcUi/0Zpq+8+NM6rqcx1BqCqJjbUF80x8X6Vk5Z7NghUcAPxutVuKp1TL7E4xFsOWwy
         8jIMGhFSKalQU8ky4mSciIceYca1kGVrxHAdhAN2kNYdlxTGVrBMkIVBstZcbLRZ4ddk
         pFBnqqMN3JyR3VDod6GBpM3ELjWtb0mUs/KPcPE4i5TqQzxOdebikE0/SWX4q/4XhOSf
         VHD3Yb5sg4upVKv0QPQs+2Fr7iMSwd6Z4XfMqjGwb/3GwCCgs4XK3oKLivk+x6mGyV8V
         7Rcg==
In-Reply-To: <20200918004456.593983-1-tj@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Debt reduction logic is going to be improved and expanded. Factor it out
into ioc_forgive_debts() and generalize the comment a bit. No functional
change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 66 ++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ef9476fca1d8..bbf30bb06c07 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1979,6 +1979,40 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 		list_del_init(&iocg->walk_list);
 }
 
+/*
+ * A low weight iocg can amass a large amount of debt, for example, when
+ * anonymous memory gets reclaimed aggressively. If the system has a lot of
+ * memory paired with a slow IO device, the debt can span multiple seconds or
+ * more. If there are no other subsequent IO issuers, the in-debt iocg may end
+ * up blocked paying its debt while the IO device is idle.
+ *
+ * The following protects against such cases. If the device has been
+ * sufficiently idle for a while, the debts are halved.
+ */
+static void ioc_forgive_debts(struct ioc *ioc, u64 usage_us_sum, int nr_debtors,
+			      int nr_shortages, struct ioc_now *now)
+{
+	if (nr_shortages ||
+	    div64_u64(100 * usage_us_sum, now->now - ioc->period_at) >=
+	    DEBT_BUSY_USAGE_PCT)
+		ioc->debt_busy_at = now->now;
+
+	if (nr_debtors &&
+	    now->now - ioc->debt_busy_at >= DEBT_REDUCTION_IDLE_DUR) {
+		struct ioc_gq *iocg;
+
+		list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
+			if (iocg->abs_vdebt) {
+				spin_lock(&iocg->waitq.lock);
+				iocg->abs_vdebt /= 2;
+				iocg_kick_waitq(iocg, true, now);
+				spin_unlock(&iocg->waitq.lock);
+			}
+		}
+		ioc->debt_busy_at = now->now;
+	}
+}
+
 static void ioc_timer_fn(struct timer_list *timer)
 {
 	struct ioc *ioc = container_of(timer, struct ioc, timer);
@@ -2171,37 +2205,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	list_for_each_entry_safe(iocg, tiocg, &surpluses, surplus_list)
 		list_del_init(&iocg->surplus_list);
 
-	/*
-	 * A low weight iocg can amass a large amount of debt, for example, when
-	 * anonymous memory gets reclaimed aggressively. If the system has a lot
-	 * of memory paired with a slow IO device, the debt can span multiple
-	 * seconds or more. If there are no other subsequent IO issuers, the
-	 * in-debt iocg may end up blocked paying its debt while the IO device
-	 * is idle.
-	 *
-	 * The following protects against such pathological cases. If the device
-	 * has been sufficiently idle for a substantial amount of time, the
-	 * debts are halved. The criteria are on the conservative side as we
-	 * want to resolve the rare extreme cases without impacting regular
-	 * operation by forgiving debts too readily.
-	 */
-	if (nr_shortages ||
-	    div64_u64(100 * usage_us_sum, now.now - ioc->period_at) >=
-	    DEBT_BUSY_USAGE_PCT)
-		ioc->debt_busy_at = now.now;
-
-	if (nr_debtors &&
-	    now.now - ioc->debt_busy_at >= DEBT_REDUCTION_IDLE_DUR) {
-		list_for_each_entry(iocg, &ioc->active_iocgs, active_list) {
-			if (iocg->abs_vdebt) {
-				spin_lock(&iocg->waitq.lock);
-				iocg->abs_vdebt /= 2;
-				iocg_kick_waitq(iocg, true, &now);
-				spin_unlock(&iocg->waitq.lock);
-			}
-		}
-		ioc->debt_busy_at = now.now;
-	}
+	ioc_forgive_debts(ioc, usage_us_sum, nr_debtors, nr_shortages, &now);
 
 	/*
 	 * If q is getting clogged or we're missing too much, we're issuing
-- 
2.26.2

