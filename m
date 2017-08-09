From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3 2/3] cgroup: Allow reenabling of controller in bypass mode
Date: Wed,  9 Aug 2017 13:55:49 -0400
Message-ID: <1502301350-19757-3-git-send-email-longman@redhat.com>
References: <1502301350-19757-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502301350-19757-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>

Non-domain controllers set to bypass mode in the parent's
"cgroup.subtree_control" can now be optionally enabled by writing the
controller name with the '+' prefix to "cgroup.controllers". Using the
'#' prefix will reset it back to the bypass state.

This capability allows a cgroup parent to individually enable
non-domain controllers in a subset of its children instead of either
all or none of them. This increases the flexibility each controller
has in shaping the effective cgroup hierarchy to best suit its need.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt |  58 +++++++++++++++++------
 include/linux/cgroup-defs.h |   7 +++
 kernel/cgroup/cgroup.c      | 109 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 156 insertions(+), 18 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index dc44785..e76dc4cf 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -363,10 +363,16 @@ disabled by writing to the "cgroup.subtree_control" file::
 
   # echo "+cpu +memory -io" > cgroup.subtree_control
 
+The prefixes '+', '-' and '#' are used to enable, disable or put
+a controller in the bypass mode respectively.  In the bypass mode,
+a controller is disabled in a cgroup, but it can be enabled again in
+its child cgroups as it will still be listed in "cgroup.controllers".
+Bypass mode can only be used on non-domain controllers.
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
@@ -390,6 +396,20 @@ prefixed controller interface files from C and D.  This means that the
 controller interface files - anything which doesn't start with
 "cgroup." are owned by the parent rather than the cgroup itself.
 
+Once a non-domain controller is put into bypass mode in
+"cgroup.subtree_control", that controller can optionally be enabled
+again in child cgroups by writing the controller name with the '+
+prefix into "cgroup.controllers".  Writing the controller name with
+the '#' prefix into "cgroup.controllers" resets the state back to
+bypass mode.  The state of a non-domain controller cannot be changed
+anymore if it is enabled or bypassed in its "cgroup.subtree_control".
+
+The use of bypass mode thus allows a cgroup parent to have the ability
+to selectively enable a non-domain controller in a subset of its
+child cgroups instead of in either all or none of them. In other words,
+a non-domain controller can be enabled only on the cgroup that actually
+needs it, if desired.
+
 
 Top-down Constraint
 ~~~~~~~~~~~~~~~~~~~
@@ -397,10 +417,11 @@ Top-down Constraint
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
@@ -823,11 +844,18 @@ All cgroup core files are prefixed with "cgroup."
 	should be granted along with the containing directory.
 
   cgroup.controllers
-	A read-only space separated values file which exists on all
+	A read-write space separated values file which exists on all
 	cgroups.
 
 	It shows space separated list of all controllers available to
-	the cgroup.  The controllers are not ordered.
+	the cgroup.  Controller names with '#' prefix are in bypass
+	mode.  The controllers are not ordered.
+
+	When a controller is set into bypass mode in its parent's
+	"cgroup.subtree_control", its name prefixed with '+' or '#'
+	can be written to enable it or reset it back to bypass mode
+	respectively.  Controllers not in bypass mode are not allowed
+	to be written.
 
   cgroup.subtree_control
 	A read-write space separated values file which exists on all
@@ -837,12 +865,12 @@ All cgroup core files are prefixed with "cgroup."
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
index 15655e5..9f03254 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -321,6 +321,13 @@ struct cgroup {
 	u16 old_subtree_ss_mask;
 	u16 old_subtree_bypass;
 
+	/*
+	 * The bitmask of subsystems that are set in its parent's
+	 * ->subtree_bypass and explicitly enabled in this cgroup.
+	 */
+	u16 enable_ss_mask;
+	u16 old_enable_ss_mask;
+
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state __rcu *subsys[CGROUP_SUBSYS_COUNT];
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9e69f7f..17591fb 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -420,7 +420,7 @@ static u16 cgroup_control(struct cgroup *cgrp, bool show_bypass)
 	u16 root_ss_mask = cgrp->root->subsys_mask;
 
 	if (parent) {
-		u16 ss_mask = parent->subtree_control;
+		u16 ss_mask = parent->subtree_control|cgrp->enable_ss_mask;
 
 		if (show_bypass)
 			ss_mask |= parent->subtree_bypass;
@@ -443,7 +443,7 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp, bool show_bypass)
 	struct cgroup *parent = cgroup_parent(cgrp);
 
 	if (parent) {
-		u16 ss_mask = parent->subtree_ss_mask;
+		u16 ss_mask = parent->subtree_ss_mask|cgrp->enable_ss_mask;
 
 
 		if (show_bypass)
@@ -2815,6 +2815,7 @@ static void cgroup_save_control(struct cgroup *cgrp)
 		dsct->old_subtree_control = dsct->subtree_control;
 		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
 		dsct->old_subtree_bypass  = dsct->subtree_bypass;
+		dsct->old_enable_ss_mask  = dsct->enable_ss_mask;
 	}
 }
 
@@ -2858,6 +2859,7 @@ static void cgroup_restore_control(struct cgroup *cgrp)
 		dsct->subtree_control = dsct->old_subtree_control;
 		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
 		dsct->subtree_bypass  = dsct->old_subtree_bypass;
+		dsct->enable_ss_mask  = dsct->old_enable_ss_mask;
 	}
 }
 
@@ -3135,7 +3137,8 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	}
 
 	cgroup_for_each_live_child(child, cgrp)
-		child_enable |= child->subtree_control|child->subtree_bypass;
+		child_enable |= child->subtree_control|child->subtree_bypass|
+				child->enable_ss_mask;
 
 	/*
 	 * Cannot change the state of a controller if enabled in children.
@@ -3168,6 +3171,105 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+/*
+ * Change bypass status of controllers for a cgroup in the default hierarchy.
+ */
+static ssize_t cgroup_controllers_write(struct kernfs_open_file *of,
+					char *buf, size_t nbytes,
+					loff_t off)
+{
+	u16 enable = 0, bypass = 0;
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
+				enable |= 1 << ssid;
+				bypass &= ~(1 << ssid);
+			} else if (*tok == '#') {
+				bypass |= 1 << ssid;
+				enable &= ~(1 << ssid);
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
+	 * Only controllers set into bypass mode in the parent cgroup
+	 * can be specified here.
+	 */
+	if (~parent->subtree_bypass & (enable|bypass)) {
+		ret = -ENOENT;
+		goto out_unlock;
+	}
+
+	/*
+	 * Mask off irrelevant bits.
+	 */
+	enable &= ~cgrp->enable_ss_mask;
+	bypass &=  cgrp->enable_ss_mask;
+
+	if (!(enable|bypass)) {
+		ret = 0;
+		goto out_unlock;
+	}
+
+	/*
+	 * We cannot change the bypass state of a controller that is enabled
+	 * in subtree_control.
+	 */
+	if ((cgrp->subtree_control|cgrp->subtree_bypass) & (enable|bypass)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	/* Save and update control masks and prepare csses */
+	cgroup_save_control(cgrp);
+
+	cgrp->enable_ss_mask |= enable;
+	cgrp->enable_ss_mask &= ~bypass;
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
 /**
  * cgroup_enable_threaded - make @cgrp threaded
  * @cgrp: the target cgroup
@@ -4433,6 +4535,7 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	{
 		.name = "cgroup.controllers",
 		.seq_show = cgroup_controllers_show,
+		.write = cgroup_controllers_write,
 	},
 	{
 		.name = "cgroup.subtree_control",
-- 
1.8.3.1

