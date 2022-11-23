From: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/11] blk-throttle: correct calculation of wait time in tg_may_dispatch
Date: Wed, 23 Nov 2022 14:03:54 +0800
Message-ID: <20221123060401.20392-5-shikemeng@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221123060401.20392-1-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If bps and iops both reach limit, we always return bps wait time as
tg_within_iops_limit is after "tg_within_bps_limit(tg, bio, bps_limit) &&"
and will not be called if tg_within_bps_limit return true.

Fix this by always calling tg_within_bps_limit and tg_within_iops_limit
to get wait time for both bps and iops.

Observed that:
1. Wait time in tg_within_iops_limit/tg_within_bps_limit need always
be stored as wait argument is always passed.
2. Stored wait time is zero if iops/bps is limited otherwise non-zero
is stored.
Simpfy tg_within_iops_limit/tg_within_bps_limit by removing wait argument
and return wait time directly. Caller tg_may_dispatch checks if wait time
is zero to find if iops/bps is limited.

Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index acfac916ed99..01e30380c19b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -815,17 +815,15 @@ static void tg_update_carryover(struct throtl_grp *tg)
 		   tg->carryover_ios[READ], tg->carryover_ios[WRITE]);
 }
 
-static bool tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio,
-				 u32 iops_limit, unsigned long *wait)
+static unsigned long tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio,
+				 u32 iops_limit)
 {
 	bool rw = bio_data_dir(bio);
 	unsigned int io_allowed;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 
 	if (iops_limit == UINT_MAX) {
-		if (wait)
-			*wait = 0;
-		return true;
+		return 0;
 	}
 
 	jiffy_elapsed = jiffies - tg->slice_start[rw];
@@ -835,21 +833,16 @@ static bool tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd) +
 		     tg->carryover_ios[rw];
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
-		if (wait)
-			*wait = 0;
-		return true;
+		return 0;
 	}
 
 	/* Calc approx time to dispatch */
 	jiffy_wait = jiffy_elapsed_rnd - jiffy_elapsed;
-
-	if (wait)
-		*wait = jiffy_wait;
-	return false;
+	return jiffy_wait;
 }
 
-static bool tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
-				u64 bps_limit, unsigned long *wait)
+static unsigned long tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
+				u64 bps_limit)
 {
 	bool rw = bio_data_dir(bio);
 	u64 bytes_allowed, extra_bytes;
@@ -857,9 +850,7 @@ static bool tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	unsigned int bio_size = throtl_bio_data_size(bio);
 
 	if (bps_limit == U64_MAX) {
-		if (wait)
-			*wait = 0;
-		return true;
+		return 0;
 	}
 
 	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
@@ -872,9 +863,7 @@ static bool tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd) +
 			tg->carryover_bytes[rw];
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
-		if (wait)
-			*wait = 0;
-		return true;
+		return 0;
 	}
 
 	/* Calc approx time to dispatch */
@@ -889,9 +878,7 @@ static bool tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	 * up we did. Add that time also.
 	 */
 	jiffy_wait = jiffy_wait + (jiffy_elapsed_rnd - jiffy_elapsed);
-	if (wait)
-		*wait = jiffy_wait;
-	return false;
+	return jiffy_wait;
 }
 
 /*
@@ -939,8 +926,9 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 				jiffies + tg->td->throtl_slice);
 	}
 
-	if (tg_within_bps_limit(tg, bio, bps_limit, &bps_wait) &&
-	    tg_within_iops_limit(tg, bio, iops_limit, &iops_wait)) {
+	bps_wait = tg_within_bps_limit(tg, bio, bps_limit);
+	iops_wait = tg_within_iops_limit(tg, bio, iops_limit);
+	if (bps_wait + iops_wait == 0) {
 		if (wait)
 			*wait = 0;
 		return true;
-- 
2.30.0

