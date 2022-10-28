From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 5/5] blk-iocost: fix sleeping in atomic context warnning in ioc_cost_model_write()
Date: Fri, 28 Oct 2022 18:10:56 +0800
Message-ID: <20221028101056.1971715-6-yukuai1@huaweicloud.com>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221028101056.1971715-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

match_u64() is called inside ioc->lock, which causes smatch static
checker warnings:

block/blk-iocost.c:3407 ioc_cost_model_write() warn: sleeping in atomic context

Fix the problem by prase params before holding the lock.

Fixes: 2c0647988433 ("blk-iocost: don't release 'ioc->lock' while updating params")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 128 +++++++++++++++++++++++++++++----------------
 1 file changed, 84 insertions(+), 44 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 27b41f3f1b07..62e18c2719cb 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3403,43 +3403,23 @@ static const match_table_t i_lcoef_tokens = {
 	{ NR_I_LCOEFS,		NULL		},
 };
 
-static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
-				    size_t nbytes, loff_t off)
-{
-	struct block_device *bdev;
-	struct request_queue *q;
-	struct ioc *ioc;
+struct ioc_model_params {
 	u64 u[NR_I_LCOEFS];
 	bool user;
-	char *p;
-	int ret;
-
-	bdev = blkcg_conf_open_bdev(&input);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-
-	q = bdev_get_queue(bdev);
-	if (!queue_is_mq(q)) {
-		ret = -EPERM;
-		goto out;
-	}
-
-	ioc = q_to_ioc(q);
-	if (!ioc) {
-		ret = blk_iocost_init(bdev->bd_disk);
-		if (ret)
-			goto out;
-		ioc = q_to_ioc(q);
-	}
+	bool set_u[NR_I_LCOEFS];
+	bool set_user;
+};
 
-	blk_mq_freeze_queue(q);
-	blk_mq_quiesce_queue(q);
+static struct ioc_model_params *ioc_model_parse_params(char *input)
+{
+	struct ioc_model_params *params;
+	char *p;
+	int ret = -EINVAL;
 
-	spin_lock_irq(&ioc->lock);
-	memcpy(u, ioc->params.i_lcoefs, sizeof(u));
-	user = ioc->user_cost_model;
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params)
+		return ERR_PTR(-ENOMEM);
 
-	ret = -EINVAL;
 	while ((p = strsep(&input, " \t\n"))) {
 		substring_t args[MAX_OPT_ARGS];
 		char buf[32];
@@ -3454,48 +3434,108 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		case COST_CTRL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
 			if (!strcmp(buf, "auto"))
-				user = false;
+				params->user = false;
 			else if (!strcmp(buf, "user"))
-				user = true;
+				params->user = true;
 			else
-				goto out_unlock;
+				goto err;
+			params->set_user = true;
 			continue;
 		case COST_MODEL:
 			match_strlcpy(buf, &args[0], sizeof(buf));
 			if (strcmp(buf, "linear"))
-				goto out_unlock;
+				goto err;
 			continue;
 		}
 
 		tok = match_token(p, i_lcoef_tokens, args);
 		if (tok == NR_I_LCOEFS)
-			goto out_unlock;
+			goto err;
 
 		err = match_u64(&args[0], &v);
 		if (err) {
 			ret = err;
-			goto out_unlock;
+			goto err;
 		}
 
-		u[tok] = v;
-		user = true;
+		params->u[tok] = v;
+		params->set_u[tok] = true;
+		params->user = true;
+		params->set_user = true;
 	}
 
-	if (user) {
-		memcpy(ioc->params.i_lcoefs, u, sizeof(u));
+	return params;
+
+err:
+	kfree(params);
+	return ERR_PTR(ret);
+}
+
+static void ioc_model_update_params(struct ioc *ioc,
+				    struct ioc_model_params *params)
+{
+	int i;
+
+	if (!params->set_user)
+		params->user = ioc->user_cost_model;
+	if (params->user) {
+		for (i = 0; i < NR_I_LCOEFS; ++i)
+			if (params->set_u[i])
+				ioc->params.i_lcoefs[i] = params->u[i];
 		ioc->user_cost_model = true;
 	} else {
 		ioc->user_cost_model = false;
 	}
+}
+
+static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
+				    size_t nbytes, loff_t off)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct ioc *ioc;
+	struct ioc_model_params *params;
+	int ret;
+
+	bdev = blkcg_conf_open_bdev(&input);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	q = bdev_get_queue(bdev);
+	if (!queue_is_mq(q)) {
+		ret = -EPERM;
+		goto out;
+	}
 
+	ioc = q_to_ioc(q);
+	if (!ioc) {
+		ret = blk_iocost_init(bdev->bd_disk);
+		if (ret)
+			goto out;
+		ioc = q_to_ioc(q);
+	}
+
+	params = ioc_model_parse_params(input);
+	if (IS_ERR(params)) {
+		ret = PTR_ERR(params);
+		goto out;
+	}
+
+	blk_mq_freeze_queue(q);
+	blk_mq_quiesce_queue(q);
+
+	spin_lock_irq(&ioc->lock);
+
+	ioc_model_update_params(ioc, params);
 	ioc_refresh_params(ioc, true);
-	ret = nbytes;
 
-out_unlock:
 	spin_unlock_irq(&ioc->lock);
+
 	blk_mq_unquiesce_queue(q);
 	blk_mq_unfreeze_queue(q);
 
+	kfree(params);
+	ret = nbytes;
 out:
 	blkdev_put_no_open(bdev);
 	return ret;
-- 
2.31.1

