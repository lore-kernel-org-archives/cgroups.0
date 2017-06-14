From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 4/6] cgroup: Introduce subtree root mode
Date: Wed, 14 Jun 2017 11:05:35 -0400
Message-ID: <1497452737-11125-5-git-send-email-longman@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com EBD365F7B6
In-Reply-To: <1497452737-11125-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

Subtree root mode is a new cgroup mode which applies the following
restrictions when turned on:

 1) Controllers are only allowed to be passed to the children in
    bypass mode except those with the "enable_on_root" flag on.
 2) Only 1 child cgroup is allowed.

That lone child can be used as the pseudo root of a container cgroup
hierarchy.  All the resources, if controlled, are in the parent
cgroup. There will be no control knobs in the child. That makes it
look and feel like a root.

That pseudo root is also considered to be mixable and so can become
root of a mixed threaded subtree. The no internal process constraint
also does not apply.

The subtree root mode and thread mode are mutually exclusive.

The subtree root mode is enabled by doing:

  # echo root > cgroup.subtree_control

It is disabled by:

  # echo nonroot > cgroup.subtree_control

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 43 +++++++++++++++++++----
 include/linux/cgroup-defs.h | 12 +++++++
 kernel/cgroup/cgroup.c      | 86 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 129 insertions(+), 12 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 55bee8a..bc2913c 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -23,7 +23,8 @@ CONTENTS
   2-4. Controlling Controllers
     2-4-1. Enabling and Disabling
     2-4-2. Top-down Constraint
-    2-4-3. No Internal Process Constraint
+    2-4-3. Subtree root mode
+    2-4-4. No Internal Process Constraint
   2-5. Delegation
     2-5-1. Model of Delegation
     2-5-2. Delegation Containment
@@ -439,7 +440,33 @@ the parent has the controller enabled ('+' or '#') and a controller
 can't be disabled if one or more children have it enabled.
 
 
-2-4-3. No Internal Process Constraint
+2-4-3. Subtree root mode
+
+Subtree root mode is a special cgroup mode that restricts the passing
+of most controllers in bypass mode only.  Only controllers that
+have the special "enabled_on_root" flag on can be directly enabled.
+It also allows only one child cgroup to be created.  That child cgroup
+can be used as the pseudo root of a container cgroup hierarchy.
+
+This pseudo root will look and feel like a root cgroup as resources
+that are not controllable in a real root will not be controllable in
+the pseudo root.  Instead, those resources can be controlled in the
+parent of the pseudo root.
+
+The pseudo root can be the root of a mixed threaded subtree, and the
+no internal process contraint does not apply.  Subtree root mode and
+thread mode are mutually exclusive.
+
+Subtree root is enabled by writing "root" to "cgroup.subtree_control".
+
+  # echo root > cgroup.subtree_control
+
+It is disabled by writing "nonroot" to "cgroup.subtree_control".
+
+  # echo nonroot > cgroup.subtree_control
+
+
+2-4-4. No Internal Process Constraint
 
 When a non-root cgroup distributes resources to their children while
 having processes of its own, its internal processes will then compete
@@ -817,10 +844,14 @@ All cgroup core files are prefixed with "cgroup."
 	or '#' can be written to enable or disable controllers as
 	well as setting them into bypass mode.	A controller name
 	prefixed with '+' enables the controller and '-' disables.
-	The '#' prefix sets the controller into bypass mode.  If a
-	controller appears more than once on the list, the last
-	one is effective.  When multiple operations are specified,
-	either all succeed or all fail.
+	The '#' prefix sets the controller into bypass mode.
+
+	The special keywords "root" and "nonroot" can be written to
+	enable and disable the subtree root mode respectively.
+
+	If a controller or a keyword appears more than once on the
+	list, the last one is effective.  When multiple operations
+	are specified, either all succeed or all fail.
 
   cgroup.events
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 14fdddb..72d51ec 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -61,6 +61,12 @@ enum {
 	 * specified at mount time and thus is implemented here.
 	 */
 	CGRP_CPUSET_CLONE_CHILDREN,
+	/*
+	 * Enforce passing controllers in bypass mode and one child only.
+	 * This child becomes a pseudo root that can serve as the root of
+	 * a container.
+	 */
+	CGRP_SUBTREE_ROOT_MODE,
 };
 
 /* cgroup_root->flags */
@@ -529,6 +535,12 @@ struct cgroup_subsys {
 	bool threaded:1;
 
 	/*
+	 * If %true, the subsystem can be enabled on root or pseudo root on
+	 * the default heirarchy.
+	 */
+	bool enabled_on_root:1;
+
+	/*
 	 * If %false, this subsystem is properly hierarchical -
 	 * configuration, resource accounting and restriction on a parent
 	 * cgroup cover those of its children.  If %true, hierarchy support
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 901314b..f0bea32 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -165,6 +165,9 @@ struct cgroup_subsys *cgroup_subsys[] = {
 /* some controllers can be threaded on the default hierarchy */
 static u16 cgrp_dfl_threaded_ss_mask;
 
+/* some controllers can be enabled on pseudo root */
+static u16 cgrp_dfl_enabled_on_root;
+
 /* The list of hierarchy roots */
 LIST_HEAD(cgroup_roots);
 static int cgroup_root_count;
@@ -340,6 +343,14 @@ static bool cgroup_is_thread_root(struct cgroup *cgrp)
 	return cgrp->proc_cgrp == cgrp;
 }
 
+/* is @cgrp a pseudo root (i.e. parent in subtree root mode)? */
+static bool cgroup_is_pseudo_root(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+
+	return parent && test_bit(CGRP_SUBTREE_ROOT_MODE, &parent->flags);
+}
+
 /* if threaded, would @cgrp become root of a mixed threaded subtree? */
 static bool cgroup_is_mixable(struct cgroup *cgrp)
 {
@@ -347,8 +358,10 @@ static bool cgroup_is_mixable(struct cgroup *cgrp)
 	 * Root isn't under domain level resource control exempting it from
 	 * the no-internal-process constraint, so it can serve as a thread
 	 * root and a parent of resource domains at the same time.
+	 *
+	 * A pseudo root is also considered to be mixable.
 	 */
-	return !cgroup_parent(cgrp);
+	return !cgroup_parent(cgrp) || cgroup_is_pseudo_root(cgrp);
 }
 
 /* is @cgrp root of a mixed threaded subtree */
@@ -2964,6 +2977,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
+	int subtree_root_mode = 0;
+	int nr_children = 0;
 	int ssid, ret;
 
 	/*
@@ -2974,6 +2989,14 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	while ((tok = strsep(&buf, " "))) {
 		if (tok[0] == '\0')
 			continue;
+
+		if (!strcmp(tok, "root")) {
+			subtree_root_mode = 1;
+			continue;
+		} else if (!strcmp(tok, "nonroot")) {
+			subtree_root_mode = -1;
+			continue;
+		}
 		do_each_subsys_mask(ss, ssid, ~cgrp_dfl_inhibit_ss_mask) {
 			if (!cgroup_ssid_enabled(ssid) ||
 			    strcmp(tok + 1, ss->name))
@@ -3015,6 +3038,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgroup_for_each_live_child(child, cgrp) {
 		child_enable |= child->subtree_control|child->subtree_bypass;
 		child_bypass |= child->bypass_ss_mask;
+		nr_children++;
 	}
 
 	/*
@@ -3025,16 +3049,33 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	disable &= (cgrp->subtree_control|cgrp->subtree_bypass);
 
 	/*
-	 * We cannot disable controllers or change the bypass state of
-	 * controllers that are enabled in a child cgroup.
+	 * We cannot enable or disable subtree root mode if it is root,
+	 * there is any child cgroups or when thread mode is on.
 	 */
-	if ((enable|bypass|disable) & child_enable) {
+	if (subtree_root_mode &&
+	   (!cgroup_parent(cgrp) || nr_children || cgroup_is_threaded(cgrp))) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 
-	if (!(enable|bypass|disable)) {
-		ret = 0;
+	/*
+	 * We can't have any controllers enabled directly when in subtree
+	 * root mode except those with the enabled_on_root flag on.
+	 */
+	if ((test_bit(CGRP_SUBTREE_ROOT_MODE, &cgrp->flags) ||
+	    (subtree_root_mode > 0)) &&
+	   ((enable|cgrp->subtree_control) & ~cgrp_dfl_enabled_on_root
+					   & ~disable)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/*
+	 * We cannot disable controllers or change the bypass state of
+	 * controllers that are enabled in a child cgroup.
+	 */
+	if ((enable|bypass|disable) & child_enable) {
+		ret = -EBUSY;
 		goto out_unlock;
 	}
 
@@ -3056,6 +3097,13 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
+	if (!(enable|bypass|disable)) {
+		ret = 0;
+		if (subtree_root_mode)
+			goto set_root_mode;
+		goto out_unlock;
+	}
+
 	/* save and update control masks and prepare csses */
 	cgroup_save_control(cgrp);
 
@@ -3077,6 +3125,14 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 	cgroup_finalize_control(cgrp, ret);
 
+	if (!ret && subtree_root_mode) {
+set_root_mode:
+		if (subtree_root_mode > 0)
+			set_bit(CGRP_SUBTREE_ROOT_MODE, &cgrp->flags);
+		else
+			clear_bit(CGRP_SUBTREE_ROOT_MODE, &cgrp->flags);
+	}
+
 	kernfs_activate(cgrp->kn);
 	ret = 0;
 out_unlock:
@@ -3190,6 +3246,12 @@ static ssize_t cgroup_controllers_write(struct kernfs_open_file *of,
 
 static int cgroup_vet_thread_mode_op(struct cgroup *cgrp, enum thread_mode_op op)
 {
+	/*
+	 * Thread mode and subtree root mode are mutually exclusive.
+	 */
+	if (test_bit(CGRP_SUBTREE_ROOT_MODE, &cgrp->flags))
+		return -EINVAL;
+
 	/* verify join conditions first and convert it to ENABLE */
 	if (op == THREAD_MODE_JOIN) {
 		/* can't join if it isn't there */
@@ -4773,6 +4835,15 @@ int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode)
 	if (!parent)
 		return -ENODEV;
 
+	/*
+	 * A cgroup in subtree root mode cannot have more than one child.
+	 */
+	if (test_bit(CGRP_SUBTREE_ROOT_MODE, &parent->flags) &&
+	   !list_empty(&parent->self.children)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
 	cgrp = cgroup_create(parent);
 	if (IS_ERR(cgrp)) {
 		ret = PTR_ERR(cgrp);
@@ -5173,6 +5244,9 @@ int __init cgroup_init(void)
 		if (ss->threaded)
 			cgrp_dfl_threaded_ss_mask |= 1 << ss->id;
 
+		if (ss->enabled_on_root)
+			cgrp_dfl_enabled_on_root |= 1 << ss->id;
+
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
 		} else {
-- 
1.8.3.1

