From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 1/4] Revert "blk-throttle: remove tg_drain_bios"
Date: Sat, 27 Nov 2021 18:10:56 +0800
Message-ID: <20211127101059.477405-2-yukuai3@huawei.com>
References: <20211127101059.477405-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20211127101059.477405-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch@infradead.org, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

This reverts commit 32e3374304c7c317c05a61f3ddc315dbd46424f2.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 39bb6e68a9a2..230e300c5856 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2257,6 +2257,28 @@ void blk_throtl_bio_endio(struct bio *bio)
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

