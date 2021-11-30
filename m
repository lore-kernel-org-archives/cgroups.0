From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] block: cancel all throttled bios in del_gendisk()
Date: Tue, 30 Nov 2021 09:17:30 +0800
Message-ID: <20211130011730.2584339-3-yukuai3@huawei.com>
References: <20211130011730.2584339-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211130011730.2584339-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Throttled bios can't be issued after del_gendisk() is done, thus
it's better to cancel them immediately rather than waiting for
throttle is done.

For example, if user thread is throttled with low bps while it's
issuing large io, and the device is deleted. The user thread will
wait for a long time for io to return.

Noted this patch is mainly from revertion of commit 32e3374304c7
("blk-throttle: remove tg_drain_bios") and commit b77412372b68
("blk-throttle: remove blk_throtl_drain").

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 59 ++++++++++++++++++++++++++++++++++++++++++++
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 63 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f7244190cb2f..64fd4d61cbfe 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2260,6 +2260,65 @@ void blk_throtl_bio_endio(struct bio *bio)
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
+/**
+ * blk_throtl_cancel_bios - cancel throttled bios
+ * @q: request_queue to cancel throttled bios for
+ *
+ * This function is called to error all currently throttled bios on @q.
+ */
+void blk_throtl_cancel_bios(struct request_queue *q)
+{
+	struct throtl_data *td = q->td;
+	struct blkcg_gq *blkg;
+	struct cgroup_subsys_state *pos_css;
+	struct bio *bio;
+	int rw;
+
+	rcu_read_lock();
+
+	/*
+	 * Drain each tg while doing post-order walk on the blkg tree, so
+	 * that all bios are propagated to td->service_queue.  It'd be
+	 * better to walk service_queue tree directly but blkg walk is
+	 * easier.
+	 */
+	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
+		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
+
+	/* finally, transfer bios from top-level tg's into the td */
+	tg_drain_bios(&td->service_queue);
+
+	rcu_read_unlock();
+
+	/* all bios now should be in td->service_queue, cancel them */
+	for (rw = READ; rw <= WRITE; rw++)
+		while ((bio = throtl_pop_queued(&td->service_queue.queued[rw],
+						NULL)))
+			bio_io_error(bio);
+}
+
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 175f03abd9e4..9d67d5139954 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -160,12 +160,14 @@ static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
 static inline void blk_throtl_charge_bio_split(struct bio *bio) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
+#define blk_throtl_cancel_bios(q)  do { } while (0)
 #else /* CONFIG_BLK_DEV_THROTTLING */
 int blk_throtl_init(struct request_queue *q);
 void blk_throtl_exit(struct request_queue *q);
 void blk_throtl_register_queue(struct request_queue *q);
 void blk_throtl_charge_bio_split(struct bio *bio);
 bool __blk_throtl_bio(struct bio *bio);
+void blk_throtl_cancel_bios(struct request_queue *q);
 static inline bool blk_throtl_bio(struct bio *bio)
 {
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
diff --git a/block/genhd.c b/block/genhd.c
index 8e9cbf23c510..24fa3356d164 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -28,6 +28,7 @@
 
 #include "blk.h"
 #include "blk-rq-qos.h"
+#include "blk-throttle.h"
 
 static struct kobject *block_depr;
 
@@ -619,6 +620,7 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_mq_freeze_queue_wait(q);
 
+	blk_throtl_cancel_bios(q);
 	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();
-- 
2.31.1

