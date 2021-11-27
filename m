From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH RFC 8/9] block, bfq: move forward __bfq_weights_tree_remove()
Date: Sat, 27 Nov 2021 18:11:31 +0800
Message-ID: <20211127101132.486806-9-yukuai3@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20211127101132.486806-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to decrease 'num_groups_with_pending_reqs' earlier.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e3c31db4bffb..4239b3996e23 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -882,6 +882,10 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 {
 	struct bfq_entity *entity = bfqq->entity.parent;
 
+	bfqq->ref++;
+	__bfq_weights_tree_remove(bfqd, bfqq,
+				  &bfqd->queue_weights_tree);
+
 	for_each_entity(entity) {
 		struct bfq_sched_data *sd = entity->my_sched_data;
 
@@ -916,14 +920,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 		}
 	}
 
-	/*
-	 * Next function is invoked last, because it causes bfqq to be
-	 * freed if the following holds: bfqq is not in service and
-	 * has no dispatched request. DO NOT use bfqq after the next
-	 * function invocation.
-	 */
-	__bfq_weights_tree_remove(bfqd, bfqq,
-				  &bfqd->queue_weights_tree);
+	bfq_put_queue(bfqq);
 }
 
 /*
-- 
2.31.1

