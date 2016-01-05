From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] sched: Misc preps for cgroup unified hierarchy interface
Date: Tue, 5 Jan 2016 11:48:34 -0500
Message-ID: <20160105164834.GE5995@mtj.duckdns.org>
References: <20160105164758.GD5995@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+juRcL8yh8a4R6jfTmH0ROEa2oTiIak6n8ZslrODWkI=;
        b=RJ2q471GM1JG+Hr0etm+1xFcDQwKoXDx+k3zw+wV2wdWy09ltcMpWQtNmaS36hvwTf
         MrLjnFf9JaEMF0QGl/gTBc31gPSlhW6JL0LyvzeWDcrGFqGNPVjuJ+6jt6vAHkRgTzWA
         rbTnWyqxhC+qIR33GK/kbPEQWx08fMzd4dlpTkeav0ANUquJxFp4z5ZYteOc8/2G8UQB
         JDDxL1uDMXBeED9dKRgry+0oLscprar9iI2K+MGfrmv4pXyYS8pRiI5zTBDYyqoA2W+k
         nUapnMCxDE1QXODflWwR7YwTUIf6rRe3PtDWqxAmPTsC/cBesw4MxxRINlS72vLxBm1E
         KhYg==
Content-Disposition: inline
In-Reply-To: <20160105164758.GD5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Make the following changes in preparation for the cpu controller
interface implementation for the unified hierarchy.  This patch
doesn't cause any functional differences.

* s/cpu_stats_show()/cpu_cfs_stats_show()/

* s/cpu_files/cpu_legacy_files/

* Separate out cpuacct_stats_read() from cpuacct_stats_show().  While
  at it, remove pointless cpuacct_stat_desc[] array.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/sched/core.c    |    8 ++++----
 kernel/sched/cpuacct.c |   33 +++++++++++++++------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8488,7 +8488,7 @@ static int __cfs_schedulable(struct task
 	return ret;
 }
 
-static int cpu_stats_show(struct seq_file *sf, void *v)
+static int cpu_cfs_stats_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
@@ -8528,7 +8528,7 @@ static u64 cpu_rt_period_read_uint(struc
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static struct cftype cpu_files[] = {
+static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
@@ -8549,7 +8549,7 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = cpu_stats_show,
+		.seq_show = cpu_cfs_stats_show,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -8575,7 +8575,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.legacy_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= 1,
 };
 
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -177,36 +177,33 @@ static int cpuacct_percpu_seq_show(struc
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
 
