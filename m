From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] blk-throttle: store a gendisk in struct throtl_data
Date: Mon, 13 Feb 2023 11:41:32 +0100
Message-ID: <20230213104134.475204-2-hch@lst.de>
References: <20230213104134.475204-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=gXScR191cWVF98xNGBGBSwSq/elO3YR90RqzHQZux44=; b=Fj2+gDnW+rKAJ0nmmYgJCJ98SI
        f7e9q+LR9wDxZ57ooygf8ySvDh9Q1zDzAjoTc/82Gt99XCsWh5/GzFHl94DzhNBBgI5LMwC8Xn6Ww
        LVf8I+ZXnaBLaPu4E+/T493CfUgCM1GxzUZVshIDAtM0KgXV2zM61cQZEcayIOVw6twCJJ31Vm7aC
        BaT43w1CtWJDfa8BPsvFc4/POAasxpFb6sXsfCcuumW3xB8+E62cpEFZjH8VtW7UVv6IT0hMefUhM
        9mqGgZBKW2Rj9QtgMYL6h/1j7zgGyuoAoxuspZE1txpkQR86Ph8QaspkrQyJKBVnf0tCkyhpptlXY
        TCYksSHA==;
In-Reply-To: <20230213104134.475204-1-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: Ming Lei <ming.lei@redhat.com>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

We generally need a gendisk for core cgroup helpers, so store that
and derive the queue from it where needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-throttle.c | 52 ++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 29 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e7bd7050d68402..6a8b82939a38ad 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -61,7 +61,7 @@ struct throtl_data
 	/* service tree for active throtl groups */
 	struct throtl_service_queue service_queue;
 
-	struct request_queue *queue;
+	struct gendisk *disk;
 
 	/* Total Number of queued bios on READ and WRITE lists */
 	unsigned int nr_queued[2];
@@ -223,13 +223,13 @@ static unsigned int tg_iops_limit(struct throtl_grp *tg, int rw)
 	struct throtl_data *__td = sq_to_td((sq));			\
 									\
 	(void)__td;							\
-	if (likely(!blk_trace_note_message_enabled(__td->queue)))	\
+	if (likely(!blk_trace_note_message_enabled(__td->disk->queue)))	\
 		break;							\
 	if ((__tg)) {							\
-		blk_add_cgroup_trace_msg(__td->queue,			\
+		blk_add_cgroup_trace_msg(__td->disk->queue,			\
 			&tg_to_blkg(__tg)->blkcg->css, "throtl " fmt, ##args);\
 	} else {							\
-		blk_add_trace_msg(__td->queue, "throtl " fmt, ##args);	\
+		blk_add_trace_msg(__td->disk->queue, "throtl " fmt, ##args);	\
 	}								\
 } while (0)
 
@@ -451,8 +451,7 @@ static void blk_throtl_update_limit_valid(struct throtl_data *td)
 	bool low_valid = false;
 
 	rcu_read_lock();
-	blkg_for_each_descendant_post(blkg, pos_css,
-			td->queue->disk->root_blkg) {
+	blkg_for_each_descendant_post(blkg, pos_css, td->disk->root_blkg) {
 		struct throtl_grp *tg = blkg_to_tg(blkg);
 
 		if (tg->bps[READ][LIMIT_LOW] || tg->bps[WRITE][LIMIT_LOW] ||
@@ -1169,19 +1168,19 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 	struct throtl_grp *tg = sq_to_tg(sq);
 	struct throtl_data *td = sq_to_td(sq);
 	struct throtl_service_queue *parent_sq;
-	struct request_queue *q;
+	struct gendisk *disk;
 	bool dispatched;
 	int ret;
 
 	/* throtl_data may be gone, so figure out request queue by blkg */
 	if (tg)
-		q = tg->pd.blkg->disk->queue;
+		disk = tg->pd.blkg->disk;
 	else
-		q = td->queue;
+		disk = td->disk;
 
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irq(&disk->queue->queue_lock);
 
-	if (!q->disk->root_blkg)
+	if (!disk->root_blkg)
 		goto out_unlock;
 
 	if (throtl_can_upgrade(td, NULL))
@@ -1206,9 +1205,9 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 			break;
 
 		/* this dispatch windows is still open, relax and repeat */
-		spin_unlock_irq(&q->queue_lock);
+		spin_unlock_irq(&disk->queue->queue_lock);
 		cpu_relax();
-		spin_lock_irq(&q->queue_lock);
+		spin_lock_irq(&disk->queue->queue_lock);
 	}
 
 	if (!dispatched)
@@ -1230,7 +1229,7 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 		queue_work(kthrotld_workqueue, &td->dispatch_work);
 	}
 out_unlock:
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&disk->queue->queue_lock);
 }
 
 /**
@@ -1246,7 +1245,6 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 	struct throtl_data *td = container_of(work, struct throtl_data,
 					      dispatch_work);
 	struct throtl_service_queue *td_sq = &td->service_queue;
-	struct request_queue *q = td->queue;
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 	struct blk_plug plug;
@@ -1254,11 +1252,11 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 
 	bio_list_init(&bio_list_on_stack);
 
-	spin_lock_irq(&q->queue_lock);
+	spin_lock_irq(&td->disk->queue->queue_lock);
 	for (rw = READ; rw <= WRITE; rw++)
 		while ((bio = throtl_pop_queued(&td_sq->queued[rw], NULL)))
 			bio_list_add(&bio_list_on_stack, bio);
-	spin_unlock_irq(&q->queue_lock);
+	spin_unlock_irq(&td->disk->queue->queue_lock);
 
 	if (!bio_list_empty(&bio_list_on_stack)) {
 		blk_start_plug(&plug);
@@ -1323,8 +1321,7 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
 	 * blk-throttle.
 	 */
 	blkg_for_each_descendant_pre(blkg, pos_css,
-			global ? tg->td->queue->disk->root_blkg :
-			tg_to_blkg(tg)) {
+			global ? tg->td->disk->root_blkg : tg_to_blkg(tg)) {
 		struct throtl_grp *this_tg = blkg_to_tg(blkg);
 		struct throtl_grp *parent_tg;
 
@@ -1873,8 +1870,7 @@ static bool throtl_can_upgrade(struct throtl_data *td,
 		return false;
 
 	rcu_read_lock();
-	blkg_for_each_descendant_post(blkg, pos_css,
-			td->queue->disk->root_blkg) {
+	blkg_for_each_descendant_post(blkg, pos_css, td->disk->root_blkg) {
 		struct throtl_grp *tg = blkg_to_tg(blkg);
 
 		if (tg == this_tg)
@@ -1920,8 +1916,7 @@ static void throtl_upgrade_state(struct throtl_data *td)
 	td->low_upgrade_time = jiffies;
 	td->scale = 0;
 	rcu_read_lock();
-	blkg_for_each_descendant_post(blkg, pos_css,
-			td->queue->disk->root_blkg) {
+	blkg_for_each_descendant_post(blkg, pos_css, td->disk->root_blkg) {
 		struct throtl_grp *tg = blkg_to_tg(blkg);
 		struct throtl_service_queue *sq = &tg->service_queue;
 
@@ -2068,7 +2063,7 @@ static void throtl_update_latency_buckets(struct throtl_data *td)
 	unsigned long last_latency[2] = { 0 };
 	unsigned long latency[2];
 
-	if (!blk_queue_nonrot(td->queue) || !td->limit_valid[LIMIT_LOW])
+	if (!blk_queue_nonrot(td->disk->queue) || !td->limit_valid[LIMIT_LOW])
 		return;
 	if (time_before(jiffies, td->last_calculate_time + HZ))
 		return;
@@ -2288,7 +2283,7 @@ static void throtl_track_latency(struct throtl_data *td, sector_t size,
 
 	if (!td || td->limit_index != LIMIT_LOW ||
 	    !(op == REQ_OP_READ || op == REQ_OP_WRITE) ||
-	    !blk_queue_nonrot(td->queue))
+	    !blk_queue_nonrot(td->disk->queue))
 		return;
 
 	index = request_bucket_index(size);
@@ -2365,11 +2360,10 @@ void blk_throtl_bio_endio(struct bio *bio)
 
 int blk_throtl_init(struct gendisk *disk)
 {
-	struct request_queue *q = disk->queue;
 	struct throtl_data *td;
 	int ret;
 
-	td = kzalloc_node(sizeof(*td), GFP_KERNEL, q->node);
+	td = kzalloc_node(sizeof(*td), GFP_KERNEL, disk->queue->node);
 	if (!td)
 		return -ENOMEM;
 	td->latency_buckets[READ] = __alloc_percpu(sizeof(struct latency_bucket) *
@@ -2389,8 +2383,8 @@ int blk_throtl_init(struct gendisk *disk)
 	INIT_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
 	throtl_service_queue_init(&td->service_queue);
 
-	q->td = td;
-	td->queue = q;
+	disk->queue->td = td;
+	td->disk = disk;
 
 	td->limit_valid[LIMIT_MAX] = true;
 	td->limit_index = LIMIT_MAX;
-- 
2.39.1

