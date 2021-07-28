From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v2] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Wed, 28 Jul 2021 17:01:41 +0800
Message-ID: <40915233274d31bb0659ff9f3be8900a5a0e81ba.1627462548.git.brookxu@tencent.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4bqdWbPwSD8rwbkHQdBKMTQMEN6QzdUaiSUT4bqLYMQ=;
        b=mBpE+ddlhyDWoSY5jwg3MaoIXgwFrSGr6qK9qvsa3MSmUvzPv7bKBlmE08+oFkSOo8
         dzeF2PrgktVn8D2JETDKhnhwU8+ownGLOpRBEkrS4LDj09zkoqZ7F9JAAKpGnOXvTLKO
         yjTopeT9+TNx6tlbQGbMqUAtySHIDDF4wkI7tPc71ldSU8hL9x+srxHZTfRMjgiJBHdJ
         wCbAq41Ud6H1dlff0n4/RvqqED1AIYHX/yf7ZLwHn4PC8ucOjT4v5wR05uT8lWbp6qed
         E5kdJjwpI4NzKmlItbDu38n8DYxIkzFMR1IDNmqPy10kviqzn8p/Mjwz0vDQjlEcz1Ae
         0Zcw==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

After patch 54efd50 (block: make generic_make_request handle
arbitrarily sized bios), the IO through io-throttle may be larger,
and these IOs may be further split into more small IOs. However,
IOPS throttle does not seem to be aware of this change, which
makes the calculation of IOPS of large IOs incomplete, resulting
in disk-side IOPS that does not meet expectations. Maybe we should
fix this problem.

We can reproduce it by set max_sectors_kb of disk to 128, set
blkio.write_iops_throttle to 100, run a dd instance inside blkio
and use iostat to watch IOPS:

dd if=/dev/zero of=/dev/sdb bs=1M count=1000 oflag=direct

As a result, without this change the average IOPS is 1995, with
this change the IOPS is 98.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/blk-merge.c    |  2 ++
 block/blk-throttle.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++-----
 block/blk.h          |  2 ++
 3 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index a11b3b5..86ff943 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -348,6 +348,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
 		trace_block_split(split, (*bio)->bi_iter.bi_sector);
 		submit_bio_noacct(*bio);
 		*bio = split;
+
+		blk_throtl_recharge_bio(*bio);
 	}
 }
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b1b22d8..a0daa15 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -178,6 +178,9 @@ struct throtl_grp {
 	unsigned int bad_bio_cnt; /* bios exceeding latency threshold */
 	unsigned long bio_cnt_reset_time;
 
+	atomic_t io_split_cnt[2];
+	atomic_t last_io_split_cnt[2];
+
 	struct blkg_rwstat stat_bytes;
 	struct blkg_rwstat stat_ios;
 };
@@ -293,6 +296,16 @@ static uint64_t throtl_adjusted_limit(uint64_t low, struct throtl_data *td)
 	return low + (low >> 1) * td->scale;
 }
 
+static inline unsigned int tg_io_disp(struct throtl_grp *tg, int rw)
+{
+	return tg->io_disp[rw] + atomic_read(&tg->io_split_cnt[rw]);
+}
+
+static inline unsigned int tg_last_io_disp(struct throtl_grp *tg, int rw)
+{
+	return tg->last_io_disp[rw] + atomic_read(&tg->last_io_split_cnt[rw]);
+}
+
 static uint64_t tg_bps_limit(struct throtl_grp *tg, int rw)
 {
 	struct blkcg_gq *blkg = tg_to_blkg(tg);
@@ -524,6 +537,11 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
 	tg->idletime_threshold = DFL_IDLE_THRESHOLD;
 	tg->idletime_threshold_conf = DFL_IDLE_THRESHOLD;
 
+	atomic_set(&tg->io_split_cnt[0], 0);
+	atomic_set(&tg->io_split_cnt[1], 0);
+	atomic_set(&tg->last_io_split_cnt[0], 0);
+	atomic_set(&tg->last_io_split_cnt[1], 0);
+
 	return &tg->pd;
 
 err_exit_stat_bytes:
@@ -777,6 +795,8 @@ static inline void throtl_start_new_slice_with_credit(struct throtl_grp *tg,
 	tg->bytes_disp[rw] = 0;
 	tg->io_disp[rw] = 0;
 
+	atomic_set(&tg->io_split_cnt[rw], 0);
+
 	/*
 	 * Previous slice has expired. We must have trimmed it after last
 	 * bio dispatch. That means since start of last slice, we never used
@@ -799,6 +819,9 @@ static inline void throtl_start_new_slice(struct throtl_grp *tg, bool rw)
 	tg->io_disp[rw] = 0;
 	tg->slice_start[rw] = jiffies;
 	tg->slice_end[rw] = jiffies + tg->td->throtl_slice;
+
+	atomic_set(&tg->io_split_cnt[rw], 0);
+
 	throtl_log(&tg->service_queue,
 		   "[%c] new slice start=%lu end=%lu jiffies=%lu",
 		   rw == READ ? 'R' : 'W', tg->slice_start[rw],
@@ -877,10 +900,19 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
 	else
 		tg->bytes_disp[rw] = 0;
 
-	if (tg->io_disp[rw] >= io_trim)
+	if (tg_io_disp(tg, rw) >= io_trim) {
+		int cnt = atomic_read(&tg->io_split_cnt[rw]);
+
+		if (cnt) {
+			atomic_set(&tg->io_split_cnt[rw], 0);
+			tg->io_disp[rw] += cnt;
+		}
+
 		tg->io_disp[rw] -= io_trim;
-	else
+	} else {
+		atomic_set(&tg->io_split_cnt[rw], 0);
 		tg->io_disp[rw] = 0;
+	}
 
 	tg->slice_start[rw] += nr_slices * tg->td->throtl_slice;
 
@@ -924,7 +956,7 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	else
 		io_allowed = tmp;
 
-	if (tg->io_disp[rw] + 1 <= io_allowed) {
+	if (tg_io_disp(tg, rw) + 1 <= io_allowed) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -2052,13 +2084,13 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 	}
 
 	if (tg->iops[READ][LIMIT_LOW]) {
-		iops = tg->last_io_disp[READ] * HZ / elapsed_time;
+		iops = tg_last_io_disp(tg, READ) * HZ / elapsed_time;
 		if (iops >= tg->iops[READ][LIMIT_LOW])
 			tg->last_low_overflow_time[READ] = now;
 	}
 
 	if (tg->iops[WRITE][LIMIT_LOW]) {
-		iops = tg->last_io_disp[WRITE] * HZ / elapsed_time;
+		iops = tg_last_io_disp(tg, WRITE) * HZ / elapsed_time;
 		if (iops >= tg->iops[WRITE][LIMIT_LOW])
 			tg->last_low_overflow_time[WRITE] = now;
 	}
@@ -2074,6 +2106,9 @@ static void throtl_downgrade_check(struct throtl_grp *tg)
 	tg->last_bytes_disp[WRITE] = 0;
 	tg->last_io_disp[READ] = 0;
 	tg->last_io_disp[WRITE] = 0;
+
+	atomic_set(&tg->last_io_split_cnt[READ], 0);
+	atomic_set(&tg->last_io_split_cnt[WRITE], 0);
 }
 
 static void blk_throtl_update_idletime(struct throtl_grp *tg)
@@ -2176,6 +2211,25 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
+void blk_throtl_recharge_bio(struct bio *bio)
+{
+	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct throtl_grp *parent = blkg_to_tg(blkg);
+	struct throtl_service_queue *parent_sq;
+	bool rw = bio_data_dir(bio);
+
+	if (!parent->has_rules[rw])
+		return;
+
+	do {
+		atomic_inc(&parent->io_split_cnt[rw]);
+		atomic_inc(&parent->last_io_split_cnt[rw]);
+
+		parent_sq = parent->service_queue.parent_sq;
+		parent = sq_to_tg(parent_sq);
+	} while (parent);
+}
+
 bool blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
@@ -2263,7 +2317,7 @@ bool blk_throtl_bio(struct bio *bio)
 		   rw == READ ? 'R' : 'W',
 		   tg->bytes_disp[rw], bio->bi_iter.bi_size,
 		   tg_bps_limit(tg, rw),
-		   tg->io_disp[rw], tg_iops_limit(tg, rw),
+		   tg_io_disp(tg, rw), tg_iops_limit(tg, rw),
 		   sq->nr_queued[READ], sq->nr_queued[WRITE]);
 
 	tg->last_low_overflow_time[rw] = jiffies;
diff --git a/block/blk.h b/block/blk.h
index 4b885c0..9e925bf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -293,11 +293,13 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern void blk_throtl_register_queue(struct request_queue *q);
+extern void blk_throtl_recharge_bio(struct bio *bio);
 bool blk_throtl_bio(struct bio *bio);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
+static inline void blk_throtl_recharge_bio(struct bio *bio) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
-- 
1.8.3.1

