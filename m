From: Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH V2] blk-cgroup: prevent rcu_sched detected stalls warnings while iterating blkgs
Date: Wed, 7 Jul 2021 09:56:49 +0800
Message-ID: <20210707015649.1929797-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

We run a test that create millions of cgroups and blkgs, and then trigger
blkg_destroy_all(). blkg_destroy_all() will hold spin lock for a long
time in such situation. Thus release the lock when a batch of blkgs are
destroyed.

blkcg_activate_policy() and blkcg_deactivate_policy() might have the
same problem, however, as they are basically only called from module
init/exit paths, let's leave them alone for now.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
changes in V2:
 - as suggested by Tejun, rename 'BLKG_DESTROY_BATCH_SIZE' and modify
 blkg_destroy_all() only.

 block/blk-cgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 7b06a5fa3cac..575d7a2e7203 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -56,6 +56,8 @@ static LIST_HEAD(all_blkcgs);		/* protected by blkcg_pol_mutex */
 bool blkcg_debug_stats = false;
 static struct workqueue_struct *blkcg_punt_bio_wq;
 
+#define BLKG_DESTROY_BATCH_SIZE  64
+
 static bool blkcg_policy_enabled(struct request_queue *q,
 				 const struct blkcg_policy *pol)
 {
@@ -422,7 +424,9 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 static void blkg_destroy_all(struct request_queue *q)
 {
 	struct blkcg_gq *blkg, *n;
+	int count = BLKG_DESTROY_BATCH_SIZE;
 
+restart:
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry_safe(blkg, n, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
@@ -430,6 +434,17 @@ static void blkg_destroy_all(struct request_queue *q)
 		spin_lock(&blkcg->lock);
 		blkg_destroy(blkg);
 		spin_unlock(&blkcg->lock);
+
+		/*
+		 * in order to avoid holding the spin lock for too long, release
+		 * it when a batch of blkgs are destroyed.
+		 */
+		if (!(--count)) {
+			count = BLKG_DESTROY_BATCH_SIZE;
+			spin_unlock_irq(&q->queue_lock);
+			cond_resched();
+			goto restart;
+		}
 	}
 
 	q->root_blkg = NULL;
-- 
2.31.1

