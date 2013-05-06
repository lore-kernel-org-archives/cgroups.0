From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 27/33] blk-throttle: make blk_throtl_bio() ready for hierarchy
Date: Mon,  6 May 2013 15:46:06 -0700
Message-ID: <1367880372-28312-28-git-send-email-tj@kernel.org>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=7wuDMgOKsuc7PCP9F4yn3UQTFOJ4WaFjqcqP0NhX9b8=;
        b=t6hRWKdfAupYlS4H8YSzokBkYkTh+qaFDh+16KcIJug6513C0wPI1KMhn80E3xqq7j
         B0pOu63Bbf7wD1Z7t4WMfusvvicgYo5DQRl+ii3wQwZdbiFb+C+9cny4RJWZuPge156C
         npq0oeAyRg3t1sbJN2xovM49HQ91foVCQVm6sSYxRWlrOlenY5DldTshkQPZlxq9V21X
         AcnQt3ezeuovT7MzafNvQESiyvQyZh/cvKTg8ujarY4+pknyRm7yGiJDF7/79+mfktGG
         t4QwwRCtK0qkCVW6pR4MrZLChGvt8Jk+wNUvWfB6d9hE6y7EHQydPd49ngS+Z+vEM9VC
         /NNg==
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, vgoyal@redhat.com, Tejun Heo <tj@kernel.org>

Currently, blk_throtl_bio() issues the passed in bio directly if it's
within limits of its associated tg (throtl_grp).  This behavior
becomes incorrect with hierarchy support as the bio should be
accounted to and throttled by the ancestor throtl_grps too.

This patch makes the direct issue path of blk_throtl_bio() to loop
until it reaches the top-level service_queue or gets throttled.  If
the former, the bio can be issued directly; otherwise, it gets queued
at the first layer it was above limits.

As tg->parent_sq is always the top-level service queue currently, this
patch in itself doesn't make any behavior differences.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8c6e133..52321a4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1239,12 +1239,16 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 
 	sq = &tg->service_queue;
 
-	/* throtl is FIFO - if other bios are already queued, should queue */
-	if (sq->nr_queued[rw])
-		goto queue_bio;
+	while (true) {
+		/* throtl is FIFO - if bios are already queued, should queue */
+		if (sq->nr_queued[rw])
+			break;
 
-	/* Bio is with-in rate limit of group */
-	if (tg_may_dispatch(tg, bio, NULL)) {
+		/* if above limits, break to queue */
+		if (!tg_may_dispatch(tg, bio, NULL))
+			break;
+
+		/* within limits, let's charge and dispatch directly */
 		throtl_charge_bio(tg, bio);
 
 		/*
@@ -1259,10 +1263,19 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		 * So keep on trimming slice even if bio is not queued.
 		 */
 		throtl_trim_slice(tg, rw);
-		goto out_unlock;
+
+		/*
+		 * @bio passed through this layer without being throttled.
+		 * Climb up the ladder.  If we''re already at the top, it
+		 * can be executed directly.
+		 */
+		sq = sq->parent_sq;
+		tg = sq_to_tg(sq);
+		if (!tg)
+			goto out_unlock;
 	}
 
-queue_bio:
+	/* out-of-limit, queue to @tg */
 	throtl_log(sq, "[%c] bio. bdisp=%llu sz=%u bps=%llu iodisp=%u iops=%u queued=%d/%d",
 		   rw == READ ? 'R' : 'W',
 		   tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
-- 
1.8.1.4
