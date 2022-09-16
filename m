From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [patch v11 6/6] block, bfq: cleanup __bfq_weights_tree_remove()
Date: Fri, 16 Sep 2022 15:19:42 +0800
Message-ID: <20220916071942.214222-7-yukuai1@huaweicloud.com>
References: <20220916071942.214222-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220916071942.214222-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

It's the same with bfq_weights_tree_remove() now.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 block/bfq-iosched.c | 11 +----------
 block/bfq-iosched.h |  1 -
 block/bfq-wf2q.c    |  2 +-
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 4ad4fa0dad4a..c14fb6b2a46d 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -944,7 +944,7 @@ void bfq_weights_tree_add(struct bfq_queue *bfqq)
  * See the comments to the function bfq_weights_tree_add() for considerations
  * about overhead.
  */
-void __bfq_weights_tree_remove(struct bfq_queue *bfqq)
+void bfq_weights_tree_remove(struct bfq_queue *bfqq)
 {
 	struct rb_root_cached *root;
 
@@ -964,15 +964,6 @@ void __bfq_weights_tree_remove(struct bfq_queue *bfqq)
 	bfq_put_queue(bfqq);
 }
 
-/*
- * Invoke __bfq_weights_tree_remove on bfqq and decrement the number
- * of active groups for each queue's inactive parent entity.
- */
-void bfq_weights_tree_remove(struct bfq_queue *bfqq)
-{
-	__bfq_weights_tree_remove(bfqq);
-}
-
 /*
  * Return expired entry, or NULL to just start from scratch in rbtree.
  */
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 4bb58ab0c90a..7795aaf4454f 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -974,7 +974,6 @@ void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync);
 struct bfq_data *bic_to_bfqd(struct bfq_io_cq *bic);
 void bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_weights_tree_add(struct bfq_queue *bfqq);
-void __bfq_weights_tree_remove(struct bfq_queue *bfqq);
 void bfq_weights_tree_remove(struct bfq_queue *bfqq);
 void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		     bool compensate, enum bfqq_expiration reason);
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 124aaea6196e..5a02cb94d86e 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -770,7 +770,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		 * there is a counter associated with the entity).
 		 */
 		if (prev_weight != new_weight && bfqq)
-			__bfq_weights_tree_remove(bfqq);
+			bfq_weights_tree_remove(bfqq);
 		entity->weight = new_weight;
 		/*
 		 * Add the entity, if it is not a weight-raised queue,
-- 
2.31.1

