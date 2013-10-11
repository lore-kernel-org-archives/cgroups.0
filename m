From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 07/12] cpuset: apply cs->effective_{cpus,mems}
Date: Fri, 11 Oct 2013 17:51:05 +0800
Message-ID: <5257CA09.3050108@huawei.com>
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

Now we can use cs->effective_{cpus,mems} as effective masks. It's
used whenever:

- we update tasks' cpus_allowed/mems_allowed,
- we want to retrieve tasks_cs(tsk)'s cpus_allowed/mems_allowed.

They actually replace effective_{cpu,node}mask_cpuset().

effective_mask == configured_mask & parent effective_mask except when
the reault is empty, in which case it inherits parent effective_mask.
The result equals the mask computed from effective_{cpu,node}mask_cpuset().

This won't affect the original !sane_bevior, because in this case we
make sure the effective masks are always the same with user-configured
masks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 83 ++++++++++-----------------------------------------------
 1 file changed, 14 insertions(+), 69 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5c53ba5..040ec59 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -318,9 +318,9 @@ static struct file_system_type cpuset_fs_type = {
  */
 static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
 {
-	while (!cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
+	while (!cpumask_intersects(cs->effective_cpus, cpu_online_mask))
 		cs = parent_cs(cs);
-	cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
+	cpumask_and(pmask, cs->effective_cpus, cpu_online_mask);
 }
 
 /*
@@ -336,9 +336,9 @@ static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
-	while (!nodes_intersects(cs->mems_allowed, node_states[N_MEMORY]))
+	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
-	nodes_and(*pmask, cs->mems_allowed, node_states[N_MEMORY]);
+	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
 }
 
 /*
@@ -803,45 +803,6 @@ void rebuild_sched_domains(void)
 	mutex_unlock(&cpuset_mutex);
 }
 
-/*
- * effective_cpumask_cpuset - return nearest ancestor with non-empty cpus
- * @cs: the cpuset in interest
- *
- * A cpuset's effective cpumask is the cpumask of the nearest ancestor
- * with non-empty cpus. We use effective cpumask whenever:
- * - we update tasks' cpus_allowed. (they take on the ancestor's cpumask
- *   if the cpuset they reside in has no cpus)
- * - we want to retrieve task_cs(tsk)'s cpus_allowed.
- *
- * Called with cpuset_mutex held. cpuset_cpus_allowed_fallback() is an
- * exception. See comments there.
- */
-static struct cpuset *effective_cpumask_cpuset(struct cpuset *cs)
-{
-	while (cpumask_empty(cs->cpus_allowed))
-		cs = parent_cs(cs);
-	return cs;
-}
-
-/*
- * effective_nodemask_cpuset - return nearest ancestor with non-empty mems
- * @cs: the cpuset in interest
- *
- * A cpuset's effective nodemask is the nodemask of the nearest ancestor
- * with non-empty memss. We use effective nodemask whenever:
- * - we update tasks' mems_allowed. (they take on the ancestor's nodemask
- *   if the cpuset they reside in has no mems)
- * - we want to retrieve task_cs(tsk)'s mems_allowed.
- *
- * Called with cpuset_mutex held.
- */
-static struct cpuset *effective_nodemask_cpuset(struct cpuset *cs)
-{
-	while (nodes_empty(cs->mems_allowed))
-		cs = parent_cs(cs);
-	return cs;
-}
-
 /**
  * cpuset_change_cpumask - make a task's cpus_allowed the same as its cpuset's
  * @tsk: task to test
@@ -856,9 +817,8 @@ static struct cpuset *effective_nodemask_cpuset(struct cpuset *cs)
 static void cpuset_change_cpumask(struct task_struct *tsk, void *data)
 {
 	struct cpuset *cs = data;
-	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
 
-	set_cpus_allowed_ptr(tsk, cpus_cs->cpus_allowed);
+	set_cpus_allowed_ptr(tsk, cs->effective_cpus);
 }
 
 /**
@@ -1026,14 +986,12 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 							const nodemask_t *to)
 {
 	struct task_struct *tsk = current;
-	struct cpuset *mems_cs;
 
 	tsk->mems_allowed = *to;
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
-	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
-	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	guarantee_online_mems(task_cs(tsk), &tsk->mems_allowed);
 }
 
 /*
@@ -1128,13 +1086,12 @@ static void *cpuset_being_rebound;
 static void update_tasks_nodemask(struct cpuset *cs, struct ptr_heap *heap)
 {
 	static nodemask_t newmems;	/* protected by cpuset_mutex */
-	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 	struct cpuset_change_nodemask_arg arg = { .cs = cs,
 						  .newmems = &newmems };
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
-	guarantee_online_mems(mems_cs, &newmems);
+	guarantee_online_mems(cs, &newmems);
 
 	/*
 	 * The mpol_rebind_mm() call takes mmap_sem, which we couldn't
@@ -1572,8 +1529,6 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 							cpuset_subsys_id);
 	struct cpuset *cs = css_cs(css);
 	struct cpuset *oldcs = css_cs(oldcss);
-	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
-	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -1581,9 +1536,9 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	if (cs == &top_cpuset)
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	else
-		guarantee_online_cpus(cpus_cs, cpus_attach);
+		guarantee_online_cpus(cs, cpus_attach);
 
-	guarantee_online_mems(mems_cs, &cpuset_attach_nodemask_to);
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
 	cgroup_taskset_for_each(task, css, tset) {
 		/*
@@ -1600,11 +1555,9 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	 * Change mm, possibly for multiple threads in a threadgroup. This is
 	 * expensive and may sleep.
 	 */
-	cpuset_attach_nodemask_to = cs->mems_allowed;
+	cpuset_attach_nodemask_to = cs->effective_mems;
 	mm = get_task_mm(leader);
 	if (mm) {
-		struct cpuset *mems_oldcs = effective_nodemask_cpuset(oldcs);
-
 		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);
 
 		/*
@@ -1615,7 +1568,7 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 		 * mm from.
 		 */
 		if (is_memory_migrate(cs)) {
-			cpuset_migrate_mm(mm, &mems_oldcs->old_mems_allowed,
+			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
 					  &cpuset_attach_nodemask_to);
 		}
 		mmput(mm);
@@ -2433,23 +2386,17 @@ void __init cpuset_init_smp(void)
 
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
-	struct cpuset *cpus_cs;
-
 	mutex_lock(&callback_mutex);
 	task_lock(tsk);
-	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
-	guarantee_online_cpus(cpus_cs, pmask);
+	guarantee_online_cpus(task_cs(tsk), pmask);
 	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 }
 
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
-	struct cpuset *cpus_cs;
-
 	rcu_read_lock();
-	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
-	do_set_cpus_allowed(tsk, cpus_cs->cpus_allowed);
+	do_set_cpus_allowed(tsk, task_cs(tsk)->effective_cpus);
 	rcu_read_unlock();
 
 	/*
@@ -2488,13 +2435,11 @@ void cpuset_init_current_mems_allowed(void)
 
 nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
 {
-	struct cpuset *mems_cs;
 	nodemask_t mask;
 
 	mutex_lock(&callback_mutex);
 	task_lock(tsk);
-	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
-	guarantee_online_mems(mems_cs, &mask);
+	guarantee_online_mems(task_cs(tsk), &mask);
 	task_unlock(tsk);
 	mutex_unlock(&callback_mutex);
 
-- 
1.8.0.2
