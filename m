From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2 block/for-6.2] blk-iolatency: Make initialization lazy
Date: Sat, 10 Dec 2022 08:34:59 -1000
Message-ID: <Y5TRU2+s379DhUbj@slm.duckdns.org>
References: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uY04nYXLVzuNbDq8d1mF0P2iWu8Vn/aqFvQdGInkT+U=;
        b=Q4Z+xbyvQLwy6YCSc3VKV/vv66l6CO/FJX6LLn1CZqXpM7GmPTER00jPUfsDLbpxQR
         NXxBhcjscA5Ksyai91lI8ZTKrgvdD4uGPeLTBSHhLQ1We78ZgiDjQgYuq/K1oxPXp269
         olUX7zXOKyl3iiosYHagArqjSc+/xUEUK+gom6eL4PLR4gKFa5127JmBOMa1iMdflG03
         0Tvbfcs6cDJS29KnFrDlSP9Zn1qD/q95LQOOrZo3keK1uT5eJzGTigCGJc8qbsaUVan/
         mp8hZLY/k20sWRXmcgTtBD4lnyJaKpqTJYwyimmtI8nBHV8WjiFA2HJrcS71uasFC8Yl
         vZSg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y5TQ5gm3O4HXrXR3@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, darklight2357@icloud.com, Josef Bacik <josef@toxicpanda.com>, Linus Torvalds <torvalds@linux-foundation.org>, cgroups@vger.kernel.org

Other rq_qos policies such as wbt and iocost are lazy-initialized when they
are configured for the first time for the device but iolatency is
initialized unconditionally from blkcg_init_disk() during gendisk init. Lazy
init is beneficial because rq_qos policies add runtime overhead when
initialized as every IO has to walk all registered rq_qos callbacks.

This patch switches iolatency to lazy initialization too so that it only
registered its rq_qos policy when it is first configured.

Note that there is a known race condition between blkcg config file writes
and del_gendisk() and this patch makes iolatency susceptible to it by
exposing the init path to race against the deletion path. However, that
problem already exists in iocost and is being worked on.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
---
Hello,

Tagged for-6.2 but this can easily go for the next merge window too.

Thanks.

 block/blk-cgroup.c    |    8 --------
 block/blk-iolatency.c |   36 ++++++++++++++++++++++++++++++++++--
 block/blk-rq-qos.h    |    2 +-
 block/blk.h           |    6 ------
 4 files changed, 35 insertions(+), 17 deletions(-)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -33,7 +33,6 @@
 #include "blk-cgroup.h"
 #include "blk-ioprio.h"
 #include "blk-throttle.h"
-#include "blk-rq-qos.h"
 
 /*
  * blkcg_pol_mutex protects blkcg_policy[] and policy [de]activation.
@@ -1300,14 +1299,8 @@ int blkcg_init_disk(struct gendisk *disk
 	if (ret)
 		goto err_ioprio_exit;
 
-	ret = blk_iolatency_init(disk);
-	if (ret)
-		goto err_throtl_exit;
-
 	return 0;
 
-err_throtl_exit:
-	blk_throtl_exit(disk);
 err_ioprio_exit:
 	blk_ioprio_exit(disk);
 err_destroy_all:
@@ -1323,7 +1316,6 @@ err_unlock:
 void blkcg_exit_disk(struct gendisk *disk)
 {
 	blkg_destroy_all(disk);
-	rq_qos_exit(disk->queue);
 	blk_throtl_exit(disk);
 }
 
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -755,7 +755,7 @@ static void blkiolatency_enable_work_fn(
 	}
 }
 
-int blk_iolatency_init(struct gendisk *disk)
+static int blk_iolatency_init(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blk_iolatency *blkiolat;
@@ -830,6 +830,31 @@ static void iolatency_clear_scaling(stru
 	}
 }
 
+static int blk_iolatency_try_init(char *input)
+{
+	static DEFINE_MUTEX(init_mutex);
+	struct block_device *bdev;
+	int ret = 0;
+
+	bdev = blkcg_conf_open_bdev(&input);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	/*
+	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
+	 * confuse iolat_rq_qos() test. Make the test and init atomic.
+	 */
+	mutex_lock(&init_mutex);
+
+	if (!iolat_rq_qos(bdev->bd_queue))
+		ret = blk_iolatency_init(bdev->bd_disk);
+
+	mutex_unlock(&init_mutex);
+	blkdev_put_no_open(bdev);
+
+	return ret;
+}
+
 static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
 			     size_t nbytes, loff_t off)
 {
@@ -842,7 +867,14 @@ static ssize_t iolatency_set_limit(struc
 	u64 oldval;
 	int ret;
 
+retry:
 	ret = blkg_conf_prep(blkcg, &blkcg_policy_iolatency, buf, &ctx);
+	if (ret == -EOPNOTSUPP) {
+		ret = blk_iolatency_try_init(buf);
+		if (ret)
+			return ret;
+		goto retry;
+	}
 	if (ret)
 		return ret;
 
@@ -974,7 +1006,7 @@ static void iolatency_pd_init(struct blk
 {
 	struct iolatency_grp *iolat = pd_to_lat(pd);
 	struct blkcg_gq *blkg = lat_to_blkg(iolat);
-	struct rq_qos *rqos = blkcg_rq_qos(blkg->q);
+	struct rq_qos *rqos = iolat_rq_qos(blkg->q);
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -74,7 +74,7 @@ static inline struct rq_qos *wbt_rq_qos(
 	return rq_qos_id(q, RQ_QOS_WBT);
 }
 
-static inline struct rq_qos *blkcg_rq_qos(struct request_queue *q)
+static inline struct rq_qos *iolat_rq_qos(struct request_queue *q)
 {
 	return rq_qos_id(q, RQ_QOS_LATENCY);
 }
--- a/block/blk.h
+++ b/block/blk.h
@@ -392,12 +392,6 @@ static inline struct bio *blk_queue_boun
 	return bio;
 }
 
-#ifdef CONFIG_BLK_CGROUP_IOLATENCY
-int blk_iolatency_init(struct gendisk *disk);
-#else
-static inline int blk_iolatency_init(struct gendisk *disk) { return 0; };
-#endif
-
 #ifdef CONFIG_BLK_DEV_ZONED
 void disk_free_zone_bitmaps(struct gendisk *disk);
 void disk_clear_zone_settings(struct gendisk *disk);
