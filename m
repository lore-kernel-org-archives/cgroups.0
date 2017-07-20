From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2] sched: Misc preps for cgroup unified hierarchy interface
Date: Thu, 20 Jul 2017 14:48:07 -0400
Message-ID: <20170720184808.1433868-2-tj@kernel.org>
References: <20170720184808.1433868-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yFiGF3Ae1ny5xhg3uibUCIUaOHJG4iaKLMtngESfWt8=;
        b=hOmutXPHz97ejz/pBGNo1bMpjgEuON/y7bZ4JEz7cIT/oA18JFae57ld24kNsJ0Eb/
         YrelbOBUut6GYZ06KVoanRtPWOckUqkh2zTIqznA0OnWdlBH+0wxAJbXZKgmKgoDUYAA
         1/NGaxh57Y8r02rhqY8AmvMGaW2GylmBWwnQAPGIsq53T2WnBvORJzHou6fxvXp/4L/M
         xKKehM2TT9gYeaDBJt58987fazfSW9S/JPEoon8qpmlp4kBRPD69RhZADxPJBOAavrL8
         xBvlYNhi2obMIxAzYPvOCeIcSk4tfM/upjOC5wmPRXzk7e6W5ho1y/ATXRiA4SA0JvlY
         83KA==
In-Reply-To: <20170720184808.1433868-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

Make the following changes in preparation for the cpu controller
interface implementation for cgroup2.  This patch doesn't cause any
functional differences.

* s/cpu_stats_show()/cpu_cfs_stats_show()/

* s/cpu_files/cpu_legacy_files/

* Separate out cpuacct_stats_read() from cpuacct_stats_show().  While
  at it, make the @val array u64 for consistency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 kernel/sched/core.c    |  8 ++++----
 kernel/sched/cpuacct.c | 29 ++++++++++++++++++-----------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 17c667b..71a060f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6578,7 +6578,7 @@ static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
 	return ret;
 }
 
-static int cpu_stats_show(struct seq_file *sf, void *v)
+static int cpu_cfs_stats_show(struct seq_file *sf, void *v)
 {
 	struct task_group *tg = css_tg(seq_css(sf));
 	struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
@@ -6618,7 +6618,7 @@ static u64 cpu_rt_period_read_uint(struct cgroup_subsys_state *css,
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
-static struct cftype cpu_files[] = {
+static struct cftype cpu_legacy_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
@@ -6639,7 +6639,7 @@ static struct cftype cpu_files[] = {
 	},
 	{
 		.name = "stat",
-		.seq_show = cpu_stats_show,
+		.seq_show = cpu_cfs_stats_show,
 	},
 #endif
 #ifdef CONFIG_RT_GROUP_SCHED
@@ -6665,7 +6665,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
-	.legacy_cftypes	= cpu_files,
+	.legacy_cftypes	= cpu_legacy_files,
 	.early_init	= true,
 };
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index f95ab29..6151c23 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -276,26 +276,33 @@ static int cpuacct_all_seq_show(struct seq_file *m, void *V)
 	return 0;
 }
 
-static int cpuacct_stats_show(struct seq_file *sf, void *v)
+static void cpuacct_stats_read(struct cpuacct *ca,
+			       u64 (*val)[CPUACCT_STAT_NSTATS])
 {
-	struct cpuacct *ca = css_ca(seq_css(sf));
-	s64 val[CPUACCT_STAT_NSTATS];
 	int cpu;
-	int stat;
 
-	memset(val, 0, sizeof(val));
+	memset(val, 0, sizeof(*val));
+
 	for_each_possible_cpu(cpu) {
 		u64 *cpustat = per_cpu_ptr(ca->cpustat, cpu)->cpustat;
 
-		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
-		val[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
-		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SYSTEM];
-		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_IRQ];
-		val[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SOFTIRQ];
+		(*val)[CPUACCT_STAT_USER]   += cpustat[CPUTIME_USER];
+		(*val)[CPUACCT_STAT_USER]   += cpustat[CPUTIME_NICE];
+		(*val)[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SYSTEM];
+		(*val)[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_IRQ];
+		(*val)[CPUACCT_STAT_SYSTEM] += cpustat[CPUTIME_SOFTIRQ];
 	}
+}
+
+static int cpuacct_stats_show(struct seq_file *sf, void *v)
+{
+	u64 val[CPUACCT_STAT_NSTATS];
+	int stat;
+
+	cpuacct_stats_read(css_ca(seq_css(sf)), &val);
 
 	for (stat = 0; stat < CPUACCT_STAT_NSTATS; stat++) {
-		seq_printf(sf, "%s %lld\n",
+		seq_printf(sf, "%s %llu\n",
 			   cpuacct_stat_desc[stat],
 			   (long long)nsec_to_clock_t(val[stat]));
 	}
-- 
2.9.3

