From: Li Lingfeng <lilingfeng@huaweicloud.com>
Subject: [PATCH -next v3] block: remove init_mutex and open-code blk_iolatency_try_init
Date: Thu, 10 Aug 2023 11:51:11 +0800
Message-ID: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org
Cc: josef@toxicpanda.com, axboe@kernel.dk, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, yukuai3@huawei.com, linan122@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, lilingfeng@huaweicloud.com, lilingfeng3@huawei.com

From: Li Lingfeng <lilingfeng3@huawei.com>

Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
a mutex named "init_mutex" in blk_iolatency_try_init for the race
condition of initializing RQ_QOS_LATENCY.
Now a new lock has been add to struct request_queue by commit a13bd91be223
("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
held in blkg_conf_open_bdev before calling blk_iolatency_init.
So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
remove it.

Since init_mutex has been removed, blk_iolatency_try_init can be
open-coded back to iolatency_set_limit() like ioc_qos_write().

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
  v1->v2: open-code blk_iolatency_try_init()
  v2->v3: add lockdep check
 block/blk-iolatency.c | 35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index fd5fec989e39..c16aef4be036 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -824,29 +824,6 @@ static void iolatency_clear_scaling(struct blkcg_gq *blkg)
 	}
 }
 
-static int blk_iolatency_try_init(struct blkg_conf_ctx *ctx)
-{
-	static DEFINE_MUTEX(init_mutex);
-	int ret;
-
-	ret = blkg_conf_open_bdev(ctx);
-	if (ret)
-		return ret;
-
-	/*
-	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
-	 * confuse iolat_rq_qos() test. Make the test and init atomic.
-	 */
-	mutex_lock(&init_mutex);
-
-	if (!iolat_rq_qos(ctx->bdev->bd_queue))
-		ret = blk_iolatency_init(ctx->bdev->bd_disk);
-
-	mutex_unlock(&init_mutex);
-
-	return ret;
-}
-
 static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
 			     size_t nbytes, loff_t off)
 {
@@ -861,7 +838,17 @@ static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
 
 	blkg_conf_init(&ctx, buf);
 
-	ret = blk_iolatency_try_init(&ctx);
+	ret = blkg_conf_open_bdev(&ctx);
+	if (ret)
+		goto out;
+
+	/*
+	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
+	 * confuse iolat_rq_qos() test. Make the test and init atomic.
+	 */
+	lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);
+	if (!iolat_rq_qos(ctx.bdev->bd_queue))
+		ret = blk_iolatency_init(ctx.bdev->bd_disk);
 	if (ret)
 		goto out;
 
-- 
2.39.2

