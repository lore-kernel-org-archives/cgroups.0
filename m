From: Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] block: Add helper for queue_flags bit test
Date: Tue, 11 Oct 2022 22:52:45 +0800
Message-ID: <TYCP286MB232392B1D23662DE81B0D2D5CA239@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
References: <20221011145246.8656-1-set_pte_at@outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbcrVk0ED9SXOg7VP3kEUS/OTui3qy3ZuXxjnkU6Yxg=;
 b=HV23m9anfunJO0q1ZiQQgUJtdFY5aLPINhpy1UbB51E2x+O1bDM/Wg+UD/BieCWe4pPEsdoQljXr3PxC7f27pEru+oFcQF/I5ogrvOq88e8fDAE9dMiZ50TMbos//jDqF/NQrN2zvdHz72CnuVnG9Rj1q0XCr4fQ0HwYSDgdsG6laURuU66pzxArAGk5MBZPZzgQAhnrs68wcIW8kzp7tVzYKlHc0SiU7X2eisZh7xYygsg7uqvpKQL+yQacPYkmC8io6US/P3Dn1Nwt5bFCYx2nMmwUVRH4he4FVpC/7R8rpOCVPvekD/m13eKO3BG7q6lLlJiTUh6YuUJ9rl46EA==
In-Reply-To: <20221011145246.8656-1-set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>

queue_flags is a flag mask representing all possible attributes
of request queue, just like flags of struct page. In analog to
implementation of PageFoo(), it's possible to abstract helpers
denoting whether or not certain attribute is set for a request
queue (actually there are some of them implemented already).

Signed-off-by: Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
---
 block/blk-core.c       |  7 +++----
 block/blk-mq-tag.c     |  8 ++++----
 block/blk-mq.c         |  8 +++-----
 block/blk-mq.h         |  2 +-
 block/blk-settings.c   |  2 +-
 block/blk-sysfs.c      | 12 ++++++------
 block/blk-timeout.c    |  2 +-
 block/blk-wbt.c        |  2 +-
 include/linux/blkdev.h | 19 ++++++++++++++-----
 9 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4bfc0d504b2d..032556de327b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -731,7 +731,7 @@ void submit_bio_noacct(struct bio *bio)
 	 * support don't have to worry about them.
 	 */
 	if (op_is_flush(bio->bi_opf) &&
-	    !test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
+		!blk_queue_wb_cached(q)) {
 		bio->bi_opf &= ~(REQ_PREFLUSH | REQ_FUA);
 		if (!bio_sectors(bio)) {
 			status = BLK_STS_OK;
@@ -739,7 +739,7 @@ void submit_bio_noacct(struct bio *bio)
 		}
 	}
 
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_queue_poll(q))
 		bio_clear_polled(bio);
 
 	switch (bio_op(bio)) {
@@ -846,8 +846,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
 	int ret = 0;
 
-	if (cookie == BLK_QC_T_NONE ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (cookie == BLK_QC_T_NONE || !blk_queue_poll(q))
 		return 0;
 
 	/*
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 9eb968e14d31..0157bb3fcd91 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -44,13 +44,13 @@ void __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
 	if (blk_mq_is_shared_tags(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
 
-		if (test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
+		if (test_and_set_bit(QUEUE_FLAG_HCTX_ACTIVE,
+				     &q->queue_flags))
 			return;
-		set_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags);
 	} else {
-		if (test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
+		if (test_and_set_bit(BLK_MQ_S_TAG_ACTIVE,
+				     &hctx->state))
 			return;
-		set_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state);
 	}
 
 	users = atomic_inc_return(&hctx->tags->active_queues);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9dd3ec42613f..6016fdea518f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1042,8 +1042,7 @@ static inline bool blk_mq_complete_need_ipi(struct request *rq)
 {
 	int cpu = raw_smp_processor_id();
 
-	if (!IS_ENABLED(CONFIG_SMP) ||
-	    !test_bit(QUEUE_FLAG_SAME_COMP, &rq->q->queue_flags))
+	if (!IS_ENABLED(CONFIG_SMP) || !blk_queue_same_comp(rq->q))
 		return false;
 	/*
 	 * With force threaded interrupts enabled, raising softirq from an SMP
@@ -1055,8 +1054,7 @@ static inline bool blk_mq_complete_need_ipi(struct request *rq)
 		return false;
 
 	/* same CPU or cache domain?  Complete locally */
-	if (cpu == rq->mq_ctx->cpu ||
-	    (!test_bit(QUEUE_FLAG_SAME_FORCE, &rq->q->queue_flags) &&
+	if (cpu == rq->mq_ctx->cpu || !(blk_queue_same_force(rq->q) &&
 	     cpus_share_cache(cpu, rq->mq_ctx->cpu)))
 		return false;
 
@@ -1142,7 +1140,7 @@ void blk_mq_start_request(struct request *rq)
 
 	trace_block_rq_issue(rq);
 
-	if (test_bit(QUEUE_FLAG_STATS, &q->queue_flags)) {
+	if (blk_queue_stats(q)) {
 		rq->io_start_time_ns = ktime_get_ns();
 		rq->stats_sectors = blk_rq_sectors(rq);
 		rq->rq_flags |= RQF_STATS;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 0b2870839cdd..0cc94937c00c 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -355,7 +355,7 @@ static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
 	if (blk_mq_is_shared_tags(hctx->flags)) {
 		struct request_queue *q = hctx->queue;
 
-		if (!test_bit(QUEUE_FLAG_HCTX_ACTIVE, &q->queue_flags))
+		if (!blk_queue_hctx_active(q))
 			return true;
 	} else {
 		if (!test_bit(BLK_MQ_S_TAG_ACTIVE, &hctx->state))
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8bb9eef5310e..525eddb114ba 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -832,7 +832,7 @@ void blk_queue_write_cache(struct request_queue *q, bool wc, bool fua)
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_FUA, q);
 
-	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
+	wbt_set_write_cache(q, blk_queue_wb_cached(q));
 }
 EXPORT_SYMBOL_GPL(blk_queue_write_cache);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index e71b3b43927c..a87b16fcbcd5 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -365,8 +365,8 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 {
-	bool set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
-	bool force = test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags);
+	bool set = blk_queue_same_comp(q);
+	bool force = blk_queue_same_force(q);
 
 	return queue_var_show(set << force, page);
 }
@@ -432,13 +432,13 @@ static ssize_t queue_poll_delay_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_poll_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(test_bit(QUEUE_FLAG_POLL, &q->queue_flags), page);
+	return queue_var_show(blk_queue_poll(q), page);
 }
 
 static ssize_t queue_poll_store(struct request_queue *q, const char *page,
 				size_t count)
 {
-	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+	if (!blk_queue_poll(q))
 		return -EINVAL;
 	pr_info_ratelimited("writes to the poll attribute are ignored.\n");
 	pr_info_ratelimited("please use driver specific parameters instead.\n");
@@ -519,7 +519,7 @@ static ssize_t queue_wb_lat_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_wc_show(struct request_queue *q, char *page)
 {
-	if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+	if (blk_queue_wb_cached(q))
 		return sprintf(page, "write back\n");
 
 	return sprintf(page, "write through\n");
@@ -549,7 +549,7 @@ static ssize_t queue_wc_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_fua_show(struct request_queue *q, char *page)
 {
-	return sprintf(page, "%u\n", test_bit(QUEUE_FLAG_FUA, &q->queue_flags));
+	return sprintf(page, "%u\n", blk_queue_fua(q));
 }
 
 static ssize_t queue_dax_show(struct request_queue *q, char *page)
diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 1b8de0417fc1..d1f7bb5a4930 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -40,7 +40,7 @@ ssize_t part_timeout_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
 	struct gendisk *disk = dev_to_disk(dev);
-	int set = test_bit(QUEUE_FLAG_FAIL_IO, &disk->queue->queue_flags);
+	int set = blk_queue_fail_io(disk->queue);
 
 	return sprintf(buf, "%d\n", set != 0);
 }
diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index 246467926253..92c03db7eb6d 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -846,7 +846,7 @@ int wbt_init(struct request_queue *q)
 	rwb->min_lat_nsec = wbt_default_latency_nsec(q);
 
 	wbt_queue_depth_changed(&rwb->rqos);
-	wbt_set_write_cache(q, test_bit(QUEUE_FLAG_WC, &q->queue_flags));
+	wbt_set_write_cache(q, blk_queue_wb_cached(q));
 
 	/*
 	 * Assign rwb and add the stats callback.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 49373d002631..57f4b9cd0ea7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -620,6 +620,16 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
 #define blk_queue_sq_sched(q)	test_bit(QUEUE_FLAG_SQ_SCHED, &(q)->queue_flags)
 
+#define blk_queue_wb_cached(q) test_bit(QUEUE_FLAG_WC, &(q)->queue_flags)
+#define blk_queue_poll(q) test_bit(QUEUE_FLAG_POLL, &(q)->queue_flags)
+#define blk_queue_fua(q) test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
+#define blk_queue_same_comp(q) test_bit(QUEUE_FLAG_SAME_COMP, &(q)->queue_flags)
+#define blk_queue_same_force(q) test_bit(QUEUE_FLAG_SAME_FORCE, &(q)->queue_flags)
+#define blk_queue_fail_io(q) test_bit(QUEUE_FLAG_FAIL_IO, &(q)->queue_flags)
+#define blk_queue_stats(q) test_bit(QUEUE_FLAG_STATS, &(q)->queue_flags)
+#define blk_queue_hctx_active(q) test_bit(QUEUE_FLAG_HCTX_ACTIVE, &(q)->queue_flags)
+#define blk_queue_nowait(q) test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
+
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
 
@@ -1265,23 +1275,22 @@ static inline bool bdev_nonrot(struct block_device *bdev)
 
 static inline bool bdev_stable_writes(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_STABLE_WRITES,
-			&bdev_get_queue(bdev)->queue_flags);
+	return blk_queue_stable_writes(bdev_get_queue(bdev));
 }
 
 static inline bool bdev_write_cache(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_WC, &bdev_get_queue(bdev)->queue_flags);
+	return blk_queue_wb_cached(bdev_get_queue(bdev));
 }
 
 static inline bool bdev_fua(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_FUA, &bdev_get_queue(bdev)->queue_flags);
+	return blk_queue_fua(bdev_get_queue(bdev));
 }
 
 static inline bool bdev_nowait(struct block_device *bdev)
 {
-	return test_bit(QUEUE_FLAG_NOWAIT, &bdev_get_queue(bdev)->queue_flags);
+	return blk_queue_nowait(bdev_get_queue(bdev));
 }
 
 static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
-- 
2.25.1

