From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next] blk-iocost: fix sleeping in atomic warning for wbt_enable_default()
Date: Wed,  8 Feb 2023 11:48:03 +0800
Message-ID: <20230208034803.2818155-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

There are following smatch warning:

block/blk-wbt.c:843 wbt_init() warn: sleeping in atomic context
ioc_qos_write() <- disables preempt
-> wbt_enable_default()
   -> wbt_init()

wbt_init() will be called from wbt_enable_default() if wbt is not
initialized, currently wbt is initialized in blk_register_queue(), hence
wbt_init() will never be called from iocost and this warning is false
positive.

However, we might support rq_qos destruction dynamically in the future,
and it's better to prevent that, hence move wbt_enable_default() outside
'ioc->lock'. This is safe because queue is still freezed.

Reported-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Link: https://lore.kernel.org/lkml/Y+Ja5SRs886CEz7a@kadam/
Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7a2dc9dc8e3b..03bfe1dda07c 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3279,11 +3279,9 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
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
@@ -3296,6 +3294,10 @@ static ssize_t ioc_qos_write(struct kernfs_open_file *of, char *input,
 	ioc_refresh_params(ioc, true);
 	spin_unlock_irq(&ioc->lock);
 
+	if (enable)
+		wbt_disable_default(disk);
+	else
+		wbt_enable_default(disk);
 	blk_mq_unquiesce_queue(disk->queue);
 	blk_mq_unfreeze_queue(disk->queue);
 
-- 
2.31.1

