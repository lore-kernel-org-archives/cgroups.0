From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 07/10] cgroup: implement cgroup v2 thread support
Date: Thu, 15 Jun 2017 16:14:16 -0400
Message-ID: <20170615201416.GA25445@htj.duckdns.org>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170610140351.10703-8-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dAQ0yXO5Oxu+nZPUc8pjZbMm6hIJvLplByxRQQEC3B4=;
        b=RfW62ggm2fNwuuszCZxFeiCirdVITZw+b3AuSeIrAaSCUATdoGKmQdVzIkTftYYOb9
         hEMIK3oCHE4OQUHwmwHa5P4Xsu86kxVrJu/BV/ycLbk17K4Xk+mKWJJAAWdbSK4G3iHW
         6vhvaTQkarKdf2VbmGNfw55dHCn1wsy8yINS4pY6MNgiNyBPrKrHD1aaosSAeM+vdzAq
         37SV+dJ+ZlX0Kk9Jo7x+r26yTTJAlOlxtwKv/G0A7C1wKHcx3bdna5Qc76ngyNFES/zN
         pC3rIevc2UbL/y3BZzTVmnMUL1xsZy8WUwz6oQFxuhP2UX+qBocAgLUITi/0CcbIwDU4
         Z+eg==
Content-Disposition: inline
In-Reply-To: <20170610140351.10703-8-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

This patch implements cgroup v2 thread support.  The goal of the
thread mode is supporting hierarchical accounting and control at
thread granularity while staying inside the resource domain model
which allows coordination across different resource controllers and
handling of anonymous resource consumptions.

Once thread mode is enabled on a cgroup, the threads of the processes
which are in its subtree can be placed inside the subtree without
being restricted by process granularity or no-internal-process
constraint.  Note that the threads aren't allowed to escape to a
different threaded subtree.  To be used inside a threaded subtree, a
controller should explicitly support threaded mode and be able to
handle internal competition in the way which is appropriate for the
resource.

The root of a threaded subtree, where thread mode is enabled in the
first place, is called the thread root and serves as the resource
domain for the whole subtree.  This is the last cgroup where
non-threaded controllers are operational and where all the
domain-level resource consumptions in the subtree are accounted.  This
allows threaded controllers to operate at thread granularity when
requested while staying inside the scope of system-level resource
distribution.

As the root cgroup is exempt from the no-internal-process constraint,
it can serve as both a thread root and a parent to normal cgroups.
The root cgroup supports mixed cgroup mode which can be enabled and
disabled anytime as long as there aren't any threaded children.  First
level child cgroups joins the mixed threaded subtree when thread mode
is enabled on them.

Internally, in a threaded subtree, each css_set has its ->proc_cset
pointing to a matching css_set which belongs to the thread root.  This
ensures that thread root level cgroup_subsys_state for all threaded
controllers are readily accessible for domain-level operations.

This patch enables threaded mode for the pids and perf_events
controllers.  Neither has to worry about domain-level resource
consumptions and it's enough to simply set the flag.

For more details on the interface and behavior of the thread mode,
please refer to the section 2-2-2 in Documentation/cgroup-v2.txt added
by this patch.  Note that the documentation update is not complete as
the rest of the documentation needs to be updated accordingly.
Rolling those updates into this patch can be confusing so that will be
separate patches.

v3: - Dropped "join" and always make mixed children join the parent's
      threaded subtree.

v2: - After discussions with Waiman, support for mixed thread mode is
      added.  This should address the issue that Peter pointed out
      where any nesting should be avoided for thread subtrees while
      coexisting with other domain cgroups.

    - Enabling / disabling thread mode now piggy backs on the existing
      control mask update mechanism.

    - Bug fixes and cleanup.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
Hello,

This is the alternative version where we don't support topologies like
the following.

         root (thread mode)
         /              \
        /                \
       /                  \
      A                    B
 (member of root's     (root of its own
  thread subtree)       thread subtree)

Supporting or not supporting the above topology only has user
interface implications.  Supporting it means more complication or
ugliness in the interface.  Not supporting it obviously results in a
simpler interface but at the cost of some of the flexibility of thread
mode.

Choosing one over the other is unlikely to result in substantial
actual differences.

Thanks.

 Documentation/cgroup-v2.txt |  111 +++++++++++++++
 include/linux/cgroup-defs.h |   12 +
 kernel/cgroup/cgroup.c      |  310 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/cgroup/pids.c        |    1 
 kernel/events/core.c        |    1 
 5 files changed, 419 insertions(+), 16 deletions(-)

--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -16,7 +16,9 @@ CONTENTS
   1-2. What is cgroup?
 2. Basic Operations
   2-1. Mounting
-  2-2. Organizing Processes
+  2-2. Organizing Processes and Threads
+    2-2-1. Processes
+    2-2-2. Threads
   2-3. [Un]populated Notification
   2-4. Controlling Controllers
     2-4-1. Enabling and Disabling
@@ -150,7 +152,9 @@ and experimenting easier, the kernel par
 disabling controllers in v1 and make them always available in v2.
 
 
-2-2. Organizing Processes
+2-2. Organizing Processes and Threads
+
+2-2-1. Processes
 
 Initially, only the root cgroup exists to which all processes belong.
 A child cgroup can be created by creating a sub-directory.
@@ -201,6 +205,109 @@ is removed subsequently, " (deleted)" is
   0::/test-cgroup/test-cgroup-nested (deleted)
 
 
+2-2-2. Threads
+
+cgroup v2 supports thread granularity for a subset of controllers to
+support use cases requiring hierarchical resource distribution across
+the threads of a group of processes.  By default, all threads of a
+process belong to the same cgroup, which also serves as the resource
+domain to host resource consumptions which are not specific to a
+process or thread.  The thread mode allows threads to be spread across
+a subtree while still maintaining the common resource domain for them.
+
+Enabling thread mode on a subtree makes it threaded.  The root of a
+threaded subtree is called thread root and serves as the resource
+domain for the entire subtree.  In a threaded subtree, threads of a
+process can be put in different cgroups and are not subject to the no
+internal process constraint - threaded controllers can be enabled on
+non-leaf cgroups whether they have threads in them or not.
+
+Because the root cgroup is not subject to no internal process
+constraint, it can serve both as a thread root and a parent to normal
+cgroups.  This is called mixed thread mode.
+
+Thread mode can be enabled by writing "enable" to "cgroup.threads"
+file.
+
+  # echo enable > cgroup.threads
+
+On a non-root cgroup, to enable the thread mode, the following
+conditions must be met.
+
+- The thread root doesn't have any child cgroups.
+
+- The thread root doesn't have any controllers enabled.
+
+On the root cgroup, only the mixed thread mode is supported.  The
+following condition should be met to enable.
+
+- The root cgroup doesn't have any threaded children.
+
+Unlike the normal thread mode, the whole subtree is not turned into
+thread subtree.  The first level children have to explicitly opt-in to
+join the thread subtree by enabling thread mode.  To join the thread
+subtree, a first level child must meet the following conditions.
+
+- The first level child doesn't have any child cgroups.
+
+- The first level child doesn't have any controllers enabled.
+
+- The first level child doesn't have any tasks.
+
+Inside a threaded subtree, "cgroup.threads" can be read and contains
+the list of the thread IDs of all threads in the cgroup.  Except that
+the operations are per-thread instead of per-process, "cgroup.threads"
+has the same format and behaves the same way as "cgroup.procs".
+
+The thread root serves as the resource domain for the whole subtree,
+and, while the threads can be scattered across the subtree, all the
+processes are considered to be in the thread root.  "cgroup.procs" in
+a thread root contains the PIDs of all processes in the subtree and is
+not readable in the subtree proper.  However, "cgroup.procs" can be
+written to from anywhere in the subtree to migrate all threads of the
+matching process to the cgroup.
+
+Only threaded controllers can be enabled in a threaded subtree.  When
+a threaded controller is enabled inside a threaded subtree, it only
+accounts for and controls resource consumptions associated with the
+threads in the cgroup and its descendants.  All consumptions which
+aren't tied to a specific thread belong to the thread root.
+
+Because a threaded subtree is exempt from no internal process
+constraint, a threaded controller must be able to handle competition
+between threads in a non-leaf cgroup and its child cgroups.  Each
+threaded controller defines how such competitions are handled.
+
+Thread mode can be disabled by writing "disable" to "cgroup.threads"
+file.
+
+  # echo disable > cgroup.threads
+
+On a normal thread subtree, to disable the thread mode, the following
+conditions must be met.
+
+- The cgroup is a thread root.  Thread mode can't be disabled
+  partially in the subtree.
+
+- The thread root doesn't have any child cgroups.
+
+- The thread root doesn't have any controllers enabled.
+
+On the root cgroup, to disable the mixed thread mode, the following
+condition should be met.
+
+- The root cgroup doesn't have any threaded children.
+
+On a first level child of the mixed thread subtree, the following
+conditions should be met.
+
+- The first level child doesn't have any child cgroups.
+
+- The first level child doesn't have any controllers enabled.
+
+- The first level child doesn't have any tasks.
+
+
 2-3. [Un]populated Notification
 
 Each non-root cgroup has a "cgroup.events" file which contains
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -505,6 +505,18 @@ struct cgroup_subsys {
 	bool implicit_on_dfl:1;
 
 	/*
+	 * If %true, the controller, supports threaded mode on the default
+	 * hierarchy.  In a threaded subtree, both process granularity and
+	 * no-internal-process constraint are ignored and a threaded
+	 * controllers should be able to handle that.
+	 *
+	 * Note that as an implicit controller is automatically enabled on
+	 * all cgroups on the default hierarchy, it should also be
+	 * threaded.  implicit && !threaded is not supported.
+	 */
+	bool threaded:1;
+
+	/*
 	 * If %false, this subsystem is properly hierarchical -
 	 * configuration, resource accounting and restriction on a parent
 	 * cgroup cover those of its children.  If %true, hierarchy support
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -162,6 +162,9 @@ static u16 cgrp_dfl_inhibit_ss_mask;
 /* some controllers are implicitly enabled on the default hierarchy */
 static u16 cgrp_dfl_implicit_ss_mask;
 
+/* some controllers can be threaded on the default hierarchy */
+static u16 cgrp_dfl_threaded_ss_mask;
+
 /* The list of hierarchy roots */
 LIST_HEAD(cgroup_roots);
 static int cgroup_root_count;
@@ -331,14 +334,60 @@ static bool cgroup_is_threaded(struct cg
 	return cgrp->proc_cgrp;
 }
 
+/* is @cgrp root of a threaded subtree? */
+static bool cgroup_is_thread_root(struct cgroup *cgrp)
+{
+	return cgrp->proc_cgrp == cgrp;
+}
+
+/* if threaded, would @cgrp become root of a mixed threaded subtree? */
+static bool cgroup_is_mixable(struct cgroup *cgrp)
+{
+	/*
+	 * Root isn't under domain level resource control exempting it from
+	 * the no-internal-process constraint, so it can serve as a thread
+	 * root and a parent of resource domains at the same time.
+	 */
+	return !cgroup_parent(cgrp);
+}
+
+/* is @cgrp root of a mixed threaded subtree */
+static bool cgroup_is_mixed_root(struct cgroup *cgrp)
+{
+	return cgroup_is_thread_root(cgrp) && cgroup_is_mixable(cgrp);
+}
+
+/* is @cgrp's parent a mixed thread root? */
+static bool cgroup_has_mixed_parent(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+
+	return parent && cgroup_is_mixed_root(parent);
+}
+
+/* is @cgrp the first level child of a mixed threaded subtree */
+static bool cgroup_is_mixed_child(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+
+	return parent && cgrp->proc_cgrp == parent &&
+		cgroup_is_mixed_root(parent);
+}
+
 /* subsystems visibly enabled on a cgroup */
 static u16 cgroup_control(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 	u16 root_ss_mask = cgrp->root->subsys_mask;
 
-	if (parent)
-		return parent->subtree_control;
+	if (parent) {
+		u16 ss_mask = parent->subtree_control;
+
+		/* mixed child can only have threaded subset of controllers */
+		if (cgroup_is_mixed_child(cgrp))
+			ss_mask &= cgrp_dfl_threaded_ss_mask;
+		return ss_mask;
+	}
 
 	if (cgroup_on_dfl(cgrp))
 		root_ss_mask &= ~(cgrp_dfl_inhibit_ss_mask |
@@ -351,8 +400,14 @@ static u16 cgroup_ss_mask(struct cgroup
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 
-	if (parent)
-		return parent->subtree_ss_mask;
+	if (parent) {
+		u16 ss_mask = parent->subtree_ss_mask;
+
+		/* mixed child can only have threaded subset of controllers */
+		if (cgroup_is_mixed_child(cgrp))
+			ss_mask &= cgrp_dfl_threaded_ss_mask;
+		return ss_mask;
+	}
 
 	return cgrp->root->subsys_mask;
 }
@@ -2241,14 +2296,14 @@ out_release_tset:
  * cgroup_may_migrate_to - verify whether a cgroup can be migration destination
  * @dst_cgrp: destination cgroup to test
  *
- * On the default hierarchy, except for the root, subtree_control must be
- * zero for migration destination cgroups with tasks so that child cgroups
- * don't compete against tasks.
+ * On the default hierarchy, except for the mixable and threaded cgroups,
+ * subtree_control must be zero for migration destination cgroups with
+ * tasks so that child cgroups don't compete against tasks.
  */
 bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
 {
-	return !cgroup_on_dfl(dst_cgrp) || !cgroup_parent(dst_cgrp) ||
-		!dst_cgrp->subtree_control;
+	return !cgroup_on_dfl(dst_cgrp) || cgroup_is_mixable(dst_cgrp) ||
+		cgroup_is_threaded(dst_cgrp) || !dst_cgrp->subtree_control;
 }
 
 /**
@@ -2957,11 +3012,20 @@ static ssize_t cgroup_subtree_control_wr
 		goto out_unlock;
 	}
 
+	/* can't enable !threaded controllers on a threaded cgroup */
+	if (cgroup_is_threaded(cgrp) && !cgroup_is_mixed_root(cgrp) &&
+	    (enable & ~cgrp_dfl_threaded_ss_mask)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	/*
-	 * Except for the root, subtree_control must be zero for a cgroup
-	 * with tasks so that child cgroups don't compete against tasks.
+	 * Except for mixable and threaded cgroups, subtree_control must be
+	 * zero for a cgroup with tasks so that child cgroups don't compete
+	 * against tasks.
 	 */
-	if (enable && cgroup_parent(cgrp) && cgroup_has_tasks(cgrp)) {
+	if (enable && !cgroup_is_mixable(cgrp) && !cgroup_is_threaded(cgrp) &&
+	    cgroup_has_tasks(cgrp)) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -2983,6 +3047,120 @@ out_unlock:
 	return ret ?: nbytes;
 }
 
+static int cgroup_vet_threaded_switch(struct cgroup *cgrp, bool is_enable)
+{
+	if (cgroup_has_mixed_parent(cgrp)) {
+		/*
+		 * @cgrp is joining or leaving an existing mixed threaded
+		 * root.  Avoid needing recursive operations, implicit
+		 * subtree_control changes, or migrations.
+		 */
+		if (css_has_online_children(&cgrp->self) ||
+		    cgrp->subtree_control || cgroup_has_tasks(cgrp))
+			return -EBUSY;
+	} else if (cgroup_is_mixable(cgrp)) {
+		struct cgroup *child;
+
+		/*
+		 * @cgrp is starting or ending a mixed threaded subtree.
+		 * It's allowed to have domain children and enabled
+		 * controllers but we can't change ->proc_cgrp of existing
+		 * threaded children.  Make sure there aren't already
+		 * threaded children.
+		 */
+		cgroup_for_each_live_child(child, cgrp)
+			if (cgroup_is_threaded(child))
+				return -EBUSY;
+	} else {
+		/*
+		 * @cgrp is starting or ending a normal threaded subtree.
+		 * Avoid needing recursive operations, or implicit
+		 * subtree_control changes.
+		 */
+		if (css_has_online_children(&cgrp->self) ||
+		    cgrp->subtree_control)
+			return -EBUSY;
+
+		/* no partial disable */
+		if (!is_enable && !cgroup_is_thread_root(cgrp))
+			return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int cgroup_enable_threaded(struct cgroup *cgrp)
+{
+	struct cgroup *proc_cgrp;
+	int ret;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	/* noop if already threaded */
+	if (cgroup_is_threaded(cgrp))
+		return 0;
+
+	ret = cgroup_vet_threaded_switch(cgrp, true);
+	if (ret)
+		return ret;
+
+	/* if the parent is mixed threaded root, join the subtree */
+	if (cgroup_has_mixed_parent(cgrp))
+		proc_cgrp = cgroup_parent(cgrp);
+	else
+		proc_cgrp = cgrp;
+
+	cgroup_save_control(cgrp);
+
+	/*
+	 * Mark it threaded.  This makes cgroup_control() and
+	 * cgroup_ss_mask() skip domain controllers.  In turn, the
+	 * following control operations migrate tasks to the matching
+	 * threaded csets.
+	 */
+	cgrp->proc_cgrp = proc_cgrp;
+
+	ret = cgroup_apply_control(cgrp);
+	if (ret)
+		cgrp->proc_cgrp = NULL;
+
+	cgroup_finalize_control(cgrp, ret);
+
+	return ret;
+}
+
+static int cgroup_disable_threaded(struct cgroup *cgrp)
+{
+	struct cgroup *proc_cgrp = cgrp->proc_cgrp;
+	int ret;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	/* noop if already !threaded */
+	if (!cgroup_is_threaded(cgrp))
+		return 0;
+
+	ret = cgroup_vet_threaded_switch(cgrp, false);
+	if (ret)
+		return ret;
+
+	cgroup_save_control(cgrp);
+
+	/*
+	 * Mark it !threaded.  This restores cgroup_control() and
+	 * cgroup_ss_mask() behavior.  See cgroup_enabled_threaded().
+	 */
+	cgrp->proc_cgrp = NULL;
+
+	ret = cgroup_apply_control(cgrp);
+	if (ret)
+		cgrp->proc_cgrp = proc_cgrp;
+
+	cgroup_finalize_control(cgrp, ret);
+
+	return ret;
+}
+
 static int cgroup_events_show(struct seq_file *seq, void *v)
 {
 	seq_printf(seq, "populated %d\n",
@@ -3866,12 +4044,12 @@ static void *cgroup_procs_next(struct se
 	return css_task_iter_next(it);
 }
 
-static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
+static void *__cgroup_procs_start(struct seq_file *s, loff_t *pos,
+				  unsigned int iter_flags)
 {
 	struct kernfs_open_file *of = s->private;
 	struct cgroup *cgrp = seq_css(s)->cgroup;
 	struct css_task_iter *it = of->priv;
-	unsigned iter_flags = CSS_TASK_ITER_PROCS | CSS_TASK_ITER_THREADED;
 
 	/*
 	 * When a seq_file is seeked, it's always traversed sequentially
@@ -3894,6 +4072,23 @@ static void *cgroup_procs_start(struct s
 	return cgroup_procs_next(s, NULL, NULL);
 }
 
+static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
+{
+	struct cgroup *cgrp = seq_css(s)->cgroup;
+
+	/*
+	 * All processes of a threaded subtree are in the top threaded
+	 * cgroup.  Only threads can be distributed across the subtree.
+	 * Reject reads on cgroup.procs in the subtree proper.  They're
+	 * always empty anyway.
+	 */
+	if (cgroup_is_threaded(cgrp) && !cgroup_is_thread_root(cgrp))
+		return ERR_PTR(-EINVAL);
+
+	return __cgroup_procs_start(s, pos, CSS_TASK_ITER_PROCS |
+					    CSS_TASK_ITER_THREADED);
+}
+
 static int cgroup_procs_show(struct seq_file *s, void *v)
 {
 	seq_printf(s, "%d\n", task_pid_vnr(v));
@@ -3948,6 +4143,76 @@ out_unlock:
 	return ret ?: nbytes;
 }
 
+static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
+{
+	struct cgroup *cgrp = seq_css(s)->cgroup;
+
+	if (!cgroup_is_threaded(cgrp))
+		return ERR_PTR(-EINVAL);
+
+	return __cgroup_procs_start(s, pos, 0);
+}
+
+static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
+{
+	struct super_block *sb = of->file->f_path.dentry->d_sb;
+	struct cgroup *cgrp, *common_ancestor;
+	struct task_struct *task;
+	ssize_t ret;
+
+	buf = strstrip(buf);
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENODEV;
+
+	/* cgroup.procs determines delegation, require permission on it too */
+	ret = cgroup_procs_write_permission(cgrp, sb);
+	if (ret)
+		goto out_unlock;
+
+	/* enable or disable? */
+	if (!strcmp(buf, "enable")) {
+		ret = cgroup_enable_threaded(cgrp);
+		goto out_unlock;
+	} else if (!strcmp(buf, "disable")) {
+		ret = cgroup_disable_threaded(cgrp);
+		goto out_unlock;
+	}
+
+	/* thread migration */
+	ret = -EINVAL;
+	if (!cgroup_is_threaded(cgrp))
+		goto out_unlock;
+
+	task = cgroup_procs_write_start(buf, false);
+	ret = PTR_ERR_OR_ZERO(task);
+	if (ret)
+		goto out_unlock;
+
+	common_ancestor = cgroup_migrate_common_ancestor(task, cgrp);
+
+	/* can't migrate across disjoint threaded subtrees */
+	ret = -EACCES;
+	if (common_ancestor->proc_cgrp != cgrp->proc_cgrp)
+		goto out_finish;
+
+	/* and follow the cgroup.procs delegation rule */
+	ret = cgroup_procs_write_permission(common_ancestor, sb);
+	if (ret)
+		goto out_finish;
+
+	ret = cgroup_attach_task(cgrp, task, false);
+
+out_finish:
+	cgroup_procs_write_finish(task);
+out_unlock:
+	cgroup_kn_unlock(of->kn);
+
+	return ret ?: nbytes;
+}
+
 /* cgroup core interface files for the default hierarchy */
 static struct cftype cgroup_base_files[] = {
 	{
@@ -3960,6 +4225,14 @@ static struct cftype cgroup_base_files[]
 		.write = cgroup_procs_write,
 	},
 	{
+		.name = "cgroup.threads",
+		.release = cgroup_procs_release,
+		.seq_start = cgroup_threads_start,
+		.seq_next = cgroup_procs_next,
+		.seq_show = cgroup_procs_show,
+		.write = cgroup_threads_write,
+	},
+	{
 		.name = "cgroup.controllers",
 		.seq_show = cgroup_controllers_show,
 	},
@@ -4274,6 +4547,9 @@ static struct cgroup *cgroup_create(stru
 	cgrp->root = root;
 	cgrp->level = level;
 
+	if (!cgroup_has_mixed_parent(cgrp))
+		cgrp->proc_cgrp = parent->proc_cgrp;
+
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp))
 		cgrp->ancestor_ids[tcgrp->level] = tcgrp->id;
 
@@ -4720,11 +4996,17 @@ int __init cgroup_init(void)
 
 		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
 
+		/* implicit controllers must be threaded too */
+		WARN_ON(ss->implicit_on_dfl && !ss->threaded);
+
 		if (ss->implicit_on_dfl)
 			cgrp_dfl_implicit_ss_mask |= 1 << ss->id;
 		else if (!ss->dfl_cftypes)
 			cgrp_dfl_inhibit_ss_mask |= 1 << ss->id;
 
+		if (ss->threaded)
+			cgrp_dfl_threaded_ss_mask |= 1 << ss->id;
+
 		if (ss->dfl_cftypes == ss->legacy_cftypes) {
 			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
 		} else {
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -345,4 +345,5 @@ struct cgroup_subsys pids_cgrp_subsys =
 	.free		= pids_free,
 	.legacy_cftypes	= pids_files,
 	.dfl_cftypes	= pids_files,
+	.threaded	= true,
 };
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11155,5 +11155,6 @@ struct cgroup_subsys perf_event_cgrp_sub
 	 * controller is not mounted on a legacy hierarchy.
 	 */
 	.implicit_on_dfl = true,
+	.threaded	= true,
 };
 #endif /* CONFIG_CGROUP_PERF */
