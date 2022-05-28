From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v3 4/6] block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
Date: Sat, 28 May 2022 17:59:56 +0800
Message-ID: <20220528095958.270455-5-yukuai3@huawei.com>
References: <20220528095958.270455-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220528095958.270455-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prevent unnecessary format conversion for bfqg->bfqd in multiple
places.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.h | 2 +-
 block/bfq-wf2q.c    | 8 +++-----
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 4d516879d9fa..b4e39ab4ad17 100644
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
index ecca2c0570ea..c6109512503b 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -895,7 +895,7 @@ struct bfq_group {
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;
 
-	void *bfqd;
+	struct bfq_data *bfqd;
 
 	struct bfq_queue *async_bfqq[2][IOPRIO_NR_LEVELS];
 	struct bfq_queue *async_idle_bfqq;
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 643e57ee3e64..26ab9ba6e5a3 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -236,9 +236,8 @@ static void bfq_inc_active_entities(struct bfq_entity *entity)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
-	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
 
-	if (bfqg != bfqd->root_group)
+	if (bfqg != bfqg->bfqd->root_group)
 		bfqg->active_entities++;
 }
 
@@ -246,9 +245,8 @@ static void bfq_dec_active_entities(struct bfq_entity *entity)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
-	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
 
-	if (bfqg != bfqd->root_group)
+	if (bfqg != bfqg->bfqd->root_group)
 		bfqg->active_entities--;
 }
 
@@ -745,7 +743,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		else {
 			sd = entity->my_sched_data;
 			bfqg = container_of(sd, struct bfq_group, sched_data);
-			bfqd = (struct bfq_data *)bfqg->bfqd;
+			bfqd = bfqg->bfqd;
 		}
 #endif
 
-- 
2.31.1

