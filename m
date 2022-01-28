From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH v7 1/2] blk-throtl: introduce a new flag THROTL_TG_CANCELING
Date: Fri, 28 Jan 2022 16:45:21 +0800
Message-ID: <20220128084522.3169961-2-yukuai3@huawei.com>
References: <20220128084522.3169961-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220128084522.3169961-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ming.lei@redhat.com, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

If the new flag is set, then the throtl_grp will stop throttling bios.
Prepare to canceling all throttled bios if the disk is gone.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-throttle.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7c462c006b26..abc5e506c72d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -43,8 +43,12 @@
 static struct workqueue_struct *kthrotld_workqueue;
 
 enum tg_state_flags {
-	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
-	THROTL_TG_WAS_EMPTY	= 1 << 1,	/* bio_lists[] became non-empty */
+	/* on parent's pending tree */
+	THROTL_TG_PENDING	= 1 << 0,
+	/* bio_lists[] became non-empty */
+	THROTL_TG_WAS_EMPTY	= 1 << 1,
+	/* starts to cancel all bios, will be set if the disk is deleted */
+	THROTL_TG_CANCELING	= 1 << 2,
 };
 
 #define rb_entry_tg(node)	rb_entry((node), struct throtl_grp, rb_node)
@@ -871,7 +875,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	       bio != throtl_peek_queued(&tg->service_queue.queued[rw]));
 
 	/* If tg->bps = -1, then BW is unlimited */
-	if (bps_limit == U64_MAX && iops_limit == UINT_MAX) {
+	if ((bps_limit == U64_MAX && iops_limit == UINT_MAX) ||
+	    tg->flags & THROTL_TG_CANCELING) {
 		if (wait)
 			*wait = 0;
 		return true;
@@ -974,6 +979,9 @@ static void tg_update_disptime(struct throtl_grp *tg)
 	unsigned long read_wait = -1, write_wait = -1, min_wait = -1, disptime;
 	struct bio *bio;
 
+	if (tg->flags & THROTL_TG_CANCELING)
+		goto update;
+
 	bio = throtl_peek_queued(&sq->queued[READ]);
 	if (bio)
 		tg_may_dispatch(tg, bio, &read_wait);
@@ -983,9 +991,10 @@ static void tg_update_disptime(struct throtl_grp *tg)
 		tg_may_dispatch(tg, bio, &write_wait);
 
 	min_wait = min(read_wait, write_wait);
-	disptime = jiffies + min_wait;
 
+update:
 	/* Update dispatch time */
+	disptime = jiffies + min_wait;
 	throtl_dequeue_tg(tg);
 	tg->disptime = disptime;
 	throtl_enqueue_tg(tg);
-- 
2.31.1

