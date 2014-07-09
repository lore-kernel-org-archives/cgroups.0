From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 07/12] cpuset: apply cs->effective_{cpus,mems}
Date: Wed, 9 Jul 2014 16:48:32 +0800
Message-ID: <53BD01E0.8090903@huawei.com>
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

Now we can use cs->effective_{cpus,mems} as effective masks. It's
used whenever:

- we update tasks' cpus_allowed/mems_allowed,
- we want to retrieve tasks_cs(tsk)'s cpus_allowed/mems_allowed.

They actually replace effective_{cpu,node}mask_cpuset().

effective_mask == configured_mask & parent effective_mask except when
the reault is empty, in which case it inherits parent effective_mask.
The result equals the mask computed from effective_{cpu,node}mask_cpuset().

This won't affect the original legacy hierarchy, because in this case we
make sure the effective masks are always the same with user-configured
masks.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 83 ++++++++++-----------------------------------------------
 1 file changed, 14 insertions(+), 69 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index e4c31e6..820870a 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -313,9 +313,9 @@ static struct file_system_type cpuset_fs_type = {
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
@@ -331,9 +331,9 @@ static void guarantee_online_cpus(struct cpuset *cs, struct cpumask *pmask)
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
@@ -795,45 +795,6 @@ void rebuild_sched_domains(void)
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
  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
@@ -844,13 +805,12 @@ static struct cpuset *effective_nodemask_cpuset(struct cpuset *cs)
  */
 static void update_tasks_cpumask(struct cpuset *cs)
 {
-	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
 	struct css_task_iter it;
 	struct task_struct *task;
 
 	css_task_iter_start(&cs->css, &it);
 	while ((task = css_task_iter_next(&it)))
-		set_cpus_allowed_ptr(task, cpus_cs->cpus_allowed);
+		set_cpus_allowed_ptr(task, cs->effective_cpus);
 	css_task_iter_end(&it);
 }
 
@@ -988,15 +948,13 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 							const nodemask_t *to)
 {
 	struct task_struct *tsk = current;
-	struct cpuset *mems_cs;
 
 	tsk->mems_allowed = *to;
 
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
 	rcu_read_lock();
-	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
-	guarantee_online_mems(mems_cs, &tsk->mems_allowed);
+	guarantee_online_mems(task_cs(tsk), &tsk->mems_allowed);
 	rcu_read_unlock();
 }
 
@@ -1065,13 +1023,12 @@ static void *cpuset_being_rebound;
 static void update_tasks_nodemask(struct cpuset *cs)
 {
 	static nodemask_t newmems;	/* protected by cpuset_mutex */
-	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 	struct css_task_iter it;
 	struct task_struct *task;
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
-	guarantee_online_mems(mems_cs, &newmems);
+	guarantee_online_mems(cs, &newmems);
 
 	/*
 	 * The mpol_rebind_mm() call takes mmap_sem, which we couldn't
@@ -1497,8 +1454,6 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	struct task_struct *leader = cgroup_taskset_first(tset);
 	struct cpuset *cs = css_cs(css);
 	struct cpuset *oldcs = cpuset_attach_old_cs;
-	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
-	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 
 	mutex_lock(&cpuset_mutex);
 
@@ -1506,9 +1461,9 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	if (cs == &top_cpuset)
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	else
-		guarantee_online_cpus(cpus_cs, cpus_attach);
+		guarantee_online_cpus(cs, cpus_attach);
 
-	guarantee_online_mems(mems_cs, &cpuset_attach_nodemask_to);
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
 	cgroup_taskset_for_each(task, tset) {
 		/*
@@ -1525,11 +1480,9 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
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
@@ -1540,7 +1493,7 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 		 * mm from.
 		 */
 		if (is_memory_migrate(cs)) {
-			cpuset_migrate_mm(mm, &mems_oldcs->old_mems_allowed,
+			cpuset_migrate_mm(mm, &oldcs->old_mems_allowed,
 					  &cpuset_attach_nodemask_to);
 		}
 		mmput(mm);
@@ -2331,23 +2284,17 @@ void __init cpuset_init_smp(void)
 
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
-	struct cpuset *cpus_cs;
-
 	mutex_lock(&callback_mutex);
 	rcu_read_lock();
-	cpus_cs = effective_cpumask_cpuset(task_cs(tsk));
-	guarantee_online_cpus(cpus_cs, pmask);
+	guarantee_online_cpus(task_cs(tsk), pmask);
 	rcu_read_unlock();
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
@@ -2386,13 +2333,11 @@ void cpuset_init_current_mems_allowed(void)
 
 nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
 {
-	struct cpuset *mems_cs;
 	nodemask_t mask;
 
 	mutex_lock(&callback_mutex);
 	rcu_read_lock();
-	mems_cs = effective_nodemask_cpuset(task_cs(tsk));
-	guarantee_online_mems(mems_cs, &mask);
+	guarantee_online_mems(task_cs(tsk), &mask);
 	rcu_read_unlock();
 	mutex_unlock(&callback_mutex);
 
-- 
1.8.0.2
