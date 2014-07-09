From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 08/12] cpuset: make cs->{cpus,mems}_allowed as user-configured
 masks
Date: Wed, 9 Jul 2014 16:48:42 +0800
Message-ID: <53BD01EA.50707@huawei.com>
References: <53BD0174.4060002@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BD0174.4060002@huawei.com>
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
 kernel/cpuset.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 820870a..4b409d2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -77,6 +77,26 @@ struct cpuset {
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
+	/*
+	 * On default hierarchy:
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
+	 * On legacy hierachy:
+	 *
+	 * The user-configured masks are always the same with effective masks.
+	 */
+
 	/* user-configured CPUs and Memory Nodes allow to tasks */
 	cpumask_var_t cpus_allowed;
 	nodemask_t mems_allowed;
@@ -450,9 +470,9 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	par = parent_cs(cur);
 
-	/* We must be a subset of our parent cpuset */
+	/* On legacy hiearchy, we must be a subset of our parent cpuset. */
 	ret = -EACCES;
-	if (!is_cpuset_subset(trial, par))
+	if (!cgroup_on_dfl(cur->css.cgroup) && !is_cpuset_subset(trial, par))
 		goto out;
 
 	/*
@@ -2167,6 +2187,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
+	bool on_dfl = cgroup_on_dfl(top_cpuset.css.cgroup);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -2174,13 +2195,14 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
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
+		if (!on_dfl)
+			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
 		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
 		mutex_unlock(&callback_mutex);
 		/* we don't mess with cpumasks of tasks in top_cpuset */
@@ -2189,7 +2211,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* synchronize mems_allowed to N_MEMORY */
 	if (mems_updated) {
 		mutex_lock(&callback_mutex);
-		top_cpuset.mems_allowed = new_mems;
+		if (!on_dfl)
+			top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
 		mutex_unlock(&callback_mutex);
 		update_tasks_nodemask(&top_cpuset);
-- 
1.8.0.2
