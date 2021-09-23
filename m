From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/6] io-cost: introduce ioc_rqos_free()
Date: Thu, 23 Sep 2021 21:46:28 +0800
Message-ID: <20210923134631.105719-4-yukuai3@huawei.com>
References: <20210923134631.105719-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210923134631.105719-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to split 'kfree(ioc)' from ioc_rqos_exit(), no functional changes.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b3880e4ba22a..b4a6c1f70eb0 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2813,6 +2813,13 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 	kfree(ioc);
 }
 
+static void ioc_rqos_free(struct rq_qos *rqos)
+{
+	struct ioc *ioc = rqos_to_ioc(rqos);
+
+	kfree(ioc);
+}
+
 static struct rq_qos_ops ioc_rqos_ops = {
 	.throttle = ioc_rqos_throttle,
 	.merge = ioc_rqos_merge,
@@ -2820,6 +2827,7 @@ static struct rq_qos_ops ioc_rqos_ops = {
 	.done = ioc_rqos_done,
 	.queue_depth_changed = ioc_rqos_queue_depth_changed,
 	.exit = ioc_rqos_exit,
+	.free = ioc_rqos_free,
 };
 
 static int blk_iocost_init(struct request_queue *q)
-- 
2.31.1

