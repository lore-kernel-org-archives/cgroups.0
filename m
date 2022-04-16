From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v2 2/5] block, bfq: add fake weight_counter for weight-raised queue
Date: Sat, 16 Apr 2022 17:37:50 +0800
Message-ID: <20220416093753.3054696-3-yukuai3@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220416093753.3054696-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Weight-raised queue is not inserted to weights_tree, which makes it
impossible to track how many queues have pending requests through
weights_tree insertion and removel. This patch add fake weight_counter
for weight-raised queue to do that.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c | 11 +++++++++++
 block/bfq-wf2q.c    |  5 ++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 2deea2d07a1f..a2977c938c70 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -134,6 +134,8 @@
 #include "bfq-iosched.h"
 #include "blk-wbt.h"
 
+#define BFQ_FAKE_WEIGHT_COUNTER ((void *) POISON_INUSE)
+
 #define BFQ_BFQQ_FNS(name)						\
 void bfq_mark_bfqq_##name(struct bfq_queue *bfqq)			\
 {									\
@@ -884,6 +886,12 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	if (bfqq->weight_counter)
 		return;
 
+	if (bfqq->wr_coeff != 1) {
+		bfqq->weight_counter = BFQ_FAKE_WEIGHT_COUNTER;
+		bfqq->ref++;
+		return;
+	}
+
 	while (*new) {
 		struct bfq_weight_counter *__counter = container_of(*new,
 						struct bfq_weight_counter,
@@ -943,6 +951,9 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	if (!bfqq->weight_counter)
 		return;
 
+	if (bfqq->weight_counter == BFQ_FAKE_WEIGHT_COUNTER)
+		goto reset_entity_pointer;
+
 	root = &bfqd->queue_weights_tree;
 	bfqq->weight_counter->num_active--;
 	if (bfqq->weight_counter->num_active > 0)
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index a1296058c1ec..ae12c6b2c525 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -776,7 +776,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		 * Add the entity, if it is not a weight-raised queue,
 		 * to the counter associated with its new weight.
 		 */
-		if (prev_weight != new_weight && bfqq && bfqq->wr_coeff == 1)
+		if (prev_weight != new_weight && bfqq)
 			bfq_weights_tree_add(bfqd, bfqq);
 
 		new_st->wsum += entity->weight;
@@ -1680,8 +1680,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
 
 	if (!bfqq->dispatched)
-		if (bfqq->wr_coeff == 1)
-			bfq_weights_tree_add(bfqd, bfqq);
+		bfq_weights_tree_add(bfqd, bfqq);
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues++;
-- 
2.31.1

