From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 13/15] cfq-iosched: Use same scheduling algorithm for groups and queues
Date: Mon,  1 Oct 2012 15:32:54 -0400
Message-ID: <1349119976-26837-14-git-send-email-vgoyal@redhat.com>
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

Ok, finally, this patch introduces the notion of vdisktime for queues
and uses same scheduling algorithm for queues as groups.

It does not merge the two code paths yet, but philosophy of scheduling
is same. Once this gets stablized, then we will require some more
changes to the code to actually share the scheduling code between
queue and groups.

One important change here is mapping of io priority to weights. Current
prio levels 0-7 are mapped over weight range 1000-1, as follows.

prio	  0     1    2    3    4   5    6    7
weight	 1000  875  750  625  500 375  250  125

Now ideally the ratio of disk share between prio 0 and 7 should
be 8 (1000/125). That is prio 0 task gets 8 times the disk share
of prio 7 task.

This patch does treat queue and groups at same level. Existing scheme
of flat hierarchy continues. This series is just preparing CFQ for
more changes.

After this patch, CFQ queues get disk time share in proportion to
their prio/weight. One interesting observation is that some queues
do not do higher amount of IO despite getting higher share of disk
time. Looking at blktrace, it looks as if disk slows down and completion
time goes up if a single queue if running for long. Not sure what to
do about it. May be it is just my hardware.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  154 ++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 115 insertions(+), 39 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8912051..732e465 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -105,7 +105,7 @@ struct cfq_queue {
 	/* service_tree member */
 	struct rb_node rb_node;
 	/* service_tree key */
-	unsigned long rb_key;
+	u64 vdisktime;
 	/* prio tree member */
 	struct rb_node p_node;
 	/* prio tree root we belong to, if any */
@@ -355,6 +355,18 @@ struct cfq_data {
 	unsigned long last_delayed_sync;
 };
 
+/*
+ * Map cfqq prio to weights.
+ * Prio 0-7 is mapped to weight range 0 - CFQ_WEIGHT_MAX
+ */
+static inline int cfq_prio_to_weight(unsigned short ioprio)
+{
+	unsigned int weight;
+
+	weight = (CFQ_WEIGHT_MAX * (IOPRIO_BE_NR-ioprio))/IOPRIO_BE_NR;
+	return weight;
+}
+
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
 static struct cfq_rb_root *st_for(struct cfq_group *cfqg,
@@ -843,10 +855,12 @@ static inline int cfq_prio_slice(struct cfq_data *cfqd, bool sync,
 				 unsigned short prio)
 {
 	const int base_slice = cfqd->cfq_slice[sync];
+	unsigned int weight = cfq_prio_to_weight(prio);
 
 	WARN_ON(prio >= IOPRIO_BE_NR);
 
-	return base_slice + (base_slice/CFQ_SLICE_SCALE * (4 - prio));
+	/* scale base slice according to proportionate weight */
+	return (2 * base_slice * weight)/CFQ_WEIGHT_MAX;
 }
 
 static inline int
@@ -882,7 +896,7 @@ static inline u64 min_vdisktime(u64 min_vdisktime, u64 vdisktime)
 	return min_vdisktime;
 }
 
-static void update_min_vdisktime(struct cfq_rb_root *st)
+static void update_min_vdisktime_group(struct cfq_rb_root *st)
 {
 	struct cfq_group *cfqg;
 
@@ -893,6 +907,17 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
 	}
 }
 
+static void update_min_vdisktime_queue(struct cfq_rb_root *st)
+{
+	struct cfq_queue *cfqq;
+
+	if (st->left) {
+		cfqq = rb_entry(st->left, struct cfq_queue, rb_node);
+		st->min_vdisktime = max_vdisktime(st->min_vdisktime,
+						  cfqq->vdisktime);
+	}
+}
+
 /*
  * get averaged number of queues of RT/BE priority.
  * average is updated, with a formula that gives more weight to higher numbers,
@@ -1143,6 +1168,11 @@ cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
 	return cfqg->vdisktime - st->min_vdisktime;
 }
+static inline s64
+cfqq_key(struct cfq_rb_root *st, struct cfq_queue *cfqq)
+{
+	return cfqq->vdisktime - st->min_vdisktime;
+}
 
 static void __cfq_group_st_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
@@ -1598,54 +1628,73 @@ cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
 
 #endif /* GROUP_IOSCHED */
 
-/*
- * The cfqd->st holds all pending cfq_queue's that have
- * requests waiting to be processed. It is sorted in the order that
- * we will service the queues.
- */
-static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-				 bool add_front)
+static u64 calc_st_last_entry_vdisktime(struct cfq_rb_root *st)
 {
-	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
-	unsigned long rb_key;
+	struct rb_node *parent;
+
+	parent = rb_last(&st->rb);
+	if (parent) {
+		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+		return (__cfqq->vdisktime + CFQ_IDLE_DELAY);
+	} else
+		return st->min_vdisktime;
+}
+
+static u64 calc_cfqq_vdisktime(struct cfq_queue *cfqq, bool add_front,
+			bool new_cfqq, struct cfq_rb_root *old_st)
+{
+
+	unsigned int charge, unaccounted_sl = 0, weight;
 	struct cfq_rb_root *st;
-	int left;
-	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 
-	if (!new_cfqq) {
-		cfq_rb_erase(&cfqq->rb_node, cfqq->st);
-		cfqq->st = NULL;
-	}
+	/*
+	 * This queue is being added to the front. This is overriding
+	 * fairness algorithm so charging for disk time does not make
+	 * any difference
+	 */
+	if (add_front)
+		return st->min_vdisktime;
 
-	if (!add_front) {
-		rb_key = CFQ_IDLE_DELAY;
-		parent = rb_last(&st->rb);
-		if (parent) {
-			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
-			rb_key += __cfqq->rb_key;
-		} else
-			rb_key += jiffies;
-	} else {
-		rb_key = -HZ;
-		__cfqq = cfq_rb_first(st);
-		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
-	}
+	/* A new queue is being added. Just add it to end of service tree */
+	if (new_cfqq)
+		return calc_st_last_entry_vdisktime(st);
+
+	/*
+	 * A queue is being requeued. If service tree has changed, then
+	 * just put the queue at the end of current entries.
+	 * */
+	if (st != old_st)
+		return calc_st_last_entry_vdisktime(st);
+
+	/*
+	 * A cfqq is being requeued on same st. Charge the amount of slice
+	 * used
+	 */
+	weight = cfq_prio_to_weight(cfqq->ioprio);
+	charge = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
+	return cfqq->vdisktime + cfq_scale_slice(charge, weight);
+}
+
+static void __cfq_st_add(struct cfq_queue *cfqq, bool add_front)
+{
+	int left;
+	struct cfq_rb_root *st = cfqq->st;
+	struct rb_node **p, *parent;
+	struct cfq_queue *__cfqq;
+	s64 key = cfqq_key(st, cfqq);
 
 	left = 1;
 	parent = NULL;
-	cfqq->st = st;
 	p = &st->rb.rb_node;
 	while (*p) {
 		parent = *p;
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
-		/*
-		 * sort by key, that represents service time.
-		 */
-		if (time_before(rb_key, __cfqq->rb_key))
+		if (key < cfqq_key(st, __cfqq) ||
+		    ((add_front == true) && key == cfqq_key(st, __cfqq)))
 			p = &parent->rb_left;
 		else {
 			p = &parent->rb_right;
@@ -1656,10 +1705,34 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (left)
 		st->left = &cfqq->rb_node;
 
-	cfqq->rb_key = rb_key;
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &st->rb);
 	st->count++;
+}
+
+/*
+ * The cfqd->st holds all pending cfq_queue's that have
+ * requests waiting to be processed. It is sorted in the order that
+ * we will service the queues.
+ */
+static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+				 bool add_front)
+{
+	struct cfq_rb_root *st, *old_st;
+	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
+
+	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
+	old_st = cfqq->st;
+
+	if (!new_cfqq) {
+		cfq_rb_erase(&cfqq->rb_node, cfqq->st);
+		cfqq->st = NULL;
+	}
+
+	cfqq->vdisktime = calc_cfqq_vdisktime(cfqq, add_front, new_cfqq,
+							old_st);
+	cfqq->st = st;
+	__cfq_st_add(cfqq, add_front);
 	if (add_front || !new_cfqq)
 		return;
 	cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
@@ -2081,6 +2154,7 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *st =
 		st_for(cfqd->serving_group, cfqd->wl_class, cfqd->wl_type);
+	struct cfq_queue *cfqq;
 
 	if (!cfqd->rq_queued)
 		return NULL;
@@ -2090,7 +2164,9 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		return NULL;
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
-	return cfq_rb_first(st);
+	cfqq = cfq_rb_first(st);
+	update_min_vdisktime_queue(st);
+	return cfqq;
 }
 
 static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
@@ -2572,7 +2648,7 @@ static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 	if (RB_EMPTY_ROOT(&st->rb))
 		return NULL;
 	cfqg = cfq_rb_first_group(st);
-	update_min_vdisktime(st);
+	update_min_vdisktime_group(st);
 	return cfqg;
 }
 
-- 
1.7.7.6
