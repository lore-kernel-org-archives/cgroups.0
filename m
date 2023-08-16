From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v2 2/4] blk-throttle: fix wrong comparation while 'carryover_ios/bytes' is negative
Date: Wed, 16 Aug 2023 09:27:06 +0800
Message-ID: <20230816012708.1193747-3-yukuai1@huaweicloud.com>
References: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230816012708.1193747-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

carryover_ios/bytes[] can be negative in the case that ios are
dispatched in the slice in advance, and then configuration is updated.
For example:

1) set iops limit to 1000, and slice start is 0, slice end is 100ms;
2) current time is 0, and 100 ios are dispatched, those ios will not be
   throttled, hence io_disp is 100;
3) still at current time 0, update iops limit to 100, then carryover_ios
   is (0 - 100) = -100;
4) then, dispatch a new io at time 0, the expected result is that this
   io will wait for 1s. The calculation in tg_within_iops_limit:

   io_disp = 0;
   io_allowed = calculate_io_allowed + carryover_ios
	      = 10 + (-100) = -90;
   io won't be throttled if (io_disp + 1 < io_allowed) passed.

Before this patch, in step 4) (io_disp + 1 < io_allowed) is passed,
because -90 for unsigned value is very huge, and such io won't be
throttled.

Fix this problem by checking if 'io/bytes_allowed' is negative first.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 5184f17f5129..7c93144d03da 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -825,7 +825,7 @@ static unsigned long tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio
 				 u32 iops_limit)
 {
 	bool rw = bio_data_dir(bio);
-	unsigned int io_allowed;
+	int io_allowed;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 
 	if (iops_limit == UINT_MAX) {
@@ -838,9 +838,8 @@ static unsigned long tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
 	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd) +
 		     tg->carryover_ios[rw];
-	if (tg->io_disp[rw] + 1 <= io_allowed) {
+	if (io_allowed > 0 && tg->io_disp[rw] + 1 <= io_allowed)
 		return 0;
-	}
 
 	/* Calc approx time to dispatch */
 	jiffy_wait = jiffy_elapsed_rnd - jiffy_elapsed;
@@ -851,7 +850,8 @@ static unsigned long tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				u64 bps_limit)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes;
+	long long bytes_allowed;
+	u64 extra_bytes;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
@@ -869,9 +869,8 @@ static unsigned long tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
 	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd) +
 			tg->carryover_bytes[rw];
-	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
+	if (bytes_allowed > 0 && tg->bytes_disp[rw] + bio_size <= bytes_allowed)
 		return 0;
-	}
 
 	/* Calc approx time to dispatch */
 	extra_bytes = tg->bytes_disp[rw] + bio_size - bytes_allowed;
-- 
2.39.2

