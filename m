From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks hotplug
 invariant
Date: Wed, 08 Oct 2014 12:37:40 +0530
Message-ID: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There are two masks associated with cpusets. The cpus/mems_allowed
and effective_cpus/mems. On the legacy hierarchy both these masks
are consistent with each other. This is the intersection of their
value and the currently active cpus. This means that we destroy the
original values set in these masks on each cpu/mem hot unplug operation.
	As a consequence when we hot plug back the cpus/mems, the tasks
no longer run on them and performance degrades, inspite of having
resources to run on.

This effect is not seen in the default hierarchy since the
allowed and effective masks are distinctly maintained.
allowed masks are never touched once configured and effective masks
alone are hotplug variant.

This patch replicates the above design even for the legacy hierarchy,
so that:

1. Tasks always run on the cpus/memory nodes that they are allowed to run on
as long as they are online. The allowed masks are hotplug invariant.

2. When all cpus/memory nodes in a cpuset are hot unplugged out, the tasks
are moved to their nearest ancestor which has resources to run on.

There were discussions earlier around this issue:
https://lkml.org/lkml/2012/5/4/265
http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1252133

The argument against making the allowed masks hotplug invariant was that
hotplug is destructive and hence cpusets cannot expect to regain resources
that have gone through a hotplug operation by the user.

But on powerpc we do smt mode switch to suit the workload running.
We therefore need to keep track of the original cpuset configuration
so as to make use of them when they are back online due to a mode switch.
Moreover there is no real harm in keeping the allowed masks invariant
on hotplug since the effective masks will anyway keep track of the
online cpus. In fact there are use cases which need the cpuset's
original configuration to be retained. The v2 of cgroup design therefore
does not overwrite this configuration.

Till the time the controllers switch to the default hierarchy it serves
well to fix this problem in the legacy hierarchy. While at it fix a comment
which assumes that cpuset masks are changed only during a hot-unplug operation.
With this patch it is ensured that cpuset masks are consistent with online cpus
in both default and legacy hierarchy.

Signed-off-by: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---

 kernel/cpuset.c |   38 ++++++++++----------------------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 22874d7..89c2e60 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -78,8 +78,6 @@ struct cpuset {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
 	/*
-	 * On default hierarchy:
-	 *
 	 * The user-configured masks can only be changed by writing to
 	 * cpuset.cpus and cpuset.mems, and won't be limited by the
 	 * parent masks.
@@ -91,10 +89,6 @@ struct cpuset {
 	 * effective_mask == configured_mask & parent's effective_mask,
 	 * and if it ends up empty, it will inherit the parent's mask.
 	 *
-	 *
-	 * On legacy hierachy:
-	 *
-	 * The user-configured masks are always the same with effective masks.
 	 */
 
 	/* user-configured CPUs and Memory Nodes allow to tasks */
@@ -842,8 +836,6 @@ static void update_tasks_cpumask(struct cpuset *cs)
  * When congifured cpumask is changed, the effective cpumasks of this cpuset
  * and all its descendants need to be updated.
  *
- * On legacy hierachy, effective_cpus will be the same with cpu_allowed.
- *
  * Called with cpuset_mutex held
  */
 static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
@@ -879,9 +871,6 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		cpumask_copy(cp->effective_cpus, new_cpus);
 		mutex_unlock(&callback_mutex);
 
-		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
-			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
-
 		update_tasks_cpumask(cp);
 
 		/*
@@ -1424,7 +1413,7 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 	/* allow moving tasks into an empty cpuset if on default hierarchy */
 	ret = -ENOSPC;
 	if (!cgroup_on_dfl(css->cgroup) &&
-	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
+	    (cpumask_empty(cs->effective_cpus) || nodes_empty(cs->effective_mems)))
 		goto out_unlock;
 
 	cgroup_taskset_for_each(task, tset) {
@@ -2108,8 +2097,8 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	 * has online cpus, so can't be empty).
 	 */
 	parent = parent_cs(cs);
-	while (cpumask_empty(parent->cpus_allowed) ||
-			nodes_empty(parent->mems_allowed))
+	while (cpumask_empty(parent->effective_cpus) ||
+			nodes_empty(parent->effective_mems))
 		parent = parent_cs(parent);
 
 	if (cgroup_transfer_tasks(parent->css.cgroup, cs->css.cgroup)) {
@@ -2127,9 +2116,7 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	bool is_empty;
 
 	mutex_lock(&callback_mutex);
-	cpumask_copy(cs->cpus_allowed, new_cpus);
 	cpumask_copy(cs->effective_cpus, new_cpus);
-	cs->mems_allowed = *new_mems;
 	cs->effective_mems = *new_mems;
 	mutex_unlock(&callback_mutex);
 
@@ -2137,13 +2124,13 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
 	 * as the tasks will be migratecd to an ancestor.
 	 */
-	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
+	if (cpus_updated && !cpumask_empty(cs->effective_cpus))
 		update_tasks_cpumask(cs);
-	if (mems_updated && !nodes_empty(cs->mems_allowed))
+	if (mems_updated && !nodes_empty(cs->effective_mems))
 		update_tasks_nodemask(cs);
 
-	is_empty = cpumask_empty(cs->cpus_allowed) ||
-		   nodes_empty(cs->mems_allowed);
+	is_empty = cpumask_empty(cs->effective_cpus) ||
+		   nodes_empty(cs->effective_mems);
 
 	mutex_unlock(&cpuset_mutex);
 
@@ -2180,11 +2167,11 @@ hotplug_update_tasks(struct cpuset *cs,
 }
 
 /**
- * cpuset_hotplug_update_tasks - update tasks in a cpuset for hotunplug
+ * cpuset_hotplug_update_tasks - update tasks in a cpuset for hotplug
  * @cs: cpuset in interest
  *
- * Compare @cs's cpu and mem masks against top_cpuset and if some have gone
- * offline, update @cs accordingly.  If @cs ends up with no CPU or memory,
+ * Compare @cs's cpu and mem masks against top_cpuset and update @cs
+ * accordingly.  If @cs ends up with no CPU or memory,
  * all its tasks are moved to the nearest ancestor with both resources.
  */
 static void cpuset_hotplug_update_tasks(struct cpuset *cs)
@@ -2244,7 +2231,6 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
-	bool on_dfl = cgroup_on_dfl(top_cpuset.css.cgroup);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -2258,8 +2244,6 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
 		mutex_lock(&callback_mutex);
-		if (!on_dfl)
-			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
 		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
 		mutex_unlock(&callback_mutex);
 		/* we don't mess with cpumasks of tasks in top_cpuset */
@@ -2268,8 +2252,6 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* synchronize mems_allowed to N_MEMORY */
 	if (mems_updated) {
 		mutex_lock(&callback_mutex);
-		if (!on_dfl)
-			top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset);
