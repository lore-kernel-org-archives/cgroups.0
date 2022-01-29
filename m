From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v3 1/3] block, bfq: cleanup bfq_bfqq_to_bfqg()
Date: Sat, 29 Jan 2022 09:59:22 +0800
Message-ID: <20220129015924.3958918-2-yukuai3@huawei.com>
References: <20220129015924.3958918-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220129015924.3958918-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, jack@suse.cz, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Use bfq_group() instead, which do the same thing.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Paolo Valente <paolo.valente@linaro.org>
---
 block/bfq-iosched.c |  4 ++--
 block/bfq-iosched.h |  1 -
 block/bfq-wf2q.c    | 15 ---------------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0c612a911696..2f2b97cad980 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -774,7 +774,7 @@ bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	if (!bfqq->next_rq)
 		return;
 
-	bfqq->pos_root = &bfq_bfqq_to_bfqg(bfqq)->rq_pos_tree;
+	bfqq->pos_root = &bfqq_group(bfqq)->rq_pos_tree;
 	__bfqq = bfq_rq_pos_tree_lookup(bfqd, bfqq->pos_root,
 			blk_rq_pos(bfqq->next_rq), &parent, &p);
 	if (!__bfqq) {
@@ -2669,7 +2669,7 @@ static struct bfq_queue *bfqq_find_close(struct bfq_data *bfqd,
 					 struct bfq_queue *bfqq,
 					 sector_t sector)
 {
-	struct rb_root *root = &bfq_bfqq_to_bfqg(bfqq)->rq_pos_tree;
+	struct rb_root *root = &bfqq_group(bfqq)->rq_pos_tree;
 	struct rb_node *parent, *node;
 	struct bfq_queue *__bfqq;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 07288b9da389..99949548896e 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1051,7 +1051,6 @@ extern struct blkcg_policy blkcg_policy_bfq;
 	for (parent = NULL; entity ; entity = parent)
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
-struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq);
 struct bfq_queue *bfq_entity_to_bfqq(struct bfq_entity *entity);
 unsigned int bfq_tot_busy_queues(struct bfq_data *bfqd);
 struct bfq_service_tree *bfq_entity_service_tree(struct bfq_entity *entity);
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index b74cc0da118e..e1f5ca5c1fdb 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -142,16 +142,6 @@ static bool bfq_update_next_in_service(struct bfq_sched_data *sd,
 
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 
-struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq)
-{
-	struct bfq_entity *group_entity = bfqq->entity.parent;
-
-	if (!group_entity)
-		group_entity = &bfqq->bfqd->root_group->entity;
-
-	return container_of(group_entity, struct bfq_group, entity);
-}
-
 /*
  * Returns true if this budget changes may let next_in_service->parent
  * become the next_in_service entity for its parent entity.
@@ -230,11 +220,6 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
 
-struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq)
-{
-	return bfqq->bfqd->root_group;
-}
-
 static bool bfq_update_parent_budget(struct bfq_entity *next_in_service)
 {
 	return false;
-- 
2.31.1

