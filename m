From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/7] blkcg: replace blkcg_policy->pd_size with ->pd_alloc/free_fn() methods
Date: Tue, 23 Jun 2015 22:44:10 -0400
Message-ID: <1435113853-12053-5-git-send-email-tj@kernel.org>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/YyAMBtVNmk/jYMXv7fvAptjyZe4VK0WIR/aCs7XovM=;
        b=gXoZCDsdq1xEhdHDNpAPXjwxf9a5vGV2sqqavYiIcNIs4c2qOxflrv5LqJniqsU1An
         HfM69POBa7hiMaLw+vnFP1bcvd2dob6aTn16BCROTQ5/9RpGom60eA/6f016BPshVPT+
         rZ57iC9PbPEBqRcqwwkjcUYRdcE+eFrcmApJ9Gby3yyZK82DHApcFsNAmBRdU59Dlmtc
         lYeCDS0r+eViHVzrp/8cSNjwlzYd8+DpvPWhSuukS0ydS2l2+zF1TKpJjS+vVxhmG9eo
         Bn0cYfjT0moCKHqnUWgGqPKCH7HqLZ+vms63skAV6vKh2FowkFg7UtO/oYkM6a88vOtU
         l5BQ==
In-Reply-To: <1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

A blkg (blkcg_gq) represents the relationship between a cgroup and
request_queue.  Each active policy has a pd (blkg_policy_data) on each
blkg.  The pd's were allocated by blkcg core and each policy could
request to allocate extra space at the end by setting
blkcg_policy->pd_size larger than the size of pd.

This is a bit unusual but was done this way mostly to simplify error
handling and all the existing use cases could be handled this way;
however, this is becoming too restrictive now that percpu memory can
be allocated without blocking.

This introduces two new mandatory blkcg_policy methods - pd_alloc_fn()
and pd_free_fn() - which are used to allocate and release pd for a
given policy.  As pd allocation is now done from policy side, it can
simply allocate a larger area which embeds pd at the beginning.  This
change makes ->pd_size pointless.  Removed.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c         | 18 +++++++++---------
 block/blk-throttle.c       | 13 ++++++++++++-
 block/cfq-iosched.c        | 13 ++++++++++++-
 include/linux/blk-cgroup.h | 18 +++++++++---------
 4 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 617a586..574971a 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -55,7 +55,8 @@ static void blkg_free(struct blkcg_gq *blkg)
 		return;
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
-		kfree(blkg->pd[i]);
+		if (blkg->pd[i])
+			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
 	if (blkg->blkcg != &blkcg_root)
 		blk_exit_rl(&blkg->rl);
@@ -101,7 +102,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 			continue;
 
 		/* alloc per-policy data and attach it to blkg */
-		pd = kzalloc_node(pol->pd_size, gfp_mask, q->node);
+		pd = pol->pd_alloc_fn(gfp_mask, q->node);
 		if (!pd)
 			goto err_free;
 
@@ -1016,7 +1017,7 @@ int blkcg_activate_policy(struct request_queue *q,
 	spin_unlock_irq(q->queue_lock);
 
 	while (cnt--) {
-		pd = kzalloc_node(pol->pd_size, GFP_KERNEL, q->node);
+		pd = pol->pd_alloc_fn(GFP_KERNEL, q->node);
 		if (!pd) {
 			ret = -ENOMEM;
 			goto out_free;
@@ -1058,7 +1059,7 @@ int blkcg_activate_policy(struct request_queue *q,
 out_free:
 	blk_queue_bypass_end(q);
 	list_for_each_entry_safe(pd, n, &pds, alloc_node)
-		kfree(pd);
+		pol->pd_free_fn(pd);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blkcg_activate_policy);
@@ -1093,8 +1094,10 @@ void blkcg_deactivate_policy(struct request_queue *q,
 		if (pol->pd_exit_fn)
 			pol->pd_exit_fn(blkg);
 
-		kfree(blkg->pd[pol->plid]);
-		blkg->pd[pol->plid] = NULL;
+		if (blkg->pd[pol->plid]) {
+			pol->pd_free_fn(blkg->pd[pol->plid]);
+			blkg->pd[pol->plid] = NULL;
+		}
 
 		spin_unlock(&blkg->blkcg->lock);
 	}
@@ -1115,9 +1118,6 @@ int blkcg_policy_register(struct blkcg_policy *pol)
 {
 	int i, ret;
 
-	if (WARN_ON(pol->pd_size < sizeof(struct blkg_policy_data)))
-		return -EINVAL;
-
 	mutex_lock(&blkcg_pol_mutex);
 
 	/* find an empty slot */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index b231935..f1dd691 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -403,6 +403,11 @@ static void throtl_service_queue_exit(struct throtl_service_queue *sq)
 	del_timer_sync(&sq->pending_timer);
 }
 
+static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
+{
+	return kzalloc_node(sizeof(struct throtl_grp), gfp, node);
+}
+
 static void throtl_pd_init(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
@@ -493,6 +498,11 @@ static void throtl_pd_exit(struct blkcg_gq *blkg)
 	throtl_service_queue_exit(&tg->service_queue);
 }
 
+static void throtl_pd_free(struct blkg_policy_data *pd)
+{
+	kfree(pd);
+}
+
 static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
 {
 	struct throtl_grp *tg = blkg_to_tg(blkg);
@@ -1468,12 +1478,13 @@ static void throtl_shutdown_wq(struct request_queue *q)
 }
 
 static struct blkcg_policy blkcg_policy_throtl = {
-	.pd_size		= sizeof(struct throtl_grp),
 	.cftypes		= throtl_files,
 
+	.pd_alloc_fn		= throtl_pd_alloc,
 	.pd_init_fn		= throtl_pd_init,
 	.pd_online_fn		= throtl_pd_online,
 	.pd_exit_fn		= throtl_pd_exit,
+	.pd_free_fn		= throtl_pd_free,
 	.pd_reset_stats_fn	= throtl_pd_reset_stats,
 };
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c09ef15..6b7bf94 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1543,6 +1543,11 @@ static void cfqg_stats_init(struct cfqg_stats *stats)
 #endif
 }
 
+static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
+{
+	return kzalloc_node(sizeof(struct cfq_group), gfp, node);
+}
+
 static void cfq_pd_init(struct blkcg_gq *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
@@ -1578,6 +1583,11 @@ static void cfq_pd_offline(struct blkcg_gq *blkg)
 	cfqg_stats_xfer_dead(cfqg);
 }
 
+static void cfq_pd_free(struct blkg_policy_data *pd)
+{
+	return kfree(pd);
+}
+
 /* offset delta from cfqg->stats to cfqg->dead_stats */
 static const int dead_stats_off_delta = offsetof(struct cfq_group, dead_stats) -
 					offsetof(struct cfq_group, stats);
@@ -4552,11 +4562,12 @@ static struct elevator_type iosched_cfq = {
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkcg_policy blkcg_policy_cfq = {
-	.pd_size		= sizeof(struct cfq_group),
 	.cftypes		= cfq_blkcg_files,
 
+	.pd_alloc_fn		= cfq_pd_alloc,
 	.pd_init_fn		= cfq_pd_init,
 	.pd_offline_fn		= cfq_pd_offline,
+	.pd_free_fn		= cfq_pd_free,
 	.pd_reset_stats_fn	= cfq_pd_reset_stats,
 };
 #endif
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 50d1009..63f6340 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -74,13 +74,11 @@ struct blkg_rwstat {
  * request_queue (q).  This is used by blkcg policies which need to track
  * information per blkcg - q pair.
  *
- * There can be multiple active blkcg policies and each has its private
- * data on each blkg, the size of which is determined by
- * blkcg_policy->pd_size.  blkcg core allocates and frees such areas
- * together with blkg and invokes pd_init/exit_fn() methods.
- *
- * Such private data must embed struct blkg_policy_data (pd) at the
- * beginning and pd_size can't be smaller than pd.
+ * There can be multiple active blkcg policies and each blkg:policy pair is
+ * represented by a blkg_policy_data which is allocated and freed by each
+ * policy's pd_alloc/free_fn() methods.  A policy can allocate private data
+ * area by allocating larger data structure which embeds blkg_policy_data
+ * at the beginning.
  */
 struct blkg_policy_data {
 	/* the blkg and policy id this per-policy data belongs to */
@@ -122,24 +120,26 @@ struct blkcg_gq {
 	struct rcu_head			rcu_head;
 };
 
+typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp, int node);
 typedef void (blkcg_pol_init_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_online_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_offline_pd_fn)(struct blkcg_gq *blkg);
 typedef void (blkcg_pol_exit_pd_fn)(struct blkcg_gq *blkg);
+typedef void (blkcg_pol_free_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkcg_gq *blkg);
 
 struct blkcg_policy {
 	int				plid;
-	/* policy specific private data size */
-	size_t				pd_size;
 	/* cgroup files for the policy */
 	struct cftype			*cftypes;
 
 	/* operations */
+	blkcg_pol_alloc_pd_fn		*pd_alloc_fn;
 	blkcg_pol_init_pd_fn		*pd_init_fn;
 	blkcg_pol_online_pd_fn		*pd_online_fn;
 	blkcg_pol_offline_pd_fn		*pd_offline_fn;
 	blkcg_pol_exit_pd_fn		*pd_exit_fn;
+	blkcg_pol_free_pd_fn		*pd_free_fn;
 	blkcg_pol_reset_pd_stats_fn	*pd_reset_stats_fn;
 };
 
-- 
2.4.3
