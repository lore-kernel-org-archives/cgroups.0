From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH] blkcg: remove unused __blkg_release_rcu()
Date: Wed, 19 Dec 2018 16:43:53 -0600
Message-ID: <20181219224353.32763-1-dennis@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>

An earlier commit 7fcf2b033b84 ("blkcg: change blkg reference counting
to use percpu_ref") moved around the release call from blkg_put() to be
a part of the percpu_ref cleanup. Remove the additional unused code
which should have been removed earlier.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 block/blk-cgroup.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c8cc1cbb6370..2bed5725aa03 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -438,29 +438,6 @@ static void blkg_destroy_all(struct request_queue *q)
 	spin_unlock_irq(&q->queue_lock);
 }
 
-/*
- * A group is RCU protected, but having an rcu lock does not mean that one
- * can access all the fields of blkg and assume these are valid.  For
- * example, don't try to follow throtl_data and request queue links.
- *
- * Having a reference to blkg under an rcu allows accesses to only values
- * local to groups like group stats and group rate limits.
- */
-void __blkg_release_rcu(struct rcu_head *rcu_head)
-{
-	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
-
-	/* release the blkcg and parent blkg refs this blkg has been holding */
-	css_put(&blkg->blkcg->css);
-	if (blkg->parent)
-		blkg_put(blkg->parent);
-
-	wb_congested_put(blkg->wb_congested);
-
-	blkg_free(blkg);
-}
-EXPORT_SYMBOL_GPL(__blkg_release_rcu);
-
 static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 			     struct cftype *cftype, u64 val)
 {
-- 
2.17.1

