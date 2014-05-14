From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.16] cgroup: disallow debug controller on the
 default hierarchy
Date: Wed, 14 May 2014 19:33:07 -0400
Message-ID: <20140514233307.GI15690@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=0NCAIVltDNFMfsQPy0UvrfQZHtFDrNaSkb+5Q3Zp9Qk=;
        b=bYGwPAkucwoUm5kTWS5DmhYdJ+WWEur2pkk+v86F/lG1mJ2gRo9illLGlKgEkeN0k1
         8KQScLn4rcWZ0m+SdxAdyqWM9nJrx/qlvlOq3dUuMj4p45yWp6TQzfyXVFBWuPiO9jFz
         3D32cTsjK/6OP8Tq+itLR8RNRZUYX0tZHi91hCL8ph9qO1tPxJAwIX/iulbHZquwrsne
         ruYrWle0ytxkjkmklLBuaiZszSqRBFM+EulQLxde/tYxDckMWmBzTv5bPwNNWl0j25gt
         n3yieGurDOtJqMuj4YT044V29BuwD3tBP6oOrR6iMGDAPcLPPAakyEf/F59sS3D5M4R8
         agnQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The debug controller, as its name suggests, exposes cgroup core
internals to userland to aid debugging.  Unfortunately, except for the
name, there's no provision to prevent its usage in production
configurations and the controller is widely enabled and mounted
leaking internal details to userland.  Like most other debug
information, the information exposed by debug isn't interesting even
for debugging itself once the related parts are working reliably.

This controller has no reason for existing.  This patch implements
cgrp_dfl_root_inhibit_ss_mask which can suppress specific subsystems
on the default hierarchy and adds the debug subsystem to it so that it
can be gradually deprecated as usages move towards the unified
hierarchy.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h        |    2 ++
 include/linux/cgroup_subsys.h |   11 +++++++----
 kernel/cgroup.c               |   21 ++++++++++++++++++---
 3 files changed, 27 insertions(+), 7 deletions(-)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -296,6 +296,8 @@ enum {
 	 *   the flag is not created.
 	 *
 	 * - blkcg: blk-throttle becomes properly hierarchical.
+	 *
+	 * - debug: disallowed on the default hierarchy.
 	 */
 	CGRP_ROOT_SANE_BEHAVIOR	= (1 << 0),
 
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -7,10 +7,6 @@
 SUBSYS(cpuset)
 #endif
 
-#if IS_ENABLED(CONFIG_CGROUP_DEBUG)
-SUBSYS(debug)
-#endif
-
 #if IS_ENABLED(CONFIG_CGROUP_SCHED)
 SUBSYS(cpu)
 #endif
@@ -50,6 +46,13 @@ SUBSYS(net_prio)
 #if IS_ENABLED(CONFIG_CGROUP_HUGETLB)
 SUBSYS(hugetlb)
 #endif
+
+/*
+ * The following subsystems are not supported on the default hierarchy.
+ */
+#if IS_ENABLED(CONFIG_CGROUP_DEBUG)
+SUBSYS(debug)
+#endif
 /*
  * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -148,6 +148,13 @@ struct cgroup_root cgrp_dfl_root;
  */
 static bool cgrp_dfl_root_visible;
 
+/* some controllers are not supported in the default hierarchy */
+static const unsigned int cgrp_dfl_root_inhibit_ss_mask = 0
+#ifdef CONFIG_CGROUP_DEBUG
+	| (1 << debug_cgrp_id)
+#endif
+	;
+
 /* The list of hierarchy roots */
 
 static LIST_HEAD(cgroup_roots);
@@ -1160,6 +1167,7 @@ static void cgroup_clear_dir(struct cgro
 static int rebind_subsystems(struct cgroup_root *dst_root, unsigned int ss_mask)
 {
 	struct cgroup_subsys *ss;
+	unsigned int tmp_ss_mask;
 	int ssid, i, ret;
 
 	lockdep_assert_held(&cgroup_mutex);
@@ -1177,7 +1185,12 @@ static int rebind_subsystems(struct cgro
 			return -EBUSY;
 	}
 
-	ret = cgroup_populate_dir(&dst_root->cgrp, ss_mask);
+	/* skip creating root files on dfl_root for inhibited subsystems */
+	tmp_ss_mask = ss_mask;
+	if (dst_root == &cgrp_dfl_root)
+		tmp_ss_mask &= ~cgrp_dfl_root_inhibit_ss_mask;
+
+	ret = cgroup_populate_dir(&dst_root->cgrp, tmp_ss_mask);
 	if (ret) {
 		if (dst_root != &cgrp_dfl_root)
 			return ret;
@@ -2444,7 +2457,8 @@ static int cgroup_root_controllers_show(
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-	cgroup_print_ss_mask(seq, cgrp->root->subsys_mask);
+	cgroup_print_ss_mask(seq, cgrp->root->subsys_mask &
+			     ~cgrp_dfl_root_inhibit_ss_mask);
 	return 0;
 }
 
@@ -2582,7 +2596,8 @@ static ssize_t cgroup_subtree_control_wr
 		if (tok[0] == '\0')
 			continue;
 		for_each_subsys(ss, ssid) {
-			if (ss->disabled || strcmp(tok + 1, ss->name))
+			if (ss->disabled || strcmp(tok + 1, ss->name) ||
+			    ((1 << ss->id) & cgrp_dfl_root_inhibit_ss_mask))
 				continue;
 
 			if (*tok == '+') {
