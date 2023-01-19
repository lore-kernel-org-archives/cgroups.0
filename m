From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH -next v3 3/3] blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()
Date: Thu, 19 Jan 2023 19:03:50 +0800
Message-ID: <20230119110350.2287325-4-yukuai1@huaweicloud.com>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

Currently parent pd can be freed before child pd:

t1: remove cgroup C1
blkcg_destroy_blkgs
 blkg_destroy
  list_del_init(&blkg->q_node)
  // remove blkg from queue list
  percpu_ref_kill(&blkg->refcnt)
   blkg_release
    call_rcu

t2: from t1
__blkg_release
 blkg_free
  schedule_work
			t4: deactivate policy
			blkcg_deactivate_policy
			 pd_free_fn
			 // parent of C1 is freed first
t3: from t2
 blkg_free_workfn
  pd_free_fn

If policy(for example, ioc_timer_fn() from iocost) access parent pd from
child pd after pd_offline_fn(), then UAF can be triggered.

Fix the problem by delaying 'list_del_init(&blkg->q_node)' from
blkg_destroy() to blkg_free_workfn(), and using a new disk level mutex to
synchronize blkg_free_workfn() and blkcg_deactivate_policy().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c     | 35 +++++++++++++++++++++++++++++------
 include/linux/blkdev.h |  1 +
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 75f3c4460715..cb110fc51940 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -118,16 +118,32 @@ static void blkg_free_workfn(struct work_struct *work)
 {
 	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
 					     free_work);
+	struct request_queue *q = blkg->q;
 	int i;
 
+	/*
+	 * pd_free_fn() can also be called from blkcg_deactivate_policy(),
+	 * in order to make sure pd_free_fn() is called in order, the deletion
+	 * of the list blkg->q_node is delayed to here from blkg_destroy(), and
+	 * blkcg_mutex is used to synchronize blkg_free_workfn() and
+	 * blkcg_deactivate_policy().
+	 */
+	if (q)
+		mutex_lock(&q->blkcg_mutex);
+
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		if (blkg->pd[i])
 			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
 	if (blkg->parent)
 		blkg_put(blkg->parent);
-	if (blkg->q)
-		blk_put_queue(blkg->q);
+
+	if (q) {
+		list_del_init(&blkg->q_node);
+		mutex_unlock(&q->blkcg_mutex);
+		blk_put_queue(q);
+	}
+
 	free_percpu(blkg->iostat_cpu);
 	percpu_ref_exit(&blkg->refcnt);
 	kfree(blkg);
@@ -462,9 +478,14 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	lockdep_assert_held(&blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
-	/* Something wrong if we are trying to remove same group twice */
-	WARN_ON_ONCE(list_empty(&blkg->q_node));
-	WARN_ON_ONCE(hlist_unhashed(&blkg->blkcg_node));
+	/*
+	 * blkg stays on the queue list until blkg_free_workfn(), see details in
+	 * blkg_free_workfn(), hence this function can be called from
+	 * blkcg_destroy_blkgs() first and again from blkg_destroy_all() before
+	 * blkg_free_workfn().
+	 */
+	if (hlist_unhashed(&blkg->blkcg_node))
+		return;
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++) {
 		struct blkcg_policy *pol = blkcg_policy[i];
@@ -479,7 +500,6 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 	blkg->online = false;
 
 	radix_tree_delete(&blkcg->blkg_tree, blkg->q->id);
-	list_del_init(&blkg->q_node);
 	hlist_del_init_rcu(&blkg->blkcg_node);
 
 	/*
@@ -1280,6 +1300,7 @@ int blkcg_init_disk(struct gendisk *disk)
 	int ret;
 
 	INIT_LIST_HEAD(&q->blkg_list);
+	mutex_init(&q->blkcg_mutex);
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
@@ -1520,6 +1541,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	if (queue_is_mq(q))
 		blk_mq_freeze_queue(q);
 
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 
 	__clear_bit(pol->plid, q->blkcg_pols);
@@ -1538,6 +1560,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
 	}
 
 	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	if (queue_is_mq(q))
 		blk_mq_unfreeze_queue(q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b87ed829ab94..53ae0a7fe377 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -485,6 +485,7 @@ struct request_queue {
 	DECLARE_BITMAP		(blkcg_pols, BLKCG_MAX_POLS);
 	struct blkcg_gq		*root_blkg;
 	struct list_head	blkg_list;
+	struct mutex		blkcg_mutex;
 #endif
 
 	struct queue_limits	limits;
-- 
2.31.1

