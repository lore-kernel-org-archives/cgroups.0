From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] cgroup: implement cgroup_subsys->implicit_on_dfl
Date: Wed, 24 Feb 2016 17:12:54 -0500
Message-ID: <1456351975-1899-2-git-send-email-tj@kernel.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vZ/au4Bauw47h2CO3my5BaO0o/RTnYl9JvWcp3csqi8=;
        b=qHUD9XCFbc5i+iaGY+0G7A9m9ijhT0cTMyhiNfKviqE5a5cu0dnq3dYSIUS4QsKzDY
         yzObmj6FklyQbrjaSi7XrKLFtIWFE005qNCPtP/Tga47Jgt05dB2o2cuWOblQ3+IldWH
         fN9Y+EVFfOPkLfbZh8lWYcU4062A5fjku8o3udvRm1UlltMw9QWWdRV4iyJyzt6Mj4eo
         Sd8StFADM/PjcoqRyreGEI9fwbzj28Y3CVdo1yNTALD/CBwyMYvE3qo/plAfDSJ1S3AL
         Z3Pbyq7RR9ioSbGfjUzYFSEPQfOnrke9HdHQLh+fCTEB46cmZjzAxai+LE0dseWwGgcr
         8oOg==
In-Reply-To: <1456351975-1899-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

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

v2: Reimplemented on top of the recent updates to css handling and
    subsystem rebinding.  Rebinding implicit subsystems is now a
    simple matter of exempting it from the busy subsystem check.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup-defs.h | 13 +++++++++++++
 kernel/cgroup.c             | 38 +++++++++++++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index aae8c94..0af8dc4 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -450,6 +450,19 @@ struct cgroup_subsys {
 	bool early_init:1;
 
 	/*
+	 * If %true, the controller, on the default hierarchy, doesn't show
+	 * up in "cgroup.controllers" or "cgroup.subtree_control", is
+	 * implicitly enabled on all cgroups on the default hierarchy, and
+	 * bypasses the "no internal process" constraint.  This is for
+	 * utility type controllers which is transparent to userland.
+	 *
+	 * An implicit controller can be stolen from the default hierarchy
+	 * anytime and thus must be okay with offline csses from previous
+	 * hierarchies coexisting with csses for the current one.
+	 */
+	bool implicit_on_dfl:1;
+
+	/*
 	 * If %false, this subsystem is properly hierarchical -
 	 * configuration, resource accounting and restriction on a parent
 	 * cgroup cover those of its children.  If %true, hierarchy support
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a44c123..0f17c65 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -186,6 +186,9 @@ static u16 cgroup_no_v1_mask;
 /* some controllers are not supported in the default hierarchy */
 static u16 cgrp_dfl_inhibit_ss_mask;
 
+/* some controllers are implicitly enabled on the default hierarchy */
+static unsigned long cgrp_dfl_implicit_ss_mask;
+
 /* The list of hierarchy roots */
 
 static LIST_HEAD(cgroup_roots);
@@ -359,8 +362,8 @@ static u16 cgroup_control(struct cgroup *cgrp)
 		return parent->subtree_control;
 
 	if (cgroup_on_dfl(cgrp))
-		root_ss_mask &= ~cgrp_dfl_inhibit_ss_mask;
-
+		root_ss_mask &= ~(cgrp_dfl_inhibit_ss_mask |
+				  cgrp_dfl_implicit_ss_mask);
 	return root_ss_mask;
 }
 
@@ -1326,6 +1329,8 @@ static u16 cgroup_calc_subtree_ss_mask(u16 subtree_control, u16 this_ss_mask)
 
 	lockdep_assert_held(&cgroup_mutex);
 
+	cur_ss_mask |= cgrp_dfl_implicit_ss_mask;
+
 	while (true) {
 		u16 new_ss_mask = cur_ss_mask;
 
@@ -1511,8 +1516,13 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 	lockdep_assert_held(&cgroup_mutex);
 
 	do_each_subsys_mask(ss, ssid, ss_mask) {
-		/* if @ss has non-root csses attached to it, can't move */
-		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)))
+		/*
+		 * If @ss has non-root csses attached to it, can't move.
+		 * If @ss is an implicit controller, it is exempt from this
+		 * rule and can be stolen.
+		 */
+		if (css_next_child(NULL, cgroup_css(&ss->root->cgrp, ss)) &&
+		    !ss->implicit_on_dfl)
 			return -EBUSY;
 
 		/* can't move between two non-dummy roots either */
@@ -3032,6 +3042,18 @@ static void cgroup_restore_control(struct cgroup *cgrp)
 	}
 }
 
+static bool css_visible(struct cgroup_subsys_state *css)
+{
+	struct cgroup_subsys *ss = css->ss;
+	struct cgroup *cgrp = css->cgroup;
+
+	if (cgroup_control(cgrp) & (1 << ss->id))
+		return true;
+	if (!(cgroup_ss_mask(cgrp) & (1 << ss->id)))
+		return false;
+	return cgroup_on_dfl(cgrp) && ss->implicit_on_dfl;
+}
+
 /**
  * cgroup_apply_control_enable - enable or show csses according to control
  * @cgrp: root of the target subtree
@@ -3067,7 +3089,7 @@ static int cgroup_apply_control_enable(struct cgroup *cgrp)
 					return PTR_ERR(css);
 			}
 
-			if (cgroup_control(dsct) & (1 << ss->id)) {
+			if (css_visible(css)) {
 				ret = css_populate_dir(css);
 				if (ret)
 					return ret;
@@ -3110,7 +3132,7 @@ static void cgroup_apply_control_disable(struct cgroup *cgrp)
 			if (css->parent &&
 			    !(cgroup_ss_mask(dsct) & (1 << ss->id))) {
 				kill_css(css);
-			} else if (!(cgroup_control(dsct) & (1 << ss->id))) {
+			} else if (!css_visible(css)) {
 				css_clear_dir(css);
 				if (ss->css_reset)
 					ss->css_reset(css);
@@ -5440,7 +5462,9 @@ int __init cgroup_init(void)
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
-		if (!ss->dfl_cftypes)
+		if (ss->implicit_on_dfl)
+			cgrp_dfl_implicit_ss_mask |= 1 << ss->id;
+		else if (!ss->dfl_cftypes)
 			cgrp_dfl_inhibit_ss_mask |= 1 << ss->id;
 
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
-- 
2.5.0
