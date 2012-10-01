From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/15] cfq-ioschd: Give boost to higher prio/weight queues
Date: Mon,  1 Oct 2012 15:32:56 -0400
Message-ID: <1349119976-26837-16-git-send-email-vgoyal@redhat.com>
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

Though vdisktime based scheduling will take care of providng a queue
its fair share time of disk, the service differentiation between prio
levels is not as pronounced as with unpatched kernel. One of the reason
is that I got rid of cfq_slice_offset() logic which will do some
approximations to allow more than fair share of disk time to higher
prio queues.

This patch does intorduce a boost logic which provides vdisktime boost
to queues based on their weights. Higher the prio/weight, higher the
boost. So higher priority queues end up getting more than their fair
disk share.

I noticed another oddity during testing and that is that even I
provide higher disk slice to a queue, it does not seem to be doing
higher amount of IO. Somehow disk seems to slow down and delays the
completions of IO. Not sure how that can happen and how to tackle
that.

This arbitrary approximation is primarily there to provide bigger
service differentiation between various prio levels. I think we
should get rid of it when we merge queue and group scheduling logic.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7d1fa41..a2f7e8d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1641,12 +1641,45 @@ static u64 calc_st_last_entry_vdisktime(struct cfq_rb_root *st)
 		return st->min_vdisktime;
 }
 
+/*
+ * Give boost to a queue based on its ioprio. This is very approximate
+ * and arbitrary boost to give higher prio queues even greater share of
+ * disk than what they are entitled to based on their weight. So why
+ * to do this. Two reasons.
+ *
+ * - Provide more service differentation between queues and keep it inline
+ *   with exisitng logic.
+ *
+ * - vdisktime logic works only if we are idling on the queue. For SSD
+ *   we might skip idling and this logic will help to provide some kind
+ *   of service differentiation. Most of the time this will not help as
+ *   there are not enough processes doing IO. If SSD has deep queue depth,
+ *   readers will be blocked as their request is with driver/device and
+ *   there are not enough readers on service tree to create service
+ *   differentiation. So this might kick in only you have 32/64 or
+ *   greater processes doing IO.
+ *
+ * I think we should do away with this boost logic some day.
+ */
+static u64 calc_cfqq_vdisktime_boost(struct cfq_rb_root *st,
+			struct cfq_queue *cfqq)
+{
+	u64 spread;
+	unsigned int weight = cfq_prio_to_weight(cfqq->ioprio);
+
+	spread = calc_st_last_entry_vdisktime(st) - st->min_vdisktime;
+
+	/* divide 50% of spread in proportion to weight as boost */
+	return (spread * weight)/(2*CFQ_WEIGHT_MAX);
+}
+
 static u64 calc_cfqq_vdisktime(struct cfq_queue *cfqq, bool add_front,
 			bool new_cfqq, struct cfq_rb_root *old_st)
 {
 
 	unsigned int charge, unaccounted_sl = 0, weight;
 	struct cfq_rb_root *st;
+	u64 vdisktime, boost;
 
 	st = st_for(cfqq->cfqg, cfqq_class(cfqq), cfqq_type(cfqq));
 
@@ -1659,8 +1692,11 @@ static u64 calc_cfqq_vdisktime(struct cfq_queue *cfqq, bool add_front,
 		return st->min_vdisktime;
 
 	/* A new queue is being added. Just add it to end of service tree */
-	if (new_cfqq)
-		return calc_st_last_entry_vdisktime(st);
+	if (new_cfqq) {
+		vdisktime = calc_st_last_entry_vdisktime(st);
+		boost = calc_cfqq_vdisktime_boost(st, cfqq);
+		return max_t(u64, st->min_vdisktime, (vdisktime - boost));
+	}
 
 	/*
 	 * A queue is being requeued. If service tree has changed, then
@@ -1675,7 +1711,9 @@ static u64 calc_cfqq_vdisktime(struct cfq_queue *cfqq, bool add_front,
 	 */
 	weight = cfq_prio_to_weight(cfqq->ioprio);
 	charge = cfq_cfqq_slice_usage(cfqq, &unaccounted_sl);
-	return cfqq->vdisktime + cfq_scale_slice(charge, weight);
+	vdisktime = cfqq->vdisktime + cfq_scale_slice(charge, weight);
+	boost = calc_cfqq_vdisktime_boost(st, cfqq);
+	return max_t(u64, st->min_vdisktime, (vdisktime - boost));
 }
 
 static void __cfq_st_add(struct cfq_queue *cfqq, bool add_front)
-- 
1.7.7.6
