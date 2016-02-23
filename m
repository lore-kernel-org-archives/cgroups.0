From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/12] cgroup: make cgroup_calc_subtree_ss_mask() take @this_ss_mask
Date: Mon, 22 Feb 2016 22:45:46 -0500
Message-ID: <1456199146-14765-13-git-send-email-tj@kernel.org>
References: <1456199146-14765-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fluHgzvJ1RXO3S1RXF9e+DABQm2O4c/Y44QY9ukrPlA=;
        b=GPtzx+mj5bAOU/BxC2Rch2m2dXbb1RXT6oozJqCA141YIShSg8smSpVshHL5lLZgNv
         5sYVZFyCntN10FEJixU9Qtjw4IiVUQj2aIrCXtmo63ucKkU3P13NNodN+xJarjtfwFdf
         qHzomwJ6FH99uA2brpkkqfssoEldYLSj7NpbrGdAjrYsQlKBIA00+EZfLOdE+2vJ3ip4
         wHsrM9tfXkohupLQIjTK2E2kyyZTJ01TwG7MnD2Qa1i41D0XkdV1HmM/24ua9lavFC1r
         YjwvlWJQJE767ABHhpLqDwDelsgXPLtOCSeCKERsotRrHTERFgj/wGnXm1599/Jqv4ul
         jQAQ==
In-Reply-To: <1456199146-14765-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

cgroup_calc_subtree_ss_mask() currently takes @cgrp and
@subtree_control.  @cgrp is used for two purposes - to decide whether
it's for default hierarchy and the mask of available subsystems.  The
former doesn't matter as the results are the same regardless.  The
latter can be specified directly through a subsystem mask.

This patch makes cgroup_calc_subtree_ss_mask() perform the same
calculations for both default and legacy hierarchies and take
@this_ss_mask for available subsystems.  @cgrp is no longer used and
dropped.  This is to allow using the function in contexts where
available controllers can't be decided from the cgroup.

This patch also drops cgroup_refresh_subtree_ss_mask().  It's a thin
wrapper which saves a bit of typing but the saving is pretty small and
planned changes will make its uses look inconsistent compared to
usages which don't update cgroups.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a1f82fa..15461c7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1301,18 +1301,17 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 
 /**
  * cgroup_calc_subtree_ss_mask - calculate subtree_ss_mask
- * @cgrp: the target cgroup
  * @subtree_control: the new subtree_control mask to consider
+ * @this_ss_mask: available subsystems
  *
  * On the default hierarchy, a subsystem may request other subsystems to be
  * enabled together through its ->depends_on mask.  In such cases, more
  * subsystems than specified in "cgroup.subtree_control" may be enabled.
  *
  * This function calculates which subsystems need to be enabled if
- * @subtree_control is to be applied to @cgrp.  The returned mask is always
- * a superset of @subtree_control and follows the usual hierarchy rules.
+ * @subtree_control is to be applied while restricted to @this_ss_mask.
  */
-static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
+static u16 cgroup_calc_subtree_ss_mask(u16 subtree_control, u16 this_ss_mask)
 {
 	u16 cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
@@ -1320,9 +1319,6 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!cgroup_on_dfl(cgrp))
-		return cur_ss_mask;
-
 	while (true) {
 		u16 new_ss_mask = cur_ss_mask;
 
@@ -1335,7 +1331,7 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 		 * happen only if some depended-upon subsystems were bound
 		 * to non-default hierarchies.
 		 */
-		new_ss_mask &= cgroup_ss_mask(cgrp);
+		new_ss_mask &= this_ss_mask;
 
 		if (new_ss_mask == cur_ss_mask)
 			break;
@@ -1346,19 +1342,6 @@ static u16 cgroup_calc_subtree_ss_mask(struct cgroup *cgrp, u16 subtree_control)
 }
 
 /**
- * cgroup_refresh_subtree_ss_mask - update subtree_ss_mask
- * @cgrp: the target cgroup
- *
- * Update @cgrp->subtree_ss_mask according to the current
- * @cgrp->subtree_control using cgroup_calc_subtree_ss_mask().
- */
-static void cgroup_refresh_subtree_ss_mask(struct cgroup *cgrp)
-{
-	cgrp->subtree_ss_mask =
-		cgroup_calc_subtree_ss_mask(cgrp, cgrp->subtree_control);
-}
-
-/**
  * cgroup_kn_unlock - unlocking helper for cgroup kernfs methods
  * @kn: the kernfs_node being serviced
  *
@@ -1592,7 +1575,9 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 
 		src_root->subsys_mask &= ~(1 << ssid);
 		scgrp->subtree_control &= ~(1 << ssid);
-		cgroup_refresh_subtree_ss_mask(scgrp);
+		scgrp->subtree_ss_mask =
+			cgroup_calc_subtree_ss_mask(scgrp->subtree_control,
+						    cgroup_ss_mask(scgrp));
 
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
@@ -1600,7 +1585,9 @@ static int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 			static_branch_enable(cgroup_subsys_on_dfl_key[ssid]);
 		} else {
 			dcgrp->subtree_control |= 1 << ssid;
-			cgroup_refresh_subtree_ss_mask(dcgrp);
+			dcgrp->subtree_ss_mask =
+				cgroup_calc_subtree_ss_mask(dcgrp->subtree_control,
+							    cgroup_ss_mask(dcgrp));
 			static_branch_disable(cgroup_subsys_on_dfl_key[ssid]);
 		}
 
@@ -3059,8 +3046,9 @@ static void cgroup_propagate_control(struct cgroup *cgrp)
 
 	cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp) {
 		dsct->subtree_control &= cgroup_control(dsct);
-		dsct->subtree_ss_mask = cgroup_calc_subtree_ss_mask(dsct,
-							dsct->subtree_control);
+		dsct->subtree_ss_mask =
+			cgroup_calc_subtree_ss_mask(dsct->subtree_control,
+						    cgroup_ss_mask(dsct));
 	}
 }
 
@@ -5108,7 +5096,9 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	 */
 	if (!cgroup_on_dfl(cgrp)) {
 		cgrp->subtree_control = cgroup_control(cgrp);
-		cgroup_refresh_subtree_ss_mask(cgrp);
+		cgrp->subtree_ss_mask =
+			cgroup_calc_subtree_ss_mask(cgrp->subtree_control,
+						    cgroup_ss_mask(cgrp));
 	}
 
 	return cgrp;
-- 
2.5.0

