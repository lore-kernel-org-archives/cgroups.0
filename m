From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next 03/11] block, bfq: cleanup for __bfq_activate_requeue_entity()
Date: Sat, 5 Mar 2022 17:11:57 +0800
Message-ID: <20220305091205.4188398-4-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Remove the parameter 'sd', which can be access by 'entity'. Just to
make the code a litter cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-wf2q.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index c4cb935a615a..e30da27f356d 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1082,12 +1082,12 @@ static void __bfq_requeue_entity(struct bfq_entity *entity)
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
@@ -1119,14 +1119,11 @@ static void bfq_activate_requeue_entity(struct bfq_entity *entity,
 					bool non_blocking_wait_rq,
 					bool requeue, bool expiration)
 {
-	struct bfq_sched_data *sd;
-
 	for_each_entity(entity) {
-		sd = entity->sched_data;
-		__bfq_activate_requeue_entity(entity, sd, non_blocking_wait_rq);
+		__bfq_activate_requeue_entity(entity, non_blocking_wait_rq);
 
-		if (!bfq_update_next_in_service(sd, entity, expiration) &&
-		    !requeue)
+		if (!bfq_update_next_in_service(entity->sched_data, entity,
+					expiration) && !requeue)
 			break;
 	}
 }
-- 
2.31.1

