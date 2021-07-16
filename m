From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Fri, 16 Jul 2021 14:22:49 +0800
Message-ID: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qBZgZ1rhUXrPQtQ1RtY6PTOQRojpxXbKtuLlXE/iYow=;
        b=A/AiFzqwhhU2cqITL0fNNzFEVtilgMAATbE5B4mhB06UhLd8ASAZbVW+cCA5x+njML
         mCrfkD7e0dh6+yS5L/ixigSwXXPXCuldq6rRWO74AJ5gB1o26IYkBRWe682enIAeJ46S
         7+LKvk7nouKC8MXNXbtKyqg8oej/p0TetmNNllY21dpbT6qttnJ9mMjmyUYu57vG/qFH
         ro7Ul8bza2FdizqbcY7jc1BOVIK6gznJCZ/SFD3VtjIaYlHBFAJqy/WcdF5TqDOCJ1TP
         +8oGL4ZPGdUzH2NS79oIkap3bZVUJK9PZaaqfBN1nk51EtZG/9Vn2b5IYXzYBfkmXpsQ
         FWfA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

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
 block/blk-throttle.c | 34 ++++++++++++++++++++++++++++++++++
 block/blk.h          |  2 ++
 3 files changed, 38 insertions(+)

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
index b1b22d8..1967438 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2176,6 +2176,40 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
 }
 #endif
 
+void blk_throtl_recharge_bio(struct bio *bio)
+{
+	bool rw = bio_data_dir(bio);
+	struct blkcg_gq *blkg = bio->bi_blkg;
+	struct throtl_grp *tg = blkg_to_tg(blkg);
+	u32 iops_limit = tg_iops_limit(tg, rw);
+
+	if (iops_limit == UINT_MAX)
+		return;
+
+	/*
+	 * If previous slice expired, start a new one otherwise renew/extend
+	 * existing slice to make sure it is at least throtl_slice interval
+	 * long since now. New slice is started only for empty throttle group.
+	 * If there is queued bio, that means there should be an active
+	 * slice and it should be extended instead.
+	 */
+	if (throtl_slice_used(tg, rw) && !(tg->service_queue.nr_queued[rw]))
+		throtl_start_new_slice(tg, rw);
+	else {
+		if (time_before(tg->slice_end[rw],
+		    jiffies + tg->td->throtl_slice))
+			throtl_extend_slice(tg, rw,
+				jiffies + tg->td->throtl_slice);
+	}
+
+	/* Recharge the bio to the group, as some BIOs will be further split
+	 * after passing through the throttle, causing the actual IOPS to
+	 * be greater than the expected value.
+	 */
+	tg->last_io_disp[rw]++;
+	tg->io_disp[rw]++;
+}
+
 bool blk_throtl_bio(struct bio *bio)
 {
 	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
diff --git a/block/blk.h b/block/blk.h
index 4b885c0..067634a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -293,12 +293,14 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 extern int blk_throtl_init(struct request_queue *q);
 extern void blk_throtl_exit(struct request_queue *q);
 extern void blk_throtl_register_queue(struct request_queue *q);
+extern void blk_throtl_recharge_bio(struct bio *bio);
 bool blk_throtl_bio(struct bio *bio);
 #else /* CONFIG_BLK_DEV_THROTTLING */
 static inline int blk_throtl_init(struct request_queue *q) { return 0; }
 static inline void blk_throtl_exit(struct request_queue *q) { }
 static inline void blk_throtl_register_queue(struct request_queue *q) { }
 static inline bool blk_throtl_bio(struct bio *bio) { return false; }
+static inline void blk_throtl_recharge_bio(struct bio *bio) { }
 #endif /* CONFIG_BLK_DEV_THROTTLING */
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 extern ssize_t blk_throtl_sample_time_show(struct request_queue *q, char *page);
-- 
1.8.3.1

