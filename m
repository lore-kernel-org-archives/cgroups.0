From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [patch v11 1/6] block, bfq: support to track if bfqq has pending requests
Date: Fri, 16 Sep 2022 15:19:37 +0800
Message-ID: <20220916071942.214222-2-yukuai1@huaweicloud.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220916071942.214222-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

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
index f769c90744fd..0dcae2f52896 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6261,6 +6261,7 @@ static void bfq_completed_request(struct bfq_queue *bfqq, struct bfq_data *bfqd)
 		 */
 		bfqq->budget_timeout = jiffies;
 
+		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
 		bfq_weights_tree_remove(bfqd, bfqq);
 	}
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 64ee618064ba..44e08b194749 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1082,6 +1082,8 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		      bool expiration);
 void bfq_del_bfqq_busy(struct bfq_queue *bfqq, bool expiration);
 void bfq_add_bfqq_busy(struct bfq_queue *bfqq);
+void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq);
+void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq);
 
 /* --------------- end of interface of B-WF2Q+ ---------------- */
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 8fc3da4c23bb..bd8f4ed84848 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1646,6 +1646,22 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
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
@@ -1668,8 +1684,10 @@ void bfq_del_bfqq_busy(struct bfq_queue *bfqq, bool expiration)
 
 	bfq_deactivate_bfqq(bfqd, bfqq, true, expiration);
 
-	if (!bfqq->dispatched)
+	if (!bfqq->dispatched) {
+		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
 		bfq_weights_tree_remove(bfqd, bfqq);
+	}
 }
 
 /*
@@ -1686,10 +1704,12 @@ void bfq_add_bfqq_busy(struct bfq_queue *bfqq)
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

