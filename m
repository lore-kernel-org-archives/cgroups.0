From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Wed, 19 Jul 2017 15:44:38 -0400
Message-ID: <20170719194439.2915602-6-tj@kernel.org>
References: <20170719194439.2915602-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5ZDZ0JubahFpwkWroO9PJSGaB3KCYl0+CoNkAZspGlg=;
        b=ZI4ppx7gt0N0OkWy/gDez5DiKiFYSyfTnN9HFhtPij4QKYcW1x6CMOPyjdewxTBHok
         RKluwBXblxXPwCPSGmyuehVnBCDe7mOESrf9/9FajPA4N+VkxI212BXT0P9CEwnciUoi
         gYVYw29p6fnoXOUhN2Nl0BR1X0KKwd9JDxT/b9tu7K3jxXwW6u6Ox6UWstAqyjSFllTP
         m3/A5My2ylCcm/v3jth7dnvvO/vi8Xl/nJL95CfxzSLUljBzmObJy7Yn0SGRryJ9hjB5
         e3TG5ZFKNRAUyapb10zcKtqGCi0d/2DfuJbcQ2uo2GZQfcjfdm4/GjUUqcjYYM8dt5Ku
         d8aQ==
In-Reply-To: <20170719194439.2915602-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

This patch implements cgroup v2 thread support.  The goal of the
thread mode is supporting hierarchical accounting and control at
thread granularity while staying inside the resource domain model
which allows coordination across different resource controllers and
handling of anonymous resource consumptions.

A cgroup is always created as a domain and can be made threaded by
writing to the "cgroup.type" file.  When a cgroup becomes threaded, it
becomes a member of a threaded subtree which is anchored at the
closest ancestor which isn't threaded.

The threads of the processes which are in a threaded subtree can be
placed anywhere without being restricted by process granularity or
no-internal-process constraint.  Note that the threads aren't allowed
to escape to a different threaded subtree.  To be used inside a
threaded subtree, a controller should explicitly support threaded mode
and be able to handle internal competition in the way which is
appropriate for the resource.

The root of a threaded subtree, the nearest ancestor which isn't
threaded, is called the threaded domain and serves as the resource
domain for the whole subtree.  This is the last cgroup where domain
controllers are operational and where all the domain-level resource
consumptions in the subtree are accounted.  This allows threaded
controllers to operate at thread granularity when requested while
staying inside the scope of system-level resource distribution.

As the root cgroup is exempt from the no-internal-process constraint,
it can serve as both a threaded domain and a parent to normal cgroups,
so, unlike non-root cgroups, the root cgroup can have both domain and
threaded children.

Internally, in a threaded subtree, each css_set has its ->dom_cset
pointing to a matching css_set which belongs to the threaded domain.
This ensures that thread root level cgroup_subsys_state for all
threaded controllers are readily accessible for domain-level
operations.

This patch enables threaded mode for the pids and perf_events
controllers.  Neither has to worry about domain-level resource
consumptions and it's enough to simply set the flag.

For more details on the interface and behavior of the thread mode,
please refer to the section 2-2-2 in Documentation/cgroup-v2.txt added
by this patch.

v5: - Dropped silly no-op ->dom_cgrp init from cgroup_create().
      Spotted by Waiman.
    - Documentation updated as suggested by Waiman.
    - cgroup.type content slightly reformatted.
    - Mark the debug controller threaded.

v4: - Updated to the general idea of marking specific cgroups
      domain/threaded as suggested by PeterZ.

v3: - Dropped "join" and always make mixed children join the parent's
      threaded subtree.

v2: - After discussions with Waiman, support for mixed thread mode is
      added.  This should address the issue that Peter pointed out
      where any nesting should be avoided for thread subtrees while
      coexisting with other domain cgroups.
    - Enabling / disabling thread mode now piggy backs on the existing
      control mask update mechanism.
    - Bug fixes and cleanup.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/cgroup-v2.txt     | 185 +++++++++++++++++++--
 include/linux/cgroup-defs.h     |  12 ++
 kernel/cgroup/cgroup-internal.h |   2 +-
 kernel/cgroup/cgroup-v1.c       |   5 +-
 kernel/cgroup/cgroup.c          | 355 +++++++++++++++++++++++++++++++++++++---
 kernel/cgroup/debug.c           |   1 +
 kernel/cgroup/pids.c            |   1 +
 kernel/events/core.c            |   1 +
 8 files changed, 522 insertions(+), 40 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index f01f831..cb9ea28 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -18,7 +18,9 @@ v1 is available under Documentation/cgroup-v1/.
      1-2. What is cgroup?
    2. Basic Operations
      2-1. Mounting
-     2-2. Organizing Processes
+     2-2. Organizing Processes and Threads
+       2-2-1. Processes
+       2-2-2. Threads
      2-3. [Un]populated Notification
      2-4. Controlling Controllers
        2-4-1. Enabling and Disabling
@@ -167,8 +169,11 @@ cgroup v2 currently supports the following mount options.
 	Delegation section for details.
 
 
-Organizing Processes
---------------------
+Organizing Processes and Threads
+--------------------------------
+
+Processes
+~~~~~~~~~
 
 Initially, only the root cgroup exists to which all processes belong.
 A child cgroup can be created by creating a sub-directory::
@@ -219,6 +224,104 @@ If the process becomes a zombie and the cgroup it was associated with
   0::/test-cgroup/test-cgroup-nested (deleted)
 
 
+Threads
+~~~~~~~
+
+cgroup v2 supports thread granularity for a subset of controllers to
+support use cases requiring hierarchical resource distribution across
+the threads of a group of processes.  By default, all threads of a
+process belong to the same cgroup, which also serves as the resource
+domain to host resource consumptions which are not specific to a
+process or thread.  The thread mode allows threads to be spread across
+a subtree while still maintaining the common resource domain for them.
+
+Controllers which support thread mode are called threaded controllers.
+The ones which don't are called domain controllers.
+
+Marking a cgroup threaded makes it join the resource domain of its
+parent as a threaded cgroup.  The parent may be another threaded
+cgroup whose resource domain is further up in the hierarchy.  The root
+of a threaded subtree, that is, the nearest ancestor which is not
+threaded, is called threaded domain or thread root interchangeably and
+serves as the resource domain for the entire subtree.
+
+Inside a threaded subtree, threads of a process can be put in
+different cgroups and are not subject to the no internal process
+constraint - threaded controllers can be enabled on non-leaf cgroups
+whether they have threads in them or not.
+
+As the threaded domain cgroup hosts all the domain resource
+consumptions of the subtree, it is considered to have internal
+resource consumptions whether there are processes in it or not and
+can't have populated child cgroups which aren't threaded.  Because the
+root cgroup is not subject to no internal process constraint, it can
+serve both as a threaded domain and a parent to domain cgroups.
+
+The current operation mode or type of the cgroup is shown in the
+"cgroup.type" file which indicates whether the cgroup is a normal
+domain, a domain which is serving as the domain of a threaded subtree,
+or a threaded cgroup.
+
+On creation, a cgroup is always a domain cgroup and can be made
+threaded by writing "threaded" to the "cgroup.type" file.  The
+operation is single direction::
+
+  # echo threaded > cgroup.type
+
+Once threaded, the cgroup can't be made a domain again.  To enable the
+thread mode, the following conditions must be met.
+
+- As the cgroup will join the parent's resource domain.  The parent
+  must either be a valid (threaded) domain or a threaded cgroup.
+
+- The cgroup must be empty.  No enabled controllers, child cgroups or
+  processes.
+
+Topology-wise, a cgroup can be in an invalid state.  Please consider
+the following toplogy::
+
+  A (threaded domain) - B (threaded) - C (domain, just created)
+
+C is created as a domain but isn't connected to a parent which can
+host child domains.  C can't be used until it is turned into a
+threaded cgroup.  "cgroup.type" file will report "domain (invalid)" in
+these cases.  Operations which fail due to invalid topology use
+EOPNOTSUPP as the errno.
+
+A domain cgroup is turned into a threaded domain when one of its child
+cgroup becomes threaded or threaded controllers are enabled in the
+"cgroup.subtree_control" file while there are processes in the cgroup.
+A threaded domain reverts to a normal domain when the conditions
+clear.
+
+When read, "cgroup.threads" contains the list of the thread IDs of all
+threads in the cgroup.  Except that the operations are per-thread
+instead of per-process, "cgroup.threads" has the same format and
+behaves the same way as "cgroup.procs".  While "cgroup.threads" can be
+written to in any cgroup, as it can only move threads inside the same
+threaded domain, its operations are confined inside each threaded
+subtree.
+
+The threaded domain cgroup serves as the resource domain for the whole
+subtree, and, while the threads can be scattered across the subtree,
+all the processes are considered to be in the threaded domain cgroup.
+"cgroup.procs" in a threaded domain cgroup contains the PIDs of all
+processes in the subtree and is not readable in the subtree proper.
+However, "cgroup.procs" can be written to from anywhere in the subtree
+to migrate all threads of the matching process to the cgroup.
+
+Only threaded controllers can be enabled in a threaded subtree.  When
+a threaded controller is enabled inside a threaded subtree, it only
+accounts for and controls resource consumptions associated with the
+threads in the cgroup and its descendants.  All consumptions which
+aren't tied to a specific thread belong to the threaded domain cgroup.
+
+Because a threaded subtree is exempt from no internal process
+constraint, a threaded controller must be able to handle competition
+between threads in a non-leaf cgroup and its child cgroups.  Each
+threaded controller defines how such competitions are handled.
+
+
 [Un]populated Notification
 --------------------------
 
@@ -302,15 +405,15 @@ disabled if one or more children have it enabled.
 No Internal Process Constraint
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-Non-root cgroups can only distribute resources to their children when
-they don't have any processes of their own.  In other words, only
-cgroups which don't contain any processes can have controllers enabled
-in their "cgroup.subtree_control" files.
+Non-root cgroups can distribute domain resources to their children
+only when they don't have any processes of their own.  In other words,
+only domain cgroups which don't contain any processes can have domain
+controllers enabled in their "cgroup.subtree_control" files.
 
-This guarantees that, when a controller is looking at the part of the
-hierarchy which has it enabled, processes are always only on the
-leaves.  This rules out situations where child cgroups compete against
-internal processes of the parent.
+This guarantees that, when a domain controller is looking at the part
+of the hierarchy which has it enabled, processes are always only on
+the leaves.  This rules out situations where child cgroups compete
+against internal processes of the parent.
 
 The root cgroup is exempt from this restriction.  Root contains
 processes and anonymous resource consumption which can't be associated
@@ -334,10 +437,10 @@ Model of Delegation
 ~~~~~~~~~~~~~~~~~~~
 
 A cgroup can be delegated in two ways.  First, to a less privileged
-user by granting write access of the directory and its "cgroup.procs"
-and "cgroup.subtree_control" files to the user.  Second, if the
-"nsdelegate" mount option is set, automatically to a cgroup namespace
-on namespace creation.
+user by granting write access of the directory and its "cgroup.procs",
+"cgroup.threads" and "cgroup.subtree_control" files to the user.
+Second, if the "nsdelegate" mount option is set, automatically to a
+cgroup namespace on namespace creation.
 
 Because the resource control interface files in a given directory
 control the distribution of the parent's resources, the delegatee
@@ -644,6 +747,29 @@ Core Interface Files
 
 All cgroup core files are prefixed with "cgroup."
 
+  cgroup.type
+
+	A read-write single value file which exists on non-root
+	cgroups.
+
+	When read, it indicates the current type of the cgroup, which
+	can be one of the following values.
+
+	- "domain" : A normal valid domain cgroup.
+
+	- "domain threaded" : A threaded domain cgroup which is
+          serving as the root of a threaded subtree.
+
+	- "domain invalid" : A cgroup which is in an invalid state.
+	  It can't be populated or have controllers enabled.  It may
+	  be allowed to become a threaded cgroup.
+
+	- "threaded" : A threaded cgroup which is a member of a
+          threaded subtree.
+
+	A cgroup can be turned into a threaded cgroup by writing
+	"threaded" to this file.
+
   cgroup.procs
 	A read-write new-line separated values file which exists on
 	all cgroups.
@@ -666,6 +792,35 @@ All cgroup core files are prefixed with "cgroup."
 	When delegating a sub-hierarchy, write access to this file
 	should be granted along with the containing directory.
 
+	In a threaded cgroup, reading this file fails with EOPNOTSUPP
+	as all the processes belong to the thread root.  Writing is
+	supported and moves every thread of the process to the cgroup.
+
+  cgroup.threads
+	A read-write new-line separated values file which exists on
+	all cgroups.
+
+	When read, it lists the TIDs of all threads which belong to
+	the cgroup one-per-line.  The TIDs are not ordered and the
+	same TID may show up more than once if the thread got moved to
+	another cgroup and then back or the TID got recycled while
+	reading.
+
+	A TID can be written to migrate the thread associated with the
+	TID to the cgroup.  The writer should match all of the
+	following conditions.
+
+	- It must have write access to the "cgroup.threads" file.
+
+	- The cgroup that the thread is currently in must be in the
+          same resource domain as the destination cgroup.
+
+	- It must have write access to the "cgroup.procs" file of the
+	  common ancestor of the source and destination cgroups.
+
+	When delegating a sub-hierarchy, write access to this file
+	should be granted along with the containing directory.
+
   cgroup.controllers
 	A read-only space separated values file which exists on all
 	cgroups.
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 651c436..9d74195 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -522,6 +522,18 @@ struct cgroup_subsys {
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
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 0e81c61..f10eb19 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -170,7 +170,7 @@ struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
 			       struct cgroup_root *root, unsigned long magic,
 			       struct cgroup_namespace *ns);
 
-bool cgroup_may_migrate_to(struct cgroup *dst_cgrp);
+int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp);
 void cgroup_migrate_finish(struct cgroup_mgctx *mgctx);
 void cgroup_migrate_add_src(struct css_set *src_cset, struct cgroup *dst_cgrp,
 			    struct cgroup_mgctx *mgctx);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 167aaab..f0e8601 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -99,8 +99,9 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 	if (cgroup_on_dfl(to))
 		return -EINVAL;
 
-	if (!cgroup_may_migrate_to(to))
-		return -EBUSY;
+	ret = cgroup_migrate_vet_dst(to);
+	if (ret)
+		return ret;
 
 	mutex_lock(&cgroup_mutex);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a1d59af..c396e70 100644
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
@@ -335,14 +338,93 @@ static bool cgroup_is_threaded(struct cgroup *cgrp)
 	return cgrp->dom_cgrp != cgrp;
 }
 
+/* can @cgrp host both domain and threaded children? */
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
+/* can @cgrp become a thread root? should always be true for a thread root */
+static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
+{
+	/* mixables don't care */
+	if (cgroup_is_mixable(cgrp))
+		return true;
+
+	/* domain roots can't be nested under threaded */
+	if (cgroup_is_threaded(cgrp))
+		return false;
+
+	/* can only have either domain or threaded children */
+	if (cgrp->nr_populated_domain_children)
+		return false;
+
+	/* and no domain controllers can be enabled */
+	if (cgrp->subtree_control & ~cgrp_dfl_threaded_ss_mask)
+		return false;
+
+	return true;
+}
+
+/* is @cgrp root of a threaded subtree? */
+static bool cgroup_is_thread_root(struct cgroup *cgrp)
+{
+	/* thread root should be a domain */
+	if (cgroup_is_threaded(cgrp))
+		return false;
+
+	/* a domain w/ threaded children is a thread root */
+	if (cgrp->nr_threaded_children)
+		return true;
+
+	/*
+	 * A domain which has tasks and explicit threaded controllers
+	 * enabled is a thread root.
+	 */
+	if (cgroup_has_tasks(cgrp) &&
+	    (cgrp->subtree_control & cgrp_dfl_threaded_ss_mask))
+		return true;
+
+	return false;
+}
+
+/* a domain which isn't connected to the root w/o brekage can't be used */
+static bool cgroup_is_valid_domain(struct cgroup *cgrp)
+{
+	/* the cgroup itself can be a thread root */
+	if (cgroup_is_threaded(cgrp))
+		return false;
+
+	/* but the ancestors can't be unless mixable */
+	while ((cgrp = cgroup_parent(cgrp))) {
+		if (!cgroup_is_mixable(cgrp) && cgroup_is_thread_root(cgrp))
+			return false;
+		if (cgroup_is_threaded(cgrp))
+			return false;
+	}
+
+	return true;
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
+		/* threaded cgroups can only have threaded controllers */
+		if (cgroup_is_threaded(cgrp))
+			ss_mask &= cgrp_dfl_threaded_ss_mask;
+		return ss_mask;
+	}
 
 	if (cgroup_on_dfl(cgrp))
 		root_ss_mask &= ~(cgrp_dfl_inhibit_ss_mask |
@@ -355,8 +437,14 @@ static u16 cgroup_ss_mask(struct cgroup *cgrp)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
 
-	if (parent)
-		return parent->subtree_ss_mask;
+	if (parent) {
+		u16 ss_mask = parent->subtree_ss_mask;
+
+		/* threaded cgroups can only have threaded controllers */
+		if (cgroup_is_threaded(cgrp))
+			ss_mask &= cgrp_dfl_threaded_ss_mask;
+		return ss_mask;
+	}
 
 	return cgrp->root->subsys_mask;
 }
@@ -2237,17 +2325,40 @@ static int cgroup_migrate_execute(struct cgroup_mgctx *mgctx)
 }
 
 /**
- * cgroup_may_migrate_to - verify whether a cgroup can be migration destination
+ * cgroup_migrate_vet_dst - verify whether a cgroup can be migration destination
  * @dst_cgrp: destination cgroup to test
  *
- * On the default hierarchy, except for the root, subtree_control must be
- * zero for migration destination cgroups with tasks so that child cgroups
- * don't compete against tasks.
+ * On the default hierarchy, except for the mixable, (possible) thread root
+ * and threaded cgroups, subtree_control must be zero for migration
+ * destination cgroups with tasks so that child cgroups don't compete
+ * against tasks.
  */
-bool cgroup_may_migrate_to(struct cgroup *dst_cgrp)
+int cgroup_migrate_vet_dst(struct cgroup *dst_cgrp)
 {
-	return !cgroup_on_dfl(dst_cgrp) || !cgroup_parent(dst_cgrp) ||
-		!dst_cgrp->subtree_control;
+	/* v1 doesn't have any restriction */
+	if (!cgroup_on_dfl(dst_cgrp))
+		return 0;
+
+	/* verify @dst_cgrp can host resources */
+	if (!cgroup_is_valid_domain(dst_cgrp->dom_cgrp))
+		return -EOPNOTSUPP;
+
+	/* mixables don't care */
+	if (cgroup_is_mixable(dst_cgrp))
+		return 0;
+
+	/*
+	 * If @dst_cgrp is already or can become a thread root or is
+	 * threaded, it doesn't matter.
+	 */
+	if (cgroup_can_be_thread_root(dst_cgrp) || cgroup_is_threaded(dst_cgrp))
+		return 0;
+
+	/* apply no-internal-process constraint */
+	if (dst_cgrp->subtree_control)
+		return -EBUSY;
+
+	return 0;
 }
 
 /**
@@ -2452,8 +2563,9 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
 	struct task_struct *task;
 	int ret;
 
-	if (!cgroup_may_migrate_to(dst_cgrp))
-		return -EBUSY;
+	ret = cgroup_migrate_vet_dst(dst_cgrp);
+	if (ret)
+		return ret;
 
 	/* look up all src csets */
 	spin_lock_irq(&css_set_lock);
@@ -2881,6 +2993,46 @@ static void cgroup_finalize_control(struct cgroup *cgrp, int ret)
 	cgroup_apply_control_disable(cgrp);
 }
 
+static int cgroup_vet_subtree_control_enable(struct cgroup *cgrp, u16 enable)
+{
+	u16 domain_enable = enable & ~cgrp_dfl_threaded_ss_mask;
+
+	/* if nothing is getting enabled, nothing to worry about */
+	if (!enable)
+		return 0;
+
+	/* can @cgrp host any resources? */
+	if (!cgroup_is_valid_domain(cgrp->dom_cgrp))
+		return -EOPNOTSUPP;
+
+	/* mixables don't care */
+	if (cgroup_is_mixable(cgrp))
+		return 0;
+
+	if (domain_enable) {
+		/* can't enable domain controllers inside a thread subtree */
+		if (cgroup_is_thread_root(cgrp) || cgroup_is_threaded(cgrp))
+			return -EOPNOTSUPP;
+	} else {
+		/*
+		 * Threaded controllers can handle internal competitions
+		 * and are always allowed inside a (prospective) thread
+		 * subtree.
+		 */
+		if (cgroup_can_be_thread_root(cgrp) || cgroup_is_threaded(cgrp))
+			return 0;
+	}
+
+	/*
+	 * Controllers can't be enabled for a cgroup with tasks to avoid
+	 * child cgroups competing against tasks.
+	 */
+	if (cgroup_has_tasks(cgrp))
+		return -EBUSY;
+
+	return 0;
+}
+
 /* change the enabled child controllers for a cgroup in the default hierarchy */
 static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 					    char *buf, size_t nbytes,
@@ -2956,14 +3108,9 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	/*
-	 * Except for the root, subtree_control must be zero for a cgroup
-	 * with tasks so that child cgroups don't compete against tasks.
-	 */
-	if (enable && cgroup_parent(cgrp) && cgroup_has_tasks(cgrp)) {
-		ret = -EBUSY;
+	ret = cgroup_vet_subtree_control_enable(cgrp, enable);
+	if (ret)
 		goto out_unlock;
-	}
 
 	/* save and update control masks and prepare csses */
 	cgroup_save_control(cgrp);
@@ -2982,6 +3129,84 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+static int cgroup_enable_threaded(struct cgroup *cgrp)
+{
+	struct cgroup *parent = cgroup_parent(cgrp);
+	struct cgroup *dom_cgrp = parent->dom_cgrp;
+	int ret;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	/* noop if already threaded */
+	if (cgroup_is_threaded(cgrp))
+		return 0;
+
+	/* we're joining the parent's domain, ensure its validity */
+	if (!cgroup_is_valid_domain(dom_cgrp) ||
+	    !cgroup_can_be_thread_root(dom_cgrp))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Allow enabling thread mode only on empty cgroups to avoid
+	 * implicit migrations and recursive operations.
+	 */
+	if (cgroup_has_tasks(cgrp) || css_has_online_children(&cgrp->self))
+		return -EBUSY;
+
+	/*
+	 * The following shouldn't cause actual migrations and should
+	 * always succeed.
+	 */
+	cgroup_save_control(cgrp);
+
+	cgrp->dom_cgrp = dom_cgrp;
+	ret = cgroup_apply_control(cgrp);
+	if (!ret)
+		parent->nr_threaded_children++;
+	else
+		cgrp->dom_cgrp = cgrp;
+
+	cgroup_finalize_control(cgrp, ret);
+	return ret;
+}
+
+static int cgroup_type_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+
+	if (cgroup_is_threaded(cgrp))
+		seq_puts(seq, "threaded\n");
+	else if (!cgroup_is_valid_domain(cgrp))
+		seq_puts(seq, "domain invalid\n");
+	else if (cgroup_is_thread_root(cgrp))
+		seq_puts(seq, "domain threaded\n");
+	else
+		seq_puts(seq, "domain\n");
+
+	return 0;
+}
+
+static ssize_t cgroup_type_write(struct kernfs_open_file *of, char *buf,
+				 size_t nbytes, loff_t off)
+{
+	struct cgroup *cgrp;
+	int ret;
+
+	/* only switching to threaded mode is supported */
+	if (strcmp(strstrip(buf), "threaded"))
+		return -EINVAL;
+
+	cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!cgrp)
+		return -ENOENT;
+
+	/* threaded can only be enabled */
+	ret = cgroup_enable_threaded(cgrp);
+
+	cgroup_kn_unlock(of->kn);
+	return ret ?: nbytes;
+}
+
 static int cgroup_events_show(struct seq_file *seq, void *v)
 {
 	seq_printf(seq, "populated %d\n",
@@ -3867,12 +4092,12 @@ static void *cgroup_procs_next(struct seq_file *s, void *v, loff_t *pos)
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
@@ -3895,6 +4120,23 @@ static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
 	return cgroup_procs_next(s, NULL, NULL);
 }
 
+static void *cgroup_procs_start(struct seq_file *s, loff_t *pos)
+{
+	struct cgroup *cgrp = seq_css(s)->cgroup;
+
+	/*
+	 * All processes of a threaded subtree belong to the domain cgroup
+	 * of the subtree.  Only threads can be distributed across the
+	 * subtree.  Reject reads on cgroup.procs in the subtree proper.
+	 * They're always empty anyway.
+	 */
+	if (cgroup_is_threaded(cgrp))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return __cgroup_procs_start(s, pos, CSS_TASK_ITER_PROCS |
+					    CSS_TASK_ITER_THREADED);
+}
+
 static int cgroup_procs_show(struct seq_file *s, void *v)
 {
 	seq_printf(s, "%d\n", task_pid_vnr(v));
@@ -3974,9 +4216,64 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
+{
+	return __cgroup_procs_start(s, pos, 0);
+}
+
+static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
+{
+	struct cgroup *src_cgrp, *dst_cgrp;
+	struct task_struct *task;
+	ssize_t ret;
+
+	buf = strstrip(buf);
+
+	dst_cgrp = cgroup_kn_lock_live(of->kn, false);
+	if (!dst_cgrp)
+		return -ENODEV;
+
+	task = cgroup_procs_write_start(buf, false);
+	ret = PTR_ERR_OR_ZERO(task);
+	if (ret)
+		goto out_unlock;
+
+	/* find the source cgroup */
+	spin_lock_irq(&css_set_lock);
+	src_cgrp = task_cgroup_from_root(task, &cgrp_dfl_root);
+	spin_unlock_irq(&css_set_lock);
+
+	/* thread migrations follow the cgroup.procs delegation rule */
+	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
+					    of->file->f_path.dentry->d_sb);
+	if (ret)
+		goto out_finish;
+
+	/* and must be contained in the same domain */
+	ret = -EOPNOTSUPP;
+	if (src_cgrp->dom_cgrp != dst_cgrp->dom_cgrp)
+		goto out_finish;
+
+	ret = cgroup_attach_task(dst_cgrp, task, false);
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
+		.name = "cgroup.type",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cgroup_type_show,
+		.write = cgroup_type_write,
+	},
+	{
 		.name = "cgroup.procs",
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.file_offset = offsetof(struct cgroup, procs_file),
@@ -3987,6 +4284,14 @@ static struct cftype cgroup_base_files[] = {
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
@@ -4753,11 +5058,17 @@ int __init cgroup_init(void)
 
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
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index dac46af..787a242 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -352,6 +352,7 @@ static int __init enable_cgroup_debug(char *str)
 {
 	debug_cgrp_subsys.dfl_cftypes = debug_files;
 	debug_cgrp_subsys.implicit_on_dfl = true;
+	debug_cgrp_subsys.threaded = true;
 	return 1;
 }
 __setup("cgroup_debug", enable_cgroup_debug);
diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index 2237201..9829c67 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -345,4 +345,5 @@ struct cgroup_subsys pids_cgrp_subsys = {
 	.free		= pids_free,
 	.legacy_cftypes	= pids_files,
 	.dfl_cftypes	= pids_files,
+	.threaded	= true,
 };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1538df9..ec78247 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11210,5 +11210,6 @@ struct cgroup_subsys perf_event_cgrp_subsys = {
 	 * controller is not mounted on a legacy hierarchy.
 	 */
 	.implicit_on_dfl = true,
+	.threaded	= true,
 };
 #endif /* CONFIG_CGROUP_PERF */
-- 
2.9.3

