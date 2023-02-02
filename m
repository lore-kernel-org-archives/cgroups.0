From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v2] block, bfq: cleanup 'bfqg->online'
Date: Thu,  2 Feb 2023 21:45:04 +0800
Message-ID: <20230202134504.2353787-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

After commit dfd6200a0954 ("blk-cgroup: support to track if policy is
online"), there is no need to do this again in bfq.

However, 'pd->online' is protected by 'bfqd->lock', in order to make
sure bfq won't see that 'pd->online' is still set after bfq_pd_offline(),
clear it before bfq_pd_offline_() is called. This is fine because
'pd->online' is only used in bfq policy and bfq_pd_offline() will move
active bfqq to root cgroup anyway.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Changes in v2:
 - clear 'pd->online' before calling bfq_pd_offline()

 block/bfq-cgroup.c  | 4 +---
 block/bfq-iosched.h | 2 --
 block/blk-cgroup.c  | 2 +-
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index b42956ab5550..a35136dae713 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -551,7 +551,6 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
 	bfqg->num_queues_with_pending_reqs = 0;
-	bfqg->online = true;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
@@ -614,7 +613,7 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfqd, struct bio *bio)
 			continue;
 		}
 		bfqg = blkg_to_bfqg(blkg);
-		if (bfqg->online) {
+		if (bfqg->pd.online) {
 			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
 			return bfqg;
 		}
@@ -985,7 +984,6 @@ static void bfq_pd_offline(struct blkg_policy_data *pd)
 
 put_async_queues:
 	bfq_put_async_queues(bfqd, bfqg);
-	bfqg->online = false;
 
 	spin_unlock_irqrestore(&bfqd->lock, flags);
 	/*
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 75cc6a324267..69aaee52285a 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -1009,8 +1009,6 @@ struct bfq_group {
 
 	/* reference counter (see comments in bfq_bic_update_cgroup) */
 	refcount_t ref;
-	/* Is bfq_group still online? */
-	bool online;
 
 	struct bfq_entity entity;
 	struct bfq_sched_data sched_data;
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cb110fc51940..a228dfe65253 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -491,9 +491,9 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		struct blkcg_policy *pol = blkcg_policy[i];
 
 		if (blkg->pd[i] && blkg->pd[i]->online) {
+			blkg->pd[i]->online = false;
 			if (pol->pd_offline_fn)
 				pol->pd_offline_fn(blkg->pd[i]);
-			blkg->pd[i]->online = false;
 		}
 	}
 
-- 
2.31.1

