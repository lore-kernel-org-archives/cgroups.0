From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 4/4] cpuset: Add cpusets.quiesce option
Date: Thu, 20 Mar 2014 19:19:01 +0530
Message-ID: <e643acf71086db239254d44c77d4966b2a4a01e5.1395322529.git.viresh.kumar@linaro.org>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar@linaro.org>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

For networking applications platforms need to provide one CPU per each user
space data plane thread. These CPUs should not be interrupted by kernel at all
unless userspace has requested for some syscalls. Currently, there are
background kernel activities that are running on almost every CPU, like:
timers/hrtimers/watchdogs/etc, and these are required to be migrated to other
CPUs.

To achieve that, this patch adds another option to cpusets, i.e. 'quiesce'.
Writing '1' on this file would migrate these unbound/unpinned timers/workqueues
away from the CPUs of the cpuset in question. Writing '0' has no effect and this
file can't be read from userspace as we aren't maintaining a state here.

Currently, only timers are migrated. This would be followed by other kernel
infrastructure later.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/cpuset.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3d54c41..1b79ae6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -43,10 +43,12 @@
 #include <linux/pagemap.h>
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
+#include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/security.h>
 #include <linux/slab.h>
+#include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/string.h>
@@ -150,6 +152,7 @@ typedef enum {
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
+	CS_QUIESCE,
 } cpuset_flagbits_t;
 
 /* convenient tests for these bits */
@@ -1208,6 +1211,44 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 	return 0;
 }
 
+void timer_quiesce_cpu(void *cpu);
+
+/**
+ * quiesce_cpuset - Move unbound timers/workqueues away from cpuset.cpus
+ * @cs: cpuset to be quiesced
+ *
+ * For isolating a core with cpusets we require all unbound timers/workqueues to
+ * move away for isolated core. For simplicity, currently we migrate these to
+ * the first online CPU which is not part of tick_nohz_full_mask.
+ *
+ * Currently we are only migrating timers away.
+ */
+void quiesce_cpuset(struct cpuset *cs)
+{
+	int from_cpu, to_cpu;
+	cpumask_t cpumask;
+
+	cpumask_andnot(&cpumask, cpu_online_mask, cs->cpus_allowed);
+
+#ifdef CONFIG_NO_HZ_FULL
+	cpumask_andnot(&cpumask, &cpumask, tick_nohz_full_mask);
+#endif
+
+	if (cpumask_empty(&cpumask)) {
+		pr_err("%s: Couldn't find a CPU to migrate to\n", __func__);
+		return;
+	}
+
+	to_cpu = cpumask_first(&cpumask);
+
+	for_each_cpu(from_cpu, cs->cpus_allowed) {
+		pr_debug("%s: Migrating from CPU:%d to CPU:%d\n", __func__,
+				from_cpu, to_cpu);
+		smp_call_function_single(to_cpu, timer_quiesce_cpu,
+				(void *)from_cpu, true);
+	}
+}
+
 /**
  * update_tasks_flags - update the spread flags of tasks in the cpuset.
  * @cs: the cpuset in which each task's spread flags needs to be changed
@@ -1244,6 +1285,11 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	int spread_flag_changed;
 	int err;
 
+	if (bit == CS_QUIESCE && turning_on) {
+		quiesce_cpuset(cs);
+		return 0;
+	}
+
 	trialcs = alloc_trial_cpuset(cs);
 	if (!trialcs)
 		return -ENOMEM;
@@ -1526,6 +1572,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_CPU_QUIESCE,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1569,6 +1616,9 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+	case FILE_CPU_QUIESCE:
+		retval = update_flag(CS_QUIESCE, cs, val);
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1837,6 +1887,12 @@ static struct cftype files[] = {
 		.private = FILE_MEMORY_PRESSURE_ENABLED,
 	},
 
+	{
+		.name = "quiesce",
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_CPU_QUIESCE,
+	},
+
 	{ }	/* terminate */
 };
 
-- 
1.7.12.rc2.18.g61b472e
