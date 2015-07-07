From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 9/9] cfq-iosched: charge async IOs to the appropriate blkcg's instead of the root
Date: Tue,  7 Jul 2015 11:36:01 -0400
Message-ID: <1436283361-3889-10-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Wt5FJB9Y0j4Sy7NIlWWfjRsmqclC/1tkOmpjzgnpFjY=;
        b=YWjSfhCiXIClOpVXS7ghdp87kJhj+LqmXWiqL55PRaYrnUIAxNHRlYngsTzVOE5iuR
         wghcruQx1HzHMlPDqEFLalQilUwMeohQuk+PsBekb3zMhfjDhfyOuxVLlkFbcxqz+KZ2
         HtWABWW5dphkmLCRZro+/CT4q0lMkNUMzTU/QWyQS8md0xTnuFHxVEzurvRgLWhFIlth
         Q7mwi/7c6a0WWHIF2kdiQ7QynrTNtkbwUWBccf0wULeNtlaO4ty2zQoWkDAWjL/YJjaV
         jW09gnqBYV56y8mFZ3KSFVzisf6QPI2fZyU/rc9S91NR30v3kumhPr/pIrlvmRgqKPgb
         Frgg==
In-Reply-To: <1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 85 ++++++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fa2a2f7..9c9ec7c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -305,6 +305,11 @@ struct cfq_group {
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
@@ -370,12 +375,6 @@ struct cfq_data {
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
@@ -401,6 +400,7 @@ struct cfq_data {
 };
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
+static void cfq_put_queue(struct cfq_queue *cfqq);
 
 static struct cfq_rb_root *st_for(struct cfq_group *cfqg,
 					    enum wl_class_t class,
@@ -1596,13 +1596,26 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
 
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
@@ -1665,10 +1678,6 @@ static struct cfq_group *cfq_lookup_create_cfqg(struct cfq_data *cfqd,
 
 static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
-	/* Currently, all async queues are mapped to root group */
-	if (!cfq_cfqq_sync(cfqq))
-		cfqg = cfqq->cfqd->root_group;
-
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
 	cfqg_get(cfqg);
@@ -3609,7 +3618,7 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 {
 	struct cfq_data *cfqd = cic_to_cfqd(cic);
-	struct cfq_queue *sync_cfqq;
+	struct cfq_queue *cfqq;
 	uint64_t serial_nr;
 
 	rcu_read_lock();
@@ -3623,15 +3632,22 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
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
@@ -3641,18 +3657,18 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) {
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
@@ -3681,7 +3697,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			ioprio = task_nice_ioprio(tsk);
 			ioprio_class = task_nice_ioclass(tsk);
 		}
-		async_cfqq = cfq_async_queue_prio(cfqd, ioprio_class, ioprio);
+		async_cfqq = cfq_async_queue_prio(cfqg, ioprio_class, ioprio);
 		cfqq = *async_cfqq;
 		if (cfqq)
 			goto out;
@@ -4355,21 +4371,6 @@ static void cfq_shutdown_timer_wq(struct cfq_data *cfqd)
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
@@ -4382,8 +4383,6 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	if (cfqd->active_queue)
 		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
 
-	cfq_put_async_queues(cfqd);
-
 	spin_unlock_irq(q->queue_lock);
 
 	cfq_shutdown_timer_wq(cfqd);
-- 
2.4.3
