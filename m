From: Li Lingfeng <lilingfeng@huaweicloud.com>
Subject: [PATCH -next] block: remove init_mutex in blk_iolatency_try_init
Date: Fri,  4 Aug 2023 19:36:59 +0800
Message-ID: <20230804113659.3816877-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, yukuai3@huawei.com, linan122@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, lilingfeng@huaweicloud.com, lilingfeng3@huawei.com

From: Li Lingfeng <lilingfeng3@huawei.com>

Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
a mutex named "init_mutex" in blk_iolatency_try_init for the race
condition of initializing RQ_QOS_LATENCY.
Now a new lock has been add to struct request_queue by commit a13bd91be223
("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
held in blkg_conf_open_bdev before calling blk_iolatency_init.
So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
remove it.

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
 block/blk-iolatency.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index fd5fec989e39..8fbd6bc96acb 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -826,7 +826,6 @@ static void iolatency_clear_scaling(struct blkcg_gq *blkg)
 
 static int blk_iolatency_try_init(struct blkg_conf_ctx *ctx)
 {
-	static DEFINE_MUTEX(init_mutex);
 	int ret;
 
 	ret = blkg_conf_open_bdev(ctx);
@@ -837,13 +836,9 @@ static int blk_iolatency_try_init(struct blkg_conf_ctx *ctx)
 	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
 	 * confuse iolat_rq_qos() test. Make the test and init atomic.
 	 */
-	mutex_lock(&init_mutex);
-
 	if (!iolat_rq_qos(ctx->bdev->bd_queue))
 		ret = blk_iolatency_init(ctx->bdev->bd_disk);
 
-	mutex_unlock(&init_mutex);
-
 	return ret;
 }
 
-- 
2.39.2

