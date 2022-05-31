From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v8 1/4] block, bfq: support to track if bfqq has pending requests
Date: Tue, 31 May 2022 22:08:55 +0800
Message-ID: <20220531140858.3324294-2-yukuai3@huawei.com>
References: <20220531140858.3324294-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220531140858.3324294-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If entity belongs to bfqq, then entity->in_groups_with_pending_reqs
is not used currently. This patch use it to track if bfqq has pending
requests through callers of weights_tree insertion and removal.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c |  1 +
 block/bfq-iosched.h |  1 +
 block/bfq-wf2q.c    | 24 ++++++++++++++++++++++--
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 0d46cb728bbf..0ec21018daba 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6263,6 +6263,7 @@ static void bfq_completed_request(struct bfq_queue *bfqq, struct bfq_data *bfqd)
 		 */
 		bfqq->budget_timeout = jiffies;
 
+		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
 		bfq_weights_tree_remove(bfqd, bfqq);
 	}
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index ca8177d7bf7c..3b9b1a0e7c1c 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1080,6 +1080,7 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		       bool expiration);
 void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq);
+void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq);
 
 /* --------------- end of interface of B-WF2Q+ ---------------- */
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index f8eb340381cf..12d20f26ad69 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1647,6 +1647,22 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 				    bfqq == bfqd->in_service_queue, expiration);
 }
 
+static void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
+{
+	struct bfq_entity *entity = &bfqq->entity;
+
+	if (!entity->in_groups_with_pending_reqs)
+		entity->in_groups_with_pending_reqs = true;
+}
+
+void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
+{
+	struct bfq_entity *entity = &bfqq->entity;
+
+	if (entity->in_groups_with_pending_reqs)
+		entity->in_groups_with_pending_reqs = false;
+}
+
 /*
  * Called when the bfqq no longer has requests pending, remove it from
  * the service tree. As a special case, it can be invoked during an
@@ -1668,8 +1684,10 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	bfq_deactivate_bfqq(bfqd, bfqq, true, expiration);
 
-	if (!bfqq->dispatched)
+	if (!bfqq->dispatched) {
+		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
 		bfq_weights_tree_remove(bfqd, bfqq);
+	}
 }
 
 /*
@@ -1684,10 +1702,12 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_mark_bfqq_busy(bfqq);
 	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
 
-	if (!bfqq->dispatched)
+	if (!bfqq->dispatched) {
+		bfq_add_bfqq_in_groups_with_pending_reqs(bfqq);
 		if (bfqq->wr_coeff == 1)
 			bfq_weights_tree_add(bfqd, bfqq,
 					     &bfqd->queue_weights_tree);
+	}
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues++;
-- 
2.31.1

