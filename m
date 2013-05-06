From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/33] blk-throttle: make blk_throtl_drain() ready for hierarchy
Date: Mon,  6 May 2013 15:46:05 -0700
Message-ID: <1367880372-28312-27-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=TC2DsBSdPPBxkfLxyp9fAjHQBm5oP4Ln3GKCtXOU0+8=;
        b=PkLBMFboajv5zrbuC+QfLvZ4y2oeKhmbPLhazGFmQjgohc3cIjFnNe3HoBN2z/+2oE
         JozpHAfb+YdrlFtIx5fNP+geoCD3ZscVRgWw3TZcT0Eha0mdHvVKjVVJ1qJJwQ4b6TJZ
         KtQ0NB6SPyiofMt6u6/C8cQOGJF3O9DXJzgxKAFfE6vNJfL3vdAbjGdzR6XRvZ9EA82y
         ox62wnQlJUYJE1Yu73exjZNY/Yc4I+TsWKUVe0pLjKDoltF0fbwYAH8wV1X57+NX03n4
         dz7o8J73rcJsKiDgZy2gyFmepo/DKQ5CzKjLSLojbhM8zlwQys4tM7npN+NRsjeF0Cs4
         KNZA==
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
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
index 918d222..8c6e133 100644
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
