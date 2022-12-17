From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 2/4] block/rq_qos: fail rq_qos_add() after del_gendisk()
Date: Sat, 17 Dec 2022 11:09:06 +0800
Message-ID: <20221217030908.1261787-3-yukuai1@huaweicloud.com>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221217030908.1261787-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

rq_qos_add() can still succeed after rq_qos_exit() is done, which will
cause memory leak because such rq_qos will never be removed.

t1                      t2
// configure iocost
blk_iocost_init
			//remove device
			del_gendisk
			 rq_qos_exit
			 // done nothing because rq_qos doesn't exist
 rq_qos_add
 // will succeed, and rq_qos won't be removed

rq_qos_add() will also be called from blkcg_init_disk() from
__alloc_disk_node(), and GD_DEAD can distinguish between disk
allocation and disk deletion. Fix the problem by checking GD_DEAD in
rq_qos_add().

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-rq-qos.h | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 1ef1f7d4bc3c..81e087139ffb 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -87,6 +87,7 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
 
 static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
+	int err;
 	/*
 	 * No IO can be in-flight when adding rqos, so freeze queue, which
 	 * is fine since we only support rq_qos for blk-mq queue.
@@ -97,8 +98,16 @@ static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 	blk_mq_freeze_queue(q);
 
 	spin_lock_irq(&q->queue_lock);
-	if (rq_qos_id(q, rqos->id))
-		goto ebusy;
+	if (rq_qos_id(q, rqos->id)) {
+		err = -EBUSY;
+		goto err;
+	}
+
+	if (q->disk && test_bit(GD_DEAD, &q->disk->state)) {
+		err = -ENODEV;
+		goto err;
+	}
+
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
 	spin_unlock_irq(&q->queue_lock);
@@ -112,10 +121,10 @@ static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 	}
 
 	return 0;
-ebusy:
+err:
 	spin_unlock_irq(&q->queue_lock);
 	blk_mq_unfreeze_queue(q);
-	return -EBUSY;
+	return err;
 
 }
 
-- 
2.31.1

