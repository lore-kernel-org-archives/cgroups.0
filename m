From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v4] block: don't allow the same type rq_qos add more than once
Date: Wed, 20 Jul 2022 17:36:16 +0800
Message-ID: <20220720093616.70584-1-hanjinke.666@bytedance.com>
References: <20220719165313.51887-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oXKrqXNoQbGqXRKsJ331SBJ7YG/0WKRR7aaK+WgaUgE=;
        b=joNrTJHxlVPnJRGb4f5KBM5NAjHQOSGvKdfYEBNnHb8bcv1/Cdl6rj5AtCz2mXeGsc
         +zeKQDsw5+SGysz+Zn8WbGnYPEOF9wEd8xMZr60qGCNCFk7lUkxLi7bF7xKlvFVr6lam
         3TXrUBnFuLI3eDmOUseVnQV+2f8rBmyqjlHAN1ZLBPXNqC0UPGcEyqSjDfQRad2lcj70
         31HL/lKNDBycUOE5opjsi7vGRYVlh6XQHrM52h6Pnn0TGM9joWEB2HY/it4SzmjknpuI
         xKjTJE8SF8n4ik1FteRU7FclP6t3uzinZkzJsc2YGJs1pqgMLWtGZ/U03nKtca6ZhOFm
         SLQA==
In-Reply-To: <20220719165313.51887-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

In our test of iocost, we encountered some list add/del corruptions of
inner_walk list in ioc_timer_fn.

The reason can be described as follow:
cpu 0						cpu 1
ioc_qos_write					ioc_qos_write

ioc = q_to_ioc(bdev_get_queue(bdev));
if (!ioc) {
        ioc = kzalloc();			ioc = q_to_ioc(bdev_get_queue(bdev));
						if (!ioc) {
							ioc = kzalloc();
							...
							rq_qos_add(q, rqos);
						}
        ...
        rq_qos_add(q, rqos);
        ...
}

When the io.cost.qos file is written by two cpus concurrently, rq_qos may
be added to one disk twice. In that case, there will be two iocs enabled
and running on one disk. They own different iocgs on their active list.
In the ioc_timer_fn function, because of the iocgs from two iocs have the
same root iocg, the root iocg's walk_list may be overwritten by each
other and this leads to list add/del corruptions in building or destroying
the inner_walk list.

And so far, the blk-rq-qos framework works in case that one instance for
one type rq_qos per queue by default. This patch make this explicit and
also fix the crash above.

Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
Changes in v2
-use goto pattern in iocost and rename the ebusy label
Changes in v3
-use goto in all places
Changes in v4
-correct some spell errors and resolve conflict with next kernel

 block/blk-iocost.c    | 20 +++++++++++++-------
 block/blk-iolatency.c | 18 +++++++++++-------
 block/blk-rq-qos.h    | 11 ++++++++++-
 block/blk-wbt.c       | 12 +++++++++++-
 4 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b7082f2aed9c..7936e5f5821c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2886,15 +2886,21 @@ static int blk_iocost_init(struct request_queue *q)
 	 * called before policy activation completion, can't assume that the
 	 * target bio has an iocg associated and need to test for NULL iocg.
 	 */
-	rq_qos_add(q, rqos);
+	ret = rq_qos_add(q, rqos);
+	if (ret)
+		goto err_free_ioc;
+
 	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
-	if (ret) {
-		rq_qos_del(q, rqos);
-		free_percpu(ioc->pcpu_stat);
-		kfree(ioc);
-		return ret;
-	}
+	if (ret)
+		goto err_del_qos;
 	return 0;
+
+err_del_qos:
+	rq_qos_del(q, rqos);
+err_free_ioc:
+	free_percpu(ioc->pcpu_stat);
+	kfree(ioc);
+	return ret;
 }
 
 static struct blkcg_policy_data *ioc_cpd_alloc(gfp_t gfp)
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 79745c6d8e15..e285152345a2 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -771,19 +771,23 @@ int blk_iolatency_init(struct request_queue *q)
 	rqos->ops = &blkcg_iolatency_ops;
 	rqos->q = q;
 
-	rq_qos_add(q, rqos);
-
+	ret = rq_qos_add(q, rqos);
+	if (ret)
+		goto err_free;
 	ret = blkcg_activate_policy(q, &blkcg_policy_iolatency);
-	if (ret) {
-		rq_qos_del(q, rqos);
-		kfree(blkiolat);
-		return ret;
-	}
+	if (ret)
+		goto err_qos_del;
 
 	timer_setup(&blkiolat->timer, blkiolatency_timer_fn, 0);
 	INIT_WORK(&blkiolat->enable_work, blkiolatency_enable_work_fn);
 
 	return 0;
+
+err_qos_del:
+	rq_qos_del(q, rqos);
+err_free:
+	kfree(blkiolat);
+	return ret;
 }
 
 static void iolatency_set_min_lat_nsec(struct blkcg_gq *blkg, u64 val)
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 0e46052b018a..08b856570ad1 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -86,7 +86,7 @@ static inline void rq_wait_init(struct rq_wait *rq_wait)
 	init_waitqueue_head(&rq_wait->wait);
 }
 
-static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
+static inline int rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 {
 	/*
 	 * No IO can be in-flight when adding rqos, so freeze queue, which
@@ -98,6 +98,8 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 	blk_mq_freeze_queue(q);
 
 	spin_lock_irq(&q->queue_lock);
+	if (rq_qos_id(q, rqos->id))
+		goto ebusy;
 	rqos->next = q->rq_qos;
 	q->rq_qos = rqos;
 	spin_unlock_irq(&q->queue_lock);
@@ -109,6 +111,13 @@ static inline void rq_qos_add(struct request_queue *q, struct rq_qos *rqos)
 		blk_mq_debugfs_register_rqos(rqos);
 		mutex_unlock(&q->debugfs_mutex);
 	}
+
+	return 0;
+ebusy:
+	spin_unlock_irq(&q->queue_lock);
+	blk_mq_unfreeze_queue(q);
+	return -EBUSY;
+
 }
 
 static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index f2e4bf1dca47..a9982000b667 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -820,6 +820,7 @@ int wbt_init(struct request_queue *q)
 {
 	struct rq_wb *rwb;
 	int i;
+	int ret;
 
 	rwb = kzalloc(sizeof(*rwb), GFP_KERNEL);
 	if (!rwb)
@@ -846,7 +847,10 @@ int wbt_init(struct request_queue *q)
 	/*
 	 * Assign rwb and add the stats callback.
 	 */
-	rq_qos_add(q, &rwb->rqos);
+	ret = rq_qos_add(q, &rwb->rqos);
+	if (ret)
+		goto err_free;
+
 	blk_stat_add_callback(q, rwb->cb);
 
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
@@ -855,4 +859,10 @@ int wbt_init(struct request_queue *q)
 	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
 
 	return 0;
+
+err_free:
+	blk_stat_free_callback(rwb->cb);
+	kfree(rwb);
+	return ret;
+
 }
-- 
2.20.1

