From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 4/5] blk-iocost: fix sleeping in atomic context warnning in ioc_qos_write()
Date: Fri, 28 Oct 2022 18:10:55 +0800
Message-ID: <20221028101056.1971715-5-yukuai1@huaweicloud.com>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

match_u64() is called inside ioc->lock, which causes smatch static
checker warnings:

block/blk-iocost.c:3211 ioc_qos_write() warn: sleeping in atomic context
block/blk-iocost.c:3240 ioc_qos_write() warn: sleeping in atomic context

Fix the problem by prase params before holding the lock.

Fixes: 2c0647988433 ("blk-iocost: don't release 'ioc->lock' while updating params")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-iocost.c | 172 +++++++++++++++++++++++++++++----------------
 1 file changed, 111 insertions(+), 61 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2bfecc511dd9..27b41f3f1b07 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3165,44 +3165,25 @@ static const match_table_t qos_tokens = {
 	{ NR_QOS_PARAMS,	NULL		},
 };
 
-static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
-			     size_t nbytes, loff_t off)
-{
-	struct block_device *bdev;
-	struct gendisk *disk;
-	struct ioc *ioc;
+struct ioc_qos_params {
 	u32 qos[NR_QOS_PARAMS];
-	bool enable, user;
-	char *p;
-	int ret;
-
-	bdev = blkcg_conf_open_bdev(&input);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-
-	disk = bdev->bd_disk;
-	if (!queue_is_mq(disk->queue)) {
-		ret = -EPERM;
-		goto out;
-	}
-
-	ioc = q_to_ioc(disk->queue);
-	if (!ioc) {
-		ret = blk_iocost_init(disk);
-		if (ret)
-			goto out;
-		ioc = q_to_ioc(disk->queue);
-	}
+	bool enable;
+	bool user;
+	bool set_qos[NR_QOS_PARAMS];
+	bool set_enable;
+	bool set_user;
+};
 
-	blk_mq_freeze_queue(disk->queue);
-	blk_mq_quiesce_queue(disk->queue);
+static struct ioc_qos_params *ioc_qos_parse_params(char *input)
+{
+	struct ioc_qos_params *params;
+	char *p;
+	int ret = -EINVAL;
 
-	spin_lock_irq(&ioc->lock);
-	memcpy(qos, ioc->params.qos, sizeof(qos));
-	enable = ioc->enabled;
-	user = ioc->user_qos_params;
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params)
+		return ERR_PTR(-ENOMEM);
 
-	ret = -EINVAL;
 	while ((p = strsep(&input, " \t\n"))) {
 		substring_t args[MAX_OPT_ARGS];
 		char buf[32];
@@ -3218,19 +3199,21 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 			err = match_u64(&args[0], &v);
 			if (err) {
 				ret = err;
-				goto out_unlock;
+				goto out_err;
 			}
 
-			enable = v;
+			params->enable = v;
+			params->set_enable = true;
 			continue;
 		case QOS_CTRL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
 			if (!strcmp(buf, "auto"))
-				user = false;
+				params->user = false;
 			else if (!strcmp(buf, "user"))
-				user = true;
+				params->user = true;
 			else
-				goto out_unlock;
+				goto out_err;
+			params->set_user = true;
 			continue;
 		}
 
@@ -3240,62 +3223,128 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 		case QOS_WPPM:
 			if (match_strlcpy(buf, &args[0], sizeof(buf)) >=
 			    sizeof(buf))
-				goto out_unlock;
+				goto out_err;
 			if (cgroup_parse_float(buf, 2, &v))
-				goto out_unlock;
+				goto out_err;
 			if (v < 0 || v > 10000)
-				goto out_unlock;
-			qos[tok] = v * 100;
+				goto out_err;
+			params->qos[tok] = v * 100;
 			break;
 		case QOS_RLAT:
 		case QOS_WLAT:
 			err = match_u64(&args[0], &v);
 			if (err) {
 				ret = err;
-				goto out_unlock;
+				goto out_err;
 			}
 
-			qos[tok] = v;
+			params->qos[tok] = v;
 			break;
 		case QOS_MIN:
 		case QOS_MAX:
 			if (match_strlcpy(buf, &args[0], sizeof(buf)) >=
 			    sizeof(buf))
-				goto out_unlock;
+				goto out_err;
 			if (cgroup_parse_float(buf, 2, &v))
-				goto out_unlock;
+				goto out_err;
 			if (v < 0)
-				goto out_unlock;
-			qos[tok] = clamp_t(s64, v * 100,
+				goto out_err;
+			params->qos[tok] = clamp_t(s64, v * 100,
 					   VRATE_MIN_PPM, VRATE_MAX_PPM);
 			break;
 		default:
-			goto out_unlock;
+			goto out_err;
 		}
-		user = true;
+		params->user = true;
+		params->set_user = true;
+		params->set_qos[tok] = true;
 	}
 
-	if (qos[QOS_MIN] > qos[QOS_MAX])
-		goto out_unlock;
+	return params;
+
+out_err:
+	kfree(params);
+	return ERR_PTR(ret);
+}
+
+static int ioc_qos_update_params(struct request_queue *q, struct ioc *ioc,
+				 struct ioc_qos_params *params)
+{
+	int i;
 
-	if (enable) {
-		blk_stat_enable_accounting(disk->queue);
-		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
+	for (i = 0; i < NR_QOS_PARAMS; ++i)
+		if (!params->set_qos[i])
+			params->qos[i] = ioc->params.qos[i];
+	if (params->qos[QOS_MIN] > params->qos[QOS_MAX])
+		return -EINVAL;
+
+	if (!params->set_enable)
+		params->enable = ioc->enabled;
+	if (params->enable) {
+		blk_stat_enable_accounting(q);
+		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, q);
 		ioc->enabled = true;
-		wbt_disable_default(disk->queue);
+		wbt_disable_default(q);
 	} else {
-		blk_queue_flag_clear(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
+		blk_queue_flag_clear(QUEUE_FLAG_RQ_ALLOC_TIME, q);
 		ioc->enabled = false;
-		wbt_enable_default(disk->queue);
+		wbt_enable_default(q);
 	}
 
-	if (user) {
-		memcpy(ioc->params.qos, qos, sizeof(qos));
+	if (!params->set_user)
+		params->user = ioc->user_qos_params;
+	if (params->user) {
+		memcpy(ioc->params.qos, params->qos, sizeof(params->qos));
 		ioc->user_qos_params = true;
 	} else {
 		ioc->user_qos_params = false;
 	}
 
+	return 0;
+}
+
+static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
+			     size_t nbytes, loff_t off)
+{
+	struct block_device *bdev;
+	struct gendisk *disk;
+	struct ioc *ioc;
+	struct ioc_qos_params *params;
+	int ret;
+
+	bdev = blkcg_conf_open_bdev(&input);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	disk = bdev->bd_disk;
+	if (!queue_is_mq(disk->queue)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	ioc = q_to_ioc(disk->queue);
+	if (!ioc) {
+		ret = blk_iocost_init(disk);
+		if (ret)
+			goto out;
+		ioc = q_to_ioc(disk->queue);
+	}
+
+	params = ioc_qos_parse_params(input);
+	if (IS_ERR(params)) {
+		ret = PTR_ERR(params);
+		goto out;
+	}
+
+	blk_mq_freeze_queue(disk->queue);
+	blk_mq_quiesce_queue(disk->queue);
+
+	spin_lock_irq(&ioc->lock);
+
+	ret = ioc_qos_update_params(disk->queue, ioc, params);
+	if (ret)
+		goto out_unlock;
+
 	ioc_refresh_params(ioc, true);
 	ret = nbytes;
 
@@ -3303,6 +3352,7 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	spin_unlock_irq(&ioc->lock);
 	blk_mq_unquiesce_queue(disk->queue);
 	blk_mq_unfreeze_queue(disk->queue);
+	kfree(params);
 
 out:
 	blkdev_put_no_open(bdev);
-- 
2.31.1

