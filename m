From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 4/8] block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
Date: Sat, 14 May 2022 17:05:18 +0800
Message-ID: <20220514090522.1669270-5-yukuai3@huawei.com>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220514090522.1669270-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prevent unnecessary format conversion for bfqg->bfqd in multiple
places.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
index bc54b9824b1e..d57e4848f57f 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -894,7 +894,7 @@ struct bfq_group {
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;
 
-	void *bfqd;
+	struct bfq_data *bfqd;
 
 	struct bfq_queue *async_bfqq[2][IOPRIO_NR_LEVELS];
 	struct bfq_queue *async_idle_bfqq;
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index c58568a4b009..15b97687493a 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -234,9 +234,8 @@ static void bfq_inc_active_entities(struct bfq_entity *entity)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
-	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
 
-	if (bfqg != bfqd->root_group)
+	if (bfqg != bfqg->bfqd->root_group)
 		bfqg->active_entities++;
 }
 
@@ -244,9 +243,8 @@ static void bfq_dec_active_entities(struct bfq_entity *entity)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
-	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
 
-	if (bfqg != bfqd->root_group)
+	if (bfqg != bfqg->bfqd->root_group)
 		bfqg->active_entities--;
 }
 
@@ -741,7 +739,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 		else {
 			sd = entity->my_sched_data;
 			bfqg = container_of(sd, struct bfq_group, sched_data);
-			bfqd = (struct bfq_data *)bfqg->bfqd;
+			bfqd = bfqg->bfqd;
 		}
 #endif
 
-- 
2.31.1

