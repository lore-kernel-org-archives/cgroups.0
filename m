From: Hong Zhiguo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] blk-throttle: simplify logic by token bucket algorithm
Date: Sat, 12 Oct 2013 18:46:34 +0800
Message-ID: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=pKQmphIxYX/2nFy0I4cZ9MEHKYq/sHiZz9NCQv5Px8o=;
        b=dpRTk3sU0/a525JuoyU4RjTxFrULKTbNZZRn94EyoVjyIlSCRcGRWW+WeVPGIvHE8b
         pIj7d6pKuDCifQNPs5yYtgppUglEro7ZRYrTR19dnPwooUlqdQLc83yM/9dG7H0cYrBO
         2lf12dtod15RYLG0RqLKaKRqbVYH3y/4g1Hw6PrTLroVg5+Iv5jBssbXUQlqXCY20kXJ
         6y5r6xlRphVceCCzup2kGa6q7QC9h7Ls4xV3Q54MOc3WScHNtMZvyCM1EfXqBTf9d1MV
         1gaQHfZUTMrd1Lbmsj1y2vh3lKM0DzoDOH2Ha0h9oV3x88KrljsG4MVy4wWZuqAsdpdi
         HVYA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Token bucket algorithm(http://en.wikipedia.org/wiki/Token_bucket)
is very simple and widely used for rate limiting and shaping.
It's well suitable for blk-throttle. And it natually works for
hierarchical cgroups without any special treatment.

So I took it to replace the original time slicing|trimming|extending
logic. After that, about 200 lines of code is reduced from
blk-throttle.c.

I've tested this patch by fio with rw=randread, rw=randrw. It
behaves almost the same with original blk-throttle implementation.

Signed-off-by: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Tested-by: Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-throttle.c | 284 ++++++++-------------------------------------------
 1 file changed, 43 insertions(+), 241 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 8331aba..a92b00f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -18,9 +18,6 @@ static int throtl_grp_quantum = 8;
 /* Total max dispatch from all groups in one round */
 static int throtl_quantum = 32;
 
-/* Throttling is performed over 100ms slice and after that slice is renewed */
-static unsigned long throtl_slice = HZ/10;	/* 100 ms */
-
 static struct blkcg_policy blkcg_policy_throtl;
 
 /* A workqueue to queue throttle related work */
@@ -91,6 +88,11 @@ struct tg_stats_cpu {
 	struct blkg_rwstat		serviced;
 };
 
+/* Depth of iops token bucket */
+#define THROTL_BURST_IO 8
+/* Depth of bps token bucket */
+#define THROTL_BURST_BYTES (4096 << 8)
+
 struct throtl_grp {
 	/* must be the first member */
 	struct blkg_policy_data pd;
@@ -133,14 +135,13 @@ struct throtl_grp {
 	/* IOPS limits */
 	unsigned int iops[2];
 
-	/* Number of bytes disptached in current slice */
-	uint64_t bytes_disp[2];
-	/* Number of bio's dispatched in current slice */
-	unsigned int io_disp[2];
+	/* Token for throttling by bps */
+	uint64_t bytes_token[2];
+	/* Token for throttling by iops */
+	unsigned int io_token[2];
 
-	/* When did we start a new slice */
-	unsigned long slice_start[2];
-	unsigned long slice_end[2];
+	/* Time check-point */
+	unsigned long t_c[2];
 
 	/* Per cpu stats pointer */
 	struct tg_stats_cpu __percpu *stats_cpu;
@@ -680,171 +681,26 @@ static bool throtl_schedule_next_dispatch(struct throtl_service_queue *sq,
 	return false;
 }
 
-static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
-		bool rw, unsigned long start)
-{
-	tg->bytes_disp[rw] = 0;
-	tg->io_disp[rw] = 0;
-
-	/*
-	 * Previous slice has expired. We must have trimmed it after last
-	 * bio dispatch. That means since start of last slice, we never used
-	 * that bandwidth. Do try to make use of that bandwidth while giving
-	 * credit.
-	 */
-	if (time_after_eq(start, tg->slice_start[rw]))
-		tg->slice_start[rw] = start;
-
-	tg->slice_end[rw] = jiffies + throtl_slice;
-	throtl_log(&tg->service_queue,
-		   "[%c] new slice with credit start=%lu end=%lu jiffies=%lu",
-		   rw == READ ? 'R' : 'W', tg->slice_start[rw],
-		   tg->slice_end[rw], jiffies);
-}
-
-static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
-{
-	tg->bytes_disp[rw] = 0;
-	tg->io_disp[rw] = 0;
-	tg->slice_start[rw] = jiffies;
-	tg->slice_end[rw] = jiffies + throtl_slice;
-	throtl_log(&tg->service_queue,
-		   "[%c] new slice start=%lu end=%lu jiffies=%lu",
-		   rw == READ ? 'R' : 'W', tg->slice_start[rw],
-		   tg->slice_end[rw], jiffies);
-}
-
-static inline void throtl_set_slice_end(struct throtl_grp *tg, bool rw,
-					unsigned long jiffy_end)
-{
-	tg->slice_end[rw] = roundup(jiffy_end, throtl_slice);
-}
-
-static inline void throtl_extend_slice(struct throtl_grp *tg, bool rw,
-				       unsigned long jiffy_end)
-{
-	tg->slice_end[rw] = roundup(jiffy_end, throtl_slice);
-	throtl_log(&tg->service_queue,
-		   "[%c] extend slice start=%lu end=%lu jiffies=%lu",
-		   rw == READ ? 'R' : 'W', tg->slice_start[rw],
-		   tg->slice_end[rw], jiffies);
-}
-
-/* Determine if previously allocated or extended slice is complete or not */
-static bool throtl_slice_used(struct throtl_grp *tg, bool rw)
-{
-	if (time_in_range(jiffies, tg->slice_start[rw], tg->slice_end[rw]))
-		return 0;
-
-	return 1;
-}
-
-/* Trim the used slices and adjust slice start accordingly */
-static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
-{
-	unsigned long nr_slices, time_elapsed, io_trim;
-	u64 bytes_trim, tmp;
-
-	BUG_ON(time_before(tg->slice_end[rw], tg->slice_start[rw]));
-
-	/*
-	 * If bps are unlimited (-1), then time slice don't get
-	 * renewed. Don't try to trim the slice if slice is used. A new
-	 * slice will start when appropriate.
-	 */
-	if (throtl_slice_used(tg, rw))
-		return;
-
-	/*
-	 * A bio has been dispatched. Also adjust slice_end. It might happen
-	 * that initially cgroup limit was very low resulting in high
-	 * slice_end, but later limit was bumped up and bio was dispached
-	 * sooner, then we need to reduce slice_end. A high bogus slice_end
-	 * is bad because it does not allow new slice to start.
-	 */
-
-	throtl_set_slice_end(tg, rw, jiffies + throtl_slice);
-
-	time_elapsed = jiffies - tg->slice_start[rw];
-
-	nr_slices = time_elapsed / throtl_slice;
-
-	if (!nr_slices)
-		return;
-	tmp = tg->bps[rw] * throtl_slice * nr_slices;
-	do_div(tmp, HZ);
-	bytes_trim = tmp;
-
-	io_trim = (tg->iops[rw] * throtl_slice * nr_slices)/HZ;
-
-	if (!bytes_trim && !io_trim)
-		return;
-
-	if (tg->bytes_disp[rw] >= bytes_trim)
-		tg->bytes_disp[rw] -= bytes_trim;
-	else
-		tg->bytes_disp[rw] = 0;
-
-	if (tg->io_disp[rw] >= io_trim)
-		tg->io_disp[rw] -= io_trim;
-	else
-		tg->io_disp[rw] = 0;
-
-	tg->slice_start[rw] += nr_slices * throtl_slice;
-
-	throtl_log(&tg->service_queue,
-		   "[%c] trim slice nr=%lu bytes=%llu io=%lu start=%lu end=%lu jiffies=%lu",
-		   rw == READ ? 'R' : 'W', nr_slices, bytes_trim, io_trim,
-		   tg->slice_start[rw], tg->slice_end[rw], jiffies);
-}
-
 static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 				  unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	unsigned int io_allowed;
-	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
-	u64 tmp;
-
-	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
-
-	/* Slice has just started. Consider one slice interval */
-	if (!jiffy_elapsed)
-		jiffy_elapsed_rnd = throtl_slice;
-
-	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
+	u64 token;
 
-	/*
-	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be
-	 * 1 then at max jiffy elapsed should be equivalent of 1 second as we
-	 * will allow dispatch after 1 second and after that slice should
-	 * have been trimmed.
-	 */
-
-	tmp = (u64)tg->iops[rw] * jiffy_elapsed_rnd;
-	do_div(tmp, HZ);
+	token = (u64)tg->iops[rw] * (jiffies - tg->t_c[rw]);
+	do_div(token, HZ);
+	token += tg->io_token[rw];
 
-	if (tmp > UINT_MAX)
-		io_allowed = UINT_MAX;
-	else
-		io_allowed = tmp;
-
-	if (tg->io_disp[rw] + 1 <= io_allowed) {
+	if (token) {
+		tg->io_token[rw] = token;
 		if (wait)
 			*wait = 0;
 		return 1;
 	}
 
 	/* Calc approx time to dispatch */
-	jiffy_wait = ((tg->io_disp[rw] + 1) * HZ)/tg->iops[rw] + 1;
-
-	if (jiffy_wait > jiffy_elapsed)
-		jiffy_wait = jiffy_wait - jiffy_elapsed;
-	else
-		jiffy_wait = 1;
-
 	if (wait)
-		*wait = jiffy_wait;
+		*wait = HZ / tg->iops[rw] ?: 1;
 	return 0;
 }
 
@@ -852,41 +708,26 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 				 unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
-	u64 bytes_allowed, extra_bytes, tmp;
-	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
-
-	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
-
-	/* Slice has just started. Consider one slice interval */
-	if (!jiffy_elapsed)
-		jiffy_elapsed_rnd = throtl_slice;
-
-	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
+	u64 extra_bytes, token;
+	unsigned long jiffy_wait;
 
-	tmp = tg->bps[rw] * jiffy_elapsed_rnd;
-	do_div(tmp, HZ);
-	bytes_allowed = tmp;
+	token = (u64)tg->bps[rw] * (jiffies - tg->t_c[rw]);
+	do_div(token, HZ);
+	token += tg->bytes_token[rw];
 
-	if (tg->bytes_disp[rw] + bio->bi_size <= bytes_allowed) {
+	if (bio->bi_size <= token) {
+		tg->bytes_token[rw] = token;
 		if (wait)
 			*wait = 0;
 		return 1;
 	}
 
 	/* Calc approx time to dispatch */
-	extra_bytes = tg->bytes_disp[rw] + bio->bi_size - bytes_allowed;
-	jiffy_wait = div64_u64(extra_bytes * HZ, tg->bps[rw]);
-
-	if (!jiffy_wait)
-		jiffy_wait = 1;
-
-	/*
-	 * This wait time is without taking into consideration the rounding
-	 * up we did. Add that time also.
-	 */
-	jiffy_wait = jiffy_wait + (jiffy_elapsed_rnd - jiffy_elapsed);
-	if (wait)
-		*wait = jiffy_wait;
+	if (wait) {
+		extra_bytes = bio->bi_size - token;
+		jiffy_wait = div64_u64(extra_bytes * HZ, tg->bps[rw]);
+		*wait = jiffy_wait ?: 1;
+	}
 	return 0;
 }
 
@@ -916,18 +757,6 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 		return 1;
 	}
 
-	/*
-	 * If previous slice expired, start a new one otherwise renew/extend
-	 * existing slice to make sure it is at least throtl_slice interval
-	 * long since now.
-	 */
-	if (throtl_slice_used(tg, rw))
-		throtl_start_new_slice(tg, rw);
-	else {
-		if (time_before(tg->slice_end[rw], jiffies + throtl_slice))
-			throtl_extend_slice(tg, rw, jiffies + throtl_slice);
-	}
-
 	if (tg_with_in_bps_limit(tg, bio, &bps_wait) &&
 	    tg_with_in_iops_limit(tg, bio, &iops_wait)) {
 		if (wait)
@@ -940,9 +769,6 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	if (wait)
 		*wait = max_wait;
 
-	if (time_before(tg->slice_end[rw], jiffies + max_wait))
-		throtl_extend_slice(tg, rw, jiffies + max_wait);
-
 	return 0;
 }
 
@@ -976,10 +802,16 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
 
-	/* Charge the bio to the group */
-	tg->bytes_disp[rw] += bio->bi_size;
-	tg->io_disp[rw]++;
+	/* Charge the bio to the group and trim the bucket */
+	tg->bytes_token[rw] -= bio->bi_size;
+	if (tg->bytes_token[rw] > THROTL_BURST_BYTES)
+		tg->bytes_token[rw] = THROTL_BURST_BYTES;
 
+	tg->io_token[rw]--;
+	if (tg->io_token[rw] > THROTL_BURST_IO)
+		tg->io_token[rw] = THROTL_BURST_IO;
+
+	tg->t_c[rw] = jiffies;
 	/*
 	 * REQ_THROTTLED is used to prevent the same bio to be throttled
 	 * more than once as a throttled bio will go through blk-throtl the
@@ -1055,16 +887,6 @@ static void tg_update_disptime(struct throtl_grp *tg)
 	tg->flags &= ~THROTL_TG_WAS_EMPTY;
 }
 
-static void start_parent_slice_with_credit(struct throtl_grp *child_tg,
-					struct throtl_grp *parent_tg, bool rw)
-{
-	if (throtl_slice_used(parent_tg, rw)) {
-		throtl_start_new_slice_with_credit(parent_tg, rw,
-				child_tg->slice_start[rw]);
-	}
-
-}
-
 static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
@@ -1093,7 +915,6 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 	 */
 	if (parent_tg) {
 		throtl_add_bio_tg(bio, &tg->qnode_on_parent[rw], parent_tg);
-		start_parent_slice_with_credit(tg, parent_tg, rw);
 	} else {
 		throtl_qnode_add_bio(bio, &tg->qnode_on_parent[rw],
 				     &parent_sq->queued[rw]);
@@ -1101,8 +922,6 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 		tg->td->nr_queued[rw]--;
 	}
 
-	throtl_trim_slice(tg, rw);
-
 	if (tg_to_put)
 		blkg_put(tg_to_blkg(tg_to_put));
 }
@@ -1386,12 +1205,8 @@ static int tg_set_conf(struct cgroup_subsys_state *css, struct cftype *cft,
 	 * We're already holding queue_lock and know @tg is valid.  Let's
 	 * apply the new config directly.
 	 *
-	 * Restart the slices for both READ and WRITES. It might happen
-	 * that a group's limit are dropped suddenly and we don't want to
-	 * account recently dispatched IO with new low rate.
+	 * Update dispatch time.
 	 */
-	throtl_start_new_slice(tg, 0);
-	throtl_start_new_slice(tg, 1);
 
 	if (tg->flags & THROTL_TG_PENDING) {
 		tg_update_disptime(tg);
@@ -1527,19 +1342,6 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		throtl_charge_bio(tg, bio);
 
 		/*
-		 * We need to trim slice even when bios are not being queued
-		 * otherwise it might happen that a bio is not queued for
-		 * a long time and slice keeps on extending and trim is not
-		 * called for a long time. Now if limits are reduced suddenly
-		 * we take into account all the IO dispatched so far at new
-		 * low rate and * newly queued IO gets a really long dispatch
-		 * time.
-		 *
-		 * So keep on trimming slice even if bio is not queued.
-		 */
-		throtl_trim_slice(tg, rw);
-
-		/*
 		 * @bio passed through this layer without being throttled.
 		 * Climb up the ladder.  If we''re already at the top, it
 		 * can be executed directly.
@@ -1552,10 +1354,10 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	}
 
 	/* out-of-limit, queue to @tg */
-	throtl_log(sq, "[%c] bio. bdisp=%llu sz=%u bps=%llu iodisp=%u iops=%u queued=%d/%d",
+	throtl_log(sq, "[%c] bio. btk=%llu sz=%u bps=%llu iotk=%u iops=%u queued=%d/%d",
 		   rw == READ ? 'R' : 'W',
-		   tg->bytes_disp[rw], bio->bi_size, tg->bps[rw],
-		   tg->io_disp[rw], tg->iops[rw],
+		   tg->bytes_token[rw], bio->bi_size, tg->bps[rw],
+		   tg->io_token[rw], tg->iops[rw],
 		   sq->nr_queued[READ], sq->nr_queued[WRITE]);
 
 	bio_associate_current(bio);
-- 
1.8.1.2
