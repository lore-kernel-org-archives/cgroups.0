From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH -next v6 1/3] block, bfq: record how many queues are busy in bfq_group
Date: Mon, 23 May 2022 21:18:16 +0800
Message-ID: <20220523131818.2798712-2-yukuai3@huawei.com>
References: <20220523131818.2798712-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220523131818.2798712-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Prepare to refactor the counting of 'num_groups_with_pending_reqs'.

Add a counter 'busy_queues' in bfq_group, and update it in
bfq_add/del_bfqq_busy().

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.h |  2 ++
 block/bfq-wf2q.c    | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 09574af83566..4d516879d9fa 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 				   */
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
+	bfqg->busy_queues = 0;
 	bfqg->online = true;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 978ef5d6fe6a..3847f4ab77ac 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -906,6 +906,7 @@ struct bfq_group_data {
  *                   are groups with more than one active @bfq_entity
  *                   (see the comments to the function
  *                   bfq_bfqq_may_idle()).
+ * @busy_queues: number of busy bfqqs.
  * @rq_pos_tree: rbtree sorted by next_request position, used when
  *               determining if two or more queues have interleaving
  *               requests (see bfq_find_close_cooperator()).
@@ -942,6 +943,7 @@ struct bfq_group {
 	struct bfq_entity *my_entity;
 
 	int active_entities;
+	int busy_queues;
 
 	struct rb_root rq_pos_tree;
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index f8eb340381cf..d9ff33e0be38 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -218,6 +218,16 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return false;
 }
 
+static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
+{
+	bfqq_group(bfqq)->busy_queues++;
+}
+
+static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
+{
+	bfqq_group(bfqq)->busy_queues--;
+}
+
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
 
 static bool bfq_update_parent_budget(struct bfq_entity *next_in_service)
@@ -230,6 +240,14 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return true;
 }
 
+static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
+{
+}
+
+static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
+{
+}
+
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
 /*
@@ -1660,6 +1678,7 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 	bfq_clear_bfqq_busy(bfqq);
 
 	bfqd->busy_queues[bfqq->ioprio_class - 1]--;
+	bfq_inc_busy_queues(bfqq);
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues--;
@@ -1683,6 +1702,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 
 	bfq_mark_bfqq_busy(bfqq);
 	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
+	bfq_dec_busy_queues(bfqq);
 
 	if (!bfqq->dispatched)
 		if (bfqq->wr_coeff == 1)
-- 
2.31.1

