From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/8] cfq-iosched: remove @gfp_mask from cfq_find_alloc_queue()
Date: Mon,  8 Jun 2015 17:59:30 +0900
Message-ID: <1433753973-23684-6-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7TwIfPIhuFYF/HXi0Fvi1iW6LKHr87CaJDSmXzpNmaQ=;
        b=z0N9aNXu5eOp0G+uqbNuPpMZVnblURDRBJtMU6XmPv0Z8B2oKThg7Y44dQ2FmXxYu4
         wjZxNed1S4xbW4UdOthLcb/9Jz1fIXTRMtvBtw5tX+8JppRWLnYKPDc8mkxJI2/FffZn
         r0e7DPg7eaj6RisZdJLxGQBeNFvNIxlT7/WKse7XxZCtj3rTwTglcmUfiUk5yGWXmRCF
         QQJs5dOLB2t1NjVfOLW57UwMxuYZFH4fzxxxbJ5E+BvrhAt2cDgtetohDKW0ncUGLCOM
         9fYRRMsc5Sgr16d02PcdJsb3tU4BlNplqdm9qPvk27hD7jv4cvwziw7XV2b0yd9Tskyq
         kPMQ==
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Even when allocations fail, cfq_find_alloc_queue() always returns a
valid cfq_queue by falling back to the oom cfq_queue.  As such, there
isn't much point in taking @gfp_mask and trying "harder" if __GFP_WAIT
is set.  GFP_ATOMIC allocations don't fail often and even when they do
the degraded behavior is acceptable and temporary.

After all, the only reason get_request(), which ultimately determines
the gfp_mask, cares about __GFP_WAIT is to guarantee request
allocation, assuming IO forward progress, for callers which are
willing to wait.  There's no reason for cfq_find_alloc_queue() to
behave differently on __GFP_WAIT when it already has a fallback
mechanism.

Remove @gfp_mask from cfq_find_alloc_queue() and propagate the changes
to its callers.  This simplifies the function quite a bit and will
help making async queues per-cfq_group.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 45 ++++++++++-----------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 90d5a87..b8e83cd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -858,8 +858,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *cfqd, bool is_sync,
-				       struct cfq_io_cq *cic, struct bio *bio,
-				       gfp_t gfp_mask);
+				       struct cfq_io_cq *cic, struct bio *bio);
 
 static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
 {
@@ -3507,7 +3506,7 @@ static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
 	cfqq = cic_to_cfqq(cic, false);
 	if (cfqq) {
 		cfq_put_queue(cfqq);
-		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_ATOMIC);
+		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio);
 		cic_set_cfqq(cic, cfqq, false);
 	}
 
@@ -3575,13 +3574,12 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) {
 
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
-		     struct bio *bio, gfp_t gfp_mask)
+		     struct bio *bio)
 {
 	struct blkcg *blkcg;
-	struct cfq_queue *cfqq, *new_cfqq = NULL;
+	struct cfq_queue *cfqq;
 	struct cfq_group *cfqg;
 
-retry:
 	rcu_read_lock();
 
 	blkcg = bio_blkcg(bio);
@@ -3598,27 +3596,9 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 	 * originally, since it should just be a temporary situation.
 	 */
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = NULL;
-		if (new_cfqq) {
-			cfqq = new_cfqq;
-			new_cfqq = NULL;
-		} else if (gfp_mask & __GFP_WAIT) {
-			rcu_read_unlock();
-			spin_unlock_irq(cfqd->queue->queue_lock);
-			new_cfqq = kmem_cache_alloc_node(cfq_pool,
-					gfp_mask | __GFP_ZERO,
-					cfqd->queue->node);
-			spin_lock_irq(cfqd->queue->queue_lock);
-			if (new_cfqq)
-				goto retry;
-			else
-				return &cfqd->oom_cfqq;
-		} else {
-			cfqq = kmem_cache_alloc_node(cfq_pool,
-					gfp_mask | __GFP_ZERO,
-					cfqd->queue->node);
-		}
-
+		cfqq = kmem_cache_alloc_node(cfq_pool,
+					     GFP_ATOMIC | __GFP_ZERO,
+					     cfqd->queue->node);
 		if (cfqq) {
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 			cfq_init_prio_data(cfqq, cic);
@@ -3628,9 +3608,6 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			cfqq = &cfqd->oom_cfqq;
 	}
 out:
-	if (new_cfqq)
-		kmem_cache_free(cfq_pool, new_cfqq);
-
 	rcu_read_unlock();
 	return cfqq;
 }
@@ -3655,7 +3632,7 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 
 static struct cfq_queue *
 cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
-	      struct bio *bio, gfp_t gfp_mask)
+	      struct bio *bio)
 {
 	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
@@ -3674,7 +3651,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			goto out;
 	}
 
-	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);
+	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -4218,8 +4195,6 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
 
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
 	spin_lock_irq(q->queue_lock);
 
 	check_ioprio_changed(cic, bio);
@@ -4229,7 +4204,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
 		if (cfqq)
 			cfq_put_queue(cfqq);
-		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
-- 
2.4.2
