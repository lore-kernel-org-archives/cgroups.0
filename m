From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] block: collapse blk_alloc_request() into get_request()
Date: Thu, 19 Apr 2012 16:29:21 -0700
Message-ID: <1334878164-24788-2-git-send-email-tj@kernel.org>
References: <1334878164-24788-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=mrMmsJHqmrjg8JRR+J5JdKvLDYcwBWQnsw8Wgu5ljvo=;
        b=HLY5ViV477CnHTMfUS1YN3VouTxAH5Gmq6yUjkwhJsoURobNGnWnt0xFcSHuDuOWCO
         ZswyJLZ3nKHO+jjY/rlAztVudCletqKBrlimx4D8G/ry2mJvMOKiOs/X01TxuNoFuMXP
         5/tKeFRbXf06UFWWrGFnK807rJ14p+sF786B4pGFbxvEzt8wel+tCEW/uqWBrY3OFVv7
         EBVDJRNnO+MGoT7GXqVfJEqaLKPlRiy7VA7Vgd/Se2F2RuMQ0qaHedJ6eRXnrqeVrNSC
         aUvYmQ3CSG5rAdKflaxceKDrCZEQe36smvjLwLetGKyiR1PVBfxjgG2sIzJcS+dPGyrH
         MYgg==
In-Reply-To: <1334878164-24788-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Allocation failure handling in get_request() is about to be updated.
To ease the update, collapse blk_alloc_request() into get_request().

This patch doesn't introduce any functional change.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-core.c |   46 +++++++++++++++++-----------------------------
 1 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3b02ba3..f6f68b0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -719,33 +719,6 @@ static inline void blk_free_request(struct request_queue *q, struct request *rq)
 	mempool_free(rq, q->rq.rq_pool);
 }
 
-static struct request *
-blk_alloc_request(struct request_queue *q, struct bio *bio, struct io_cq *icq,
-		  unsigned int flags, gfp_t gfp_mask)
-{
-	struct request *rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
-
-	if (!rq)
-		return NULL;
-
-	blk_rq_init(q, rq);
-
-	rq->cmd_flags = flags | REQ_ALLOCED;
-
-	if (flags & REQ_ELVPRIV) {
-		rq->elv.icq = icq;
-		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
-			mempool_free(rq, q->rq.rq_pool);
-			return NULL;
-		}
-		/* @rq->elv.icq holds on to io_context until @rq is freed */
-		if (icq)
-			get_io_context(icq->ioc);
-	}
-
-	return rq;
-}
-
 /*
  * ioc_batching returns true if the ioc is a valid batching request and
  * should be given priority access to a request.
@@ -968,10 +941,25 @@ retry:
 			goto fail_alloc;
 	}
 
-	rq = blk_alloc_request(q, bio, icq, rw_flags, gfp_mask);
-	if (unlikely(!rq))
+	/* allocate and init request */
+	rq = mempool_alloc(q->rq.rq_pool, gfp_mask);
+	if (!rq)
 		goto fail_alloc;
 
+	blk_rq_init(q, rq);
+	rq->cmd_flags = rw_flags | REQ_ALLOCED;
+
+	if (rw_flags & REQ_ELVPRIV) {
+		rq->elv.icq = icq;
+		if (unlikely(elv_set_request(q, rq, bio, gfp_mask))) {
+			mempool_free(rq, q->rq.rq_pool);
+			goto fail_alloc;
+		}
+		/* @rq->elv.icq holds on to io_context until @rq is freed */
+		if (icq)
+			get_io_context(icq->ioc);
+	}
+
 	/*
 	 * ioc may be NULL here, and ioc_batching will be false. That's
 	 * OK, if the queue is under the request limit then requests need
-- 
1.7.7.3
