From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v4 2/5] block, bfq: factor out code to update 'active_entities'
Date: Wed,  2 Nov 2022 10:25:39 +0800
Message-ID: <20221102022542.3621219-3-yukuai1@huaweicloud.com>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221102022542.3621219-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Current code is a bit ugly and hard to read.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
---
 block/bfq-wf2q.c | 61 +++++++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 29 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 2faa29fcb1e9..a908aa3eb0ab 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -218,6 +218,26 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return false;
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
@@ -230,6 +250,14 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return true;
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
@@ -456,11 +484,6 @@ static void bfq_active_insert(struct bfq_service_tree *st,
 {
 	struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
 	struct rb_node *node = &entity->rb_node;
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	struct bfq_sched_data *sd = NULL;
-	struct bfq_group *bfqg = NULL;
-	struct bfq_data *bfqd = NULL;
-#endif
 
 	bfq_insert(&st->active, entity);
 
@@ -471,17 +494,10 @@ static void bfq_active_insert(struct bfq_service_tree *st,
 
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
@@ -558,29 +574,16 @@ static void bfq_active_extract(struct bfq_service_tree *st,
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

