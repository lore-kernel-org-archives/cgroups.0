From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next] block, bfq: cleanup 'bfqg->online'
Date: Wed,  1 Feb 2023 20:06:09 +0800
Message-ID: <20230201120609.4151432-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack@suse.cz, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

After commit dfd6200a0954 ("blk-cgroup: support to track if policy is
online"), there is no need to do this again in bfq.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-cgroup.c  | 4 +---
 block/bfq-iosched.h | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

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
-- 
2.31.1

