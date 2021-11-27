From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RFC 7/9] block, bfq: record how many queues have pending requests in bfq_group
Date: Sat, 27 Nov 2021 18:11:30 +0800
Message-ID: <20211127101132.486806-8-yukuai3@huawei.com>
References: <20211127101132.486806-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211127101132.486806-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to decrease 'num_groups_with_pending_reqs' earlier.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.c | 21 +++++++++++++++++++++
 block/bfq-iosched.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 9c36deda4ed4..d6f7e96ec852 100644
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
index 63e4e13db92f..e3c31db4bffb 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -825,6 +825,16 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 inc_counter:
 	bfqq->weight_counter->num_active++;
 	bfqq->ref++;
+
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (!entity->in_groups_with_pending_reqs) {
+		struct bfq_group *bfqg =
+			container_of(entity->parent, struct bfq_group, entity);
+
+		entity->in_groups_with_pending_reqs = true;
+		bfqg->num_entities_with_pending_reqs++;
+	}
+#endif
 }
 
 /*
@@ -841,6 +851,17 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
 		return;
 
 	bfqq->weight_counter->num_active--;
+
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+	if (bfqq->entity.in_groups_with_pending_reqs) {
+		struct bfq_group *bfqg = container_of(bfqq->entity.parent,
+				struct bfq_group, entity);
+
+		bfqq->entity.in_groups_with_pending_reqs = false;
+		bfqg->num_entities_with_pending_reqs--;
+	}
+#endif
+
 	if (bfqq->weight_counter->num_active > 0)
 		goto reset_entity_pointer;
 
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 515eb2604a37..df08bff89a70 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -937,6 +937,7 @@ struct bfq_group {
 	struct bfq_entity *my_entity;
 
 	int active_entities;
+	int num_entities_with_pending_reqs;
 
 	struct rb_root rq_pos_tree;
 
-- 
2.31.1

