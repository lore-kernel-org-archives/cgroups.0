From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/4] Revert "blk-throttle: remove tg_drain_bios"
Date: Wed, 22 Sep 2021 20:51:12 +0800
Message-ID: <20210922125115.381752-2-yukuai3@huawei.com>
References: <20210922125115.381752-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210922125115.381752-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

This reverts commit 32e3374304c7c317c05a61f3ddc315dbd46424f2.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7c4e7993ba97..43dee985170b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2412,6 +2412,28 @@ void blk_throtl_bio_endio(struct bio *bio)
 }
 #endif
 
+/*
+ * Dispatch all bios from all children tg's queued on @parent_sq.  On
+ * return, @parent_sq is guaranteed to not have any active children tg's
+ * and all bios from previously active tg's are on @parent_sq->bio_lists[].
+ */
+static void tg_drain_bios(struct throtl_service_queue *parent_sq)
+{
+	struct throtl_grp *tg;
+
+	while ((tg = throtl_rb_first(parent_sq))) {
+		struct throtl_service_queue *sq = &tg->service_queue;
+		struct bio *bio;
+
+		throtl_dequeue_tg(tg);
+
+		while ((bio = throtl_peek_queued(&sq->queued[READ])))
+			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+		while ((bio = throtl_peek_queued(&sq->queued[WRITE])))
+			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+	}
+}
+
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
-- 
2.31.1

