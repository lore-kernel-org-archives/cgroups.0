From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/45] writeback, blkcg: restructure blk_{set|clear}_queue_congested()
Date: Tue,  6 Jan 2015 16:25:47 -0500
Message-ID: <1420579582-8516-11-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zd1H/4KTwrqO3ns+H5RbI5xo196mrg7X/pi6txgV+4s=;
        b=zFlZgaeICFSF3Ly19E3I1b05EASjRonWFgv/z3y91VbYJioffzaXn2kX/MbDTiS8Sn
         y1ao2Q8BGElMOxQWICOj4vsW9NRI9Zy9Ord8yhkHUzIbHsj5utSnFq7doW+LLTDymIrI
         633IDsuRspSA/+MKxhiGkLEqJdLFPYPDOue9aX96dCvuf80AFMckzGFq81CjJAPJfx+F
         lhQt+PzGGy0ejotcEJBSYlc/UmFtQYoZTlluZBgh+nd32oIMmm4lblpELsgfKjkzx3IU
         CLTE/imrhAZb30wzY6SAbAPsEKDymXwmtmHIkZm+ixBwZ/XoyqQYltCCcsdNTzkJ4SvJ
         cWJQ==
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, Tejun Heo <tj@kernel.org>

blk_{set|clear}_queue_congested() take @q and set or clear,
respectively, the congestion state of its bdi's root wb.  Because bdi
used to be able to handle congestion state only on the root wb, the
callers of those functions tested whether the congestion is on the
root blkcg and skipped if not.

This is cumbersome and makes implementation of per cgroup
bdi_writeback congestion state propagation difficult.  This patch
renames blk_{set|clear}_queue_congested() to
blk_{set|clear}_congested(), and makes them take request_list instead
of request_queue and test whether the specified request_list is the
root one before updating bdi_writeback congestion state.  This makes
the tests in the callers unnecessary and simplifies them.

As there are no external users of these functions, the definitions are
moved from include/linux/blkdev.h to block/blk-core.c.

This patch doesn't introduce any noticeable behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c       | 62 ++++++++++++++++++++++++++++++--------------------
 include/linux/blkdev.h | 19 ----------------
 2 files changed, 37 insertions(+), 44 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ff4d2f8..c9a7d6c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -63,6 +63,28 @@ struct kmem_cache *blk_requestq_cachep;
  */
 static struct workqueue_struct *kblockd_workqueue;
 
+static void blk_clear_congested(struct request_list *rl, int sync)
+{
+	if (rl != &rl->q->root_rl)
+		return;
+#ifdef CONFIG_CGROUP_WRITEBACK
+	clear_wb_congested(rl->blkg->wb, sync);
+#else
+	clear_wb_congested(&rl->q->backing_dev_info.wb, sync);
+#endif
+}
+
+static void blk_set_congested(struct request_list *rl, int sync)
+{
+	if (rl != &rl->q->root_rl)
+		return;
+#ifdef CONFIG_CGROUP_WRITEBACK
+	set_wb_congested(rl->blkg->wb, sync);
+#else
+	set_wb_congested(&rl->q->backing_dev_info.wb, sync);
+#endif
+}
+
 void blk_queue_congestion_threshold(struct request_queue *q)
 {
 	int nr;
@@ -828,13 +850,8 @@ static void __freed_request(struct request_list *rl, int sync)
 {
 	struct request_queue *q = rl->q;
 
-	/*
-	 * bdi isn't aware of blkcg yet.  As all async IOs end up root
-	 * blkcg anyway, just use root blkcg state.
-	 */
-	if (rl == &q->root_rl &&
-	    rl->count[sync] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, sync);
+	if (rl->count[sync] < queue_congestion_off_threshold(q))
+		blk_clear_congested(rl, sync);
 
 	if (rl->count[sync] + 1 <= q->nr_requests) {
 		if (waitqueue_active(&rl->wait[sync]))
@@ -867,25 +884,25 @@ static void freed_request(struct request_list *rl, unsigned int flags)
 int blk_update_nr_requests(struct request_queue *q, unsigned int nr)
 {
 	struct request_list *rl;
+	int on_thresh, off_thresh;
 
 	spin_lock_irq(q->queue_lock);
 	q->nr_requests = nr;
 	blk_queue_congestion_threshold(q);
+	on_thresh = queue_congestion_on_threshold(q);
+	off_thresh = queue_congestion_off_threshold(q);
 
-	/* congestion isn't cgroup aware and follows root blkcg for now */
-	rl = &q->root_rl;
-
-	if (rl->count[BLK_RW_SYNC] >= queue_congestion_on_threshold(q))
-		blk_set_queue_congested(q, BLK_RW_SYNC);
-	else if (rl->count[BLK_RW_SYNC] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, BLK_RW_SYNC);
+	blk_queue_for_each_rl(rl, q) {
+		if (rl->count[BLK_RW_SYNC] >= on_thresh)
+			blk_set_congested(rl, BLK_RW_SYNC);
+		else if (rl->count[BLK_RW_SYNC] < off_thresh)
+			blk_clear_congested(rl, BLK_RW_SYNC);
 
-	if (rl->count[BLK_RW_ASYNC] >= queue_congestion_on_threshold(q))
-		blk_set_queue_congested(q, BLK_RW_ASYNC);
-	else if (rl->count[BLK_RW_ASYNC] < queue_congestion_off_threshold(q))
-		blk_clear_queue_congested(q, BLK_RW_ASYNC);
+		if (rl->count[BLK_RW_ASYNC] >= on_thresh)
+			blk_set_congested(rl, BLK_RW_ASYNC);
+		else if (rl->count[BLK_RW_ASYNC] < off_thresh)
+			blk_clear_congested(rl, BLK_RW_ASYNC);
 
-	blk_queue_for_each_rl(rl, q) {
 		if (rl->count[BLK_RW_SYNC] >= q->nr_requests) {
 			blk_set_rl_full(rl, BLK_RW_SYNC);
 		} else {
@@ -995,12 +1012,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 				}
 			}
 		}
-		/*
-		 * bdi isn't aware of blkcg yet.  As all async IOs end up
-		 * root blkcg anyway, just use root blkcg state.
-		 */
-		if (rl == &q->root_rl)
-			blk_set_queue_congested(q, is_sync);
+		blk_set_congested(rl, is_sync);
 	}
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fc980a6..b8964a7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -819,25 +819,6 @@ extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 
 extern void blk_queue_bio(struct request_queue *q, struct bio *bio);
 
-/*
- * A queue has just exitted congestion.  Note this in the global counter of
- * congested queues, and wake up anyone who was waiting for requests to be
- * put back.
- */
-static inline void blk_clear_queue_congested(struct request_queue *q, int sync)
-{
-	clear_bdi_congested(&q->backing_dev_info, sync);
-}
-
-/*
- * A queue has just entered congestion.  Flag that in the queue's VM-visible
- * state flags and increment the global gounter of congested queues.
- */
-static inline void blk_set_queue_congested(struct request_queue *q, int sync)
-{
-	set_bdi_congested(&q->backing_dev_info, sync);
-}
-
 extern void blk_start_queue(struct request_queue *q);
 extern void blk_stop_queue(struct request_queue *q);
 extern void blk_sync_queue(struct request_queue *q);
-- 
2.1.0
