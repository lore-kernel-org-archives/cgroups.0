From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/15] cfq-iosched: Wait for queue to get busy even if this is not last queue in group
Date: Mon,  1 Oct 2012 15:32:55 -0400
Message-ID: <1349119976-26837-15-git-send-email-vgoyal@redhat.com>
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

With new algorithm, to maintain fairness we need to make sure that queue
does not get deleted from tree at slice expiry. Otherwise when new
request comes in very shortly after deletion, queue gets queued at
the end of service tree.

In general it is not too much of a problem as we had scaled slice
length based on prio/weight scaling to begin with. But low_latency
logic might introduce some imperfections.

We intoroduced wait for queue to get backlogged logic already. Just
that we trigger it only when queue is last queue in the group (In
an attempt to provide group its fair share). Just extend same wait
busy logic to queue too.

Because this little extra wait happens only if we have been idling
all along on the queue, I am not expecting any serious impact of this
little extra idling.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 732e465..7d1fa41 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2685,7 +2685,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		return NULL;
 
 	/*
-	 * We were waiting for group to get backlogged. Expire the queue
+	 * We were waiting for queue to get backlogged. Expire the queue
 	 */
 	if (cfq_cfqq_wait_busy(cfqq) && !RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto expire;
@@ -2703,7 +2703,7 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		 * have been idling all along on this queue and it should be
 		 * ok to wait for this request to complete.
 		 */
-		if (cfqq->cfqg->nr_cfqq == 1 && RB_EMPTY_ROOT(&cfqq->sort_list)
+		if (RB_EMPTY_ROOT(&cfqq->sort_list)
 		    && cfqq->dispatched && cfq_should_idle(cfqd, cfqq)) {
 			cfqq = NULL;
 			goto keep_queue;
@@ -3631,10 +3631,6 @@ static bool cfq_should_wait_busy(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 		return false;
 
-	/* If there are other queues in the group, don't wait */
-	if (cfqq->cfqg->nr_cfqq > 1)
-		return false;
-
 	/* the only queue in the group, but think time is big */
 	if (cfq_io_thinktime_big(cfqd, &cfqq->cfqg->ttime, true))
 		return false;
-- 
1.7.7.6
