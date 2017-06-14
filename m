From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 2/6] cgroup: Enable bypass mode in cgroup v2
Date: Wed, 14 Jun 2017 11:05:33 -0400
Message-ID: <1497452737-11125-3-git-send-email-longman@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 27E55285C1
In-Reply-To: <1497452737-11125-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

For cgroup v1, different controllers can be binded to different cgroup
hierarchies optimized for their own use cases. That is not currently
the case for cgroup v2 where combining all these controllers into
the same hierarchy will probably require more levels than is needed
by each individual controller.

By not enabling a controller in a cgroup and its descendants, we can
effectively trim the hierarchy as seen by a controller from the leafs
up. However, there is currently no way to compress the hierarchy in
the intermediate levels.

This patch implements a new bypass mechanism to allow a controller to
skip some intermediate levels in a hierarchy and effectively flatten
the hierarchy as seen by that controller.

Controllers enabled by the parent's "cgroup.subtree_control"
file can now be set into a special bypass mode by writing to the
"cgroup.controllers" file with the special '#' prefix attached to the
controller name.  In that mode, the controller is disabled for that
cgroup but it allows its children to have that controller enabled or in
bypass mode again. The bypass mode is removed by using the '+' prefix.

With this change, each controller can now have a unique view of their
virtual process hierarchy that can be quite different from other
controllers.  We now have the freedom and flexibility to create the
right hierarchy for each controller to suit their own needs without
performance loss when compared with cgroup v1.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt |  98 ++++++++++++++++----
 include/linux/cgroup-defs.h |   8 ++
 kernel/cgroup/cgroup.c      | 211 ++++++++++++++++++++++++++++++++++++--------
 3 files changed, 263 insertions(+), 54 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 98f92b1..0df06ba 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -323,25 +323,28 @@ both cgroups.
 2-4-1. Enabling and Disabling
 
 Each cgroup has a "cgroup.controllers" file which lists all
-controllers available for the cgroup to enable.
+controllers available for the cgroup to enable for its children.
 
   # cat cgroup.controllers
   cpu io memory
 
-No controller is enabled by default.  Controllers can be enabled and
-disabled by writing to the "cgroup.subtree_control" file.
+No controller is enabled by default.  Controllers can be
+enabled and disabled on the child cgroups by writing to the
+"cgroup.subtree_control" file.  A '+' prefix enables the controller,
+and a '-' prefix disables it.
 
   # echo "+cpu +memory -io" > cgroup.subtree_control
 
-Only controllers which are listed in "cgroup.controllers" can be
-enabled.  When multiple operations are specified as above, either they
-all succeed or fail.  If multiple operations on the same controller
-are specified, the last one is effective.
+Only controllers which are listed in "cgroup.controllers" can
+be enabled in the "cgroup.subtree_control" file.  When multiple
+operations are specified as above, either they all succeed or fail.
+If multiple operations on the same controller are specified, the last
+one is effective.
 
 Enabling a controller in a cgroup indicates that the distribution of
 the target resource across its immediate children will be controlled.
-Consider the following sub-hierarchy.  The enabled controllers are
-listed in parentheses.
+Consider the following sub-hierarchy.  The enabled controllers in the
+"cgroup.subtree_control" file are listed in parentheses.
 
   A(cpu,memory) - B(memory) - C()
                             \ D()
@@ -351,6 +354,17 @@ of CPU cycles and memory to its children, in this case, B.  As B has
 "memory" enabled but not "CPU", C and D will compete freely on CPU
 cycles but their division of memory available to B will be controlled.
 
+By not enabling a controller in a cgroup and its descendants, we can
+effectively trim the hierarchy as seen by a controller from the leafs
+up.  From the perspective of the cpu controller, the hierarchy is:
+
+  A - B|C|D
+
+From the perspective of the memory controller, the hierarchy becomes:
+
+  A - B - C
+        \ D
+
 As a controller regulates the distribution of the target resource to
 the cgroup's children, enabling it creates the controller's interface
 files in the child cgroups.  In the above example, enabling "cpu" on B
@@ -358,7 +372,55 @@ would create the "cpu." prefixed controller interface files in C and
 D.  Likewise, disabling "memory" from B would remove the "memory."
 prefixed controller interface files from C and D.  This means that the
 controller interface files - anything which doesn't start with
-"cgroup." are owned by the parent rather than the cgroup itself.
+"cgroup." can be considered to be owned by the parent under this
+control scheme.
+
+Enabling controllers via the "cgroup.subtree_control" file is
+relatively coarse-grained.  Finer-grained control of the controllers
+in a non-root cgroup can be done by writing a controller name with
+either a '#' or '+' prefix to its "cgroup.controllers" file directly.
+
+Writing the special prefix '#' with the controller name
+into "cgroup.controllers" is used to mark that controller in
+bypass mode.  Only controllers that are enabled at the parent's
+"cgroup.subtree_control" file can be used.  In this mode, the
+controller is disabled in the cgroup effectively collapsing it with
+its parent from the perspective of that controller.  However, it allows
+the enablement of that controller in the "cgroup.subtree_control"
+file and hence enabled in the child cgroups.  The bypass mode can be
+disabled by using the '+' prefix to re-enable the controller.
+
+In the example below, '+' corresponds to an enabled controller and
+corresponds to a bypassed controller.
+
+   +   #   #   #   +
+   A - B - C - D - E
+         \ F
+	   +
+In this case, the effective hiearchy is:
+
+	A|B|C|D - E
+	        \ F
+
+The use of the special '#' prefix allows the users to trim away layers
+in the middle of the hierarchy, thus flattening the tree from the
+perspective of that particular controller.  As a result, different
+controllers can have quite different views of their virtual process
+hierarchy that can best fit their own needs.
+
+In the diagram below, the controller name in the parenthesis represents
+controller enabled as shown in the "cgroup.controllers" file.
+
+  A(cpu,memory) - B(cpu,#memory) - C()
+                                 \ D(memory)
+
+From the memory controller's perspective, the hierarchy looks like:
+
+   A|B|C - D
+
+For the CPU controller, the hierarchy is:
+
+   A - B|C|D
 
 
 2-4-2. Top-down Constraint
@@ -368,8 +430,8 @@ a resource only if the resource has been distributed to it from the
 parent.  This means that all non-root "cgroup.subtree_control" files
 can only contain controllers which are enabled in the parent's
 "cgroup.subtree_control" file.  A controller can be enabled only if
-the parent has the controller enabled and a controller can't be
-disabled if one or more children have it enabled.
+the parent has the controller enabled ('+' or '#') and a controller
+can't be disabled if one or more children have it enabled.
 
 
 2-4-3. No Internal Process Constraint
@@ -725,11 +787,17 @@ All cgroup core files are prefixed with "cgroup."
 
   cgroup.controllers
 
-	A read-only space separated values file which exists on all
+	A read-write space separated values file which exists on all
 	cgroups.
 
-	It shows space separated list of all controllers available to
-	the cgroup.  The controllers are not ordered.
+	When read, it shows space separated list of all controllers
+	available to the cgroup.  The controllers are not ordered.
+
+	Space separated list of controllers prefixed with '+' or '#'
+	can be written to re-enable or set the controllers in bypass
+	mode.  If a controller appears more than once on the list,
+	the last one is effective.  When multiple re-enable and bypass
+	operations are specified, either all succeed or all fail.
 
   cgroup.subtree_control
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index ea3218a..f5c1e36 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -289,6 +289,14 @@ struct cgroup {
 	u16 old_subtree_control;
 	u16 old_subtree_ss_mask;
 
+	/*
+	 * The bitmasks of subsystems in bypass mode on the current cgroup.
+	 * The bypass mode can only be set if a controller is enabled at
+	 * the parent subtree_control mask.
+	 */
+	u16 bypass_ss_mask;
+	u16 old_bypass_ss_mask;
+
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f72dce1..7d1326e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2598,15 +2598,18 @@ void cgroup_procs_write_finish(struct task_struct *task)
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
+		if (bypass_mask & (1 << ssid))
+			seq_putc(seq, '#');
 		seq_printf(seq, "%s", ss->name);
 		printed = true;
 	} while_each_subsys_mask();
@@ -2619,7 +2622,7 @@ static int cgroup_controllers_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgroup_control(cgrp));
+	cgroup_print_ss_mask(seq, cgroup_control(cgrp), cgrp->bypass_ss_mask);
 	return 0;
 }
 
@@ -2628,7 +2631,7 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgrp->subtree_control);
+	cgroup_print_ss_mask(seq, cgrp->subtree_control, 0);
 	return 0;
 }
 
@@ -2741,6 +2744,7 @@ static void cgroup_save_control(struct cgroup *cgrp)
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		dsct->old_subtree_control = dsct->subtree_control;
 		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
+		dsct->old_bypass_ss_mask = dsct->bypass_ss_mask;
 	}
 }
 
@@ -2758,10 +2762,11 @@ static void cgroup_propagate_control(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
-		dsct->subtree_control &= cgroup_control(dsct);
+		dsct->subtree_control &= cgroup_control(dsct)|
+					 dsct->bypass_ss_mask;
 		dsct->subtree_ss_mask =
 			cgroup_calc_subtree_ss_mask(dsct->subtree_control,
-						    cgroup_ss_mask(dsct));
+				cgroup_ss_mask(dsct)|dsct->bypass_ss_mask);
 	}
 }
 
@@ -2780,6 +2785,7 @@ static void cgroup_restore_control(struct cgroup *cgrp)
 	cgroup_for_each_live_descendant_post(dsct, d_css, cgrp) {
 		dsct->subtree_control = dsct->old_subtree_control;
 		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
+		dsct->bypass_ss_mask = dsct->old_bypass_ss_mask;
 	}
 }
 
@@ -2821,7 +2827,8 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 
 			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
 
-			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)))
+			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)) ||
+			    (dsct->bypass_ss_mask & (1 << ss->id)))
 				continue;
 
 			if (!css) {
@@ -2871,7 +2878,8 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 				continue;
 
 			if (css->parent &&
-			    !(cgroup_ss_mask(dsct) & (1 << ss->id))) {
+			    (!(cgroup_ss_mask(dsct) & (1 << ss->id)) ||
+			    (dsct->bypass_ss_mask & (1 << ss->id)))) {
 				kill_css(css);
 			} else if (!css_visible(css)) {
 				css_clear_dir(css);
@@ -2944,6 +2952,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    loff_t off)
 {
 	u16 enable = 0, disable = 0;
+	u16 child_enable = 0, child_bypass = 0;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -2981,31 +2990,31 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	if (!cgrp)
 		return -ENODEV;
 
-	for_each_subsys(ss, ssid) {
-		if (enable & (1 << ssid)) {
-			if (cgrp->subtree_control & (1 << ssid)) {
-				enable &= ~(1 << ssid);
-				continue;
-			}
+	/*
+	 * We cannot use controllers that are not enabled.
+	 */
+	if (~cgroup_control(cgrp) & (enable|disable)) {
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
+	cgroup_for_each_live_child(child, cgrp) {
+		child_enable |= child->subtree_control;
+		child_bypass |= child->bypass_ss_mask;
+	}
 
-			/* a child has it enabled? */
-			cgroup_for_each_live_child(child, cgrp) {
-				if (child->subtree_control & (1 << ssid)) {
-					ret = -EBUSY;
-					goto out_unlock;
-				}
-			}
-		}
+	/*
+	 * Strip out redundant bits.
+	 */
+	enable  &= ~cgrp->subtree_control;
+	disable &=  cgrp->subtree_control;
+
+	/*
+	 * We cannot disable controllers that are enabled in a child cgroup.
+	 */
+	if (disable & child_enable) {
+		ret = -EBUSY;
+		goto out_unlock;
 	}
 
 	if (!enable && !disable) {
@@ -3037,6 +3046,15 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgrp->subtree_control |= enable;
 	cgrp->subtree_control &= ~disable;
 
+	/*
+	 * Clear the child's bypass_ss_mask for those bits that are disabled
+	 * in subtree_control.
+	 */
+	if (child_bypass & disable) {
+		cgroup_for_each_live_child(child, cgrp)
+			child->bypass_ss_mask &= ~disable;
+	}
+
 	ret = cgroup_apply_control(cgrp);
 
 	cgroup_finalize_control(cgrp, ret);
@@ -3054,6 +3072,104 @@ enum thread_mode_op {
 	THREAD_MODE_DISABLE,
 };
 
+/*
+ * Change the bypass controllers for a cgroup in the default hierarchy.
+ */
+static ssize_t cgroup_controllers_write(struct kernfs_open_file *of,
+					char *buf, size_t nbytes,
+					loff_t off)
+{
+	u16 reenable = 0, bypass = 0;
+	struct cgroup *cgrp, *parent;
+	struct cgroup_subsys *ss;
+	char *tok;
+	int ssid, ret;
+
+	/*
+	 * Parse input - space separated list of subsystem names prefixed
+	 * with either + or #.
+	 */
+	buf = strstrip(buf);
+	while ((tok = strsep(&buf, " "))) {
+		if (tok[0] == '\0')
+			continue;
+		do_each_subsys_mask(ss, ssid, ~cgrp_dfl_inhibit_ss_mask) {
+			if (!cgroup_ssid_enabled(ssid) ||
+			    strcmp(tok + 1, ss->name))
+				continue;
+
+			if (*tok == '+') {
+				reenable |= 1 << ssid;
+				bypass &= ~(1 << ssid);
+			} else if (*tok == '#') {
+				bypass |= 1 << ssid;
+				reenable &= ~(1 << ssid);
+			} else {
+				return -EINVAL;
+			}
+			break;
+		} while_each_subsys_mask();
+		if (ssid == CGROUP_SUBSYS_COUNT)
+			return -EINVAL;
+	}
+
+	cgrp = cgroup_kn_lock_live(of->kn, true);
+	if (!cgrp)
+		return -ENODEV;
+
+	/*
+	 * Write to root cgroup's controllers file is not allowed.
+	 */
+	parent = cgroup_parent(cgrp);
+	if (!parent) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * Only controllers enabled by the parent can be specified here.
+	 */
+	if (~cgroup_control(cgrp) & (reenable|bypass)) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	/*
+	 * Mask off irrelevant bits.
+	 */
+	bypass   &= ~cgrp->bypass_ss_mask;
+	reenable &=  cgrp->bypass_ss_mask;
+
+	if (!bypass && !reenable) {
+		ret = 0;
+		goto out_unlock;
+	}
+
+	/*
+	 * We cannot change the bypass state of a controller that is enabled
+	 * in subtree_control.
+	 */
+	if (cgrp->subtree_control & (reenable|bypass)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	/* Save and update control masks and prepare csses */
+	cgroup_save_control(cgrp);
+
+	cgrp->bypass_ss_mask |= bypass;
+	cgrp->bypass_ss_mask &= ~reenable;
+
+	ret = cgroup_apply_control(cgrp);
+	cgroup_finalize_control(cgrp, ret);
+	kernfs_activate(cgrp->kn);
+	ret = 0;
+
+out_unlock:
+	cgroup_kn_unlock(of->kn);
+	return ret ?: nbytes;
+}
+
 static int cgroup_vet_thread_mode_op(struct cgroup *cgrp, enum thread_mode_op op)
 {
 	/* verify join conditions first and convert it to ENABLE */
@@ -3087,11 +3203,12 @@ static int cgroup_vet_thread_mode_op(struct cgroup *cgrp, enum thread_mode_op op
 
 	/*
 	 * @cgrp is starting or ending a normal threaded subtree.  Make
-	 * sure the subtree has no !threaded controller enabled and avoid
-	 * needing implicit domain controller migrations.
+	 * sure the subtree has no !threaded controller enabled or bypassed
+	 * and avoid needing implicit domain controller migrations.
 	 */
 	if (css_has_online_children(&cgrp->self) ||
-	   (cgrp->subtree_control & ~cgrp_dfl_threaded_ss_mask))
+	   ((cgrp->subtree_control|cgrp->bypass_ss_mask) &
+			~cgrp_dfl_threaded_ss_mask))
 		return -EBUSY;
 
 	/* no partial disable */
@@ -4250,6 +4367,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	{
 		.name = "cgroup.controllers",
 		.seq_show = cgroup_controllers_show,
+		.write = cgroup_controllers_write,
 	},
 	{
 		.name = "cgroup.subtree_control",
@@ -4396,7 +4514,8 @@ static void css_release(struct percpu_ref *ref)
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
-			      struct cgroup_subsys *ss, struct cgroup *cgrp)
+			      struct cgroup_subsys *ss, struct cgroup *cgrp,
+			      struct cgroup_subsys_state *parent_css)
 {
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -4412,7 +4531,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	atomic_set(&css->online_cnt, 0);
 
 	if (cgroup_parent(cgrp)) {
-		css->parent = cgroup_css(cgroup_parent(cgrp), ss);
+		css->parent = parent_css;
 		css_get(css->parent);
 	}
 
@@ -4475,19 +4594,33 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 					      struct cgroup_subsys *ss)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	struct cgroup_subsys_state *parent_css = cgroup_css(parent, ss);
+	struct cgroup_subsys_state *parent_css;
 	struct cgroup_subsys_state *css;
 	int err;
 
 	lockdep_assert_held(&cgroup_mutex);
 
+	/*
+	 * Need to skip over ancestor cgroups with NULL CSS.
+	 */
+	for (; parent; parent = cgroup_parent(parent)) {
+		parent_css = cgroup_css(parent, ss);
+		if (parent_css)
+			break;
+	}
+
+	if (!parent) {
+		WARN_ON_ONCE(1);
+		return ERR_PTR(-EINVAL);
+	}
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
@@ -4866,7 +4999,7 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	css = ss->css_alloc(cgroup_css(&cgrp_dfl_root.cgrp, ss));
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
-	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
+	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp, NULL);
 
 	/*
 	 * Root csses are never destroyed and we can't initialize
-- 
1.8.3.1

