From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v7 1/3] block, bfq: record how many queues are busy in bfq_group
Date: Sat, 28 May 2022 17:50:18 +0800
Message-ID: <20220528095020.186970-2-yukuai3@huawei.com>
References: <20220528095020.186970-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220528095020.186970-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to refactor the counting of 'num_groups_with_pending_reqs'.

Add a counter 'busy_queues' in bfq_group, and update it in
bfq_add/del_bfqq_busy().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.h |  2 ++
 block/bfq-wf2q.c    | 26 ++++++++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

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
index ca8177d7bf7c..d92adbdd70ee 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -907,6 +907,7 @@ struct bfq_group_data {
  *                   are groups with more than one active @bfq_entity
  *                   (see the comments to the function
  *                   bfq_bfqq_may_idle()).
+ * @busy_queues: number of busy bfqqs.
  * @rq_pos_tree: rbtree sorted by next_request position, used when
  *               determining if two or more queues have interleaving
  *               requests (see bfq_find_close_cooperator()).
@@ -943,6 +944,7 @@ struct bfq_group {
 	struct bfq_entity *my_entity;
 
 	int active_entities;
+	int busy_queues;
 
 	struct rb_root rq_pos_tree;
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index f8eb340381cf..b97e33688335 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -218,6 +218,18 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return false;
 }
 
+static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
+{
+	bfqq->bfqd->busy_queues[bfqq->ioprio_class - 1]++;
+	bfqq_group(bfqq)->busy_queues++;
+}
+
+static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
+{
+	bfqq->bfqd->busy_queues[bfqq->ioprio_class - 1]--;
+	bfqq_group(bfqq)->busy_queues--;
+}
+
 #else /* CONFIG_BFQ_GROUP_IOSCHED */
 
 static bool bfq_update_parent_budget(struct bfq_entity *next_in_service)
@@ -230,6 +242,16 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
 	return true;
 }
 
+static void bfq_inc_busy_queues(struct bfq_queue *bfqq)
+{
+	bfqq->bfqd->busy_queues[bfqq->ioprio_class - 1]++;
+}
+
+static void bfq_dec_busy_queues(struct bfq_queue *bfqq)
+{
+	bfqq->bfqd->busy_queues[bfqq->ioprio_class - 1]--;
+}
+
 #endif /* CONFIG_BFQ_GROUP_IOSCHED */
 
 /*
@@ -1659,7 +1681,7 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	bfq_clear_bfqq_busy(bfqq);
 
-	bfqd->busy_queues[bfqq->ioprio_class - 1]--;
+	bfq_dec_busy_queues(bfqq);
 
 	if (bfqq->wr_coeff > 1)
 		bfqd->wr_busy_queues--;
@@ -1682,7 +1704,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 	bfq_activate_bfqq(bfqd, bfqq);
 
 	bfq_mark_bfqq_busy(bfqq);
-	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
+	bfq_inc_busy_queues(bfqq);
 
 	if (!bfqq->dispatched)
 		if (bfqq->wr_coeff == 1)
-- 
2.31.1

