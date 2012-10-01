From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/15] cfq-iosced: Do the round robin selection of workload type
Date: Mon,  1 Oct 2012 15:32:48 -0400
Message-ID: <1349119976-26837-8-git-send-email-vgoyal@redhat.com>
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

We have three subclass of workloads (SYNC_NODILE, SYNC and ASYNC) for
prio class RT and BE. And cfq needs to select a workload to dispatch
from before it selects a cfqq.

Current workload selection seems to be selecting a workload which has
the lowest key for a cfqq. So effectively all three service tree are
kind of related using that cfqq->rb_key. And that cfqq->rb_key is
influenced by time (apart from other factors). So basically service
tree keys are influenced by time of queuing as well as prio of queue
and service trees are related.

I want to change the workload selection logic a bit for following
reason.

I am moving away from the notion of time for rb_key. The reason
being that I am bringing queue scheduling logic closer to group
scheduling logic where every service tree keeps track of virtual
time (vdisktime) based on disk share used by that group.

That means we can't use real time on queue service tree. And that
also means that virtual time of every service tree will move
independently and I can't use current logic of workload selection
which assumes that cfqq->rb_key of all three service tree are
co-related.

I think one simple way to select workload is do the round robin
among active workloads. That way each workload gets it fair share.
(Though we override that later by allowing preemption of of async
queue by sync queue).

In case a group is freshly queued, we always start with sync-noidle
workload first as that seems to be most important.

So making this change allows us to bring closer to group scheduling
logic, simplifies the workload selection logic and makes the workload
selection more predictable. I am not expecting any serious adverse effects
of this change.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |   51 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 619c680..7a65e12 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -166,9 +166,10 @@ enum wl_class_t {
  * Second index in the service_trees.
  */
 enum wl_type_t {
-	ASYNC_WORKLOAD = 0,
-	SYNC_NOIDLE_WORKLOAD = 1,
-	SYNC_WORKLOAD = 2
+	SYNC_NOIDLE_WORKLOAD = 0,
+	SYNC_WORKLOAD = 1,
+	ASYNC_WORKLOAD = 2,
+	WL_TYPE_NR,
 };
 
 struct cfqg_stats {
@@ -248,10 +249,14 @@ struct cfq_group {
 	struct cfq_rb_root sts[2][3];
 	struct cfq_rb_root st_idle;
 
+	/* Saved state when group is scheduled out */
 	unsigned long saved_wl_slice;
 	enum wl_type_t saved_wl_type;
 	enum wl_class_t saved_wl_class;
 
+	/* Last workload type chosen to run in this group */
+	enum wl_type_t last_run_wl_type;
+
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 	struct cfq_ttime ttime;
@@ -703,7 +708,7 @@ static inline void cfqg_stats_update_completion(struct cfq_group *cfqg,
 	for (i = 0; i <= IDLE_WORKLOAD; i++) \
 		for (j = 0, st = i < IDLE_WORKLOAD ? &cfqg->sts[i][j]\
 			: &cfqg->st_idle; \
-			(i < IDLE_WORKLOAD && j <= SYNC_WORKLOAD) || \
+			(i < IDLE_WORKLOAD && j < WL_TYPE_NR) || \
 			(i == IDLE_WORKLOAD && j == 0); \
 			j++, st = i < IDLE_WORKLOAD ? \
 			&cfqg->sts[i][j]: NULL) \
@@ -1243,6 +1248,7 @@ cfq_group_notify_queue_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
 	cfq_group_st_del(st, cfqg);
 	cfqg->saved_wl_slice = 0;
+	cfqg->last_run_wl_type = WL_TYPE_NR;
 	cfqg_stats_update_dequeue(cfqg);
 }
 
@@ -1336,6 +1342,7 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
 	RB_CLEAR_NODE(&cfqg->rb_node);
 
 	cfqg->ttime.last_end_request = jiffies;
+	cfqg->last_run_wl_type = WL_TYPE_NR;
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
@@ -2486,27 +2493,33 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
+static inline enum wl_type_t next_wl_type(enum wl_type_t wl_type)
+{
+	wl_type++;
+	if (wl_type >= WL_TYPE_NR)
+		wl_type = 0;
+	return wl_type;
+}
+
 static enum wl_type_t cfq_choose_wl_type(struct cfq_data *cfqd,
 			struct cfq_group *cfqg, enum wl_class_t wl_class)
 {
-	struct cfq_queue *queue;
+	enum wl_type_t new_wl_type, old_wl_type;
+	struct cfq_rb_root *st;
 	int i;
-	bool key_valid = false;
-	unsigned long lowest_key = 0;
-	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
-
-	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
-		/* select the one with lowest rb_key */
-		queue = cfq_rb_first(st_for(cfqg, wl_class, i));
-		if (queue &&
-		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
-			lowest_key = queue->rb_key;
-			cur_best = i;
-			key_valid = true;
-		}
+
+	old_wl_type = cfqg->last_run_wl_type;
+
+	for (i = 0; i < WL_TYPE_NR; i++) {
+		new_wl_type = next_wl_type(old_wl_type);
+		st = st_for(cfqg, wl_class, new_wl_type);
+		if (st->count)
+			break;
+		old_wl_type = new_wl_type;
 	}
 
-	return cur_best;
+	cfqg->last_run_wl_type = new_wl_type;
+	return new_wl_type;
 }
 
 static void
-- 
1.7.7.6
