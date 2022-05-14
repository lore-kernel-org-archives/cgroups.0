From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 7/8] block, bfq: cleanup bfq_bfqq_update_budg_for_activation()
Date: Sat, 14 May 2022 17:05:21 +0800
Message-ID: <20220514090522.1669270-8-yukuai3@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

It will only be called from bfq_bfqq_handle_idle_busy_switch() in
specific code branch, there is no need to precaculate
'bfqq_wants_to_preempt' each time bfq_bfqq_handle_idle_busy_switch()
is caleld.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-iosched.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index e36a16684fb4..1e57d76c8dd3 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1555,10 +1555,11 @@ static int bfq_min_budget(struct bfq_data *bfqd)
  * responsibility of handling the above case 2.
  */
 static bool bfq_bfqq_update_budg_for_activation(struct bfq_data *bfqd,
-						struct bfq_queue *bfqq,
-						bool arrived_in_time)
+						struct bfq_queue *bfqq)
 {
 	struct bfq_entity *entity = &bfqq->entity;
+	bool arrived_in_time = ktime_get_ns() <= bfqq->ttime.last_end_request +
+			       bfqd->bfq_slice_idle * 3;
 
 	/*
 	 * In the next compound condition, we check also whether there
@@ -1567,7 +1568,7 @@ static bool bfq_bfqq_update_budg_for_activation(struct bfq_data *bfqd,
 	 * would be expired immediately after being selected for
 	 * service. This would only cause useless overhead.
 	 */
-	if (bfq_bfqq_non_blocking_wait_rq(bfqq) && arrived_in_time &&
+	if (arrived_in_time && bfq_bfqq_non_blocking_wait_rq(bfqq) &&
 	    bfq_bfqq_budget_left(bfqq) > 0) {
 		/*
 		 * We do not clear the flag non_blocking_wait_rq here, as
@@ -1768,17 +1769,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 					     bool *interactive)
 {
 	bool soft_rt, in_burst,	wr_or_deserves_wr,
-		bfqq_wants_to_preempt,
-		idle_for_long_time = bfq_bfqq_idle_for_long_time(bfqd, bfqq),
-		/*
-		 * See the comments on
-		 * bfq_bfqq_update_budg_for_activation for
-		 * details on the usage of the next variable.
-		 */
-		arrived_in_time =  ktime_get_ns() <=
-			bfqq->ttime.last_end_request +
-			bfqd->bfq_slice_idle * 3;
-
+		idle_for_long_time = bfq_bfqq_idle_for_long_time(bfqd, bfqq);
 
 	/*
 	 * bfqq deserves to be weight-raised if:
@@ -1816,14 +1807,6 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 		  (bfqq->bic || RQ_BIC(rq)->stably_merged) &&
 		   (*interactive || soft_rt)));
 
-	/*
-	 * Using the last flag, update budget and check whether bfqq
-	 * may want to preempt the in-service queue.
-	 */
-	bfqq_wants_to_preempt =
-		bfq_bfqq_update_budg_for_activation(bfqd, bfqq,
-						    arrived_in_time);
-
 	/*
 	 * If bfqq happened to be activated in a burst, but has been
 	 * idle for much more than an interactive queue, then we
@@ -1879,8 +1862,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 	 * guarantees or throughput. As for guarantees, we care
 	 * explicitly about two cases. The first is that bfqq has to
 	 * recover a service hole, as explained in the comments on
-	 * bfq_bfqq_update_budg_for_activation(), i.e., that
-	 * bfqq_wants_to_preempt is true. However, if bfqq does not
+	 * bfq_bfqq_update_budg_for_activation(). However, if bfqq does not
 	 * carry time-critical I/O, then bfqq's bandwidth is less
 	 * important than that of queues that carry time-critical I/O.
 	 * So, as a further constraint, we consider this case only if
@@ -1918,7 +1900,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 	 * (2) this switch of bfqq to busy changes the scenario.
 	 */
 	if (bfqd->in_service_queue &&
-	    ((bfqq_wants_to_preempt &&
+	    ((bfq_bfqq_update_budg_for_activation(bfqd, bfqq) &&
 	      bfqq->wr_coeff >= bfqd->in_service_queue->wr_coeff) ||
 	     bfq_bfqq_higher_class_or_weight(bfqq, bfqd->in_service_queue) ||
 	     !bfq_better_to_idle(bfqd->in_service_queue)) &&
-- 
2.31.1

