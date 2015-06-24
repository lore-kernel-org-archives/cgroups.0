From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/7] blkcg: make blkcg_policy methods take a pointer to blkcg_policy_data
Date: Tue, 23 Jun 2015 22:44:13 -0400
Message-ID: <1435113853-12053-8-git-send-email-tj@kernel.org>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NQMDZ8Va3TFLgAcooPPMtSQzCEqCS7G0D+XHbR9Z9BU=;
        b=B+ydIJfzZDckh5u8+9giHuYtB1UBwOIScgSGySbi6bp2CWc+rv+fDd6bo4xNGAOwxT
         1c1Bke4/i5inDryxa2XKeu+URGCZhoGhhYjvkOXqfVZhs5QvtPMDFfjvoNVTILBJmvCM
         JTPbn+xWAfbb8APGVFDrVZV3EUudQFy3x6CcEVkBOlSjpxcCfy11TyMww/RAdP7M+S1Y
         SmHwpNSbw+Gz8VmaqjNFGJIhgzSfVZbaRztx4yu7Dgn5QtUZuCppAMgfwUyrrFsVrzKM
         TWpR1WqNE10aTWv7CnZ2CP/4hythmU2zlLnmN/wLcPCo3AHzPcQQplD1FeyvuLh48zSZ
         qxGA==
In-Reply-To: <1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

The newly added ->pd_alloc_fn() and ->pd_free_fn() deal with pd
(blkg_policy_data) while the older ones use blkg (blkcg_gq).  As using
blkg doesn't make sense for ->pd_alloc_fn() and after allocation pd
can always be mapped to blkg and given that these are policy-specific
methods, it makes sense to converge on pd.

This patch makes all methods deal with pd instead of blkg.  Most
conversions are trivial.  In blk-cgroup.c, a couple method invocation
sites now test whether pd exists instead of policy state for
consistency.  This shouldn't cause any behavioral differences.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c         | 18 ++++++++----------
 block/blk-throttle.c       | 13 +++++++------
 block/cfq-iosched.c        | 17 +++++++++--------
 include/linux/blk-cgroup.h |  8 ++++----
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9d434a9..15d9628b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -229,7 +229,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 		struct blkcg_policy *pol = blkcg_policy[i];
 
 		if (blkg->pd[i] && pol->pd_init_fn)
-			pol->pd_init_fn(blkg);
+			pol->pd_init_fn(blkg->pd[i]);
 	}
 
 	/* insert */
@@ -243,7 +243,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
 			struct blkcg_policy *pol = blkcg_policy[i];
 
 			if (blkg->pd[i] && pol->pd_online_fn)
-				pol->pd_online_fn(blkg);
+				pol->pd_online_fn(blkg->pd[i]);
 		}
 	}
 	blkg->online = true;
@@ -334,7 +334,7 @@ static void blkg_destroy(struct blkcg_gq *blkg)
 		struct blkcg_policy *pol = blkcg_policy[i];
 
 		if (blkg->pd[i] && pol->pd_offline_fn)
-			pol->pd_offline_fn(blkg);
+			pol->pd_offline_fn(blkg->pd[i]);
 	}
 	blkg->online = false;
 
@@ -468,9 +468,8 @@ static int blkcg_reset_stats(struct cgroup_subsys_state *css,
 		for (i = 0; i < BLKCG_MAX_POLS; i++) {
 			struct blkcg_policy *pol = blkcg_policy[i];
 
-			if (blkcg_policy_enabled(blkg->q, pol) &&
-			    pol->pd_reset_stats_fn)
-				pol->pd_reset_stats_fn(blkg);
+			if (blkg->pd[i] && pol->pd_reset_stats_fn)
+				pol->pd_reset_stats_fn(blkg->pd[i]);
 		}
 	}
 
@@ -1038,7 +1037,7 @@ int blkcg_activate_policy(struct request_queue *q,
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
 		if (pol->pd_init_fn)
-			pol->pd_init_fn(blkg);
+			pol->pd_init_fn(pd);
 
 		spin_unlock(&blkg->blkcg->lock);
 	}
@@ -1080,10 +1079,9 @@ void blkcg_deactivate_policy(struct request_queue *q,
 		/* grab blkcg lock too while removing @pd from @blkg */
 		spin_lock(&blkg->blkcg->lock);
 
-		if (pol->pd_offline_fn)
-			pol->pd_offline_fn(blkg);
-
 		if (blkg->pd[pol->plid]) {
+			if (pol->pd_offline_fn)
+				pol->pd_offline_fn(blkg->pd[pol->plid]);
 			pol->pd_free_fn(blkg->pd[pol->plid]);
 			blkg->pd[pol->plid] = NULL;
 		}
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c3a235b..c2c7547 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -377,9 +377,10 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp, int node)
 	return &tg->pd;
 }
 
-static void throtl_pd_init(struct blkcg_gq *blkg)
+static void throtl_pd_init(struct blkg_policy_data *pd)
 {
-	struct throtl_grp *tg = blkg_to_tg(blkg);
+	struct throtl_grp *tg = pd_to_tg(pd);
+	struct blkcg_gq *blkg = tg_to_blkg(tg);
 	struct throtl_data *td = blkg->q->td;
 	struct throtl_service_queue *sq = &tg->service_queue;
 
@@ -417,13 +418,13 @@ static void tg_update_has_rules(struct throtl_grp *tg)
 				    (tg->bps[rw] != -1 || tg->iops[rw] != -1);
 }
 
-static void throtl_pd_online(struct blkcg_gq *blkg)
+static void throtl_pd_online(struct blkg_policy_data *pd)
 {
 	/*
 	 * We don't want new groups to escape the limits of its ancestors.
 	 * Update has_rules[] after a new group is brought online.
 	 */
-	tg_update_has_rules(blkg_to_tg(blkg));
+	tg_update_has_rules(pd_to_tg(pd));
 }
 
 static void throtl_pd_free(struct blkg_policy_data *pd)
@@ -435,9 +436,9 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 	kfree(tg);
 }
 
-static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
+static void throtl_pd_reset_stats(struct blkg_policy_data *pd)
 {
-	struct throtl_grp *tg = blkg_to_tg(blkg);
+	struct throtl_grp *tg = pd_to_tg(pd);
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d281ea6..d2bc961 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1558,17 +1558,18 @@ static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
 	return &cfqg->pd;
 }
 
-static void cfq_pd_init(struct blkcg_gq *blkg)
+static void cfq_pd_init(struct blkg_policy_data *pd)
 {
-	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+	struct cfq_group *cfqg = pd_to_cfqg(pd);
+	struct blkcg *blkcg = cfqg_to_blkg(cfqg)->blkcg;
 
-	cfqg->weight = blkg->blkcg->cfq_weight;
-	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
+	cfqg->weight = blkcg->cfq_weight;
+	cfqg->leaf_weight = blkcg->cfq_leaf_weight;
 }
 
-static void cfq_pd_offline(struct blkcg_gq *blkg)
+static void cfq_pd_offline(struct blkg_policy_data *pd)
 {
-	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+	struct cfq_group *cfqg = pd_to_cfqg(pd);
 	int i;
 
 	for (i = 0; i < IOPRIO_BE_NR; i++) {
@@ -1621,9 +1622,9 @@ static struct blkg_rwstat cfqg_rwstat_pd_recursive_sum(struct blkg_policy_data *
 	return a;
 }
 
-static void cfq_pd_reset_stats(struct blkcg_gq *blkg)
+static void cfq_pd_reset_stats(struct blkg_policy_data *pd)
 {
-	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
+	struct cfq_group *cfqg = pd_to_cfqg(pd);
 
 	cfqg_stats_reset(&cfqg->stats);
 	cfqg_stats_reset(&cfqg->dead_stats);
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 9603ae1..cafc54a 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -121,11 +121,11 @@ struct blkcg_gq {
 };
 
 typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp, int node);
-typedef void (blkcg_pol_init_pd_fn)(struct blkcg_gq *blkg);
-typedef void (blkcg_pol_online_pd_fn)(struct blkcg_gq *blkg);
-typedef void (blkcg_pol_offline_pd_fn)(struct blkcg_gq *blkg);
+typedef void (blkcg_pol_init_pd_fn)(struct blkg_policy_data *pd);
+typedef void (blkcg_pol_online_pd_fn)(struct blkg_policy_data *pd);
+typedef void (blkcg_pol_offline_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_free_pd_fn)(struct blkg_policy_data *pd);
-typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkcg_gq *blkg);
+typedef void (blkcg_pol_reset_pd_stats_fn)(struct blkg_policy_data *pd);
 
 struct blkcg_policy {
 	int				plid;
-- 
2.4.3
