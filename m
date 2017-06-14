From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 3/6] cgroup: Allow bypss mode in subtree_control
Date: Wed, 14 Jun 2017 11:05:34 -0400
Message-ID: <1497452737-11125-4-git-send-email-longman@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 8D8D44E339
In-Reply-To: <1497452737-11125-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

The special prefix '#' attached to a controller name can now be
written into the cgroup.subtree_control file to set that controller
in bypass mode in all the child cgroups. The controller will show
up in the children's cgroup.controllers file, but the corresponding
control knobs will be absent. The child cgroups cannot change the
controller states by writing to their cgroup.controllers file at all.

That can be useful for setting up a container where the container
root has a parent which enables controllers in bypass mode only. The
container root will then behave similar to a real root where controller
names show up in cgroup.controllers but the resource control files
are absent. If that parent has only one child which is a container
root, enabling those controllers in that parent will allow container
specific resources to be controlled there without being noticed by
the container itself.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 19 ++++++++----
 include/linux/cgroup-defs.h |  4 +++
 kernel/cgroup/cgroup.c      | 70 ++++++++++++++++++++++++++++-----------------
 3 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 0df06ba..55bee8a 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -335,6 +335,11 @@ and a '-' prefix disables it.
 
   # echo "+cpu +memory -io" > cgroup.subtree_control
 
+The special prefix '#' is used to enable bypass mode for that
+particular controller on the child cgroups. In the bypass mode, a
+controller is disabled in a cgroup, but it can be enabled again in
+its child cgroups.
+
 Only controllers which are listed in "cgroup.controllers" can
 be enabled in the "cgroup.subtree_control" file.  When multiple
 operations are specified as above, either they all succeed or fail.
@@ -808,12 +813,14 @@ All cgroup core files are prefixed with "cgroup."
 	which are enabled to control resource distribution from the
 	cgroup to its children.
 
-	Space separated list of controllers prefixed with '+' or '-'
-	can be written to enable or disable controllers.  A controller
-	name prefixed with '+' enables the controller and '-'
-	disables.  If a controller appears more than once on the list,
-	the last one is effective.  When multiple enable and disable
-	operations are specified, either all succeed or all fail.
+	Space separated list of controllers prefixed with '+', '-'
+	or '#' can be written to enable or disable controllers as
+	well as setting them into bypass mode.	A controller name
+	prefixed with '+' enables the controller and '-' disables.
+	The '#' prefix sets the controller into bypass mode.  If a
+	controller appears more than once on the list, the last
+	one is effective.  When multiple operations are specified,
+	either all succeed or all fail.
 
   cgroup.events
 
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f5c1e36..14fdddb 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -283,10 +283,14 @@ struct cgroup {
 	 * "cgroup.subtree_control" while ->child_ss_mask is the effective
 	 * one which may have more subsystems enabled.  Controller knobs
 	 * are made available iff it's enabled in ->subtree_control.
+	 * ->subtree_bypass marks those controllers that are set into
+	 * the bypass mode in the child cgroups.
 	 */
 	u16 subtree_control;
+	u16 subtree_bypass;
 	u16 subtree_ss_mask;
 	u16 old_subtree_control;
+	u16 old_subtree_bypass;
 	u16 old_subtree_ss_mask;
 
 	/*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 7d1326e..901314b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -375,7 +375,7 @@ static bool cgroup_is_mixed_child(struct cgroup *cgrp)
 }
 
 /* subsystems visibly enabled on a cgroup */
-static u16 cgroup_control(struct cgroup *cgrp)
+static u16 cgroup_control(struct cgroup *cgrp, bool show_bypass)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 root_ss_mask = cgrp->root->subsys_mask;
@@ -383,6 +383,9 @@ static u16 cgroup_control(struct cgroup *cgrp)
 	if (parent) {
 		u16 ss_mask = parent->subtree_control;
 
+		if (show_bypass)
+			ss_mask |= parent->subtree_bypass;
+
 		/* mixed child can only have threaded subset of controllers */
 		if (cgroup_is_mixed_child(cgrp))
 			ss_mask &= cgrp_dfl_threaded_ss_mask;
@@ -396,13 +399,16 @@ static u16 cgroup_control(struct cgroup *cgrp)
 }
 
 /* subsystems enabled on a cgroup */
-static u16 cgroup_ss_mask(struct cgroup *cgrp)
+static u16 cgroup_ss_mask(struct cgroup *cgrp, bool show_bypass)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 
 	if (parent) {
 		u16 ss_mask = parent->subtree_ss_mask;
 
+		if (show_bypass)
+			ss_mask |= parent->subtree_bypass;
+
 		/* mixed child can only have threaded subset of controllers */
 		if (cgroup_is_mixed_child(cgrp))
 			ss_mask &= cgrp_dfl_threaded_ss_mask;
@@ -455,7 +461,7 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 	 * This function is used while updating css associations and thus
 	 * can't test the csses directly.  Test ss_mask.
 	 */
-	while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
+	while (!(cgroup_ss_mask(cgrp, false) & (1 << ss->id))) {
 		cgrp = cgroup_parent(cgrp);
 		if (!cgrp)
 			return NULL;
@@ -2622,7 +2628,8 @@ static int cgroup_controllers_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgroup_control(cgrp), cgrp->bypass_ss_mask);
+	cgroup_print_ss_mask(seq, cgroup_control(cgrp, true),
+			     cgrp->bypass_ss_mask);
 	return 0;
 }
 
@@ -2631,7 +2638,7 @@ static int cgroup_subtree_control_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgrp->subtree_control, 0);
+	cgroup_print_ss_mask(seq, cgrp->subtree_control, cgrp->subtree_bypass);
 	return 0;
 }
 
@@ -2744,6 +2751,7 @@ static void cgroup_save_control(struct cgroup *cgrp)
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		dsct->old_subtree_control = dsct->subtree_control;
 		dsct->old_subtree_ss_mask = dsct->subtree_ss_mask;
+		dsct->old_subtree_bypass = dsct->subtree_bypass;
 		dsct->old_bypass_ss_mask = dsct->bypass_ss_mask;
 	}
 }
@@ -2762,11 +2770,10 @@ static void cgroup_propagate_control(struct cgroup *cgrp)
 	struct cgroup_subsys_state *d_css;
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
-		dsct->subtree_control &= cgroup_control(dsct)|
-					 dsct->bypass_ss_mask;
+		dsct->subtree_control &= cgroup_control(dsct, true);
 		dsct->subtree_ss_mask =
 			cgroup_calc_subtree_ss_mask(dsct->subtree_control,
-				cgroup_ss_mask(dsct)|dsct->bypass_ss_mask);
+						    cgroup_ss_mask(dsct, true));
 	}
 }
 
@@ -2786,6 +2793,7 @@ static void cgroup_restore_control(struct cgroup *cgrp)
 		dsct->subtree_control = dsct->old_subtree_control;
 		dsct->subtree_ss_mask = dsct->old_subtree_ss_mask;
 		dsct->bypass_ss_mask = dsct->old_bypass_ss_mask;
+		dsct->subtree_bypass = dsct->old_subtree_bypass;
 	}
 }
 
@@ -2794,9 +2802,9 @@ static bool css_visible(struct cgroup_subsys_state *css)
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
@@ -2827,7 +2835,7 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 
 			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
 
-			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)) ||
+			if (!(cgroup_ss_mask(dsct, false) & (1 << ss->id)) ||
 			    (dsct->bypass_ss_mask & (1 << ss->id)))
 				continue;
 
@@ -2878,7 +2886,7 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 				continue;
 
 			if (css->parent &&
-			    (!(cgroup_ss_mask(dsct) & (1 << ss->id)) ||
+			    (!(cgroup_ss_mask(dsct, false) & (1 << ss->id)) ||
 			    (dsct->bypass_ss_mask & (1 << ss->id)))) {
 				kill_css(css);
 			} else if (!css_visible(css)) {
@@ -2951,7 +2959,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
 					    loff_t off)
 {
-	u16 enable = 0, disable = 0;
+	u16 enable = 0, disable = 0, bypass = 0;
 	u16 child_enable = 0, child_bypass = 0;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
@@ -2973,10 +2981,16 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
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
@@ -2993,13 +3007,13 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	/*
 	 * We cannot use controllers that are not enabled.
 	 */
-	if (~cgroup_control(cgrp) & (enable|disable)) {
+	if (~cgroup_control(cgrp, true) & (enable|bypass|disable)) {
 		ret = -ENOENT;
 		goto out_unlock;
 	}
 
 	cgroup_for_each_live_child(child, cgrp) {
-		child_enable |= child->subtree_control;
+		child_enable |= child->subtree_control|child->subtree_bypass;
 		child_bypass |= child->bypass_ss_mask;
 	}
 
@@ -3007,24 +3021,26 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * Strip out redundant bits.
 	 */
 	enable  &= ~cgrp->subtree_control;
-	disable &=  cgrp->subtree_control;
+	bypass  &= ~cgrp->subtree_bypass;
+	disable &= (cgrp->subtree_control|cgrp->subtree_bypass);
 
 	/*
-	 * We cannot disable controllers that are enabled in a child cgroup.
+	 * We cannot disable controllers or change the bypass state of
+	 * controllers that are enabled in a child cgroup.
 	 */
-	if (disable & child_enable) {
+	if ((enable|bypass|disable) & child_enable) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
 
-	if (!enable && !disable) {
+	if (!(enable|bypass|disable)) {
 		ret = 0;
 		goto out_unlock;
 	}
 
 	/* can't enable !threaded controllers on a threaded cgroup */
 	if (cgroup_is_threaded(cgrp) && !cgroup_is_mixed_root(cgrp) &&
-	    (enable & ~cgrp_dfl_threaded_ss_mask)) {
+	    ((enable|bypass) & ~cgrp_dfl_threaded_ss_mask)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -3044,15 +3060,17 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	cgroup_save_control(cgrp);
 
 	cgrp->subtree_control |= enable;
-	cgrp->subtree_control &= ~disable;
+	cgrp->subtree_control &= ~(bypass|disable);
+	cgrp->subtree_bypass  |= bypass;
+	cgrp->subtree_bypass  &= ~(enable|disable);
 
 	/*
 	 * Clear the child's bypass_ss_mask for those bits that are disabled
-	 * in subtree_control.
+	 * are bypassed in subtree_control.
 	 */
-	if (child_bypass & disable) {
+	if (child_bypass & (disable|bypass)) {
 		cgroup_for_each_live_child(child, cgrp)
-			child->bypass_ss_mask &= ~disable;
+			child->bypass_ss_mask &= ~(disable|bypass);
 	}
 
 	ret = cgroup_apply_control(cgrp);
@@ -3129,7 +3147,7 @@ static ssize_t cgroup_controllers_write(struct kernfs_open_file *of,
 	/*
 	 * Only controllers enabled by the parent can be specified here.
 	 */
-	if (~cgroup_control(cgrp) & (reenable|bypass)) {
+	if (~cgroup_control(cgrp, true) & (reenable|bypass)) {
 		ret = -ENOENT;
 		goto out_unlock;
 	}
@@ -4725,7 +4743,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 * subtree_control from the parent.  Each is configured manually.
 	 */
 	if (!cgroup_on_dfl(cgrp))
-		cgrp->subtree_control = cgroup_control(cgrp);
+		cgrp->subtree_control = cgroup_control(cgrp, false);
 
 	if (parent)
 		cgroup_bpf_inherit(cgrp, parent);
-- 
1.8.3.1

