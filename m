From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v6 2/2] block: cancel all throttled bios in del_gendisk()
Date: Wed, 12 Jan 2022 11:05:54 +0800
Message-ID: <Yd5FkuhYX9YcgQkZ@T590>
References: <20220110134758.2233758-1-yukuai3@huawei.com>
 <20220110134758.2233758-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641956794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hLUxMC+s0pjFSC8kaV/VAZ/OjH+3iQwtRfE6QrexVRQ=;
        b=CbTvkKSwsGdKG6kpTLJugZ4XuOeJRudt5m7p30PWh49X2QCCdY1VplQLLGURauvcEkTCDv
        RZ+Ooy8AfZl9Hrst5UzgFmJFDdMJGSLVp0pJY2VZrpsFwwrYjd8tVWnQECWUE6O0ptjm7k
        HhWt2f9IjShz8JcRf8EBoRDkaIiawEA=
Content-Disposition: inline
In-Reply-To: <20220110134758.2233758-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: mkoutny@suse.com, paulmck@kernel.org, tj@kernel.org, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hello Yu Kuai,

On Mon, Jan 10, 2022 at 09:47:58PM +0800, Yu Kuai wrote:
> Throttled bios can't be issued after del_gendisk() is done, thus
> it's better to cancel them immediately rather than waiting for
> throttle is done.
> 
> For example, if user thread is throttled with low bps while it's
> issuing large io, and the device is deleted. The user thread will
> wait for a long time for io to return.
> 
> Noted this patch is mainly from revertion of commit 32e3374304c7
> ("blk-throttle: remove tg_drain_bios") and commit b77412372b68
> ("blk-throttle: remove blk_throtl_drain").
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  block/blk-throttle.c | 77 ++++++++++++++++++++++++++++++++++++++++++++
>  block/blk-throttle.h |  2 ++
>  block/genhd.c        |  2 ++
>  3 files changed, 81 insertions(+)

Just wondering why not take the built-in way in throtl_upgrade_state() for
canceling throttled bios? Something like the following, then we can avoid
to re-invent the wheel.

 block/blk-throttle.c | 38 +++++++++++++++++++++++++++++++-------
 block/blk-throttle.h |  2 ++
 block/genhd.c        |  3 +++
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index cf7e20804f1b..17e56b2e44c4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1816,16 +1816,11 @@ static void throtl_upgrade_check(struct throtl_grp *tg)
 		throtl_upgrade_state(tg->td);
 }
 
-static void throtl_upgrade_state(struct throtl_data *td)
+static void __throtl_cancel_bios(struct throtl_data *td)
 {
 	struct cgroup_subsys_state *pos_css;
 	struct blkcg_gq *blkg;
 
-	throtl_log(&td->service_queue, "upgrade to max");
-	td->limit_index = LIMIT_MAX;
-	td->low_upgrade_time = jiffies;
-	td->scale = 0;
-	rcu_read_lock();
 	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg) {
 		struct throtl_grp *tg = blkg_to_tg(blkg);
 		struct throtl_service_queue *sq = &tg->service_queue;
@@ -1834,12 +1829,41 @@ static void throtl_upgrade_state(struct throtl_data *td)
 		throtl_select_dispatch(sq);
 		throtl_schedule_next_dispatch(sq, true);
 	}
-	rcu_read_unlock();
 	throtl_select_dispatch(&td->service_queue);
 	throtl_schedule_next_dispatch(&td->service_queue, true);
 	queue_work(kthrotld_workqueue, &td->dispatch_work);
 }
 
+void blk_throtl_cancel_bios(struct request_queue *q)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct blkcg_gq *blkg;
+
+	rcu_read_lock();
+	spin_lock_irq(&q->queue_lock);
+	__throtl_cancel_bios(q->td);
+	spin_unlock_irq(&q->queue_lock);
+	rcu_read_unlock();
+
+	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg)
+		del_timer_sync(&blkg_to_tg(blkg)->service_queue.pending_timer);
+	del_timer_sync(&q->td->service_queue.pending_timer);
+
+	throtl_shutdown_wq(q);
+}
+
+static void throtl_upgrade_state(struct throtl_data *td)
+{
+	throtl_log(&td->service_queue, "upgrade to max");
+	td->limit_index = LIMIT_MAX;
+	td->low_upgrade_time = jiffies;
+	td->scale = 0;
+
+	rcu_read_lock();
+	__throtl_cancel_bios(td);
+	rcu_read_unlock();
+}
+
 static void throtl_downgrade_state(struct throtl_data *td)
 {
 	td->scale /= 2;
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index b23a9f3abb82..525ac607c518 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -162,11 +162,13 @@ static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
+static inline void blk_throtl_cancel_bios(struct request_queue *q) {}
 #else /* CONFIG_BLK_DEV_THROTTLING */
 int blk_throtl_init(struct request_queue *q);
 void blk_throtl_exit(struct request_queue *q);
 void blk_throtl_register_queue(struct request_queue *q);
 bool __blk_throtl_bio(struct bio *bio);
+void blk_throtl_cancel_bios(struct request_queue *q);
 static inline bool blk_throtl_bio(struct bio *bio)
 {
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
diff --git a/block/genhd.c b/block/genhd.c
index 626c8406f21a..1395cbd8eacf 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -30,6 +30,7 @@
 #include "blk.h"
 #include "blk-mq-sched.h"
 #include "blk-rq-qos.h"
+#include "blk-throttle.h"
 
 static struct kobject *block_depr;
 
@@ -622,6 +623,8 @@ void del_gendisk(struct gendisk *disk)
 
 	blk_mq_freeze_queue_wait(q);
 
+	blk_throtl_cancel_bios(q);
+
 	rq_qos_exit(q);
 	blk_sync_queue(q);
 	blk_flush_integrity();

Thanks,
Ming

