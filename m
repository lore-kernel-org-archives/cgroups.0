From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/27] blk-iocost: ioc_pd_free() shouldn't assume irq disabled
Date: Tue,  1 Sep 2020 14:52:31 -0400
Message-ID: <20200901185257.645114-2-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V69TM0TXJZV6Ph3DQcWjjVMFJyyhsm9AOvCWZiY6Tfg=;
        b=npTqPcLDLPp9IG+8hih3s0n1i8HE84G+rEqAq7/0mzOvX4YAHvQawMoRbgGBQt3Yig
         2eneUEERH+HTyLTzXLB4YL2RGRONA0RTWYNtrj47yF3wKaXG1SvQcwpDJCy21eZ5Jsca
         sZEjiM8Q8sRrkCSCdh7obp3ZwzFnJGVNkTOhuz/R6vNzBKji4+ZPo5x3PfxZMyNd2OBO
         M4MTsGJ65P64qH13pbf0vQEUgLCZYCKSqoDEAtJXuzOVPMrbIWAIgJY6kryL066yazx7
         Vx3KNiFq7vpMib+dcpa+l8yunUwdH0plUmX8yPgAs/DeFZ1XTCDGXi3fKIOkg1FtiVS1
         14Ng==
In-Reply-To: <20200901185257.645114-1-tj@kernel.org>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, newella@fb.com, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org

ioc_pd_free() grabs irq-safe ioc->lock without ensuring that irq is disabled
when it can be called with irq disabled or enabled. This has a small chance
of causing A-A deadlocks and triggers lockdep splats. Use irqsave operations
instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Cc: stable@vger.kernel.org # v5.4+
---
 block/blk-iocost.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 413e0b5c8e6b..d37b55db2409 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2092,14 +2092,15 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
+	unsigned long flags;
 
 	if (ioc) {
-		spin_lock(&ioc->lock);
+		spin_lock_irqsave(&ioc->lock, flags);
 		if (!list_empty(&iocg->active_list)) {
 			propagate_active_weight(iocg, 0, 0);
 			list_del_init(&iocg->active_list);
 		}
-		spin_unlock(&ioc->lock);
+		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		hrtimer_cancel(&iocg->waitq_timer);
 		hrtimer_cancel(&iocg->delay_timer);
-- 
2.26.2

