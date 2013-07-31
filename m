From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 7/7] cgroup: more naming cleanups
Date: Wed, 31 Jul 2013 16:18:36 +0800
Message-ID: <51F8C85C.1050206@huawei.com>
References: <51F8C7C5.9040608@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Constantly use @cset for css_set varabbles and use @cgrp as cgroup
variables.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  6 +++---
 kernel/cgroup.c        | 26 +++++++++++++-------------
 kernel/cpuset.c        | 16 ++++++++--------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c07e175..ee048ba 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -400,8 +400,8 @@ struct cgroup_map_cb {
 
 /* cftype->flags */
 enum {
-	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cg */
-	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cg */
+	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cgrp */
+	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cgrp */
 	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
 };
 
@@ -519,7 +519,7 @@ struct cftype_set {
 };
 
 struct cgroup_scanner {
-	struct cgroup *cg;
+	struct cgroup *cgrp;
 	int (*test_task)(struct task_struct *p, struct cgroup_scanner *scan);
 	void (*process_task)(struct task_struct *p,
 			struct cgroup_scanner *scan);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 89d63b0..3729f43 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -431,7 +431,7 @@ static inline void put_css_set_taskexit(struct css_set *cset)
  * @new_cgrp: cgroup that's being entered by the task
  * @template: desired set of css pointers in css_set (pre-calculated)
  *
- * Returns true if "cg" matches "old_cg" except for the hierarchy
+ * Returns true if "cset" matches "old_cset" except for the hierarchy
  * which "new_cgrp" belongs to, for which it should match "new_cgrp".
  */
 static bool compare_css_sets(struct css_set *cset,
@@ -1804,7 +1804,7 @@ EXPORT_SYMBOL_GPL(task_cgroup_path_from_hierarchy);
 struct task_and_cgroup {
 	struct task_struct	*task;
 	struct cgroup		*cgrp;
-	struct css_set		*cg;
+	struct css_set		*cset;
 };
 
 struct cgroup_taskset {
@@ -2022,8 +2022,8 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 
 		tc = flex_array_get(group, i);
 		old_cset = task_css_set(tc->task);
-		tc->cg = find_css_set(old_cset, cgrp);
-		if (!tc->cg) {
+		tc->cset = find_css_set(old_cset, cgrp);
+		if (!tc->cset) {
 			retval = -ENOMEM;
 			goto out_put_css_set_refs;
 		}
@@ -2036,7 +2036,7 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
 	 */
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
-		cgroup_task_migrate(tc->cgrp, tc->task, tc->cg);
+		cgroup_task_migrate(tc->cgrp, tc->task, tc->cset);
 	}
 	/* nothing is sensitive to fork() after this point. */
 
@@ -2056,9 +2056,9 @@ out_put_css_set_refs:
 	if (retval) {
 		for (i = 0; i < group_size; i++) {
 			tc = flex_array_get(group, i);
-			if (!tc->cg)
+			if (!tc->cset)
 				break;
-			put_css_set(tc->cg);
+			put_css_set(tc->cset);
 		}
 	}
 out_cancel_attach:
@@ -2168,9 +2168,9 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 
 	mutex_lock(&cgroup_mutex);
 	for_each_active_root(root) {
-		struct cgroup *from_cg = task_cgroup_from_root(from, root);
+		struct cgroup *from_cgrp = task_cgroup_from_root(from, root);
 
-		retval = cgroup_attach_task(from_cg, tsk, false);
+		retval = cgroup_attach_task(from_cgrp, tsk, false);
 		if (retval)
 			break;
 	}
@@ -3275,8 +3275,8 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
 	 * guarantees forward progress and that we don't miss any tasks.
 	 */
 	heap->size = 0;
-	cgroup_iter_start(scan->cg, &it);
-	while ((p = cgroup_iter_next(scan->cg, &it))) {
+	cgroup_iter_start(scan->cgrp, &it);
+	while ((p = cgroup_iter_next(scan->cgrp, &it))) {
 		/*
 		 * Only affect tasks that qualify per the caller's callback,
 		 * if he provided one
@@ -3309,7 +3309,7 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
 		 * the heap and wasn't inserted
 		 */
 	}
-	cgroup_iter_end(scan->cg, &it);
+	cgroup_iter_end(scan->cgrp, &it);
 
 	if (heap->size) {
 		for (i = 0; i < heap->size; i++) {
@@ -3355,7 +3355,7 @@ int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 {
 	struct cgroup_scanner scan;
 
-	scan.cg = from;
+	scan.cgrp = from;
 	scan.test_task = NULL; /* select all tasks in cgroup */
 	scan.process_task = cgroup_transfer_one_task;
 	scan.heap = NULL;
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e565778..299cd71 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -846,7 +846,7 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
 {
 	struct cpuset *cpus_cs;
 
-	cpus_cs = effective_cpumask_cpuset(cgroup_cs(scan->cg));
+	cpus_cs = effective_cpumask_cpuset(cgroup_cs(scan->cgrp));
 	set_cpus_allowed_ptr(tsk, cpus_cs->cpus_allowed);
 }
 
@@ -867,7 +867,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
 {
 	struct cgroup_scanner scan;
 
-	scan.cg = cs->css.cgroup;
+	scan.cgrp = cs->css.cgroup;
 	scan.test_task = NULL;
 	scan.process_task = cpuset_change_cpumask;
 	scan.heap = heap;
@@ -1063,7 +1063,7 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 static void cpuset_change_nodemask(struct task_struct *p,
 				   struct cgroup_scanner *scan)
 {
-	struct cpuset *cs = cgroup_cs(scan->cg);
+	struct cpuset *cs = cgroup_cs(scan->cgrp);
 	struct mm_struct *mm;
 	int migrate;
 	nodemask_t *newmems = scan->data;
@@ -1103,7 +1103,7 @@ static void update_tasks_nodemask(struct cpuset *cs, struct ptr_heap *heap)
 
 	guarantee_online_mems(mems_cs, &newmems);
 
-	scan.cg = cs->css.cgroup;
+	scan.cgrp = cs->css.cgroup;
 	scan.test_task = NULL;
 	scan.process_task = cpuset_change_nodemask;
 	scan.heap = heap;
@@ -1276,7 +1276,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 static void cpuset_change_flag(struct task_struct *tsk,
 				struct cgroup_scanner *scan)
 {
-	cpuset_update_task_spread_flag(cgroup_cs(scan->cg), tsk);
+	cpuset_update_task_spread_flag(cgroup_cs(scan->cgrp), tsk);
 }
 
 /*
@@ -1296,7 +1296,7 @@ static void update_tasks_flags(struct cpuset *cs, struct ptr_heap *heap)
 {
 	struct cgroup_scanner scan;
 
-	scan.cg = cs->css.cgroup;
+	scan.cgrp = cs->css.cgroup;
 	scan.test_task = NULL;
 	scan.process_task = cpuset_change_flag;
 	scan.heap = heap;
@@ -1972,7 +1972,7 @@ static int cpuset_css_online(struct cgroup *cgrp)
 	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset *parent = parent_cs(cs);
 	struct cpuset *tmp_cs;
-	struct cgroup *pos_cg;
+	struct cgroup *pos_cgrp;
 
 	if (!parent)
 		return 0;
@@ -2004,7 +2004,7 @@ static int cpuset_css_online(struct cgroup *cgrp)
 	 * (and likewise for mems) to the new cgroup.
 	 */
 	rcu_read_lock();
-	cpuset_for_each_child(tmp_cs, pos_cg, parent) {
+	cpuset_for_each_child(tmp_cs, pos_cgrp, parent) {
 		if (is_mem_exclusive(tmp_cs) || is_cpu_exclusive(tmp_cs)) {
 			rcu_read_unlock();
 			goto out_unlock;
-- 
1.8.0.2
