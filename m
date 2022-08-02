From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v7 9/9] blk-throttle: clean up flag 'THROTL_TG_PENDING'
Date: Tue,  2 Aug 2022 22:04:15 +0800
Message-ID: <20220802140415.2960284-10-yukuai1@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220802140415.2960284-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

All related operations are inside 'queue_lock', there is no need to use
the flag, we only need to make sure throtl_enqueue_tg() is called when
the first bio is throttled, and throtl_dequeue_tg() is called when the
last throttled bio is dispatched. There are no functional changes in
this patch.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 22 ++++++++--------------
 block/blk-throttle.h |  7 +++----
 2 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 6b2096e95221..778c0131adb1 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -561,23 +561,16 @@ static void tg_service_queue_add(struct throtl_grp *tg)
 
 static void throtl_enqueue_tg(struct throtl_grp *tg)
 {
-	if (!(tg->flags & THROTL_TG_PENDING)) {
-		tg_service_queue_add(tg);
-		tg->flags |= THROTL_TG_PENDING;
-		tg->service_queue.parent_sq->nr_pending++;
-	}
+	tg_service_queue_add(tg);
+	tg->service_queue.parent_sq->nr_pending++;
 }
 
 static void throtl_dequeue_tg(struct throtl_grp *tg)
 {
-	if (tg->flags & THROTL_TG_PENDING) {
-		struct throtl_service_queue *parent_sq =
-			tg->service_queue.parent_sq;
+	struct throtl_service_queue *parent_sq = tg->service_queue.parent_sq;
 
-		throtl_rb_erase(&tg->rb_node, parent_sq);
-		--parent_sq->nr_pending;
-		tg->flags &= ~THROTL_TG_PENDING;
-	}
+	throtl_rb_erase(&tg->rb_node, parent_sq);
+	--parent_sq->nr_pending;
 }
 
 /* Call with queue lock held */
@@ -1026,8 +1019,9 @@ static void throtl_add_bio_tg(struct bio *bio, struct throtl_qnode *qn,
 
 	throtl_qnode_add_bio(bio, qn, &sq->queued[rw]);
 
+	if (!sq->nr_queued[READ] && !sq->nr_queued[WRITE])
+		throtl_enqueue_tg(tg);
 	sq->nr_queued[rw]++;
-	throtl_enqueue_tg(tg);
 }
 
 static void tg_update_disptime(struct throtl_grp *tg)
@@ -1382,7 +1376,7 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 	throtl_start_new_slice(tg, READ, false);
 	throtl_start_new_slice(tg, WRITE, false);
 
-	if (tg->flags & THROTL_TG_PENDING) {
+	if (sq->nr_queued[READ] || sq->nr_queued[WRITE]) {
 		tg_update_disptime(tg);
 		throtl_schedule_next_dispatch(sq->parent_sq, true);
 	}
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index c9545616ba12..2ae5ac8fe76e 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -53,10 +53,9 @@ struct throtl_service_queue {
 };
 
 enum tg_state_flags {
-	THROTL_TG_PENDING	= 1 << 0,	/* on parent's pending tree */
-	THROTL_TG_WAS_EMPTY	= 1 << 1,	/* bio_lists[] became non-empty */
-	THROTL_TG_HAS_IOPS_LIMIT = 1 << 2,	/* tg has iops limit */
-	THROTL_TG_CANCELING	= 1 << 3,	/* starts to cancel bio */
+	THROTL_TG_WAS_EMPTY	= 1 << 0,	/* bio_lists[] became non-empty */
+	THROTL_TG_HAS_IOPS_LIMIT = 1 << 1,	/* tg has iops limit */
+	THROTL_TG_CANCELING	= 1 << 2,	/* starts to cancel bio */
 };
 
 enum {
-- 
2.31.1

