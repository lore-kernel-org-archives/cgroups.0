From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 3/4] blk-cgroup: add a new interface blkcg_conf_close_bdev()
Date: Sat, 17 Dec 2022 11:09:07 +0800
Message-ID: <20221217030908.1261787-4-yukuai1@huaweicloud.com>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

It's the same as blkdev_put_no_open() for now, prepare to synchronize
del_gendisk() with configuring cgroup policy. There are no functional
changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 9 +++++++--
 block/blk-cgroup.h | 1 +
 block/blk-iocost.c | 8 ++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 77f44472b41e..ad612148cf3b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -662,6 +662,11 @@ struct block_device *blkcg_conf_open_bdev(char **inputp)
 	return bdev;
 }
 
+void blkcg_conf_close_bdev(struct block_device *bdev)
+{
+	blkdev_put_no_open(bdev);
+}
+
 /**
  * blkg_conf_prep - parse and prepare for per-blkg config update
  * @blkcg: target block cgroup
@@ -781,7 +786,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 fail_exit_queue:
 	blk_queue_exit(q);
 fail:
-	blkdev_put_no_open(bdev);
+	blkcg_conf_close_bdev(bdev);
 	/*
 	 * If queue was bypassing, we should retry.  Do so after a
 	 * short msleep().  It isn't strictly necessary but queue
@@ -808,7 +813,7 @@ void blkg_conf_finish(struct blkg_conf_ctx *ctx)
 {
 	spin_unlock_irq(&bdev_get_queue(ctx->bdev)->queue_lock);
 	rcu_read_unlock();
-	blkdev_put_no_open(ctx->bdev);
+	blkcg_conf_close_bdev(ctx->bdev);
 }
 EXPORT_SYMBOL_GPL(blkg_conf_finish);
 
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 1e94e404eaa8..d4ae1e7288c1 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -214,6 +214,7 @@ struct blkg_conf_ctx {
 };
 
 struct block_device *blkcg_conf_open_bdev(char **inputp);
+void blkcg_conf_close_bdev(struct block_device *bdev);
 int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		   char *input, struct blkg_conf_ctx *ctx);
 void blkg_conf_finish(struct blkg_conf_ctx *ctx);
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index d1bdc12deaa7..5294a404c892 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3288,7 +3288,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	blk_mq_unquiesce_queue(disk->queue);
 	blk_mq_unfreeze_queue(disk->queue);
 
-	blkdev_put_no_open(bdev);
+	blkcg_conf_close_bdev(bdev);
 	return nbytes;
 einval:
 	spin_unlock_irq(&ioc->lock);
@@ -3298,7 +3298,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 
 	ret = -EINVAL;
 err:
-	blkdev_put_no_open(bdev);
+	blkcg_conf_close_bdev(bdev);
 	return ret;
 }
 
@@ -3424,7 +3424,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
-	blkdev_put_no_open(bdev);
+	blkcg_conf_close_bdev(bdev);
 	return nbytes;
 
 einval:
@@ -3435,7 +3435,7 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 
 	ret = -EINVAL;
 err:
-	blkdev_put_no_open(bdev);
+	blkcg_conf_close_bdev(bdev);
 	return ret;
 }
 
-- 
2.31.1

