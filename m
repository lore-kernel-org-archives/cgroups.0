From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Tue, 20 Jul 2021 00:35:54 +0800
Message-ID: <957ab14d-c4bc-32f0-3f7d-af98832ab955@gmail.com>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4kEVl6RJazubuVOQxY7IzYyGCt4KpCBPiq4YuJI+gH0=;
        b=oeV8OB0zNpfctE1iyccIC6jgn//DX4QmA9LN0GC6Rqa+8zpdljbixJg3iW+45USJZD
         r/Wz5KpcKpEJeTLhJkPS5THvVX7y5LQnTpruroAi/sylF+DE9Vj3qPSzyxwW8Lp5Bppb
         KhBG20IIpg6LMd/j75wOvB3fEYic1otHQOnwWNORRkATtnMNVQzNk/iDkWUMDTdU9V1D
         1ePAs6vJ0Ugaa11j5DF+1+FOZD1KNuqS0JW+TliD24dbD17cQI0Q84Bk4TaqWfayGlvU
         62Tval56Sxu+q3kMMzqsAKHMGov7Tvl0liYj3LALyteXbsIhddyq/mdHpGXo+HGQEdYW
         6NYw==
In-Reply-To: <YPGvIzZUI+QxP1js-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun:

In order to avoid code duplication and IOPS stability problems caused by estimating
the equivalent number of IOs, and to avoid potential deadlock problems caused by
synchronization through queue_lock. I tried to count the number of splited IOs in
the current window through two atomic counters. Add the value of the atomic variable
when calculating io_disp[rw], which can also avoid the problem of inaccurate IOPS in
large IO scenarios. How do you think of this approach? Thanks for your time.

The following are related changes. If that is ok, I will send the v2 version later.

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


