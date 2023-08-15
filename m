From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 4/4] blk-throttle: consider 'carryover_ios/bytes' in throtl_trim_slice()
Date: Tue, 15 Aug 2023 09:41:23 +0800
Message-ID: <20230815014123.368929-5-yukuai1@huaweicloud.com>
References: <20230815014123.368929-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20230815014123.368929-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, yukuai3@huawei.com, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Currently, 'carryover_ios/bytes' is not handled in throtl_trim_slice(),
for consequence, 'carryover_ios/bytes' will be used to throttle bio
multiple times, for example:

1) set iops limit to 100, and slice start is 0, slice end is 100ms;
2) current time is 0, and 10 ios are dispatched, those io won't be
   throttled and io_disp is 10;
3) still at current time 0, update iops limit to 1000, carryover_ios is
   updated to (0 - 10) = -10;
4) in this slice(0 - 100ms), io_allowed = 100 + (-10) = 90, which means
   only 90 ios can be dispatched without waiting;
5) assume that io is throttled in slice(0 - 100ms), and
   throtl_trim_slice() update silce to (100ms - 200ms). In this case,
   'carryover_ios/bytes' is not cleared and still only 90 ios can be
   dispatched between 100ms - 200ms.

Fix this problem by updating 'carryover_ios/bytes' in
throtl_trim_slice().

Fixes: a880ae93e5b5 ("blk-throttle: fix io hung due to configuration updates")
Reported-by: zhuxiaohui <zhuxiaohui.400@bytedance.com>
Link: https://lore.kernel.org/all/20230812072116.42321-1-zhuxiaohui.400@bytedance.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e5296960c799..75b4a78c1e45 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -729,8 +729,9 @@ static u64 calculate_bytes_allowed(u64 bps_limit, unsigned long jiffy_elapsed)
 /* Trim the used slices and adjust slice start accordingly */
 static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 {
-	unsigned long time_elapsed, io_trim;
-	u64 bytes_trim;
+	unsigned long time_elapsed;
+	long long bytes_trim;
+	int io_trim;
 
 	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
 
@@ -758,17 +759,21 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 		return;
 
 	bytes_trim = calculate_bytes_allowed(tg_bps_limit(tg, rw),
-					     time_elapsed);
-	io_trim = calculate_io_allowed(tg_iops_limit(tg, rw), time_elapsed);
-	if (!bytes_trim && !io_trim)
+					     time_elapsed) +
+		     tg->carryover_bytes[rw];
+	io_trim = calculate_io_allowed(tg_iops_limit(tg, rw), time_elapsed) +
+		  tg->carryover_ios[rw];
+	if (bytes_trim <= 0 && io_trim <= 0)
 		return;
 
-	if (tg->bytes_disp[rw] >= bytes_trim)
+	tg->carryover_bytes[rw] = 0;
+	if ((long long)tg->bytes_disp[rw] >= bytes_trim)
 		tg->bytes_disp[rw] -= bytes_trim;
 	else
 		tg->bytes_disp[rw] = 0;
 
-	if (tg->io_disp[rw] >= io_trim)
+	tg->carryover_ios[rw] = 0;
+	if ((int)tg->io_disp[rw] >= io_trim)
 		tg->io_disp[rw] -= io_trim;
 	else
 		tg->io_disp[rw] = 0;
-- 
2.39.2

