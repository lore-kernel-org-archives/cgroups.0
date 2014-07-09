From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 10/12] cpuset: enable onlined cpu/node in effective masks
Date: Wed, 9 Jul 2014 16:49:04 +0800
Message-ID: <53BD0200.9050105@huawei.com>
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

Firstly offline cpu1:

  # echo 0-1 > cpuset.cpus
  # echo 0 > /sys/devices/system/cpu/cpu1/online
  # cat cpuset.cpus
  0-1
  # cat cpuset.effective_cpus
  0

Then online it:

  # echo 1 > /sys/devices/system/cpu/cpu1/online
  # cat cpuset.cpus
  0-1
  # cat cpuset.effective_cpus
  0-1

And cpuset will bring it back to the effective mask.

The implementation is quite straightforward. Instead of calculating the
offlined cpus/mems and do updates, we just set the new effective_mask
to online_mask & congifured_mask.

This is a behavior change for default hierarchy, so legacy hierarchy
won't be affected.

v2:
- make refactoring of cpuset_hotplug_update_tasks() as seperate patch,
  suggested by Tejun.
- make hotplug_update_tasks_insane() use @new_cpus and @new_mems as
  hotplug_update_tasks_sane() does.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 65 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 41822e2..c47cb94 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2080,26 +2080,27 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	}
 }
 
-static void hotplug_update_tasks_legacy(struct cpuset *cs,
-					struct cpumask *off_cpus,
-					nodemask_t *off_mems)
+static void
+hotplug_update_tasks_legacy(struct cpuset *cs,
+			    struct cpumask *new_cpus, nodemask_t *new_mems,
+			    bool cpus_updated, bool mems_updated)
 {
 	bool is_empty;
 
 	mutex_lock(&callback_mutex);
-	cpumask_andnot(cs->cpus_allowed, cs->cpus_allowed, off_cpus);
-	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, off_cpus);
-	nodes_andnot(cs->mems_allowed, cs->mems_allowed, *off_mems);
-	nodes_andnot(cs->effective_mems, cs->effective_mems, *off_mems);
+	cpumask_copy(cs->cpus_allowed, new_cpus);
+	cpumask_copy(cs->effective_cpus, new_cpus);
+	cs->mems_allowed = *new_mems;
+	cs->effective_mems = *new_mems;
 	mutex_unlock(&callback_mutex);
 
 	/*
 	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
 	 * as the tasks will be migratecd to an ancestor.
 	 */
-	if (!cpumask_empty(off_cpus) && !cpumask_empty(cs->cpus_allowed))
+	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
 		update_tasks_cpumask(cs);
-	if (!nodes_empty(*off_mems) && !nodes_empty(cs->mems_allowed))
+	if (mems_updated && !nodes_empty(cs->mems_allowed))
 		update_tasks_nodemask(cs);
 
 	is_empty = cpumask_empty(cs->cpus_allowed) ||
@@ -2118,24 +2119,24 @@ static void hotplug_update_tasks_legacy(struct cpuset *cs,
 	mutex_lock(&cpuset_mutex);
 }
 
-static void hotplug_update_tasks(struct cpuset *cs,
-				 struct cpumask *off_cpus,
-				 nodemask_t *off_mems)
+static void
+hotplug_update_tasks(struct cpuset *cs,
+		     struct cpumask *new_cpus, nodemask_t *new_mems,
+		     bool cpus_updated, bool mems_updated)
 {
+	if (cpumask_empty(new_cpus))
+		cpumask_copy(new_cpus, parent_cs(cs)->effective_cpus);
+	if (nodes_empty(*new_mems))
+		*new_mems = parent_cs(cs)->effective_mems;
+
 	mutex_lock(&callback_mutex);
-	cpumask_andnot(cs->effective_cpus, cs->effective_cpus, off_cpus);
-	if (cpumask_empty(cs->effective_cpus))
-		cpumask_copy(cs->effective_cpus,
-			     parent_cs(cs)->effective_cpus);
-
-	nodes_andnot(cs->effective_mems, cs->effective_mems, *off_mems);
-	if (nodes_empty(cs->effective_mems))
-		cs->effective_mems = parent_cs(cs)->effective_mems;
+	cpumask_copy(cs->effective_cpus, new_cpus);
+	cs->effective_mems = *new_mems;
 	mutex_unlock(&callback_mutex);
 
-	if (!cpumask_empty(off_cpus))
+	if (cpus_updated)
 		update_tasks_cpumask(cs);
-	if (!nodes_empty(*off_mems))
+	if (mems_updated)
 		update_tasks_nodemask(cs);
 }
 
@@ -2149,8 +2150,10 @@ static void hotplug_update_tasks(struct cpuset *cs,
  */
 static void cpuset_hotplug_update_tasks(struct cpuset *cs)
 {
-	static cpumask_t off_cpus;
-	static nodemask_t off_mems;
+	static cpumask_t new_cpus;
+	static nodemask_t new_mems;
+	bool cpus_updated;
+	bool mems_updated;
 retry:
 	wait_event(cpuset_attach_wq, cs->attach_in_progress == 0);
 
@@ -2165,14 +2168,18 @@ retry:
 		goto retry;
 	}
 
-	cpumask_andnot(&off_cpus, cs->effective_cpus,
-		       top_cpuset.effective_cpus);
-	nodes_andnot(off_mems, cs->effective_mems, top_cpuset.effective_mems);
+	cpumask_and(&new_cpus, cs->cpus_allowed, parent_cs(cs)->effective_cpus);
+	nodes_and(new_mems, cs->mems_allowed, parent_cs(cs)->effective_mems);
+
+	cpus_updated = !cpumask_equal(&new_cpus, cs->effective_cpus);
+	mems_updated = !nodes_equal(new_mems, cs->effective_mems);
 
 	if (cgroup_on_dfl(cs->css.cgroup))
-		hotplug_update_tasks(cs, &off_cpus, &off_mems);
+		hotplug_update_tasks(cs, &new_cpus, &new_mems,
+				     cpus_updated, mems_updated);
 	else
-		hotplug_update_tasks_legacy(cs, &off_cpus, &off_mems);
+		hotplug_update_tasks_legacy(cs, &new_cpus, &new_mems,
+					    cpus_updated, mems_updated);
 
 	mutex_unlock(&cpuset_mutex);
 }
-- 
1.8.0.2
