From: Tejun Heo <tj@kernel.org>
Subject: [PATCH block/for-next] blk-iocost: fix divide-by-zero in
 transfer_surpluses()
Date: Fri, 11 Sep 2020 13:07:46 -0400
Message-ID: <20200911170746.GG4295@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=3AjEi6jGt52sCYG9BLpiLcsHH3zd+gAC/phsC2ntthU=;
        b=JKlox8HeF84wzkIcQoSdZMzb6i1aJWdpyWSIxiL7LCaduzfZgAyPT1sZm6in5FXwM3
         xltvN80oIihI4QVyN4BbUoIIm0zDriphHq19mOuPSJI2g9qrmVGZohyEsdMJtLtpHtOc
         RSRwl3VLVhpG7HoevUhSI6BwOe7mhYw2INhERcVs0y6HDwmUpEit9JJTs0yhFDeBDmlF
         AYScKSGInP3Nvlm+FOEy3T3KAoJxRLHBqxaW7bRPuFTAqdhRuEPPNoMA4lwalUsKsF3n
         yjnY9S3VXYUfS7NFcbWHPkwLZwjrwOFPADAqJGiY/GC8LCvsxv3Jo55+ke2Yeya9RnFv
         PDaQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
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
---
 block/blk-iocost.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index fc897bb142bcd..978753335370a 100644
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
+		WEIGHT_ONE - min_t(root_iocg->hweight_donating, WEIGHT_ONE - 1));
 
 	/*
 	 * Calculate adjusted hwi, child_adjusted_sum and inuse for the inner
