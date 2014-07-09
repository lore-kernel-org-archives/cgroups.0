From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 09/12] cpuset: refactor cpuset_hotplug_update_tasks()
Date: Wed, 9 Jul 2014 16:48:54 +0800
Message-ID: <53BD01F6.9020206@huawei.com>
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

We mix the handling for both default hierarchy and legacy hierarchy in
the same function, and it's quite messy, so split into two functions.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 121 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 55 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4b409d2..41822e2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2080,6 +2080,65 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	}
 }
 
+static void hotplug_update_tasks_legacy(struct cpuset *cs,
+					struct cpumask *off_cpus,
+					nodemask_t *off_mems)
+{
+	bool is_empty;
+
+	mutex_lock(&callback_mutex);
+	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, off_cpus);
+	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, off_cpus);
+	nodes_andnot(cs->mems_allowed, cs->mems_allowed, *off_mems);
+	nodes_andnot(cs->effective_mems, cs->effective_mems, *off_mems);
+	mutex_unlock(&callback_mutex);
+
+	/*
+	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
+	 * as the tasks will be migratecd to an ancestor.
+	 */
+	if (!cpumask_empty(off_cpus) && !cpumask_empty(cs->cpus_allowed))
+		update_tasks_cpumask(cs);
+	if (!nodes_empty(*off_mems) && !nodes_empty(cs->mems_allowed))
+		update_tasks_nodemask(cs);
+
+	is_empty = cpumask_empty(cs->cpus_allowed) ||
+		   nodes_empty(cs->mems_allowed);
+
+	mutex_unlock(&cpuset_mutex);
+
+	/*
+	 * Move tasks to the nearest ancestor with execution resources,
+	 * This is full cgroup operation which will also call back into
+	 * cpuset. Should be done outside any lock.
+	 */
+	if (is_empty)
+		remove_tasks_in_empty_cpuset(cs);
+
+	mutex_lock(&cpuset_mutex);
+}
+
+static void hotplug_update_tasks(struct cpuset *cs,
+				 struct cpumask *off_cpus,
+				 nodemask_t *off_mems)
+{
+	mutex_lock(&callback_mutex);
+	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, off_cpus);
+	if (cpumask_empty(cs->effective_cpus))
+		cpumask_copy(cs->effective_cpus,
+			     parent_cs(cs)->effective_cpus);
+
+	nodes_andnot(cs->effective_mems, cs->effective_mems, *off_mems);
+	if (nodes_empty(cs->effective_mems))
+		cs->effective_mems = parent_cs(cs)->effective_mems;
+	mutex_unlock(&callback_mutex);
+
+	if (!cpumask_empty(off_cpus))
+		update_tasks_cpumask(cs);
+	if (!nodes_empty(*off_mems))
+		update_tasks_nodemask(cs);
+}
+
 /**
  * cpuset_hotplug_update_tasks - update tasks in a cpuset for hotunplug
  * @cs: cpuset in interest
@@ -2092,9 +2151,6 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs)
 {
 	static cpumask_t off_cpus;
 	static nodemask_t off_mems;
-	bool is_empty;
-	bool on_dfl = cgroup_on_dfl(cs->css.cgroup);
-
 retry:
 	wait_event(cpuset_attach_wq, cs->attach_in_progress == 0);
 
@@ -2109,61 +2165,16 @@ retry:
 		goto retry;
 	}
 
-	cpumask_andnot(&off_cpus, cs->cpus_allowed, top_cpuset.cpus_allowed);
-	nodes_andnot(off_mems, cs->mems_allowed, top_cpuset.mems_allowed);
-
-	mutex_lock(&callback_mutex);
-	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, &off_cpus);
-
-	/* Inherit the effective mask of the parent, if it becomes empty. */
-	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, &off_cpus);
-	if (on_dfl && cpumask_empty(cs->effective_cpus))
-		cpumask_copy(cs->effective_cpus, parent_cs(cs)->effective_cpus);
-	mutex_unlock(&callback_mutex);
-
-	/*
-	 * If on_dfl, we need to update tasks' cpumask for empty cpuset to
-	 * take on ancestor's cpumask. Otherwise, don't call
-	 * update_tasks_cpumask() if the cpuset becomes empty, as the tasks
-	 * in it will be migrated to an ancestor.
-	 */
-	if ((on_dfl && cpumask_empty(cs->cpus_allowed)) ||
-	    (!cpumask_empty(&off_cpus) && !cpumask_empty(cs->cpus_allowed)))
-		update_tasks_cpumask(cs);
-
-	mutex_lock(&callback_mutex);
-	nodes_andnot(cs->mems_allowed, cs->mems_allowed, off_mems);
+	cpumask_andnot(&off_cpus, cs->effective_cpus,
+		       top_cpuset.effective_cpus);
+	nodes_andnot(off_mems, cs->effective_mems, top_cpuset.effective_mems);
 
-	/* Inherit the effective mask of the parent, if it becomes empty */
-	nodes_andnot(cs->effective_mems, cs->effective_mems, off_mems);
-	if (on_dfl && nodes_empty(cs->effective_mems))
-		cs->effective_mems = parent_cs(cs)->effective_mems;
-	mutex_unlock(&callback_mutex);
-
-	/*
-	 * If on_dfl, we need to update tasks' nodemask for empty cpuset to
-	 * take on ancestor's nodemask. Otherwise, don't call
-	 * update_tasks_nodemask() if the cpuset becomes empty, as the
-	 * tasks in it will be migratd to an ancestor.
-	 */
-	if ((on_dfl && nodes_empty(cs->mems_allowed)) ||
-	    (!nodes_empty(off_mems) && !nodes_empty(cs->mems_allowed)))
-		update_tasks_nodemask(cs);
-
-	is_empty = cpumask_empty(cs->cpus_allowed) ||
-		nodes_empty(cs->mems_allowed);
+	if (cgroup_on_dfl(cs->css.cgroup))
+		hotplug_update_tasks(cs, &off_cpus, &off_mems);
+	else
+		hotplug_update_tasks_legacy(cs, &off_cpus, &off_mems);
 
 	mutex_unlock(&cpuset_mutex);
-
-	/*
-	 * If on_dfl, we'll keep tasks in empty cpusets.
-	 *
-	 * Otherwise move tasks to the nearest ancestor with execution
-	 * resources.  This is full cgroup operation which will
-	 * also call back into cpuset.  Should be done outside any lock.
-	 */
-	if (!on_dfl && is_empty)
-		remove_tasks_in_empty_cpuset(cs);
 }
 
 /**
-- 
1.8.0.2
