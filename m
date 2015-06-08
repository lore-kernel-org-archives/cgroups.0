From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/8] cfq-iosched: fold cfq_find_alloc_queue() into cfq_get_queue()
Date: Mon,  8 Jun 2015 17:59:32 +0900
Message-ID: <1433753973-23684-8-git-send-email-tj@kernel.org>
References: <1433753973-23684-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7YVGVn8hJm698otdWykbv62rBv0r6L86EEaN7rOnrlY=;
        b=TRJWZZRSL/XTEP0iFJcHguq3wqQvE+LmH6zClRCNBTTu3HLdrp22y/Uv/zBr7UYJsa
         U9aBq8tdh+d55EnjBfD6sTUAWAnF4dcPZJ+Uvs1P0XBOOEceNGVnSLwOt24CRZlQZyKR
         WEfev09mW4gUFVemqMCSba5o9BBvo+VZjd4aPb/80dRvjVduWMhekx7QBbvYI+FtcXb3
         w+7szcjTsQwmkJiCgwDx7ewmHYLRyyPX6EtV9ZjXubj+a7ofo0YgTs6/np448JxpFrK4
         PKSTHrU7e4ALxDuZD3BD8hLRyNdt40q+jg+uxfOGf44ElEQiAOFEZ3PDifoZLW3Bb07z
         oKpQ==
In-Reply-To: <1433753973-23684-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cfq_find_alloc_queue() checks whether a queue actually needs to be
allocated, which is unnecessary as its sole caller, cfq_get_queue(),
only calls it if so.  Also, the oom queue fallback logic is scattered
between cfq_get_queue() and cfq_find_alloc_queue().  There really
isn't much going on in the latter and things can be made simpler by
folding it into cfq_get_queue().

This patch collapses cfq_find_alloc_queue() into cfq_get_queue().  The
change is fairly straight-forward with one exception - async_cfqq is
now initialized to NULL and the "!is_sync" test in the last if
conditional is replaced with "async_cfqq" test.  This is because gcc
(5.1.1) gets confused for some reason and warns that async_cfqq may be
used uninitialized otherwise.  Oh well, the code isn't necessarily
worse this way.

This patch doesn't cause any functional difference.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 49 +++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a775128..393befb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3572,33 +3572,6 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
 static inline void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio) { }
 #endif  /* CONFIG_CFQ_GROUP_IOSCHED */
 
-static struct cfq_queue *
-cfq_find_alloc_queue(struct cfq_data *cfqd, struct cfq_group *cfqg, bool is_sync,
-		     struct cfq_io_cq *cic, struct bio *bio)
-{
-	struct cfq_queue *cfqq;
-
-	cfqq = cic_to_cfqq(cic, is_sync);
-
-	/*
-	 * Always try a new alloc if we fell back to the OOM cfqq
-	 * originally, since it should just be a temporary situation.
-	 */
-	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
-		cfqq = kmem_cache_alloc_node(cfq_pool,
-					     GFP_ATOMIC | __GFP_ZERO,
-					     cfqd->queue->node);
-		if (cfqq) {
-			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
-			cfq_init_prio_data(cfqq, cic);
-			cfq_link_cfqq_cfqg(cfqq, cfqg);
-			cfq_log_cfqq(cfqd, cfqq, "alloced");
-		} else
-			cfqq = &cfqd->oom_cfqq;
-	}
-	return cfqq;
-}
-
 static struct cfq_queue **
 cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 {
@@ -3623,7 +3596,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 {
 	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
-	struct cfq_queue **async_cfqq;
+	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq;
 	struct cfq_group *cfqg;
 
@@ -3646,12 +3619,20 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			goto out;
 	}
 
-	cfqq = cfq_find_alloc_queue(cfqd, cfqg, is_sync, cic, bio);
+	cfqq = kmem_cache_alloc_node(cfq_pool, GFP_ATOMIC | __GFP_ZERO,
+				     cfqd->queue->node);
+	if (!cfqq) {
+		cfqq = &cfqd->oom_cfqq;
+		goto out;
+	}
+
+	cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
+	cfq_init_prio_data(cfqq, cic);
+	cfq_link_cfqq_cfqg(cfqq, cfqg);
+	cfq_log_cfqq(cfqd, cfqq, "alloced");
 
-	/*
-	 * pin the queue now that it's allocated, scheduler exit will prune it
-	 */
-	if (!is_sync && cfqq != &cfqd->oom_cfqq) {
+	if (async_cfqq) {
+		/* a new async queue is created, pin and remember */
 		cfqq->ref++;
 		*async_cfqq = cfqq;
 	}
@@ -4401,7 +4382,7 @@ static int cfq_init_queue(struct request_queue *q, struct elevator_type *e)
 		cfqd->prio_trees[i] = RB_ROOT;
 
 	/*
-	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
+	 * Our fallback cfqq if cfq_get_queue() runs into OOM issues.
 	 * Grab a permanent reference to it, so that the normal code flow
 	 * will not attempt to free it.  oom_cfqq is linked to root_group
 	 * but shouldn't hold a reference as it'll never be unlinked.  Lose
-- 
2.4.2
