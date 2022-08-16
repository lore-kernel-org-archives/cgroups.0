From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next 3/3] block, bfq: remove useless parameter for bfq_add/del_bfqq_busy()
Date: Tue, 16 Aug 2022 09:56:31 +0800
Message-ID: <20220816015631.1323948-4-yukuai1@huaweicloud.com>
References: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

'bfqd' can be accessed through 'bfqq->bfqd', there is no need to pass
it as a parameter separately.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c | 8 ++++----
 block/bfq-iosched.h | 5 ++---
 block/bfq-wf2q.c    | 9 ++++++---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index f39067389b2b..7ea427817f7f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1925,7 +1925,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 	bfqq->service_from_backlogged = 0;
 	bfq_clear_bfqq_softrt_update(bfqq);
 
-	bfq_add_bfqq_busy(bfqd, bfqq);
+	bfq_add_bfqq_busy(bfqq);
 
 	/*
 	 * Expire in-service queue if preemption may be needed for
@@ -2419,7 +2419,7 @@ static void bfq_remove_request(struct request_queue *q,
 		bfqq->next_rq = NULL;
 
 		if (bfq_bfqq_busy(bfqq) && bfqq != bfqd->in_service_queue) {
-			bfq_del_bfqq_busy(bfqd, bfqq, false);
+			bfq_del_bfqq_busy(bfqq, false);
 			/*
 			 * bfqq emptied. In normal operation, when
 			 * bfqq is empty, bfqq->entity.service and
@@ -3098,7 +3098,7 @@ void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	 */
 	if (bfq_bfqq_busy(bfqq) && RB_EMPTY_ROOT(&bfqq->sort_list) &&
 	    bfqq != bfqd->in_service_queue)
-		bfq_del_bfqq_busy(bfqd, bfqq, false);
+		bfq_del_bfqq_busy(bfqq, false);
 
 	bfq_reassign_last_bfqq(bfqq, NULL);
 
@@ -3908,7 +3908,7 @@ static bool __bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 			 */
 			bfqq->budget_timeout = jiffies;
 
-		bfq_del_bfqq_busy(bfqd, bfqq, true);
+		bfq_del_bfqq_busy(bfqq, true);
 	} else {
 		bfq_requeue_bfqq(bfqd, bfqq, true);
 		/*
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index f81ab3c8fa3c..64ee618064ba 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1080,9 +1080,8 @@ void bfq_deactivate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 void bfq_activate_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		      bool expiration);
-void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-		       bool expiration);
-void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq);
+void bfq_del_bfqq_busy(struct bfq_queue *bfqq, bool expiration);
+void bfq_add_bfqq_busy(struct bfq_queue *bfqq);
 
 /* --------------- end of interface of B-WF2Q+ ---------------- */
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 983413cdefad..8fc3da4c23bb 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1651,9 +1651,10 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
  * the service tree. As a special case, it can be invoked during an
  * expiration.
  */
-void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
-		       bool expiration)
+void bfq_del_bfqq_busy(struct bfq_queue *bfqq, bool expiration)
 {
+	struct bfq_data *bfqd = bfqq->bfqd;
+
 	bfq_log_bfqq(bfqd, bfqq, "del from busy");
 
 	bfq_clear_bfqq_busy(bfqq);
@@ -1674,8 +1675,10 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 /*
  * Called when an inactive queue receives a new request.
  */
-void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
+void bfq_add_bfqq_busy(struct bfq_queue *bfqq)
 {
+	struct bfq_data *bfqd = bfqq->bfqd;
+
 	bfq_log_bfqq(bfqd, bfqq, "add to busy");
 
 	bfq_activate_bfqq(bfqd, bfqq);
-- 
2.31.1

