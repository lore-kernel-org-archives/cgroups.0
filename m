From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 3/8] block, bfq: factor out code to update 'active_entities'
Date: Sat, 14 May 2022 17:05:17 +0800
Message-ID: <20220514090522.1669270-4-yukuai3@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Current code is a bit ugly and hard to read.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-wf2q.c | 61 +++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 2f3fb45a32c3..c58568a4b009 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -230,6 +230,26 @@ static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
 		bfqq->bfqd->num_groups_with_busy_queues--;
 }
 
+static void bfq_inc_active_entities(struct bfq_entity *entity)
+{
+	struct bfq_sched_data *sd = entity->sched_data;
+	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
+	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
+
+	if (bfqg != bfqd->root_group)
+		bfqg->active_entities++;
+}
+
+static void bfq_dec_active_entities(struct bfq_entity *entity)
+{
+	struct bfq_sched_data *sd = entity->sched_data;
+	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
+	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
+
+	if (bfqg != bfqd->root_group)
+		bfqg->active_entities--;
+}
+
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
 
 static bool bfq_update_parent_budget(struct bfq_entity *next_in_service)
@@ -250,6 +270,14 @@ static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
 {
 }
 
+static void bfq_inc_active_entities(struct bfq_entity *entity)
+{
+}
+
+static void bfq_dec_active_entities(struct bfq_entity *entity)
+{
+}
+
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
 /*
@@ -476,11 +504,6 @@ static void bfq_active_insert(struct bfq_service_tree *st,
 {
 	struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
 	struct rb_node *node = &entity->rb_node;
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	struct bfq_sched_data *sd = NULL;
-	struct bfq_group *bfqg = NULL;
-	struct bfq_data *bfqd = NULL;
-#endif
 
 	bfq_insert(&st->active, entity);
 
@@ -491,17 +514,10 @@ static void bfq_active_insert(struct bfq_service_tree *st,
 
 	bfq_update_active_tree(node);
 
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	sd = entity->sched_data;
-	bfqg = container_of(sd, struct bfq_group, sched_data);
-	bfqd = (struct bfq_data *)bfqg->bfqd;
-#endif
 	if (bfqq)
 		list_add(&bfqq->bfqq_list, &bfqq->bfqd->active_list);
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	if (bfqg != bfqd->root_group)
-		bfqg->active_entities++;
-#endif
+
+	bfq_inc_active_entities(entity);
 }
 
 /**
@@ -578,29 +594,16 @@ static void bfq_active_extract(struct bfq_service_tree *st,
 {
 	struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
 	struct rb_node *node;
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	struct bfq_sched_data *sd = NULL;
-	struct bfq_group *bfqg = NULL;
-	struct bfq_data *bfqd = NULL;
-#endif
 
 	node = bfq_find_deepest(&entity->rb_node);
 	bfq_extract(&st->active, entity);
 
 	if (node)
 		bfq_update_active_tree(node);
-
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	sd = entity->sched_data;
-	bfqg = container_of(sd, struct bfq_group, sched_data);
-	bfqd = (struct bfq_data *)bfqg->bfqd;
-#endif
 	if (bfqq)
 		list_del(&bfqq->bfqq_list);
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	if (bfqg != bfqd->root_group)
-		bfqg->active_entities--;
-#endif
+
+	bfq_dec_active_entities(entity);
 }
 
 /**
-- 
2.31.1

