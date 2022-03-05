From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next 08/11] block, bfq: record how many queues have pending requests in bfq_group
Date: Sat, 5 Mar 2022 17:12:02 +0800
Message-ID: <20220305091205.4188398-9-yukuai3@huawei.com>
References: <20220305091205.4188398-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220305091205.4188398-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to decrease 'num_groups_with_pending_reqs' earlier.

bfqq will be inserted to weights_tree when new io is inserted to it, and
bfqq will be removed from weights_tree when all the requests are completed.
Thus use weights_tree insertion and removal to track how many queues have
pending requests.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.c | 15 +++++++++++++++
 block/bfq-iosched.h |  1 +
 3 files changed, 17 insertions(+)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 6cd65b5e790d..58acaf14a91d 100644
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
index 07027dc9dc4c..2a48c40b4f02 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -928,6 +928,13 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 inc_counter:
 	bfqq->weight_counter->num_active++;
 	bfqq->ref++;
+
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (!entity->in_groups_with_pending_reqs) {
+		entity->in_groups_with_pending_reqs = true;
+		bfqq_group(bfqq)->num_entities_with_pending_reqs++;
+	}
+#endif
 }
 
 /*
@@ -944,6 +951,14 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
 		return;
 
 	bfqq->weight_counter->num_active--;
+
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (bfqq->entity.in_groups_with_pending_reqs) {
+		bfqq->entity.in_groups_with_pending_reqs = false;
+		bfqq_group(bfqq)->num_entities_with_pending_reqs--;
+	}
+#endif
+
 	if (bfqq->weight_counter->num_active > 0)
 		goto reset_entity_pointer;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 4530ab8b42ac..5d904851519c 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -940,6 +940,7 @@ struct bfq_group {
 	struct bfq_entity *my_entity;
 
 	int active_entities;
+	int num_entities_with_pending_reqs;
 
 	struct rb_root rq_pos_tree;
 
-- 
2.31.1

