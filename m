From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 5/8] block, bfq: cleanup bfq_activate_requeue_entity()
Date: Sat, 14 May 2022 17:05:19 +0800
Message-ID: <20220514090522.1669270-6-yukuai3@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Just make the code a litter cleaner by removing the unnecessary
variable 'sd'.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-wf2q.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 15b97687493a..da189c732376 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1085,12 +1085,12 @@ static void __bfq_requeue_entity(struct bfq_entity *entity)
 }
 
 static void __bfq_activate_requeue_entity(struct bfq_entity *entity,
-					  struct bfq_sched_data *sd,
 					  bool non_blocking_wait_rq)
 {
 	struct bfq_service_tree *st = bfq_entity_service_tree(entity);
 
-	if (sd->in_service_entity == entity || entity->tree == &st->active)
+	if (entity->sched_data->in_service_entity == entity ||
+	    entity->tree == &st->active)
 		 /*
 		  * in service or already queued on the active tree,
 		  * requeue or reposition
@@ -1122,14 +1122,10 @@ static void bfq_activate_requeue_entity(struct bfq_entity *entity,
 					bool non_blocking_wait_rq,
 					bool requeue, bool expiration)
 {
-	struct bfq_sched_data *sd;
-
 	for_each_entity(entity) {
-		sd = entity->sched_data;
-		__bfq_activate_requeue_entity(entity, sd, non_blocking_wait_rq);
-
-		if (!bfq_update_next_in_service(sd, entity, expiration) &&
-		    !requeue)
+		__bfq_activate_requeue_entity(entity, non_blocking_wait_rq);
+		if (!bfq_update_next_in_service(entity->sched_data, entity,
+						expiration) && !requeue)
 			break;
 	}
 }
-- 
2.31.1

