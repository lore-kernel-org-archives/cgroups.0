From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 18/33] blk-throttle: dispatch to throtl_data->service_queue.bio_lists[]
Date: Mon,  6 May 2013 15:45:57 -0700
Message-ID: <1367880372-28312-19-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=Uo0XY/g14cWXpkv4uznJMcEoKBknOrUCB1hCjVYLeHk=;
        b=KAYoP0nNDtb6DQNlbCcCQSyYPAqRtzkFfH06Pw2hUeHIihpLL6t8P5dxjP+tfrkjLi
         0abSNZkxmzYCdjyiqMCqgZR+UJkXD/TAncpMpXcd8HdWNv+w1gb8tzrKoGZYy0690d43
         TQinl/pvAeHt5qW+fI5t1N+/eF6hA9tP4ujHmCSRU/XRF3ZNQK8yrM6yCLGdhJ0hro10
         BARWk2ILiDw6ZvM5Vh6ls2udqjnikrtvIO51uz8V8Hph0YJoyhyUEpBlSfQcAfmjk0zN
         ++Oz6ln5EfWnYEH1parC8HNfF9FybEI54EMi8g32bNZ6WLkO4RUEHFZr3Nv2hMgv40tT
         RlTA==
In-Reply-To: <1367880372-28312-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

throtl_service_queues will eventually form a tree which is anchored at
throtl_data->service_queue and queue bios will climb the tree to the
top service_queue to be executed.

This patch makes the dispatch paths in blk_throtl_dispatch_work_fn()
and blk_throtl_drain() to dispatch bios to
throtl_data->service_queue.bio_lists[] instead of the on-stack
bio_lists.  This will keep the final dispatch to the top level
service_queue share the same mechanism as dispatches through the rest
of the hierarchy.

As bio's should be issued in a sleepable context,
blk_throtl_dispatch_work_fn() transfers all dispatched bio's from the
service_queue bio_lists[] into an onstack one before dropping
queue_lock and issuing the bio's.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6f57f94..154bd63 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -743,7 +743,7 @@ static void tg_update_disptime(struct throtl_grp *tg,
 }
 
 static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw,
-				struct bio_list *bl)
+				struct throtl_service_queue *parent_sq)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 	struct bio *bio;
@@ -757,13 +757,14 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw,
 	tg->td->nr_queued[rw]--;
 
 	throtl_charge_bio(tg, bio);
-	bio_list_add(bl, bio);
+	bio_list_add(&parent_sq->bio_lists[rw], bio);
 	bio->bi_rw |= REQ_THROTTLED;
 
 	throtl_trim_slice(tg, rw);
 }
 
-static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
+static int throtl_dispatch_tg(struct throtl_grp *tg,
+			      struct throtl_service_queue *parent_sq)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 	unsigned int nr_reads = 0, nr_writes = 0;
@@ -776,7 +777,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
 	while ((bio = bio_list_peek(&sq->bio_lists[READ])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio), bl);
+		tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 		nr_reads++;
 
 		if (nr_reads >= max_nr_reads)
@@ -786,7 +787,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
 	while ((bio = bio_list_peek(&sq->bio_lists[WRITE])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio), bl);
+		tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 		nr_writes++;
 
 		if (nr_writes >= max_nr_writes)
@@ -796,8 +797,7 @@ static int throtl_dispatch_tg(struct throtl_grp *tg, struct bio_list *bl)
 	return nr_reads + nr_writes;
 }
 
-static int throtl_select_dispatch(struct throtl_service_queue *parent_sq,
-				  struct bio_list *bl)
+static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 {
 	unsigned int nr_disp = 0;
 
@@ -813,7 +813,7 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq,
 
 		throtl_dequeue_tg(tg, parent_sq);
 
-		nr_disp += throtl_dispatch_tg(tg, bl);
+		nr_disp += throtl_dispatch_tg(tg, parent_sq);
 
 		if (sq->nr_queued[0] || sq->nr_queued[1])
 			tg_update_disptime(tg, parent_sq);
@@ -830,11 +830,13 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 {
 	struct throtl_data *td = container_of(to_delayed_work(work),
 					      struct throtl_data, dispatch_work);
+	struct throtl_service_queue *sq = &td->service_queue;
 	struct request_queue *q = td->queue;
 	unsigned int nr_disp = 0;
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 	struct blk_plug plug;
+	int rw;
 
 	spin_lock_irq(q->queue_lock);
 
@@ -844,10 +846,15 @@ void blk_throtl_dispatch_work_fn(struct work_struct *work)
 		   td->nr_queued[READ] + td->nr_queued[WRITE],
 		   td->nr_queued[READ], td->nr_queued[WRITE]);
 
-	nr_disp = throtl_select_dispatch(&td->service_queue, &bio_list_on_stack);
+	nr_disp = throtl_select_dispatch(sq);
 
-	if (nr_disp)
+	if (nr_disp) {
+		for (rw = READ; rw <= WRITE; rw++) {
+			bio_list_merge(&bio_list_on_stack, &sq->bio_lists[rw]);
+			bio_list_init(&sq->bio_lists[rw]);
+		}
 		throtl_log(td, "bios disp=%u", nr_disp);
+	}
 
 	throtl_schedule_next_dispatch(td);
 
@@ -1156,27 +1163,26 @@ void blk_throtl_drain(struct request_queue *q)
 	struct throtl_data *td = q->td;
 	struct throtl_service_queue *parent_sq = &td->service_queue;
 	struct throtl_grp *tg;
-	struct bio_list bl;
 	struct bio *bio;
+	int rw;
 
 	queue_lockdep_assert_held(q);
 
-	bio_list_init(&bl);
-
 	while ((tg = throtl_rb_first(parent_sq))) {
 		struct throtl_service_queue *sq = &tg->service_queue;
 
 		throtl_dequeue_tg(tg, parent_sq);
 
 		while ((bio = bio_list_peek(&sq->bio_lists[READ])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio), &bl);
+			tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 		while ((bio = bio_list_peek(&sq->bio_lists[WRITE])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio), &bl);
+			tg_dispatch_one_bio(tg, bio_data_dir(bio), parent_sq);
 	}
 	spin_unlock_irq(q->queue_lock);
 
-	while ((bio = bio_list_pop(&bl)))
-		generic_make_request(bio);
+	for (rw = READ; rw <= WRITE; rw++)
+		while ((bio = bio_list_pop(&parent_sq->bio_lists[rw])))
+			generic_make_request(bio);
 
 	spin_lock_irq(q->queue_lock);
 }
-- 
1.8.1.4
