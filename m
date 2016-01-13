From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 1/2] sched: implement cpu subsystem for unified hierarchy
Date: Wed, 13 Jan 2016 16:40:19 +0800
Message-ID: <1452674420-31603-2-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1452674420-31603-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452674420-31603-1-git-send-email-yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

In cgroup2, we plan to combine cpuacct and cpu subsystem.

This patch implement cpu subsystem in unified hierarchy
and implement a cpu.usage in cpu subsystem.

Signed-off-by: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/sched/core.c      | 187 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/deadline.c  |   2 +-
 kernel/sched/fair.c      |   2 +-
 kernel/sched/rt.c        |   2 +-
 kernel/sched/sched.h     |  10 +++
 kernel/sched/stop_task.c |   2 +-
 6 files changed, 199 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 732e993..1333b6c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7349,11 +7349,14 @@ int in_sched_functions(unsigned long addr)
 }
 
 #ifdef CONFIG_CGROUP_SCHED
+DEFINE_PER_CPU(u64, root_cpuusage);
 /*
  * Default task group.
  * Every task in system belongs to this group at bootup.
  */
-struct task_group root_task_group;
+struct task_group root_task_group = {
+	.cpuusage	= &root_cpuusage,
+};
 LIST_HEAD(task_groups);
 #endif
 
@@ -7692,10 +7695,26 @@ void set_curr_task(int cpu, struct task_struct *p)
 /* task_group_lock serializes the addition/removal of task groups */
 static DEFINE_SPINLOCK(task_group_lock);
 
+static int alloc_cpuusage(struct task_group *tg)
+{
+	tg->cpuusage = alloc_percpu(u64);
+	if (!tg->cpuusage)
+		goto err;
+	return 0;
+err:
+	return -ENOMEM;
+}
+
+static void free_cpuusage(struct task_group *tg)
+{
+	free_percpu(tg->cpuusage);
+}
+
 static void free_sched_group(struct task_group *tg)
 {
 	free_fair_sched_group(tg);
 	free_rt_sched_group(tg);
+	free_cpuusage(tg);
 	autogroup_free(tg);
 	kfree(tg);
 }
@@ -7715,6 +7734,9 @@ struct task_group *sched_create_group(struct task_group *parent)
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
+	if (alloc_cpuusage(tg))
+		goto err;
+
 	return tg;
 
 err:
@@ -8194,6 +8216,35 @@ static inline struct task_group *css_tg(struct cgroup_subsys_state *css)
 	return css ? container_of(css, struct task_group, css) : NULL;
 }
 
+static inline struct task_group *parent_tg(struct task_group *tg)
+{
+	return css_tg(tg->css.parent);
+}
+
+void cpu_usage_charge(struct task_struct *tsk, u64 cputime)
+{
+	struct task_group *tg;
+	int cpu;
+
+	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
+
+	tg = task_group(tsk);
+
+	while (true) {
+		u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+		*cpuusage += cputime;
+
+		tg = parent_tg(tg);
+		if (!tg)
+			break;
+	}
+	rcu_read_unlock();
+
+	cpuacct_charge(tsk, cputime);
+}
+
 static struct cgroup_subsys_state *
 cpu_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
@@ -8552,6 +8603,128 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+static u64 cpu_usage_percpu_read(struct task_group *tg, int cpu)
+{
+	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+	u64 data;
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	data = *cpuusage;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	data = *cpuusage;
+#endif
+
+	return data;
+}
+
+static void cpu_usage_percpu_write(struct task_group *tg, int cpu, u64 val)
+{
+	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+
+#ifndef CONFIG_64BIT
+	/*
+	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 */
+	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	*cpuusage = val;
+	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#else
+	*cpuusage = val;
+#endif
+}
+
+static u64 cpu_usage_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	struct task_group *tg = css_tg(css);
+	u64 totalcpuusage = 0;
+	int i;
+
+	for_each_present_cpu(i)
+		totalcpuusage += cpu_usage_percpu_read(tg, i);
+
+	return totalcpuusage;
+}
+
+static int cpu_usage_write(struct cgroup_subsys_state *css, struct cftype *cft,
+			   u64 val)
+{
+	struct task_group *tg = css_tg(css);
+	int err = 0;
+	int i;
+
+	/*
+	 * Only allow '0' here to do a reset.
+	 */
+	if (val) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	for_each_present_cpu(i)
+		cpu_usage_percpu_write(tg, i, 0);
+
+out:
+	return err;
+}
+
+static int cpu_usage_percpu_seq_show(struct seq_file *m, void *V)
+{
+	struct task_group *tg = css_tg(seq_css(m));
+	u64 percpu;
+	int i;
+
+	for_each_present_cpu(i) {
+		percpu = cpu_usage_percpu_read(tg, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+
+static struct cftype cpu_legacy_files[] = {
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	{
+		.name = "shares",
+		.read_u64 = cpu_shares_read_u64,
+		.write_u64 = cpu_shares_write_u64,
+	},
+#endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.name = "cfs_quota_us",
+		.read_s64 = cpu_cfs_quota_read_s64,
+		.write_s64 = cpu_cfs_quota_write_s64,
+	},
+	{
+		.name = "cfs_period_us",
+		.read_u64 = cpu_cfs_period_read_u64,
+		.write_u64 = cpu_cfs_period_write_u64,
+	},
+	{
+		.name = "stat",
+		.seq_show = cpu_stats_show,
+	},
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	{
+		.name = "rt_runtime_us",
+		.read_s64 = cpu_rt_runtime_read,
+		.write_s64 = cpu_rt_runtime_write,
+	},
+	{
+		.name = "rt_period_us",
+		.read_u64 = cpu_rt_period_read_uint,
+		.write_u64 = cpu_rt_period_write_uint,
+	},
+#endif
+	{ }	/* terminate */
+};
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -8588,6 +8761,15 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_rt_period_write_uint,
 	},
 #endif
+	{
+		.name = "usage",
+		.read_u64 = cpu_usage_read,
+		.write_u64 = cpu_usage_write,
+	},
+	{
+		.name = "usage_percpu",
+		.seq_show = cpu_usage_percpu_seq_show,
+	},
 	{ }	/* terminate */
 };
 
@@ -8599,7 +8781,8 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.legacy_cftypes	= cpu_files,
+	.dfl_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= 1,
 };
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 8b0a15e..efae061 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -739,7 +739,7 @@ static void update_curr_dl(struct rq *rq)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
+	cpu_usage_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfdc0e6..ee2fb15 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -726,7 +726,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
-		cpuacct_charge(curtask, delta_exec);
+		cpu_usage_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8ec86ab..efd666c 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -956,7 +956,7 @@ static void update_curr_rt(struct rq *rq)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
+	cpu_usage_charge(curr, delta_exec);
 
 	sched_rt_avg_update(rq, delta_exec);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 141a16c..fc8db08 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -266,6 +266,9 @@ struct task_group {
 	struct list_head siblings;
 	struct list_head children;
 
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
 #endif
@@ -336,10 +339,17 @@ extern void sched_move_task(struct task_struct *tsk);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 #endif
 
+extern void cpu_usage_charge(struct task_struct *tsk, u64 cputime);
+
 #else /* CONFIG_CGROUP_SCHED */
 
 struct cfs_bandwidth { };
 
+static inline void cpu_usage_charge(struct task_struct *tsk, u64 cputime)
+{
+	cpuacct_charge(tsk, cputime);	
+}
+
 #endif	/* CONFIG_CGROUP_SCHED */
 
 /* CFS-related fields in a runqueue */
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index cbc67da..132d056 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -71,7 +71,7 @@ static void put_prev_task_stop(struct rq *rq, struct task_struct *prev)
 	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq_clock_task(rq);
-	cpuacct_charge(curr, delta_exec);
+	cpu_usage_charge(curr, delta_exec);
 }
 
 static void task_tick_stop(struct rq *rq, struct task_struct *curr, int queued)
-- 
1.8.4.2


