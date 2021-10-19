From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v3 -next 1/2] blk-cgroup: don't call blk_mq_freeze_queue() in blkcg_deactivate_policy()
Date: Tue, 19 Oct 2021 10:41:31 +0800
Message-ID: <20211019024132.432458-2-yukuai3@huawei.com>
References: <20211019024132.432458-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211019024132.432458-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, avanzini.arianna@gmail.com, fchecconi@gmail.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

blkcg_deactivate_policy() can be called from either
blk_cleanup_queue() for all policies or elevator_switch() for bfq
policy. Thus there is no need to freeze queue in
blkcg_deactivate_policy() since the caller freeze the queue aready.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cec86a705c89..ca60233c8392 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1398,9 +1398,6 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	if (!blkcg_policy_enabled(q, pol))
 		return;
 
-	if (queue_is_mq(q))
-		blk_mq_freeze_queue(q);
-
 	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
@@ -1419,9 +1416,6 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	}
 
 	spin_unlock_irq(&q->queue_lock);
-
-	if (queue_is_mq(q))
-		blk_mq_unfreeze_queue(q);
 }
 EXPORT_SYMBOL_GPL(blkcg_deactivate_policy);
 
-- 
2.31.1

