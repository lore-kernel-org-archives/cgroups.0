From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
Date: Mon,  1 Oct 2012 15:32:44 -0400
Message-ID: <1349119976-26837-4-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

At quite a few places we use the keyword "service_tree" and I feel that
names in CFQ are already very long and they need to be shortened a bit
where appropriate.

So this patch just renames "service_tree" to "st" at most of the places.
No functionality change.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |  153 ++++++++++++++++++++++++--------------------------
 1 files changed, 73 insertions(+), 80 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 44ac479..5eb3ed2 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -144,7 +144,7 @@ struct cfq_queue {
 	u32 seek_history;
 	sector_t last_request_pos;
 
-	struct cfq_rb_root *service_tree;
+	struct cfq_rb_root *st;
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	/* Number of sectors dispatched from queue in single dispatch round */
@@ -245,8 +245,8 @@ struct cfq_group {
 	 * a single tree service_tree_idle.
 	 * Counts are embedded in the cfq_rb_root
 	 */
-	struct cfq_rb_root service_trees[2][3];
-	struct cfq_rb_root service_tree_idle;
+	struct cfq_rb_root sts[2][3];
+	struct cfq_rb_root st_idle;
 
 	unsigned long saved_wl_slice;
 	enum wl_type_t saved_wl_type;
@@ -274,7 +274,7 @@ struct cfq_io_cq {
 struct cfq_data {
 	struct request_queue *queue;
 	/* Root service tree for cfq_groups */
-	struct cfq_rb_root grp_service_tree;
+	struct cfq_rb_root grp_st;
 	struct cfq_group *root_group;
 
 	/*
@@ -353,7 +353,7 @@ struct cfq_data {
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
-static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
+static struct cfq_rb_root *st_for(struct cfq_group *cfqg,
 					    enum wl_class_t class,
 					    enum wl_type_t type)
 {
@@ -361,9 +361,9 @@ static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
 		return NULL;
 
 	if (class == IDLE_WORKLOAD)
-		return &cfqg->service_tree_idle;
+		return &cfqg->st_idle;
 
-	return &cfqg->service_trees[class][type];
+	return &cfqg->sts[class][type];
 }
 
 enum cfqq_state_flags {
@@ -697,12 +697,12 @@ static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 /* Traverses through cfq group service trees */
 #define for_each_cfqg_st(cfqg, i, j, st) \
 	for (i = 0; i <= IDLE_WORKLOAD; i++) \
-		for (j = 0, st = i < IDLE_WORKLOAD ? &cfqg->service_trees[i][j]\
-			: &cfqg->service_tree_idle; \
+		for (j = 0, st = i < IDLE_WORKLOAD ? &cfqg->sts[i][j]\
+			: &cfqg->st_idle; \
 			(i < IDLE_WORKLOAD && j <= SYNC_WORKLOAD) || \
 			(i == IDLE_WORKLOAD && j == 0); \
 			j++, st = i < IDLE_WORKLOAD ? \
-			&cfqg->service_trees[i][j]: NULL) \
+			&cfqg->sts[i][j]: NULL) \
 
 static inline bool cfq_io_thinktime_big(struct cfq_data *cfqd,
 	struct cfq_ttime *ttime, bool group_idle)
@@ -756,18 +756,18 @@ static inline int cfq_group_busy_queues_wl(enum wl_class_t wl_class,
 					struct cfq_group *cfqg)
 {
 	if (wl_class == IDLE_WORKLOAD)
-		return cfqg->service_tree_idle.count;
+		return cfqg->st_idle.count;
 
-	return cfqg->service_trees[wl_class][ASYNC_WORKLOAD].count
-		+ cfqg->service_trees[wl_class][SYNC_NOIDLE_WORKLOAD].count
-		+ cfqg->service_trees[wl_class][SYNC_WORKLOAD].count;
+	return cfqg->sts[wl_class][ASYNC_WORKLOAD].count
+		+ cfqg->sts[wl_class][SYNC_NOIDLE_WORKLOAD].count
+		+ cfqg->sts[wl_class][SYNC_WORKLOAD].count;
 }
 
 static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 					struct cfq_group *cfqg)
 {
-	return cfqg->service_trees[RT_WORKLOAD][ASYNC_WORKLOAD].count
-		+ cfqg->service_trees[BE_WORKLOAD][ASYNC_WORKLOAD].count;
+	return cfqg->sts[RT_WORKLOAD][ASYNC_WORKLOAD].count
+		+ cfqg->sts[BE_WORKLOAD][ASYNC_WORKLOAD].count;
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
@@ -909,7 +909,7 @@ static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_st;
 
 	return cfqd->cfq_target_latency * cfqg->weight / st->total_weight;
 }
@@ -1146,8 +1146,7 @@ cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
 	return cfqg->vdisktime - st->min_vdisktime;
 }
 
-static void
-__cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+static void __cfq_group_st_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	struct rb_node **node = &st->rb.rb_node;
 	struct rb_node *parent = NULL;
@@ -1184,20 +1183,19 @@ cfq_update_group_weight(struct cfq_group *cfqg)
 	}
 }
 
-static void
-cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
+static void cfq_group_st_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	BUG_ON(!RB_EMPTY_NODE(&cfqg->rb_node));
 
 	cfq_update_group_weight(cfqg);
-	__cfq_group_service_tree_add(st, cfqg);
+	__cfq_group_st_add(st, cfqg);
 	st->total_weight += cfqg->weight;
 }
 
 static void
 cfq_group_notify_queue_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_st;
 	struct cfq_group *__cfqg;
 	struct rb_node *n;
 
@@ -1216,11 +1214,10 @@ cfq_group_notify_queue_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
 	} else
 		cfqg->vdisktime = st->min_vdisktime;
-	cfq_group_service_tree_add(st, cfqg);
+	cfq_group_st_add(st, cfqg);
 }
 
-static void
-cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
+static void cfq_group_st_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
@@ -1230,7 +1227,7 @@ cfq_group_service_tree_del(struct cfq_rb_root *st, struct cfq_group *cfqg)
 static void
 cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_st;
 
 	BUG_ON(cfqg->nr_cfqq < 1);
 	cfqg->nr_cfqq--;
@@ -1240,7 +1237,7 @@ cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
-	cfq_group_service_tree_del(st, cfqg);
+	cfq_group_st_del(st, cfqg);
 	cfqg->saved_wl_slice = 0;
 	cfqg_stats_update_dequeue(cfqg);
 }
@@ -1280,10 +1277,10 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq,
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_st;
 	unsigned int used_sl, charge, unaccounted_sl = 0;
 	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
-			- cfqg->service_tree_idle.count;
+			- cfqg->st_idle.count;
 
 	BUG_ON(nr_sync < 0);
 	used_sl = charge = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
@@ -1294,10 +1291,10 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		charge = cfqq->allocated_slice;
 
 	/* Can't update vdisktime while group is on service tree */
-	cfq_group_service_tree_del(st, cfqg);
+	cfq_group_st_del(st, cfqg);
 	cfqg->vdisktime += cfq_scale_slice(charge, cfqg);
 	/* If a new weight was requested, update now, off tree */
-	cfq_group_service_tree_add(st, cfqg);
+	cfq_group_st_add(st, cfqg);
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
@@ -1602,25 +1599,24 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 #endif /* GROUP_IOSCHED */
 
 /*
- * The cfqd->service_trees holds all pending cfq_queue's that have
+ * The cfqd->st holds all pending cfq_queue's that have
  * requests waiting to be processed. It is sorted in the order that
  * we will service the queues.
  */
-static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 				 bool add_front)
 {
 	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
 	unsigned long rb_key;
-	struct cfq_rb_root *service_tree;
+	struct cfq_rb_root *st;
 	int left;
 	int new_cfqq = 1;
 
-	service_tree = service_tree_for(cfqq->cfqg, cfqq_class(cfqq),
-						cfqq_type(cfqq));
+	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&service_tree->rb);
+		parent = rb_last(&st->rb);
 		if (parent && parent != &cfqq->rb_node) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
@@ -1638,7 +1634,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqq->slice_resid = 0;
 	} else {
 		rb_key = -HZ;
-		__cfqq = cfq_rb_first(service_tree);
+		__cfqq = cfq_rb_first(st);
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
@@ -1647,18 +1643,17 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/*
 		 * same position, nothing more to do
 		 */
-		if (rb_key == cfqq->rb_key &&
-		    cfqq->service_tree == service_tree)
+		if (rb_key == cfqq->rb_key && cfqq->st == st)
 			return;
 
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
+		cfq_rb_erase(&cfqq->rb_node, cfqq->st);
+		cfqq->st = NULL;
 	}
 
 	left = 1;
 	parent = NULL;
-	cfqq->service_tree = service_tree;
-	p = &service_tree->rb.rb_node;
+	cfqq->st = st;
+	p = &st->rb.rb_node;
 	while (*p) {
 		struct rb_node **n;
 
@@ -1679,12 +1674,12 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 
 	if (left)
-		service_tree->left = &cfqq->rb_node;
+		st->left = &cfqq->rb_node;
 
 	cfqq->rb_key = rb_key;
 	rb_link_node(&cfqq->rb_node, parent, p);
-	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
-	service_tree->count++;
+	rb_insert_color(&cfqq->rb_node, &st->rb);
+	st->count++;
 	if (add_front || !new_cfqq)
 		return;
 	cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
@@ -1760,7 +1755,7 @@ static void cfq_resort_rr_list(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Resorting requires the cfqq to be on the RR list already.
 	 */
 	if (cfq_cfqq_on_rr(cfqq)) {
-		cfq_service_tree_add(cfqd, cfqq, 0);
+		cfq_st_add(cfqd, cfqq, 0);
 		cfq_prio_tree_add(cfqd, cfqq);
 	}
 }
@@ -1792,8 +1787,8 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_clear_cfqq_on_rr(cfqq);
 
 	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
-		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
-		cfqq->service_tree = NULL;
+		cfq_rb_erase(&cfqq->rb_node, cfqq->st);
+		cfqq->st = NULL;
 	}
 	if (cfqq->p_root) {
 		rb_erase(&cfqq->p_node, cfqq->p_root);
@@ -2116,19 +2111,18 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
  */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_group, cfqd->wl_class,
-						cfqd->wl_type);
+	struct cfq_rb_root *st =
+		st_for(cfqd->serving_group, cfqd->wl_class, cfqd->wl_type);
 
 	if (!cfqd->rq_queued)
 		return NULL;
 
 	/* There is nothing to dispatch */
-	if (!service_tree)
+	if (!st)
 		return NULL;
-	if (RB_EMPTY_ROOT(&service_tree->rb))
+	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	return cfq_rb_first(service_tree);
+	return cfq_rb_first(st);
 }
 
 static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
@@ -2285,10 +2279,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	enum wl_class_t wl_class = cfqq_class(cfqq);
-	struct cfq_rb_root *service_tree = cfqq->service_tree;
+	struct cfq_rb_root *st = cfqq->st;
 
-	BUG_ON(!service_tree);
-	BUG_ON(!service_tree->count);
+	BUG_ON(!st);
+	BUG_ON(!st->count);
 
 	if (!cfqd->cfq_slice_idle)
 		return false;
@@ -2306,11 +2300,10 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
-	   !cfq_io_thinktime_big(cfqd, &service_tree->ttime, false))
+	if (st->count == 1 && cfq_cfqq_sync(cfqq) &&
+	   !cfq_io_thinktime_big(cfqd, &st->ttime, false))
 		return true;
-	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
-			service_tree->count);
+	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d", st->count);
 	return false;
 }
 
@@ -2504,7 +2497,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		/* select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(cfqg, wl_class, i));
+		queue = cfq_rb_first(st_for(cfqg, wl_class, i));
 		if (queue &&
 		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
 			lowest_key = queue->rb_key;
@@ -2516,7 +2509,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 	return cur_best;
 }
 
-static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
+static void choose_st(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned slice;
 	unsigned count;
@@ -2543,7 +2536,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
 	 * expiration time
 	 */
-	st = service_tree_for(cfqg, cfqd->wl_class, cfqd->wl_type);
+	st = st_for(cfqg, cfqd->wl_class, cfqd->wl_type);
 	count = st->count;
 
 	/*
@@ -2555,7 +2548,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 new_workload:
 	/* otherwise select new workload type */
 	cfqd->wl_type = cfq_choose_wl(cfqd, cfqg, cfqd->wl_class);
-	st = service_tree_for(cfqg, cfqd->wl_class, cfqd->wl_type);
+	st = st_for(cfqg, cfqd->wl_class, cfqd->wl_type);
 	count = st->count;
 
 	/*
@@ -2599,7 +2592,7 @@ new_workload:
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_st;
 	struct cfq_group *cfqg;
 
 	if (RB_EMPTY_ROOT(&st->rb))
@@ -2623,7 +2616,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
-	choose_service_tree(cfqd, cfqg);
+	choose_st(cfqd, cfqg);
 }
 
 /*
@@ -3291,7 +3284,7 @@ cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 {
 	if (cfq_cfqq_sync(cfqq)) {
 		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
-		__cfq_update_io_thinktime(&cfqq->service_tree->ttime,
+		__cfq_update_io_thinktime(&cfqq->st->ttime,
 			cfqd->cfq_slice_idle);
 	}
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -3404,8 +3397,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	/* Allow preemption only if we are idling on sync-noidle tree */
 	if (cfqd->wl_type == SYNC_NOIDLE_WORKLOAD &&
 	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
-	    new_cfqq->service_tree->count == 2 &&
-	    RB_EMPTY_ROOT(&cfqq->sort_list))
+	    new_cfqq->st->count == 2 && RB_EMPTY_ROOT(&cfqq->sort_list))
 		return true;
 
 	/*
@@ -3462,7 +3454,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 */
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
 
-	cfq_service_tree_add(cfqd, cfqq, 1);
+	cfq_st_add(cfqd, cfqq, 1);
 
 	cfqq->slice_end = 0;
 	cfq_mark_cfqq_slice_new(cfqq);
@@ -3636,16 +3628,17 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
-		struct cfq_rb_root *service_tree;
+		struct cfq_rb_root *st;
 
 		RQ_CIC(rq)->ttime.last_end_request = now;
 
 		if (cfq_cfqq_on_rr(cfqq))
-			service_tree = cfqq->service_tree;
+			st = cfqq->st;
 		else
-			service_tree = service_tree_for(cfqq->cfqg,
-				cfqq_class(cfqq), cfqq_type(cfqq));
-		service_tree->ttime.last_end_request = now;
+			st = st_for(cfqq->cfqg, cfqq_class(cfqq),
+					cfqq_type(cfqq));
+
+		st->ttime.last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
 	}
@@ -3973,7 +3966,7 @@ static int cfq_init_queue(struct request_queue *q)
 	q->elevator->elevator_data = cfqd;
 
 	/* Init root service tree */
-	cfqd->grp_service_tree = CFQ_RB_ROOT;
+	cfqd->grp_st = CFQ_RB_ROOT;
 
 	/* Init root group and prefer root group over other groups by default */
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-- 
1.7.7.6
