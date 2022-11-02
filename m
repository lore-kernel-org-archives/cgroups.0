From: Yuwei Guan <ssawgyw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/5] block, bfq: change type for "prio_changed"
Date: Wed,  2 Nov 2022 19:43:53 +0800
Message-ID: <20221102114354.162-5-Yuwei.Guan@zeekrlife.com>
References: <20221102114354.162-1-Yuwei.Guan@zeekrlife.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTeNkRAzXSEVLoL3Lhip7sQ1RKcNrqLgbC54eCLx1tw=;
        b=HDp9lWuenSozaRzjerT1H0dZlQhufG/Pzy+6qbGUuQROkQ8ydTkNedBSkovOwbR2Qo
         cb4AOFtQs3G5G27oFv8KLihh9/LjmdELUsdNSXD8x51ZYESdNoSvnWerP5ifneF2Angs
         DUUx6R8MUL788RpABcGiGAWTwq6SY7IwizGMNnrRGHqPRpXBqV2G2SFvE9oezxAwF2MW
         0PToDCekpr574VXcUiycmuX6caumO8BZ9E4pnLjkFEJu1+3dWtkPyhYDIablEcZU75sW
         53xi29g1iBbjJjUBi8vTccGJxC/tTfOpRVWmXV/x3jTzC/UyVFkPsfCoVeSvjaje9sGh
         NeOg==
In-Reply-To: <20221102114354.162-1-Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org

"bool" type is more suitable for "prio_changed",
so change it from int to bool.

Signed-off-by: Yuwei Guan <Yuwei.Guan-tZnZJQTKG+hl57MIdRCFDg@public.gmane.org>
---
 block/bfq-cgroup.c  |  2 +-
 block/bfq-iosched.c | 20 ++++++++++----------
 block/bfq-iosched.h |  2 +-
 block/bfq-wf2q.c    |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 144bca006463..0eaa709995a9 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -1056,7 +1056,7 @@ static void bfq_group_set_weight(struct bfq_group *bfqg, u64 weight, u64 dev_wei
 		 * seen in that code.
 		 */
 		smp_wmb();
-		bfqg->entity.prio_changed = 1;
+		bfqg->entity.prio_changed = true;
 	}
 }
 
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 74b87694105f..48fdad88aa48 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -1211,7 +1211,7 @@ bfq_bfqq_resume_state(struct bfq_queue *bfqq, struct bfq_data *bfqd,
 	}
 
 	/* make sure weight will be updated, however we got here */
-	bfqq->entity.prio_changed = 1;
+	bfqq->entity.prio_changed = true;
 
 	if (likely(!busy))
 		return;
@@ -1917,7 +1917,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
 							 soft_rt);
 
 			if (old_wr_coeff != bfqq->wr_coeff)
-				bfqq->entity.prio_changed = 1;
+				bfqq->entity.prio_changed = true;
 		}
 	}
 
@@ -2315,7 +2315,7 @@ static void bfq_add_request(struct request *rq)
 			bfqq->wr_cur_max_time = bfq_wr_duration(bfqd);
 
 			bfqd->wr_busy_queues++;
-			bfqq->entity.prio_changed = 1;
+			bfqq->entity.prio_changed = true;
 		}
 		if (prev != bfqq->next_rq)
 			bfq_updated_next_req(bfqd, bfqq);
@@ -2634,7 +2634,7 @@ static void bfq_bfqq_end_wr(struct bfq_queue *bfqq)
 	 * Trigger a weight change on the next invocation of
 	 * __bfq_entity_update_weight_prio.
 	 */
-	bfqq->entity.prio_changed = 1;
+	bfqq->entity.prio_changed = true;
 }
 
 void bfq_end_wr_async_queues(struct bfq_data *bfqd,
@@ -3154,12 +3154,12 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 			bfqq->wr_start_at_switch_to_srt;
 		if (bfq_bfqq_busy(new_bfqq))
 			bfqd->wr_busy_queues++;
-		new_bfqq->entity.prio_changed = 1;
+		new_bfqq->entity.prio_changed = true;
 	}
 
 	if (bfqq->wr_coeff > 1) { /* bfqq has given its wr to new_bfqq */
 		bfqq->wr_coeff = 1;
-		bfqq->entity.prio_changed = 1;
+		bfqq->entity.prio_changed = true;
 		if (bfq_bfqq_busy(bfqq))
 			bfqd->wr_busy_queues--;
 	}
@@ -4987,7 +4987,7 @@ static void bfq_update_wr_data(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 				  * interactive weight raising
 				  */
 				switch_back_to_interactive_wr(bfqq, bfqd);
-				bfqq->entity.prio_changed = 1;
+				bfqq->entity.prio_changed = true;
 			}
 		}
 		if (bfqq->wr_coeff > 1 &&
@@ -5457,7 +5457,7 @@ bfq_set_next_ioprio_data(struct bfq_queue *bfqq, struct bfq_io_cq *bic)
 	bfqq->entity.new_weight = bfq_ioprio_to_weight(bfqq->new_ioprio);
 	bfq_log_bfqq(bfqd, bfqq, "new_ioprio %d new_weight %d",
 		     bfqq->new_ioprio, bfqq->entity.new_weight);
-	bfqq->entity.prio_changed = 1;
+	bfqq->entity.prio_changed = true;
 }
 
 static struct bfq_queue *bfq_get_queue(struct bfq_data *bfqd,
@@ -5831,7 +5831,7 @@ bfq_update_io_seektime(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 			  * raising
 			  */
 			switch_back_to_interactive_wr(bfqq, bfqd);
-			bfqq->entity.prio_changed = 1;
+			bfqq->entity.prio_changed = true;
 		}
 	}
 }
@@ -7099,7 +7099,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_type *e)
 	 * oom_bfqq's first activation. The oom_bfqq's ioprio and ioprio
 	 * class won't be changed any more.
 	 */
-	bfqd->oom_bfqq.entity.prio_changed = 1;
+	bfqd->oom_bfqq.entity.prio_changed = true;
 
 	bfqd->queue = q;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 256a9d267204..b022e5ec0871 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -195,7 +195,7 @@ struct bfq_entity {
 	struct bfq_sched_data *sched_data;
 
 	/* flag, set to request a weight, ioprio or ioprio_class change  */
-	int prio_changed;
+	bool prio_changed;
 
 	/* flag, set if the entity is counted in groups_with_pending_reqs */
 	bool in_groups_with_pending_reqs;
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 3da08f4be633..d9cef0f68d5a 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -751,7 +751,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		 * is not pending any longer.
 		 */
 		if (!bfqq || bfqq->ioprio_class == bfqq->new_ioprio_class)
-			entity->prio_changed = 0;
+			entity->prio_changed = false;
 
 		/*
 		 * NOTE: here we may be changing the weight too early,
-- 
2.34.1

