From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v6 3/8] blk-throttle: factor out code to calculate ios/bytes_allowed
Date: Fri,  1 Jul 2022 15:49:18 +0800
Message-ID: <20220701074923.657426-5-yukuai3@huawei.com>
References: <20220701074923.657426-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220701074923.657426-1-yukuai3@huawei.com>
Sender: yukuai1@huaweicloud.com
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

No functional changes, new apis will be used in later patches to
calculate wait time for throttled bios while updating config.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 51 +++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a89c62bef2fb..8612a071305e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -754,33 +754,20 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 		   tg->slice_start[rw], tg->slice_end[rw], jiffies);
 }
 
-static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
-				  u32 iops_limit, unsigned long *wait)
+static unsigned int calculate_io_allowed(u32 iops_limit,
+					 unsigned long jiffy_elapsed)
 {
-	bool rw = bio_data_dir(bio);
 	unsigned int io_allowed;
-	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
 	u64 tmp;
 
-	if (iops_limit == UINT_MAX) {
-		if (wait)
-			*wait = 0;
-		return true;
-	}
-
-	jiffy_elapsed = jiffies - tg->slice_start[rw];
-
-	/* Round up to the next throttle slice, wait time must be nonzero */
-	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
-
 	/*
-	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be
+	 * jiffy_elapsed should not be a big value as minimum iops can be
 	 * 1 then at max jiffy elapsed should be equivalent of 1 second as we
 	 * will allow dispatch after 1 second and after that slice should
 	 * have been trimmed.
 	 */
 
-	tmp = (u64)iops_limit * jiffy_elapsed_rnd;
+	tmp = (u64)iops_limit * jiffy_elapsed;
 	do_div(tmp, HZ);
 
 	if (tmp > UINT_MAX)
@@ -788,6 +775,32 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	else
 		io_allowed = tmp;
 
+	return io_allowed;
+}
+
+static u64 calculate_bytes_allowed(u64 bps_limit, unsigned long jiffy_elapsed)
+{
+	return mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed, (u64)HZ);
+}
+
+static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
+				  u32 iops_limit, unsigned long *wait)
+{
+	bool rw = bio_data_dir(bio);
+	unsigned int io_allowed;
+	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
+
+	if (iops_limit == UINT_MAX) {
+		if (wait)
+			*wait = 0;
+		return true;
+	}
+
+	jiffy_elapsed = jiffies - tg->slice_start[rw];
+
+	/* Round up to the next throttle slice, wait time must be nonzero */
+	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
+	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd);
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
 			*wait = 0;
@@ -824,9 +837,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-	bytes_allowed = mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed_rnd,
-					    (u64)HZ);
-
+	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd);
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
 			*wait = 0;
-- 
2.31.1

