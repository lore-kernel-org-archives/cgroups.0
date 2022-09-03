From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH] blk-throttle: clean up codes that can't be reached
Date: Sat,  3 Sep 2022 14:28:26 +0800
Message-ID: <20220903062826.1099085-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

While doing code coverage testing while CONFIG_BLK_DEV_THROTTLING_LOW is
disabled, we found that there are many codes can never be reached.

This patch move such codes inside "#ifdef CONFIG_BLK_DEV_THROTTLING_LOW".

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-throttle.c | 90 +++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 34 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9f5fe62afff9..667b2958471a 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1673,6 +1673,40 @@ struct blkcg_policy blkcg_policy_throtl = {
 	.pd_free_fn		= throtl_pd_free,
 };
 
+void blk_throtl_cancel_bios(struct request_queue *q)
+{
+	struct cgroup_subsys_state *pos_css;
+	struct blkcg_gq *blkg;
+
+	spin_lock_irq(&q->queue_lock);
+	/*
+	 * queue_lock is held, rcu lock is not needed here technically.
+	 * However, rcu lock is still held to emphasize that following
+	 * path need RCU protection and to prevent warning from lockdep.
+	 */
+	rcu_read_lock();
+	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
+		struct throtl_grp *tg = blkg_to_tg(blkg);
+		struct throtl_service_queue *sq = &tg->service_queue;
+
+		/*
+		 * Set the flag to make sure throtl_pending_timer_fn() won't
+		 * stop until all throttled bios are dispatched.
+		 */
+		blkg_to_tg(blkg)->flags |= THROTL_TG_CANCELING;
+		/*
+		 * Update disptime after setting the above flag to make sure
+		 * throtl_select_dispatch() won't exit without dispatching.
+		 */
+		tg_update_disptime(tg);
+
+		throtl_schedule_pending_timer(sq, jiffies + 1);
+	}
+	rcu_read_unlock();
+	spin_unlock_irq(&q->queue_lock);
+}
+
+#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 static unsigned long __tg_last_low_overflow_time(struct throtl_grp *tg)
 {
 	unsigned long rtime = jiffies, wtime = jiffies;
@@ -1777,39 +1811,6 @@ static bool throtl_hierarchy_can_upgrade(struct throtl_grp *tg)
 	return false;
 }
 
-void blk_throtl_cancel_bios(struct request_queue *q)
-{
-	struct cgroup_subsys_state *pos_css;
-	struct blkcg_gq *blkg;
-
-	spin_lock_irq(&q->queue_lock);
-	/*
-	 * queue_lock is held, rcu lock is not needed here technically.
-	 * However, rcu lock is still held to emphasize that following
-	 * path need RCU protection and to prevent warning from lockdep.
-	 */
-	rcu_read_lock();
-	blkg_for_each_descendant_post(blkg, pos_css, q->root_blkg) {
-		struct throtl_grp *tg = blkg_to_tg(blkg);
-		struct throtl_service_queue *sq = &tg->service_queue;
-
-		/*
-		 * Set the flag to make sure throtl_pending_timer_fn() won't
-		 * stop until all throttled bios are dispatched.
-		 */
-		blkg_to_tg(blkg)->flags |= THROTL_TG_CANCELING;
-		/*
-		 * Update disptime after setting the above flag to make sure
-		 * throtl_select_dispatch() won't exit without dispatching.
-		 */
-		tg_update_disptime(tg);
-
-		throtl_schedule_pending_timer(sq, jiffies + 1);
-	}
-	rcu_read_unlock();
-	spin_unlock_irq(&q->queue_lock);
-}
-
 static bool throtl_can_upgrade(struct throtl_data *td,
 	struct throtl_grp *this_tg)
 {
@@ -2005,7 +2006,6 @@ static void blk_throtl_update_idletime(struct throtl_grp *tg)
 	tg->checked_last_finish_time = last_finish_time;
 }
 
-#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 static void throtl_update_latency_buckets(struct throtl_data *td)
 {
 	struct avg_latency_bucket avg_latency[2][LATENCY_BUCKET_SIZE];
@@ -2086,6 +2086,28 @@ static void throtl_update_latency_buckets(struct throtl_data *td)
 static inline void throtl_update_latency_buckets(struct throtl_data *td)
 {
 }
+
+static void blk_throtl_update_idletime(struct throtl_grp *tg)
+{
+}
+
+static void throtl_downgrade_check(struct throtl_grp *tg)
+{
+}
+
+static void throtl_upgrade_check(struct throtl_grp *tg)
+{
+}
+
+static bool throtl_can_upgrade(struct throtl_data *td,
+	struct throtl_grp *this_tg)
+{
+	return false;
+}
+
+static void throtl_upgrade_state(struct throtl_data *td)
+{
+}
 #endif
 
 bool __blk_throtl_bio(struct bio *bio)
-- 
2.31.1

