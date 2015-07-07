From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] blkcg: replace blkcg_policy->pd_size with ->pd_alloc/free_fn() methods
Date: Tue,  7 Jul 2015 11:51:30 -0400
Message-ID: <1436284293-4666-5-git-send-email-tj@kernel.org>
References: <1436284293-4666-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xdrRadQYPBxbe6b+OlqHKBsFkH06OPGQhcDmR7uJo/g=;
        b=rezuPILlBgIN1eMhg1OVn9cSu/4S77gUT8s9J9U6PfGuR9c3ACrpaHiayqsepuQVmt
         Vhr0Cw+93Vvb9qiIXlRqwLj0jmpMWUn21gN64An+bxOs87MKarn1s8UgrXplLkhuYADw
         1vYM/89weYAQ4J8sVLbRujimKg/35IIUjNs17yNudPdi76dtKaYdZS8qndoAgBLQFcqC
         Ple1vVtoapBVfzQfuOTT3qNHgH+es4AiCxeyTKkySrxYTltxUk2e7sMYXhf0IsNhGbn1
         TjV+VIzhKlQpliwPp8CcPIFHRWs6Nsp00JLPnqiAjcunGocSO/CgFXVf2PH9KVqtoBVI
         hvZw==
In-Reply-To: <1436284293-4666-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, vgoyal@redhat.com, avanzini.arianna@gmail.com, Tejun Heo <tj@kernel.org>

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

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c         | 19 ++++++++++---------
 block/blk-throttle.c       | 13 ++++++++++++-
 block/cfq-iosched.c        | 13 ++++++++++++-
 include/linux/blk-cgroup.h | 18 +++++++++---------
 4 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e16d1dc..0bf76e7 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -58,7 +58,8 @@ static void blkg_free(struct blkcg_gq *blkg)
 		return;
 
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
-		kfree(blkg->pd[i]);
+		if (blkg->pd[i])
+			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
 
 	if (blkg->blkcg != &blkcg_root)
 		blk_exit_rl(&blkg->rl);
@@ -104,7 +105,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 			continue;
 
 		/* alloc per-policy data and attach it to blkg */
-		pd = kzalloc_node(pol->pd_size, gfp_mask, q->node);
+		pd = pol->pd_alloc_fn(gfp_mask, q->node);
 		if (!pd)
 			goto err_free;
 
@@ -1059,7 +1060,7 @@ int blkcg_activate_policy(struct request_queue *q,
 	 * for all existing blkgs.
 	 */
 	while (cnt--) {
-		pd = kzalloc_node(pol->pd_size, GFP_KERNEL, q->node);
+		pd = pol->pd_alloc_fn(GFP_KERNEL, q->node);
 		if (!pd) {
 			ret = -ENOMEM;
 			goto out_free;
@@ -1125,7 +1126,7 @@ int blkcg_activate_policy(struct request_queue *q,
 out_free:
 	blk_queue_bypass_end(q);
 	list_for_each_entry_safe(pd, nd, &pds, alloc_node)
-		kfree(pd);
+		pol->pd_free_fn(pd);
 	list_for_each_entry_safe(cpd, cnd, &cpds, alloc_node)
 		kfree(cpd);
 	return ret;
@@ -1162,8 +1163,11 @@ void blkcg_deactivate_policy(struct request_queue *q,
 		if (pol->pd_exit_fn)
 			pol->pd_exit_fn(blkg);
 
-		kfree(blkg->pd[pol->plid]);
-		blkg->pd[pol->plid] = NULL;
+		if (blkg->pd[pol->plid]) {
+			pol->pd_free_fn(blkg->pd[pol->plid]);
+			blkg->pd[pol->plid] = NULL;
+		}
+
 		kfree(blkg->blkcg->pd[pol->plid]);
 		blkg->blkcg->pd[pol->plid] = NULL;
 
@@ -1186,9 +1190,6 @@ int blkcg_policy_register(struct blkcg_policy *pol)
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
index 9c9ec7c..69ce288 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1582,6 +1582,11 @@ static void cfq_cpd_init(const struct blkcg *blkcg)
 	}
 }
 
+static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
+{
+	return kzalloc_node(sizeof(struct cfq_group), gfp, node);
+}
+
 static void cfq_pd_init(struct blkcg_gq *blkg)
 {
 	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
@@ -1618,6 +1623,11 @@ static void cfq_pd_offline(struct blkcg_gq *blkg)
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
@@ -4633,13 +4643,14 @@ static struct elevator_type iosched_cfq = {
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 static struct blkcg_policy blkcg_policy_cfq = {
-	.pd_size		= sizeof(struct cfq_group),
 	.cpd_size		= sizeof(struct cfq_group_data),
 	.cftypes		= cfq_blkcg_files,
 
 	.cpd_init_fn		= cfq_cpd_init,
+	.pd_alloc_fn		= cfq_pd_alloc,
 	.pd_init_fn		= cfq_pd_init,
 	.pd_offline_fn		= cfq_pd_offline,
+	.pd_free_fn		= cfq_pd_free,
 	.pd_reset_stats_fn	= cfq_pd_reset_stats,
 };
 #endif
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 2e41f8c..a4d0998 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -67,13 +67,11 @@ struct blkg_rwstat {
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
@@ -134,16 +132,16 @@ struct blkcg_gq {
 };
 
 typedef void (blkcg_pol_init_cpd_fn)(const struct blkcg *blkcg);
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
 	/* policy specific per-blkcg data size */
 	size_t				cpd_size;
 	/* cgroup files for the policy */
@@ -151,10 +149,12 @@ struct blkcg_policy {
 
 	/* operations */
 	blkcg_pol_init_cpd_fn		*cpd_init_fn;
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
