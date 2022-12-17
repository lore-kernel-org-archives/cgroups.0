From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 4/4] blk-iocost: guarantee the exit order of iocg
Date: Sat, 17 Dec 2022 11:05:27 +0800
Message-ID: <20221217030527.1250083-5-yukuai1@huaweicloud.com>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

pd_offline_fn() is ensured to be called in order(parent after child),
while pd_free_fn() is not. Furthermore, rq_qos_exit() can also be called
before pd_free_fn(). For conclusion, doing cleanups in ioc_pd_free() is
not safe, which can cause many problems. By the way, iocost is the only
policy to do cleanups in pd_free_fn().

Since previous patches guarantee that ioc_pd_offline() will dispatch
throttled bio and prevent new io to be throttled. It's safe to move
cleanup operations for iocg from ioc_pd_free() to ioc_pd_offline().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-iocost.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b63ecfdd815c..d634ea73f991 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3011,21 +3011,6 @@ static void ioc_pd_offline(struct blkg_policy_data *pd)
 
 		iocg_lock(iocg, true, &flags);
 		iocg->online = false;
-		iocg_unlock(iocg, true, &flags);
-
-		hrtimer_cancel(&iocg->waitq_timer);
-		__wake_up(&iocg->waitq, TASK_NORMAL, 0, &ctx);
-	}
-}
-
-static void ioc_pd_free(struct blkg_policy_data *pd)
-{
-	struct ioc_gq *iocg = pd_to_iocg(pd);
-	struct ioc *ioc = iocg->ioc;
-	unsigned long flags;
-
-	if (ioc) {
-		spin_lock_irqsave(&ioc->lock, flags);
 
 		if (!list_empty(&iocg->active_list)) {
 			struct ioc_now now;
@@ -3038,8 +3023,17 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 		WARN_ON_ONCE(!list_empty(&iocg->walk_list));
 		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
 
-		spin_unlock_irqrestore(&ioc->lock, flags);
+		iocg_unlock(iocg, true, &flags);
+
+		hrtimer_cancel(&iocg->waitq_timer);
+		__wake_up(&iocg->waitq, TASK_NORMAL, 0, &ctx);
 	}
+}
+
+static void ioc_pd_free(struct blkg_policy_data *pd)
+{
+	struct ioc_gq *iocg = pd_to_iocg(pd);
+
 	free_percpu(iocg->pcpu_stat);
 	kfree(iocg);
 }
-- 
2.31.1

