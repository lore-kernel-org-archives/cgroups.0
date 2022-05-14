From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 1/8] block, bfq: cleanup bfq_weights_tree add/remove apis
Date: Sat, 14 May 2022 17:05:15 +0800
Message-ID: <20220514090522.1669270-2-yukuai3@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

They already pass 'bfqd' as the first parameter, there is no need to
pass 'bfqd->queue_weights_tree' as another parameter.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c | 12 ++++++------
 block/bfq-iosched.h | 10 +++-------
 block/bfq-wf2q.c    | 16 +++++-----------
 3 files changed, 14 insertions(+), 24 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index d32b8340510a..bcbe78d71143 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -870,9 +870,9 @@ static bool bfq_asymmetric_scenario(struct bfq_data *bfqd,
  * In most scenarios, the rate at which nodes are created/destroyed
  * should be low too.
  */
-void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-			  struct rb_root_cached *root)
+void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 {
+	struct rb_root_cached *root = &bfqd->queue_weights_tree;
 	struct bfq_entity *entity = &bfqq->entity;
 	struct rb_node **new = &(root->rb_root.rb_node), *parent = NULL;
 	bool leftmost = true;
@@ -945,12 +945,13 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
  * about overhead.
  */
 void __bfq_weights_tree_remove(struct bfq_data *bfqd,
-			       struct bfq_queue *bfqq,
-			       struct rb_root_cached *root)
+			       struct bfq_queue *bfqq)
 {
+	struct rb_root_cached *root;
 	if (!bfqq->weight_counter)
 		return;
 
+	root = &bfqd->queue_weights_tree;
 	bfqq->weight_counter->num_active--;
 	if (bfqq->weight_counter->num_active > 0)
 		goto reset_entity_pointer;
@@ -970,8 +971,7 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
 void bfq_weights_tree_remove(struct bfq_data *bfqd,
 			     struct bfq_queue *bfqq)
 {
-	__bfq_weights_tree_remove(bfqd, bfqq,
-				  &bfqd->queue_weights_tree);
+	__bfq_weights_tree_remove(bfqd, bfqq);
 }
 
 /*
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index c3bd8ab169e0..0a3415abb994 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -932,13 +932,9 @@ struct bfq_queue *bic_to_bfqq(struct bfq_io_cq *bic, bool is_sync);
 void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync);
 struct bfq_data *bic_to_bfqd(struct bfq_io_cq *bic);
 void bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq);
-void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-			  struct rb_root_cached *root);
-void __bfq_weights_tree_remove(struct bfq_data *bfqd,
-			       struct bfq_queue *bfqq,
-			       struct rb_root_cached *root);
-void bfq_weights_tree_remove(struct bfq_data *bfqd,
-			     struct bfq_queue *bfqq);
+void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq);
+void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq);
+void bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		     bool compensate, enum bfqq_expiration reason);
 void bfq_put_queue(struct bfq_queue *bfqq);
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 42464e6ff40c..ccd227fed1c3 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -727,7 +727,6 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
 		unsigned int prev_weight, new_weight;
 		struct bfq_data *bfqd = NULL;
-		struct rb_root_cached *root;
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 		struct bfq_sched_data *sd;
 		struct bfq_group *bfqg;
@@ -790,19 +789,15 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		 * queue, remove the entity from its old weight counter (if
 		 * there is a counter associated with the entity).
 		 */
-		if (prev_weight != new_weight && bfqq) {
-			root = &bfqd->queue_weights_tree;
-			__bfq_weights_tree_remove(bfqd, bfqq, root);
-		}
+		if (prev_weight != new_weight && bfqq)
+			__bfq_weights_tree_remove(bfqd, bfqq);
 		entity->weight = new_weight;
 		/*
 		 * Add the entity, if it is not a weight-raised queue,
 		 * to the counter associated with its new weight.
 		 */
-		if (prev_weight != new_weight && bfqq && bfqq->wr_coeff == 1) {
-			/* If we get here, root has been initialized. */
-			bfq_weights_tree_add(bfqd, bfqq, root);
-		}
+		if (prev_weight != new_weight && bfqq && bfqq->wr_coeff == 1)
+			bfq_weights_tree_add(bfqd, bfqq);
 
 		new_st->wsum += entity->weight;
 
@@ -1695,8 +1690,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 
 	if (!bfqq->dispatched)
 		if (bfqq->wr_coeff == 1)
-			bfq_weights_tree_add(bfqd, bfqq,
-					     &bfqd->queue_weights_tree);
+			bfq_weights_tree_add(bfqd, bfqq);
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues++;
-- 
2.31.1

