From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v7 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 28 Jan 2022 16:45:22 +0800
Message-ID: <20220128084522.3169961-3-yukuai3@huawei.com>
References: <20220128084522.3169961-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220128084522.3169961-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Throttled bios can't be issued after del_gendisk() is done, thus
it's better to cancel them immediately rather than waiting for
throttle is done.

For example, if user thread is throttled with low bps while it's
issuing large io, and the device is deleted. The user thread will
wait for a long time for io to return.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 32 ++++++++++++++++++++++++++++++++
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  2 ++
 3 files changed, 36 insertions(+)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index abc5e506c72d..3280b8559ea7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1772,6 +1772,38 @@ static bool throtl_hierarchy_can_upgrade(struct throtl_grp *tg)
 	return false;
 }
 
+void blk_throtl_cancel_bios(struct request_queue *q)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct blkcg_gq *blkg;
+
+	spin_lock_irq(&q->queue_lock);
+	/*
+	 * queue_lock is held, rcu lock is not needed here technically.
+	 * However, rcu lock is still held to emphasize that following
+	 * path need RCU protection and to prevent warning from lockdep.
+	 */
+	rcu_read_lock();
+	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
+		struct throtl_grp *tg = blkg_to_tg(blkg);
+		struct throtl_service_queue *sq = &tg->service_queue;
+
+		/*
+		 * Set disptime in the past to make sure
+		 * throtl_select_dispatch() won't exit without dispatching.
+		 */
+		tg->disptime = jiffies - 1;
+		/*
+		 * Set the flag to make sure throtl_pending_timer_fn() won't
+		 * stop until all throttled bios are dispatched.
+		 */
+		blkg_to_tg(blkg)->flags |= THROTL_TG_CANCELING;
+		throtl_schedule_pending_timer(sq, jiffies + 1);
+	}
+	rcu_read_unlock();
+	spin_unlock_irq(&q->queue_lock);
+}
+
 static bool throtl_can_upgrade(struct throtl_data *td,
 	struct throtl_grp *this_tg)
 {
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 175f03abd9e4..2ae467ac17ea 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -160,12 +160,14 @@ static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
 static inline void blk_throtl_charge_bio_split(struct bio *bio) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
+static inline void blk_throtl_cancel_bios(struct request_queue *q) { }
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
index 9589d1d59afa..6acc98cd0365 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -29,6 +29,7 @@
 #include "blk.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
+#include "blk-throttle.h"
 
 static struct kobject *block_depr;
 
@@ -625,6 +626,7 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_mq_freeze_queue_wait(q);
 
+	blk_throtl_cancel_bios(disk->queue);
 	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();
-- 
2.31.1

