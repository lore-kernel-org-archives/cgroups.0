From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH block/for-next] iocost: fix infinite loop bug in
 adjust_inuse_and_calc_cost()
Date: Mon, 14 Sep 2020 11:05:13 -0400
Message-ID: <20200914150513.GC865564@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=MwhoD2IsxPuM7wLbM0i6FSRjhQSYCwaNO02+PwwZFwI=;
        b=hj2b9XRbREKQ+sQk3KdHJ9qKJ/wirPnzOxDkqIAkGjUGWYNewcfCK/Z7n78c1zp8np
         xtjqO9I4lyHECVNCQi1LMx1mAeUDX84kSpB/SM3ReBDs4J6RgH29faPh/v3Rsm7StlAK
         xOrl5xFFo0tb3gX4J8z5hmS9pVBMkMdT2iMV+D7pJAv+UfXc0x24dq6sVeouNDnz0Yn/
         J26hK5gKW1e6k0ng4Gh62M5KQXjWM7IUC3ec0FE6jB3N9CRxVsrXO2p5G3TADdo6gIC6
         eTwZar7N5P2rGY67eotzjFM3OpJeplY2AXypg/5jDqiUBilJ2ERSBOAjO6/IIdeg9CUv
         wdMQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

adjust_inuse_and_calc_cost() is responsible for reducing the amount of
donated weights dynamically in period as the budget runs low. Because we
don't want to do full donation calculation in period, we keep latching up
inuse by INUSE_ADJ_STEP_PCT of the active weight of the cgroup until the
resulting hweight_inuse is satisfactory.

Unfortunately, the adj_step calculation was reading the active weight before
acquiring ioc->lock. Because the current thread could have lost race to
activate the iocg to another thread before entering this function, it may
read the active weight as zero before acquiring ioc->lock. When this
happens, the adj_step is calculated as zero and the incremental adjustment
loop becomes an infinite one.

Fix it by fetching the active weight after acquiring ioc->lock.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: b0853ab4a238 ("blk-iocost: revamp in-period donation snapbacks")
---
 block/blk-iocost.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6e29b4dcf3566..ef9476fca1d8a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2323,9 +2323,8 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_gq *iocg, u64 vtime,
 {
 	struct ioc *ioc = iocg->ioc;
 	struct ioc_margins *margins = &ioc->margins;
-	u32 adj_step = DIV_ROUND_UP(iocg->active * INUSE_ADJ_STEP_PCT, 100);
 	u32 __maybe_unused old_inuse = iocg->inuse, __maybe_unused old_hwi;
-	u32 hwi;
+	u32 hwi, adj_step;
 	s64 margin;
 	u64 cost, new_inuse;
 
@@ -2354,8 +2353,15 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_gq *iocg, u64 vtime,
 		return cost;
 	}
 
-	/* bump up inuse till @abs_cost fits in the existing budget */
+	/*
+	 * Bump up inuse till @abs_cost fits in the existing budget.
+	 * adj_step must be determined after acquiring ioc->lock - we might
+	 * have raced and lost to another thread for activation and could
+	 * be reading 0 iocg->active before ioc->lock which will lead to
+	 * infinite loop.
+	 */
 	new_inuse = iocg->inuse;
+	adj_step = DIV_ROUND_UP(iocg->active * INUSE_ADJ_STEP_PCT, 100);
 	do {
 		new_inuse = new_inuse + adj_step;
 		propagate_weights(iocg, iocg->active, new_inuse, true, now);
