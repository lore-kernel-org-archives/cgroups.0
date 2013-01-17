From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/6] sched: split out tg creation/destruction to css_online/css_offline
Date: Thu, 17 Jan 2013 16:03:29 +0800
Message-ID: <50F7B051.4000507@huawei.com>
References: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50F7B040.2020906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

With this change, it's safe to access tg->css.cgroup while iterating
the global task_group list.

This is a preparation for later patches.

Signed-off-by: Li Zefan <lizefan@huawei.com>
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
