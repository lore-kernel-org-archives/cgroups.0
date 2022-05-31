From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH -next v8 2/4] block, bfq: record how many queues have pending requests
Date: Tue, 31 May 2022 22:08:56 +0800
Message-ID: <20220531140858.3324294-3-yukuai3@huawei.com>
References: <20220531140858.3324294-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220531140858.3324294-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: paolo.valente@linaro.org, jack@suse.cz, axboe@kernel.dk, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Prepare to refactor the counting of 'num_groups_with_pending_reqs'.

Add a counter in bfq_group, and update it while tracking if bfqq have
pending requests.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-cgroup.c  |  1 +
 block/bfq-iosched.h |  1 +
 block/bfq-wf2q.c    | 12 ++++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 09574af83566..0954a258a107 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
 				   */
 	bfqg->bfqd = bfqd;
 	bfqg->active_entities = 0;
+	bfqg->num_queues_with_pending_reqs = 0;
 	bfqg->online = true;
 	bfqg->rq_pos_tree = RB_ROOT;
 }
diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
index 3b9b1a0e7c1c..a5f7c0c1a3b3 100644
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -943,6 +943,7 @@ struct bfq_group {
 	struct bfq_entity *my_entity;
 
 	int active_entities;
+	int num_queues_with_pending_reqs;
 
 	struct rb_root rq_pos_tree;
 
diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
index 12d20f26ad69..b533e17e9f0c 100644
--- a/block/bfq-wf2q.c
+++ b/block/bfq-wf2q.c
@@ -1651,16 +1651,24 @@ static void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
 {
 	struct bfq_entity *entity = &bfqq->entity;
 
-	if (!entity->in_groups_with_pending_reqs)
+	if (!entity->in_groups_with_pending_reqs) {
 		entity->in_groups_with_pending_reqs = true;
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+		bfqq_group(bfqq)->num_queues_with_pending_reqs++;
+#endif
+	}
 }
 
 void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
 {
 	struct bfq_entity *entity = &bfqq->entity;
 
-	if (entity->in_groups_with_pending_reqs)
+	if (entity->in_groups_with_pending_reqs) {
 		entity->in_groups_with_pending_reqs = false;
+#ifdef CONFIG_BFQ_GROUP_IOSCHED
+		bfqq_group(bfqq)->num_queues_with_pending_reqs--;
+#endif
+	}
 }
 
 /*
-- 
2.31.1

