From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/3] blk-throttle: move the throtl_data pointer from to struct gendisk
Date: Mon, 13 Feb 2023 11:41:33 +0100
Message-ID: <20230213104134.475204-3-hch@lst.de>
References: <20230213104134.475204-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=anWbode/9rI+FLUB/mF2liGhRUBZCvhjwrtOfgkthIk=; b=iikheqQOZk5Pdvh+bbJdxspsbv
        tIo+Dbkc/fyowURmlq+aQrsQyWr2igsqUl7DDeR4OF2dWdYC2k4EzxmS9P5G5nYKhtUP3ypZplwOd
        Rm0EW/G30K/6PMEEpf+NPD3IO0k61Mcky8+wcf/G/q9o04VijK5xYzUd1B6qlheI5NRhMhSXFOazA
        dZM4UVNhRqsZ+csxC+Q9sbwcCk8WOSa6BZgj0l3bQ73sX5qVC9gzHy7SE64iT6ljF+2O/Dsmgn4Rp
        f12drY6zp++WUnrcuBYPWmEUXEuLn/6C1liH6+cT673y/vpTzmCou8cZSpjd8Z4baoqSsGYzIdaxC
        S8z+8BTw==;
In-Reply-To: <20230213104134.475204-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Block throttling is only used for file system I/O, so move the
throtl_data pointer to the gendisk.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-throttle.c   | 39 ++++++++++++++++-----------------------
 include/linux/blkdev.h |  8 +++-----
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6a8b82939a38ad..8cece10c56515d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -387,7 +387,7 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
 	struct blkcg_gq *blkg = tg_to_blkg(tg);
-	struct throtl_data *td = blkg->disk->queue->td;
+	struct throtl_data *td = blkg->disk->td;
 	struct throtl_service_queue *sq = &tg->service_queue;
 
 	/*
@@ -1685,13 +1685,6 @@ static struct cftype throtl_files[] = {
 	{ }	/* terminate */
 };
 
-static void throtl_shutdown_wq(struct request_queue *q)
-{
-	struct throtl_data *td = q->td;
-
-	cancel_work_sync(&td->dispatch_work);
-}
-
 struct blkcg_policy blkcg_policy_throtl = {
 	.dfl_cftypes		= throtl_files,
 	.legacy_cftypes		= throtl_legacy_files,
@@ -2297,7 +2290,7 @@ static void throtl_track_latency(struct throtl_data *td, sector_t size,
 void blk_throtl_stat_add(struct request *rq, u64 time_ns)
 {
 	struct request_queue *q = rq->q;
-	struct throtl_data *td = q->td;
+	struct throtl_data *td = q->disk->td;
 
 	throtl_track_latency(td, blk_rq_stats_sectors(rq), req_op(rq),
 			     time_ns >> 10);
@@ -2383,7 +2376,7 @@ int blk_throtl_init(struct gendisk *disk)
 	INIT_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
 	throtl_service_queue_init(&td->service_queue);
 
-	disk->queue->td = td;
+	disk->td = td;
 	td->disk = disk;
 
 	td->limit_valid[LIMIT_MAX] = true;
@@ -2403,25 +2396,24 @@ int blk_throtl_init(struct gendisk *disk)
 
 void blk_throtl_exit(struct gendisk *disk)
 {
-	struct request_queue *q = disk->queue;
+	struct throtl_data *td = disk->td;
 
-	if (!q->td)
+	if (!td)
 		return;
-	del_timer_sync(&q->td->service_queue.pending_timer);
-	throtl_shutdown_wq(q);
+	del_timer_sync(&td->service_queue.pending_timer);
+	cancel_work_sync(&td->dispatch_work);
 	blkcg_deactivate_policy(disk, &blkcg_policy_throtl);
-	free_percpu(q->td->latency_buckets[READ]);
-	free_percpu(q->td->latency_buckets[WRITE]);
-	kfree(q->td);
+	free_percpu(td->latency_buckets[READ]);
+	free_percpu(td->latency_buckets[WRITE]);
+	kfree(td);
 }
 
 void blk_throtl_register(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	struct throtl_data *td;
+	struct throtl_data *td = disk->td;
 	int i;
 
-	td = q->td;
 	BUG_ON(!td);
 
 	if (blk_queue_nonrot(q)) {
@@ -2448,9 +2440,10 @@ void blk_throtl_register(struct gendisk *disk)
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 ssize_t blk_throtl_sample_time_show(struct request_queue *q, char *page)
 {
-	if (!q->td)
+	if (!q->disk->td)
 		return -EINVAL;
-	return sprintf(page, "%u\n", jiffies_to_msecs(q->td->throtl_slice));
+	return sprintf(page, "%u\n",
+		       jiffies_to_msecs(q->disk->td->throtl_slice));
 }
 
 ssize_t blk_throtl_sample_time_store(struct request_queue *q,
@@ -2459,14 +2452,14 @@ ssize_t blk_throtl_sample_time_store(struct request_queue *q,
 	unsigned long v;
 	unsigned long t;
 
-	if (!q->td)
+	if (!q->disk->td)
 		return -EINVAL;
 	if (kstrtoul(page, 10, &v))
 		return -EINVAL;
 	t = msecs_to_jiffies(v);
 	if (t == 0 || t > MAX_THROTL_SLICE)
 		return -EINVAL;
-	q->td->throtl_slice = t;
+	q->disk->td->throtl_slice = t;
 	return count;
 }
 #endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 79aec4ebadb9e0..f07bc82c87f8b3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -169,6 +169,9 @@ struct gendisk {
 	struct list_head	blkg_list;
 	struct mutex		blkcg_mutex;
 #endif /* CONFIG_BLK_CGROUP */
+#ifdef CONFIG_BLK_DEV_THROTTLING
+	struct throtl_data	*td;
+#endif
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct kobject integrity_kobj;
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
@@ -516,11 +519,6 @@ struct request_queue {
 	spinlock_t		unused_hctx_lock;
 
 	int			mq_freeze_depth;
-
-#ifdef CONFIG_BLK_DEV_THROTTLING
-	/* Throttle data */
-	struct throtl_data *td;
-#endif
 	struct rcu_head		rcu_head;
 	wait_queue_head_t	mq_freeze_wq;
 	/*
-- 
2.39.1

