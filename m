From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Tue, 27 Dec 2022 20:55:01 +0800
Message-ID: <20221227125502.541931-2-yukuai1@huaweicloud.com>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221227125502.541931-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com, yi.zhang@huawei.com

From: Yu Kuai <yukuai3@huawei.com>

iocost requires that child iocg must exit before parent iocg, otherwise
kernel might crash in ioc_timer_fn(). However, currently iocg is exited
in pd_free_fn(), which can't guarantee such order:

1) remove cgroup can concurrent with deactivate policy;
2) blkg_free() triggered by remove cgroup is asynchronously, remove
child cgroup can concurrent with remove parent cgroup;

Fix the problem by add refcounting for iocg, and child iocg will grab
reference of parent iocg, so that parent iocg will wait for all child
iocg to be exited.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-iocost.c | 74 +++++++++++++++++++++++++++++++---------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 7a0d754b9eb2..525e93e1175a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -461,6 +461,8 @@ struct ioc_gq {
 	struct blkg_policy_data		pd;
 	struct ioc			*ioc;
 
+	refcount_t			ref;
+
 	/*
 	 * A iocg can get its weight from two sources - an explicit
 	 * per-device-cgroup configuration or the default weight of the
@@ -2943,9 +2945,53 @@ static struct blkg_policy_data *ioc_pd_alloc(gfp_t gfp, struct request_queue *q,
 		return NULL;
 	}
 
+	refcount_set(&iocg->ref, 1);
 	return &iocg->pd;
 }
 
+static void iocg_get(struct ioc_gq *iocg)
+{
+	refcount_inc(&iocg->ref);
+}
+
+static void iocg_put(struct ioc_gq *iocg)
+{
+	struct ioc *ioc = iocg->ioc;
+	unsigned long flags;
+	struct ioc_gq *parent = NULL;
+
+	if (!refcount_dec_and_test(&iocg->ref))
+		return;
+
+	if (iocg->level > 0)
+		parent = iocg->ancestors[iocg->level - 1];
+
+	if (ioc) {
+		spin_lock_irqsave(&ioc->lock, flags);
+
+		if (!list_empty(&iocg->active_list)) {
+			struct ioc_now now;
+
+			ioc_now(ioc, &now);
+			propagate_weights(iocg, 0, 0, false, &now);
+			list_del_init(&iocg->active_list);
+		}
+
+		WARN_ON_ONCE(!list_empty(&iocg->walk_list));
+		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
+
+		spin_unlock_irqrestore(&ioc->lock, flags);
+
+		hrtimer_cancel(&iocg->waitq_timer);
+	}
+
+	free_percpu(iocg->pcpu_stat);
+	kfree(iocg);
+
+	if (parent)
+		iocg_put(parent);
+}
+
 static void ioc_pd_init(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
@@ -2973,6 +3019,9 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 
 	iocg->level = blkg->blkcg->css.cgroup->level;
 
+	if (blkg->parent)
+		iocg_get(blkg_to_iocg(blkg->parent));
+
 	for (tblkg = blkg; tblkg; tblkg = tblkg->parent) {
 		struct ioc_gq *tiocg = blkg_to_iocg(tblkg);
 		iocg->ancestors[tiocg->level] = tiocg;
@@ -2985,30 +3034,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
-	struct ioc_gq *iocg = pd_to_iocg(pd);
-	struct ioc *ioc = iocg->ioc;
-	unsigned long flags;
-
-	if (ioc) {
-		spin_lock_irqsave(&ioc->lock, flags);
-
-		if (!list_empty(&iocg->active_list)) {
-			struct ioc_now now;
-
-			ioc_now(ioc, &now);
-			propagate_weights(iocg, 0, 0, false, &now);
-			list_del_init(&iocg->active_list);
-		}
-
-		WARN_ON_ONCE(!list_empty(&iocg->walk_list));
-		WARN_ON_ONCE(!list_empty(&iocg->surplus_list));
-
-		spin_unlock_irqrestore(&ioc->lock, flags);
-
-		hrtimer_cancel(&iocg->waitq_timer);
-	}
-	free_percpu(iocg->pcpu_stat);
-	kfree(iocg);
+	iocg_put(pd_to_iocg(pd));
 }
 
 static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
-- 
2.31.1

