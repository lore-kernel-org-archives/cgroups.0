From: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: [PATCH V2] cpuset: Add knob to make allowed masks hotplug invariant
 on legacy hierarchy
Date: Fri, 10 Apr 2015 19:41:52 +0530
Message-ID: <20150410141118.11284.36206.stgit@preeti.in.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: svaidy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, nacc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, bharata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org

The cpus_allowed and mems_allowed masks of a cpuset get overwritten
after each hotplug operation on the legacy hierarchy of cgroups so as to
remain in sync with the online mask. But there are use cases which
expect user configured masks to remain unchanged.

For instance, when hotplugged out CPUs are brought back online, they
remain idle with none of the existing tasks allowed to run on them since
the cpus_allowed mask was overwritten to not include them when they were
offlined.

We cannot change the legacy hierarchy design now to keep the allowed
masks hotplug invariant since it is a user visible change. It was
suggested instead to add a knob in the root cpuset directory which
allows the user to specify if he wants the user configured masks to be
hotplug invariant [1]. This knob will enforce the choice throughout the
hierarchy. If the knob is set, the allowed maks will not be varied on
hotplug. It is also to to be noted that this knob will appear in the
root cgroup mounted on the legacy hierarchy alone since the default
hierarchy does not overwrite the allowed masks anyway.

Having said this, there are fair reasons to argue that the kernel is not
responsible for taking care of user configurations in the face of
hotplug. But one of the consequences of the current legacy hierarchy
design, is that CPUs are left out from being used at all on online
operations. The reason for this is not very obvious at first and several
users have raised the issue as a bug. Hence the patch was strongly
called for.

Moreover the default hierarchy keeps the allowed masks hotplug invariant
too. So the patch is not bringing about a fundamental change in the
design of cgroups.

[1] https://lkml.org/lkml/2015/4/6/196

Signed-off-by: Preeti U Murthy <preeti-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
Changes from V1: https://lkml.org/lkml/2014/10/8/46
Add a knob to bring about the behavioral change

 kernel/cpuset.c |   67 +++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index fc7f474..b14d15f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -63,6 +63,9 @@
 
 struct static_key cpusets_enabled_key __read_mostly = STATIC_KEY_INIT_FALSE;
 
+/* Knob to request hotplug invariant allowed masks on legacy hierarcy */
+static int cpuset_hotplug_invariant __read_mostly;
+
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -887,8 +890,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
 		cpumask_copy(cp->effective_cpus, new_cpus);
 		spin_unlock_irq(&callback_lock);
 
-		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
-			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
+		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) && !cpuset_hotplug_invariant
+			&& !cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
 		update_tasks_cpumask(cp);
 
@@ -1143,8 +1146,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
 
-		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
-			!nodes_equal(cp->mems_allowed, cp->effective_mems));
+		WARN_ON(!cgroup_on_dfl(cp->css.cgroup) && !cpuset_hotplug_invariant
+			&& !nodes_equal(cp->mems_allowed, cp->effective_mems));
 
 		update_tasks_nodemask(cp);
 
@@ -1429,11 +1432,17 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 
 	mutex_lock(&cpuset_mutex);
 
-	/* allow moving tasks into an empty cpuset if on default hierarchy */
+	/*
+	 * Allow moving tasks into an empty cpuset if on default hierarchy
+	 * Use effective_cpus instead of cpus_allowed to check for empty
+	 * cpusets since these masks are equivalent on legacy hierarchy
+	 * and more importantly will enable cases where cpuset_hotplug_invariant
+	 * is set to fall in place.
+	 */
 	ret = -ENOSPC;
 	if (!cgroup_on_dfl(css->cgroup) &&
-	    (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed)))
-		goto out_unlock;
+	(cpumask_empty(cs->effective_cpus) || nodes_empty(cs->effective_mems)))
+			goto out_unlock;
 
 	cgroup_taskset_for_each(task, tset) {
 		ret = task_can_attach(task, cs->cpus_allowed);
@@ -1551,6 +1560,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_HOTPLUG_INVARIANT,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1594,6 +1604,9 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+	case FILE_HOTPLUG_INVARIANT:
+		cpuset_hotplug_invariant = !!val;
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1752,6 +1765,8 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+	case FILE_HOTPLUG_INVARIANT:
+		return cpuset_hotplug_invariant;
 	default:
 		BUG();
 	}
@@ -1881,6 +1896,14 @@ static struct cftype files[] = {
 		.private = FILE_MEMORY_PRESSURE_ENABLED,
 	},
 
+	{
+		.name = "hotplug_invariant",
+		.flags = CFTYPE_ONLY_ON_ROOT | __CFTYPE_NOT_ON_DFL,
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_HOTPLUG_INVARIANT,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -2096,8 +2119,14 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	 * has online cpus, so can't be empty).
 	 */
 	parent = parent_cs(cs);
-	while (cpumask_empty(parent->cpus_allowed) ||
-			nodes_empty(parent->mems_allowed))
+	/*
+	 * Use effective_cpus instead of cpus_allowed to check for empty
+	 * cpusets since these masks are equivalent on legacy hierarchy
+	 * and more importantly will enable cases where cpuset_hotplug_invariant
+	 * is set to fall in place.
+	 */
+	while (cpumask_empty(parent->effective_cpus) ||
+			nodes_empty(parent->effective_mems))
 		parent = parent_cs(parent);
 
 	if (cgroup_transfer_tasks(parent->css.cgroup, cs->css.cgroup)) {
@@ -2115,23 +2144,27 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 	bool is_empty;
 
 	spin_lock_irq(&callback_lock);
-	cpumask_copy(cs->cpus_allowed, new_cpus);
+	if (!cpuset_hotplug_invariant) {
+		cpumask_copy(cs->cpus_allowed, new_cpus);
+		cs->mems_allowed = *new_mems;
+	}
 	cpumask_copy(cs->effective_cpus, new_cpus);
-	cs->mems_allowed = *new_mems;
 	cs->effective_mems = *new_mems;
 	spin_unlock_irq(&callback_lock);
 
 	/*
 	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
-	 * as the tasks will be migratecd to an ancestor.
+	 * as the tasks will be migrated to an ancestor. Check
+	 * effective_cpus so that cases where cpuset_hotplug_invariant
+	 * is set falls in place.
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
 
@@ -2246,7 +2279,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
 		spin_lock_irq(&callback_lock);
-		if (!on_dfl)
+		if (!on_dfl && !cpuset_hotplug_invariant)
 			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
 		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
 		spin_unlock_irq(&callback_lock);
