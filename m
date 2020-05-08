From: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Subject: [PATCH 1/4] blk-throttle: remove blk_throtl_drain
Date: Sat,  9 May 2020 00:00:12 +0200
Message-ID: <20200508220015.11528-2-guoqing.jiang@cloud.ionos.com>
References: <20200508220015.11528-1-guoqing.jiang@cloud.ionos.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nqYXnG0hXHAuFcgizjaOL1g3/nTuWaq2pTGY70YFO3Y=;
        b=FTCqn59ZXMOJsVXSlArE/0ZWBGzr2XuYwLeHciwR5qzYZRXhR1EZ6Xfd6b7/r8ih0M
         CfN1XuLLM8m4AnYPs62BvH51dOTAR5+i1qZePVMFNuxE2GVd9zbIWN8A6W5SngNAMtbM
         rXu+yWKyHjiBcT5SBjH0ANMY+QMONbTD+tH6p8U1ZVzMs9ozYFw13Ur1sZDtPyNal6uH
         0Fa+wXY+SeyfRIIpUvbNP7+2IC8CiFsof1w9hIOZrSKNptintXW2VO0+TOZPoS4I/rdb
         4Q7/SUjABCOgY7csXNyxU5xVWEAZcuwTTrxKovuO8/bM3kThIQatghRykiVvYkEk+qrx
         QtNg==
In-Reply-To: <20200508220015.11528-1-guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>

After the commit 5addeae1bedc4 ("blk-cgroup: remove blkcg_drain_queue"),
there is no caller of blk_throtl_drain, so let's remove it.

Signed-off-by: Guoqing Jiang <guoqing.jiang-8+5b1tb3oTXfrHaScsAUWw@public.gmane.org>
---
 block/blk-throttle.c | 41 -----------------------------------------
 block/blk.h          |  2 --
 2 files changed, 43 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 98233c9c65a8..0b2ce7fb77a7 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2380,47 +2380,6 @@ static void tg_drain_bios(struct throtl_service_queue *parent_sq)
 	}
 }
 
-/**
- * blk_throtl_drain - drain throttled bios
- * @q: request_queue to drain throttled bios for
- *
- * Dispatch all currently throttled bios on @q through ->make_request_fn().
- */
-void blk_throtl_drain(struct request_queue *q)
-	__releases(&q->queue_lock) __acquires(&q->queue_lock)
-{
-	struct throtl_data *td = q->td;
-	struct blkcg_gq *blkg;
-	struct cgroup_subsys_state *pos_css;
-	struct bio *bio;
-	int rw;
-
-	rcu_read_lock();
-
-	/*
-	 * Drain each tg while doing post-order walk on the blkg tree, so
-	 * that all bios are propagated to td->service_queue.  It'd be
-	 * better to walk service_queue tree directly but blkg walk is
-	 * easier.
-	 */
-	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
-		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
-
-	/* finally, transfer bios from top-level tg's into the td */
-	tg_drain_bios(&td->service_queue);
-
-	rcu_read_unlock();
-	spin_unlock_irq(&q->queue_lock);
-
-	/* all bios now should be in td->service_queue, issue them */
-	for (rw = READ; rw <= WRITE; rw++)
-		while ((bio = throtl_pop_queued(&td->service_queue.queued[rw],
-						NULL)))
-			generic_make_request(bio);
-
-	spin_lock_irq(&q->queue_lock);
-}
-
 int blk_throtl_init(struct request_queue *q)
 {
 	struct throtl_data *td;
diff --git a/block/blk.h b/block/blk.h
index 73bd3b1c6938..997459de47d0 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -307,12 +307,10 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_mask, int node);
  * Internal throttling interface
  */
 #ifdef CONFIG_BLK_DEV_THROTTLING
-extern void blk_throtl_drain(struct request_queue *q);
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern void blk_throtl_register_queue(struct request_queue *q);
 #else /* CONFIG_BLK_DEV_THROTTLING */
-static inline void blk_throtl_drain(struct request_queue *q) { }
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
-- 
2.17.1

