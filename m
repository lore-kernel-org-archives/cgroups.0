From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 16/33] blk-throttle: add throtl_grp->service_queue
Date: Mon,  6 May 2013 15:45:55 -0700
Message-ID: <1367880372-28312-17-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=DH32Iu5A2/B9SEjgkdoEETR+lmTj/riMXJoRhb7h+zQ=;
        b=etANmDRfeM3dEpPEJRqG+2KOaT4ivRfGtyLSIkFvlSEhdBDHRagj/PNdMlwAax/0Ap
         KADhDjjn5gA369mKQ2UOVEgZkMyFRQiT3yn+dXGqUvH2RpOEBsnJ8jhE6iBQECcpA5iv
         3H1mFOv57R+N9v6tG/joYeX13vOzVccRioEeAAKgdzozG3HUIXWaKAMOe42abWrEOC42
         harUuSQNx9dAj6tZGpLXptwF2P9dtxvLiCVcdCeE9+Xy4FG90fNlEODbGPwtTpkW8ieq
         e6XVZlmnbICFFN6Ju0rw4/GZacUswgNj9HWWgwBNc0Co7yzBfn8frEwYWPFDMS+u9H1X
         01xQ==
In-Reply-To: <1367880372-28312-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, there's single service_queue per queue -
throtl_data->service_queue.  All active throtl_grp's are queued on the
queue and dispatched according to their limits.  To support hierarchy,
this will be expanded such that active throtl_grp's form a tree
anchored at throtl_data->service_queue and chained through each
intermediate throtl_grp's service_queue.

This patch adds throtl_grp->service_queue to prepare for hierarchy
support.  The initialization function - throtl_service_queue_init() -
is added and replaces the macro initializer.  The newly added
tg->service_queue isn't used yet.  Following patches will do.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ebaaaa9..7340440 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -33,9 +33,6 @@ struct throtl_service_queue {
 	unsigned long		first_pending_disptime;	/* disptime of the first tg */
 };
 
-#define THROTL_SERVICE_QUEUE_INITIALIZER				\
-	(struct throtl_service_queue){ .pending_tree = RB_ROOT }
-
 enum tg_state_flags {
 	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
 };
@@ -60,6 +57,9 @@ struct throtl_grp {
 	/* throtl_data this group belongs to */
 	struct throtl_data *td;
 
+	/* this group's service queue */
+	struct throtl_service_queue service_queue;
+
 	/*
 	 * Dispatch time in jiffies. This is the estimated time when group
 	 * will unthrottle and is ready to dispatch more bio. It is used as
@@ -190,11 +190,18 @@ alloc_stats:
 		goto alloc_stats;
 }
 
+/* init a service_queue, assumes the caller zeroed it */
+static void throtl_service_queue_init(struct throtl_service_queue *sq)
+{
+	sq->pending_tree = RB_ROOT;
+}
+
 static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	unsigned long flags;
 
+	throtl_service_queue_init(&tg->service_queue);
 	RB_CLEAR_NODE(&tg->rb_node);
 	tg->td = blkg->q->td;
 	bio_list_init(&tg->bio_lists[0]);
@@ -1168,8 +1175,8 @@ int blk_throtl_init(struct request_queue *q)
 	if (!td)
 		return -ENOMEM;
 
-	td->service_queue = THROTL_SERVICE_QUEUE_INITIALIZER;
 	INIT_DELAYED_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
+	throtl_service_queue_init(&td->service_queue);
 
 	q->td = td;
 	td->queue = q;
-- 
1.8.1.4
