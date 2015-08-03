From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] sched: Misc preps for cgroup unified hierarchy interface
Date: Mon,  3 Aug 2015 18:41:28 -0400
Message-ID: <1438641689-14655-3-git-send-email-tj@kernel.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iUGB6JmRNz3mr+T/QZJh7PxwoAmTB8iGCN3FMwEW87Y=;
        b=w4g5IigExiwmlm2n9FBUOp+nWQ3J+KQdSrHRRDIi3gTosfiDV5SgkDRZxQ5la99lot
         ivZ/fJARFP5h5ogOfsNzI0aLmgO68rMGIdegQ75SeJ5PmFSfVoAt+4wTRgXkKMMdZjHm
         v6a1tsOD95qiQ2NmirsQ/e0K/7fCKuMItn6wMVHoXczZVXED0PM5JB6TOOESrGZUkVND
         U7kVJ4kObgOKx2OuBnKr+Is78REP+WE1daVqtWM7xP2Q0vmDNkcegZDI0M3Ce2rbHeWG
         MtcHRcbKLvwMpz23c5bNox64I67ZbS6oZfg6X1bKkftO8I1cHWP+/dxIC55s4JYBTNnN
         4awg==
In-Reply-To: <1438641689-14655-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo@redhat.com, peterz@infradead.org
Cc: hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Make the following changes in preparation for the cpu controller
interface implementation for the unified hierarchy.  This patch
doesn't cause any functional differences.

* s/cpu_stats_show()/cpu_cfs_stats_show()/

* s/cpu_files/cpu_legacy_files/

* Separate out cpuacct_stats_read() from cpuacct_stats_show().  While
  at it, remove pointless cpuacct_stat_desc[] array.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/core.c    |  8 ++++----
 kernel/sched/cpuacct.c | 33 +++++++++++++++------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 78b4bad10..6137037 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8359,7 +8359,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 	return ret;
 }
 
-static int cpu_stats_show(struct seq_file *sf, void *v)
+static int cpu_cfs_stats_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
@@ -8399,7 +8399,7 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static struct cftype cpu_files[] = {
+static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
@@ -8420,7 +8420,7 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = cpu_stats_show,
+		.seq_show = cpu_cfs_stats_show,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -8447,7 +8447,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
-	.legacy_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= 1,
 };
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index dd7cbb5..42b2dd5 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -177,36 +177,33 @@ static int cpuacct_percpu_seq_show(struct seq_file *m, void *V)
 	return 0;
 }
 
-static const char * const cpuacct_stat_desc[] = {
-	[CPUACCT_STAT_USER] = "user",
-	[CPUACCT_STAT_SYSTEM] = "system",
-};
-
-static int cpuacct_stats_show(struct seq_file *sf, void *v)
+static void cpuacct_stats_read(struct cpuacct *ca, u64 *userp, u64 *sysp)
 {
-	struct cpuacct *ca = css_ca(seq_css(sf));
 	int cpu;
-	s64 val = 0;
 
+	*userp = 0;
 	for_each_online_cpu(cpu) {
 		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_USER];
-		val += kcpustat->cpustat[CPUTIME_NICE];
+		*userp += kcpustat->cpustat[CPUTIME_USER];
+		*userp += kcpustat->cpustat[CPUTIME_NICE];
 	}
-	val = cputime64_to_clock_t(val);
-	seq_printf(sf, "%s %lld\n", cpuacct_stat_desc[CPUACCT_STAT_USER], val);
 
-	val = 0;
+	*sysp = 0;
 	for_each_online_cpu(cpu) {
 		struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
-		val += kcpustat->cpustat[CPUTIME_SYSTEM];
-		val += kcpustat->cpustat[CPUTIME_IRQ];
-		val += kcpustat->cpustat[CPUTIME_SOFTIRQ];
+		*sysp += kcpustat->cpustat[CPUTIME_SYSTEM];
+		*sysp += kcpustat->cpustat[CPUTIME_IRQ];
+		*sysp += kcpustat->cpustat[CPUTIME_SOFTIRQ];
 	}
+}
 
-	val = cputime64_to_clock_t(val);
-	seq_printf(sf, "%s %lld\n", cpuacct_stat_desc[CPUACCT_STAT_SYSTEM], val);
+static int cpuacct_stats_show(struct seq_file *sf, void *v)
+{
+	cputime64_t user, sys;
 
+	cpuacct_stats_read(css_ca(seq_css(sf)), &user, &sys);
+	seq_printf(sf, "user %lld\n", cputime64_to_clock_t(user));
+	seq_printf(sf, "system %lld\n", cputime64_to_clock_t(sys));
 	return 0;
 }
 
-- 
2.4.3
