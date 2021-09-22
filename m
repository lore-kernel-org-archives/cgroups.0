From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] block: cancel all throttled bios in blk_cleanup_queue()
Date: Wed, 22 Sep 2021 20:51:15 +0800
Message-ID: <20210922125115.381752-5-yukuai3@huawei.com>
References: <20210922125115.381752-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210922125115.381752-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Throttled bios can't be issued after queue is dying in
blk_cleanup_queue(), thus it's better to cancel them immediately
rather than waiting for throttle is done.

For example, if user thread is throttled with low bps while is
issuing large io, and the device is deleted. The user thread will
wait for a long time for io to return.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5454db2fa263..356a56318068 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -389,6 +389,9 @@ void blk_cleanup_queue(struct request_queue *q)
 
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
+	if (q->root_blkg)
+		blk_throtl_cancel_bios(q);
+
 	/* for synchronous bio-based driver finish in-flight integrity i/o */
 	blk_flush_integrity();
 
-- 
2.31.1

