From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon,  3 Aug 2015 18:41:29 -0400
Message-ID: <1438641689-14655-4-git-send-email-tj@kernel.org>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JnQrP86TStuQDYlY1ZDYLm5aATQRJ0y3RdS7tztNHPM=;
        b=IXLc6se1BQKfHDPEOy+eU9GCY6Ge+GLJrixEgKkgZ0GnJ4FQNi3bhJDeNGSgXjJnXX
         roayOEWnhuOLHHblx5BD+4zrpLdtBaV8Ntt99IJC4h29aM6Z64ckzw3wE8OVBlCo1kIh
         7yfNwd/WauIhf2bPcJBoXEP7qnhbPsm1BfnaIdpK6Zhw6IVXFXiEPC7z3evTWnkYFrwy
         r+9by/xeNrYiG6ugkD8I1t+A89TSMr4WgXStWLBHhf4csp5hZeNnEeYIRAh5PqxxA9OG
         gmEdeiio5So07s+R+CVPEPKWpQ04H7wUGfwIXkvbeY0vLt27Eiqbh3WsOydklO6DAqGb
         NS3w==
In-Reply-To: <1438641689-14655-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo@redhat.com, peterz@infradead.org
Cc: hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

While the cpu controller doesn't have any functional problems, there
are a couple interface issues which can be addressed in the v2
interface.

* cpuacct being a separate controller.  This separation is artificial
  and rather pointless as demonstrated by most use cases co-mounting
  the two controllers.  It also forces certain information to be
  accounted twice.

* Use of different time units.  Writable control knobs use
  microseconds, some stat fields use nanoseconds while other cpuacct
  stat fields use centiseconds.

* Control knobs which can't be used in the root cgroup still show up
  in the root.

* Control knob names and semantics aren't consistent with other
  controllers.

This patchset implements cpu controller's interface on the unified
hierarchy which adheres to the controller file conventions described
in Documentation/cgroups/unified-hierarchy.txt.  Overall, the
following changes are made.

* cpuacct is implictly enabled and disabled by cpu and its information
  is reported through "cpu.stat" which now uses microseconds for all
  time durations.  All time duration fields now have "_usec" appended
  to them for clarity.  While this doesn't solve the double accounting
  immediately, once majority of users switch to v2, cpu can directly
  account and report the relevant stats and cpuacct can be disabled on
  the unified hierarchy.

  Note that cpuacct.usage_percpu is currently not included in
  "cpu.stat".  If this information is actually called for, it can be
  added later.

* "cpu.shares" is replaced with "cpu.weight" and operates on the
  standard scale defined by CGROUP_WEIGHT_MIN/DFL/MAX (1, 100, 10000).
  The weight is scaled to scheduler weight so that 100 maps to 1024
  and the ratio relationship is preserved - if weight is W and its
  scaled value is S, W / 100 == S / 1024.  While the mapped range is a
  bit smaller than the orignal scheduler weight range, the dead zones
  on both sides are relatively small and covers wider range than the
  nice value mappings.  This file doesn't make sense in the root
  cgroup and isn't create on root.

* "cpu.cfs_quota_us" and "cpu.cfs_period_us" are replaced by "cpu.max"
  which contains both quota and period.

* "cpu.rt_runtime_us" and "cpu.rt_period_us" are replaced by
  "cpu.rt.max" which contains both runtime and period.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  53 +++++++++
 kernel/sched/core.c                         | 165 ++++++++++++++++++++++++++++
 kernel/sched/cpuacct.c                      |  24 ++++
 kernel/sched/cpuacct.h                      |   5 +
 4 files changed, 247 insertions(+)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index fc372b8..24c3e89 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -30,6 +30,7 @@ CONTENTS
     5-4-1. blkio
     5-4-2. cpuset
     5-4-3. memory
+    5-4-4. cpu, cpuacct
 6. Planned Changes
   6-1. CAP for resource control
 
@@ -532,6 +533,58 @@ may be specified in any order and not all pairs have to be specified.
   memory.low, memory.high, and memory.max will use the string "max" to
   indicate and set the highest possible value.
 
+5-4-4. cpu, cpuacct
+
+- cpuacct is no longer an independent controller.  It's implicitly
+  enabled by cpu and its information is reported in cpu.stat.
+
+- All time durations, including all stats, are now in microseconds.
+
+- The interface is updated as follows.
+
+  cpu.stat
+
+	Currently reports the following six stats.  All time stats are
+	in microseconds.
+
+	  usage_usec
+	  user_usec
+	  system_usec
+	  nr_periods
+	  nr_throttled
+	  throttled_usec
+
+  cpu.weight
+
+	The weight setting.  The weight is between 1 and 10000 and
+	defaults to 100.
+
+	This file is available only on non-root cgroups.
+
+  cpu.max
+
+	The maximum bandwidth setting.  It's in the following format.
+
+	  $MAX $PERIOD
+
+	which indicates that the group may consume upto $MAX in each
+	$PERIOD duration.  "max" for $MAX indicates no limit.  If only
+	one number is written, $MAX is updated.
+
+	This file is available only on non-root cgroups.
+
+  cpu.rt.max
+
+	The maximum realtime runtime setting.  It's in the following
+	format.
+
+	  $MAX $PERIOD
+
+	which indicates that the group may consume upto $MAX in each
+	$PERIOD duration.  If only one number is written, $MAX is
+	updated.
+
+
 6. Planned Changes
 
 6-1. CAP for resource control
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6137037..0fb1dd7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8438,6 +8438,163 @@ static struct cftype cpu_legacy_files[] = {
 	{ }	/* terminate */
 };
 
+static int cpu_stats_show(struct seq_file *sf, void *v)
+{
+	cpuacct_cpu_stats_show(sf);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	{
+		struct task_group *tg = css_tg(seq_css(sf));
+		struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+
+		seq_printf(sf, "nr_periods %d\n"
+			   "nr_throttled %d\n"
+			   "throttled_usec %llu\n",
+			   cfs_b->nr_periods, cfs_b->nr_throttled,
+			   cfs_b->throttled_time / NSEC_PER_USEC);
+	}
+#endif
+	return 0;
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static u64 cpu_weight_read_u64(struct cgroup_subsys_state *css,
+			       struct cftype *cft)
+{
+	struct task_group *tg = css_tg(css);
+	u64 weight = scale_load_down(tg->shares);
+
+	return DIV_ROUND_CLOSEST_ULL(weight * CGROUP_WEIGHT_DFL, 1024);
+}
+
+static int cpu_weight_write_u64(struct cgroup_subsys_state *css,
+				struct cftype *cftype, u64 weight)
+{
+	/*
+	 * cgroup weight knobs should use the common MIN, DFL and MAX
+	 * values which are 1, 100 and 10000 respectively.  While it loses
+	 * a bit of range on both ends, it maps pretty well onto the shares
+	 * value used by scheduler and the round-trip conversions preserve
+	 * the original value over the entire range.
+	 */
+	if (weight < CGROUP_WEIGHT_MIN || weight > CGROUP_WEIGHT_MAX)
+		return -ERANGE;
+
+	weight = DIV_ROUND_CLOSEST_ULL(weight * 1024, CGROUP_WEIGHT_DFL);
+
+	return sched_group_set_shares(css_tg(css), scale_load(weight));
+}
+#endif
+
+/* caller should put the current value in *@periodp before calling */
+static int __maybe_unused cpu_max_parse(char *buf, u64 *periodp, u64 *quotap)
+{
+	char tok[21];	/* U64_MAX */
+
+	if (!sscanf(buf, "%s %llu", tok, periodp))
+		return -EINVAL;
+
+	*periodp *= NSEC_PER_USEC;
+
+	if (sscanf(tok, "%llu", quotap))
+		*quotap *= NSEC_PER_USEC;
+	else if (!strcmp(tok, "max"))
+		*quotap = RUNTIME_INF;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __maybe_unused cpu_max_print(struct seq_file *sf, long period,
+					 long quota)
+{
+	if (quota < 0)
+		seq_puts(sf, "max");
+	else
+		seq_printf(sf, "%ld", quota);
+
+	seq_printf(sf, " %ld\n", period);
+}
+
+#ifdef CONFIG_CFS_BANDWIDTH
+static int cpu_max_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+
+	cpu_max_print(sf, tg_get_cfs_period(tg), tg_get_cfs_quota(tg));
+	return 0;
+}
+
+static ssize_t cpu_max_write(struct kernfs_open_file *of,
+			     char *buf, size_t nbytes, loff_t off)
+{
+	struct task_group *tg = css_tg(of_css(of));
+	u64 period = tg_get_cfs_period(tg);
+	u64 quota;
+	int ret;
+
+	ret = cpu_max_parse(buf, &period, &quota);
+	if (!ret)
+		ret = tg_set_cfs_bandwidth(tg, period, quota);
+	return ret ?: nbytes;
+}
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+static int cpu_rt_max_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+
+	cpu_max_print(sf, sched_group_rt_period(tg), sched_group_rt_runtime(tg));
+	return 0;
+}
+
+static ssize_t cpu_rt_max_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct task_group *tg = css_tg(of_css(of));
+	u64 period = sched_group_rt_period(tg);
+	u64 runtime;
+	int ret;
+
+	ret = cpu_max_parse(buf, &period, &runtime);
+	if (!ret)
+		ret = tg_set_rt_bandwidth(tg, period, runtime);
+	return ret ?: nbytes;
+}
+#endif
+
+static struct cftype cpu_files[] = {
+	{
+		.name = "stat",
+		.seq_show = cpu_stats_show,
+	},
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	{
+		.name = "weight",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_weight_read_u64,
+		.write_u64 = cpu_weight_write_u64,
+	},
+#endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		.name = "max",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cpu_max_show,
+		.write = cpu_max_write,
+	},
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	{
+		.name = "rt.max",
+		.seq_show = cpu_rt_max_show,
+		.write = cpu_rt_max_write,
+	},
+#endif
+	{ }	/* terminate */
+};
+
 struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_alloc	= cpu_cgroup_css_alloc,
 	.css_free	= cpu_cgroup_css_free,
@@ -8448,7 +8605,15 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.attach		= cpu_cgroup_attach,
 	.exit		= cpu_cgroup_exit,
 	.legacy_cftypes	= cpu_legacy_files,
+	.dfl_cftypes	= cpu_files,
 	.early_init	= 1,
+#ifdef CONFIG_CGROUP_CPUACCT
+	/*
+	 * cpuacct is enabled together with cpu on the unified hierarchy
+	 * and its stats are reported through "cpu.stat".
+	 */
+	.depends_on	= 1 << cpuacct_cgrp_id,
+#endif
 };
 
 #endif	/* CONFIG_CGROUP_SCHED */
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 42b2dd5..b4d32a6 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -224,6 +224,30 @@ static struct cftype files[] = {
 	{ }	/* terminate */
 };
 
+/* used to print cpuacct stats in cpu.stat on the unified hierarchy */
+void cpuacct_cpu_stats_show(struct seq_file *sf)
+{
+	struct cgroup_subsys_state *css;
+	u64 usage, user, sys;
+
+	css = cgroup_get_e_css(seq_css(sf)->cgroup, &cpuacct_cgrp_subsys);
+
+	usage = cpuusage_read(css, seq_cft(sf));
+	cpuacct_stats_read(css_ca(css), &user, &sys);
+
+	user *= TICK_NSEC;
+	sys *= TICK_NSEC;
+	do_div(usage, NSEC_PER_USEC);
+	do_div(user, NSEC_PER_USEC);
+	do_div(sys, NSEC_PER_USEC);
+
+	seq_printf(sf, "usage_usec %llu\n"
+		   "user_usec %llu\n"
+		   "system_usec %llu\n", usage, user, sys);
+
+	css_put(css);
+}
+
 /*
  * charge this task's execution time to its accounting group.
  *
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index ed60562..44eace9 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -2,6 +2,7 @@
 
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 extern void cpuacct_account_field(struct task_struct *p, int index, u64 val);
+extern void cpuacct_cpu_stats_show(struct seq_file *sf);
 
 #else
 
@@ -14,4 +15,8 @@ cpuacct_account_field(struct task_struct *p, int index, u64 val)
 {
 }
 
+static inline void cpuacct_cpu_stats_show(struct seq_file *sf)
+{
+}
+
 #endif
-- 
2.4.3
