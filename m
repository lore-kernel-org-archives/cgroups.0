From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 10/15] cfq-get-rid-of-slice-offset-and-always-put-new-queue-at-the-end-2
Date: Mon,  1 Oct 2012 15:32:51 -0400
Message-ID: <1349119976-26837-11-git-send-email-vgoyal@redhat.com>
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

Currently cfq does round robin among cfqq and allocates bigger slices
to higher prio queue. But it also does additional logic of putting
higher priority queues ahead of lower priority queues in the service
tree. cfq_slice_offset() determines the postion of a queue in the
service tree.

I think it was done so that higher prio queues can get even higher
share of disk. As I am planning to move to vdisktime logic, this
does not fit anymore in to scheme of things. In the end of patch
series, I will introduce another approximation which provides vdisktime
boost based on weight. So that will kind of emulate this logic to
provide higher prio queues more than fair share of disk.

So this patch puts every new queue at the end of service tree by
default. Existing queues get their position in the tree depending
on how much slice did they use recently and what's their prio/weight.

This patch only introduces the functionality of adding queues at
the end of service tree. Later patches will introduce the functionality
of determining vdisktime (hence position in service tree) based on
slice used and weight.

If a queue is being requeued, then it will already be on service tree
and we can't determine the rb_key of last element using cfq_rb_last().
So we always remove the queue from service tree first.

This is just an intermediate patch to show clearly how I am chaning
existing functionality. Did not want to lump it together with bigger
patches.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   51 ++++++++++++++++++---------------------------------
 1 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 76f020f..bf2bc32 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1139,16 +1139,6 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_choose_req(cfqd, next, prev, blk_rq_pos(last));
 }
 
-static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
-				      struct cfq_queue *cfqq)
-{
-	/*
-	 * just an approximation, should be ok.
-	 */
-	return (cfqq->cfqg->nr_cfqq - 1) * (cfq_prio_slice(cfqd, 1, 0) -
-		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
-}
-
 static inline s64
 cfqg_key(struct cfq_rb_root *st, struct cfq_group *cfqg)
 {
@@ -1625,41 +1615,36 @@ static void cfq_st_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	bool new_cfqq = RB_EMPTY_NODE(&cfqq->rb_node);
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
-	if (cfq_class_idle(cfqq)) {
+
+	if (!new_cfqq) {
+		cfq_rb_erase(&cfqq->rb_node, cfqq->st);
+		cfqq->st = NULL;
+	}
+
+	if (!add_front) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&st->rb);
-		if (parent && parent != &cfqq->rb_node) {
+		if (parent) {
 			__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 			rb_key += __cfqq->rb_key;
 		} else
 			rb_key += jiffies;
-	} else if (!add_front) {
-		/*
-		 * Get our rb key offset. Subtract any residual slice
-		 * value carried from last service. A negative resid
-		 * count indicates slice overrun, and this should position
-		 * the next service time further away in the tree.
-		 */
-		rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
-		rb_key -= cfqq->slice_resid;
-		cfqq->slice_resid = 0;
+		if (!cfq_class_idle(cfqq)) {
+			/*
+			 * Subtract any residual slice * value carried from
+			 * last service. A negative resid count indicates
+			 * slice overrun, and this should position
+			 * the next service time further away in the tree.
+			 */
+			rb_key -= cfqq->slice_resid;
+			cfqq->slice_resid = 0;
+		}
 	} else {
 		rb_key = -HZ;
 		__cfqq = cfq_rb_first(st);
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
 	}
 
-	if (!new_cfqq) {
-		/*
-		 * same position, nothing more to do
-		 */
-		if (rb_key == cfqq->rb_key && cfqq->st == st)
-			return;
-
-		cfq_rb_erase(&cfqq->rb_node, cfqq->st);
-		cfqq->st = NULL;
-	}
-
 	left = 1;
 	parent = NULL;
 	cfqq->st = st;
-- 
1.7.7.6
