From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] cfq-iosched: remove @gfp_mask from cfq_find_alloc_queue()
Date: Tue,  7 Jul 2015 11:35:58 -0400
Message-ID: <1436283361-3889-7-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/w+Mex/iGjpjZYKlaJluYZfZeVU07FpNCLdKWmxYpPk=;
        b=EEuwvQWymEl8AvMaH1re22ppMLZj+lX+NzMpeDIlg5SdwEK43k4EbnF68nH4p8swJ1
         LwcoX2iXl1FO4obdRkzgSMqsSLJoLLhTXSLA9ZPy2jd3/ueeHDZhpOljh42BwTYkTO8a
         31bG6Nxhh1gGdn7EVqI7GdRiHe+g3+/YttMahCNlVA2fsYKHSN6nSw/jd4rq9mw2f4dX
         e5BJTJRhPku1gHbgBS07rWq1UIIucPSsm23gPMERa9PpF2SYuBD9Y9UM3daRCLUd1vra
         HEfexzG8Fp/AKoB0t2p/+GYLBxBNGhMtOPZYmuScSomR2jy8u+7xexwSJJHiLZWDkSR8
         PcBg==
In-Reply-To: <1436283361-3889-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>, Arianna Avanzini <avanzini.arianna@gmail.com>

Even when allocations fail, cfq_find_alloc_queue() always returns a
valid cfq_queue by falling back to the oom cfq_queue.  As such, there
isn't much point in taking @gfp_mask and trying "harder" if __GFP_WAIT
is set.  GFP_NOWAIT allocations don't fail often and even when they do
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

v2: Updated to reflect GFP_ATOMIC -> GPF_NOWAIT.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Arianna Avanzini <avanzini.arianna@gmail.com>
---
 block/cfq-iosched.c | 45 ++++++++++-----------------------------------
 1 file changed, 10 insertions(+), 35 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5f11929..146b03d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -883,8 +883,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *cfqd, bool is_sync,
-				       struct cfq_io_cq *cic, struct bio *bio,
-				       gfp_t gfp_mask);
+				       struct cfq_io_cq *cic, struct bio *bio);
 
 static inline struct cfq_io_cq *icq_to_cic(struct io_cq *icq)
 {
@@ -3575,7 +3574,7 @@ static void check_ioprio_changed(struct cfq_io_cq *cic, struct bio *bio)
 	cfqq = cic_to_cfqq(cic, false);
 	if (cfqq) {
 		cfq_put_queue(cfqq);
-		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio, GFP_NOWAIT);
+		cfqq = cfq_get_queue(cfqd, BLK_RW_ASYNC, cic, bio);
 		cic_set_cfqq(cic, cfqq, false);
 	}
 
@@ -3643,13 +3642,12 @@ static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) {
 
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
@@ -3666,27 +3664,9 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
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
+					     GFP_NOWAIT | __GFP_ZERO,
+					     cfqd->queue->node);
 		if (cfqq) {
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 			cfq_init_prio_data(cfqq, cic);
@@ -3696,9 +3676,6 @@ cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			cfqq = &cfqd->oom_cfqq;
 	}
 out:
-	if (new_cfqq)
-		kmem_cache_free(cfq_pool, new_cfqq);
-
 	rcu_read_unlock();
 	return cfqq;
 }
@@ -3723,7 +3700,7 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 
 static struct cfq_queue *
 cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
-	      struct bio *bio, gfp_t gfp_mask)
+	      struct bio *bio)
 {
 	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
@@ -3742,7 +3719,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			goto out;
 	}
 
-	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio, gfp_mask);
+	cfqq = cfq_find_alloc_queue(cfqd, is_sync, cic, bio);
 
 	/*
 	 * pin the queue now that it's allocated, scheduler exit will prune it
@@ -4286,8 +4263,6 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	const bool is_sync = rq_is_sync(rq);
 	struct cfq_queue *cfqq;
 
-	might_sleep_if(gfp_mask & __GFP_WAIT);
-
 	spin_lock_irq(q->queue_lock);
 
 	check_ioprio_changed(cic, bio);
@@ -4297,7 +4272,7 @@ cfq_set_request(struct request_queue *q, struct request *rq, struct bio *bio,
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
 		if (cfqq)
 			cfq_put_queue(cfqq);
-		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio, gfp_mask);
+		cfqq = cfq_get_queue(cfqd, is_sync, cic, bio);
 		cic_set_cfqq(cic, cfqq, is_sync);
 	} else {
 		/*
-- 
2.4.3
