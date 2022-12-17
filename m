From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 1/4] block/rq_qos: protect 'q->rq_qos' with queue_lock in rq_qos_exit()
Date: Sat, 17 Dec 2022 11:09:05 +0800
Message-ID: <20221217030908.1261787-2-yukuai1@huaweicloud.com>
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

queue_lock is held to protect 'q->rqos' in rq_qos_add() and
rq_qos_del(), however, it's not held in rq_qos_exit(), while they
can operate the list concurrently:

t1			t2
// configure iocost	//remove device
blk_iocost_init		del_gendisk
 rq_qos_add		 rq_qos_exit

'rqos->ops->exit' can't be called under spinlock because it might
be scheduled out, hence fix the problem by holding queue_lock to
fetch the list and reset q->rq_qos first.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-rq-qos.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 88f0fe7dcf54..efffc6fa55db 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -288,9 +288,16 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 
 void rq_qos_exit(struct request_queue *q)
 {
-	while (q->rq_qos) {
-		struct rq_qos *rqos = q->rq_qos;
-		q->rq_qos = rqos->next;
-		rqos->ops->exit(rqos);
-	}
+	struct rq_qos *rqos;
+
+	spin_lock_irq(&q->queue_lock);
+	rqos = q->rq_qos;
+	q->rq_qos = NULL;
+	spin_unlock_irq(&q->queue_lock);
+
+	do {
+		if (rqos->ops->exit)
+			rqos->ops->exit(rqos);
+		rqos = rqos->next;
+	} while (rqos);
 }
-- 
2.31.1

