From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context warnning
Date: Fri,  4 Nov 2022 10:39:37 +0800
Message-ID: <20221104023938.2346986-5-yukuai1@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221104023938.2346986-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

match_u64() is called inside ioc->lock, which causes smatch static
checker warnings:

block/blk-iocost.c:3211 ioc_qos_write() warn: sleeping in atomic context
block/blk-iocost.c:3240 ioc_qos_write() warn: sleeping in atomic context
block/blk-iocost.c:3407 ioc_cost_model_write() warn: sleeping in atomic
context

Fix the problem by introducing a mutex and using it while prasing input
params.

Fixes: 2c0647988433 ("blk-iocost: don't release 'ioc->lock' while updating params")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2bfecc511dd9..192ad4e0cfc6 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -404,6 +404,7 @@ struct ioc {
 
 	bool				enabled;
 
+	struct mutex			params_mutex;
 	struct ioc_params		params;
 	struct ioc_margins		margins;
 	u32				period_us;
@@ -2212,6 +2213,8 @@ static void ioc_timer_fn(struct timer_list *timer)
 	/* how were the latencies during the period? */
 	ioc_lat_stat(ioc, missed_ppm, &rq_wait_pct);
 
+	mutex_lock(&ioc->params_mutex);
+
 	/* take care of active iocgs */
 	spin_lock_irq(&ioc->lock);
 
@@ -2222,6 +2225,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	period_vtime = now.vnow - ioc->period_at_vtime;
 	if (WARN_ON_ONCE(!period_vtime)) {
 		spin_unlock_irq(&ioc->lock);
+		mutex_unlock(&ioc->params_mutex);
 		return;
 	}
 
@@ -2419,6 +2423,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 	}
 
 	spin_unlock_irq(&ioc->lock);
+	mutex_unlock(&ioc->params_mutex);
 }
 
 static u64 adjust_inuse_and_calc_cost(struct ioc_gq *iocg, u64 vtime,
@@ -2801,9 +2806,11 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
 
+	mutex_lock(&ioc->params_mutex);
 	spin_lock_irq(&ioc->lock);
 	ioc_refresh_params(ioc, false);
 	spin_unlock_irq(&ioc->lock);
+	mutex_unlock(&ioc->params_mutex);
 }
 
 static void ioc_rqos_exit(struct rq_qos *rqos)
@@ -2862,6 +2869,7 @@ static int blk_iocost_init(struct gendisk *disk)
 	rqos->ops = &ioc_rqos_ops;
 	rqos->q = q;
 
+	mutex_init(&ioc->params_mutex);
 	spin_lock_init(&ioc->lock);
 	timer_setup(&ioc->timer, ioc_timer_fn, 0);
 	INIT_LIST_HEAD(&ioc->active_iocgs);
@@ -2874,10 +2882,12 @@ static int blk_iocost_init(struct gendisk *disk)
 	atomic64_set(&ioc->cur_period, 0);
 	atomic_set(&ioc->hweight_gen, 0);
 
+	mutex_lock(&ioc->params_mutex);
 	spin_lock_irq(&ioc->lock);
 	ioc->autop_idx = AUTOP_INVALID;
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
+	mutex_unlock(&ioc->params_mutex);
 
 	/*
 	 * rqos must be added before activation to allow iocg_pd_init() to
@@ -3197,7 +3207,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	blk_mq_freeze_queue(disk->queue);
 	blk_mq_quiesce_queue(disk->queue);
 
-	spin_lock_irq(&ioc->lock);
+	mutex_lock(&ioc->params_mutex);
 	memcpy(qos, ioc->params.qos, sizeof(qos));
 	enable = ioc->enabled;
 	user = ioc->user_qos_params;
@@ -3278,6 +3288,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	if (qos[QOS_MIN] > qos[QOS_MAX])
 		goto out_unlock;
 
+	spin_lock_irq(&ioc->lock);
 	if (enable) {
 		blk_stat_enable_accounting(disk->queue);
 		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
@@ -3298,9 +3309,10 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 
 	ioc_refresh_params(ioc, true);
 	ret = nbytes;
+	spin_unlock_irq(&ioc->lock);
 
 out_unlock:
-	spin_unlock_irq(&ioc->lock);
+	mutex_unlock(&ioc->params_mutex);
 	blk_mq_unquiesce_queue(disk->queue);
 	blk_mq_unfreeze_queue(disk->queue);
 
@@ -3385,7 +3397,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	blk_mq_freeze_queue(q);
 	blk_mq_quiesce_queue(q);
 
-	spin_lock_irq(&ioc->lock);
+	mutex_lock(&ioc->params_mutex);
 	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
 	user = ioc->user_cost_model;
 
@@ -3431,6 +3443,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		user = true;
 	}
 
+	spin_lock_irq(&ioc->lock);
 	if (user) {
 		memcpy(ioc->params.i_lcoefs, u, sizeof(u));
 		ioc->user_cost_model = true;
@@ -3440,9 +3453,10 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 
 	ioc_refresh_params(ioc, true);
 	ret = nbytes;
+	spin_unlock_irq(&ioc->lock);
 
 out_unlock:
-	spin_unlock_irq(&ioc->lock);
+	mutex_unlock(&ioc->params_mutex);
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
-- 
2.31.1

