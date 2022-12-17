From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 3/4] blk-iocost: dispatch all throttled bio in ioc_pd_offline
Date: Sat, 17 Dec 2022 11:05:26 +0800
Message-ID: <20221217030527.1250083-4-yukuai1@huaweicloud.com>
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

Currently, if cgroup is removed while some bio is still throttled, such
bio will still wait for timer to dispatch. On the one hand, it
doesn't make sense to throttle bio while cgroup is removed, on the other
hand, this behaviour makes it hard to guarantee the exit order for
iocg(in ioc_pd_free() currently).

This patch make iocg->online updated under both 'ioc->lock' and
'iocg->waitq.lock', so it can be guaranteed that iocg will stay online
while holding any lock. In the meantime, all throttled bio will be
dispatched immediately in ioc_pd_offline().

This patch also prepare to move operations on iocg from ioc_pd_free()
to ioc_pd_offline().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-iocost.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 23cc734dbe43..b63ecfdd815c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1448,14 +1448,18 @@ static int iocg_wake_fn(struct wait_queue_entry *wq_entry, unsigned mode,
 {
 	struct iocg_wait *wait = container_of(wq_entry, struct iocg_wait, wait);
 	struct iocg_wake_ctx *ctx = key;
-	u64 cost = abs_cost_to_cost(wait->abs_cost, ctx->hw_inuse);
 
-	ctx->vbudget -= cost;
+	if (ctx->iocg->online) {
+		u64 cost = abs_cost_to_cost(wait->abs_cost, ctx->hw_inuse);
 
-	if (ctx->vbudget < 0)
-		return -1;
+		ctx->vbudget -= cost;
+
+		if (ctx->vbudget < 0)
+			return -1;
+
+		iocg_commit_bio(ctx->iocg, wait->bio, wait->abs_cost, cost);
+	}
 
-	iocg_commit_bio(ctx->iocg, wait->bio, wait->abs_cost, cost);
 	wait->committed = true;
 
 	/*
@@ -3003,9 +3007,14 @@ static void ioc_pd_offline(struct blkg_policy_data *pd)
 	unsigned long flags;
 
 	if (ioc) {
-		spin_lock_irqsave(&ioc->lock, flags);
+		struct iocg_wake_ctx ctx = { .iocg = iocg };
+
+		iocg_lock(iocg, true, &flags);
 		iocg->online = false;
-		spin_unlock_irqrestore(&ioc->lock, flags);
+		iocg_unlock(iocg, true, &flags);
+
+		hrtimer_cancel(&iocg->waitq_timer);
+		__wake_up(&iocg->waitq, TASK_NORMAL, 0, &ctx);
 	}
 }
 
@@ -3030,8 +3039,6 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
 
 		spin_unlock_irqrestore(&ioc->lock, flags);
-
-		hrtimer_cancel(&iocg->waitq_timer);
 	}
 	free_percpu(iocg->pcpu_stat);
 	kfree(iocg);
-- 
2.31.1

