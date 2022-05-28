From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v3 2/6] block, bfq: cleanup __bfq_weights_tree_remove()
Date: Sat, 28 May 2022 17:59:54 +0800
Message-ID: <20220528095958.270455-3-yukuai3@huawei.com>
References: <20220528095958.270455-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220528095958.270455-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

It's the same with bfq_weights_tree_remove() now.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 block/bfq-iosched.c | 13 +------------
 block/bfq-iosched.h |  1 -
 block/bfq-wf2q.c    |  2 +-
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 2315cfbe46e7..8c7020f8cdf2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -944,8 +944,7 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
  * See the comments to the function bfq_weights_tree_add() for considerations
  * about overhead.
  */
-void __bfq_weights_tree_remove(struct bfq_data *bfqd,
-			       struct bfq_queue *bfqq)
+void bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 {
 	struct rb_root_cached *root;
 
@@ -965,16 +964,6 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
 	bfq_put_queue(bfqq);
 }
 
-/*
- * Invoke __bfq_weights_tree_remove on bfqq and decrement the number
- * of active groups for each queue's inactive parent entity.
- */
-void bfq_weights_tree_remove(struct bfq_data *bfqd,
-			     struct bfq_queue *bfqq)
-{
-	__bfq_weights_tree_remove(bfqd, bfqq);
-}
-
 /*
  * Return expired entry, or NULL to just start from scratch in rbtree.
  */
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 50c554134196..ecca2c0570ea 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -934,7 +934,6 @@ void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync);
 struct bfq_data *bic_to_bfqd(struct bfq_io_cq *bic);
 void bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq);
-void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		     bool compensate, enum bfqq_expiration reason);
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 03949c20494d..44905ed5175d 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -794,7 +794,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		 * there is a counter associated with the entity).
 		 */
 		if (prev_weight != new_weight && bfqq)
-			__bfq_weights_tree_remove(bfqd, bfqq);
+			bfq_weights_tree_remove(bfqd, bfqq);
 		entity->weight = new_weight;
 		/*
 		 * Add the entity, if it is not a weight-raised queue,
-- 
2.31.1

