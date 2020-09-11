From: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 block/for-next] blk-iocost: fix divide-by-zero in
 transfer_surpluses()
Date: Fri, 11 Sep 2020 18:40:49 -0400
Message-ID: <20200911224049.GA865564@mtj.thefacebook.com>
References: <20200911170746.GG4295@mtj.thefacebook.com>
 <ff46ca79-433e-3279-a8eb-35156639be7b@kernel.dk>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YYtbWxsMj/6n0uZf9WI97Rz4VWxjIwP6xqNBdneeUNo=;
        b=JkeVh8VK3P/IsY0yYuXRdbFDfSKwWuZBsdVeYQRNJXfK2KGyYQA/AQG1w6u3J0hR27
         xeKsvGfP60teeylfKsR7sGVXFMV23UrkcYS7IDmwba1mQ6wUDlymmXWC2YHbSd29ru18
         pt2KX5E/s3IOIPopfD1+EeR9VSvm3ykan7xzxtVrzfWo4ez/vOxR+5JrJjTOwyjKrpFu
         TuMTwzTuMnCHWaDumPkGYbWJTCWoxq4zR3eSIPh7oON1BRWWNFipreIaAwRz8hYzfHqT
         1o5fPvv/NulyfvabHbVdfiQCigpSGk1nVtsUJ2oyfjGmIk7eh233XREeAOk/JxjqdGzp
         66JQ==
Content-Disposition: inline
In-Reply-To: <ff46ca79-433e-3279-a8eb-35156639be7b@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org

Conceptually, root_iocg->hweight_donating must be less than WEIGHT_ONE but
all hweight calculations round up and thus it may end up >= WEIGHT_ONE
triggering divide-by-zero and other issues. Bound the value to avoid
surprises.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: e08d02aa5fc9 ("blk-iocost: implement Andy's method for donation weight updates")

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Jens, I was flipping between doing max_t(, 1) over the whole divider and
doing min_t(, WEIGHT_ONE - 1) for hweight_donating. I thought that I as
testing after the last change but it obviously wasn't and the previous patch
doesn't compile due to missing type argument. Can you please apply this
patch instead? I can send an incremental patch if that'd be better. My
apologies.

Thanks.

 block/blk-iocost.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index fc897bb142bcd..6e29b4dcf3566 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1881,15 +1881,21 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 
 	/*
 	 * Calculate the global donation rate (gamma) - the rate to adjust
-	 * non-donating budgets by. No need to use 64bit multiplication here as
-	 * the first operand is guaranteed to be smaller than WEIGHT_ONE
-	 * (1<<16).
+	 * non-donating budgets by.
+	 *
+	 * No need to use 64bit multiplication here as the first operand is
+	 * guaranteed to be smaller than WEIGHT_ONE (1<<16).
+	 *
+	 * We know that there are beneficiary nodes and the sum of the donating
+	 * hweights can't be whole; however, due to the round-ups during hweight
+	 * calculations, root_iocg->hweight_donating might still end up equal to
+	 * or greater than whole. Limit the range when calculating the divider.
 	 *
 	 * gamma = (1 - t_r') / (1 - t_r)
 	 */
 	gamma = DIV_ROUND_UP(
 		(WEIGHT_ONE - root_iocg->hweight_after_donation) * WEIGHT_ONE,
-		WEIGHT_ONE - root_iocg->hweight_donating);
+		WEIGHT_ONE - min_t(u32, root_iocg->hweight_donating, WEIGHT_ONE - 1));
 
 	/*
 	 * Calculate adjusted hwi, child_adjusted_sum and inuse for the inner
