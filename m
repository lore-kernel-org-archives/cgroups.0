From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/7] blk-throttle: clean up blkg_policy_data alloc/init/exit/free methods
Date: Tue, 23 Jun 2015 22:44:12 -0400
Message-ID: <1435113853-12053-7-git-send-email-tj@kernel.org>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VPLuiVHQUEAE4glCLrHeqY5kebTk43jcWlzRBeSfDBw=;
        b=w9dTJMkMF6W1kxu0W9sejGfe4Wp/RGuEGZrud6YsBlO0N5f1umsy2lfUPvbfAK8aiR
         NcG8bUCPqmYeGcMP4rUGc18WktzghjoX4ceTy6YPHipsjTEVIeqpl2FkWb3Nx81LpFZe
         U244usn6mZKfphoFYzh0wZt3e2V6pNRkn72YR1IRL1lXZZfv+rEznQTf41OjwKcoyk9L
         0SF3H0smPOB9nsAhvMVT7HVJK2VOG2ei5vfhQ8CGXEW1hpknZ7QimNMB2bNnwpWgwOZf
         WphCI0K+v5tf8jVgs0wDYXKcIvBnzOuLLjkNuToKtyQa7l6nW7zGzyK5ItbXmupi3OJD
         Mf8A==
In-Reply-To: <1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

With the recent addition of alloc and free methods, things became
messier.  This patch reorganizes them according to the followings.

* ->pd_alloc_fn()

  Responsible for allocation and static initializations - the ones
  which can be done independent of where the pd might be attached.

* ->pd_init_fn()

  Initializations which require the knowledge of where the pd is
  attached.

* ->pd_free_fn()

  The counter part of pd_alloc_fn().  Static de-init and freeing.

This leaves ->pd_exit_fn() without any users.  Removed.

While at it, collapse an one liner function throtl_pd_exit(), which
has only one user, into its user.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c         | 11 ---------
 block/blk-throttle.c       | 57 ++++++++++++++++------------------------------
 block/cfq-iosched.c        | 15 ++++++++----
 include/linux/blk-cgroup.h |  2 --
 4 files changed, 31 insertions(+), 54 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 574971a..9d434a9 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -389,15 +389,6 @@ static void blkg_destroy_all(struct request_queue *q)
 void __blkg_release_rcu(struct rcu_head *rcu_head)
 {
 	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
-	int i;
-
-	/* tell policies that this one is being freed */
-	for (i = 0; i < BLKCG_MAX_POLS; i++) {
-		struct blkcg_policy *pol = blkcg_policy[i];
-
-		if (blkg->pd[i] && pol->pd_exit_fn)
-			pol->pd_exit_fn(blkg);
-	}
 
 	/* release the blkcg and parent blkg refs this blkg has been holding */
 	css_put(&blkg->blkcg->css);
@@ -1091,8 +1082,6 @@ void blkcg_deactivate_policy(struct request_queue *q,
 
 		if (pol->pd_offline_fn)
 			pol->pd_offline_fn(blkg);
-		if (pol->pd_exit_fn)
-			pol->pd_exit_fn(blkg);
 
 		if (blkg->pd[pol->plid]) {
 			pol->pd_free_fn(blkg->pd[pol->plid]);
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3c86976..c3a235b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -330,26 +330,19 @@ static struct bio *throtl_pop_queued(struct list_head *queued,
 }
 
 /* init a service_queue, assumes the caller zeroed it */
-static void throtl_service_queue_init(struct throtl_service_queue *sq,
-				      struct throtl_service_queue *parent_sq)
+static void throtl_service_queue_init(struct throtl_service_queue *sq)
 {
 	INIT_LIST_HEAD(&sq->queued[0]);
 	INIT_LIST_HEAD(&sq->queued[1]);
 	sq->pending_tree = RB_ROOT;
-	sq->parent_sq = parent_sq;
 	setup_timer(&sq->pending_timer, throtl_pending_timer_fn,
 		    (unsigned long)sq);
 }
 
-static void throtl_service_queue_exit(struct throtl_service_queue *sq)
-{
-	del_timer_sync(&sq->pending_timer);
-}
-
 static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 {
 	struct throtl_grp *tg;
-	int cpu;
+	int rw, cpu;
 
 	tg = kzalloc_node(sizeof(*tg), gfp, node);
 	if (!tg)
@@ -361,6 +354,19 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 		return NULL;
 	}
 
+	throtl_service_queue_init(&tg->service_queue);
+
+	for (rw = READ; rw <= WRITE; rw++) {
+		throtl_qnode_init(&tg->qnode_on_self[rw], tg);
+		throtl_qnode_init(&tg->qnode_on_parent[rw], tg);
+	}
+
+	RB_CLEAR_NODE(&tg->rb_node);
+	tg->bps[READ] = -1;
+	tg->bps[WRITE] = -1;
+	tg->iops[READ] = -1;
+	tg->iops[WRITE] = -1;
+
 	for_each_possible_cpu(cpu) {
 		struct tg_stats_cpu *stats_cpu = per_cpu_ptr(tg->stats_cpu, cpu);
 
@@ -375,8 +381,7 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct throtl_data *td = blkg->q->td;
-	struct throtl_service_queue *parent_sq;
-	int rw;
+	struct throtl_service_queue *sq = &tg->service_queue;
 
 	/*
 	 * If on the default hierarchy, we switch to properly hierarchical
@@ -391,25 +396,10 @@ static void throtl_pd_init(struct blkcg_gq *blkg)
 	 * Limits of a group don't interact with limits of other groups
 	 * regardless of the position of the group in the hierarchy.
 	 */
-	parent_sq = &td->service_queue;
-
+	sq->parent_sq = &td->service_queue;
 	if (cgroup_on_dfl(blkg->blkcg->css.cgroup) && blkg->parent)
-		parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
-
-	throtl_service_queue_init(&tg->service_queue, parent_sq);
-
-	for (rw = READ; rw <= WRITE; rw++) {
-		throtl_qnode_init(&tg->qnode_on_self[rw], tg);
-		throtl_qnode_init(&tg->qnode_on_parent[rw], tg);
-	}
-
-	RB_CLEAR_NODE(&tg->rb_node);
+		sq->parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
 	tg->td = td;
-
-	tg->bps[READ] = -1;
-	tg->bps[WRITE] = -1;
-	tg->iops[READ] = -1;
-	tg->iops[WRITE] = -1;
 }
 
 /*
@@ -436,17 +426,11 @@ static void throtl_pd_online(struct blkcg_gq *blkg)
 	tg_update_has_rules(blkg_to_tg(blkg));
 }
 
-static void throtl_pd_exit(struct blkcg_gq *blkg)
-{
-	struct throtl_grp *tg = blkg_to_tg(blkg);
-
-	throtl_service_queue_exit(&tg->service_queue);
-}
-
 static void throtl_pd_free(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg = pd_to_tg(pd);
 
+	del_timer_sync(&tg->service_queue.pending_timer);
 	free_percpu(tg->stats_cpu);
 	kfree(tg);
 }
@@ -1421,7 +1405,6 @@ static struct blkcg_policy blkcg_policy_throtl = {
 	.pd_alloc_fn		= throtl_pd_alloc,
 	.pd_init_fn		= throtl_pd_init,
 	.pd_online_fn		= throtl_pd_online,
-	.pd_exit_fn		= throtl_pd_exit,
 	.pd_free_fn		= throtl_pd_free,
 	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
@@ -1616,7 +1599,7 @@ int blk_throtl_init(struct request_queue *q)
 		return -ENOMEM;
 
 	INIT_WORK(&td->dispatch_work, blk_throtl_dispatch_work_fn);
-	throtl_service_queue_init(&td->service_queue, NULL);
+	throtl_service_queue_init(&td->service_queue);
 
 	q->td = td;
 	td->queue = q;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6b7bf94..d281ea6 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1545,18 +1545,25 @@ static void cfqg_stats_init(struct cfqg_stats *stats)
 
 static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
 {
-	return kzalloc_node(sizeof(struct cfq_group), gfp, node);
+	struct cfq_group *cfqg;
+
+	cfqg = kzalloc_node(sizeof(*cfqg), gfp, node);
+	if (!cfqg)
+		return NULL;
+
+	cfq_init_cfqg_base(cfqg);
+	cfqg_stats_init(&cfqg->stats);
+	cfqg_stats_init(&cfqg->dead_stats);
+
+	return &cfqg->pd;
 }
 
 static void cfq_pd_init(struct blkcg_gq *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
 
-	cfq_init_cfqg_base(cfqg);
 	cfqg->weight = blkg->blkcg->cfq_weight;
 	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
-	cfqg_stats_init(&cfqg->stats);
-	cfqg_stats_init(&cfqg->dead_stats);
 }
 
 static void cfq_pd_offline(struct blkcg_gq *blkg)
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 63f6340..9603ae1 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -124,7 +124,6 @@ typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp, int node);
 typedef void (blkcg_pol_init_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_online_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_offline_pd_fn)(struct blkcg_gq *blkg);
-typedef void (blkcg_pol_exit_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_free_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkcg_gq *blkg);
 
@@ -138,7 +137,6 @@ struct blkcg_policy {
 	blkcg_pol_init_pd_fn		*pd_init_fn;
 	blkcg_pol_online_pd_fn		*pd_online_fn;
 	blkcg_pol_offline_pd_fn		*pd_offline_fn;
-	blkcg_pol_exit_pd_fn		*pd_exit_fn;
 	blkcg_pol_free_pd_fn		*pd_free_fn;
 	blkcg_pol_reset_pd_stats_fn	*pd_reset_stats_fn;
 };
-- 
2.4.3
