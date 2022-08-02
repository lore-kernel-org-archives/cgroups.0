From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v7 8/9] blk-throttle: cleanup tg_update_disptime()
Date: Tue,  2 Aug 2022 22:04:14 +0800
Message-ID: <20220802140415.2960284-9-yukuai1@huaweicloud.com>
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

tg_update_disptime() only need to adjust postion for 'tg' in
'parent_sq', there is no need to call throtl_enqueue/dequeue_tg().

Save a little overhead in tg_update_disptime() and prepare to cleanup
flag 'THROTL_TG_PENDING', there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f7048f87b19f..6b2096e95221 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -520,7 +520,6 @@ static void throtl_rb_erase(struct rb_node *n,
 {
 	rb_erase_cached(n, &parent_sq->pending_tree);
 	RB_CLEAR_NODE(n);
-	--parent_sq->nr_pending;
 }
 
 static void update_min_dispatch_time(struct throtl_service_queue *parent_sq)
@@ -572,7 +571,11 @@ static void throtl_enqueue_tg(struct throtl_grp *tg)
 static void throtl_dequeue_tg(struct throtl_grp *tg)
 {
 	if (tg->flags & THROTL_TG_PENDING) {
-		throtl_rb_erase(&tg->rb_node, tg->service_queue.parent_sq);
+		struct throtl_service_queue *parent_sq =
+			tg->service_queue.parent_sq;
+
+		throtl_rb_erase(&tg->rb_node, parent_sq);
+		--parent_sq->nr_pending;
 		tg->flags &= ~THROTL_TG_PENDING;
 	}
 }
@@ -1045,9 +1048,9 @@ static void tg_update_disptime(struct throtl_grp *tg)
 	disptime = jiffies + min_wait;
 
 	/* Update dispatch time */
-	throtl_dequeue_tg(tg);
+	throtl_rb_erase(&tg->rb_node, tg->service_queue.parent_sq);
 	tg->disptime = disptime;
-	throtl_enqueue_tg(tg);
+	tg_service_queue_add(tg);
 
 	/* see throtl_add_bio_tg() */
 	tg->flags &= ~THROTL_TG_WAS_EMPTY;
-- 
2.31.1

