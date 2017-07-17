From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2 cgroup/for-4.14] cgroup: distinguish local and children
 populated states
Date: Sun, 16 Jul 2017 21:43:33 -0400
Message-ID: <20170717014333.GA3519177@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=75SmWEnmeNsDm4feRbWf/cRlJnazD0o0PHYIkHqE1wM=;
        b=cBRKAK4pJ04PiuS+mdkYkNNg8n4529DsM3PFVuLKARB9gOAkBWd70OfZZWbvOsxs2t
         6Mm8Qa3JFYaX0YCY/aFv1RD8HFGbxm3DRVLbo4+Y9fa4yyCX4ppvcqe+OqVV8O6SamzN
         2wyfleW48m/BHSOdlJT0Kl4llt5jQuDtWe+rUBG8c/7mnDvpw+alRZzCh2nqVELaNJA5
         +OZ4za8H8vLLjQVA6UuZWNI77bUhyHZoNvG7E20bULRh/q/6SC70M+W6T/08dmX7+XVP
         1kCuzHhqqqmCV2Kmv22PDE9mnVfBznXHVE9i93pavG/AthvaBF1Sezpwb0fv8KK5Cve0
         TWbg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

cgrp->populated_cnt counts both local (the cgroup's populated
css_sets) and subtree proper (populated children) so that it's only
zero when the whole subtree, including self, is empty.

This patch splits the counter into two so that local and children
populated states are tracked separately.  It allows finer-grained
tests on the state of the hierarchy which will be used to replace
css_set walking local populated test.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applying to cgroup/for-4.14.

Thanks.

 include/linux/cgroup-defs.h |   13 +++++++++----
 include/linux/cgroup.h      |    2 +-
 kernel/cgroup/cgroup.c      |   37 +++++++++++++++++++++----------------
 3 files changed, 31 insertions(+), 21 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -263,11 +263,16 @@ struct cgroup {
 
 	/*
 	 * Each non-empty css_set associated with this cgroup contributes
-	 * one to populated_cnt.  All children with non-zero popuplated_cnt
-	 * of their own contribute one.  The count is zero iff there's no
-	 * task in this cgroup or its subtree.
+	 * one to nr_populated_csets.  The counter is zero iff this cgroup
+	 * doesn't have any tasks.
+	 *
+	 * All children which have non-zero nr_populated_csets and/or
+	 * nr_populated_children of their own contribute one to
+	 * nr_populated_children.  The counter is zero iff this cgroup's
+	 * subtree proper doesn't have any tasks.
 	 */
-	int populated_cnt;
+	int nr_populated_csets;
+	int nr_populated_children;
 
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
 	struct cgroup_file procs_file;	/* handle for "cgroup.procs" */
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -537,7 +537,7 @@ static inline bool task_under_cgroup_hie
 /* no synchronization, the result can only be used as a hint */
 static inline bool cgroup_is_populated(struct cgroup *cgrp)
 {
-	return cgrp->populated_cnt;
+	return cgrp->nr_populated_csets + cgrp->nr_populated_children;
 }
 
 /* returns ino associated with a cgroup */
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -587,39 +587,44 @@ static bool css_set_populated(struct css
 }
 
 /**
- * cgroup_update_populated - updated populated count of a cgroup
+ * cgroup_update_populated - update the populated count of a cgroup
  * @cgrp: the target cgroup
  * @populated: inc or dec populated count
  *
  * One of the css_sets associated with @cgrp is either getting its first
- * task or losing the last.  Update @cgrp->populated_cnt accordingly.  The
- * count is propagated towards root so that a given cgroup's populated_cnt
- * is zero iff the cgroup and all its descendants don't contain any tasks.
+ * task or losing the last.  Update @cgrp->nr_populated_* accordingly.  The
+ * count is propagated towards root so that a given cgroup's
+ * nr_populated_children is zero iff none of its descendants contain any
+ * tasks.
  *
- * @cgrp's interface file "cgroup.populated" is zero if
- * @cgrp->populated_cnt is zero and 1 otherwise.  When @cgrp->populated_cnt
- * changes from or to zero, userland is notified that the content of the
- * interface file has changed.  This can be used to detect when @cgrp and
- * its descendants become populated or empty.
+ * @cgrp's interface file "cgroup.populated" is zero if both
+ * @cgrp->nr_populated_csets and @cgrp->nr_populated_children are zero and
+ * 1 otherwise.  When the sum changes from or to zero, userland is notified
+ * that the content of the interface file has changed.  This can be used to
+ * detect when @cgrp and its descendants become populated or empty.
  */
 static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 {
+	struct cgroup *child = NULL;
+	int adj = populated ? 1 : -1;
+
 	lockdep_assert_held(&css_set_lock);
 
 	do {
-		bool trigger;
+		bool was_populated = cgroup_is_populated(cgrp);
 
-		if (populated)
-			trigger = !cgrp->populated_cnt++;
+		if (!child)
+			cgrp->nr_populated_csets += adj;
 		else
-			trigger = !--cgrp->populated_cnt;
+			cgrp->nr_populated_children += adj;
 
-		if (!trigger)
+		if (was_populated == cgroup_is_populated(cgrp))
 			break;
 
 		cgroup1_check_for_release(cgrp);
 		cgroup_file_notify(&cgrp->events_file);
 
+		child = cgrp;
 		cgrp = cgroup_parent(cgrp);
 	} while (cgrp);
 }
@@ -630,7 +635,7 @@ static void cgroup_update_populated(stru
  * @populated: whether @cset is populated or depopulated
  *
  * @cset is either getting the first task or losing the last.  Update the
- * ->populated_cnt of all associated cgroups accordingly.
+ * populated counters of all associated cgroups accordingly.
  */
 static void css_set_update_populated(struct css_set *cset, bool populated)
 {
@@ -653,7 +658,7 @@ static void css_set_update_populated(str
  * css_set, @from_cset can be NULL.  If @task is being disassociated
  * instead of moved, @to_cset can be NULL.
  *
- * This function automatically handles populated_cnt updates and
+ * This function automatically handles populated counter updates and
  * css_task_iter adjustments but the caller is responsible for managing
  * @from_cset and @to_cset's reference counts.
  */
