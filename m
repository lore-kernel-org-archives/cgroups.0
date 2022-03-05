From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 04/11] block, bfq: move the increasement of 'num_groups_with_pending_reqs' to it's caller
Date: Sat, 5 Mar 2022 17:11:58 +0800
Message-ID: <20220305091205.4188398-5-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Root group is not in service tree, thus __bfq_activate_entity() is not
needed for root_group. This will simplify counting root group into
'num_groups_with_pending_reqs'.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-wf2q.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index e30da27f356d..17f1d2c5b8dc 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -218,6 +218,19 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return false;
 }
 
+static void bfq_update_groups_with_pending_reqs(struct bfq_entity *entity)
+{
+	if (!bfq_entity_to_bfqq(entity) && /* bfq_group */
+	    !entity->in_groups_with_pending_reqs) {
+		struct bfq_group *bfqg =
+			container_of(entity, struct bfq_group, entity);
+		struct bfq_data *bfqd = bfqg->bfqd;
+
+		entity->in_groups_with_pending_reqs = true;
+		bfqd->num_groups_with_pending_reqs++;
+	}
+}
+
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
 
 static bool bfq_update_parent_budget(struct bfq_entity *next_in_service)
@@ -230,6 +243,10 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return true;
 }
 
+static void bfq_update_groups_with_pending_reqs(struct bfq_entity *entity)
+{
+}
+
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
 /*
@@ -984,19 +1001,6 @@ static void __bfq_activate_entity(struct bfq_entity *entity,
 		entity->on_st_or_in_serv = true;
 	}
 
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-	if (!bfq_entity_to_bfqq(entity)) { /* bfq_group */
-		struct bfq_group *bfqg =
-			container_of(entity, struct bfq_group, entity);
-		struct bfq_data *bfqd = bfqg->bfqd;
-
-		if (!entity->in_groups_with_pending_reqs) {
-			entity->in_groups_with_pending_reqs = true;
-			bfqd->num_groups_with_pending_reqs++;
-		}
-	}
-#endif
-
 	bfq_update_fin_time_enqueue(entity, st, backshifted);
 }
 
@@ -1120,6 +1124,7 @@ static void bfq_activate_requeue_entity(struct bfq_entity *entity,
 					bool requeue, bool expiration)
 {
 	for_each_entity(entity) {
+		bfq_update_groups_with_pending_reqs(entity);
 		__bfq_activate_requeue_entity(entity, non_blocking_wait_rq);
 
 		if (!bfq_update_next_in_service(entity->sched_data, entity,
-- 
2.31.1

