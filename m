From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 2/6] blk-wbt: introduce wbt_free()
Date: Thu, 23 Sep 2021 21:46:27 +0800
Message-ID: <20210923134631.105719-3-yukuai3@huawei.com>
References: <20210923134631.105719-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20210923134631.105719-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to split 'kfree(rwb)' from wbt_exit(), no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-wbt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 874c1c37bf0c..4190453d5e0b 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -694,6 +694,13 @@ static void wbt_exit(struct rq_qos *rqos)
 	kfree(rwb);
 }
 
+static void wbt_free(struct rq_qos *rqos)
+{
+	struct rq_wb *rwb = RQWB(rqos);
+
+	kfree(rwb);
+}
+
 /*
  * Disable wbt, if enabled by default.
  */
@@ -808,6 +815,7 @@ static struct rq_qos_ops wbt_rqos_ops = {
 	.cleanup = wbt_cleanup,
 	.queue_depth_changed = wbt_queue_depth_changed,
 	.exit = wbt_exit,
+	.free = wbt_free,
 #ifdef CONFIG_BLK_DEBUG_FS
 	.debugfs_attrs = wbt_debugfs_attrs,
 #endif
-- 
2.31.1

