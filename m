From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/6] sched: split out css_online/css_offline from tg creation/destruction
Date: Thu, 24 Jan 2013 14:30:48 +0800
Message-ID: <5100D518.8000103@huawei.com>
References: <5100D4FE.9080205@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5100D4FE.9080205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

This is a preparaton for later patches.

- What do we gain from cpu_cgroup_css_online():

After ss->css_alloc() and before ss->css_online(), there's a small
window that tg->css.cgroup is NULL. With this change, tg won't be seen
before ss->css_online(), where it's added to the global list, so we're
guaranteed we'll never see NULL tg->css.cgroup.

- What do we gain from cpu_cgroup_css_offline():

tg is freed via RCU, so is cgroup. Without this change, This is how
synchronization works:

cgroup_rmdir()
  no ss->css_offline()
diput()
  syncornize_rcu()
  ss->css_free()       <-- unregister tg, and free it via call_rcu()
  kfree_rcu(cgroup)    <-- wait possible refs to cgroup, and free cgroup

We can't just kfree(cgroup), because tg might access tg->css.cgroup.

With this change:

cgroup_rmdir()
  ss->css_offline()    <-- unregister tg
diput()
  synchronize_rcu()    <-- wait possible refs to tg and cgroup
  ss->css_free()       <-- free tg
  kfree_rcu(cgroup)    <-- free cgroup

As you see, kfree_rcu() is redundant now.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

v2: changelog rephrased

---
 include/linux/sched.h     |  3 +++
 kernel/sched/auto_group.c |  3 +++
 kernel/sched/core.c       | 49 +++++++++++++++++++++++++++++++++++++----------
 3 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..577eb97 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2750,7 +2750,10 @@ extern void normalize_rt_tasks(void);
 extern struct task_group root_task_group;
 
 extern struct task_group *sched_create_group(struct task_group *parent);
+extern void sched_online_group(struct task_group *tg,
+			       struct task_group *parent);
 extern void sched_destroy_group(struct task_group *tg);
+extern void sched_offline_group(struct task_group *tg);
 extern void sched_move_task(struct task_struct *tsk);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
diff --git a/kernel/sched/auto_group.c b/kernel/sched/auto_group.c
index 0984a21..64de5f8 100644
--- a/kernel/sched/auto_group.c
+++ b/kernel/sched/auto_group.c
@@ -35,6 +35,7 @@ static inline void autogroup_destroy(struct kref *kref)
 	ag->tg->rt_se = NULL;
 	ag->tg->rt_rq = NULL;
 #endif
+	sched_offline_group(ag->tg);
 	sched_destroy_group(ag->tg);
 }
 
@@ -76,6 +77,8 @@ static inline struct autogroup *autogroup_create(void)
 	if (IS_ERR(tg))
 		goto out_free;
 
+	sched_online_group(tg, &root_task_group);
+
 	kref_init(&ag->kref);
 	init_rwsem(&ag->lock);
 	ag->id = atomic_inc_return(&autogroup_seq_nr);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 257002c..1061672 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7159,7 +7159,6 @@ static void free_sched_group(struct task_group *tg)
 struct task_group *sched_create_group(struct task_group *parent)
 {
 	struct task_group *tg;
-	unsigned long flags;
 
 	tg = kzalloc(sizeof(*tg), GFP_KERNEL);
 	if (!tg)
@@ -7171,6 +7170,17 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	return tg;
+
+err:
+	free_sched_group(tg);
+	return ERR_PTR(-ENOMEM);
+}
+
+void sched_online_group(struct task_group *tg, struct task_group *parent)
+{
+	unsigned long flags;
+
 	spin_lock_irqsave(&task_group_lock, flags);
 	list_add_rcu(&tg->list, &task_groups);
 
@@ -7180,12 +7190,6 @@ struct task_group *sched_create_group(struct task_group *parent)
 	INIT_LIST_HEAD(&tg->children);
 	list_add_rcu(&tg->siblings, &parent->children);
 	spin_unlock_irqrestore(&task_group_lock, flags);
-
-	return tg;
-
-err:
-	free_sched_group(tg);
-	return ERR_PTR(-ENOMEM);
 }
 
 /* rcu callback to free various structures associated with a task group */
@@ -7198,6 +7202,12 @@ static void free_sched_group_rcu(struct rcu_head *rhp)
 /* Destroy runqueue etc associated with a task group */
 void sched_destroy_group(struct task_group *tg)
 {
+	/* wait for possible concurrent references to cfs_rqs complete */
+	call_rcu(&tg->rcu, free_sched_group_rcu);
+}
+
+void sched_offline_group(struct task_group *tg)
+{
 	unsigned long flags;
 	int i;
 
@@ -7209,9 +7219,6 @@ void sched_destroy_group(struct task_group *tg)
 	list_del_rcu(&tg->list);
 	list_del_rcu(&tg->siblings);
 	spin_unlock_irqrestore(&task_group_lock, flags);
-
-	/* wait for possible concurrent references to cfs_rqs complete */
-	call_rcu(&tg->rcu, free_sched_group_rcu);
 }
 
 /* change task's runqueue when it moves between groups.
@@ -7563,6 +7570,19 @@ static struct cgroup_subsys_state *cpu_cgroup_css_alloc(struct cgroup *cgrp)
 	return &tg->css;
 }
 
+static int cpu_cgroup_css_online(struct cgroup *cgrp)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	struct task_group *parent;
+
+	if (!cgrp->parent)
+		return 0;
+
+	parent = cgroup_tg(cgrp->parent);
+	sched_online_group(tg, parent);
+	return 0;
+}
+
 static void cpu_cgroup_css_free(struct cgroup *cgrp)
 {
 	struct task_group *tg = cgroup_tg(cgrp);
@@ -7570,6 +7590,13 @@ static void cpu_cgroup_css_free(struct cgroup *cgrp)
 	sched_destroy_group(tg);
 }
 
+static void cpu_cgroup_css_offline(struct cgroup *cgrp)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+
+	sched_offline_group(tg);
+}
+
 static int cpu_cgroup_can_attach(struct cgroup *cgrp,
 				 struct cgroup_taskset *tset)
 {
@@ -7925,6 +7952,8 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 	.name		= "cpu",
 	.css_alloc	= cpu_cgroup_css_alloc,
 	.css_free	= cpu_cgroup_css_free,
+	.css_online	= cpu_cgroup_css_online,
+	.css_offline	= cpu_cgroup_css_offline,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
-- 
1.8.0.2
