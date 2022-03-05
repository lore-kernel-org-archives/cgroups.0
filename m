From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next 09/11] block, bfq: move forward __bfq_weights_tree_remove()
Date: Sat, 5 Mar 2022 17:12:03 +0800
Message-ID: <20220305091205.4188398-10-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to decrease 'num_groups_with_pending_reqs' earlier.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 2a48c40b4f02..f221e9cab4d0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -979,6 +979,19 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 {
 	struct bfq_entity *entity = bfqq->entity.parent;
 
+	/*
+	 * grab a ref to prevent bfqq to be freed in
+	 * __bfq_weights_tree_remove
+	 */
+	bfqq->ref++;
+
+	/*
+	 * remove bfqq from weights tree first, so that how many queues have
+	 * pending requests in parent bfqg is updated.
+	 */
+	__bfq_weights_tree_remove(bfqd, bfqq,
+				  &bfqd->queue_weights_tree);
+
 	for_each_entity(entity) {
 		struct bfq_sched_data *sd = entity->my_sched_data;
 
@@ -1013,14 +1026,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
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

