From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 03/12] cpuset: update cs->effective_{cpus,mems} when config
 changes
Date: Fri, 11 Oct 2013 17:50:04 +0800
Message-ID: <5257C9CC.3080806@huawei.com>
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

We're going to have separate user-configured masks and effective ones.

Eventually configured masks can only be changed by writing cpuset.cpus
and cpuset.mems, and they won't be restricted by parent cpuset. While
effective masks reflect cpu/memory hotplug and hierachical restriction,
and these are the real masks that apply to the tasks in the cpuset.

We calculate effective mask this way:
  - top cpuset's effective_mask == online_mask, otherwise
  - cpuset's effective_mask == configured_mask & parent effective_mask,
    if the result is empty, it inherits parent effective mask.

Those behavior changes are for sane_behavior only. For !sane_behavior
effective_mask and configured_mask are the same, so we won't break old
interfaces.

To make cs->effective_{cpus,mems} to be effective masks, we need to
  - change the effective masks at hotplug
  - change the effective masks at config change
  - take on ancestor's mask when the effective mask is empty

The second item is done here. We don't need to treat root_cs specially
in update_cpumasks_hier(). While at it, remove the redundant variable
is_load_balanced.

This won't introduce behavior change.

v2:
- revise the comment in update_{cpu,node}masks_hier(), suggested by Tejun.
- fix to use @cp instead of @cs in these two functions.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 115 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 49 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index d0ccde2..bdc6047 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -879,39 +879,49 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 	css_scan_tasks(&cs->css, NULL, cpuset_change_cpumask, cs, heap);
 }
 
-/*
- * update_tasks_cpumask_hier - Update the cpumasks of tasks in the hierarchy.
- * @root_cs: the root cpuset of the hierarchy
- * @update_root: update root cpuset or not?
+/**
+ * update_cpumasks_hier - Update effective cpumasks and tasks in the subtree
+ * @cs: the cpuset to consider
+ * @trialcs: the trial cpuset
  * @heap: the heap used by css_scan_tasks()
  *
- * This will update cpumasks of tasks in @root_cs and all other empty cpusets
- * which take on cpumask of @root_cs.
- *
- * Called with cpuset_mutex held
+ * When configured cpumask is changed, the effective cpumasks of this cpuset
+ * and all its descendants need to be updated.
  */
-static void update_tasks_cpumask_hier(struct cpuset *root_cs,
-				      bool update_root, struct ptr_heap *heap)
+static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
+				 struct ptr_heap *heap)
 {
-	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp;
 
 	rcu_read_lock();
-	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs) {
-			if (!update_root)
-				continue;
-		} else {
-			/* skip the whole subtree if @cp have some CPU */
-			if (!cpumask_empty(cp->cpus_allowed)) {
-				pos_css = css_rightmost_descendant(pos_css);
-				continue;
-			}
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		struct cpuset *parent = parent_cs(cp);
+		struct cpumask *new_cpus = trialcs->effective_cpus;
+
+		cpumask_and(new_cpus, cp->cpus_allowed,
+			    parent->effective_cpus);
+
+		/*
+		 * Skip the whole subtree if the cpumask remains the same
+		 * and isn't empty. If it's empty, we need to update tasks
+		 * to take on an ancestor's cpumask.
+		 */
+		if (cpumask_equal(new_cpus, cp->effective_cpus) &&
+		    ((cp == cs) || !cpumask_empty(new_cpus))) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
 		}
+
 		if (!css_tryget(&cp->css))
 			continue;
+
 		rcu_read_unlock();
 
+		mutex_lock(&callback_mutex);
+		cpumask_copy(cp->effective_cpus, new_cpus);
+		mutex_unlock(&callback_mutex);
+
 		update_tasks_cpumask(cp, heap);
 
 		rcu_read_lock();
@@ -930,7 +940,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 {
 	struct ptr_heap heap;
 	int retval;
-	int is_load_balanced;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_mask; it's read-only */
 	if (cs == &top_cpuset)
@@ -965,17 +974,15 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval)
 		return retval;
 
-	is_load_balanced = is_sched_load_balance(trialcs);
-
 	mutex_lock(&callback_mutex);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
-	update_tasks_cpumask_hier(cs, true, &heap);
+	update_cpumasks_hier(cs, trialcs, &heap);
 
 	heap_free(&heap);
 
-	if (is_load_balanced)
+	if (is_sched_load_balance(cs))
 		rebuild_sched_domains_locked();
 	return 0;
 }
@@ -1136,40 +1143,50 @@ static void update_tasks_nodemask(struct cpuset *cs, struct ptr_heap *heap)
 	cpuset_being_rebound = NULL;
 }
 
-/*
- * update_tasks_nodemask_hier - Update the nodemasks of tasks in the hierarchy.
- * @cs: the root cpuset of the hierarchy
- * @update_root: update the root cpuset or not?
+/**
+ * update_nodesmasks_hier - Update effective nodemasks and tasks in the subtree
+ * @cs: the cpuset to consider
+ * @trialcs: the trial cpuset
  * @heap: the heap used by css_scan_tasks()
  *
- * This will update nodemasks of tasks in @root_cs and all other empty cpusets
- * which take on nodemask of @root_cs.
- *
- * Called with cpuset_mutex held
+ * When configured nodemask is changed, the effective nodemasks of this cpuset
+ * and all its descendants need to be updated.
  */
-static void update_tasks_nodemask_hier(struct cpuset *root_cs,
-				       bool update_root, struct ptr_heap *heap)
+static void update_nodemasks_hier(struct cpuset *cs, struct cpuset *trialcs,
+				 struct ptr_heap *heap)
 {
-	struct cpuset *cp;
 	struct cgroup_subsys_state *pos_css;
+	struct cpuset *cp;
 
 	rcu_read_lock();
-	cpuset_for_each_descendant_pre(cp, pos_css, root_cs) {
-		if (cp == root_cs) {
-			if (!update_root)
-				continue;
-		} else {
-			/* skip the whole subtree if @cp have some CPU */
-			if (!nodes_empty(cp->mems_allowed)) {
-				pos_css = css_rightmost_descendant(pos_css);
-				continue;
-			}
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		struct cpuset *parent = parent_cs(cp);
+		nodemask_t *new_mems = &trialcs->effective_mems;
+
+		nodes_and(*new_mems, cp->mems_allowed,
+			  parent->effective_mems);
+
+		/*
+		 * Skip the whole subtree if the nodemask remains the same
+		 * and isn't empty. If it's empty, we need to update tasks
+		 * to take on an ancestor's nodemask.
+		 */
+		if (nodes_equal(*new_mems, cp->effective_mems) &&
+		    ((cp == cs) || !nodes_empty(*new_mems))) {
+			pos_css = css_rightmost_descendant(pos_css);
+			continue;
 		}
+
 		if (!css_tryget(&cp->css))
 			continue;
+
 		rcu_read_unlock();
 
-		update_tasks_nodemask(cp, heap);
+		mutex_lock(&callback_mutex);
+		cp->effective_mems = *new_mems;
+		mutex_unlock(&callback_mutex);
+
+		update_tasks_cpumask(cp, heap);
 
 		rcu_read_lock();
 		css_put(&cp->css);
@@ -1241,7 +1258,7 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	cs->mems_allowed = trialcs->mems_allowed;
 	mutex_unlock(&callback_mutex);
 
-	update_tasks_nodemask_hier(cs, true, &heap);
+	update_nodemasks_hier(cs, trialcs, &heap);
 
 	heap_free(&heap);
 done:
-- 
1.8.0.2
