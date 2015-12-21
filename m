From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [RESEND PATCH 2/2] cpuacct: split usage into user_usage and sys_usage.
Date: Mon, 21 Dec 2015 19:14:43 +0800
Message-ID: <1450696483-2864-2-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450696483-2864-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org, tj@kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Sometimes, cpuacct.usage is not detialed enough to user
to see how much usage a group used. We want to know how
much time it used in user mode and how much in kernel mode.

This patch introduce some more files to tell user these informations.
 # ls /sys/fs/cgroup/cpuacct/cpuacct.usage*
/sys/fs/cgroup/cpuacct/cpuacct.usage             /sys/fs/cgroup/cpuacct/cpuacct.usage_percpu_user
/sys/fs/cgroup/cpuacct/cpuacct.usage_percpu      /sys/fs/cgroup/cpuacct/cpuacct.usage_sys
/sys/fs/cgroup/cpuacct/cpuacct.usage_percpu_sys  /sys/fs/cgroup/cpuacct/cpuacct.usage_user

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sched/cpuacct.c | 140 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 120 insertions(+), 20 deletions(-)

diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 9c2bbf7..b3e8971 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -25,11 +25,22 @@ enum cpuacct_stat_index {
 	CPUACCT_STAT_NSTATS,
 };
 
+enum cpuacct_usage_index {
+	CPUACCT_USAGE_USER,	/* ... user mode */
+	CPUACCT_USAGE_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_USAGE_NRUSAGE,
+};
+
+struct cpuacct_usage {
+	u64	usages[CPUACCT_USAGE_NRUSAGE];
+};
+
 /* track cpu usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
+	struct cpuacct_usage __percpu *cpuusage;
 	struct kernel_cpustat __percpu *cpustat;
 };
 
@@ -49,7 +60,7 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	return css_ca(ca->css.parent);
 }
 
-static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
+static DEFINE_PER_CPU(struct cpuacct_usage, root_cpuacct_cpuusage);
 static struct cpuacct root_cpuacct = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
@@ -68,7 +79,7 @@ cpuacct_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!ca)
 		goto out;
 
-	ca->cpuusage = alloc_percpu(u64);
+	ca->cpuusage = alloc_percpu(struct cpuacct_usage);
 	if (!ca->cpuusage)
 		goto out_free_ca;
 
@@ -96,54 +107,104 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
 	kfree(ca);
 }
 
-static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
+static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
+				 enum cpuacct_usage_index index)
 {
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-	u64 data;
+	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	u64 data = 0;
+	int i = 0;
+
+	/*
+	 * We allow index == CPUACCT_USAGE_NRUSAGE here to read
+	 * the sum of suages.
+	 */
+	BUG_ON(index > CPUACCT_USAGE_NRUSAGE);
+
+	if (index == CPUACCT_USAGE_NRUSAGE) {
+		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+		for (i = 0; i < CPUACCT_USAGE_NRUSAGE; i++)
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
 
-static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
+static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu,
+				   enum cpuacct_usage_index index, u64 val)
 {
-	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+	int i = 0;
+
+	/*
+	 * We allow index == CPUACCT_USAGE_NRUSAGE here to write
+	 * val to each index of usages.
+	 */
+	BUG_ON(index > CPUACCT_USAGE_NRUSAGE);
+
+	if (index == CPUACCT_USAGE_NRUSAGE) {
+		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+		for (i = 0; i < CPUACCT_USAGE_NRUSAGE; i++)
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
 
 /* return total cpu usage (in nanoseconds) of a group */
-static u64 cpuusage_read(struct cgroup_subsys_state *css, struct cftype *cft)
+static u64 __cpuusage_read(struct cgroup_subsys_state *css, enum cpuacct_usage_index index)
 {
 	struct cpuacct *ca = css_ca(css);
 	u64 totalcpuusage = 0;
 	int i;
 
 	for_each_present_cpu(i)
-		totalcpuusage += cpuacct_cpuusage_read(ca, i);
+		totalcpuusage += cpuacct_cpuusage_read(ca, i, index);
 
 	return totalcpuusage;
 }
 
+static u64 cpuusage_user_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return __cpuusage_read(css, CPUACCT_USAGE_USER);
+}
+
+static u64 cpuusage_sys_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return __cpuusage_read(css, CPUACCT_USAGE_SYSTEM);
+}
+
+static u64 cpuusage_read(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return __cpuusage_read(css, CPUACCT_USAGE_NRUSAGE);
+}
+
 static int cpuusage_write(struct cgroup_subsys_state *css, struct cftype *cft,
 			  u64 val)
 {
@@ -159,27 +220,43 @@ static int cpuusage_write(struct cgroup_subsys_state *css, struct cftype *cft,
 		goto out;
 	}
 
-	for_each_present_cpu(i)
-		cpuacct_cpuusage_write(ca, i, 0);
+	for_each_present_cpu(i) {
+		cpuacct_cpuusage_write(ca, i, CPUACCT_USAGE_NRUSAGE, 0);
+	}
 
 out:
 	return err;
 }
 
-static int cpuacct_percpu_seq_show(struct seq_file *m, void *V)
+static int __cpuacct_percpu_seq_show(struct seq_file *m, enum cpuacct_usage_index index)
 {
 	struct cpuacct *ca = css_ca(seq_css(m));
 	u64 percpu;
 	int i;
 
 	for_each_present_cpu(i) {
-		percpu = cpuacct_cpuusage_read(ca, i);
+		percpu = cpuacct_cpuusage_read(ca, i, index);
 		seq_printf(m, "%llu ", (unsigned long long) percpu);
 	}
 	seq_printf(m, "\n");
 	return 0;
 }
 
+static int cpuacct_percpu_user_seq_show(struct seq_file *m, void *V)
+{
+	return __cpuacct_percpu_seq_show(m, CPUACCT_USAGE_USER);
+}
+
+static int cpuacct_percpu_sys_seq_show(struct seq_file *m, void *V)
+{
+	return __cpuacct_percpu_seq_show(m, CPUACCT_USAGE_SYSTEM);
+}
+
+static int cpuacct_percpu_seq_show(struct seq_file *m, void *V)
+{
+	return __cpuacct_percpu_seq_show(m, CPUACCT_USAGE_NRUSAGE);
+}
+
 static const char * const cpuacct_stat_desc[] = {
 	[CPUACCT_STAT_USER] = "user",
 	[CPUACCT_STAT_SYSTEM] = "system",
@@ -220,10 +297,26 @@ static struct cftype files[] = {
 		.write_u64 = cpuusage_write,
 	},
 	{
+		.name = "usage_user",
+		.read_u64 = cpuusage_user_read,
+	},
+	{
+		.name = "usage_sys",
+		.read_u64 = cpuusage_sys_read,
+	},
+	{
 		.name = "usage_percpu",
 		.seq_show = cpuacct_percpu_seq_show,
 	},
 	{
+		.name = "usage_percpu_user",
+		.seq_show = cpuacct_percpu_user_seq_show,
+	},
+	{
+		.name = "usage_percpu_sys",
+		.seq_show = cpuacct_percpu_sys_seq_show,
+	},
+	{
 		.name = "stat",
 		.seq_show = cpuacct_stats_show,
 	},
@@ -239,6 +332,7 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct cpuacct *ca;
 	int cpu;
+	int user_time;
 
 	cpu = task_cpu(tsk);
 
@@ -246,9 +340,15 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	ca = task_ca(tsk);
 
+	user_time = user_mode(task_pt_regs(tsk));
+
 	while (true) {
-		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
-		*cpuusage += cputime;
+		struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
+
+		if (user_time)
+			cpuusage->usages[CPUACCT_USAGE_USER] += cputime;
+		else
+			cpuusage->usages[CPUACCT_USAGE_SYSTEM] += cputime;
 
 		ca = parent_ca(ca);
 		if (!ca)
-- 
1.8.4.2


