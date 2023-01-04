From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 2/4] block/rq_qos: factor out a helper to add rq_qos and activate policy
Date: Wed,  4 Jan 2023 16:53:52 +0800
Message-ID: <20230104085354.2343590-3-yukuai1@huaweicloud.com>
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

For the policy that use both rq_qos and blkcg_policy, rq_qos_add() and
blkcg_activate_policy() should be atomic, otherwise null-ptr-deference
can be triggered. This patch prepare to use a global mutex to protect
them, there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c    | 14 +-------------
 block/blk-iolatency.c |  7 +------
 block/blk-rq-qos.c    | 23 +++++++++++++++++++++++
 block/blk-rq-qos.h    |  6 ++++++
 4 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 6955605629e4..9199124f0cc2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2883,23 +2883,11 @@ static int blk_iocost_init(struct gendisk *disk)
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
-	/*
-	 * rqos must be added before activation to allow ioc_pd_init() to
-	 * lookup the ioc from q. This means that the rqos methods may get
-	 * called before policy activation completion, can't assume that the
-	 * target bio has an iocg associated and need to test for NULL iocg.
-	 */
-	ret = rq_qos_add(q, rqos);
+	ret = rq_qos_add_and_activate_policy(q, rqos, &blkcg_policy_iocost);
 	if (ret)
 		goto err_free_ioc;
-
-	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
-	if (ret)
-		goto err_del_qos;
 	return 0;
 
-err_del_qos:
-	rq_qos_del(q, rqos);
 err_free_ioc:
 	free_percpu(ioc->pcpu_stat);
 	kfree(ioc);
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index ecdc10741836..a29b923e2a6a 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -771,20 +771,15 @@ int blk_iolatency_init(struct gendisk *disk)
 	rqos->ops = &blkcg_iolatency_ops;
 	rqos->q = q;
 
-	ret = rq_qos_add(q, rqos);
+	ret = rq_qos_add_and_activate_policy(q, rqos, &blkcg_policy_iolatency);
 	if (ret)
 		goto err_free;
-	ret = blkcg_activate_policy(q, &blkcg_policy_iolatency);
-	if (ret)
-		goto err_qos_del;
 
 	timer_setup(&blkiolat->timer, blkiolatency_timer_fn, 0);
 	INIT_WORK(&blkiolat->enable_work, blkiolatency_enable_work_fn);
 
 	return 0;
 
-err_qos_del:
-	rq_qos_del(q, rqos);
 err_free:
 	kfree(blkiolat);
 	return ret;
diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index b6ea40775b2a..50544bfb12f1 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -353,3 +353,26 @@ void rq_qos_exit(struct request_queue *q)
 		rqos->ops->exit(rqos);
 	}
 }
+
+#ifdef CONFIG_BLK_CGROUP
+int rq_qos_add_and_activate_policy(struct request_queue *q, struct rq_qos *rqos,
+				   const struct blkcg_policy *pol)
+{
+	/*
+	 * rqos must be added before activation to allow pd_init_fn() to
+	 * lookup the global structure from q. This means that the rqos methods
+	 * may get called before policy activation completion, can't assume that
+	 * the target bio has an pd associated and need to test for NULL.
+	 */
+	int ret = rq_qos_add(q, rqos);
+
+	if (ret)
+		return ret;
+
+	ret = blkcg_activate_policy(q, pol);
+	if (ret)
+		rq_qos_del(q, rqos);
+
+	return ret;
+}
+#endif
diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index f2d95e19d7a8..0778cff3777c 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -173,4 +173,10 @@ static inline void rq_qos_queue_depth_changed(struct request_queue *q)
 		__rq_qos_queue_depth_changed(q->rq_qos);
 }
 
+#ifdef CONFIG_BLK_CGROUP
+#include "blk-cgroup.h"
+int rq_qos_add_and_activate_policy(struct request_queue *q, struct rq_qos *rqos,
+				   const struct blkcg_policy *pol);
+#endif
+
 #endif
-- 
2.31.1

