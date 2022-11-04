From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v2 3/5] blk-iocost: don't allow to configure bio based device
Date: Fri,  4 Nov 2022 10:39:36 +0800
Message-ID: <20221104023938.2346986-4-yukuai1@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@lst.de, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

iocost is based on rq_qos, which can only work for request based device,
thus it doesn't make sense to configure iocost for bio based device.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-iocost.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c532129a1456..2bfecc511dd9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3181,6 +3181,11 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 		return PTR_ERR(bdev);
 
 	disk = bdev->bd_disk;
+	if (!queue_is_mq(disk->queue)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	ioc = q_to_ioc(disk->queue);
 	if (!ioc) {
 		ret = blk_iocost_init(disk);
@@ -3364,6 +3369,11 @@ static ssize_t ioc_cost_model_write(struct kernfs_open_file *of, char *input,
 		return PTR_ERR(bdev);
 
 	q = bdev_get_queue(bdev);
+	if (!queue_is_mq(q)) {
+		ret = -EPERM;
+		goto out;
+	}
+
 	ioc = q_to_ioc(q);
 	if (!ioc) {
 		ret = blk_iocost_init(bdev->bd_disk);
-- 
2.31.1

