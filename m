From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v2 4/5] block, bfq: refactor the counting of 'num_groups_with_pending_reqs'
Date: Sat, 16 Apr 2022 17:37:52 +0800
Message-ID: <20220416093753.3054696-5-yukuai3@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Currently, bfq can't handle sync io concurrently as long as they
are not issued from root group. This is because
'bfqd->num_groups_with_pending_reqs > 0' is always true in
bfq_asymmetric_scenario().

The way that bfqg is counted to 'num_groups_with_pending_reqs':

Before this patch:
 1) root group will never be counted.
 2) Count if bfqg or it's child bfqgs have pending requests.
 3) Don't count if bfqg and it's child bfqgs complete all the requests.

After this patch:
 1) root group is counted.
 2) Count if bfqg have pending requests.
 3) Don't count if bfqg complete all the requests.

With this patch, the occasion that only one group have pending requests
can be detected, and next patch will support concurrent sync io in the
occasion.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c | 52 ++++++---------------------------------------
 block/bfq-iosched.h | 18 ++++++++--------
 block/bfq-wf2q.c    | 13 ------------
 3 files changed, 15 insertions(+), 68 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 994c6b36a5d5..39abcd95df8e 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -941,7 +941,8 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 	if (!entity->in_groups_with_pending_reqs) {
 		entity->in_groups_with_pending_reqs = true;
-		bfqq_group(bfqq)->num_entities_with_pending_reqs++;
+		if (!(bfqq_group(bfqq)->num_entities_with_pending_reqs++))
+			bfqd->num_groups_with_pending_reqs++;
 	}
 #endif
 }
@@ -974,7 +975,8 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 	if (bfqq->entity.in_groups_with_pending_reqs) {
 		bfqq->entity.in_groups_with_pending_reqs = false;
-		bfqq_group(bfqq)->num_entities_with_pending_reqs--;
+		if (!(--bfqq_group(bfqq)->num_entities_with_pending_reqs))
+			bfqd->num_groups_with_pending_reqs--;
 	}
 #endif
 
@@ -989,48 +991,6 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 void bfq_weights_tree_remove(struct bfq_data *bfqd,
 			     struct bfq_queue *bfqq)
 {
-	struct bfq_entity *entity = bfqq->entity.parent;
-
-	for_each_entity(entity) {
-		struct bfq_sched_data *sd = entity->my_sched_data;
-
-		if (sd->next_in_service || sd->in_service_entity) {
-			/*
-			 * entity is still active, because either
-			 * next_in_service or in_service_entity is not
-			 * NULL (see the comments on the definition of
-			 * next_in_service for details on why
-			 * in_service_entity must be checked too).
-			 *
-			 * As a consequence, its parent entities are
-			 * active as well, and thus this loop must
-			 * stop here.
-			 */
-			break;
-		}
-
-		/*
-		 * The decrement of num_groups_with_pending_reqs is
-		 * not performed immediately upon the deactivation of
-		 * entity, but it is delayed to when it also happens
-		 * that the first leaf descendant bfqq of entity gets
-		 * all its pending requests completed. The following
-		 * instructions perform this delayed decrement, if
-		 * needed. See the comments on
-		 * num_groups_with_pending_reqs for details.
-		 */
-		if (entity->in_groups_with_pending_reqs) {
-			entity->in_groups_with_pending_reqs = false;
-			bfqd->num_groups_with_pending_reqs--;
-		}
-	}
-
-	/*
-	 * Next function is invoked last, because it causes bfqq to be
-	 * freed if the following holds: bfqq is not in service and
-	 * has no dispatched request. DO NOT use bfqq after the next
-	 * function invocation.
-	 */
 	__bfq_weights_tree_remove(bfqd, bfqq);
 }
 
@@ -3710,7 +3670,7 @@ static void bfq_dispatch_remove(struct request_queue *q, struct request *rq)
  * group. More precisely, for conditions (i-a) or (i-b) to become
  * false because of such a group, it is not even necessary that the
  * group is (still) active: it is sufficient that, even if the group
- * has become inactive, some of its descendant processes still have
+ * has become inactive, some of its processes still have
  * some request already dispatched but still waiting for
  * completion. In fact, requests have still to be guaranteed their
  * share of the throughput even after being dispatched. In this
@@ -3719,7 +3679,7 @@ static void bfq_dispatch_remove(struct request_queue *q, struct request *rq)
  * happens, the group is not considered in the calculation of whether
  * the scenario is asymmetric, then the group may fail to be
  * guaranteed its fair share of the throughput (basically because
- * idling may not be performed for the descendant processes of the
+ * idling may not be performed for the processes of the
  * group, but it had to be).  We address this issue with the following
  * bi-modal behavior, implemented in the function
  * bfq_asymmetric_scenario().
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 5e1a0ead2b6a..0850ca03e1d5 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -495,27 +495,27 @@ struct bfq_data {
 	struct rb_root_cached queue_weights_tree;
 
 	/*
-	 * Number of groups with at least one descendant process that
+	 * Number of groups with at least one process that
 	 * has at least one request waiting for completion. Note that
 	 * this accounts for also requests already dispatched, but not
 	 * yet completed. Therefore this number of groups may differ
 	 * (be larger) than the number of active groups, as a group is
 	 * considered active only if its corresponding entity has
-	 * descendant queues with at least one request queued. This
+	 * queues with at least one request queued. This
 	 * number is used to decide whether a scenario is symmetric.
 	 * For a detailed explanation see comments on the computation
 	 * of the variable asymmetric_scenario in the function
 	 * bfq_better_to_idle().
 	 *
 	 * However, it is hard to compute this number exactly, for
-	 * groups with multiple descendant processes. Consider a group
-	 * that is inactive, i.e., that has no descendant process with
+	 * groups with multiple processes. Consider a group
+	 * that is inactive, i.e., that has no process with
 	 * pending I/O inside BFQ queues. Then suppose that
 	 * num_groups_with_pending_reqs is still accounting for this
-	 * group, because the group has descendant processes with some
+	 * group, because the group has processes with some
 	 * I/O request still in flight. num_groups_with_pending_reqs
 	 * should be decremented when the in-flight request of the
-	 * last descendant process is finally completed (assuming that
+	 * last process is finally completed (assuming that
 	 * nothing else has changed for the group in the meantime, in
 	 * terms of composition of the group and active/inactive state of child
 	 * groups and processes). To accomplish this, an additional
@@ -524,7 +524,7 @@ struct bfq_data {
 	 * we resort to the following tradeoff between simplicity and
 	 * accuracy: for an inactive group that is still counted in
 	 * num_groups_with_pending_reqs, we decrement
-	 * num_groups_with_pending_reqs when the first descendant
+	 * num_groups_with_pending_reqs when the first
 	 * process of the group remains with no request waiting for
 	 * completion.
 	 *
@@ -532,12 +532,12 @@ struct bfq_data {
 	 * carefulness: to avoid multiple decrements, we flag a group,
 	 * more precisely an entity representing a group, as still
 	 * counted in num_groups_with_pending_reqs when it becomes
-	 * inactive. Then, when the first descendant queue of the
+	 * inactive. Then, when the first queue of the
 	 * entity remains with no request waiting for completion,
 	 * num_groups_with_pending_reqs is decremented, and this flag
 	 * is reset. After this flag is reset for the entity,
 	 * num_groups_with_pending_reqs won't be decremented any
-	 * longer in case a new descendant queue of the entity remains
+	 * longer in case a new queue of the entity remains
 	 * with no request waiting for completion.
 	 */
 	unsigned int num_groups_with_pending_reqs;
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index ae12c6b2c525..e848d5d2bcdc 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -979,19 +979,6 @@ static void __bfq_activate_entity(struct bfq_entity *entity,
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
 
-- 
2.31.1

