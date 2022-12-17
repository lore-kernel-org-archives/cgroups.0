From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 1/4] blk-iocost: track whether iocg is still online
Date: Sat, 17 Dec 2022 11:05:24 +0800
Message-ID: <20221217030527.1250083-2-yukuai1@huaweicloud.com>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221217030527.1250083-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

blkcg_gq->online can't be used in iocost because it gets cleared only after
all policies are offlined. This patch add a new field 'online' in iocg.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 3aeb8538f0c3..1498879c4a52 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -459,6 +459,8 @@ struct ioc_gq {
 	struct blkg_policy_data		pd;
 	struct ioc			*ioc;
 
+	bool online;
+
 	/*
 	 * A iocg can get its weight from two sources - an explicit
 	 * per-device-cgroup configuration or the default weight of the
@@ -2952,6 +2954,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	ioc_now(ioc, &now);
 
 	iocg->ioc = ioc;
+	iocg->online = true;
 	atomic64_set(&iocg->vtime, now.vnow);
 	atomic64_set(&iocg->done_vtime, now.vnow);
 	atomic64_set(&iocg->active_period, atomic64_read(&ioc->cur_period));
@@ -2977,6 +2980,19 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	spin_unlock_irqrestore(&ioc->lock, flags);
 }
 
+static void ioc_pd_offline(struct blkg_policy_data *pd)
+{
+	struct ioc_gq *iocg = pd_to_iocg(pd);
+	struct ioc *ioc = iocg->ioc;
+	unsigned long flags;
+
+	if (ioc) {
+		spin_lock_irqsave(&ioc->lock, flags);
+		iocg->online = false;
+		spin_unlock_irqrestore(&ioc->lock, flags);
+	}
+}
+
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
@@ -3467,6 +3483,7 @@ static struct blkcg_policy blkcg_policy_iocost = {
 	.cpd_free_fn	= ioc_cpd_free,
 	.pd_alloc_fn	= ioc_pd_alloc,
 	.pd_init_fn	= ioc_pd_init,
+	.pd_offline_fn	= ioc_pd_offline,
 	.pd_free_fn	= ioc_pd_free,
 	.pd_stat_fn	= ioc_pd_stat,
 };
-- 
2.31.1

