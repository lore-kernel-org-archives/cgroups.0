From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/31] blk-throttle: implement dispatch looping
Date: Wed,  1 May 2013 17:39:42 -0700
Message-ID: <1367455189-6957-25-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=hZ6tml/nrJj5uZLZrp5RKlFgtvV48nEB7PCqTCUoHzg=;
        b=HercU1pFUvhySdWi+KoD4TgakMgyd+gDgB+iIgjkjwSUSEJNJ0mwFOC9UEKV5pV0Sm
         wvDFku19TZpNhcCPkB6VYXxzoAIZUs6N5ODXLLVMwDdDYmjx8MB022ZGYnfJKg3+ucKJ
         ST5kxpWPyne+WkPoDWKu9fNAx4nxsO0LOeZJ4+u1mJmk2A4QBbdjk3PRLoZc80pJE1VH
         wFg2m3ctyc4CIuXVdIz/CRJukt80zBvvttxHB8bq/o0xr/gJreyCiqhOoqmNP5T50Xp9
         VsOjSfjY4nuYeR6grO5eWbLrd5tHC4tujIdA/J2pdjq+Fyl+gEYGv+WbtRgDLNTKaQ5z
         zpMQ==
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

throtl_select_dispatch() only dispatches throtl_quantum bios on each
invocation.  blk_throtl_dispatch_work_fn() in turn depends on
throtl_schedule_next_dispatch() scheduling the next dispatch window
immediately so that undue delays aren't incurred.  This effectively
chains multiple dispatch work item executions back-to-back when there
are more than throtl_quantum bios to dispatch on a given tick.

There is no reason to finish the current work item just to repeat it
immediately.  This patch makes throtl_schedule_next_dispatch() return
%false without doing anything if the current dispatch window is still
open and updates blk_throtl_dispatch_work_fn() repeat dispatching
after cpu_relax() on %false return.

This change will help implementing hierarchy support as dispatching
will be done from pending_timer and immediate reschedule of timer
function isn't supported and doesn't make much sense.

While this patch changes how dispatch behaves when there are more than
throtl_quantum bios to dispatch on a single tick, the behavior change
is immaterial.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 82 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 26 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9270663..d573cdf 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -464,24 +464,41 @@ static void throtl_schedule_pending_timer(struct throtl_service_queue *sq,
 		   expires - jiffies, jiffies);
 }
 
-static void throtl_schedule_next_dispatch(struct throtl_service_queue *sq)
+/**
+ * throtl_schedule_next_dispatch - schedule the next dispatch cycle
+ * @sq: the service_queue to schedule dispatch for
+ * @force: force scheduling
+ *
+ * Arm @sq->pending_timer so that the next dispatch cycle starts on the
+ * dispatch time of the first pending child.  Returns %true if either timer
+ * is armed or there's no pending child left.  %false if the current
+ * dispatch window is still open and the caller should continue
+ * dispatching.
+ *
+ * If @force is %true, the dispatch timer is always scheduled and this
+ * function is guaranteed to return %true.  This is to be used when the
+ * caller can't dispatch itself and needs to invoke pending_timer
+ * unconditionally.  Note that forced scheduling is likely to induce short
+ * delay before dispatch starts even if @sq->first_pending_disptime is not
+ * in the future and thus shouldn't be used in hot paths.
+ */
+static bool throtl_schedule_next_dispatch(struct throtl_service_queue *sq,
+					  bool force)
 {
-	struct throtl_data *td = sq_to_td(sq);
-
 	/* any pending children left? */
 	if (!sq->nr_pending)
-		return;
+		return true;
 
 	update_min_dispatch_time(sq);
 
 	/* is the next dispatch time in the future? */
-	if (time_after(sq->first_pending_disptime, jiffies)) {
+	if (force || time_after(sq->first_pending_disptime, jiffies)) {
 		throtl_schedule_pending_timer(sq, sq->first_pending_disptime);
-		return;
+		return true;
 	}
 
-	/* kick immediate execution */
-	queue_work(kthrotld_workqueue, &td->dispatch_work);
+	/* tell the caller to continue dispatching */
+	return false;
 }
 
 static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
@@ -927,39 +944,47 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 					      dispatch_work);
 	struct throtl_service_queue *sq = &td->service_queue;
 	struct request_queue *q = td->queue;
-	unsigned int nr_disp = 0;
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 	struct blk_plug plug;
-	int rw;
+	bool dispatched = false;
+	int rw, ret;
 
 	spin_lock_irq(q->queue_lock);
 
 	bio_list_init(&bio_list_on_stack);
 
-	throtl_log(sq, "dispatch nr_queued=%u read=%u write=%u",
-		   td->nr_queued[READ] + td->nr_queued[WRITE],
-		   td->nr_queued[READ], td->nr_queued[WRITE]);
+	while (true) {
+		throtl_log(sq, "dispatch nr_queued=%u read=%u write=%u",
+			   td->nr_queued[READ] + td->nr_queued[WRITE],
+			   td->nr_queued[READ], td->nr_queued[WRITE]);
+
+		ret = throtl_select_dispatch(sq);
+		if (ret) {
+			for (rw = READ; rw <= WRITE; rw++) {
+				bio_list_merge(&bio_list_on_stack, &sq->bio_lists[rw]);
+				bio_list_init(&sq->bio_lists[rw]);
+			}
+			throtl_log(sq, "bios disp=%u", ret);
+			dispatched = true;
+		}
 
-	nr_disp = throtl_select_dispatch(sq);
+		if (throtl_schedule_next_dispatch(sq, false))
+			break;
 
-	if (nr_disp) {
-		for (rw = READ; rw <= WRITE; rw++) {
-			bio_list_merge(&bio_list_on_stack, &sq->bio_lists[rw]);
-			bio_list_init(&sq->bio_lists[rw]);
-		}
-		throtl_log(sq, "bios disp=%u", nr_disp);
+		/* this dispatch windows is still open, relax and repeat */
+		spin_unlock_irq(q->queue_lock);
+		cpu_relax();
+		spin_lock_irq(q->queue_lock);
 	}
 
-	throtl_schedule_next_dispatch(sq);
-
 	spin_unlock_irq(q->queue_lock);
 
 	/*
 	 * If we dispatched some requests, unplug the queue to make sure
 	 * immediate dispatch
 	 */
-	if (nr_disp) {
+	if (dispatched) {
 		blk_start_plug(&plug);
 		while((bio = bio_list_pop(&bio_list_on_stack)))
 			generic_make_request(bio);
@@ -1075,7 +1100,7 @@ static int tg_set_conf(struct cgroup *cgrp, struct cftype *cft, const char *buf,
 
 	if (tg->flags & THROTL_TG_PENDING) {
 		tg_update_disptime(tg);
-		throtl_schedule_next_dispatch(sq->parent_sq);
+		throtl_schedule_next_dispatch(sq->parent_sq, true);
 	}
 
 	/* kick dispatch in case disptime got shortened */
@@ -1229,10 +1254,15 @@ queue_bio:
 	throtl_add_bio_tg(bio, tg);
 	throttled = true;
 
-	/* update @tg's dispatch time if @tg was empty before @bio */
+	/*
+	 * Update @tg's dispatch time and force schedule dispatch if @tg
+	 * was empty before @bio.  The forced scheduling isn't likely to
+	 * cause undue delay as @bio is likely to be dispatched directly if
+	 * its @tg's disptime is not in the future.
+	 */
 	if (tg->flags & THROTL_TG_WAS_EMPTY) {
 		tg_update_disptime(tg);
-		throtl_schedule_next_dispatch(tg->service_queue.parent_sq);
+		throtl_schedule_next_dispatch(tg->service_queue.parent_sq, true);
 	}
 
 out_unlock:
-- 
1.8.1.4
