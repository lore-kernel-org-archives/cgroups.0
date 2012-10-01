From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/15] cfq-iosched: put cooperating queue at the front of service tree
Date: Mon,  1 Oct 2012 15:32:53 -0400
Message-ID: <1349119976-26837-13-git-send-email-vgoyal@redhat.com>
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

Currently during select_queue(), if a cfqq runs out of requests, cfq
checks if there is a cooperating queue doing IO nearby. If yes, it
lets that queue run out of turn.

But while doing so, CFQ does not put that queue at the front of service
tree and select it. It just forces it to be active queue.

This will not play very nice with new algorithm where we keep track
of min_vdisktime on service tree and always select first queue on
the service tree to run.

So instead of force setting active queue, put desired cooperating
queue at the front of service tree (like preemption), and then
go through get_next_cfqq() to select first queue on service tree.

So end result still remains the same, just that this method will
play better with new algorithm.

Signed-off-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/cfq-iosched.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a2016f5..8912051 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2116,12 +2116,11 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 /*
  * Get and set a new active queue for service.
  */
-static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
-					      struct cfq_queue *cfqq)
+static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
 {
-	if (!cfqq)
-		cfqq = cfq_get_next_queue(cfqd);
+	struct cfq_queue *cfqq;
 
+	cfqq = cfq_get_next_queue(cfqd);
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -2651,6 +2650,12 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 */
 	new_cfqq = cfq_close_cooperator(cfqd, cfqq);
 	if (new_cfqq) {
+		/*
+		 * This close cooperator queue will be selected next. Put
+		 * it at the front of servie tree and then go through normal
+		 * get_next_queue() logic.
+		 */
+		cfq_st_add(cfqd, new_cfqq, 1);
 		if (!cfqq->new_cfqq)
 			cfq_setup_merge(cfqq, new_cfqq);
 		goto expire;
@@ -2704,7 +2709,7 @@ new_queue:
 	if (!new_cfqq)
 		cfq_choose_cfqg(cfqd);
 
-	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
+	cfqq = cfq_set_active_queue(cfqd);
 keep_queue:
 	return cfqq;
 }
-- 
1.7.7.6
