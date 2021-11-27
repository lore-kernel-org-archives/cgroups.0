From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 3/9] block, bfq: handle the case when for_each_entity() access root group
Date: Sat, 27 Nov 2021 18:11:26 +0800
Message-ID: <20211127101132.486806-4-yukuai3@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prevent null-ptr-deref after counting root group into
'num_groups_with_pending_reqs'.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c |  2 +-
 block/bfq-wf2q.c    | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 3262d062e21f..47722f931ee3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -864,7 +864,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 	for_each_entity(entity) {
 		struct bfq_sched_data *sd = entity->my_sched_data;
 
-		if (sd->next_in_service || sd->in_service_entity) {
+		if (sd && (sd->next_in_service || sd->in_service_entity)) {
 			/*
 			 * entity is still active, because either
 			 * next_in_service or in_service_entity is not
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 67e32481e455..6693765ff3a0 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -965,6 +965,13 @@ static void __bfq_activate_entity(struct bfq_entity *entity,
 	bool backshifted = false;
 	unsigned long long min_vstart;
 
+	if (is_root_entity(entity))
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+		goto update;
+#else
+		return;
+#endif
+
 	/* See comments on bfq_fqq_update_budg_for_activation */
 	if (non_blocking_wait_rq && bfq_gt(st->vtime, entity->finish)) {
 		backshifted = true;
@@ -999,7 +1006,10 @@ static void __bfq_activate_entity(struct bfq_entity *entity,
 		entity->on_st_or_in_serv = true;
 	}
 
+	bfq_update_fin_time_enqueue(entity, st, backshifted);
+
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
+update:
 	if (!bfq_entity_to_bfqq(entity)) { /* bfq_group */
 		struct bfq_group *bfqg =
 			container_of(entity, struct bfq_group, entity);
@@ -1011,8 +1021,6 @@ static void __bfq_activate_entity(struct bfq_entity *entity,
 		}
 	}
 #endif
-
-	bfq_update_fin_time_enqueue(entity, st, backshifted);
 }
 
 /**
@@ -1102,7 +1110,8 @@ static void __bfq_activate_requeue_entity(struct bfq_entity *entity,
 {
 	struct bfq_service_tree *st = bfq_entity_service_tree(entity);
 
-	if (sd->in_service_entity == entity || entity->tree == &st->active)
+	if (sd && (sd->in_service_entity == entity ||
+		   entity->tree == &st->active))
 		 /*
 		  * in service or already queued on the active tree,
 		  * requeue or reposition
@@ -1140,7 +1149,7 @@ static void bfq_activate_requeue_entity(struct bfq_entity *entity,
 		sd = entity->sched_data;
 		__bfq_activate_requeue_entity(entity, sd, non_blocking_wait_rq);
 
-		if (!bfq_update_next_in_service(sd, entity, expiration) &&
+		if (sd && !bfq_update_next_in_service(sd, entity, expiration) &&
 		    !requeue)
 			break;
 	}
-- 
2.31.1

