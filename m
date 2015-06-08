From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] cfq-iosched: charge async IOs to the appropriate blkcg's instead of the root
Date: Mon,  8 Jun 2015 17:59:33 +0900
Message-ID: <1433753973-23684-9-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z/JKK3YCqEmXYkTFhKx0US6UeENEpicavas54r4jaVw=;
        b=dXmCzfSBG0vPLNbbcY3gnrhxGVibpe5zTQ+fz0hlP2Vda1ZdtX595iSDJwoWb/KW4O
         nSjQTiPVjFOvdjgEuQjsi3u3uYZ0AV6sYVw8eVJsS9EvCkHQumBz543KlmE61ka+Iy3G
         6ndZJuSEpCmXAC0PUn7ia+p/poxmfO8i6iUU5nR1yddvnIieoxl8pAl614lCHFOxzDNY
         Ag9/aN7/Xipt8oe7+LAUWRzdBBV0nXVxjkg5gG0YXuiejzX5CSPeNHYtP5alzy/k9wTe
         QlohpAD8C7HziPSC4Yo6EHyycf3P7HwXfZn13M8/FmPMlWeP5A36G9Tn30S5tb6oZX0e
         f/UA==
In-Reply-To: <1433753973-23684-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com, avanzini.arianna@gmail.com, Tejun Heo <tj@kernel.org>

Up until now, all async IOs were queued to async queues which are
shared across the whole request_queue, which means that blkcg resource
control is completely void on async IOs including all writeback IOs.
It was done this way because writeback didn't support writeback and
there was no way of telling which writeback IO belonged to which
cgroup; however, writeback recently became cgroup aware and writeback
bio's are sent down properly tagged with the blkcg's to charge them
against.

This patch makes async cfq_queues per-cfq_cgroup instead of
per-cfq_data so that each async IO is charged to the blkcg that it was
tagged for instead of unconditionally attributing it to root.

* cfq_data->async_cfqq and ->async_idle_cfqq are moved to cfq_group
  and alloc / destroy paths are updated accordingly.

* cfq_link_cfqq_cfqg() no longer overrides @cfqg to root for async
  queues.

* check_blkcg_changed() now also invalidates async queues as they no
  longer stay the same across cgroups.

After this patch, cfq's proportional IO control through blkio.weight
works correctly when cgroup writeback is in use.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 85 ++++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 393befb..fded8d7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -291,6 +291,11 @@ struct cfq_group {
 	struct cfq_ttime ttime;
 	struct cfqg_stats stats;	/* stats for this cfqg */
 	struct cfqg_stats dead_stats;	/* stats pushed from dead children */
+
+	/* async queue for each priority case */
+	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
+	struct cfq_queue *async_idle_cfqq;
+
 };
 
 struct cfq_io_cq {
@@ -356,12 +361,6 @@ struct cfq_data {
 	struct cfq_queue *active_queue;
 	struct cfq_io_cq *active_cic;
 
-	/*
-	 * async queue for each priority case
-	 */
-	struct cfq_queue *async_cfqq[2][IOPRIO_BE_NR];
-	struct cfq_queue *async_idle_cfqq;
-
 	sector_t last_position;
 
 	/*
@@ -387,6 +386,7 @@ struct cfq_data {
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
+static void cfq_put_queue(struct cfq_queue *cfqq);
 
 static struct cfq_rb_root *st_for(struct cfq_group *cfqg,
 					    enum wl_class_t class,
@@ -1556,13 +1556,26 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
 
 static void cfq_pd_offline(struct blkcg_gq *blkg)
 {
+	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+	int i;
+
+	for (i = 0; i < IOPRIO_BE_NR; i++) {
+		if (cfqg->async_cfqq[0][i])
+			cfq_put_queue(cfqg->async_cfqq[0][i]);
+		if (cfqg->async_cfqq[1][i])
+			cfq_put_queue(cfqg->async_cfqq[1][i]);
+	}
+
+	if (cfqg->async_idle_cfqq)
+		cfq_put_queue(cfqg->async_idle_cfqq);
+
 	/*
 	 * @blkg is going offline and will be ignored by
 	 * blkg_[rw]stat_recursive_sum().  Transfer stats to the parent so
 	 * that they don't get lost.  If IOs complete after this point, the
 	 * stats for them will be lost.  Oh well...
 	 */
-	cfqg_stats_xfer_dead(blkg_to_cfqg(blkg));
+	cfqg_stats_xfer_dead(cfqg);
 }
 
 /* offset delta from cfqg->stats to cfqg->dead_stats */
@@ -1625,10 +1638,6 @@ static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
 
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
-	/* Currently, all async queues are mapped to root group */
-	if (!cfq_cfqq_sync(cfqq))
-		cfqg = cfqq->cfqd->root_group;
-
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
 	cfqg_get(cfqg);
@@ -3541,7 +3550,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
-	struct cfq_queue *sync_cfqq;
+	struct cfq_queue *cfqq;
 	uint64_t serial_nr;
 
 	rcu_read_lock();
@@ -3555,15 +3564,22 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 	if (unlikely(!cfqd) || likely(cic->blkcg_serial_nr == serial_nr))
 		return;
 
-	sync_cfqq = cic_to_cfqq(cic, 1);
-	if (sync_cfqq) {
-		/*
-		 * Drop reference to sync queue. A new sync queue will be
-		 * assigned in new group upon arrival of a fresh request.
-		 */
-		cfq_log_cfqq(cfqd, sync_cfqq, "changed cgroup");
-		cic_set_cfqq(cic, NULL, 1);
-		cfq_put_queue(sync_cfqq);
+	/*
+	 * Drop reference to queues.  New queues will be assigned in new
+	 * group upon arrival of fresh requests.
+	 */
+	cfqq = cic_to_cfqq(cic, false);
+	if (cfqq) {
+		cfq_log_cfqq(cfqd, cfqq, "changed cgroup");
+		cic_set_cfqq(cic, NULL, false);
+		cfq_put_queue(cfqq);
+	}
+
+	cfqq = cic_to_cfqq(cic, true);
+	if (cfqq) {
+		cfq_log_cfqq(cfqd, cfqq, "changed cgroup");
+		cic_set_cfqq(cic, NULL, true);
+		cfq_put_queue(cfqq);
 	}
 
 	cic->blkcg_serial_nr = serial_nr;
@@ -3573,18 +3589,18 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) {
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
 static struct cfq_queue **
-cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
+cfq_async_queue_prio(struct cfq_group *cfqg, int ioprio_class, int ioprio)
 {
 	switch (ioprio_class) {
 	case IOPRIO_CLASS_RT:
-		return &cfqd->async_cfqq[0][ioprio];
+		return &cfqg->async_cfqq[0][ioprio];
 	case IOPRIO_CLASS_NONE:
 		ioprio = IOPRIO_NORM;
 		/* fall through */
 	case IOPRIO_CLASS_BE:
-		return &cfqd->async_cfqq[1][ioprio];
+		return &cfqg->async_cfqq[1][ioprio];
 	case IOPRIO_CLASS_IDLE:
-		return &cfqd->async_idle_cfqq;
+		return &cfqg->async_idle_cfqq;
 	default:
 		BUG();
 	}
@@ -3613,7 +3629,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			ioprio = task_nice_ioprio(tsk);
 			ioprio_class = task_nice_ioclass(tsk);
 		}
-		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
+		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class, ioprio);
 		cfqq = *async_cfqq;
 		if (cfqq)
 			goto out;
@@ -4287,21 +4303,6 @@ static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
 	cancel_work_sync(&cfqd->unplug_work);
 }
 
-static void cfq_put_async_queues(struct cfq_data *cfqd)
-{
-	int i;
-
-	for (i = 0; i < IOPRIO_BE_NR; i++) {
-		if (cfqd->async_cfqq[0][i])
-			cfq_put_queue(cfqd->async_cfqq[0][i]);
-		if (cfqd->async_cfqq[1][i])
-			cfq_put_queue(cfqd->async_cfqq[1][i]);
-	}
-
-	if (cfqd->async_idle_cfqq)
-		cfq_put_queue(cfqd->async_idle_cfqq);
-}
-
 static void cfq_exit_queue(struct elevator_queue *e)
 {
 	struct cfq_data *cfqd = e->elevator_data;
@@ -4314,8 +4315,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	cfq_put_async_queues(cfqd);
-
 	spin_unlock_irq(q->queue_lock);
 
 	cfq_shutdown_timer_wq(cfqd);
-- 
2.4.2
