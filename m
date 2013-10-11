From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 08/12] cpuset: make cs->{cpus,mems}_allowed as user-configured
 masks
Date: Fri, 11 Oct 2013 17:51:18 +0800
Message-ID: <5257CA16.2060008@huawei.com>
References: <5257C9A1.1030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

Now we've used effective cpumasks to enforce hierarchical manner,
we can use cs->{cpus,mems}_allowed as configured masks.

Configured masks can be changed by writing cpuset.cpus and cpuset.mems
only. The new behaviors are:

- They won't be changed by hotplug anymore.
- They won't be limited by its parent's masks.

This ia a behavior change, but won't take effect unless mount with
sane_behavior.

v2:
- Add comments to explain the differences between configured masks and
effective masks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 040ec59..e47115e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -82,6 +82,26 @@ struct cpuset {
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
+	/*
+	 * If sane_behavior is set:
+	 *
+	 * The user-configured masks can only be changed by writing to
+	 * cpuset.cpus and cpuset.mems, and won't be limited by the
+	 * parent masks.
+	 *
+	 * The effective masks is the real masks that apply to the tasks
+	 * in the cpuset. They may be changed if the configured masks are
+	 * changed or hotplug happens.
+	 *
+	 * effective_mask == configured_mask & parent's effective_mask,
+	 * and if it ends up empty, it will inherit the parent's mask.
+	 *
+	 *
+	 * If sane_behavior is not set:
+	 *
+	 * The user-configured masks are always the same with effective masks.
+	 */
+
 	/* user-configured CPUs and Memory Nodes allow to tasks */
 	cpumask_var_t cpus_allowed;
 	nodemask_t mems_allowed;
@@ -455,9 +475,13 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
-	/* We must be a subset of our parent cpuset */
+	/*
+	 * We must be a subset of our parent cpuset, unless sane_behavior
+	 * flag is set.
+	 */
 	ret = -EACCES;
-	if (!is_cpuset_subset(trial, par))
+	if (!cgroup_sane_behavior(cur->css.cgroup) &&
+	    !is_cpuset_subset(trial, par))
 		goto out;
 
 	/*
@@ -779,7 +803,7 @@ static void rebuild_sched_domains_locked(void)
 	 * passing doms with offlined cpu to partition_sched_domains().
 	 * Anyways, hotplug work item will rebuild sched domains.
 	 */
-	if (!cpumask_equal(top_cpuset.cpus_allowed, cpu_active_mask))
+	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
 		goto out;
 
 	/* Generate domain masks and attrs */
@@ -2191,11 +2215,12 @@ retry:
 		goto retry;
 	}
 
-	cpumask_andnot(&off_cpus, cs->cpus_allowed, top_cpuset.cpus_allowed);
-	nodes_andnot(off_mems, cs->mems_allowed, top_cpuset.mems_allowed);
+	cpumask_andnot(&off_cpus, cs->effective_cpus, top_cpuset.effective_cpus);
+	nodes_andnot(off_mems, cs->effective_mems, top_cpuset.effective_mems);
 
 	mutex_lock(&callback_mutex);
-	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
+	if (!sane)
+		cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
 
 	/* Inherit the effective mask of the parent, if it becomes empty. */
 	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, &off_cpus);
@@ -2214,7 +2239,8 @@ retry:
 		update_tasks_cpumask(cs, NULL);
 
 	mutex_lock(&callback_mutex);
-	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+	if (!sane)
+		nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
 
 	/* Inherit the effective mask of the parent, if it becomes empty */
 	nodes_andnot(cs->effective_mems, cs->effective_mems, off_mems);
@@ -2269,6 +2295,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
+	bool sane = cgroup_sane_behavior(top_cpuset.css.cgroup);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -2276,13 +2303,14 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	cpumask_copy(&new_cpus, cpu_active_mask);
 	new_mems = node_states[N_MEMORY];
 
-	cpus_updated = !cpumask_equal(top_cpuset.cpus_allowed, &new_cpus);
-	mems_updated = !nodes_equal(top_cpuset.mems_allowed, new_mems);
+	cpus_updated = !cpumask_equal(top_cpuset.effective_cpus, &new_cpus);
+	mems_updated = !nodes_equal(top_cpuset.effective_mems, new_mems);
 
 	/* synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
 		mutex_lock(&callback_mutex);
-		cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
+		if (!sane)
+			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
 		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
 		mutex_unlock(&callback_mutex);
 		/* we don't mess with cpumasks of tasks in top_cpuset */
@@ -2291,7 +2319,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* synchronize mems_allowed to N_MEMORY */
 	if (mems_updated) {
 		mutex_lock(&callback_mutex);
-		top_cpuset.mems_allowed = new_mems;
+		if (!sane)
+			top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset, NULL);
-- 
1.8.0.2
