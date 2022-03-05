From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 10/11] block, bfq: decrease 'num_groups_with_pending_reqs' earlier
Date: Sat, 5 Mar 2022 17:12:04 +0800
Message-ID: <20220305091205.4188398-11-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Currently 'num_groups_with_pending_reqs' won't be decreased when
the group doesn't have any pending requests, while some child group
still have pending requests. The decrement is delayed to when all the
child groups doesn't have any pending requests.

For example:
1) t1 issue sync io on root group, t2 and t3 issue sync io on the same
child group. num_groups_with_pending_reqs is 2 now.
2) t1 stopped, num_groups_with_pending_reqs is still 2. io from t2 and
t3 still can't be handled concurrently.

Fix the problem by decreasing 'num_groups_with_pending_reqs'
immediately upon the weights_tree removal of last bfqq of the group.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c | 56 +++++++++++++++------------------------------
 block/bfq-iosched.h | 16 ++++++-------
 2 files changed, 27 insertions(+), 45 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index f221e9cab4d0..119b64c9c1d9 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -970,6 +970,24 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
 	bfq_put_queue(bfqq);
 }
 
+static void decrease_groups_with_pending_reqs(struct bfq_data *bfqd,
+					      struct bfq_queue *bfqq)
+{
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	struct bfq_entity *entity = bfqq->entity.parent;
+
+	/*
+	 * The decrement of num_groups_with_pending_reqs is performed
+	 * immediately when the last bfqq completes all the requests.
+	 */
+	if (!bfqq_group(bfqq)->num_entities_with_pending_reqs &&
+	    entity->in_groups_with_pending_reqs) {
+		entity->in_groups_with_pending_reqs = false;
+		bfqd->num_groups_with_pending_reqs--;
+	}
+#endif
+}
+
 /*
  * Invoke __bfq_weights_tree_remove on bfqq and decrement the number
  * of active groups for each queue's inactive parent entity.
@@ -977,8 +995,6 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
 void bfq_weights_tree_remove(struct bfq_data *bfqd,
 			     struct bfq_queue *bfqq)
 {
-	struct bfq_entity *entity = bfqq->entity.parent;
-
 	/*
 	 * grab a ref to prevent bfqq to be freed in
 	 * __bfq_weights_tree_remove
@@ -991,41 +1007,7 @@ void bfq_weights_tree_remove(struct bfq_data *bfqd,
 	 */
 	__bfq_weights_tree_remove(bfqd, bfqq,
 				  &bfqd->queue_weights_tree);
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
+	decrease_groups_with_pending_reqs(bfqd, bfqq);
 	bfq_put_queue(bfqq);
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 5d904851519c..9ec72bd24fc2 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -495,7 +495,7 @@ struct bfq_data {
 	struct rb_root_cached queue_weights_tree;
 
 	/*
-	 * Number of groups with at least one descendant process that
+	 * Number of groups with at least one process that
 	 * has at least one request waiting for completion. Note that
 	 * this accounts for also requests already dispatched, but not
 	 * yet completed. Therefore this number of groups may differ
@@ -508,14 +508,14 @@ struct bfq_data {
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
+	 * num_groups_with_pending_reqs when the last
 	 * process of the group remains with no request waiting for
 	 * completion.
 	 *
@@ -532,12 +532,12 @@ struct bfq_data {
 	 * carefulness: to avoid multiple decrements, we flag a group,
 	 * more precisely an entity representing a group, as still
 	 * counted in num_groups_with_pending_reqs when it becomes
-	 * inactive. Then, when the first descendant queue of the
+	 * inactive. Then, when the last queue of the
 	 * entity remains with no request waiting for completion,
 	 * num_groups_with_pending_reqs is decremented, and this flag
 	 * is reset. After this flag is reset for the entity,
 	 * num_groups_with_pending_reqs won't be decremented any
-	 * longer in case a new descendant queue of the entity remains
+	 * longer in case a new queue of the entity remains
 	 * with no request waiting for completion.
 	 */
 	unsigned int num_groups_with_pending_reqs;
-- 
2.31.1

