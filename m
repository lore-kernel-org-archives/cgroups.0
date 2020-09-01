From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 08/27] blk-iocost: s/HWEIGHT_WHOLE/WEIGHT_ONE/g
Date: Tue,  1 Sep 2020 14:52:38 -0400
Message-ID: <20200901185257.645114-9-tj@kernel.org>
References: <20200901185257.645114-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/e5PktXRLfAON/oeMdCF9GHjT7JkUKFYrJ6ekTNbMj4=;
        b=fVMNPf9V07T3Oj0WLXkxJyr2vUryz+0eFnqMy0IfL0m9+flFyBQJkyxPkvXdbI+V5y
         fp50Dp+/Sw0qfga/3hn/lHcdMLzu9HKS6cbiP8vssRSknZyEF9y2ct3EfuzNb8Kd9fYT
         YpqpPe51lFRcaFG6N+Lz94nju/FMYSyauWu9TZ70urnuYUS5ZXwJGG7VsmVEajHW9LJ0
         TQgAB3lwHPjX+rpEDclBOJ3LGs0imUwHCUXFyX3E291U0rRRwKad7A8bW4gty3YipSl7
         n+loyCrxZg6UQnSEQEsBXo4D3F87fRblhrgP2P3+jfsgHN3ssjLyxgRXh3RHtlsLmwWg
         At+w==
In-Reply-To: <20200901185257.645114-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, newella-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We're gonna use HWEIGHT_WHOLE for regular weights too. Let's rename it to
WEIGHT_ONE.

Pure rename.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b2b8dfbeee5a..5e6d56eec1c9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -68,7 +68,7 @@
  * gets 300/(100+300) or 75% share, and A0 and A1 equally splits the rest,
  * 12.5% each.  The distribution mechanism only cares about these flattened
  * shares.  They're called hweights (hierarchical weights) and always add
- * upto 1 (HWEIGHT_WHOLE).
+ * upto 1 (WEIGHT_ONE).
  *
  * A given cgroup's vtime runs slower in inverse proportion to its hweight.
  * For example, with 12.5% weight, A0's time runs 8 times slower (100/12.5)
@@ -246,7 +246,7 @@ enum {
 	MIN_VALID_USAGES	= 2,
 
 	/* 1/64k is granular enough and can easily be handled w/ u32 */
-	HWEIGHT_WHOLE		= 1 << 16,
+	WEIGHT_ONE		= 1 << 16,
 
 	/*
 	 * As vtime is used to calculate the cost of each IO, it needs to
@@ -285,8 +285,8 @@ enum {
 	 * donate the surplus.
 	 */
 	SURPLUS_SCALE_PCT	= 125,			/* * 125% */
-	SURPLUS_SCALE_ABS	= HWEIGHT_WHOLE / 50,	/* + 2% */
-	SURPLUS_MIN_ADJ_DELTA	= HWEIGHT_WHOLE / 33,	/* 3% */
+	SURPLUS_SCALE_ABS	= WEIGHT_ONE / 50,	/* + 2% */
+	SURPLUS_MIN_ADJ_DELTA	= WEIGHT_ONE / 33,	/* 3% */
 
 	/* switch iff the conditions are met for longer than this */
 	AUTOP_CYCLE_NSEC	= 10LLU * NSEC_PER_SEC,
@@ -491,7 +491,7 @@ struct ioc_gq {
 	struct hrtimer			waitq_timer;
 	struct hrtimer			delay_timer;
 
-	/* usage is recorded as fractions of HWEIGHT_WHOLE */
+	/* usage is recorded as fractions of WEIGHT_ONE */
 	int				usage_idx;
 	u32				usages[NR_USAGE_SLOTS];
 
@@ -658,7 +658,7 @@ static struct ioc_cgrp *blkcg_to_iocc(struct blkcg *blkcg)
  */
 static u64 abs_cost_to_cost(u64 abs_cost, u32 hw_inuse)
 {
-	return DIV64_U64_ROUND_UP(abs_cost * HWEIGHT_WHOLE, hw_inuse);
+	return DIV64_U64_ROUND_UP(abs_cost * WEIGHT_ONE, hw_inuse);
 }
 
 /*
@@ -666,7 +666,7 @@ static u64 abs_cost_to_cost(u64 abs_cost, u32 hw_inuse)
  */
 static u64 cost_to_abs_cost(u64 cost, u32 hw_inuse)
 {
-	return DIV64_U64_ROUND_UP(cost * hw_inuse, HWEIGHT_WHOLE);
+	return DIV64_U64_ROUND_UP(cost * hw_inuse, WEIGHT_ONE);
 }
 
 static void iocg_commit_bio(struct ioc_gq *iocg, struct bio *bio, u64 cost)
@@ -980,7 +980,7 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 	 */
 	smp_rmb();
 
-	hwa = hwi = HWEIGHT_WHOLE;
+	hwa = hwi = WEIGHT_ONE;
 	for (lvl = 0; lvl <= iocg->level - 1; lvl++) {
 		struct ioc_gq *parent = iocg->ancestors[lvl];
 		struct ioc_gq *child = iocg->ancestors[lvl + 1];
@@ -2088,8 +2088,8 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	atomic64_set(&iocg->done_vtime, now.vnow);
 	atomic64_set(&iocg->active_period, atomic64_read(&ioc->cur_period));
 	INIT_LIST_HEAD(&iocg->active_list);
-	iocg->hweight_active = HWEIGHT_WHOLE;
-	iocg->hweight_inuse = HWEIGHT_WHOLE;
+	iocg->hweight_active = WEIGHT_ONE;
+	iocg->hweight_inuse = WEIGHT_ONE;
 
 	init_waitqueue_head(&iocg->waitq);
 	hrtimer_init(&iocg->waitq_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-- 
2.26.2

