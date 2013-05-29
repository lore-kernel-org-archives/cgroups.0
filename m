From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 11/11] sched: introduce cgroup file stat_percpu
Date: Wed, 29 May 2013 15:03:22 +0400
Message-ID: <1369825402-31046-12-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

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

The file format consists of a one-line header that describes the fields
being listed.  No guarantee is given that the fields will be kept the
same between kernel releases, and readers should always check the header
in order to introspect it.

Each of the following lines will show the respective field value for
each of the possible cpus in the system. All values are show in
nanoseconds.

One example output for this file is:

cpu user nice system irq softirq guest guest_nice wait nr_switches nr_running
cpu0 471000000 0 15000000 0 0 0 0 1996534 7205 1
cpu1 588000000 0 17000000 0 0 0 0 2848680 6510 1
cpu2 505000000 0 14000000 0 0 0 0 2350771 6183 1
cpu3 472000000 0 16000000 0 0 0 0 19766345 6277 2

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 Documentation/cgroups/cpu.txt |  18 +++++++
 kernel/sched/core.c           | 109 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c           |  14 ++++++
 kernel/sched/sched.h          |  10 +++-
 4 files changed, 150 insertions(+), 1 deletion(-)

diff --git a/Documentation/cgroups/cpu.txt b/Documentation/cgroups/cpu.txt
index 072fd58..d40e500 100644
--- a/Documentation/cgroups/cpu.txt
+++ b/Documentation/cgroups/cpu.txt
@@ -68,6 +68,24 @@ The CPU controller exposes the following files to the user:
    can ever be run in this cgroup. For more information about rt tasks runtime
    assignments, see scheduler/sched-rt-group.txt
 
+ - cpu.stat_percpu: Various scheduler statistics for the current group. The
+   information provided in this file is akin to the one displayed in /proc/stat,
+   except for the fact that it is cgroup-aware. The file format consists of a
+   one-line header that describes the fields being listed.  No guarantee is
+   given that the fields will be kept the same between kernel releases, and
+   readers should always check the header in order to introspect it.
+
+   Each of the following lines will show the respective field value for
+   each of the possible cpus in the system. All values are show in
+   nanoseconds. One example output for this file is:
+
+   cpu user nice system irq softirq guest guest_nice wait nr_switches nr_running
+   cpu0 471000000 0 15000000 0 0 0 0 1996534 7205 1
+   cpu1 588000000 0 17000000 0 0 0 0 2848680 6510 1
+   cpu2 505000000 0 14000000 0 0 0 0 2350771 6183 1
+   cpu3 472000000 0 16000000 0 0 0 0 19766345 6277 2
+
+
  - cpuacct.usage: The aggregate CPU time, in nanoseconds, consumed by all tasks
    in this group.
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 892c828..e2963ec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7239,6 +7239,7 @@ static inline void cfs_exec_clock_reset(struct task_group *tg, int cpu)
 #else
 static inline u64 cfs_exec_clock(struct task_group *tg, int cpu)
 {
+	return 0;
 }
 
 static inline void cfs_exec_clock_reset(struct task_group *tg, int cpu)
@@ -7670,6 +7671,108 @@ static u64 cpu_rt_period_read_uint(struct cgroup *cgrp, struct cftype *cft)
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
+		val = cfs_read_wait(tg, cpu);
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
+	kcpustat = per_cpu_ptr(tg->cpustat, cpu);
+	val = cputime64_to_clock_t(kcpustat->cpustat[index]) * TICK_NSEC;
+	seq_put_decimal_ull(m, ' ', val);
+}
+
+/*
+ * This will dislay per-cpu statistics about the running cgroup. The file
+ * format consists of a one-line header that describes the fields being listed.
+ * No guarantee is given that the fields will be kept the same between kernel
+ * releases, and readers should always check the header in order to introspect
+ * it. The first column, however, will always be in the form cpux, where
+ * x is the logical number of the cpu.
+ *
+ * Each of the following lines will show the respective field value for each of
+ * the possible cpus in the system. All values are show in nanoseconds.
+ */
+static int cpu_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
+				 struct seq_file *m)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+	int cpu;
+
+	seq_printf(m, "cpu user nice system irq softirq guest guest_nice ");
+	seq_printf(m, "wait nr_switches nr_running\n");
+
+	for_each_possible_cpu(cpu) {
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
@@ -7723,6 +7826,12 @@ static struct cftype cpu_files[] = {
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
index b29e5dd..f718c28 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1123,6 +1123,20 @@ static void update_cfs_shares(struct cfs_rq *cfs_rq)
 
 	reweight_entity(cfs_rq_of(se), se, shares);
 }
+
+#ifdef CONFIG_SCHEDSTATS
+u64 cfs_read_wait(struct task_group *tg, int cpu)
+{
+	struct sched_entity *se = tg->se[cpu];
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+	u64 value = se->statistics.wait_sum;
+
+	if (!se->statistics.wait_start)
+		return value;
+
+	return value + rq_of(cfs_rq)->clock - se->statistics.wait_start;
+}
+#endif
 #else /* CONFIG_FAIR_GROUP_SCHED */
 static inline void update_cfs_shares(struct cfs_rq *cfs_rq)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 39d3284..742870e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -242,8 +242,16 @@ extern void sched_move_task(struct task_struct *tsk);
 extern int sched_group_set_shares(struct task_group *tg, unsigned long shares);
 #endif
 
-#else /* CONFIG_CGROUP_SCHED */
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+extern u64 cfs_read_wait(struct task_group *tg, int cpu);
+#else
+static inline u64 cfs_read_wait(struct task_group *tg, int cpu)
+{
+	return 0;
+}
+#endif
+#else /* CONFIG_CGROUP_SCHED */
 struct cfs_bandwidth { };
 
 #endif	/* CONFIG_CGROUP_SCHED */
-- 
1.8.1.4
