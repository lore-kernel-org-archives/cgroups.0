From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v10 1/4] block, bfq: support to track if bfqq has pending requests
Date: Fri, 10 Jun 2022 10:16:58 +0800
Message-ID: <20220610021701.2347602-2-yukuai3@huawei.com>
References: <20220610021701.2347602-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20220610021701.2347602-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, jack@suse.cz, cgroups@vger.kernel.org, linux-block@vger.kernel.org
Cc: tj@kernel.org, axboe@kernel.dk, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

If entity belongs to bfqq, then entity->in_groups_with_pending_reqs
is not used currently. This patch use it to track if bfqq has pending
requests through callers of weights_tree insertion and removal.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/bfq-iosched.c |  1 +
 block/bfq-iosched.h |  2 ++
 block/bfq-wf2q.c    | 24 ++++++++++++++++++++++--
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0d46cb728bbf..0ec21018daba 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6263,6 +6263,7 @@ static void bfq_completed_request(struct bfq_queue *bfqq, struct bfq_data *bfqd)
 		 */
 		bfqq->budget_timeout = jiffies;
 
+		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
 		bfq_weights_tree_remove(bfqd, bfqq);
 	}
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index ca8177d7bf7c..69c7d15417e5 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1080,6 +1080,8 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		       bool expiration);
 void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq);
+void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq);
+void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq);
 
 /* --------------- end of interface of B-WF2Q+ ---------------- */
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index f8eb340381cf..5704a0315cf2 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1647,6 +1647,22 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 				    bfqq == bfqd->in_service_queue, expiration);
 }
 
+void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
+{
+	struct bfq_entity *entity = &bfqq->entity;
+
+	if (!entity->in_groups_with_pending_reqs)
+		entity->in_groups_with_pending_reqs = true;
+}
+
+void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
+{
+	struct bfq_entity *entity = &bfqq->entity;
+
+	if (entity->in_groups_with_pending_reqs)
+		entity->in_groups_with_pending_reqs = false;
+}
+
 /*
  * Called when the bfqq no longer has requests pending, remove it from
  * the service tree. As a special case, it can be invoked during an
@@ -1668,8 +1684,10 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	bfq_deactivate_bfqq(bfqd, bfqq, true, expiration);
 
-	if (!bfqq->dispatched)
+	if (!bfqq->dispatched) {
+		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
 		bfq_weights_tree_remove(bfqd, bfqq);
+	}
 }
 
 /*
@@ -1684,10 +1702,12 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_mark_bfqq_busy(bfqq);
 	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
 
-	if (!bfqq->dispatched)
+	if (!bfqq->dispatched) {
+		bfq_add_bfqq_in_groups_with_pending_reqs(bfqq);
 		if (bfqq->wr_coeff == 1)
 			bfq_weights_tree_add(bfqd, bfqq,
 					     &bfqd->queue_weights_tree);
+	}
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues++;
-- 
2.31.1

