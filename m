From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 17/19] blk-cgroup: pass a gendisk to pd_alloc_fn
Date: Fri,  3 Feb 2023 16:03:58 +0100
Message-ID: <20230203150400.3199230-18-hch@lst.de>
References: <20230203150400.3199230-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iqxzzCJmHhLIZQm1tJj+TSbgjJAKy0k/QNFyAF6ZNsA=; b=tWx0Clz9w3UeM3V1h1z8TfnqgD
        4GVjoHs+9BmxPoHEiAwWjM0hN66RuSZyb3VFfnIojDqSFpF7Js1WcfiZ09vCCRyftl3FPbr6ouCkD
        G8b+KmsJShhF1aPpIOaA5TeNBucLG7CCcG+mrJA14eSqwO8BWo7Z/lf8ErdNqIa4bf/XTbUFSZluf
        qAKg6rN2ZDMtXvgLiHX1+zczPml0fcrg61riR7cc67u8ElPsHVCgdFiZUBqNK3EX6y/Q52VvucAHn
        0A2x26TTFroMzOcMtUxPBPwS55hwR14Z+zlcuKRB3/fjDqyPvC/1FA8uFdL630F7Cm0SeVi7tz+dP
        l6a+Q9Rw==;
In-Reply-To: <20230203150400.3199230-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>

No need to the request_queue here, pass a gendisk and extract the
node ids from that.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Andreas Herrmann <aherrmann-l3A5Bk7waGM@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/bfq-cgroup.c    |  6 +++---
 block/blk-cgroup.c    | 10 +++++-----
 block/blk-cgroup.h    |  4 ++--
 block/blk-iocost.c    |  7 ++++---
 block/blk-iolatency.c |  7 +++----
 block/blk-ioprio.c    |  2 +-
 block/blk-throttle.c  |  7 +++----
 7 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 032c14f0451a1d..37333c164ed458 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -513,12 +513,12 @@ static void bfq_cpd_free(struct blkcg_policy_data *cpd)
 	kfree(cpd_to_bfqgd(cpd));
 }
 
-static struct blkg_policy_data *bfq_pd_alloc(gfp_t gfp, struct request_queue *q,
-					     struct blkcg *blkcg)
+static struct blkg_policy_data *bfq_pd_alloc(struct gendisk *disk,
+		struct blkcg *blkcg, gfp_t gfp)
 {
 	struct bfq_group *bfqg;
 
-	bfqg = kzalloc_node(sizeof(*bfqg), gfp, q->node);
+	bfqg = kzalloc_node(sizeof(*bfqg), gfp, disk->node_id);
 	if (!bfqg)
 		return NULL;
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index c20929bce8125c..fc264b15588210 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -276,7 +276,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
 			continue;
 
 		/* alloc per-policy data and attach it to blkg */
-		pd = pol->pd_alloc_fn(gfp_mask, disk->queue, blkcg);
+		pd = pol->pd_alloc_fn(disk, blkcg, gfp_mask);
 		if (!pd)
 			goto out_free_pds;
 		blkg->pd[i] = pd;
@@ -1432,8 +1432,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 			pd = pd_prealloc;
 			pd_prealloc = NULL;
 		} else {
-			pd = pol->pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN, q,
-					      blkg->blkcg);
+			pd = pol->pd_alloc_fn(disk, blkg->blkcg,
+					      GFP_NOWAIT | __GFP_NOWARN);
 		}
 
 		if (!pd) {
@@ -1450,8 +1450,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 			if (pd_prealloc)
 				pol->pd_free_fn(pd_prealloc);
-			pd_prealloc = pol->pd_alloc_fn(GFP_KERNEL, q,
-						       blkg->blkcg);
+			pd_prealloc = pol->pd_alloc_fn(disk, blkg->blkcg,
+						       GFP_KERNEL);
 			if (pd_prealloc)
 				goto retry;
 			else
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 27068faa2cd086..3d9e42c519db86 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -154,8 +154,8 @@ typedef struct blkcg_policy_data *(blkcg_pol_alloc_cpd_fn)(gfp_t gfp);
 typedef void (blkcg_pol_init_cpd_fn)(struct blkcg_policy_data *cpd);
 typedef void (blkcg_pol_free_cpd_fn)(struct blkcg_policy_data *cpd);
 typedef void (blkcg_pol_bind_cpd_fn)(struct blkcg_policy_data *cpd);
-typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp,
-				struct request_queue *q, struct blkcg *blkcg);
+typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(struct gendisk *disk,
+		struct blkcg *blkcg, gfp_t gfp);
 typedef void (blkcg_pol_init_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_online_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_offline_pd_fn)(struct blkg_policy_data *pd);
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 078b7770951962..7a2dc9dc8e3ba0 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2923,13 +2923,14 @@ static void ioc_cpd_free(struct blkcg_policy_data *cpd)
 	kfree(container_of(cpd, struct ioc_cgrp, cpd));
 }
 
-static struct blkg_policy_data *ioc_pd_alloc(gfp_t gfp, struct request_queue *q,
-					     struct blkcg *blkcg)
+static struct blkg_policy_data *ioc_pd_alloc(struct gendisk *disk,
+		struct blkcg *blkcg, gfp_t gfp)
 {
 	int levels = blkcg->css.cgroup->level + 1;
 	struct ioc_gq *iocg;
 
-	iocg = kzalloc_node(struct_size(iocg, ancestors, levels), gfp, q->node);
+	iocg = kzalloc_node(struct_size(iocg, ancestors, levels), gfp,
+			    disk->node_id);
 	if (!iocg)
 		return NULL;
 
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 39853fc5c2b02f..bc0d217f5c1723 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -946,13 +946,12 @@ static void iolatency_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 			iolat->max_depth, avg_lat, cur_win);
 }
 
-static struct blkg_policy_data *iolatency_pd_alloc(gfp_t gfp,
-						   struct request_queue *q,
-						   struct blkcg *blkcg)
+static struct blkg_policy_data *iolatency_pd_alloc(struct gendisk *disk,
+		struct blkcg *blkcg, gfp_t gfp)
 {
 	struct iolatency_grp *iolat;
 
-	iolat = kzalloc_node(sizeof(*iolat), gfp, q->node);
+	iolat = kzalloc_node(sizeof(*iolat), gfp, disk->node_id);
 	if (!iolat)
 		return NULL;
 	iolat->stats = __alloc_percpu_gfp(sizeof(struct latency_stat),
diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8194826cc824bc..055529b9b92bab 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -116,7 +116,7 @@ static ssize_t ioprio_set_prio_policy(struct kernfs_open_file *of, char *buf,
 }
 
 static struct blkg_policy_data *
-ioprio_alloc_pd(gfp_t gfp, struct request_queue *q, struct blkcg *blkcg)
+ioprio_alloc_pd(struct gendisk *disk, struct blkcg *blkcg, gfp_t gfp)
 {
 	struct ioprio_blkg *ioprio_blkg;
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index efc0a9092c6942..74bb1e753ea09d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -335,14 +335,13 @@ static void throtl_service_queue_init(struct throtl_service_queue *sq)
 	timer_setup(&sq->pending_timer, throtl_pending_timer_fn, 0);
 }
 
-static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
-						struct request_queue *q,
-						struct blkcg *blkcg)
+static struct blkg_policy_data *throtl_pd_alloc(struct gendisk *disk,
+		struct blkcg *blkcg, gfp_t gfp)
 {
 	struct throtl_grp *tg;
 	int rw;
 
-	tg = kzalloc_node(sizeof(*tg), gfp, q->node);
+	tg = kzalloc_node(sizeof(*tg), gfp, disk->node_id);
 	if (!tg)
 		return NULL;
 
-- 
2.39.0

