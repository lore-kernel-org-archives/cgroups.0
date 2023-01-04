From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect rq_qos apis
Date: Wed,  4 Jan 2023 16:53:53 +0800
Message-ID: <20230104085354.2343590-4-yukuai1@huaweicloud.com>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

This patch fix following problems:

1) rq_qos_add() and rq_qos_del() is protected, while rq_qos_exit() is
   not.
2) rq_qos_add() and blkcg_activate_policy() is not atomic, if
   rq_qos_exit() is done before blkcg_activate_policy(),
   null-ptr-deference can be triggered.

rq_qos_add(), rq_qos_del() and rq_qos_exit() are super cold path, hence
fix the problems by using a global mutex to protect them.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-rq-qos.c | 50 ++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 50544bfb12f1..5f7ccc249c11 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -2,6 +2,8 @@
 
 #include "blk-rq-qos.h"
 
+static DEFINE_MUTEX(rq_qos_lock);
+
 /*
  * Increment 'v', if 'v' is below 'below'. Returns true if we succeeded,
  * false if 'v' + 1 would be bigger than 'below'.
@@ -286,23 +288,18 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 	finish_wait(&rqw->wait, &data.wq);
 }
 
-int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
+static int __rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
 	/*
 	 * No IO can be in-flight when adding rqos, so freeze queue, which
 	 * is fine since we only support rq_qos for blk-mq queue.
-	 *
-	 * Reuse ->queue_lock for protecting against other concurrent
-	 * rq_qos adding/deleting
 	 */
 	blk_mq_freeze_queue(q);
 
-	spin_lock_irq(&q->queue_lock);
 	if (rq_qos_id(q, rqos->id))
 		goto ebusy;
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
-	spin_unlock_irq(&q->queue_lock);
 
 	blk_mq_unfreeze_queue(q);
 
@@ -314,29 +311,23 @@ int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 
 	return 0;
 ebusy:
-	spin_unlock_irq(&q->queue_lock);
 	blk_mq_unfreeze_queue(q);
 	return -EBUSY;
 }
 
-void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
+static void __rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 {
 	struct rq_qos **cur;
 
-	/*
-	 * See comment in rq_qos_add() about freezing queue & using
-	 * ->queue_lock.
-	 */
+	/* See comment in __rq_qos_add() about freezing queue */
 	blk_mq_freeze_queue(q);
 
-	spin_lock_irq(&q->queue_lock);
 	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
 		if (*cur == rqos) {
 			*cur = rqos->next;
 			break;
 		}
 	}
-	spin_unlock_irq(&q->queue_lock);
 
 	blk_mq_unfreeze_queue(q);
 
@@ -345,13 +336,33 @@ void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 	mutex_unlock(&q->debugfs_mutex);
 }
 
+int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
+{
+	int ret;
+
+	mutex_lock(&rq_qos_lock);
+	ret = __rq_qos_add(q, rqos);
+	mutex_unlock(&rq_qos_lock);
+
+	return ret;
+}
+
+void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
+{
+	mutex_lock(&rq_qos_lock);
+	__rq_qos_del(q, rqos);
+	mutex_unlock(&rq_qos_lock);
+}
+
 void rq_qos_exit(struct request_queue *q)
 {
+	mutex_lock(&rq_qos_lock);
 	while (q->rq_qos) {
 		struct rq_qos *rqos = q->rq_qos;
 		q->rq_qos = rqos->next;
 		rqos->ops->exit(rqos);
 	}
+	mutex_unlock(&rq_qos_lock);
 }
 
 #ifdef CONFIG_BLK_CGROUP
@@ -364,15 +375,20 @@ int rq_qos_add_and_activate_policy(struct request_queue *q, struct rq_qos *rqos,
 	 * may get called before policy activation completion, can't assume that
 	 * the target bio has an pd associated and need to test for NULL.
 	 */
-	int ret = rq_qos_add(q, rqos);
+	int ret;
 
-	if (ret)
+	mutex_lock(&rq_qos_lock);
+	ret = __rq_qos_add(q, rqos);
+	if (ret) {
+		mutex_unlock(&rq_qos_lock);
 		return ret;
+	}
 
 	ret = blkcg_activate_policy(q, pol);
 	if (ret)
-		rq_qos_del(q, rqos);
+		__rq_qos_del(q, rqos);
 
+	mutex_unlock(&rq_qos_lock);
 	return ret;
 }
 #endif
-- 
2.31.1

