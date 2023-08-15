From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next 3/4] blk-throttle: use calculate_io/bytes_allowed() for throtl_trim_slice()
Date: Tue, 15 Aug 2023 09:41:22 +0800
Message-ID: <20230815014123.368929-4-yukuai1@huaweicloud.com>
References: <20230815014123.368929-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230815014123.368929-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

There are no functional changes, just make the code cleaner.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 81 +++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 43 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7c93144d03da..e5296960c799 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -697,11 +697,40 @@ static bool throtl_slice_used(struct throtl_grp *tg, bool rw)
 	return true;
 }
 
+static unsigned int calculate_io_allowed(u32 iops_limit,
+					 unsigned long jiffy_elapsed)
+{
+	unsigned int io_allowed;
+	u64 tmp;
+
+	/*
+	 * jiffy_elapsed should not be a big value as minimum iops can be
+	 * 1 then at max jiffy elapsed should be equivalent of 1 second as we
+	 * will allow dispatch after 1 second and after that slice should
+	 * have been trimmed.
+	 */
+
+	tmp = (u64)iops_limit * jiffy_elapsed;
+	do_div(tmp, HZ);
+
+	if (tmp > UINT_MAX)
+		io_allowed = UINT_MAX;
+	else
+		io_allowed = tmp;
+
+	return io_allowed;
+}
+
+static u64 calculate_bytes_allowed(u64 bps_limit, unsigned long jiffy_elapsed)
+{
+	return mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed, (u64)HZ);
+}
+
 /* Trim the used slices and adjust slice start accordingly */
 static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 {
-	unsigned long nr_slices, time_elapsed, io_trim;
-	u64 bytes_trim, tmp;
+	unsigned long time_elapsed, io_trim;
+	u64 bytes_trim;
 
 	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
 
@@ -723,19 +752,14 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 
 	throtl_set_slice_end(tg, rw, jiffies + tg->td->throtl_slice);
 
-	time_elapsed = jiffies - tg->slice_start[rw];
-
-	nr_slices = time_elapsed / tg->td->throtl_slice;
-
-	if (!nr_slices)
+	time_elapsed = rounddown(jiffies - tg->slice_start[rw],
+				 tg->td->throtl_slice);
+	if (!time_elapsed)
 		return;
-	tmp = tg_bps_limit(tg, rw) * tg->td->throtl_slice * nr_slices;
-	do_div(tmp, HZ);
-	bytes_trim = tmp;
-
-	io_trim = (tg_iops_limit(tg, rw) * tg->td->throtl_slice * nr_slices) /
-		HZ;
 
+	bytes_trim = calculate_bytes_allowed(tg_bps_limit(tg, rw),
+					     time_elapsed);
+	io_trim = calculate_io_allowed(tg_iops_limit(tg, rw), time_elapsed);
 	if (!bytes_trim && !io_trim)
 		return;
 
@@ -749,7 +773,7 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 	else
 		tg->io_disp[rw] = 0;
 
-	tg->slice_start[rw] += nr_slices * tg->td->throtl_slice;
+	tg->slice_start[rw] += time_elapsed;
 
 	throtl_log(&tg->service_queue,
 		   "[%c] trim slice nr=%lu bytes=%llu io=%lu start=%lu end=%lu jiffies=%lu",
@@ -757,35 +781,6 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 		   tg->slice_start[rw], tg->slice_end[rw], jiffies);
 }
 
-static unsigned int calculate_io_allowed(u32 iops_limit,
-					 unsigned long jiffy_elapsed)
-{
-	unsigned int io_allowed;
-	u64 tmp;
-
-	/*
-	 * jiffy_elapsed should not be a big value as minimum iops can be
-	 * 1 then at max jiffy elapsed should be equivalent of 1 second as we
-	 * will allow dispatch after 1 second and after that slice should
-	 * have been trimmed.
-	 */
-
-	tmp = (u64)iops_limit * jiffy_elapsed;
-	do_div(tmp, HZ);
-
-	if (tmp > UINT_MAX)
-		io_allowed = UINT_MAX;
-	else
-		io_allowed = tmp;
-
-	return io_allowed;
-}
-
-static u64 calculate_bytes_allowed(u64 bps_limit, unsigned long jiffy_elapsed)
-{
-	return mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed, (u64)HZ);
-}
-
 static void __tg_update_carryover(struct throtl_grp *tg, bool rw)
 {
 	unsigned long jiffy_elapsed = jiffies - tg->slice_start[rw];
-- 
2.39.2

