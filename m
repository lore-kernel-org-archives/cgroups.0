From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/15] cfq-iosched: More renaming to better represent wl_class and wl_type
Date: Mon,  1 Oct 2012 15:32:43 -0400
Message-ID: <1349119976-26837-3-git-send-email-vgoyal@redhat.com>
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

Some more renaming. Again making the code uniform w.r.t use of
wl_class/class to represent IO class (RT, BE, IDLE) and using
wl_type/type to represent subclass (SYNC, SYNC-IDLE, ASYNC).

At places this patch shortens the string "workload" to "wl". Also at
places I have got rid of keyword "serving" as it is obivious.

Again, just trying to increase uniformity and improve readability. No
functional change.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |   61 +++++++++++++++++++++++++--------------------------
 1 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9d44394..44ac479 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -248,9 +248,9 @@ struct cfq_group {
 	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
 
-	unsigned long saved_workload_slice;
-	enum wl_type_t saved_workload;
-	enum wl_class_t saved_serving_class;
+	unsigned long saved_wl_slice;
+	enum wl_type_t saved_wl_type;
+	enum wl_class_t saved_wl_class;
 
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
@@ -280,8 +280,8 @@ struct cfq_data {
 	/*
 	 * The priority currently being served
 	 */
-	enum wl_class_t serving_class;
-	enum wl_type_t serving_type;
+	enum wl_class_t wl_class;
+	enum wl_type_t wl_type;
 	unsigned long workload_expires;
 	struct cfq_group *serving_group;
 
@@ -1241,7 +1241,7 @@ cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfq_group_service_tree_del(st, cfqg);
-	cfqg->saved_workload_slice = 0;
+	cfqg->saved_wl_slice = 0;
 	cfqg_stats_update_dequeue(cfqg);
 }
 
@@ -1301,12 +1301,12 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	/* This group is being expired. Save the context */
 	if (time_after(cfqd->workload_expires, jiffies)) {
-		cfqg->saved_workload_slice = cfqd->workload_expires
+		cfqg->saved_wl_slice = cfqd->workload_expires
 						- jiffies;
-		cfqg->saved_workload = cfqd->serving_type;
-		cfqg->saved_serving_class = cfqd->serving_class;
+		cfqg->saved_wl_type = cfqd->wl_type;
+		cfqg->saved_wl_class = cfqd->wl_class;
 	} else
-		cfqg->saved_workload_slice = 0;
+		cfqg->saved_wl_slice = 0;
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
@@ -2030,7 +2030,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 {
 	if (cfqq) {
 		cfq_log_cfqq(cfqd, cfqq, "set_active wl_class:%d wl_type:%d",
-				cfqd->serving_class, cfqd->serving_type);
+				cfqd->wl_class, cfqd->wl_type);
 		cfqg_stats_update_avg_queue_size(cfqq->cfqg);
 		cfqq->slice_start = 0;
 		cfqq->dispatch_start = jiffies;
@@ -2117,8 +2117,8 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_group, cfqd->serving_class,
-					cfqd->serving_type);
+		service_tree_for(cfqd->serving_group, cfqd->wl_class,
+						cfqd->wl_type);
 
 	if (!cfqd->rq_queued)
 		return NULL;
@@ -2522,20 +2522,20 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	unsigned count;
 	struct cfq_rb_root *st;
 	unsigned group_slice;
-	enum wl_class_t original_class = cfqd->serving_class;
+	enum wl_class_t original_class = cfqd->wl_class;
 
 	/* Choose next priority. RT > BE > IDLE */
 	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_class = RT_WORKLOAD;
+		cfqd->wl_class = RT_WORKLOAD;
 	else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_class = BE_WORKLOAD;
+		cfqd->wl_class = BE_WORKLOAD;
 	else {
-		cfqd->serving_class = IDLE_WORKLOAD;
+		cfqd->wl_class = IDLE_WORKLOAD;
 		cfqd->workload_expires = jiffies + 1;
 		return;
 	}
 
-	if (original_class != cfqd->serving_class)
+	if (original_class != cfqd->wl_class)
 		goto new_workload;
 
 	/*
@@ -2543,7 +2543,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
 	 * expiration time
 	 */
-	st = service_tree_for(cfqg, cfqd->serving_class, cfqd->serving_type);
+	st = service_tree_for(cfqg, cfqd->wl_class, cfqd->wl_type);
 	count = st->count;
 
 	/*
@@ -2554,9 +2554,8 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 new_workload:
 	/* otherwise select new workload type */
-	cfqd->serving_type =
-		cfq_choose_wl(cfqd, cfqg, cfqd->serving_class);
-	st = service_tree_for(cfqg, cfqd->serving_class, cfqd->serving_type);
+	cfqd->wl_type = cfq_choose_wl(cfqd, cfqg, cfqd->wl_class);
+	st = service_tree_for(cfqg, cfqd->wl_class, cfqd->wl_type);
 	count = st->count;
 
 	/*
@@ -2567,11 +2566,11 @@ new_workload:
 	group_slice = cfq_group_slice(cfqd, cfqg);
 
 	slice = group_slice * count /
-		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_class],
-		      cfq_group_busy_queues_wl(cfqd->serving_class, cfqd,
+		max_t(unsigned, cfqg->busy_queues_avg[cfqd->wl_class],
+		      cfq_group_busy_queues_wl(cfqd->wl_class, cfqd,
 					cfqg));
 
-	if (cfqd->serving_type == ASYNC_WORKLOAD) {
+	if (cfqd->wl_type == ASYNC_WORKLOAD) {
 		unsigned int tmp;
 
 		/*
@@ -2617,10 +2616,10 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	cfqd->serving_group = cfqg;
 
 	/* Restore the workload type data */
-	if (cfqg->saved_workload_slice) {
-		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
-		cfqd->serving_type = cfqg->saved_workload;
-		cfqd->serving_class = cfqg->saved_serving_class;
+	if (cfqg->saved_wl_slice) {
+		cfqd->workload_expires = jiffies + cfqg->saved_wl_slice;
+		cfqd->wl_type = cfqg->saved_wl_type;
+		cfqd->wl_class = cfqg->saved_wl_class;
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
@@ -3403,7 +3402,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 		return true;
 
 	/* Allow preemption only if we are idling on sync-noidle tree */
-	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
+	if (cfqd->wl_type == SYNC_NOIDLE_WORKLOAD &&
 	    cfqq_type(new_cfqq) == SYNC_NOIDLE_WORKLOAD &&
 	    new_cfqq->service_tree->count == 2 &&
 	    RB_EMPTY_ROOT(&cfqq->sort_list))
@@ -3455,7 +3454,7 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * doesn't happen
 	 */
 	if (old_type != cfqq_type(cfqq))
-		cfqq->cfqg->saved_workload_slice = 0;
+		cfqq->cfqg->saved_wl_slice = 0;
 
 	/*
 	 * Put the new queue at the front of the of the current list,
-- 
1.7.7.6
