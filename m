From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] cgroup: implement cgroup_subsys->implicit_on_dfl
Date: Thu,  7 Jan 2016 17:29:49 -0500
Message-ID: <1452205790-21331-6-git-send-email-tj@kernel.org>
References: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=53zS6mKisiksKONuNQWJw0cf+9qEMyiA/vzitJ9or4g=;
        b=rDttXT4uVkYmTZ7MBV5qIXmJlDyyjIX3TI0neW9uM9wbGYmLgskXVmLK66GOXlIQM1
         mGGwx9BAvqNZZMMJgG+0VMMUhOKGChP8FJ2+/OY3OxNahNEhQiWPccDJwKn0jskSQi3i
         54zYh7YBjJwNNiH+o09ao7coRd2eQzt7ZeVNGwwNifSRM7EdOaZxa7iYOkMGAPO4uFFl
         Zp3UON5xZDdgnkBj3bmqhPMuGwpA4eufBxzX/TZUpStM9hSWrL4JMLG9jQk4IGoIw7+M
         n0FGfs6BWqVal32bv+LB4m4giSzuWfy94uJkXERSEzmOn0xzTS3CcEZsxLWsF3AaDaUP
         islw==
In-Reply-To: <1452205790-21331-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, a.p.zijlstra@chello.nl, mingo@redhat.com, acme@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Some controllers, perf_event for now and possibly freezer in the
future, don't really make sense to control explicitly through
"cgroup.subtree_control".  For example, the primary role of perf_event
is identifying the cgroups of tasks; however, because the controller
also keeps a small amount of state per cgroup, it can't be replaced
with simple cgroup membership tests.

This patch implements cgroup_subsys->implicit_on_dfl flag.  When set,
the controller is implicitly enabled on all cgroups on the v2
hierarchy so that utility type controllers such as perf_event can be
enabled and function transparently.

An implicit controller doesn't show up in "cgroup.controllers" or
"cgroup.subtree_control", is exempt from no internal process rule and
can be stolen from the default hierarchy even if there are non-root
csses.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  15 +++++++
 kernel/cgroup.c             | 106 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 104 insertions(+), 17 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index dc6f0ce..e7f69ef7 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -443,6 +443,21 @@ struct cgroup_subsys {
 	bool early_init:1;
 
 	/*
+	 * If %true, the controller, on the default hierarchy, doesn't show
+	 * up in "cgroup.controllers" or "cgroup.subtree_control", is
+	 * implicitly enabled on all cgroups on the default hierarchy, and
+	 * bypasses the "no internal process" constraint.  This is for
+	 * utility type controllers which is transparent to userland.
+	 *
+	 * For an implicit controller to be available to the default
+	 * hierarchy, it shouldn't be attached to a legacy hierarchy when
+	 * the default hierarchy is first mounted.  A legacy hierarchy can
+	 * steal an implicit controller but it can't be given back to the
+	 * default hierarchy afterwards.
+	 */
+	bool implicit_on_dfl:1;
+
+	/*
 	 * If %false, this subsystem is properly hierarchical -
 	 * configuration, resource accounting and restriction on a parent
 	 * cgroup cover those of its children.  If %true, hierarchy support
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8bc83fd..bd86106 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -182,6 +182,9 @@ static bool cgrp_dfl_visible;
 /* some controllers are not supported in the default hierarchy */
 static unsigned long cgrp_dfl_inhibit_ss_mask;
 
+/* some controllers are implicitly enabled on the default hierarchy */
+static unsigned long cgrp_dfl_implicit_ss_mask;
+
 /* The list of hierarchy roots */
 
 static LIST_HEAD(cgroup_roots);
@@ -215,6 +218,7 @@ static struct file_system_type cgroup2_fs_type;
 static struct cftype cgroup_dfl_base_files[];
 static struct cftype cgroup_legacy_base_files[];
 
+static int cgroup_update_dfl_csses(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned long ss_mask);
 static void css_task_iter_advance(struct css_task_iter *it);
@@ -1272,6 +1276,8 @@ static unsigned long cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
 	if (!cgroup_on_dfl(cgrp))
 		return cur_ss_mask;
 
+	cur_ss_mask |= cgrp_dfl_implicit_ss_mask;
+
 	while (true) {
 		unsigned long new_ss_mask = cur_ss_mask;
 
@@ -1450,6 +1456,32 @@ static int css_populate_dir(struct cgroup_subsys_state *css,
 	return ret;
 }
 
+static void steal_implicit_ss(struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *css;
+
+	if (cgrp_dfl_visible) {
+		pr_info("%s is detached from and won't be available on v2 hierarchy\n",
+			ss->name);
+		cgrp_dfl_implicit_ss_mask &= ~(1 << ss->id);
+	}
+
+	/*
+	 * With @ss cleared from the implicit_ss_mask, the following will
+	 * clear it from ->child_subsys_mask on all dfl cgroups.
+	 */
+	css_for_each_descendant_post(css, cgroup_css(&cgrp_dfl_root.cgrp, ss))
+		cgroup_refresh_child_subsys_mask(css->cgroup);
+
+	/* migrate all processes to the root */
+	WARN_ON_ONCE(cgroup_update_dfl_csses(&cgrp_dfl_root.cgrp));
+
+	/* and kill all !root csses */
+	css_for_each_descendant_post(css, cgroup_css(&cgrp_dfl_root.cgrp, ss))
+		if (css->parent)
+			kill_css(css);
+}
+
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned long ss_mask)
 {
@@ -1461,8 +1493,13 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 	lockdep_assert_held(&cgroup_mutex);
 
 	for_each_subsys_which(ss, ssid, &ss_mask) {
-		/* if @ss has non-root csses attached to it, can't move */
-		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
+		/*
+		 * If @ss has non-root csses attached to it, can't move.
+		 * If @ss is an implicit controller on dfl, it can be
+		 * stolen and is exempt from this rule.
+		 */
+		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)) &&
+		    !(ss->implicit_on_dfl && ss->root == &cgrp_dfl_root))
 			return -EBUSY;
 
 		/* can't move between two non-dummy roots either */
@@ -1470,6 +1507,11 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 			return -EBUSY;
 	}
 
+	/* steal implcit controllers on dfl */
+	for_each_subsys_which(ss, ssid, &ss_mask)
+		if (ss->implicit_on_dfl && ss->root == &cgrp_dfl_root)
+			steal_implicit_ss(ss);
+
 	/* skip creating root files on dfl_root for inhibited subsystems */
 	tmp_ss_mask = ss_mask;
 	if (dst_root == &cgrp_dfl_root)
@@ -1973,9 +2015,9 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct super_block *pinned_sb = NULL;
 	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
-	struct cgroup_sb_opts opts;
+	struct cgroup_sb_opts opts = { };
 	struct dentry *dentry;
-	int ret;
+	int ret = 0;
 	int i;
 	bool new_sb;
 
@@ -1986,18 +2028,41 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
 
+	mutex_lock(&cgroup_mutex);
+
 	if (is_v2) {
 		if (data) {
 			pr_err("cgroup2: unknown option \"%s\"\n", (char *)data);
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto out_unlock;
 		}
-		cgrp_dfl_visible = true;
+
 		root = &cgrp_dfl_root;
 		cgroup_get(&root->cgrp);
-		goto out_mount;
-	}
 
-	mutex_lock(&cgroup_mutex);
+		/*
+		 * dfl hierarchy is being mounted for the first time.
+		 * Toggle its visibility and see which implicit controllers
+		 * are available.
+		 */
+		if (!cgrp_dfl_visible) {
+			cgrp_dfl_visible = true;
+
+			for_each_subsys_which(ss, i, &cgrp_dfl_implicit_ss_mask) {
+				if (ss->root == &cgrp_dfl_root)
+					continue;
+
+				pr_info("%s is busy and won't be available on v2 hierarchy\n",
+					ss->name);
+				cgrp_dfl_implicit_ss_mask &= ~(1 << ss->id);
+			}
+
+			/* apply implicit_ss_mask to the root */
+			cgroup_refresh_child_subsys_mask(&cgrp_dfl_root.cgrp);
+		}
+
+		goto out_unlock;
+	}
 
 	/* First find the desired set of subsystems */
 	ret = parse_cgroupfs_options(data, &opts);
@@ -2114,7 +2179,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 	if (ret)
 		return ERR_PTR(ret);
-out_mount:
+
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
 			      is_v2 ? CGROUP2_SUPER_MAGIC : CGROUP_SUPER_MAGIC,
 			      &new_sb);
@@ -2826,6 +2891,8 @@ static void cgroup_print_ss_mask(struct seq_file *seq, unsigned long ss_mask)
 	bool printed = false;
 	int ssid;
 
+	ss_mask &= ~cgrp_dfl_implicit_ss_mask;
+
 	for_each_subsys_which(ss, ssid, &ss_mask) {
 		if (printed)
 			seq_putc(seq, ' ');
@@ -2944,7 +3011,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 */
 	buf = strstrip(buf);
 	while ((tok = strsep(&buf, " "))) {
-		unsigned long tmp_ss_mask = ~cgrp_dfl_inhibit_ss_mask;
+		unsigned long tmp_ss_mask = ~(cgrp_dfl_inhibit_ss_mask |
+					      cgrp_dfl_implicit_ss_mask);
 
 		if (tok[0] == '\0')
 			continue;
@@ -4970,8 +5038,10 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	/* let's create and online css's */
 	for_each_subsys(ss, ssid) {
 		if (parent->child_subsys_mask & (1 << ssid)) {
-			ret = create_css(cgrp, ss,
-					 parent->subtree_control & (1 << ssid));
+			bool visible = ss->implicit_on_dfl ||
+				(parent->subtree_control & (1 << ssid));
+
+			ret = create_css(cgrp, ss, visible);
 			if (ret)
 				goto out_destroy;
 		}
@@ -4981,10 +5051,10 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	 * On the default hierarchy, a child doesn't automatically inherit
 	 * subtree_control from the parent.  Each is configured manually.
 	 */
-	if (!cgroup_on_dfl(cgrp)) {
+	if (!cgroup_on_dfl(cgrp))
 		cgrp->subtree_control = parent->subtree_control;
-		cgroup_refresh_child_subsys_mask(cgrp);
-	}
+
+	cgroup_refresh_child_subsys_mask(cgrp);
 
 	kernfs_activate(kn);
 
@@ -5311,7 +5381,9 @@ int __init cgroup_init(void)
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
-		if (!ss->dfl_cftypes)
+		if (ss->implicit_on_dfl)
+			cgrp_dfl_implicit_ss_mask |= 1 << ss->id;
+		else if (!ss->dfl_cftypes)
 			cgrp_dfl_inhibit_ss_mask |= 1 << ss->id;
 
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
-- 
2.5.0

