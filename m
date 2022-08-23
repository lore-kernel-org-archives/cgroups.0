From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v8 4/4] blk-throttle: fix io hung due to configuration updates
Date: Tue, 23 Aug 2022 11:31:30 +0800
Message-ID: <20220823033130.874230-5-yukuai1@huaweicloud.com>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220823033130.874230-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

If new configuration is submitted while a bio is throttled, then new
waiting time is recalculated regardless that the bio might already wait
for some time:

tg_conf_updated
 throtl_start_new_slice
  tg_update_disptime
  throtl_schedule_next_dispatch

Then io hung can be triggered by always submmiting new configuration
before the throttled bio is dispatched.

Fix the problem by respecting the time that throttled bio already waited.
In order to do that, add new fields to record how many bytes/io are
waited, and use it to calculate wait time for throttled bio under new
configuration.

Some simple test:
1)
cd /sys/fs/cgroup/blkio/
echo $$ > cgroup.procs
echo "8:0 2048" > blkio.throttle.write_bps_device
{
        sleep 2
        echo "8:0 1024" > blkio.throttle.write_bps_device
} &
dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct

2)
cd /sys/fs/cgroup/blkio/
echo $$ > cgroup.procs
echo "8:0 1024" > blkio.throttle.write_bps_device
{
        sleep 4
        echo "8:0 2048" > blkio.throttle.write_bps_device
} &
dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct

test results: io finish time
	before this patch	with this patch
1)	10s			6s
2)	8s			6s

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 58 +++++++++++++++++++++++++++++++++++++++-----
 block/blk-throttle.h |  9 +++++++
 2 files changed, 61 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 757b620f0f2d..679e08c0714c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -639,6 +639,8 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 {
 	tg->bytes_disp[rw] = 0;
 	tg->io_disp[rw] = 0;
+	tg->carryover_bytes[rw] = 0;
+	tg->carryover_ios[rw] = 0;
 
 	/*
 	 * Previous slice has expired. We must have trimmed it after last
@@ -656,12 +658,17 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 		   tg->slice_end[rw], jiffies);
 }
 
-static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
+static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw,
+					  bool clear_carryover)
 {
 	tg->bytes_disp[rw] = 0;
 	tg->io_disp[rw] = 0;
 	tg->slice_start[rw] = jiffies;
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
+	if (clear_carryover) {
+		tg->carryover_bytes[rw] = 0;
+		tg->carryover_ios[rw] = 0;
+	}
 
 	throtl_log(&tg->service_queue,
 		   "[%c] new slice start=%lu end=%lu jiffies=%lu",
@@ -783,6 +790,41 @@ static u64 calculate_bytes_allowed(u64 bps_limit, unsigned long jiffy_elapsed)
 	return mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed, (u64)HZ);
 }
 
+static void __tg_update_carryover(struct throtl_grp *tg, bool rw)
+{
+	unsigned long jiffy_elapsed = jiffies - tg->slice_start[rw];
+	u64 bps_limit = tg_bps_limit(tg, rw);
+	u32 iops_limit = tg_iops_limit(tg, rw);
+
+	/*
+	 * If config is updated while bios are still throttled, calculate and
+	 * accumulate how many bytes/ios are waited across changes. And
+	 * carryover_bytes/ios will be used to calculate new wait time under new
+	 * configuration.
+	 */
+	if (bps_limit != U64_MAX)
+		tg->carryover_bytes[rw] +=
+			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
+			tg->bytes_disp[rw];
+	if (iops_limit != UINT_MAX)
+		tg->carryover_ios[rw] +=
+			calculate_io_allowed(iops_limit, jiffy_elapsed) -
+			tg->io_disp[rw];
+}
+
+static void tg_update_carryover(struct throtl_grp *tg)
+{
+	if (tg->service_queue.nr_queued[READ])
+		__tg_update_carryover(tg, READ);
+	if (tg->service_queue.nr_queued[WRITE])
+		__tg_update_carryover(tg, WRITE);
+
+	/* see comments in struct throtl_grp for meaning of these fields. */
+	throtl_log(&tg->service_queue, "%s: %llu %llu %u %u\n", __func__,
+		   tg->carryover_bytes[READ], tg->carryover_bytes[WRITE],
+		   tg->carryover_ios[READ], tg->carryover_ios[WRITE]);
+}
+
 static bool tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio,
 				 u32 iops_limit, unsigned long *wait)
 {
@@ -800,7 +842,8 @@ static bool tg_within_iops_limit(struct throtl_grp *tg, struct bio *bio,
 
 	/* Round up to the next throttle slice, wait time must be nonzero */
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
-	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd);
+	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd) +
+		     tg->carryover_ios[rw];
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
 			*wait = 0;
@@ -837,7 +880,8 @@ static bool tg_within_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd);
+	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd) +
+			tg->carryover_bytes[rw];
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
 			*wait = 0;
@@ -898,7 +942,7 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	 * slice and it should be extended instead.
 	 */
 	if (throtl_slice_used(tg, rw) && !(tg->service_queue.nr_queued[rw]))
-		throtl_start_new_slice(tg, rw);
+		throtl_start_new_slice(tg, rw, true);
 	else {
 		if (time_before(tg->slice_end[rw],
 		    jiffies + tg->td->throtl_slice))
@@ -1332,8 +1376,8 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 	 * that a group's limit are dropped suddenly and we don't want to
 	 * account recently dispatched IO with new low rate.
 	 */
-	throtl_start_new_slice(tg, READ);
-	throtl_start_new_slice(tg, WRITE);
+	throtl_start_new_slice(tg, READ, false);
+	throtl_start_new_slice(tg, WRITE, false);
 
 	if (tg->flags & THROTL_TG_PENDING) {
 		tg_update_disptime(tg);
@@ -1361,6 +1405,7 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 		v = U64_MAX;
 
 	tg = blkg_to_tg(ctx.blkg);
+	tg_update_carryover(tg);
 
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
@@ -1547,6 +1592,7 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 		return ret;
 
 	tg = blkg_to_tg(ctx.blkg);
+	tg_update_carryover(tg);
 
 	v[0] = tg->bps_conf[READ][index];
 	v[1] = tg->bps_conf[WRITE][index];
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index 45c6f3c1dfe0..a25e9e356d17 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -121,6 +121,15 @@ struct throtl_grp {
 	uint64_t last_bytes_disp[2];
 	unsigned int last_io_disp[2];
 
+	/*
+	 * The following two fields are updated when new configuration is
+	 * submitted while some bios are still throttled, they record how many
+	 * bytes/ios are waited already in previous configuration, and they will
+	 * be used to calculate wait time under new configuration.
+	 */
+	uint64_t carryover_bytes[2];
+	unsigned int carryover_ios[2];
+
 	unsigned long last_check_time;
 
 	unsigned long latency_target; /* us */
-- 
2.31.1

