From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/4] blkcg: use CGROUP_WEIGHT_* scale for io.weight on the unified hierarchy
Date: Sun,  2 Aug 2015 16:23:44 -0400
Message-ID: <1438547024-23497-5-git-send-email-tj@kernel.org>
References: <1438547024-23497-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8Buf+m736JzGOH3AonEngeMPelxlqxppOLwrs108vfc=;
        b=YFmTDLHCmJZ1ETxkGOdBV+WLwHcY/stnpcPXMusAKkIzo631234i3xUN7qL5dux2m0
         BsKWUJ4NBDa0JzsKda61qVOEhuM60ttcR5H7+K3uZsM0Or6DrgYyiINZaOKtyDoNYgm6
         9/pcF1Glk9ThYEydbE5YEUB7gwpm/21LTNa2ZMYC15tJ66rNJmdkQanQFex9KbZ+J/Kj
         ds4WRynq2/BJq4ujwTuOSStjvd0uM1W0Qp+LY4ROH4x59pbduoCwrfo8kPIckcNbhFvv
         YP/I8fkmqY77MExebVAX8x427hmJ4pzJfMn8R2uDEhg/gXn6aH3nlya3MM/EOAG6OUY0
         7VHA==
In-Reply-To: <1438547024-23497-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup is trying to make interface consistent across different
controllers.  For weight based resource control, the knob should have
the range [1, 10000] and default to 100.  This patch updates
cfq-iosched so that the weight range conforms.  The internal
calculations have enough range and the widening of the weight range
shouldn't cause any problem.

* blkcg_policy->cpd_bind_fn() is added.  If present, this is invoked
  when blkcg is attached to a hierarchy.

* cfq_cpd_init() is updated to use the new default value on the
  unified hierarchy.

* cfq_cpd_bind() callback is implemented to clear per-blkg configs and
  apply the default config matching the hierarchy type.

* cfqd->root_group->[leaf_]weight initialization in cfq_init_queue()
  is moved into !CONFIG_CFQ_GROUP_IOSCHED block.  cfq_cpd_bind() is
  now responsible for initializing the initial weights when blkcg is
  enabled.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  2 +-
 block/blk-cgroup.c                          | 21 +++++++++++
 block/cfq-iosched.c                         | 55 +++++++++++++++++++++--------
 include/linux/blk-cgroup.h                  |  2 ++
 4 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index ee6ce34..bd319f0 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -459,7 +459,7 @@ may be specified in any order and not all pairs have to be specified.
 
 	The weight setting, currently only available and effective if
 	cfq-iosched is in use for the target device.  The weight is
-	between 10 and 1000 and defaults to 500.  The first line
+	between 1 and 10000 and defaults to 100.  The first line
 	always contains the default weight in the following format to
 	use when per-device setting is missing.
 
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 88bdb73..ac8370c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1143,11 +1143,32 @@ static int blkcg_can_attach(struct cgroup_subsys_state *css,
 	return ret;
 }
 
+static void blkcg_bind(struct cgroup_subsys_state *root_css)
+{
+	int i;
+
+	mutex_lock(&blkcg_pol_mutex);
+
+	for (i = 0; i < BLKCG_MAX_POLS; i++) {
+		struct blkcg_policy *pol = blkcg_policy[i];
+		struct blkcg *blkcg;
+
+		if (!pol || !pol->cpd_bind_fn)
+			continue;
+
+		list_for_each_entry(blkcg, &all_blkcgs, all_blkcgs_node)
+			if (blkcg->cpd[pol->plid])
+				pol->cpd_bind_fn(blkcg->cpd[pol->plid]);
+	}
+	mutex_unlock(&blkcg_pol_mutex);
+}
+
 struct cgroup_subsys io_cgrp_subsys = {
 	.css_alloc = blkcg_css_alloc,
 	.css_offline = blkcg_css_offline,
 	.css_free = blkcg_css_free,
 	.can_attach = blkcg_can_attach,
+	.bind = blkcg_bind,
 	.dfl_cftypes = blkcg_files,
 	.legacy_cftypes = blkcg_legacy_files,
 	.legacy_name = "blkio",
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 0fe721e..04de884 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1522,6 +1522,9 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
 }
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
+			    bool on_dfl, bool reset_dev, bool is_leaf_weight);
+
 static void cfqg_stats_exit(struct cfqg_stats *stats)
 {
 	blkg_rwstat_exit(&stats->merged);
@@ -1578,14 +1581,14 @@ static struct blkcg_policy_data *cfq_cpd_alloc(gfp_t gfp)
 static void cfq_cpd_init(struct blkcg_policy_data *cpd)
 {
 	struct cfq_group_data *cgd = cpd_to_cfqgd(cpd);
+	unsigned int weight = cgroup_on_dfl(blkcg_root.css.cgroup) ?
+			      CGROUP_WEIGHT_DFL : CFQ_WEIGHT_LEGACY_DFL;
 
-	if (cpd_to_blkcg(cpd) == &blkcg_root) {
-		cgd->weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
-		cgd->leaf_weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
-	} else {
-		cgd->weight = CFQ_WEIGHT_LEGACY_DFL;
-		cgd->leaf_weight = CFQ_WEIGHT_LEGACY_DFL;
-	}
+	if (cpd_to_blkcg(cpd) == &blkcg_root)
+		weight *= 2;
+
+	cgd->weight = weight;
+	cgd->leaf_weight = weight;
 }
 
 static void cfq_cpd_free(struct blkcg_policy_data *cpd)
@@ -1593,6 +1596,19 @@ static void cfq_cpd_free(struct blkcg_policy_data *cpd)
 	kfree(cpd_to_cfqgd(cpd));
 }
 
+static void cfq_cpd_bind(struct blkcg_policy_data *cpd)
+{
+	struct blkcg *blkcg = cpd_to_blkcg(cpd);
+	bool on_dfl = cgroup_on_dfl(blkcg_root.css.cgroup);
+	unsigned int weight = on_dfl ? CGROUP_WEIGHT_DFL : CFQ_WEIGHT_LEGACY_DFL;
+
+	if (blkcg == &blkcg_root)
+		weight *= 2;
+
+	WARN_ON_ONCE(__cfq_set_weight(&blkcg->css, weight, on_dfl, true, false));
+	WARN_ON_ONCE(__cfq_set_weight(&blkcg->css, weight, on_dfl, true, true));
+}
+
 static struct blkg_policy_data *cfq_pd_alloc(gfp_t gfp, int node)
 {
 	struct cfq_group *cfqg;
@@ -1742,6 +1758,8 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 					char *buf, size_t nbytes, loff_t off,
 					bool on_dfl, bool is_leaf_weight)
 {
+	unsigned int min = on_dfl ? CGROUP_WEIGHT_MIN : CFQ_WEIGHT_LEGACY_MIN;
+	unsigned int max = on_dfl ? CGROUP_WEIGHT_MAX : CFQ_WEIGHT_LEGACY_MAX;
 	struct blkcg *blkcg = css_to_blkcg(of_css(of));
 	struct blkg_conf_ctx ctx;
 	struct cfq_group *cfqg;
@@ -1769,7 +1787,7 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 	cfqgd = blkcg_to_cfqgd(blkcg);
 
 	ret = -ERANGE;
-	if (!v || (v >= CFQ_WEIGHT_LEGACY_MIN && v <= CFQ_WEIGHT_LEGACY_MAX)) {
+	if (!v || (v >= min && v <= max)) {
 		if (!is_leaf_weight) {
 			cfqg->dev_weight = v;
 			cfqg->new_weight = v ?: cfqgd->weight;
@@ -1797,15 +1815,17 @@ static ssize_t cfqg_set_leaf_weight_device(struct kernfs_open_file *of,
 }
 
 static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
-			    bool is_leaf_weight)
+			    bool on_dfl, bool reset_dev, bool is_leaf_weight)
 {
+	unsigned int min = on_dfl ? CGROUP_WEIGHT_MIN : CFQ_WEIGHT_LEGACY_MIN;
+	unsigned int max = on_dfl ? CGROUP_WEIGHT_MAX : CFQ_WEIGHT_LEGACY_MAX;
 	struct blkcg *blkcg = css_to_blkcg(css);
 	struct blkcg_gq *blkg;
 	struct cfq_group_data *cfqgd;
 	int ret = 0;
 
-	if (val < CFQ_WEIGHT_LEGACY_MIN || val > CFQ_WEIGHT_LEGACY_MAX)
-		return -EINVAL;
+	if (val < min || val > max)
+		return -ERANGE;
 
 	spin_lock_irq(&blkcg->lock);
 	cfqgd = blkcg_to_cfqgd(blkcg);
@@ -1826,9 +1846,13 @@ static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
 			continue;
 
 		if (!is_leaf_weight) {
+			if (reset_dev)
+				cfqg->dev_weight = 0;
 			if (!cfqg->dev_weight)
 				cfqg->new_weight = cfqgd->weight;
 		} else {
+			if (reset_dev)
+				cfqg->dev_leaf_weight = 0;
 			if (!cfqg->dev_leaf_weight)
 				cfqg->new_leaf_weight = cfqgd->leaf_weight;
 		}
@@ -1842,13 +1866,13 @@ static int __cfq_set_weight(struct cgroup_subsys_state *css, u64 val,
 static int cfq_set_weight(struct cgroup_subsys_state *css, struct cftype *cft,
 			  u64 val)
 {
-	return __cfq_set_weight(css, val, false);
+	return __cfq_set_weight(css, val, false, false, false);
 }
 
 static int cfq_set_leaf_weight(struct cgroup_subsys_state *css,
 			       struct cftype *cft, u64 val)
 {
-	return __cfq_set_weight(css, val, true);
+	return __cfq_set_weight(css, val, false, false, true);
 }
 
 static int cfqg_print_stat(struct seq_file *sf, void *v)
@@ -2135,7 +2159,7 @@ static ssize_t cfq_set_weight_on_dfl(struct kernfs_open_file *of,
 	/* "WEIGHT" or "default WEIGHT" sets the default weight */
 	v = simple_strtoull(buf, &endp, 0);
 	if (*endp == '\0' || sscanf(buf, "default %llu", &v) == 1) {
-		ret = __cfq_set_weight(of_css(of), v, false);
+		ret = __cfq_set_weight(of_css(of), v, true, false, false);
 		return ret ?: nbytes;
 	}
 
@@ -4512,9 +4536,9 @@ static int cfq_init_queue(struct request_queue *q, struct elevator_type *e)
 		goto out_free;
 
 	cfq_init_cfqg_base(cfqd->root_group);
-#endif
 	cfqd->root_group->weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
 	cfqd->root_group->leaf_weight = 2 * CFQ_WEIGHT_LEGACY_DFL;
+#endif
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
@@ -4715,6 +4739,7 @@ static struct blkcg_policy blkcg_policy_cfq = {
 	.cpd_alloc_fn		= cfq_cpd_alloc,
 	.cpd_init_fn		= cfq_cpd_init,
 	.cpd_free_fn		= cfq_cpd_free,
+	.cpd_bind_fn		= cfq_cpd_bind,
 
 	.pd_alloc_fn		= cfq_pd_alloc,
 	.pd_init_fn		= cfq_pd_init,
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 9a7c4bd..0a5cc7a 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -138,6 +138,7 @@ struct blkcg_gq {
 typedef struct blkcg_policy_data *(blkcg_pol_alloc_cpd_fn)(gfp_t gfp);
 typedef void (blkcg_pol_init_cpd_fn)(struct blkcg_policy_data *cpd);
 typedef void (blkcg_pol_free_cpd_fn)(struct blkcg_policy_data *cpd);
+typedef void (blkcg_pol_bind_cpd_fn)(struct blkcg_policy_data *cpd);
 typedef struct blkg_policy_data *(blkcg_pol_alloc_pd_fn)(gfp_t gfp, int node);
 typedef void (blkcg_pol_init_pd_fn)(struct blkg_policy_data *pd);
 typedef void (blkcg_pol_online_pd_fn)(struct blkg_policy_data *pd);
@@ -155,6 +156,7 @@ struct blkcg_policy {
 	blkcg_pol_alloc_cpd_fn		*cpd_alloc_fn;
 	blkcg_pol_init_cpd_fn		*cpd_init_fn;
 	blkcg_pol_free_cpd_fn		*cpd_free_fn;
+	blkcg_pol_bind_cpd_fn		*cpd_bind_fn;
 
 	blkcg_pol_alloc_pd_fn		*pd_alloc_fn;
 	blkcg_pol_init_pd_fn		*pd_init_fn;
-- 
2.4.3
