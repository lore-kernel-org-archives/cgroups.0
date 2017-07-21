From: Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/4] cgroup: Allow bypass mode in subtree_control
Date: Fri, 21 Jul 2017 16:34:51 -0400
Message-ID: <1500669293-21792-3-git-send-email-longman@redhat.com>
References: <1500669293-21792-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 7EB47C00DB8F
In-Reply-To: <1500669293-21792-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Waiman Long <longman@redhat.com>

The special prefix '#' attached to a controller name can now be written
into the cgroup.subtree_control file to set that controller in bypass
mode in all the child cgroups. The controller will show up in the
children's cgroup.controllers file, but the corresponding control knobs
will be absent. However, that controller can be enabled or bypassed
in its children by writing to their respective subtree_control files.

This mode can be useful to non-domain controllers or controllers where
there are costs to each additional layer of hierarchy. This mode will
also allow more freedom in how each controller can shape its effective
hierarchy independent of each others.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt |  67 +++++++++++++++++-----
 include/linux/cgroup-defs.h |  12 ++--
 kernel/cgroup/cgroup.c      | 136 ++++++++++++++++++++++++++++----------------
 3 files changed, 145 insertions(+), 70 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 43f9811..f17a74b 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -24,8 +24,9 @@ v1 is available under Documentation/cgroup-v1/.
      2-3. [Un]populated Notification
      2-4. Controlling Controllers
        2-4-1. Enabling and Disabling
-       2-4-2. Top-down Constraint
-       2-4-3. No Internal Process Constraint
+       2-4-2. Cgroup Hierarchy
+       2-4-3. Top-down Constraint
+       2-4-4. No Internal Process Constraint
      2-5. Delegation
        2-5-1. Model of Delegation
        2-5-2. Delegation Containment
@@ -362,10 +363,15 @@ disabled by writing to the "cgroup.subtree_control" file::
 
   # echo "+cpu +memory -io" > cgroup.subtree_control
 
+The prefixes '+', '-' and '#' are used to enable, disable or put a
+controller in the bypass mode respectively.  In the bypass mode, a
+controller is disabled in a cgroup, but it can be enabled again in its
+child cgroups as it will still be listed in "cgroup.controllers".
+
 Only controllers which are listed in "cgroup.controllers" can be
-enabled.  When multiple operations are specified as above, either they
-all succeed or fail.  If multiple operations on the same controller
-are specified, the last one is effective.
+enabled or bypassed.  When multiple operations are specified as above,
+either they all succeed or fail.  If multiple operations on the same
+controller are specified, the last one is effective.
 
 Enabling a controller in a cgroup indicates that the distribution of
 the target resource across its immediate children will be controlled.
@@ -390,16 +396,47 @@ controller interface files - anything which doesn't start with
 "cgroup." are owned by the parent rather than the cgroup itself.
 
 
+Cgroup Hierarchy
+~~~~~~~~~~~~~~~~
+
+The hierarchy as seen from each controller's perspective can be different
+from that of another controller depending on which controllers are enabled
+or disabled in various nodes within the full cgroup hierarchy.
+
+In the example below::
+
+  A(+) - B(#) - C(#) - D(#) - E(+) - F(-)
+              \ G(+)
+
+The '+', '-' and '#' markers in parenthesis indicate a controller in
+enabled, disabled or bypass mode respectively.
+
+Disabling a controller in a cgroup effectively collapses it to its
+parent from that controller's point of view.  In this case, the
+effective hierarchy as seen from that particular controller will be::
+
+  A|B|C|D - E|F
+          \ G
+
+There are three effective node clusters. The top cluster contains
+(A, B, C, D) with two leaf clusters (E, F) and (G).
+
+Disabling controllers from the leaves up and using bypass mode in
+the middle layers allow controllers to have their own unique views
+of the cgroup hierarchy that can best fit their own need.
+
+
 Top-down Constraint
 ~~~~~~~~~~~~~~~~~~~
 
 Resources are distributed top-down and a cgroup can further distribute
 a resource only if the resource has been distributed to it from the
 parent.  This means that all non-root "cgroup.subtree_control" files
-can only contain controllers which are enabled in the parent's
-"cgroup.subtree_control" file.  A controller can be enabled only if
-the parent has the controller enabled and a controller can't be
-disabled if one or more children have it enabled.
+can only contain controllers which are enabled or bypassed in the parent's
+"cgroup.subtree_control" file.  A controller can be enabled or bypassed
+only if the parent has the controller enabled or bypassed and the
+state of a controller can't be changed if one or more children have
+it enabled or bypassed.
 
 
 No Internal Process Constraint
@@ -836,12 +873,12 @@ All cgroup core files are prefixed with "cgroup."
 	which are enabled to control resource distribution from the
 	cgroup to its children.
 
-	Space separated list of controllers prefixed with '+' or '-'
-	can be written to enable or disable controllers.  A controller
-	name prefixed with '+' enables the controller and '-'
-	disables.  If a controller appears more than once on the list,
-	the last one is effective.  When multiple enable and disable
-	operations are specified, either all succeed or all fail.
+	Space separated list of controllers prefixed with '+', '-' or
+	'#' can be written to enable, disable or bypass controllers
+	respectively.  If a controller appears more than once on
+	the list, the last one is effective.  When multiple enable,
+	disable or bypass operations are specified, either all succeed
+	or all fail.
 
   cgroup.events
 	A read-only flat-keyed file which exists on non-root cgroups.
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 9d74195..3cac6d0 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -295,16 +295,18 @@ struct cgroup {
 	struct cgroup_file events_file;	/* handle for "cgroup.events" */
 
 	/*
-	 * The bitmask of subsystems enabled on the child cgroups.
-	 * ->subtree_control is the one configured through
-	 * "cgroup.subtree_control" while ->child_ss_mask is the effective
-	 * one which may have more subsystems enabled.  Controller knobs
-	 * are made available iff it's enabled in ->subtree_control.
+	 * The bitmask of subsystems enabled or bypassed on the child cgroups.
+	 * ->subtree_control and ->subtree_bypass are the one configured
+	 * through "cgroup.subtree_control" while ->subtree_ss_mask is the
+	 * effective one which may have more subsystems enabled.  Controller
+	 * knobs are made available iff it's enabled in ->subtree_ss_mask.
 	 */
 	u16 subtree_control;
 	u16 subtree_ss_mask;
+	u16 subtree_bypass;
 	u16 old_subtree_control;
 	u16 old_subtree_ss_mask;
+	u16 old_subtree_bypass;
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 5fc8133..1e7feae 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -365,7 +365,8 @@ static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
 		return false;
 
 	/* and no domain controllers can be enabled */
-	if (cgrp->subtree_control & ~cgrp_dfl_threaded_ss_mask)
+	if ((cgrp->subtree_control|cgrp->subtree_bypass) &
+	    ~cgrp_dfl_threaded_ss_mask)
 		return false;
 
 	return true;
@@ -387,7 +388,8 @@ bool cgroup_is_thread_root(struct cgroup *cgrp)
 	 * enabled is a thread root.
 	 */
 	if (cgroup_has_tasks(cgrp) &&
-	    (cgrp->subtree_control & cgrp_dfl_threaded_ss_mask))
+	   ((cgrp->subtree_control|cgrp->subtree_bypass)
+	   & cgrp_dfl_threaded_ss_mask))
 		return true;
 
 	return false;
@@ -412,7 +414,7 @@ static bool cgroup_is_valid_domain(struct cgroup *cgrp)
 }
 
 /* subsystems visibly enabled on a cgroup */
-static u16 cgroup_control(struct cgroup *cgrp)
+static u16 cgroup_control(struct cgroup *cgrp, bool show_bypass)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 root_ss_mask = cgrp->root->subsys_mask;
@@ -420,6 +422,9 @@ static u16 cgroup_control(struct cgroup *cgrp)
 	if (parent) {
 		u16 ss_mask = parent->subtree_control;
 
+		if (show_bypass)
+			ss_mask |= parent->subtree_bypass;
+
 		/* threaded cgroups can only have threaded controllers */
 		if (cgroup_is_threaded(cgrp))
 			ss_mask &= cgrp_dfl_threaded_ss_mask;
@@ -433,13 +438,17 @@ static u16 cgroup_control(struct cgroup *cgrp)
 }
 
 /* subsystems enabled on a cgroup */
-static u16 cgroup_ss_mask(struct cgroup *cgrp)
+static u16 cgroup_ss_mask(struct cgroup *cgrp, bool show_bypass)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 
 	if (parent) {
 		u16 ss_mask = parent->subtree_ss_mask;
 
+
+		if (show_bypass)
+			ss_mask |= parent->subtree_bypass;
+
 		/* threaded cgroups can only have threaded controllers */
 		if (cgroup_is_threaded(cgrp))
 			ss_mask &= cgrp_dfl_threaded_ss_mask;
@@ -492,7 +501,7 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	 * This function is used while updating css associations and thus
 	 * can't test the csses directly.  Test ss_mask.
 	 */
-	while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
+	while (!(cgroup_ss_mask(cgrp, false) & (1 << ss->id))) {
 		cgrp = cgroup_parent(cgrp);
 		if (!cgrp)
 			return NULL;
@@ -2355,7 +2364,7 @@ int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
 		return 0;
 
 	/* apply no-internal-process constraint */
-	if (dst_cgrp->subtree_control)
+	if (dst_cgrp->subtree_control|dst_cgrp->subtree_bypass)
 		return -EBUSY;
 
 	return 0;
@@ -2653,15 +2662,18 @@ void cgroup_procs_write_finish(struct task_struct *task)
 			ss->post_attach();
 }
 
-static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
+static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask,
+				 u16 bypass_mask)
 {
 	struct cgroup_subsys *ss;
 	bool printed = false;
 	int ssid;
 
-	do_each_subsys_mask(ss, ssid, ss_mask) {
+	do_each_subsys_mask(ss, ssid, ss_mask|bypass_mask) {
 		if (printed)
 			seq_putc(seq, ' ');
+		if (!(ss_mask & (1 << ssid)))
+			seq_putc(seq, '#');
 		seq_printf(seq, "%s", ss->name);
 		printed = true;
 	} while_each_subsys_mask();
@@ -2673,8 +2685,10 @@ static void cgroup_print_ss_mask(struct seq_file *seq, u16 ss_mask)
 static int cgroup_controllers_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct cgroup *parent = cgroup_parent(cgrp);
+	u16 bypass = parent ? parent->subtree_bypass : 0;
 
-	cgroup_print_ss_mask(seq, cgroup_control(cgrp));
+	cgroup_print_ss_mask(seq, cgroup_control(cgrp, false), bypass);
 	return 0;
 }
 
@@ -2683,7 +2697,7 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgrp->subtree_control);
+	cgroup_print_ss_mask(seq, cgrp->subtree_control, cgrp->subtree_bypass);
 	return 0;
 }
 
@@ -2796,6 +2810,7 @@ static void cgroup_save_control(struct cgroup *cgrp)
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		dsct->old_subtree_control = dsct->subtree_control;
 		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
+		dsct->old_subtree_bypass  = dsct->subtree_bypass;
 	}
 }
 
@@ -2813,10 +2828,13 @@ static void cgroup_propagate_control(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
-		dsct->subtree_control &= cgroup_control(dsct);
+		u16 mask = cgroup_control(dsct, true);
+
+		dsct->subtree_control &= mask;
+		dsct->subtree_bypass  &= mask;
 		dsct->subtree_ss_mask =
 			cgroup_calc_subtree_ss_mask(dsct->subtree_control,
-						    cgroup_ss_mask(dsct));
+						cgroup_ss_mask(dsct, true));
 	}
 }
 
@@ -2835,6 +2853,7 @@ static void cgroup_restore_control(struct cgroup *cgrp)
 	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
 		dsct->subtree_control = dsct->old_subtree_control;
 		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
+		dsct->subtree_bypass  = dsct->old_subtree_bypass;
 	}
 }
 
@@ -2843,9 +2862,9 @@ static bool css_visible(struct cgroup_subsys_state *css)
 	struct cgroup_subsys *ss = css->ss;
 	struct cgroup *cgrp = css->cgroup;
 
-	if (cgroup_control(cgrp) & (1 << ss->id))
+	if (cgroup_control(cgrp, false) & (1 << ss->id))
 		return true;
-	if (!(cgroup_ss_mask(cgrp) & (1 << ss->id)))
+	if (!(cgroup_ss_mask(cgrp, false) & (1 << ss->id)))
 		return false;
 	return cgroup_on_dfl(cgrp) && ss->implicit_on_dfl;
 }
@@ -2876,7 +2895,7 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 
 			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
 
-			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)))
+			if (!(cgroup_ss_mask(dsct, false) & (1 << ss->id)))
 				continue;
 
 			if (!css) {
@@ -2926,7 +2945,7 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 				continue;
 
 			if (css->parent &&
-			    !(cgroup_ss_mask(dsct) & (1 << ss->id))) {
+			    !(cgroup_ss_mask(dsct, false) & (1 << ss->id))) {
 				kill_css(css);
 			} else if (!css_visible(css)) {
 				css_clear_dir(css);
@@ -3038,7 +3057,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
 					    loff_t off)
 {
-	u16 enable = 0, disable = 0;
+	u16 enable = 0, disable = 0, bypass = 0;
+	u16 child_enable = 0;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -3059,10 +3079,16 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 			if (*tok == '+') {
 				enable |= 1 << ssid;
+				bypass &= ~(1 << ssid);
 				disable &= ~(1 << ssid);
 			} else if (*tok == '-') {
 				disable |= 1 << ssid;
 				enable &= ~(1 << ssid);
+				bypass &= ~(1 << ssid);
+			} else if (*tok == '#') {
+				bypass |= 1 << ssid;
+				enable &= ~(1 << ssid);
+				disable &= ~(1 << ssid);
 			} else {
 				return -EINVAL;
 			}
@@ -3076,35 +3102,35 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	if (!cgrp)
 		return -ENODEV;
 
-	for_each_subsys(ss, ssid) {
-		if (enable & (1 << ssid)) {
-			if (cgrp->subtree_control & (1 << ssid)) {
-				enable &= ~(1 << ssid);
-				continue;
-			}
+	/*
+	 * Cannot use controllers that aren't allowed.
+	 */
+	if (~cgroup_control(cgrp, true) & (enable|disable|bypass)) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
 
-			if (!(cgroup_control(cgrp) & (1 << ssid))) {
-				ret = -ENOENT;
-				goto out_unlock;
-			}
-		} else if (disable & (1 << ssid)) {
-			if (!(cgrp->subtree_control & (1 << ssid))) {
-				disable &= ~(1 << ssid);
-				continue;
-			}
+	/*
+	 * Strip out redundant bits.
+	 */
+	enable  &= ~cgrp->subtree_control;
+	bypass  &= ~cgrp->subtree_bypass;
+	disable &= (cgrp->subtree_control|cgrp->subtree_bypass);
 
-			/* a child has it enabled? */
-			cgroup_for_each_live_child(child, cgrp) {
-				if (child->subtree_control & (1 << ssid)) {
-					ret = -EBUSY;
-					goto out_unlock;
-				}
-			}
-		}
+	if (!(enable|bypass|disable)) {
+		ret = 0;
+		goto out_unlock;
 	}
 
-	if (!enable && !disable) {
-		ret = 0;
+
+	cgroup_for_each_live_child(child, cgrp)
+		child_enable |= child->subtree_control|child->subtree_bypass;
+
+	/*
+	 * Cannot change the state of a controller if enabled in children.
+	 */
+	if ((enable|bypass|disable) & child_enable) {
+		ret = -EBUSY;
 		goto out_unlock;
 	}
 
@@ -3116,7 +3142,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgroup_save_control(cgrp);
 
 	cgrp->subtree_control |= enable;
-	cgrp->subtree_control &= ~disable;
+	cgrp->subtree_control &= ~(bypass|disable);
+	cgrp->subtree_bypass  |= bypass;
+	cgrp->subtree_bypass  &= ~(enable|disable);
 
 	ret = cgroup_apply_control(cgrp);
 
@@ -4441,7 +4469,8 @@ static void css_release(struct percpu_ref *ref)
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
-			      struct cgroup_subsys *ss, struct cgroup *cgrp)
+			      struct cgroup_subsys *ss, struct cgroup *cgrp,
+			      struct cgroup_subsys_state *parent_css)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -4456,8 +4485,8 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	css->serial_nr = css_serial_nr_next++;
 	atomic_set(&css->online_cnt, 0);
 
-	if (cgroup_parent(cgrp)) {
-		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
+	if (parent_css) {
+		css->parent = parent_css;
 		css_get(css->parent);
 	}
 
@@ -4520,19 +4549,26 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	struct cgroup_subsys_state *parent_css = cgroup_css(parent, ss);
+	struct cgroup_subsys_state *parent_css = NULL;
 	struct cgroup_subsys_state *css;
 	int err;
 
 	lockdep_assert_held(&cgroup_mutex);
 
+	/*
+	 * As cgroup may be in bypass mode, need to skip over ancestor
+	 * cgroups with NULL CSS.
+	 */
+	for (; parent && !parent_css; parent = cgroup_parent(parent))
+		parent_css = cgroup_css(parent, ss);
+
 	css = ss->css_alloc(parent_css);
 	if (!css)
 		css = ERR_PTR(-ENOMEM);
 	if (IS_ERR(css))
 		return css;
 
-	init_and_link_css(css, ss, cgrp);
+	init_and_link_css(css, ss, cgrp, parent_css);
 
 	err = percpu_ref_init(&css->refcnt, css_release, 0, GFP_KERNEL);
 	if (err)
@@ -4634,7 +4670,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 * subtree_control from the parent.  Each is configured manually.
 	 */
 	if (!cgroup_on_dfl(cgrp))
-		cgrp->subtree_control = cgroup_control(cgrp);
+		cgrp->subtree_control = cgroup_control(cgrp, false);
 
 	if (parent)
 		cgroup_bpf_inherit(cgrp, parent);
@@ -4921,7 +4957,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	css = ss->css_alloc(cgroup_css(&cgrp_dfl_root.cgrp, ss));
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
-	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
+	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp, NULL);
 
 	/*
 	 * Root csses are never destroyed and we can't initialize
-- 
1.8.3.1

