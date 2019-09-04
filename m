From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] blk-iocost: Don't let merges push vtime into the future
Date: Wed,  4 Sep 2019 12:45:53 -0700
Message-ID: <20190904194556.2984857-3-tj@kernel.org>
References: <20190904194556.2984857-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=20hd4msrraab6jp0F0s3lMKgksvtNidxbTFc6K2dRls=;
        b=CupX71bIVnfpPA8VGUrRsLsNQaXHSnSrVgTiMAhqvTUTIhXuj/bvxSRlaVRiANA7Z7
         W6lK0f2NMmzXwkjXayxc91oQmH4j/o4uQkRffIRsRwb8+njuyWCFetp90/r9jD94bYdk
         cFSShDfZhragdYKCx7McGmf7vS/mAWvMuLK/QaWOu7qHR/VE/tB5DPouZagXNU8mbefP
         10UO9oCiSORQNsx88g6WFqmOTixTwCTygs1Ii3g5KOPq/fc26lgbTzZc06xATfiZxmbl
         BZhbP3ZOsXL4Lj8XDj7iq38DoHYra/0lw/G1bbIYVud1VBcWhHDbE4lA5tCkd3Q/N6gE
         JBjQ==
In-Reply-To: <20190904194556.2984857-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@vger.kernel.org, cgroups@vger.kernel.org, newella@fb.com, Tejun Heo <tj@kernel.org>

Merges have the same problem that forced-bios had which is fixed by
the previous patch.  The cost of a merge is calculated at the time of
issue and force-advances vtime into the future.  Until global vtime
catches up, how the cgroup's hweight changes in the meantime doesn't
matter and it often leads to situations where the cost is calculated
at one hweight and paid at a very different one.  See the previous
patch for more details.

Fix it by never advancing vtime into the future for merges.  If budget
is available, vtime is advanced.  Otherwise, the cost is charged as
debt.

This brings merge cost handling in line with issue cost handling in
ioc_rqos_throttle().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-iocost.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 5b0c024ee5dd..6000ce9b10bb 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1784,28 +1784,39 @@ static void ioc_rqos_merge(struct rq_qos *rqos, struct request *rq,
 			   struct bio *bio)
 {
 	struct ioc_gq *iocg = blkg_to_iocg(bio->bi_blkg);
+	struct ioc *ioc = iocg->ioc;
 	sector_t bio_end = bio_end_sector(bio);
+	struct ioc_now now;
 	u32 hw_inuse;
 	u64 abs_cost, cost;
 
-	/* add iff the existing request has cost assigned */
-	if (!rq->bio || !rq->bio->bi_iocost_cost)
+	/* bypass if disabled or for root cgroup */
+	if (!ioc->enabled || !iocg->level)
 		return;
 
 	abs_cost = calc_vtime_cost(bio, iocg, true);
 	if (!abs_cost)
 		return;
 
+	ioc_now(ioc, &now);
+	current_hweight(iocg, NULL, &hw_inuse);
+	cost = abs_cost_to_cost(abs_cost, hw_inuse);
+
 	/* update cursor if backmerging into the request at the cursor */
 	if (blk_rq_pos(rq) < bio_end &&
 	    blk_rq_pos(rq) + blk_rq_sectors(rq) == iocg->cursor)
 		iocg->cursor = bio_end;
 
-	current_hweight(iocg, NULL, &hw_inuse);
-	cost = div64_u64(abs_cost * HWEIGHT_WHOLE, hw_inuse);
-	bio->bi_iocost_cost = cost;
-
-	atomic64_add(cost, &iocg->vtime);
+	/*
+	 * Charge if there's enough vtime budget and the existing request
+	 * has cost assigned.  Otherwise, account it as debt.  See debt
+	 * handling in ioc_rqos_throttle() for details.
+	 */
+	if (rq->bio && rq->bio->bi_iocost_cost &&
+	    time_before_eq64(atomic64_read(&iocg->vtime) + cost, now.vnow))
+		iocg_commit_bio(iocg, bio, cost);
+	else
+		atomic64_add(abs_cost, &iocg->abs_vdebt);
 }
 
 static void ioc_rqos_done_bio(struct rq_qos *rqos, struct bio *bio)
-- 
2.17.1

