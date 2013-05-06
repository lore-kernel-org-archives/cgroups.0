From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/33] blk-throttle: dispatch from throtl_pending_timer_fn()
Date: Mon,  6 May 2013 15:46:04 -0700
Message-ID: <1367880372-28312-26-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=UygtmK05Tjy88KqTebYmcpu1p0HEFYTJwZmMLhOh0/Y=;
        b=0oYbrmofprx0TnFKAjW/G4QL721HeQSW60MpLhavyjH+I8R3XgIRlohFzSsPsWV+Zu
         jcg1uWdDTnfprHOiVVYfMZpCG+wm0/fhYGtyHChRXJbsWQnCPJtg4kGtQ/Y/LgRqjq1e
         9/iG3x08zJ0Bb5rFBbI/jnukfYDRvo3SPIHI0lkJq8t53paXJXOJG6Ed+kUCNult/QGU
         jeTJaxR86E1cOHVaQ/XJB5vsqjIXy0Sfc2XF/LuP9z3+BlH8bSHzMsDOl6utw6n9ej9B
         qfqDji94Sg4biLLFwSizbw3ZQ/U8jlzkYO59CQEdq6rFv55X89TnMXJApAg8PAom9C8n
         gCXQ==
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

Currently, blk_throtl_dispatch_work_fn() is responsible for both
dispatching bio's from throtl_grp's according to their limits and then
issuing the dispatched bios.

This patch moves the dispatch part to throtl_pending_timer_fn() so
that the work item is kicked iff there are bio's to issue.  This is to
avoid work item execution at each step when hierarchy support is
enabled.  bio's will be dispatched towards the top-level service_queue
from the timers at each layer and the work item will only be used to
issue the bio's which reached the top-level service_queue.

While fetching bio's to issue from bio_lists[],
blk_throtl_dispatch_work_fn() fetches all READs before WRITEs.  While
the original code also dispatched READs first, if multiple throtl_grps
are dispatched on the same run, WRITEs from throtl_grp which is
dispatched first would precede READs from throtl_grps which are
dispatched later.  While this is a behavior change, given that the
previous code already prioritized READs and block layer generally
prioritizes and segregates READs from WRITEs, this isn't likely to
make any noticeable differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 69 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 25 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8ee8e4e..918d222 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -932,31 +932,26 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 	return nr_disp;
 }
 
+/**
+ * throtl_pending_timer_fn - timer function for service_queue->pending_timer
+ * @arg: the throtl_service_queue being serviced
+ *
+ * This timer is armed when a child throtl_grp with active bio's become
+ * pending and queued on the service_queue's pending_tree and expires when
+ * the first child throtl_grp should be dispatched.  This function
+ * dispatches bio's from the children throtl_grps and kicks
+ * throtl_data->dispatch_work if there are bio's ready to be issued.
+ */
 static void throtl_pending_timer_fn(unsigned long arg)
 {
 	struct throtl_service_queue *sq = (void *)arg;
 	struct throtl_data *td = sq_to_td(sq);
-
-	queue_work(kthrotld_workqueue, &td->dispatch_work);
-}
-
-/* work function to dispatch throttled bios */
-void blk_throtl_dispatch_work_fn(struct work_struct *work)
-{
-	struct throtl_data *td = container_of(work, struct throtl_data,
-					      dispatch_work);
-	struct throtl_service_queue *sq = &td->service_queue;
 	struct request_queue *q = td->queue;
-	struct bio_list bio_list_on_stack;
-	struct bio *bio;
-	struct blk_plug plug;
 	bool dispatched = false;
-	int rw, ret;
+	int ret;
 
 	spin_lock_irq(q->queue_lock);
 
-	bio_list_init(&bio_list_on_stack);
-
 	while (true) {
 		throtl_log(sq, "dispatch nr_queued=%u read=%u write=%u",
 			   td->nr_queued[READ] + td->nr_queued[WRITE],
@@ -964,10 +959,6 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 
 		ret = throtl_select_dispatch(sq);
 		if (ret) {
-			for (rw = READ; rw <= WRITE; rw++) {
-				bio_list_merge(&bio_list_on_stack, &sq->bio_lists[rw]);
-				bio_list_init(&sq->bio_lists[rw]);
-			}
 			throtl_log(sq, "bios disp=%u", ret);
 			dispatched = true;
 		}
@@ -981,13 +972,41 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 		spin_lock_irq(q->queue_lock);
 	}
 
+	if (dispatched)
+		queue_work(kthrotld_workqueue, &td->dispatch_work);
+
 	spin_unlock_irq(q->queue_lock);
+}
 
-	/*
-	 * If we dispatched some requests, unplug the queue to make sure
-	 * immediate dispatch
-	 */
-	if (dispatched) {
+/**
+ * blk_throtl_dispatch_work_fn - work function for throtl_data->dispatch_work
+ * @work: work item being executed
+ *
+ * This function is queued for execution when bio's reach the bio_lists[]
+ * of throtl_data->service_queue.  Those bio's are ready and issued by this
+ * function.
+ */
+void blk_throtl_dispatch_work_fn(struct work_struct *work)
+{
+	struct throtl_data *td = container_of(work, struct throtl_data,
+					      dispatch_work);
+	struct throtl_service_queue *td_sq = &td->service_queue;
+	struct request_queue *q = td->queue;
+	struct bio_list bio_list_on_stack;
+	struct bio *bio;
+	struct blk_plug plug;
+	int rw;
+
+	bio_list_init(&bio_list_on_stack);
+
+	spin_lock_irq(q->queue_lock);
+	for (rw = READ; rw <= WRITE; rw++) {
+		bio_list_merge(&bio_list_on_stack, &td_sq->bio_lists[rw]);
+		bio_list_init(&td_sq->bio_lists[rw]);
+	}
+	spin_unlock_irq(q->queue_lock);
+
+	if (!bio_list_empty(&bio_list_on_stack)) {
 		blk_start_plug(&plug);
 		while((bio = bio_list_pop(&bio_list_on_stack)))
 			generic_make_request(bio);
-- 
1.8.1.4
