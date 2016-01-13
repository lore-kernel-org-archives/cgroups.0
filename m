From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 2/2] cgroup: cpu subsystem: split cpu usage into user_usage and sys_usage.
Date: Wed, 13 Jan 2016 16:40:20 +0800
Message-ID: <1452674420-31603-3-git-send-email-yangds.fnst@cn.fujitsu.com>
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

Sometimes, cpu.usage is not detialed enough to user
to see how much usage a group used. We want to know how
much time it used in user mode and how much in kernel mode.

This patch introduce some more files to tell user these informations.
 # ll /cgroup2/cpu.usage*
-rw-r--r--. 1 root root 0 Jan 12 23:23 /cgroup2/cpu.usage
-r--r--r--. 1 root root 0 Jan 12 23:23 /cgroup2/cpu.usage_percpu
-r--r--r--. 1 root root 0 Jan 12 23:23 /cgroup2/cpu.usage_percpu_sys
-r--r--r--. 1 root root 0 Jan 12 23:23 /cgroup2/cpu.usage_percpu_user
-r--r--r--. 1 root root 0 Jan 12 23:23 /cgroup2/cpu.usage_sys
-r--r--r--. 1 root root 0 Jan 12 23:23 /cgroup2/cpu.usage_user

Signed-off-by: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/sched/core.c  | 125 +++++++++++++++++++++++++++++++++++++++++++--------
 kernel/sched/sched.h |  15 ++++++-
 2 files changed, 120 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1333b6c..989fdc5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7349,7 +7349,7 @@ int in_sched_functions(unsigned long addr)
 }
 
 #ifdef CONFIG_CGROUP_SCHED
-DEFINE_PER_CPU(u64, root_cpuusage);
+DEFINE_PER_CPU(struct cpu_usage, root_cpuusage);
 /*
  * Default task group.
  * Every task in system belongs to this group at bootup.
@@ -7697,7 +7697,7 @@ static DEFINE_SPINLOCK(task_group_lock);
 
 static int alloc_cpuusage(struct task_group *tg)
 {
-	tg->cpuusage = alloc_percpu(u64);
+	tg->cpuusage = alloc_percpu(struct cpu_usage);
 	if (!tg->cpuusage)
 		goto err;
 	return 0;
@@ -8224,7 +8224,9 @@ static inline struct task_group *parent_tg(struct task_group *tg)
 void cpu_usage_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct task_group *tg;
+	struct cpu_usage *cpuusage;
 	int cpu;
+	int user_time;
 
 	cpu = task_cpu(tsk);
 
@@ -8232,9 +8234,15 @@ void cpu_usage_charge(struct task_struct *tsk, u64 cputime)
 
 	tg = task_group(tsk);
 
+	user_time = user_mode(task_pt_regs(tsk));
+
 	while (true) {
-		u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
-		*cpuusage += cputime;
+		cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+
+		if (user_time)
+			cpuusage->usages[CPU_USAGE_USER] += cputime;
+		else
+			cpuusage->usages[CPU_USAGE_SYSTEM] += cputime;
 
 		tg = parent_tg(tg);
 		if (!tg)
@@ -8603,53 +8611,103 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static u64 cpu_usage_percpu_read(struct task_group *tg, int cpu)
+static u64 cpu_usage_percpu_read(struct task_group *tg, int cpu,
+				 enum cpu_usage_index index)
 {
-	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
-	u64 data;
+	struct cpu_usage *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+	u64 data = 0;
+	int i = 0;
+
+	/*
+	 * Allow index == CPU_USAGE_NRUSAGE here to read
+	 * the sum of suages.
+	 */
+	BUG_ON(index > CPU_USAGE_NRUSAGE);
+
+	if (index == CPU_USAGE_NRUSAGE) {
+		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+		for (i = 0; i < CPU_USAGE_NRUSAGE; i++)
+			data += cpuusage->usages[i];
+		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+
+		goto out;
+	}
 
 #ifndef CONFIG_64BIT
 	/*
 	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
 	 */
 	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	data = *cpuusage;
+	data = cpuusage->usages[index];
 	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
 #else
-	data = *cpuusage;
+	data = cpuusage->usages[index];
 #endif
 
+out:
 	return data;
 }
 
-static void cpu_usage_percpu_write(struct task_group *tg, int cpu, u64 val)
+static void cpu_usage_percpu_write(struct task_group *tg, int cpu,
+				   enum cpu_usage_index index, u64 val)
 {
-	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+	struct cpu_usage *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+	int i = 0;
+
+	/*
+	 * Allow index == CPU_USAGE_NRUSAGE here to write
+	 * val to each index of usages.
+	 */
+	BUG_ON(index > CPU_USAGE_NRUSAGE);
+
+	if (index == CPU_USAGE_NRUSAGE) {
+		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+		for (i = 0; i < CPU_USAGE_NRUSAGE; i++)
+			cpuusage->usages[i] = val;
+		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+
+		return;
+	}
 
 #ifndef CONFIG_64BIT
 	/*
 	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
 	 */
 	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	*cpuusage = val;
+	cpuusage->usages[index] = val;
 	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
 #else
-	*cpuusage = val;
+	cpuusage->usages[index] = val;
 #endif
 }
 
-static u64 cpu_usage_read(struct cgroup_subsys_state *css, struct cftype *cft)
+static u64 __cpu_usage_read(struct cgroup_subsys_state *css, enum cpu_usage_index index)
 {
 	struct task_group *tg = css_tg(css);
 	u64 totalcpuusage = 0;
 	int i;
 
 	for_each_present_cpu(i)
-		totalcpuusage += cpu_usage_percpu_read(tg, i);
+		totalcpuusage += cpu_usage_percpu_read(tg, i, index);
 
 	return totalcpuusage;
 }
 
+static u64 cpu_usage_user_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return __cpu_usage_read(css, CPU_USAGE_USER);
+}
+
+static u64 cpu_usage_sys_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return __cpu_usage_read(css, CPU_USAGE_SYSTEM);
+}
+
+static u64 cpu_usage_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return __cpu_usage_read(css, CPU_USAGE_NRUSAGE);
+}
+
 static int cpu_usage_write(struct cgroup_subsys_state *css, struct cftype *cft,
 			   u64 val)
 {
@@ -8666,26 +8724,41 @@ static int cpu_usage_write(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 
 	for_each_present_cpu(i)
-		cpu_usage_percpu_write(tg, i, 0);
+		cpu_usage_percpu_write(tg, i, CPU_USAGE_NRUSAGE, 0);
 
 out:
 	return err;
 }
 
-static int cpu_usage_percpu_seq_show(struct seq_file *m, void *V)
+static int __cpu_usage_percpu_seq_show(struct seq_file *m, enum cpu_usage_index index)
 {
 	struct task_group *tg = css_tg(seq_css(m));
 	u64 percpu;
 	int i;
 
 	for_each_present_cpu(i) {
-		percpu = cpu_usage_percpu_read(tg, i);
+		percpu = cpu_usage_percpu_read(tg, i, index);
 		seq_printf(m, "%llu ", (unsigned long long) percpu);
 	}
 	seq_printf(m, "\n");
 	return 0;
 }
 
+static int cpu_usage_percpu_user_seq_show(struct seq_file *m, void *V)
+{
+	return __cpu_usage_percpu_seq_show(m, CPU_USAGE_USER);
+}
+
+static int cpu_usage_percpu_sys_seq_show(struct seq_file *m, void *V)
+{
+	return __cpu_usage_percpu_seq_show(m, CPU_USAGE_SYSTEM);
+}
+
+static int cpu_usage_percpu_seq_show(struct seq_file *m, void *V)
+{
+	return __cpu_usage_percpu_seq_show(m, CPU_USAGE_NRUSAGE);
+}
+
 static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -8767,9 +8840,25 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_usage_write,
 	},
 	{
+		.name = "usage_user",
+		.read_u64 = cpu_usage_user_read,
+	},
+	{
+		.name = "usage_sys",
+		.read_u64 = cpu_usage_sys_read,
+	},
+	{
 		.name = "usage_percpu",
 		.seq_show = cpu_usage_percpu_seq_show,
 	},
+	{
+		.name = "usage_percpu_user",
+		.seq_show = cpu_usage_percpu_user_seq_show,
+	},
+	{
+		.name = "usage_percpu_sys",
+		.seq_show = cpu_usage_percpu_sys_seq_show,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fc8db08..6e52d25 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -236,6 +236,17 @@ struct cfs_bandwidth {
 #endif
 };
 
+enum cpu_usage_index {
+	CPU_USAGE_USER,		/* ... user mode */
+	CPU_USAGE_SYSTEM,	/* ... kernel mode */
+
+	CPU_USAGE_NRUSAGE,
+};
+
+struct cpu_usage {
+	u64	usages[CPU_USAGE_NRUSAGE];
+};
+
 /* task group related information */
 struct task_group {
 	struct cgroup_subsys_state css;
@@ -266,8 +277,8 @@ struct task_group {
 	struct list_head siblings;
 	struct list_head children;
 
-	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
+	/* cpuusage holds pointer to a cpu_usage on every cpu */
+	struct cpu_usage __percpu *cpuusage;
 
 #ifdef CONFIG_SCHED_AUTOGROUP
 	struct autogroup *autogroup;
-- 
1.8.4.2


