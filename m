From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v4 2/5] blk-iocost: don't allow to configure bio based device
Date: Tue, 17 Jan 2023 15:08:03 +0800
Message-ID: <20230117070806.3857142-3-yukuai1@huaweicloud.com>
References: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230117070806.3857142-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

iocost is based on rq_qos, which can only work for request based device,
thus it doesn't make sense to configure iocost for bio based device.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index f1166582fb64..d6256731cae4 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3185,6 +3185,11 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 		return PTR_ERR(bdev);
 
 	disk = bdev->bd_disk;
+	if (!queue_is_mq(disk->queue)) {
+		ret = -EOPNOTSUPP;
+		goto err;
+	}
+
 	ioc = q_to_ioc(disk->queue);
 	if (!ioc) {
 		ret = blk_iocost_init(disk);
@@ -3365,6 +3370,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		return PTR_ERR(bdev);
 
 	q = bdev_get_queue(bdev);
+	if (!queue_is_mq(q)) {
+		ret = -EOPNOTSUPP;
+		goto err;
+	}
+
 	ioc = q_to_ioc(q);
 	if (!ioc) {
 		ret = blk_iocost_init(bdev->bd_disk);
-- 
2.31.1

