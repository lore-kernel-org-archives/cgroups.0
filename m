From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] cgroup: s/child_subsys_mask/subtree_ss_mask/
Date: Mon, 22 Feb 2016 18:05:46 -0500
Message-ID: <1456182349-18156-4-git-send-email-tj@kernel.org>
References: <1456182349-18156-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VaqoGY04VISeGLhcSviMatrjN/JmQ5/8mU56rM0yRMk=;
        b=QqngkIWfr6/XupQlohbp1TmJKo9tqSX4q6fyLeP4eb9KqoMUiRfDkjadqQ3FxD7auO
         AEkcq6BkqYc9hU40p7SiggwBZq1qTOPhYgc146ZzM/mPiT2p5AClL6Seu4B4g1BYPEih
         aTU2Fy+RLfdimH8JIvHD1GU7NHn3QxGmyrB5zt+lACZvcK85Nw4s16mvru+6JVn5b5qk
         NiIx/5dlweDSFlP8VgMXnVGXlxTiwW2HnWYC3aSQyWVkMXbB9ZPfJj5K/FqgyS/KJ+xK
         KTfeARbAXY+HYjluQ5Q2QN/22oqDoMu6pnCYkqT/2C4lQxb6yWlGHpgnAtF85QD4Dru9
         qCUw==
In-Reply-To: <1456182349-18156-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

For consistency with cgroup->subtree_control.

* cgroup->child_subsys_mask -> cgroup->subtree_ss_mask
* cgroup_calc_child_subsys_mask() -> cgroup_calc_subtree_ss_mask()
* cgroup_refresh_child_subsys_mask() -> cgroup_refresh_subtree_ss_mask()

No functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h | 11 +++++------
 kernel/cgroup.c             | 48 ++++++++++++++++++++++-----------------------
 2 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 4f3c0da..c68ae7f 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -253,13 +253,12 @@ struct cgroup {
 	/*
 	 * The bitmask of subsystems enabled on the child cgroups.
 	 * ->subtree_control is the one configured through
-	 * "cgroup.subtree_control" while ->child_subsys_mask is the
-	 * effective one which may have more subsystems enabled.
-	 * Controller knobs are made available iff it's enabled in
-	 * ->subtree_control.
+	 * "cgroup.subtree_control" while ->child_ss_mask is the effective
+	 * one which may have more subsystems enabled.  Controller knobs
+	 * are made available iff it's enabled in ->subtree_control.
 	 */
-	unsigned int subtree_control;
-	unsigned int child_subsys_mask;
+	unsigned long subtree_control;
+	unsigned long subtree_ss_mask;
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7727b6e..f3cd67b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -391,10 +391,10 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 
 	/*
 	 * This function is used while updating css associations and thus
-	 * can't test the csses directly.  Use ->child_subsys_mask.
+	 * can't test the csses directly.  Use ->subtree_ss_mask.
 	 */
 	while (cgroup_parent(cgrp) &&
-	       !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ss->id)))
+	       !(cgroup_parent(cgrp)->subtree_ss_mask & (1 << ss->id)))
 		cgrp = cgroup_parent(cgrp);
 
 	return cgroup_css(cgrp, ss);
@@ -1256,7 +1256,7 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 }
 
 /**
- * cgroup_calc_child_subsys_mask - calculate child_subsys_mask
+ * cgroup_calc_subtree_ss_mask - calculate subtree_ss_mask
  * @cgrp: the target cgroup
  * @subtree_control: the new subtree_control mask to consider
  *
@@ -1268,8 +1268,8 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
  * @subtree_control is to be applied to @cgrp.  The returned mask is always
  * a superset of @subtree_control and follows the usual hierarchy rules.
  */
-static unsigned long cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
-						  unsigned long subtree_control)
+static unsigned long cgroup_calc_subtree_ss_mask(struct cgroup *cgrp,
+						 unsigned long subtree_control)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	unsigned long cur_ss_mask = subtree_control;
@@ -1293,7 +1293,7 @@ static unsigned long cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
 		 * to non-default hierarchies.
 		 */
 		if (parent)
-			new_ss_mask &= parent->child_subsys_mask;
+			new_ss_mask &= parent->subtree_ss_mask;
 		else
 			new_ss_mask &= cgrp->root->subsys_mask;
 
@@ -1306,16 +1306,16 @@ static unsigned long cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
 }
 
 /**
- * cgroup_refresh_child_subsys_mask - update child_subsys_mask
+ * cgroup_refresh_subtree_ss_mask - update subtree_ss_mask
  * @cgrp: the target cgroup
  *
- * Update @cgrp->child_subsys_mask according to the current
- * @cgrp->subtree_control using cgroup_calc_child_subsys_mask().
+ * Update @cgrp->subtree_ss_mask according to the current
+ * @cgrp->subtree_control using cgroup_calc_subtree_ss_mask().
  */
-static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
+static void cgroup_refresh_subtree_ss_mask(struct cgroup *cgrp)
 {
-	cgrp->child_subsys_mask =
-		cgroup_calc_child_subsys_mask(cgrp, cgrp->subtree_control);
+	cgrp->subtree_ss_mask =
+		cgroup_calc_subtree_ss_mask(cgrp, cgrp->subtree_control);
 }
 
 /**
@@ -1542,7 +1542,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 
 		src_root->subsys_mask &= ~(1 << ssid);
 		scgrp->subtree_control &= ~(1 << ssid);
-		cgroup_refresh_child_subsys_mask(scgrp);
+		cgroup_refresh_subtree_ss_mask(scgrp);
 
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
@@ -1550,7 +1550,7 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 			static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
 		} else {
 			dcgrp->subtree_control |= 1 << ssid;
-			cgroup_refresh_child_subsys_mask(dcgrp);
+			cgroup_refresh_subtree_ss_mask(dcgrp);
 			static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
 		}
 
@@ -2523,11 +2523,11 @@ static int cgroup_migrate_prepare_dst(struct cgroup *dst_cgrp,
 	lockdep_assert_held(&cgroup_mutex);
 
 	/*
-	 * Except for the root, child_subsys_mask must be zero for a cgroup
+	 * Except for the root, subtree_ss_mask must be zero for a cgroup
 	 * with tasks so that child cgroups don't compete against tasks.
 	 */
 	if (dst_cgrp && cgroup_on_dfl(dst_cgrp) && cgroup_parent(dst_cgrp) &&
-	    dst_cgrp->child_subsys_mask)
+	    dst_cgrp->subtree_ss_mask)
 		return -EBUSY;
 
 	/* look up the dst cset for each src cset and link it to src */
@@ -2880,7 +2880,7 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
  * cgroup_update_dfl_csses - update css assoc of a subtree in default hierarchy
  * @cgrp: root of the subtree to update csses for
  *
- * @cgrp's child_subsys_mask has changed and its subtree's (self excluded)
+ * @cgrp's subtree_ss_mask has changed and its subtree's (self excluded)
  * css associations need to be updated accordingly.  This function looks up
  * all css_sets which are attached to the subtree, creates the matching
  * updated css_sets and migrates the tasks to the new ones.
@@ -2902,7 +2902,7 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
 	css_for_each_descendant_pre(css, cgroup_css(cgrp, NULL)) {
 		struct cgrp_cset_link *link;
 
-		/* self is not affected by child_subsys_mask change */
+		/* self is not affected by subtree_ss_mask change */
 		if (css->cgroup == cgrp)
 			continue;
 
@@ -3034,9 +3034,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * depending on subsystem dependencies.
 	 */
 	old_sc = cgrp->subtree_control;
-	old_ss = cgrp->child_subsys_mask;
+	old_ss = cgrp->subtree_ss_mask;
 	new_sc = (old_sc | enable) & ~disable;
-	new_ss = cgroup_calc_child_subsys_mask(cgrp, new_sc);
+	new_ss = cgroup_calc_subtree_ss_mask(cgrp, new_sc);
 
 	css_enable = ~old_ss & new_ss;
 	css_disable = old_ss & ~new_ss;
@@ -3069,7 +3069,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	}
 
 	cgrp->subtree_control = new_sc;
-	cgrp->child_subsys_mask = new_ss;
+	cgrp->subtree_ss_mask = new_ss;
 
 	/*
 	 * Create new csses or make the existing ones visible.  A css is
@@ -3135,7 +3135,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 err_undo_css:
 	cgrp->subtree_control = old_sc;
-	cgrp->child_subsys_mask = old_ss;
+	cgrp->subtree_ss_mask = old_ss;
 
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
@@ -4969,7 +4969,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 
 	/* let's create and online css's */
 	for_each_subsys(ss, ssid) {
-		if (parent->child_subsys_mask & (1 << ssid)) {
+		if (parent->subtree_ss_mask & (1 << ssid)) {
 			ret = create_css(cgrp, ss,
 					 parent->subtree_control & (1 << ssid));
 			if (ret)
@@ -4983,7 +4983,7 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 	 */
 	if (!cgroup_on_dfl(cgrp)) {
 		cgrp->subtree_control = parent->subtree_control;
-		cgroup_refresh_child_subsys_mask(cgrp);
+		cgroup_refresh_subtree_ss_mask(cgrp);
 	}
 
 	kernfs_activate(kn);
-- 
2.5.0

