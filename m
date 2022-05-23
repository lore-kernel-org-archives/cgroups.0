From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v4 4/4] blk-throttle: fix io hung due to config updates
Date: Mon, 23 May 2022 16:26:33 +0800
Message-ID: <20220523082633.2324980-5-yukuai3@huawei.com>
References: <20220523082633.2324980-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220523082633.2324980-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

If new configuration is submitted while a bio is throttled, then new
waiting time is recalculated regardless that the bio might aready wait
for some time:

tg_conf_updated
 throtl_start_new_slice
  tg_update_disptime
  throtl_schedule_next_dispatch

Then io hung can be triggered by always submmiting new configuration
before the throttled bio is dispatched.

Fix the problem by respecting the time that throttled bio aready waited.
In order to do that, add new fields to record how many bytes/io already
waited, and use it to calculate wait time for throttled bio under new
configuration.

Some simple test:
1)
cd /sys/fs/cgroup/blkio/
echo $$ > cgroup.procs
echo "8:0 2048" > blkio.throttle.write_bps_device
{
        sleep 3
        echo "8:0 1024" > blkio.throttle.write_bps_device
} &
sleep 1
dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct

2)
cd /sys/fs/cgroup/blkio/
echo $$ > cgroup.procs
echo "8:0 1024" > blkio.throttle.write_bps_device
{
        sleep 5
        echo "8:0 2048" > blkio.throttle.write_bps_device
} &
sleep 1
dd if=/dev/zero of=/dev/sda bs=8k count=1 oflag=direct

test results: io finish time
	before this patch	with this patch
1)	10s			6s
2)	8s			6s

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 49 ++++++++++++++++++++++++++++++++++++++------
 block/blk-throttle.h |  4 ++++
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ded0d30ef49e..612bd221783c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -656,12 +656,17 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 		   tg->slice_end[rw], jiffies);
 }
 
-static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
+static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw,
+					  bool clear_skipped)
 {
 	tg->bytes_disp[rw] = 0;
 	tg->io_disp[rw] = 0;
 	tg->slice_start[rw] = jiffies;
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
+	if (clear_skipped) {
+		tg->bytes_skipped[rw] = 0;
+		tg->io_skipped[rw] = 0;
+	}
 
 	throtl_log(&tg->service_queue,
 		   "[%c] new slice start=%lu end=%lu jiffies=%lu",
@@ -784,6 +789,34 @@ static u64 calculate_bytes_allowed(u64 bps_limit,
 	return mul_u64_u64_div_u64(bps_limit, (u64)jiffy_elapsed_rnd, (u64)HZ);
 }
 
+static void __tg_update_skipped(struct throtl_grp *tg, bool rw)
+{
+	unsigned long jiffy_elapsed = jiffies - tg->slice_start[rw];
+	u64 bps_limit = tg_bps_limit(tg, rw);
+	u32 iops_limit = tg_iops_limit(tg, rw);
+
+	if (bps_limit != U64_MAX)
+		tg->bytes_skipped[rw] +=
+			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
+			tg->bytes_disp[rw];
+	if (iops_limit != UINT_MAX)
+		tg->io_skipped[rw] +=
+			calculate_io_allowed(iops_limit, jiffy_elapsed) -
+			tg->io_disp[rw];
+}
+
+static void tg_update_skipped(struct throtl_grp *tg)
+{
+	if (tg->service_queue.nr_queued[READ])
+		__tg_update_skipped(tg, READ);
+	if (tg->service_queue.nr_queued[WRITE])
+		__tg_update_skipped(tg, WRITE);
+
+	throtl_log(&tg->service_queue, "%s: %llu %llu %u %u\n", __func__,
+		   tg->bytes_skipped[READ], tg->bytes_skipped[WRITE],
+		   tg->io_skipped[READ], tg->io_skipped[WRITE]);
+}
+
 static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 				  u32 iops_limit, unsigned long *wait)
 {
@@ -801,7 +834,8 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 
 	/* Round up to the next throttle slice, wait time must be nonzero */
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
-	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd);
+	io_allowed = calculate_io_allowed(iops_limit, jiffy_elapsed_rnd) +
+		     tg->io_skipped[rw];
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
 			*wait = 0;
@@ -838,7 +872,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 		jiffy_elapsed_rnd = tg->td->throtl_slice;
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
-	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd);
+	bytes_allowed = calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd) +
+			tg->bytes_skipped[rw];
 	if (tg->bytes_disp[rw] + bio_size <= bytes_allowed) {
 		if (wait)
 			*wait = 0;
@@ -899,7 +934,7 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	 * slice and it should be extended instead.
 	 */
 	if (throtl_slice_used(tg, rw) && !(tg->service_queue.nr_queued[rw]))
-		throtl_start_new_slice(tg, rw);
+		throtl_start_new_slice(tg, rw, true);
 	else {
 		if (time_before(tg->slice_end[rw],
 		    jiffies + tg->td->throtl_slice))
@@ -1328,8 +1363,8 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 	 * that a group's limit are dropped suddenly and we don't want to
 	 * account recently dispatched IO with new low rate.
 	 */
-	throtl_start_new_slice(tg, READ);
-	throtl_start_new_slice(tg, WRITE);
+	throtl_start_new_slice(tg, READ, false);
+	throtl_start_new_slice(tg, WRITE, false);
 
 	if (tg->flags & THROTL_TG_PENDING) {
 		tg_update_disptime(tg);
@@ -1357,6 +1392,7 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 		v = U64_MAX;
 
 	tg = blkg_to_tg(ctx.blkg);
+	tg_update_skipped(tg);
 
 	if (is_u64)
 		*(u64 *)((void *)tg + of_cft(of)->private) = v;
@@ -1543,6 +1579,7 @@ static ssize_t tg_set_limit(struct kernfs_open_file *of,
 		return ret;
 
 	tg = blkg_to_tg(ctx.blkg);
+	tg_update_skipped(tg);
 
 	v[0] = tg->bps_conf[READ][index];
 	v[1] = tg->bps_conf[WRITE][index];
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index c1b602996127..845909c72f86 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -115,6 +115,10 @@ struct throtl_grp {
 	uint64_t bytes_disp[2];
 	/* Number of bio's dispatched in current slice */
 	unsigned int io_disp[2];
+	/* Number of bytes will be skipped in current slice */
+	uint64_t bytes_skipped[2];
+	/* Number of bio's will be skipped in current slice */
+	unsigned int io_skipped[2];
 
 	unsigned long last_low_overflow_time[2];
 
-- 
2.31.1

