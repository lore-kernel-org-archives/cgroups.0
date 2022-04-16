From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v2 3/5] bfq, block: record how many queues have pending requests in bfq_group
Date: Sat, 16 Apr 2022 17:37:51 +0800
Message-ID: <20220416093753.3054696-4-yukuai3@huawei.com>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220416093753.3054696-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to refactor the counting of 'num_groups_with_pending_reqs'.

bfqq will be inserted to weights_tree when new io is inserted to it, and
bfqq will be removed from weights_tree when all the requests are completed.
Thus use weights_tree insertion and removal to track how many queues have
pending requests.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.c | 17 ++++++++++++++++-
 block/bfq-iosched.h |  1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 420eda2589c0..e8b58b2361a6 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 				   */
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
+	bfqg->num_entities_with_pending_reqs = 0;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
 
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index a2977c938c70..994c6b36a5d5 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -889,7 +889,7 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	if (bfqq->wr_coeff != 1) {
 		bfqq->weight_counter = BFQ_FAKE_WEIGHT_COUNTER;
 		bfqq->ref++;
-		return;
+		goto update;
 	}
 
 	while (*new) {
@@ -936,6 +936,14 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 inc_counter:
 	bfqq->weight_counter->num_active++;
 	bfqq->ref++;
+
+update:
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (!entity->in_groups_with_pending_reqs) {
+		entity->in_groups_with_pending_reqs = true;
+		bfqq_group(bfqq)->num_entities_with_pending_reqs++;
+	}
+#endif
 }
 
 /*
@@ -963,6 +971,13 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	kfree(bfqq->weight_counter);
 
 reset_entity_pointer:
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (bfqq->entity.in_groups_with_pending_reqs) {
+		bfqq->entity.in_groups_with_pending_reqs = false;
+		bfqq_group(bfqq)->num_entities_with_pending_reqs--;
+	}
+#endif
+
 	bfqq->weight_counter = NULL;
 	bfq_put_queue(bfqq);
 }
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 072099b0c11a..5e1a0ead2b6a 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -940,6 +940,7 @@ struct bfq_group {
 	struct bfq_entity *my_entity;
 
 	int active_entities;
+	int num_entities_with_pending_reqs;
 
 	struct rb_root rq_pos_tree;
 
-- 
2.31.1

