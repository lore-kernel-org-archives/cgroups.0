From: brookxu <brookxu.cn@gmail.com>
Subject: [RFC PATCH v2 02/11] bfq: convert the type of bfq_group.bfqd to bfq_data*
Date: Fri, 12 Mar 2021 19:08:36 +0800
Message-ID: <856a594d70b9a43b911285ff192d892d664001b0.1615527324.git.brookxu@tencent.com>
References: <cover.1615517202.git.brookxu@tencent.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=T14uQktm+Sg7+gpVLlmca1QlgsLzohgO//zswTvqmzc=;
        b=qQDIP426SYd0JFMuLOjcjCvM4b7lir3T36QLUC/aPgXpKn0w4+ZiPKbzzaDVqbdx7S
         N2ig54PNAeA0G8Jal9Yrlp0BoyTf1wIDq6n51EfRR8jxA1nf6sCkh8/0ThlPy2gFMRt5
         EpwK+5oted7MknJGGmQI6Qx/xhmpdUVaPJIcdvtjMzaqLTdoX0+Y8LvH6VPnz764xmIr
         FCWG3oLX0ehAyAi0Vbl6tvCLEQHGgI9KF997kPOyyyluYVldm6i4l8UMT2s25LNfHEXe
         812ijlTGrWs3LvuPq6dOa24ceKqExR4JAK0WzFHETP8xN2NUjjtc5xjb6pHJTDXy1VWf
         pUsw==
In-Reply-To: <cover.1615517202.git.brookxu@tencent.com>
In-Reply-To: <cover.1615527324.git.brookxu@tencent.com>
References: <cover.1615527324.git.brookxu@tencent.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Setting bfq_group.bfqd to void* type does not seem to make much sense.
This will cause unnecessary type conversion. Perhaps it would be better
to change it to bfq_data* type.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.h | 2 +-
 block/bfq-wf2q.c    | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index a5f544acaa61..50d06c760194 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -224,7 +224,7 @@ void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
 {
 	blkg_rwstat_add(&bfqg->stats.queued, op, 1);
 	bfqg_stats_end_empty_time(&bfqg->stats);
-	if (!(bfqq == ((struct bfq_data *)bfqg->bfqd)->in_service_queue))
+	if (!(bfqq == bfqg->bfqd->in_service_queue))
 		bfqg_stats_set_start_group_wait_time(bfqg, bfqq_group(bfqq));
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index a6f98e9e14b5..28d85903cf66 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -914,7 +914,7 @@ struct bfq_group {
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;
 
-	void *bfqd;
+	struct bfq_data *bfqd;
 
 	struct bfq_queue *async_bfqq[2][IOPRIO_BE_NR];
 	struct bfq_queue *async_idle_bfqq;
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 5ff0028920a2..276f225f9c6e 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -498,7 +498,7 @@ static void bfq_active_insert(struct bfq_service_tree *st,
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 	sd = entity->sched_data;
 	bfqg = container_of(sd, struct bfq_group, sched_data);
-	bfqd = (struct bfq_data *)bfqg->bfqd;
+	bfqd = bfqg->bfqd;
 #endif
 	if (bfqq)
 		list_add(&bfqq->bfqq_list, &bfqq->bfqd->active_list);
@@ -597,7 +597,7 @@ static void bfq_active_extract(struct bfq_service_tree *st,
 #ifdef CONFIG_BFQ_GROUP_IOSCHED
 	sd = entity->sched_data;
 	bfqg = container_of(sd, struct bfq_group, sched_data);
-	bfqd = (struct bfq_data *)bfqg->bfqd;
+	bfqd = bfqg->bfqd;
 #endif
 	if (bfqq)
 		list_del(&bfqq->bfqq_list);
@@ -743,7 +743,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		else {
 			sd = entity->my_sched_data;
 			bfqg = container_of(sd, struct bfq_group, sched_data);
-			bfqd = (struct bfq_data *)bfqg->bfqd;
+			bfqd = bfqg->bfqd;
 		}
 #endif
 
-- 
2.30.0

