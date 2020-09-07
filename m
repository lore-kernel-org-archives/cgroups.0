From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 4/5] blk-throttle: Avoid calculating bps/iops limitation repeatedly
Date: Mon,  7 Sep 2020 16:10:16 +0800
Message-ID: <f04f6e4de7f39f7cf2b47ff49247857a41e68df9.1599458244.git.baolin.wang@linux.alibaba.com>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
References: <cover.1599458244.git.baolin.wang@linux.alibaba.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, axboe@kernel.dk
Cc: baolin.wang@linux.alibaba.com, baolin.wang7@gmail.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

The tg_may_dispatch() will call tg_with_in_bps_limit() and
tg_with_in_iops_limit() to check if we can dispatch a bio or
not, which will calculate bps/iops limitation multiple times.
But tg_may_dispatch() is always called under queue lock, which
means the bps/iops limitation will not change in tg_may_dispatch().

So we can calculate the bps/iops limitation only once, and pass
them to tg_with_in_bps_limit() and tg_with_in_iops_limit() to
avoid calculating bps/iops limitation repeatedly.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 block/blk-throttle.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ca9002d..8719e37 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -894,7 +894,7 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 }
 
 static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
-				  unsigned long *wait)
+				  u32 iops_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
 	unsigned int io_allowed;
@@ -913,7 +913,7 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	 * have been trimmed.
 	 */
 
-	tmp = (u64)tg_iops_limit(tg, rw) * jiffy_elapsed_rnd;
+	tmp = (u64)iops_limit * jiffy_elapsed_rnd;
 	do_div(tmp, HZ);
 
 	if (tmp > UINT_MAX)
@@ -936,7 +936,7 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 }
 
 static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
-				 unsigned long *wait)
+				 u64 bps_limit, unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
 	u64 bytes_allowed, extra_bytes, tmp;
@@ -951,7 +951,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
 
-	tmp = tg_bps_limit(tg, rw) * jiffy_elapsed_rnd;
+	tmp = bps_limit * jiffy_elapsed_rnd;
 	do_div(tmp, HZ);
 	bytes_allowed = tmp;
 
@@ -963,7 +963,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 
 	/* Calc approx time to dispatch */
 	extra_bytes = tg->bytes_disp[rw] + bio_size - bytes_allowed;
-	jiffy_wait = div64_u64(extra_bytes * HZ, tg_bps_limit(tg, rw));
+	jiffy_wait = div64_u64(extra_bytes * HZ, bps_limit);
 
 	if (!jiffy_wait)
 		jiffy_wait = 1;
@@ -987,6 +987,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 {
 	bool rw = bio_data_dir(bio);
 	unsigned long bps_wait = 0, iops_wait = 0, max_wait = 0;
+	u64 bps_limit = tg_bps_limit(tg, rw);
+	u32 iops_limit = tg_iops_limit(tg, rw);
 
 	/*
  	 * Currently whole state machine of group depends on first bio
@@ -998,8 +1000,7 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	       bio != throtl_peek_queued(&tg->service_queue.queued[rw]));
 
 	/* If tg->bps = -1, then BW is unlimited */
-	if (tg_bps_limit(tg, rw) == U64_MAX &&
-	    tg_iops_limit(tg, rw) == UINT_MAX) {
+	if (bps_limit == U64_MAX && iops_limit == UINT_MAX) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -1021,8 +1022,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 				jiffies + tg->td->throtl_slice);
 	}
 
-	if (tg_with_in_bps_limit(tg, bio, &bps_wait) &&
-	    tg_with_in_iops_limit(tg, bio, &iops_wait)) {
+	if (tg_with_in_bps_limit(tg, bio, bps_limit, &bps_wait) &&
+	    tg_with_in_iops_limit(tg, bio, iops_limit, &iops_wait)) {
 		if (wait)
 			*wait = 0;
 		return true;
-- 
1.8.3.1

