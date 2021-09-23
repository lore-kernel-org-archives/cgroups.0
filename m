From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] blk-iolatency: splict blkcg_iolatency_free() from blkcg_iolatency_exit()
Date: Thu, 23 Sep 2021 21:46:29 +0800
Message-ID: <20210923134631.105719-5-yukuai3@huawei.com>
References: <20210923134631.105719-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210923134631.105719-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to split 'kfree(blkiolat)' from blkcg_iolatency_exit(), no
functional changes.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iolatency.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index c0545f9da549..f3b8848e6a46 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -648,10 +648,18 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 	kfree(blkiolat);
 }
 
+static void blkcg_iolatency_free(struct rq_qos *rqos)
+{
+	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
+
+	kfree(blkiolat);
+}
+
 static struct rq_qos_ops blkcg_iolatency_ops = {
 	.throttle = blkcg_iolatency_throttle,
 	.done_bio = blkcg_iolatency_done_bio,
 	.exit = blkcg_iolatency_exit,
+	.free = blkcg_iolatency_free,
 };
 
 static void blkiolatency_timer_fn(struct timer_list *t)
-- 
2.31.1

