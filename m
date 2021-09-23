From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/6] blk-ioprio: introduce blkcg_ioprio_free()
Date: Thu, 23 Sep 2021 21:46:30 +0800
Message-ID: <20210923134631.105719-6-yukuai3@huawei.com>
References: <20210923134631.105719-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210923134631.105719-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to split 'kfree(blkioprio_blkg)' from blkcg_ioprio_exit(),
no functional changes.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-ioprio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 332a07761bf8..55338ebee356 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -212,9 +212,18 @@ static void blkcg_ioprio_exit(struct rq_qos *rqos)
 	kfree(blkioprio_blkg);
 }
 
+static void blkcg_ioprio_free(struct rq_qos *rqos)
+{
+	struct blk_ioprio *blkioprio_blkg =
+		container_of(rqos, typeof(*blkioprio_blkg), rqos);
+
+	kfree(blkioprio_blkg);
+}
+
 static struct rq_qos_ops blkcg_ioprio_ops = {
 	.track	= blkcg_ioprio_track,
 	.exit	= blkcg_ioprio_exit,
+	.free	= blkcg_ioprio_free,
 };
 
 int blk_ioprio_init(struct request_queue *q)
-- 
2.31.1

