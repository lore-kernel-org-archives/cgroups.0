From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v3 4/5] blk-iocost: move wbt_enable/disable_default() out of spinlock
Date: Sat, 27 May 2023 09:06:43 +0800
Message-ID: <20230527010644.647900-5-yukuai1@huaweicloud.com>
References: <20230527010644.647900-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230527010644.647900-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@lst.de, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

There are following smatch warning:

block/blk-wbt.c:843 wbt_init() warn: sleeping in atomic context
ioc_qos_write() <- disables preempt
-> wbt_enable_default()
   -> wbt_init()

wbt_init() will be called from wbt_enable_default() if wbt is not
initialized, currently this is only possible in blk_register_queue(), hence
wbt_init() will never be called from iocost and this warning is false
positive.

However, we might support rq_qos destruction dynamically in the future,
and it's better to prevent that, hence move wbt_enable_default() outside
'ioc->lock'. This is safe because queue is still freezed.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/lkml/Y+Ja5SRs886CEz7a@kadam/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-iocost.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 285ced3467ab..eb57e7e4f2db 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3300,11 +3300,9 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 		blk_stat_enable_accounting(disk->queue);
 		blk_queue_flag_set(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
 		ioc->enabled = true;
-		wbt_disable_default(disk);
 	} else {
 		blk_queue_flag_clear(QUEUE_FLAG_RQ_ALLOC_TIME, disk->queue);
 		ioc->enabled = false;
-		wbt_enable_default(disk);
 	}
 
 	if (user) {
@@ -3317,6 +3315,11 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	if (enable)
+		wbt_disable_default(disk);
+	else
+		wbt_enable_default(disk);
+
 	blk_mq_unquiesce_queue(disk->queue);
 	blk_mq_unfreeze_queue(disk->queue);
 
-- 
2.39.2

