From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/9] cfq-iosched: fold cfq_find_alloc_queue() into cfq_get_queue()
Date: Tue,  7 Jul 2015 11:36:00 -0400
Message-ID: <1436283361-3889-9-git-send-email-tj@kernel.org>
References: <1436283361-3889-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4satsgP8j/QVHxuHTkKasm0KYOYRR3hDlgHsaPX05Es=;
        b=KFDNys0s7BmdMYbmtedE1G0sziyEb1BzoT/bCDRtdz3cFpBZkQSBOfbNssXXfcSbit
         i2/J6L2RWDxaZ4aiqppyUD9+nYV0yrG6Kt+Nyn0G3LbvDqliMXignGiqCfYShV/2qbDU
         Dh6ltJ9Vmnhd82uAyXAE8o5y7Hd5vvazfFO6rCnT3EPP6hY77nupDH03Tedh9LEVaJnx
         MTz+6ClWwQONXNtZUfabFVYM74TP8atewB47SNh3d4C0RyEFHeuP9vm2Ocsn9Vs2i7xn
         lQDr0JpGJ0Ca0rhC37Zhfx6cQIx5ptHKEsjfXX3Bx4Q0YvQjTkQNWcdM3tfdOGmanXs/
         jzgA==
In-Reply-To: <1436283361-3889-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

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

v2: Updated to reflect GFP_ATOMIC -> GPF_NOWAIT.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 block/cfq-iosched.c | 49 +++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f3ea8a1..fa2a2f7 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3640,33 +3640,6 @@ static void check_blkcg_changed(struct cfq_io_cq *cic, struct bio *bio)
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
-					     GFP_NOWAIT | __GFP_ZERO,
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
@@ -3691,7 +3664,7 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 {
 	int ioprio_class = IOPRIO_PRIO_CLASS(cic->ioprio);
 	int ioprio = IOPRIO_PRIO_DATA(cic->ioprio);
-	struct cfq_queue **async_cfqq;
+	struct cfq_queue **async_cfqq = NULL;
 	struct cfq_queue *cfqq;
 	struct cfq_group *cfqg;
 
@@ -3714,12 +3687,20 @@ cfq_get_queue(struct cfq_data *cfqd, bool is_sync, struct cfq_io_cq *cic,
 			goto out;
 	}
 
-	cfqq = cfq_find_alloc_queue(cfqd, cfqg, is_sync, cic, bio);
+	cfqq = kmem_cache_alloc_node(cfq_pool, GFP_NOWAIT | __GFP_ZERO,
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
@@ -4469,7 +4450,7 @@ static int cfq_init_queue(struct request_queue *q, struct elevator_type *e)
 		cfqd->prio_trees[i] = RB_ROOT;
 
 	/*
-	 * Our fallback cfqq if cfq_find_alloc_queue() runs into OOM issues.
+	 * Our fallback cfqq if cfq_get_queue() runs into OOM issues.
 	 * Grab a permanent reference to it, so that the normal code flow
 	 * will not attempt to free it.  oom_cfqq is linked to root_group
 	 * but shouldn't hold a reference as it'll never be unlinked.  Lose
-- 
2.4.3
