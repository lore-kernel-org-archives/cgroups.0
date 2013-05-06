From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/33] blk-throttle: removed deferred config application mechanism
Date: Mon,  6 May 2013 15:45:46 -0700
Message-ID: <1367880372-28312-8-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=SYH0wjqk88mCINg4/X8pAvV7sURJ9nBWCN7wpKui5k0=;
        b=dYeSVWx9wqfs8duGOFPS6dDJ2aEBMxWinJzGDN+rj9IkcFUAVbwdewNZ/r7LYInJCU
         gcsUkjTPt1FILFBjhB5hFqTL/EYqfpancWqVcrF/ZihTj2ImKUpIM5z8JjEIJGE5lKeE
         x54FMwfLyV1nSib2VXlEjA+lZtEQ2a1lQzzyyfw2gKRoSEE+O0Dhg3OdntLhUCcXJZRt
         jKeJJwsjL2+pyIy1FwgqIOPooXYvW2Zzul0GxOBDTdLcSBcDASWaSbG3YRQULurbjdC+
         26c10O20IM3Fk53WIdNzhcPh30gsGG0qDeNFNZta5RwBfhQKUlc8nie1FLcYDqUoCz+3
         7vjw==
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

When bps or iops configuration changes, blk-throttle records the new
configuration and sets a flag indicating that the config has changed.
The flag is checked in the bio dispatch path and applied.  This
deferred config application was necessary due to limitations in blkcg
framework, which haven't existed for quite a while now.

This patch removes the deferred config application mechanism and
applies new configurations directly from tg_set_conf(), which is
simpler.

v2: Dropped unnecessary throtl_schedule_delayed_work() call from
    tg_set_conf() as suggested by Vivek Goyal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c | 74 ++++++++++++++--------------------------------------
 1 file changed, 20 insertions(+), 54 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3960787..7dbd0e69 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -85,9 +85,6 @@ struct throtl_grp {
 	unsigned long slice_start[2];
 	unsigned long slice_end[2];
 
-	/* Some throttle limits got updated for the group */
-	int limits_changed;
-
 	/* Per cpu stats pointer */
 	struct tg_stats_cpu __percpu *stats_cpu;
 
@@ -112,8 +109,6 @@ struct throtl_data
 
 	/* Work for dispatching throttled bios */
 	struct delayed_work throtl_work;
-
-	int limits_changed;
 };
 
 /* list and work item to allocate percpu group stats */
@@ -223,7 +218,6 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
-	tg->limits_changed = false;
 
 	tg->bps[READ] = -1;
 	tg->bps[WRITE] = -1;
@@ -826,45 +820,6 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 	return nr_disp;
 }
 
-static void throtl_process_limit_change(struct throtl_data *td)
-{
-	struct request_queue *q = td->queue;
-	struct blkcg_gq *blkg, *n;
-
-	if (!td->limits_changed)
-		return;
-
-	xchg(&td->limits_changed, false);
-
-	throtl_log(td, "limits changed");
-
-	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
-		struct throtl_grp *tg = blkg_to_tg(blkg);
-
-		if (!tg->limits_changed)
-			continue;
-
-		if (!xchg(&tg->limits_changed, false))
-			continue;
-
-		throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
-			" riops=%u wiops=%u", tg->bps[READ], tg->bps[WRITE],
-			tg->iops[READ], tg->iops[WRITE]);
-
-		/*
-		 * Restart the slices for both READ and WRITES. It
-		 * might happen that a group's limit are dropped
-		 * suddenly and we don't want to account recently
-		 * dispatched IO with new low rate
-		 */
-		throtl_start_new_slice(td, tg, 0);
-		throtl_start_new_slice(td, tg, 1);
-
-		if (throtl_tg_on_rr(tg))
-			tg_update_disptime(td, tg);
-	}
-}
-
 /* Dispatch throttled bios. Should be called without queue lock held. */
 static int throtl_dispatch(struct request_queue *q)
 {
@@ -876,8 +831,6 @@ static int throtl_dispatch(struct request_queue *q)
 
 	spin_lock_irq(q->queue_lock);
 
-	throtl_process_limit_change(td);
-
 	if (!total_nr_queued(td))
 		goto out;
 
@@ -925,8 +878,7 @@ throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 
 	struct delayed_work *dwork = &td->throtl_work;
 
-	/* schedule work if limits changed even if no bio is queued */
-	if (total_nr_queued(td) || td->limits_changed) {
+	if (total_nr_queued(td)) {
 		mod_delayed_work(kthrotld_workqueue, dwork, delay);
 		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
 				delay, jiffies);
@@ -1023,10 +975,25 @@ static int tg_set_conf(struct cgroup *cgrp, struct cftype *cft, const char *buf,
 	else
 		*(unsigned int *)((void *)tg + cft->private) = ctx.v;
 
-	/* XXX: we don't need the following deferred processing */
-	xchg(&tg->limits_changed, true);
-	xchg(&td->limits_changed, true);
-	throtl_schedule_delayed_work(td, 0);
+	throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu riops=%u wiops=%u",
+		      tg->bps[READ], tg->bps[WRITE],
+		      tg->iops[READ], tg->iops[WRITE]);
+
+	/*
+	 * We're already holding queue_lock and know @tg is valid.  Let's
+	 * apply the new config directly.
+	 *
+	 * Restart the slices for both READ and WRITES. It might happen
+	 * that a group's limit are dropped suddenly and we don't want to
+	 * account recently dispatched IO with new low rate.
+	 */
+	throtl_start_new_slice(td, tg, 0);
+	throtl_start_new_slice(td, tg, 1);
+
+	if (throtl_tg_on_rr(tg)) {
+		tg_update_disptime(td, tg);
+		throtl_schedule_next_dispatch(td);
+	}
 
 	blkg_conf_finish(&ctx);
 	return 0;
@@ -1239,7 +1206,6 @@ int blk_throtl_init(struct request_queue *q)
 		return -ENOMEM;
 
 	td->tg_service_tree = THROTL_RB_ROOT;
-	td->limits_changed = false;
 	INIT_DELAYED_WORK(&td->throtl_work, blk_throtl_work);
 
 	q->td = td;
-- 
1.8.1.4
