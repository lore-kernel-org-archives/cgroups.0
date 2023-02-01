From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/19] blk-rq-qos: move rq_qos_add and rq_qos_del out of line
Date: Wed,  1 Feb 2023 14:41:16 +0100
Message-ID: <20230201134123.2656505-13-hch@lst.de>
References: <20230201134123.2656505-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=G1shG5/OrozUHVfAc1cUdd0E76j9UvDUkwrynVgRXzo=; b=LIeCoThpyukJg3cO0I0QvIFP4h
        M5COWk7owYqOGzDVClmgcfi81hyOPEkTDmZ4VcZOPGKCSy03X+xnHG7m20C9Kta4R0gwIYDAoac3Y
        Ohz4vx6VFQhj07yDXW+OcL7aPC8x6bMY92sMzl3ngMeQ8q/k2tmK8X2xyZC7pOEtJyeH9eSE1LwAh
        SGJRvHIax6c8prACWVzIZJVSntdXZDTkO6YGkjju8104NBwqZ9n2tDDepUsWyB+l7XKMq1+ZmdBP6
        NfakIv/KXnjh/DQkHUO9XPYvWJaRQyBi+uOJM+U58+F8o1mxRHS8Jv8zjZywV+rne+PMOZWDEiJs9
        2F3bFlpg==;
In-Reply-To: <20230201134123.2656505-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

These two functions are rather larger and not in a fast path, so move
them out of line.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-rq-qos.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
 block/blk-rq-qos.h | 61 ++--------------------------------------------
 2 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 88f0fe7dcf5451..aae98dcb01ebe7 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -294,3 +294,63 @@ void rq_qos_exit(struct request_queue *q)
 		rqos->ops->exit(rqos);
 	}
 }
+
+int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
+{
+	/*
+	 * No IO can be in-flight when adding rqos, so freeze queue, which
+	 * is fine since we only support rq_qos for blk-mq queue.
+	 *
+	 * Reuse ->queue_lock for protecting against other concurrent
+	 * rq_qos adding/deleting
+	 */
+	blk_mq_freeze_queue(q);
+
+	spin_lock_irq(&q->queue_lock);
+	if (rq_qos_id(q, rqos->id))
+		goto ebusy;
+	rqos->next = q->rq_qos;
+	q->rq_qos = rqos;
+	spin_unlock_irq(&q->queue_lock);
+
+	blk_mq_unfreeze_queue(q);
+
+	if (rqos->ops->debugfs_attrs) {
+		mutex_lock(&q->debugfs_mutex);
+		blk_mq_debugfs_register_rqos(rqos);
+		mutex_unlock(&q->debugfs_mutex);
+	}
+
+	return 0;
+ebusy:
+	spin_unlock_irq(&q->queue_lock);
+	blk_mq_unfreeze_queue(q);
+	return -EBUSY;
+
+}
+
+void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
+{
+	struct rq_qos **cur;
+
+	/*
+	 * See comment in rq_qos_add() about freezing queue & using
+	 * ->queue_lock.
+	 */
+	blk_mq_freeze_queue(q);
+
+	spin_lock_irq(&q->queue_lock);
+	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
+		if (*cur == rqos) {
+			*cur = rqos->next;
+			break;
+		}
+	}
+	spin_unlock_irq(&q->queue_lock);
+
+	blk_mq_unfreeze_queue(q);
+
+	mutex_lock(&q->debugfs_mutex);
+	blk_mq_debugfs_unregister_rqos(rqos);
+	mutex_unlock(&q->debugfs_mutex);
+}
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 1ef1f7d4bc3cbc..805eee8b031d00 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -85,65 +85,8 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
 	init_waitqueue_head(&rq_wait->wait);
 }
 
-static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
-{
-	/*
-	 * No IO can be in-flight when adding rqos, so freeze queue, which
-	 * is fine since we only support rq_qos for blk-mq queue.
-	 *
-	 * Reuse ->queue_lock for protecting against other concurrent
-	 * rq_qos adding/deleting
-	 */
-	blk_mq_freeze_queue(q);
-
-	spin_lock_irq(&q->queue_lock);
-	if (rq_qos_id(q, rqos->id))
-		goto ebusy;
-	rqos->next = q->rq_qos;
-	q->rq_qos = rqos;
-	spin_unlock_irq(&q->queue_lock);
-
-	blk_mq_unfreeze_queue(q);
-
-	if (rqos->ops->debugfs_attrs) {
-		mutex_lock(&q->debugfs_mutex);
-		blk_mq_debugfs_register_rqos(rqos);
-		mutex_unlock(&q->debugfs_mutex);
-	}
-
-	return 0;
-ebusy:
-	spin_unlock_irq(&q->queue_lock);
-	blk_mq_unfreeze_queue(q);
-	return -EBUSY;
-
-}
-
-static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
-{
-	struct rq_qos **cur;
-
-	/*
-	 * See comment in rq_qos_add() about freezing queue & using
-	 * ->queue_lock.
-	 */
-	blk_mq_freeze_queue(q);
-
-	spin_lock_irq(&q->queue_lock);
-	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
-		if (*cur == rqos) {
-			*cur = rqos->next;
-			break;
-		}
-	}
-	spin_unlock_irq(&q->queue_lock);
-
-	blk_mq_unfreeze_queue(q);
-
-	mutex_lock(&q->debugfs_mutex);
-	blk_mq_debugfs_unregister_rqos(rqos);
-	mutex_unlock(&q->debugfs_mutex);
-}
+int rq_qos_add(struct request_queue *q, struct rq_qos *rqos);
+void rq_qos_del(struct request_queue *q, struct rq_qos *rqos);
 
 typedef bool (acquire_inflight_cb_t)(struct rq_wait *rqw, void *private_data);
 typedef void (cleanup_cb_t)(struct rq_wait *rqw, void *private_data);
-- 
2.39.0

