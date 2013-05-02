From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/31] blk-throttle: make blk_throtl_drain() ready for hierarchy
Date: Wed,  1 May 2013 17:39:44 -0700
Message-ID: <1367455189-6957-27-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=hFVXrcc3wl0gmPQK20N6Lhc5UjXgCfIpy7C3R10q18w=;
        b=URuYxBY/6qlN+He6OLLxv43BfRKBQxIQAviI6lCyXo5Vs0lFdwRgwm84b/1P2ZIW9e
         tMU3t/BwOjPI7ureReLO4s5k87A5o1d+rjLHiWHiSry0kulx2f5V3tHD8Z9ynnUnxqHE
         6pV6LJrganYdwmlO40Lxr3jR4eWts9oP7W7bSuoUDdwa7wX6lFjph0p9P+NPwSpXkn8U
         V7BPy9OwKmycuoOsbSzjtA/XHcP+fNSSBFnMQgwKoq3soyjvp85FpjgXiCQIX7oQ8q0Y
         eiWB/Mtq+irkK0FA9gvrgvJ7yt4ckWuUIzA53J8OJ3SCsoBeSA+KpyUWUWhRvk1QL1AS
         PlTA==
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

The current blk_throtl_drain() assumes that all active throtl_grps are
queued on throtl_data->service_queue, which won't be true once
hierarchy support is implemented.

This patch makes blk_throtl_drain() perform post-order walk of the
blkg hierarchy draining each associated throtl_grp, which guarantees
that all bios will eventually be pushed to the top-level service_queue
in throtl_data.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8f435a7..1080563 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1299,6 +1299,28 @@ out:
 	return throttled;
 }
 
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
+		while ((bio = bio_list_peek(&sq->bio_lists[READ])))
+			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+		while ((bio = bio_list_peek(&sq->bio_lists[WRITE])))
+			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+	}
+}
+
 /**
  * blk_throtl_drain - drain throttled bios
  * @q: request_queue to drain throttled bios for
@@ -1309,27 +1331,34 @@ void blk_throtl_drain(struct request_queue *q)
 	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct throtl_data *td = q->td;
-	struct throtl_service_queue *parent_sq = &td->service_queue;
-	struct throtl_grp *tg;
+	struct blkcg_gq *blkg;
+	struct cgroup *pos_cgrp;
 	struct bio *bio;
 	int rw;
 
 	queue_lockdep_assert_held(q);
+	rcu_read_lock();
 
-	while ((tg = throtl_rb_first(parent_sq))) {
-		struct throtl_service_queue *sq = &tg->service_queue;
+	/*
+	 * Drain each tg while doing post-order walk on the blkg tree, so
+	 * that all bios are propagated to td->service_queue.  It'd be
+	 * better to walk service_queue tree directly but blkg walk is
+	 * easier.
+	 */
+	blkg_for_each_descendant_post(blkg, pos_cgrp, td->queue->root_blkg)
+		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
 
-		throtl_dequeue_tg(tg);
+	tg_drain_bios(&td_root_tg(td)->service_queue);
 
-		while ((bio = bio_list_peek(&sq->bio_lists[READ])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
-		while ((bio = bio_list_peek(&sq->bio_lists[WRITE])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
-	}
+	/* finally, transfer bios from top-level tg's into the td */
+	tg_drain_bios(&td->service_queue);
+
+	rcu_read_unlock();
 	spin_unlock_irq(q->queue_lock);
 
+	/* all bios now should be in td->service_queue, issue them */
 	for (rw = READ; rw <= WRITE; rw++)
-		while ((bio = bio_list_pop(&parent_sq->bio_lists[rw])))
+		while ((bio = bio_list_pop(&td->service_queue.bio_lists[rw])))
 			generic_make_request(bio);
 
 	spin_lock_irq(q->queue_lock);
-- 
1.8.1.4
