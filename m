From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/15] cfq-iosched: Remove residual slice logic
Date: Mon,  1 Oct 2012 15:32:52 -0400
Message-ID: <1349119976-26837-12-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

CFQ has this logic of residual slice so that a queue does not lose its
allocated share due to preemption. When when we move to vdisktime logic,
a queue will not lose its share even if it preempted. (It will get queued
back into service tree with smaller key and get selected to run again).

So scheduling algorithm will take care of making sure preempted queue
still gets the fair share. Hence remove the logic of residual slice.

Note: vdisktime patches for queues are ahead in the series. I am first
cleaning up the code.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |   53 +++++++++++++-------------------------------------
 1 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index bf2bc32..a2016f5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -128,7 +128,6 @@ struct cfq_queue {
 	/* time when first request from queue completed and slice started. */
 	unsigned long slice_start;
 	unsigned long slice_end;
-	long slice_resid;
 
 	/* pending priority requests */
 	int prio_pending;
@@ -1629,16 +1628,6 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			rb_key += __cfqq->rb_key;
 		} else
 			rb_key += jiffies;
-		if (!cfq_class_idle(cfqq)) {
-			/*
-			 * Subtract any residual slice * value carried from
-			 * last service. A negative resid count indicates
-			 * slice overrun, and this should position
-			 * the next service time further away in the tree.
-			 */
-			rb_key -= cfqq->slice_resid;
-			cfqq->slice_resid = 0;
-		}
 	} else {
 		rb_key = -HZ;
 		__cfqq = cfq_rb_first(st);
@@ -2041,10 +2030,9 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
  * current cfqq expired its slice (or was too idle), select new one
  */
 static void
-__cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-		    bool timed_out)
+__cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
+	cfq_log_cfqq(cfqd, cfqq, "slice expired");
 
 	if (cfq_cfqq_wait_request(cfqq))
 		cfq_del_timer(cfqd, cfqq);
@@ -2061,17 +2049,6 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfq_cfqq_coop(cfqq) && CFQQ_SEEKY(cfqq))
 		cfq_mark_cfqq_split_coop(cfqq);
 
-	/*
-	 * store what was left of this slice, if the queue idled/timed out
-	 */
-	if (timed_out) {
-		if (cfq_cfqq_slice_new(cfqq))
-			cfqq->slice_resid = cfq_scaled_cfqq_slice(cfqd, cfqq);
-		else
-			cfqq->slice_resid = cfqq->slice_end - jiffies;
-		cfq_log_cfqq(cfqd, cfqq, "resid=%ld", cfqq->slice_resid);
-	}
-
 	cfq_group_served(cfqd, cfqq->cfqg, cfqq);
 
 	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
@@ -2088,12 +2065,12 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 }
 
-static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
+static inline void cfq_slice_expired(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
 	if (cfqq)
-		__cfq_slice_expired(cfqd, cfqq, timed_out);
+		__cfq_slice_expired(cfqd, cfqq);
 }
 
 /*
@@ -2718,7 +2695,7 @@ check_group_idle:
 	}
 
 expire:
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd);
 new_queue:
 	/*
 	 * Current queue expired. Check if we have to switch to a new
@@ -2744,7 +2721,7 @@ static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 	BUG_ON(!list_empty(&cfqq->fifo));
 
 	/* By default cfqq is not expired if it is empty. Do it explicitly */
-	__cfq_slice_expired(cfqq->cfqd, cfqq, 0);
+	__cfq_slice_expired(cfqq->cfqd, cfqq);
 	return dispatched;
 }
 
@@ -2758,7 +2735,7 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	int dispatched = 0;
 
 	/* Expire the timeslice of the current active queue first */
-	cfq_slice_expired(cfqd, 0);
+	cfq_slice_expired(cfqd);
 	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
 		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
@@ -2939,7 +2916,7 @@ static int cfq_dispatch_requests(struct request_queue *q, int force)
 	    cfqq->slice_dispatch >= cfq_prio_to_maxrq(cfqd, cfqq)) ||
 	    cfq_class_idle(cfqq))) {
 		cfqq->slice_end = jiffies + 1;
-		cfq_slice_expired(cfqd, 0);
+		cfq_slice_expired(cfqd);
 	}
 
 	cfq_log_cfqq(cfqd, cfqq, "dispatched a request");
@@ -2970,7 +2947,7 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	cfqg = cfqq->cfqg;
 
 	if (unlikely(cfqd->active_queue == cfqq)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -3003,7 +2980,7 @@ static void cfq_put_cooperator(struct cfq_queue *cfqq)
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	if (unlikely(cfqq == cfqd->active_queue)) {
-		__cfq_slice_expired(cfqd, cfqq, 0);
+		__cfq_slice_expired(cfqd, cfqq);
 		cfq_schedule_dispatch(cfqd);
 	}
 
@@ -3437,7 +3414,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	enum wl_type_t old_type = cfqq_type(cfqd->active_queue);
 
 	cfq_log_cfqq(cfqd, cfqq, "preempt");
-	cfq_slice_expired(cfqd, 1);
+	cfq_slice_expired(cfqd);
 
 	/*
 	 * workload type is changed, don't save slice, otherwise preempt
@@ -3679,7 +3656,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 		 * - when there is a close cooperator
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
-			cfq_slice_expired(cfqd, 1);
+			cfq_slice_expired(cfqd);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
 			cfq_arm_slice_timer(cfqd);
@@ -3855,7 +3832,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 	struct cfq_data *cfqd = (struct cfq_data *) data;
 	struct cfq_queue *cfqq;
 	unsigned long flags;
-	int timed_out = 1;
 
 	cfq_log(cfqd, "idle timer fired");
 
@@ -3863,7 +3839,6 @@ static void cfq_idle_slice_timer(unsigned long data)
 
 	cfqq = cfqd->active_queue;
 	if (cfqq) {
-		timed_out = 0;
 
 		/*
 		 * We saw a request before the queue expired, let it through
@@ -3896,7 +3871,7 @@ static void cfq_idle_slice_timer(unsigned long data)
 		cfq_clear_cfqq_deep(cfqq);
 	}
 expire:
-	cfq_slice_expired(cfqd, timed_out);
+	cfq_slice_expired(cfqd);
 out_kick:
 	cfq_schedule_dispatch(cfqd);
 out_cont:
@@ -3934,7 +3909,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 	spin_lock_irq(q->queue_lock);
 
 	if (cfqd->active_queue)
-		__cfq_slice_expired(cfqd, cfqd->active_queue, 0);
+		__cfq_slice_expired(cfqd, cfqd->active_queue);
 
 	cfq_put_async_queues(cfqd);
 
-- 
1.7.7.6
