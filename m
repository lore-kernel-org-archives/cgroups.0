From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Wed,  9 Jan 2013 15:45:38 +0400
Message-ID: <1357731938-8417-12-git-send-email-glommer@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357731938-8417-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

The file cpu.stat_percpu will show various scheduler related
information, that are usually available to the top level through other
files.

For instance, most of the meaningful data in /proc/stat is presented
here. Given this file, a container can easily construct a local copy of
/proc/stat for internal consumption.

The data we export is comprised of:
* all the tick information, previously available only through cpuacct,
  like user time, system time, etc.

* wait time, which can be used to construct analogous information to
  steal time in hypervisors,

* nr_switches and nr_running, which are cgroup-local versions of
  their global counterparts.

The file includes a header, so fields can come and go if needed.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c  | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c  | 13 +++++++
 kernel/sched/sched.h |  1 +
 3 files changed, 111 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6bb56f0..5135b50 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8111,6 +8111,97 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+#ifdef CONFIG_SCHEDSTATS
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#define fair_rq(field, tg, i)  (tg)->cfs_rq[i]->field
+#else
+#define fair_rq(field, tg, i)  0
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+#define rt_rq(field, tg, i)  (tg)->rt_rq[i]->field
+#else
+#define rt_rq(field, tg, i)  0
+#endif
+
+static u64 tg_nr_switches(struct task_group *tg, int cpu)
+{
+	/* nr_switches, which counts idle and stop task, is added to all tgs */
+	return cpu_rq(cpu)->nr_switches +
+		cfs_nr_switches(tg, cpu) + rt_nr_switches(tg, cpu);
+}
+
+static u64 tg_nr_running(struct task_group *tg, int cpu)
+{
+	/*
+	 * because of autogrouped groups in root_task_group, the
+	 * following does not hold.
+	 */
+	if (tg != &root_task_group)
+		return rt_rq(rt_nr_running, tg, cpu) + fair_rq(nr_running, tg, cpu);
+
+	return cpu_rq(cpu)->nr_running;
+}
+
+static u64 tg_wait(struct task_group *tg, int cpu)
+{
+	u64 val;
+
+	if (tg != &root_task_group)
+		val = cfs_read_wait(tg->se[cpu]);
+	else
+		/*
+		 * There are many errors here that we are accumulating.
+		 * However, we only provide this in the interest of having
+		 * a consistent interface for all cgroups. Everybody
+		 * probing the root cgroup should be getting its figures
+		 * from system-wide files as /proc/stat. That would be faster
+		 * to begin with...
+		 */
+		val = kcpustat_cpu(cpu).cpustat[CPUTIME_STEAL] * TICK_NSEC;
+
+	return val;
+}
+
+static inline void do_fill_seq(struct seq_file *m, struct task_group *tg,
+			       int cpu, int index)
+{
+	u64 val = 0;
+	struct kernel_cpustat *kcpustat;
+	kcpustat = this_cpu_ptr(tg->cpustat);
+	val = cputime64_to_clock_t(kcpustat->cpustat[index]) * TICK_NSEC;
+	seq_put_decimal_ull(m, ' ', val);
+}
+
+static int cpu_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
+				 struct seq_file *m)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int cpu;
+
+	seq_printf(m, "user nice system irq softirq guest guest_nice ");
+	seq_printf(m, "wait nr_switches nr_running\n");
+
+	for_each_online_cpu(cpu) {
+		seq_printf(m, "cpu%d", cpu);
+		do_fill_seq(m, tg, cpu, CPUTIME_USER);
+		do_fill_seq(m, tg, cpu, CPUTIME_NICE);
+		do_fill_seq(m, tg, cpu, CPUTIME_SYSTEM);
+		do_fill_seq(m, tg, cpu, CPUTIME_IRQ);
+		do_fill_seq(m, tg, cpu, CPUTIME_SOFTIRQ);
+		do_fill_seq(m, tg, cpu, CPUTIME_GUEST);
+		do_fill_seq(m, tg, cpu, CPUTIME_GUEST_NICE);
+		seq_put_decimal_ull(m, ' ', tg_wait(tg, cpu));
+		seq_put_decimal_ull(m, ' ', tg_nr_switches(tg, cpu));
+		seq_put_decimal_ull(m, ' ', tg_nr_running(tg, cpu));
+		seq_putc(m, '\n');
+	}
+
+	return 0;
+}
+#endif
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -8164,6 +8255,12 @@ static struct cftype cpu_files[] = {
 		.flags = CFTYPE_NO_PREFIX,
 		.read_map = cpucg_stats_show,
 	},
+#ifdef CONFIG_SCHEDSTATS
+	{
+		.name = "stat_percpu",
+		.read_seq_string = cpu_stats_percpu_show,
+	},
+#endif
 	{ }	/* terminate */
 };
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0dd9c50..778b249 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -721,6 +721,19 @@ update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	schedstat_set(se->statistics.wait_start, rq_of(cfs_rq)->clock);
 }
 
+#ifdef CONFIG_SCHEDSTATS
+u64 cfs_read_wait(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 value = se->statistics.wait_sum;
+
+	if (!se->statistics.wait_start)
+		return value;
+
+	return value + rq_of(cfs_rq)->clock - se->statistics.wait_start;
+}
+#endif
+
 /*
  * Task is being enqueued - update stats:
  */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index a426abc..0a12980 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1195,6 +1195,7 @@ extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
 
 extern void account_cfs_bandwidth_used(int enabled, int was_enabled);
+extern u64 cfs_read_wait(struct sched_entity *se);
 
 #ifdef CONFIG_NO_HZ
 enum rq_nohz_flag_bits {
-- 
1.7.11.7
