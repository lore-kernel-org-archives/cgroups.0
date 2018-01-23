From: xuejiufei <jiufei.xue-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH RESEND] blk-throttle: dispatch more sync writes in block
 throttle layer
Date: Tue, 23 Jan 2018 10:08:01 +0800
Message-ID: <557effc5-65f0-5190-477e-6d20b7121b59@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, caspar-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

Cgroup writeback is supported since v4.2. But there exists a problem
in the following case.

A cgroup may send both buffer and direct/sync IOs. The foreground
thread will be stalled when periodic writeback IOs is flushed because
the service queue in block throttle layer already has a plenty of
writeback IOs, then foreground IOs should be enqueued with its FIFO
policy. The current policy is dispatching 6 reads and 2 writes during
each round, sync writes will be significantly delayed.

This patch adds another queue in block throttle. Now there are 3 queues
in a service queue: read, sync write, async write, and we can dispatch
more sync writes than aync writes.

Test:
1) setup a memcg and a blkcg with uplimit bandwidth 20m/s;
2) start a script writing 5G buffer to page cache and start to sync
3) start sync writes:
    dd if=/dev/zero of=test bs=4k count=12800 oflag=direct conv=notrunc

Unpatched:
52428800 bytes (52 MB) copied, 307.065 s, 171 kB/s

Patched:
52428800 bytes (52 MB) copied, 13.8192 s, 3.8 MB/s

Signed-off-by: Jiufei Xue <jiufei.xjf-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
---
 block/blk-throttle.c | 195 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 129 insertions(+), 66 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index d19f416..842257e 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -14,10 +14,10 @@
 #include "blk.h"
 
 /* Max dispatch from a group in 1 round */
-static int throtl_grp_quantum = 8;
+static int throtl_grp_quantum = 32;
 
 /* Total max dispatch from all groups in one round */
-static int throtl_quantum = 32;
+static int throtl_quantum = 128;
 
 /* Throttling is performed over a slice and after that slice is renewed */
 #define DFL_THROTL_SLICE_HD (HZ / 10)
@@ -43,6 +43,12 @@
 /* A workqueue to queue throttle related work */
 static struct workqueue_struct *kthrotld_workqueue;
 
+enum wl_type {
+	READ_WORKLOAD = 0,
+	SYNC_WRITE_WORKLOAD = 1,
+	ASYNC_WRITE_WORKLOAD = 2
+};
+
 /*
  * To implement hierarchical throttling, throtl_grps form a tree and bios
  * are dispatched upwards level by level until they reach the top and get
@@ -79,8 +85,11 @@ struct throtl_service_queue {
 	 * Bios queued directly to this service_queue or dispatched from
 	 * children throtl_grp's.
 	 */
-	struct list_head	queued[2];	/* throtl_qnode [READ/WRITE] */
-	unsigned int		nr_queued[2];	/* number of queued bios */
+	/* throtl_qnode [READ/WRITE/ASYNC_WRITE] */
+	struct list_head	queued[3];
+
+	unsigned int		nr_queued[3];	/* number of queued bios */
+
 
 	/*
 	 * RB tree of active children throtl_grp's, which are sorted by
@@ -127,8 +136,8 @@ struct throtl_grp {
 	 * with the sibling qnode_on_parents and the parent's
 	 * qnode_on_self.
 	 */
-	struct throtl_qnode qnode_on_self[2];
-	struct throtl_qnode qnode_on_parent[2];
+	struct throtl_qnode qnode_on_self[3];
+	struct throtl_qnode qnode_on_parent[3];
 
 	/*
 	 * Dispatch time in jiffies. This is the estimated time when group
@@ -202,7 +211,7 @@ struct throtl_data
 	struct request_queue *queue;
 
 	/* Total Number of queued bios on READ and WRITE lists */
-	unsigned int nr_queued[2];
+	unsigned int nr_queued[3];
 
 	unsigned int throtl_slice;
 
@@ -274,6 +283,18 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
 		return container_of(sq, struct throtl_data, service_queue);
 }
 
+static inline enum wl_type bio_workload_type(struct bio *bio)
+{
+	return bio_data_dir(bio) ?
+	       ((bio->bi_opf & REQ_SYNC) ? SYNC_WRITE_WORKLOAD :
+	       ASYNC_WRITE_WORKLOAD) : READ_WORKLOAD;
+}
+
+static inline bool wl_to_rw(enum wl_type type)
+{
+	return type >= SYNC_WRITE_WORKLOAD;
+}
+
 /*
  * cgroup's limit in LIMIT_MAX is scaled if low limit is set. This scale is to
  * make the IO dispatch more smooth.
@@ -475,8 +496,9 @@ static struct bio *throtl_pop_queued(struct list_head *queued,
 /* init a service_queue, assumes the caller zeroed it */
 static void throtl_service_queue_init(struct throtl_service_queue *sq)
 {
-	INIT_LIST_HEAD(&sq->queued[0]);
-	INIT_LIST_HEAD(&sq->queued[1]);
+	INIT_LIST_HEAD(&sq->queued[READ_WORKLOAD]);
+	INIT_LIST_HEAD(&sq->queued[SYNC_WRITE_WORKLOAD]);
+	INIT_LIST_HEAD(&sq->queued[ASYNC_WRITE_WORKLOAD]);
 	sq->pending_tree = RB_ROOT;
 	timer_setup(&sq->pending_timer, throtl_pending_timer_fn, 0);
 }
@@ -484,7 +506,7 @@ static void throtl_service_queue_init(struct throtl_service_queue *sq)
 static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 {
 	struct throtl_grp *tg;
-	int rw;
+	enum wl_type type;
 
 	tg = kzalloc_node(sizeof(*tg), gfp, node);
 	if (!tg)
@@ -492,9 +514,9 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 
 	throtl_service_queue_init(&tg->service_queue);
 
-	for (rw = READ; rw <= WRITE; rw++) {
-		throtl_qnode_init(&tg->qnode_on_self[rw], tg);
-		throtl_qnode_init(&tg->qnode_on_parent[rw], tg);
+	for (type = READ_WORKLOAD; type <= ASYNC_WRITE_WORKLOAD; type++) {
+		throtl_qnode_init(&tg->qnode_on_self[type], tg);
+		throtl_qnode_init(&tg->qnode_on_parent[type], tg);
 	}
 
 	RB_CLEAR_NODE(&tg->rb_node);
@@ -985,6 +1007,7 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 			    unsigned long *wait)
 {
 	bool rw = bio_data_dir(bio);
+	enum wl_type type = bio_workload_type(bio);
 	unsigned long bps_wait = 0, iops_wait = 0, max_wait = 0;
 
 	/*
@@ -993,8 +1016,8 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	 * this function with a different bio if there are other bios
 	 * queued.
 	 */
-	BUG_ON(tg->service_queue.nr_queued[rw] &&
-	       bio != throtl_peek_queued(&tg->service_queue.queued[rw]));
+	BUG_ON(tg->service_queue.nr_queued[type] &&
+	       bio != throtl_peek_queued(&tg->service_queue.queued[type]));
 
 	/* If tg->bps = -1, then BW is unlimited */
 	if (tg_bps_limit(tg, rw) == U64_MAX &&
@@ -1011,7 +1034,12 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	 * If there is queued bio, that means there should be an active
 	 * slice and it should be extended instead.
 	 */
-	if (throtl_slice_used(tg, rw) && !(tg->service_queue.nr_queued[rw]))
+	if (throtl_slice_used(tg, rw) &&
+	   ((rw == READ &&
+	    !tg->service_queue.nr_queued[READ_WORKLOAD]) ||
+	    (rw == WRITE &&
+	    !tg->service_queue.nr_queued[SYNC_WRITE_WORKLOAD] &&
+	    !tg->service_queue.nr_queued[ASYNC_WRITE_WORKLOAD])))
 		throtl_start_new_slice(tg, rw);
 	else {
 		if (time_before(tg->slice_end[rw],
@@ -1072,10 +1100,10 @@ static void throtl_add_bio_tg(struct bio *bio, struct throtl_qnode *qn,
 			      struct throtl_grp *tg)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
-	bool rw = bio_data_dir(bio);
+	int type = bio_workload_type(bio);
 
 	if (!qn)
-		qn = &tg->qnode_on_self[rw];
+		qn = &tg->qnode_on_self[type];
 
 	/*
 	 * If @tg doesn't currently have any bios queued in the same
@@ -1083,12 +1111,12 @@ static void throtl_add_bio_tg(struct bio *bio, struct throtl_qnode *qn,
 	 * dispatched.  Mark that @tg was empty.  This is automatically
 	 * cleaered on the next tg_update_disptime().
 	 */
-	if (!sq->nr_queued[rw])
+	if (!sq->nr_queued[type])
 		tg->flags |= THROTL_TG_WAS_EMPTY;
 
-	throtl_qnode_add_bio(bio, qn, &sq->queued[rw]);
+	throtl_qnode_add_bio(bio, qn, &sq->queued[type]);
 
-	sq->nr_queued[rw]++;
+	sq->nr_queued[type]++;
 	throtl_enqueue_tg(tg);
 }
 
@@ -1096,16 +1124,22 @@ static void tg_update_disptime(struct throtl_grp *tg)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 	unsigned long read_wait = -1, write_wait = -1, min_wait = -1, disptime;
+	unsigned long sync_write_wait, async_write_wait;
 	struct bio *bio;
 
-	bio = throtl_peek_queued(&sq->queued[READ]);
+	bio = throtl_peek_queued(&sq->queued[READ_WORKLOAD]);
 	if (bio)
 		tg_may_dispatch(tg, bio, &read_wait);
 
-	bio = throtl_peek_queued(&sq->queued[WRITE]);
+	bio = throtl_peek_queued(&sq->queued[SYNC_WRITE_WORKLOAD]);
+	if (bio)
+		tg_may_dispatch(tg, bio, &sync_write_wait);
+
+	bio = throtl_peek_queued(&sq->queued[ASYNC_WRITE_WORKLOAD]);
 	if (bio)
-		tg_may_dispatch(tg, bio, &write_wait);
+		tg_may_dispatch(tg, bio, &async_write_wait);
 
+	write_wait = min(sync_write_wait, async_write_wait);
 	min_wait = min(read_wait, write_wait);
 	disptime = jiffies + min_wait;
 
@@ -1125,16 +1159,16 @@ static void start_parent_slice_with_credit(struct throtl_grp *child_tg,
 		throtl_start_new_slice_with_credit(parent_tg, rw,
 				child_tg->slice_start[rw]);
 	}
-
 }
 
-static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
+static void tg_dispatch_one_bio(struct throtl_grp *tg, enum wl_type type)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
 	struct throtl_service_queue *parent_sq = sq->parent_sq;
 	struct throtl_grp *parent_tg = sq_to_tg(parent_sq);
 	struct throtl_grp *tg_to_put = NULL;
 	struct bio *bio;
+	bool rw = wl_to_rw(type);
 
 	/*
 	 * @bio is being transferred from @tg to @parent_sq.  Popping a bio
@@ -1142,8 +1176,8 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 	 * getting released prematurely.  Remember the tg to put and put it
 	 * after @bio is transferred to @parent_sq.
 	 */
-	bio = throtl_pop_queued(&sq->queued[rw], &tg_to_put);
-	sq->nr_queued[rw]--;
+	bio = throtl_pop_queued(&sq->queued[type], &tg_to_put);
+	sq->nr_queued[type]--;
 
 	throtl_charge_bio(tg, bio);
 
@@ -1155,13 +1189,13 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 	 * responsible for issuing these bios.
 	 */
 	if (parent_tg) {
-		throtl_add_bio_tg(bio, &tg->qnode_on_parent[rw], parent_tg);
+		throtl_add_bio_tg(bio, &tg->qnode_on_parent[type], parent_tg);
 		start_parent_slice_with_credit(tg, parent_tg, rw);
 	} else {
-		throtl_qnode_add_bio(bio, &tg->qnode_on_parent[rw],
-				     &parent_sq->queued[rw]);
-		BUG_ON(tg->td->nr_queued[rw] <= 0);
-		tg->td->nr_queued[rw]--;
+		throtl_qnode_add_bio(bio, &tg->qnode_on_parent[type],
+				     &parent_sq->queued[type]);
+		BUG_ON(tg->td->nr_queued[type] <= 0);
+		tg->td->nr_queued[type]--;
 	}
 
 	throtl_trim_slice(tg, rw);
@@ -1173,34 +1207,45 @@ static void tg_dispatch_one_bio(struct throtl_grp *tg, bool rw)
 static int throtl_dispatch_tg(struct throtl_grp *tg)
 {
 	struct throtl_service_queue *sq = &tg->service_queue;
-	unsigned int nr_reads = 0, nr_writes = 0;
+	unsigned int nr_reads = 0, nr_async_writes = 0, nr_sync_writes = 0;
 	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
-	unsigned int max_nr_writes = throtl_grp_quantum - max_nr_reads;
+	unsigned int max_sync_writes = (throtl_grp_quantum - max_nr_reads)*7/8;
+	unsigned int max_async_writes = throtl_grp_quantum - max_nr_reads
+					- max_sync_writes;
 	struct bio *bio;
 
 	/* Try to dispatch 75% READS and 25% WRITES */
-
-	while ((bio = throtl_peek_queued(&sq->queued[READ])) &&
+	while ((bio = throtl_peek_queued(&sq->queued[READ_WORKLOAD])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio));
+		tg_dispatch_one_bio(tg, READ_WORKLOAD);
 		nr_reads++;
 
 		if (nr_reads >= max_nr_reads)
 			break;
 	}
 
-	while ((bio = throtl_peek_queued(&sq->queued[WRITE])) &&
+	while ((bio = throtl_peek_queued(&sq->queued[SYNC_WRITE_WORKLOAD])) &&
 	       tg_may_dispatch(tg, bio, NULL)) {
 
-		tg_dispatch_one_bio(tg, bio_data_dir(bio));
-		nr_writes++;
+		tg_dispatch_one_bio(tg, SYNC_WRITE_WORKLOAD);
+		nr_sync_writes++;
 
-		if (nr_writes >= max_nr_writes)
+		if (nr_sync_writes >= max_sync_writes)
 			break;
 	}
 
-	return nr_reads + nr_writes;
+	while ((bio = throtl_peek_queued(&sq->queued[ASYNC_WRITE_WORKLOAD])) &&
+	       tg_may_dispatch(tg, bio, NULL)) {
+
+		tg_dispatch_one_bio(tg, ASYNC_WRITE_WORKLOAD);
+		nr_async_writes++;
+
+		if (nr_async_writes >= max_async_writes)
+			break;
+	}
+
+	return nr_reads + nr_sync_writes + nr_async_writes;
 }
 
 static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
@@ -1221,7 +1266,9 @@ static int throtl_select_dispatch(struct throtl_service_queue *parent_sq)
 
 		nr_disp += throtl_dispatch_tg(tg);
 
-		if (sq->nr_queued[0] || sq->nr_queued[1])
+		if (sq->nr_queued[READ_WORKLOAD] ||
+		    sq->nr_queued[SYNC_WRITE_WORKLOAD] ||
+		    sq->nr_queued[ASYNC_WRITE_WORKLOAD])
 			tg_update_disptime(tg);
 
 		if (nr_disp >= throtl_quantum)
@@ -1267,9 +1314,14 @@ static void throtl_pending_timer_fn(struct timer_list *t)
 	dispatched = false;
 
 	while (true) {
-		throtl_log(sq, "dispatch nr_queued=%u read=%u write=%u",
-			   sq->nr_queued[READ] + sq->nr_queued[WRITE],
-			   sq->nr_queued[READ], sq->nr_queued[WRITE]);
+		throtl_log(sq,
+			  "dispatch nr_queued=%u read=%u sync_write=%u async_write=%u",
+			   sq->nr_queued[READ_WORKLOAD] +
+			   sq->nr_queued[SYNC_WRITE_WORKLOAD] +
+			   sq->nr_queued[ASYNC_WRITE_WORKLOAD],
+			   sq->nr_queued[READ_WORKLOAD],
+			   sq->nr_queued[SYNC_WRITE_WORKLOAD],
+			   sq->nr_queued[ASYNC_WRITE_WORKLOAD]);
 
 		ret = throtl_select_dispatch(sq);
 		if (ret) {
@@ -1325,13 +1377,13 @@ static void blk_throtl_dispatch_work_fn(struct work_struct *work)
 	struct bio_list bio_list_on_stack;
 	struct bio *bio;
 	struct blk_plug plug;
-	int rw;
+	enum wl_type type;
 
 	bio_list_init(&bio_list_on_stack);
 
 	spin_lock_irq(q->queue_lock);
-	for (rw = READ; rw <= WRITE; rw++)
-		while ((bio = throtl_pop_queued(&td_sq->queued[rw], NULL)))
+	for (type = READ_WORKLOAD; type <= ASYNC_WRITE_WORKLOAD; type++)
+		while ((bio = throtl_pop_queued(&td_sq->queued[type], NULL)))
 			bio_list_add(&bio_list_on_stack, bio);
 	spin_unlock_irq(q->queue_lock);
 
@@ -1820,11 +1872,13 @@ static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
 	write_limit = tg->bps[WRITE][LIMIT_LOW] || tg->iops[WRITE][LIMIT_LOW];
 	if (!read_limit && !write_limit)
 		return true;
-	if (read_limit && sq->nr_queued[READ] &&
-	    (!write_limit || sq->nr_queued[WRITE]))
+	if (read_limit && sq->nr_queued[READ_WORKLOAD] &&
+	    (!write_limit || sq->nr_queued[SYNC_WRITE_WORKLOAD] ||
+			     sq->nr_queued[ASYNC_WRITE_WORKLOAD]))
 		return true;
-	if (write_limit && sq->nr_queued[WRITE] &&
-	    (!read_limit || sq->nr_queued[READ]))
+	if (write_limit && (sq->nr_queued[SYNC_WRITE_WORKLOAD] ||
+			    sq->nr_queued[ASYNC_WRITE_WORKLOAD]) &&
+	    (!read_limit || sq->nr_queued[READ_WORKLOAD]))
 		return true;
 
 	if (time_after_eq(jiffies,
@@ -2129,6 +2183,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 	struct throtl_grp *tg = blkg_to_tg(blkg ?: q->root_blkg);
 	struct throtl_service_queue *sq;
 	bool rw = bio_data_dir(bio);
+	enum wl_type type = bio_workload_type(bio);
 	bool throttled = false;
 	struct throtl_data *td = tg->td;
 
@@ -2157,7 +2212,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 		throtl_downgrade_check(tg);
 		throtl_upgrade_check(tg);
 		/* throtl is FIFO - if bios are already queued, should queue */
-		if (sq->nr_queued[rw])
+		if (sq->nr_queued[type])
 			break;
 
 		/* if above limits, break to queue */
@@ -2191,7 +2246,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 		 * Climb up the ladder.  If we''re already at the top, it
 		 * can be executed directly.
 		 */
-		qn = &tg->qnode_on_parent[rw];
+		qn = &tg->qnode_on_parent[type];
 		sq = sq->parent_sq;
 		tg = sq_to_tg(sq);
 		if (!tg)
@@ -2199,16 +2254,19 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 	}
 
 	/* out-of-limit, queue to @tg */
-	throtl_log(sq, "[%c] bio. bdisp=%llu sz=%u bps=%llu iodisp=%u iops=%u queued=%d/%d",
+	throtl_log(sq, "[%c] bio. bdisp=%llu sz=%u bps=%llu iodisp=%u "
+		   "iops=%u queued=%d/%d/%d",
 		   rw == READ ? 'R' : 'W',
 		   tg->bytes_disp[rw], bio->bi_iter.bi_size,
 		   tg_bps_limit(tg, rw),
 		   tg->io_disp[rw], tg_iops_limit(tg, rw),
-		   sq->nr_queued[READ], sq->nr_queued[WRITE]);
+		   sq->nr_queued[READ_WORKLOAD],
+		   sq->nr_queued[SYNC_WRITE_WORKLOAD],
+		   sq->nr_queued[ASYNC_WRITE_WORKLOAD]);
 
 	tg->last_low_overflow_time[rw] = jiffies;
 
-	td->nr_queued[rw]++;
+	td->nr_queued[type]++;
 	throtl_add_bio_tg(bio, qn, tg);
 	throttled = true;
 
@@ -2334,10 +2392,15 @@ static void tg_drain_bios(struct throtl_service_queue *parent_sq)
 
 		throtl_dequeue_tg(tg);
 
-		while ((bio = throtl_peek_queued(&sq->queued[READ])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
-		while ((bio = throtl_peek_queued(&sq->queued[WRITE])))
-			tg_dispatch_one_bio(tg, bio_data_dir(bio));
+		while ((bio =
+		      throtl_peek_queued(&sq->queued[READ_WORKLOAD])))
+			tg_dispatch_one_bio(tg, READ_WORKLOAD);
+		while ((bio =
+		      throtl_peek_queued(&sq->queued[SYNC_WRITE_WORKLOAD])))
+			tg_dispatch_one_bio(tg, SYNC_WRITE_WORKLOAD);
+		while ((bio =
+		      throtl_peek_queued(&sq->queued[ASYNC_WRITE_WORKLOAD])))
+			tg_dispatch_one_bio(tg, ASYNC_WRITE_WORKLOAD);
 	}
 }
 
@@ -2354,7 +2417,7 @@ void blk_throtl_drain(struct request_queue *q)
 	struct blkcg_gq *blkg;
 	struct cgroup_subsys_state *pos_css;
 	struct bio *bio;
-	int rw;
+	enum wl_type type;
 
 	queue_lockdep_assert_held(q);
 	rcu_read_lock();
@@ -2375,8 +2438,8 @@ void blk_throtl_drain(struct request_queue *q)
 	spin_unlock_irq(q->queue_lock);
 
 	/* all bios now should be in td->service_queue, issue them */
-	for (rw = READ; rw <= WRITE; rw++)
-		while ((bio = throtl_pop_queued(&td->service_queue.queued[rw],
+	for (type = READ_WORKLOAD; type <= ASYNC_WRITE_WORKLOAD; type++)
+		while ((bio = throtl_pop_queued(&td->service_queue.queued[type],
 						NULL)))
 			generic_make_request(bio);
 
-- 
1.8.3.1
