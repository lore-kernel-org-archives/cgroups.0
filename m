From: Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/2] block: Make refcnt of bfq_group/bfq_queue atomic
Date: Tue, 11 Oct 2022 22:52:46 +0800
Message-ID: <TYCP286MB2323F5B27A24ABA2CD1A3F70CA239@TYCP286MB2323.JPNP286.PROD.OUTLOOK.COM>
References: <20221011145246.8656-1-set_pte_at@outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo1Uyd5Cr+vUeOBgInoErdw02W2KCHswu/ahNGDjgQE=;
 b=PLSTtEFBXU+g/sB/Hz08I+spMOtWRF+JKQV9X9vBw75vIwu8D8ptarpxb9ZZe6ezwTn9wJM+Fe/wxTCg5SxnDy/iUyyX32ke9tvamzGDMLm9eYk4K+gz4fq1vfuOyDm/c7CCRH8SPZ1fwwdFMkrmblb42yYvaPhUmWNMu6klps3AvUjjQ0FGexDJz9SxNrvV4TGtiSWMNiIoPpe7+q/c8iq8ev1Rw6GrYhDg1Gfkg09HIy+6Bs9/F673oqPBuGC70BhBjd2NAl5l5JRtii2qsE2TDsnykdb7tQLxyl88EHiANJF0pX3KN8K7zFDgofgo7XPzYL1PKmWCdXq+wVB7LQ==
In-Reply-To: <20221011145246.8656-1-set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>

For most implementations of reference count, atomic_t is preferred
for their natural-born atomic ops capability.
Change the reference count of bfq_group/bfq_queue, both data structures
and related ops, into atomic.

Signed-off-by: Dawei Li <set_pte_at-1ViLX0X+lBJBDgjK7y7TUQ@public.gmane.org>
---
 block/bfq-cgroup.c  |  8 +++----
 block/bfq-iosched.c | 54 +++++++++++++++++++++++----------------------
 block/bfq-iosched.h |  6 ++---
 block/bfq-wf2q.c    |  6 ++---
 4 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 144bca006463..714126ba21b6 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -316,14 +316,12 @@ struct bfq_group *bfqq_group(struct bfq_queue *bfqq)
 
 static void bfqg_get(struct bfq_group *bfqg)
 {
-	bfqg->ref++;
+	atomic_inc(&bfqg->ref);
 }
 
 static void bfqg_put(struct bfq_group *bfqg)
 {
-	bfqg->ref--;
-
-	if (bfqg->ref == 0)
+	if (atomic_dec_and_test(&bfqg->ref))
 		kfree(bfqg);
 }
 
@@ -659,7 +657,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	 * Get extra reference to prevent bfqq from being freed in
 	 * next possible expire or deactivate.
 	 */
-	bfqq->ref++;
+	atomic_inc(&bfqq->ref);
 
 	/* If bfqq is empty, then bfq_bfqq_expire also invokes
 	 * bfq_del_bfqq_busy, thereby removing bfqq and its entity
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7ea427817f7f..fbe5624be71f 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -935,7 +935,7 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 inc_counter:
 	bfqq->weight_counter->num_active++;
-	bfqq->ref++;
+	atomic_inc(&bfqq->ref);
 }
 
 /*
@@ -1224,9 +1224,10 @@ bfq_bfqq_resume_state(struct bfq_queue *bfqq, struct bfq_data *bfqd,
 
 static int bfqq_process_refs(struct bfq_queue *bfqq)
 {
-	return bfqq->ref - bfqq->entity.allocated -
+	return atomic_read(&bfqq->ref) - bfqq->entity.allocated -
 		bfqq->entity.on_st_or_in_serv -
-		(bfqq->weight_counter != NULL) - bfqq->stable_ref;
+		(bfqq->weight_counter != NULL) -
+		atomic_read(&bfqq->stable_ref);
 }
 
 /* Empty burst list and add just bfqq (see comments on bfq_handle_burst) */
@@ -2818,7 +2819,7 @@ bfq_setup_merge(struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
 	 * expected to be associated with new_bfqq as they happen to
 	 * issue I/O.
 	 */
-	new_bfqq->ref += process_refs;
+	atomic_add(process_refs, &new_bfqq->ref);
 	return new_bfqq;
 }
 
@@ -5255,10 +5256,10 @@ void bfq_put_queue(struct bfq_queue *bfqq)
 	struct hlist_node *n;
 	struct bfq_group *bfqg = bfqq_group(bfqq);
 
-	bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d", bfqq, bfqq->ref);
+	bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d", bfqq,
+		     atomic_read(&bfqq->ref));
 
-	bfqq->ref--;
-	if (bfqq->ref)
+	if (!atomic_dec_and_test(&bfqq->ref))
 		return;
 
 	if (!hlist_unhashed(&bfqq->burst_list_node)) {
@@ -5328,7 +5329,7 @@ void bfq_put_queue(struct bfq_queue *bfqq)
 
 static void bfq_put_stable_ref(struct bfq_queue *bfqq)
 {
-	bfqq->stable_ref--;
+	atomic_dec(&bfqq->stable_ref);
 	bfq_put_queue(bfqq);
 }
 
@@ -5358,7 +5359,7 @@ static void bfq_exit_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 		bfq_schedule_dispatch(bfqd);
 	}
 
-	bfq_log_bfqq(bfqd, bfqq, "exit_bfqq: %p, %d", bfqq, bfqq->ref);
+	bfq_log_bfqq(bfqd, bfqq, "exit_bfqq: %p, %d", bfqq, atomic_read(&bfqq->ref));
 
 	bfq_put_cooperator(bfqq);
 
@@ -5507,7 +5508,7 @@ static void bfq_init_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	INIT_HLIST_NODE(&bfqq->woken_list_node);
 	INIT_HLIST_HEAD(&bfqq->woken_list);
 
-	bfqq->ref = 0;
+	atomic_set(&bfqq->ref, 0);
 	bfqq->bfqd = bfqd;
 
 	if (bic)
@@ -5710,12 +5711,12 @@ static struct bfq_queue *bfq_do_or_sched_stable_merge(struct bfq_data *bfqd,
 			 * to prevent it from being freed,
 			 * until we decide whether to merge
 			 */
-			last_bfqq_created->ref++;
+			atomic_inc(&last_bfqq_created->ref);
 			/*
 			 * need to keep track of stable refs, to
 			 * compute process refs correctly
 			 */
-			last_bfqq_created->stable_ref++;
+			atomic_inc(&last_bfqq_created->stable_ref);
 			/*
 			 * Record the bfqq to merge to.
 			 */
@@ -5767,20 +5768,21 @@ static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
 	 * prune it.
 	 */
 	if (async_bfqq) {
-		bfqq->ref++; /*
-			      * Extra group reference, w.r.t. sync
-			      * queue. This extra reference is removed
-			      * only if bfqq->bfqg disappears, to
-			      * guarantee that this queue is not freed
-			      * until its group goes away.
-			      */
+		atomic_inc(&bfqq->ref);
+		/*
+		 * Extra group reference, w.r.t. sync
+		 * queue. This extra reference is removed
+		 * only if bfqq->bfqg disappears, to
+		 * guarantee that this queue is not freed
+		 * until its group goes away.
+		 */
 		bfq_log_bfqq(bfqd, bfqq, "get_queue, bfqq not in async: %p, %d",
-			     bfqq, bfqq->ref);
+			     bfqq, atomic_read(&bfqq->ref));
 		*async_bfqq = bfqq;
 	}
 
 out:
-	bfqq->ref++; /* get a process reference to this queue */
+	atomic_inc(&bfqq->ref); /* get a process reference to this queue */
 
 	if (bfqq != &bfqd->oom_bfqq && is_sync && !respawn)
 		bfqq = bfq_do_or_sched_stable_merge(bfqd, bfqq, bic);
@@ -6059,7 +6061,7 @@ static bool __bfq_insert_request(struct bfq_data *bfqd, struct request *rq)
 		 */
 		bfqq_request_allocated(new_bfqq);
 		bfqq_request_freed(bfqq);
-		new_bfqq->ref++;
+		atomic_inc(&new_bfqq->ref);
 		/*
 		 * If the bic associated with the process
 		 * issuing this request still points to bfqq
@@ -6803,10 +6805,10 @@ static struct bfq_queue *bfq_init_rq(struct request *rq)
 	}
 
 	bfqq_request_allocated(bfqq);
-	bfqq->ref++;
+	atomic_inc(&bfqq->ref);
 	bic->requests++;
 	bfq_log_bfqq(bfqd, bfqq, "get_request %p: bfqq %p, %d",
-		     rq, bfqq, bfqq->ref);
+		     rq, bfqq, atomic_read(&bfqq->ref));
 
 	rq->elv.priv[0] = bic;
 	rq->elv.priv[1] = bfqq;
@@ -6939,7 +6941,7 @@ static void __bfq_put_async_bfqq(struct bfq_data *bfqd,
 		bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
 
 		bfq_log_bfqq(bfqd, bfqq, "put_async_bfqq: putting %p, %d",
-			     bfqq, bfqq->ref);
+			     bfqq, atomic_read(&bfqq->ref));
 		bfq_put_queue(bfqq);
 		*bfqq_ptr = NULL;
 	}
@@ -7092,7 +7094,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	 * will not attempt to free it.
 	 */
 	bfq_init_bfqq(bfqd, &bfqd->oom_bfqq, NULL, 1, 0);
-	bfqd->oom_bfqq.ref++;
+	atomic_inc(&bfqd->oom_bfqq.ref);
 	bfqd->oom_bfqq.new_ioprio = BFQ_DEFAULT_QUEUE_IOPRIO;
 	bfqd->oom_bfqq.new_ioprio_class = IOPRIO_CLASS_BE;
 	bfqd->oom_bfqq.entity.new_weight =
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 64ee618064ba..71ac0de80bb0 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -234,9 +234,9 @@ struct bfq_ttime {
  */
 struct bfq_queue {
 	/* reference counter */
-	int ref;
+	atomic_t ref;
 	/* counter of references from other queues for delayed stable merge */
-	int stable_ref;
+	atomic_t stable_ref;
 	/* parent bfq_data */
 	struct bfq_data *bfqd;
 
@@ -928,7 +928,7 @@ struct bfq_group {
 	char blkg_path[128];
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
-	int ref;
+	atomic_t ref;
 	/* Is bfq_group still online? */
 	bool online;
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 8fc3da4c23bb..60a9a2c1fc8d 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -512,9 +512,9 @@ static void bfq_get_entity(struct bfq_entity *entity)
 	struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
 
 	if (bfqq) {
-		bfqq->ref++;
+		atomic_inc(&bfqq->ref);
 		bfq_log_bfqq(bfqq->bfqd, bfqq, "get_entity: %p %d",
-			     bfqq, bfqq->ref);
+			     bfqq, atomic_read(&bfqq->ref));
 	}
 }
 
@@ -1611,7 +1611,7 @@ bool __bfq_bfqd_reset_in_service(struct bfq_data *bfqd)
 		 * reference to the queue. If this is the case, then
 		 * bfqq gets freed here.
 		 */
-		int ref = in_serv_bfqq->ref;
+		int ref = atomic_read(&in_serv_bfqq->ref);
 		bfq_put_queue(in_serv_bfqq);
 		if (ref == 1)
 			return true;
-- 
2.25.1

