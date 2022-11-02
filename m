From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH -next v4 1/5] block, bfq: remove set but not used variable in __bfq_entity_update_weight_prio
Date: Wed,  2 Nov 2022 10:25:38 +0800
Message-ID: <20221102022542.3621219-2-yukuai1@huaweicloud.com>
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

After the patch "block, bfq: cleanup bfq_weights_tree add/remove apis"),
the local variable 'bfqd' is not used anymore, thus remove it.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-wf2q.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 5a02cb94d86e..2faa29fcb1e9 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -706,21 +706,6 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
 	if (entity->prio_changed) {
 		struct bfq_queue *bfqq = bfq_entity_to_bfqq(entity);
 		unsigned int prev_weight, new_weight;
-		struct bfq_data *bfqd = NULL;
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-		struct bfq_sched_data *sd;
-		struct bfq_group *bfqg;
-#endif
-
-		if (bfqq)
-			bfqd = bfqq->bfqd;
-#ifdef CONFIG_BFQ_GROUP_IOSCHED
-		else {
-			sd = entity->my_sched_data;
-			bfqg = container_of(sd, struct bfq_group, sched_data);
-			bfqd = (struct bfq_data *)bfqg->bfqd;
-		}
-#endif
 
 		/* Matches the smp_wmb() in bfq_group_set_weight. */
 		smp_rmb();
-- 
2.31.1

