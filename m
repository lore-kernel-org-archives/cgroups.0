From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 7/8] cpuset: Create sysfs file: cpusets.quiesce to isolate CPUs
Date: Fri,  4 Apr 2014 14:05:34 +0530
Message-ID: <977126350594ff25c5b7f9e8a42331872c657fdc.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org, Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

For networking applications, platforms need to provide one CPU per each user
space data plane thread. These CPUs shouldn't be interrupted by kernel at all
unless userspace has requested for some functionality. Currently, there are
background kernel activities that are running on almost every CPU, like:
timers/hrtimers/watchdogs/etc, and these are required to be migrated to other
CPUs.

To achieve that, this patch adds another option to cpusets, i.e. 'quiesce'.
Writing '1' on this file would migrate these unbound/unpinned timers/hrtimers
away from the CPUs of the cpuset in question. Also it would disallow addition of
any new unpinned timers/hrtimers to isolated CPUs (This would be handled in next
patch). Writing '0' will disable isolation of CPUs in current cpuset and
unpinned timers/hrtimers would be allowed in future on these CPUs.

Currently, only timers and hrtimers are migrated. This would be followed by
other kernel infrastructure later if required.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cgroups/cpusets.txt | 19 ++++++++--
 include/linux/cpuset.h            |  8 +++++
 kernel/cpuset.c                   | 76 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 7740038..8c1078b 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -22,7 +22,8 @@ CONTENTS:
   1.6 What is memory spread ?
   1.7 What is sched_load_balance ?
   1.8 What is sched_relax_domain_level ?
-  1.9 How do I use cpusets ?
+  1.9 What is quiesce?
+  1.10 How do I use cpusets ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Adding/removing cpus
@@ -581,7 +582,21 @@ If your situation is:
 then increasing 'sched_relax_domain_level' would benefit you.
 
 
-1.9 How do I use cpusets ?
+1.9 What is quiesce ?
+--------------------------------------
+We need to migrate away all the background kernel activities (Unbound) for
+systems requiring isolation of cores (HPC, Real time, networking, etc). After
+creating cpusets, you can write 1 or 0 to cpuset.quiesce file.
+
+Writing '1': on this file would migrate unbound/unpinned timers and hrtimers
+away from the CPUs of the cpuset in question. Also it would disallow addition of
+any new unpinned timers & hrtimers to isolated CPUs.
+
+Writing '0': will disable isolation of CPUs in current cpuset and unpinned
+timers/hrtimers would be allowed in future on these CPUs.
+
+
+1.10 How do I use cpusets ?
 --------------------------
 
 In order to minimize the impact of cpusets on critical kernel
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 3fe661f..1ce0775 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -15,6 +15,13 @@
 
 #ifdef CONFIG_CPUSETS
 
+extern cpumask_var_t cpuset_quiesced_cpus_mask;
+
+static inline bool cpu_quiesced(int cpu)
+{
+	return cpumask_test_cpu(cpu, cpuset_quiesced_cpus_mask);
+}
+
 extern int number_of_cpusets;	/* How many cpusets are defined in system? */
 
 extern int cpuset_init(void);
@@ -123,6 +130,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 
 #else /* !CONFIG_CPUSETS */
 
+static inline bool cpu_quiesced(int cpu) { return 0; }
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4410ac6..256cf11 100644
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
@@ -193,6 +196,14 @@ static inline int is_spread_slab(const struct cpuset *cs)
 	return test_bit(CS_SPREAD_SLAB, &cs->flags);
 }
 
+static inline int is_cpu_quiesced(const struct cpuset *cs)
+{
+	return test_bit(CS_QUIESCE, &cs->flags);
+}
+
+/* Mask of CPUs which have requested isolation */
+cpumask_var_t cpuset_quiesced_cpus_mask;
+
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_ONLINE) | (1 << CS_CPU_EXCLUSIVE) |
 		  (1 << CS_MEM_EXCLUSIVE)),
@@ -1261,6 +1272,53 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 }
 
 /**
+ * quiesce_cpuset - Move unbound timers/hrtimers away from cpuset.cpus
+ * @cs: cpuset to be quiesced
+ *
+ * For isolating a core with cpusets we require all unbound timers/hrtimers to
+ * move away from isolated core. We migrate these to one of the CPUs which
+ * hasn't isolated itself yet. And the CPU is selected by
+ * smp_call_function_any() routine.
+ *
+ * Currently we are only migrating timers and hrtimers away.
+ */
+static int quiesce_cpuset(struct cpuset *cs, int turning_on)
+{
+	int from_cpu;
+	cpumask_t cpumask;
+
+	/* Fail if we are already in the requested state */
+	if (!(is_cpu_quiesced(cs) ^ turning_on))
+		return -EINVAL;
+
+	if (!turning_on) {
+		cpumask_andnot(cpuset_quiesced_cpus_mask,
+			       cpuset_quiesced_cpus_mask, cs->cpus_allowed);
+		return 0;
+	}
+
+	cpumask_andnot(&cpumask, cpu_online_mask, cs->cpus_allowed);
+	cpumask_andnot(&cpumask, &cpumask, cpuset_quiesced_cpus_mask);
+
+	if (cpumask_empty(&cpumask)) {
+		pr_err("%s: Couldn't find a CPU to migrate to\n", __func__);
+		return -EPERM;
+	}
+
+	cpumask_or(cpuset_quiesced_cpus_mask, cpuset_quiesced_cpus_mask,
+		   cs->cpus_allowed);
+
+	for_each_cpu(from_cpu, cs->cpus_allowed) {
+		smp_call_function_any(&cpumask, hrtimer_quiesce_cpu, &from_cpu,
+				      1);
+		smp_call_function_any(&cpumask, timer_quiesce_cpu, &from_cpu,
+				      1);
+	}
+
+	return 0;
+}
+
+/**
  * cpuset_change_flag - make a task's spread flags the same as its cpuset's
  * @tsk: task to be updated
  * @data: cpuset to @tsk belongs to
@@ -1326,6 +1384,9 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	if (err < 0)
 		goto out;
 
+	if (bit == CS_QUIESCE && quiesce_cpuset(cs, turning_on))
+		goto out;
+
 	err = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
 	if (err < 0)
 		goto out;
@@ -1597,6 +1658,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_CPU_QUIESCE,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1640,6 +1702,9 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	case FILE_SPREAD_SLAB:
 		retval = update_flag(CS_SPREAD_SLAB, cs, val);
 		break;
+	case FILE_CPU_QUIESCE:
+		retval = update_flag(CS_QUIESCE, cs, val);
+		break;
 	default:
 		retval = -EINVAL;
 		break;
@@ -1791,6 +1856,8 @@ static u64 cpuset_read_u64(struct cgroup_subsys_state *css, struct cftype *cft)
 		return is_spread_page(cs);
 	case FILE_SPREAD_SLAB:
 		return is_spread_slab(cs);
+	case FILE_CPU_QUIESCE:
+		return is_cpu_quiesced(cs);
 	default:
 		BUG();
 	}
@@ -1908,6 +1975,13 @@ static struct cftype files[] = {
 		.private = FILE_MEMORY_PRESSURE_ENABLED,
 	},
 
+	{
+		.name = "quiesce",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_CPU_QUIESCE,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -2065,6 +2139,8 @@ int __init cpuset_init(void)
 	if (!alloc_cpumask_var(&cpus_attach, GFP_KERNEL))
 		BUG();
 
+	BUG_ON(!zalloc_cpumask_var(&cpuset_quiesced_cpus_mask, GFP_KERNEL));
+
 	number_of_cpusets = 1;
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e
