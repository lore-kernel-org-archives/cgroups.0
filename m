From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 01/15] cfq-iosched: Properly name all references to IO class
Date: Mon,  1 Oct 2012 15:32:42 -0400
Message-ID: <1349119976-26837-2-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com

Currently CFQ has three IO classes, RT, BE and IDLE. At many a places we
are calling workloads belonging to these classes as "prio". This gets
very confusing as one starts to associate it with ioprio.

So this patch just does bunch of renaming so that reading code becomes
easier. All reference to RT, BE and IDLE workload are done using keyword
"class" and all references to subclass, SYNC, SYNC-IDLE, ASYNC are made
using keyword "type".

This makes me feel much better while I am reading the code. There is no
functionality change due to this patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   67 ++++++++++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..9d44394 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -155,7 +155,7 @@ struct cfq_queue {
  * First index in the service_trees.
  * IDLE is handled separately, so it has negative index
  */
-enum wl_prio_t {
+enum wl_class_t {
 	BE_WORKLOAD = 0,
 	RT_WORKLOAD = 1,
 	IDLE_WORKLOAD = 2,
@@ -250,7 +250,7 @@ struct cfq_group {
 
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
-	enum wl_prio_t saved_serving_prio;
+	enum wl_class_t saved_serving_class;
 
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
@@ -280,7 +280,7 @@ struct cfq_data {
 	/*
 	 * The priority currently being served
 	 */
-	enum wl_prio_t serving_prio;
+	enum wl_class_t serving_class;
 	enum wl_type_t serving_type;
 	unsigned long workload_expires;
 	struct cfq_group *serving_group;
@@ -354,16 +354,16 @@ struct cfq_data {
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
-					    enum wl_prio_t prio,
+					    enum wl_class_t class,
 					    enum wl_type_t type)
 {
 	if (!cfqg)
 		return NULL;
 
-	if (prio == IDLE_WORKLOAD)
+	if (class == IDLE_WORKLOAD)
 		return &cfqg->service_tree_idle;
 
-	return &cfqg->service_trees[prio][type];
+	return &cfqg->service_trees[class][type];
 }
 
 enum cfqq_state_flags {
@@ -732,7 +732,7 @@ static inline bool iops_mode(struct cfq_data *cfqd)
 		return false;
 }
 
-static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
+static inline enum wl_class_t cfqq_class(struct cfq_queue *cfqq)
 {
 	if (cfq_class_idle(cfqq))
 		return IDLE_WORKLOAD;
@@ -751,16 +751,16 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
 	return SYNC_WORKLOAD;
 }
 
-static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
+static inline int cfq_group_busy_queues_wl(enum wl_class_t wl_class,
 					struct cfq_data *cfqd,
 					struct cfq_group *cfqg)
 {
-	if (wl == IDLE_WORKLOAD)
+	if (wl_class == IDLE_WORKLOAD)
 		return cfqg->service_tree_idle.count;
 
-	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
-		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
-		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
+	return cfqg->service_trees[wl_class][ASYNC_WORKLOAD].count
+		+ cfqg->service_trees[wl_class][SYNC_NOIDLE_WORKLOAD].count
+		+ cfqg->service_trees[wl_class][SYNC_WORKLOAD].count;
 }
 
 static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
@@ -1304,7 +1304,7 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		cfqg->saved_workload_slice = cfqd->workload_expires
 						- jiffies;
 		cfqg->saved_workload = cfqd->serving_type;
-		cfqg->saved_serving_prio = cfqd->serving_prio;
+		cfqg->saved_serving_class = cfqd->serving_class;
 	} else
 		cfqg->saved_workload_slice = 0;
 
@@ -1616,7 +1616,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	int left;
 	int new_cfqq = 1;
 
-	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
+	service_tree = service_tree_for(cfqq->cfqg, cfqq_class(cfqq),
 						cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
@@ -2029,8 +2029,8 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 				   struct cfq_queue *cfqq)
 {
 	if (cfqq) {
-		cfq_log_cfqq(cfqd, cfqq, "set_active wl_prio:%d wl_type:%d",
-				cfqd->serving_prio, cfqd->serving_type);
+		cfq_log_cfqq(cfqd, cfqq, "set_active wl_class:%d wl_type:%d",
+				cfqd->serving_class, cfqd->serving_type);
 		cfqg_stats_update_avg_queue_size(cfqq->cfqg);
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
@@ -2117,7 +2117,7 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
+		service_tree_for(cfqd->serving_group, cfqd->serving_class,
 					cfqd->serving_type);
 
 	if (!cfqd->rq_queued)
@@ -2284,7 +2284,7 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 
 static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
-	enum wl_prio_t prio = cfqq_prio(cfqq);
+	enum wl_class_t wl_class = cfqq_class(cfqq);
 	struct cfq_rb_root *service_tree = cfqq->service_tree;
 
 	BUG_ON(!service_tree);
@@ -2294,7 +2294,7 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		return false;
 
 	/* We never do for idle class queues. */
-	if (prio == IDLE_WORKLOAD)
+	if (wl_class == IDLE_WORKLOAD)
 		return false;
 
 	/* We do for queues that were marked with idle window flag. */
@@ -2494,7 +2494,7 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 }
 
 static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
-				struct cfq_group *cfqg, enum wl_prio_t prio)
+			struct cfq_group *cfqg, enum wl_class_t wl_class)
 {
 	struct cfq_queue *queue;
 	int i;
@@ -2504,7 +2504,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		/* select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(cfqg, prio, i));
+		queue = cfq_rb_first(service_tree_for(cfqg, wl_class, i));
 		if (queue &&
 		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
 			lowest_key = queue->rb_key;
@@ -2522,20 +2522,20 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	unsigned count;
 	struct cfq_rb_root *st;
 	unsigned group_slice;
-	enum wl_prio_t original_prio = cfqd->serving_prio;
+	enum wl_class_t original_class = cfqd->serving_class;
 
 	/* Choose next priority. RT > BE > IDLE */
 	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_prio = RT_WORKLOAD;
+		cfqd->serving_class = RT_WORKLOAD;
 	else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_prio = BE_WORKLOAD;
+		cfqd->serving_class = BE_WORKLOAD;
 	else {
-		cfqd->serving_prio = IDLE_WORKLOAD;
+		cfqd->serving_class = IDLE_WORKLOAD;
 		cfqd->workload_expires = jiffies + 1;
 		return;
 	}
 
-	if (original_prio != cfqd->serving_prio)
+	if (original_class != cfqd->serving_class)
 		goto new_workload;
 
 	/*
@@ -2543,7 +2543,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
 	 * expiration time
 	 */
-	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
+	st = service_tree_for(cfqg, cfqd->serving_class, cfqd->serving_type);
 	count = st->count;
 
 	/*
@@ -2555,8 +2555,8 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 new_workload:
 	/* otherwise select new workload type */
 	cfqd->serving_type =
-		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
-	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
+		cfq_choose_wl(cfqd, cfqg, cfqd->serving_class);
+	st = service_tree_for(cfqg, cfqd->serving_class, cfqd->serving_type);
 	count = st->count;
 
 	/*
@@ -2567,8 +2567,9 @@ new_workload:
 	group_slice = cfq_group_slice(cfqd, cfqg);
 
 	slice = group_slice * count /
-		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
-		      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
+		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_class],
+		      cfq_group_busy_queues_wl(cfqd->serving_class, cfqd,
+					cfqg));
 
 	if (cfqd->serving_type == ASYNC_WORKLOAD) {
 		unsigned int tmp;
@@ -2619,7 +2620,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	if (cfqg->saved_workload_slice) {
 		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
 		cfqd->serving_type = cfqg->saved_workload;
-		cfqd->serving_prio = cfqg->saved_serving_prio;
+		cfqd->serving_class = cfqg->saved_serving_class;
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
@@ -3644,7 +3645,7 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			service_tree = cfqq->service_tree;
 		else
 			service_tree = service_tree_for(cfqq->cfqg,
-				cfqq_prio(cfqq), cfqq_type(cfqq));
+				cfqq_class(cfqq), cfqq_type(cfqq));
 		service_tree->ttime.last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
-- 
1.7.7.6
