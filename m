From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 4/4] block/rq_qos: fail rq_qos_add() after rq_qos_exit()
Date: Wed,  4 Jan 2023 16:53:54 +0800
Message-ID: <20230104085354.2343590-5-yukuai1@huaweicloud.com>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230104085354.2343590-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

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

Fix the problem by setting q->rq_qos to a special value in
rq_qos_exit(), and check the value in rq_qos_add().

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-rq-qos.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 5f7ccc249c11..cfd8024ff6e8 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -290,6 +290,10 @@ void rq_qos_wait(struct rq_wait *rqw, void *private_data,
 
 static int __rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
+	/* See details in rq_qos_exit() for this specail value. */
+	if (IS_ERR(q->rq_qos))
+		return PTR_ERR(q->rq_qos);
+
 	/*
 	 * No IO can be in-flight when adding rqos, so freeze queue, which
 	 * is fine since we only support rq_qos for blk-mq queue.
@@ -356,12 +360,22 @@ void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 
 void rq_qos_exit(struct request_queue *q)
 {
+	struct rq_qos *rqos;
+
 	mutex_lock(&rq_qos_lock);
-	while (q->rq_qos) {
-		struct rq_qos *rqos = q->rq_qos;
-		q->rq_qos = rqos->next;
+	rqos = q->rq_qos;
+
+	/*
+	 * Set q->rq_qos to a special value to make sure rq_qos_add() will fail
+	 * after rq_qos_exit().
+	 */
+	q->rq_qos = ERR_PTR(-ENODEV);
+
+	while (rqos) {
 		rqos->ops->exit(rqos);
+		rqos = rqos->next;
 	}
+
 	mutex_unlock(&rq_qos_lock);
 }
 
-- 
2.31.1

