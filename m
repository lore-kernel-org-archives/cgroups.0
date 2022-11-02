From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v4 5/5] block, bfq: don't declare 'bfqd' as type 'void *' in bfq_group
Date: Wed,  2 Nov 2022 10:25:42 +0800
Message-ID: <20221102022542.3621219-6-yukuai1@huaweicloud.com>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221102022542.3621219-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Prevent unnecessary format conversion for bfqg->bfqd in multiple
places.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Acked-by: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
---
 block/bfq-cgroup.c  | 2 +-
 block/bfq-iosched.h | 2 +-
 block/bfq-wf2q.c    | 6 ++----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 4c37398e0b99..d57872cc05ed 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -224,7 +224,7 @@ void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
 {
 	blkg_rwstat_add(&bfqg->stats.queued, opf, 1);
 	bfqg_stats_end_empty_time(&bfqg->stats);
-	if (!(bfqq == ((struct bfq_data *)bfqg->bfqd)->in_service_queue))
+	if (!(bfqq == bfqg->bfqd->in_service_queue))
 		bfqg_stats_set_start_group_wait_time(bfqg, bfqq_group(bfqq));
 }
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 76363841d8ff..9fa89577322d 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -931,7 +931,7 @@ struct bfq_group {
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;
 
-	void *bfqd;
+	struct bfq_data *bfqd;
 
 	struct bfq_queue *async_bfqq[2][IOPRIO_NR_LEVELS];
 	struct bfq_queue *async_idle_bfqq;
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 4d4b84e7bf3e..b02b53658ed4 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -222,9 +222,8 @@ static void bfq_inc_active_entities(struct bfq_entity *entity)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
-	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
 
-	if (bfqg != bfqd->root_group)
+	if (bfqg != bfqg->bfqd->root_group)
 		bfqg->active_entities++;
 }
 
@@ -232,9 +231,8 @@ static void bfq_dec_active_entities(struct bfq_entity *entity)
 {
 	struct bfq_sched_data *sd = entity->sched_data;
 	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
-	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
 
-	if (bfqg != bfqd->root_group)
+	if (bfqg != bfqg->bfqd->root_group)
 		bfqg->active_entities--;
 }
 
-- 
2.31.1

