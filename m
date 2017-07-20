From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/2] sched: Implement interface for cgroup unified hierarchy
Date: Thu, 20 Jul 2017 14:48:08 -0400
Message-ID: <20170720184808.1433868-3-tj@kernel.org>
References: <20170720184808.1433868-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=56mHQCz0imB6so57L1KZ9nglOAioeAjOKIeUe5o5YkU=;
        b=MG56dL/Sbn/RRr9e8qxRc0Maw82GB74HeFxWrZH+F3cI2r2ov9qK8/AZfQuSKz3ozF
         8HHM5T3ZTt+0jBZt+/YQ4smItxtkV3KK4fckh6VsSoe5QXakcvxbLzJMnJadNxrwVFsG
         hocwtpx+KK48kccccqO4K/ig6YLssACcm2JYmBlq+H+I+LBUx5kEbunRZa4abWMhUGmk
         2ERaLuP4UTk9hpJ5+CPIEXoMaNIaQ2Yi/xajIocy+OCg1MgYGVg+2aynOqPP0D0PNIkw
         up+ekzuiI9JUoA8ZR2K3qklqmnGOgJSX/QlGxTldKh/Svuj+rtUPviv7HcjPjzVGup6y
         vBiA==
In-Reply-To: <20170720184808.1433868-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

There are a couple interface issues which can be addressed in cgroup2
interface.

* Stats from cpuacct being reported separately from the cpu stats.

* Use of different time units.  Writable control knobs use
  microseconds, some stat fields use nanoseconds while other cpuacct
  stat fields use centiseconds.

* Control knobs which can't be used in the root cgroup still show up
  in the root.

* Control knob names and semantics aren't consistent with other
  controllers.

This patchset implements cpu controller's interface on cgroup2 which
adheres to the controller file conventions described in
Documentation/cgroups/cgroup-v2.txt.  Overall, the following changes
are made.

* cpuacct is implictly enabled and disabled by cpu and its information
  is reported through "cpu.stat" which now uses microseconds for all
  time durations.  All time duration fields now have "_usec" appended
  to them for clarity.

  Note that cpuacct.usage_percpu is currently not included in
  "cpu.stat".  If this information is actually called for, it will be
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

* "cpu.weight.nice" is added. When read, it reads back the nice value
  which is closest to the current "cpu.weight".  When written, it sets
  "cpu.weight" to the weight value which matches the nice value.  This
  makes it easy to configure cgroups when they're competing against
  threads in threaded subtrees.

* "cpu.cfs_quota_us" and "cpu.cfs_period_us" are replaced by "cpu.max"
  which contains both quota and period.

* "cpu.rt_runtime_us" and "cpu.rt_period_us" are replaced by
  "cpu.rt.max" which contains both runtime and period.

v3: - Added "cpu.weight.nice" to allow using nice values when
      configuring the weight.  The feature is requested by PeterZ.
    - Merge the patch to enable threaded support on cpu and cpuacct.
    - Dropped the bits about getting rid of cpuacct from patch
      description as there is a pretty strong case for making cpuacct
      an implicit controller so that basic cpu usage stats are always
      available.
    - Documentation updated accordingly.  "cpu.rt.max" section is
      dropped for now.

v2: - cpu_stats_show() was incorrectly using CONFIG_FAIR_GROUP_SCHED
      for CFS bandwidth stats and also using raw division for u64.
      Use CONFIG_CFS_BANDWITH and do_div() instead.  "cpu.rt.max" is
      not included yet.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroup-v2.txt |  36 +++------
 kernel/sched/core.c         | 178 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/cpuacct.c      |  24 ++++++
 kernel/sched/cpuacct.h      |   5 ++
 4 files changed, 219 insertions(+), 24 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index cb9ea28..43f9811 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -860,10 +860,6 @@ Controllers
 CPU
 ---
 
-.. note::
-
-	The interface for the cpu controller hasn't been merged yet
-
 The "cpu" controllers regulates distribution of CPU cycles.  This
 controller implements weight and absolute bandwidth limit models for
 normal scheduling policy and absolute bandwidth allocation model for
@@ -893,6 +889,18 @@ All time durations are in microseconds.
 
 	The weight in the range [1, 10000].
 
+  cpu.weight.nice
+	A read-write single value file which exists on non-root
+	cgroups.  The default is "0".
+
+	The nice value is in the range [-20, 19].
+
+	This interface file is an alternative interface for
+	"cpu.weight" and allows reading and setting weight using the
+	same values used by nice(2).  Because the range is smaller and
+	granularity is coarser for the nice values, the read value is
+	the closest approximation of the current weight.
+
   cpu.max
 	A read-write two value file which exists on non-root cgroups.
 	The default is "max 100000".
@@ -905,26 +913,6 @@ All time durations are in microseconds.
 	$PERIOD duration.  "max" for $MAX indicates no limit.  If only
 	one number is written, $MAX is updated.
 
-  cpu.rt.max
-	.. note::
-
-	   The semantics of this file is still under discussion and the
-	   interface hasn't been merged yet
-
-	A read-write two value file which exists on all cgroups.
-	The default is "0 100000".
-
-	The maximum realtime runtime allocation.  Over-committing
-	configurations are disallowed and process migrations are
-	rejected if not enough bandwidth is available.  It's in the
-	following format::
-
-	  $MAX $PERIOD
-
-	which indicates that the group may consume upto $MAX in each
-	$PERIOD duration.  If only one number is written, $MAX is
-	updated.
-
 
 Memory
 ------
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 71a060f..9766670 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6657,6 +6657,175 @@ static struct cftype cpu_legacy_files[] = {
 	{ }	/* Terminate */
 };
 
+static int cpu_stats_show(struct seq_file *sf, void *v)
+{
+	cpuacct_cpu_stats_show(sf);
+
+#ifdef CONFIG_CFS_BANDWIDTH
+	{
+		struct task_group *tg = css_tg(seq_css(sf));
+		struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
+		u64 throttled_usec;
+
+		throttled_usec = cfs_b->throttled_time;
+		do_div(throttled_usec, NSEC_PER_USEC);
+
+		seq_printf(sf, "nr_periods %d\n"
+			   "nr_throttled %d\n"
+			   "throttled_usec %llu\n",
+			   cfs_b->nr_periods, cfs_b->nr_throttled,
+			   throttled_usec);
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
+				struct cftype *cft, u64 weight)
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
+
+static s64 cpu_weight_nice_read_s64(struct cgroup_subsys_state *css,
+				    struct cftype *cft)
+{
+	unsigned long weight = scale_load_down(css_tg(css)->shares);
+	int last_delta = INT_MAX;
+	int prio, delta;
+
+	/* find the closest nice value to the current weight */
+	for (prio = 0; prio < ARRAY_SIZE(sched_prio_to_weight); prio++) {
+		delta = abs(sched_prio_to_weight[prio] - weight);
+		if (delta >= last_delta)
+			break;
+		last_delta = delta;
+	}
+
+	return PRIO_TO_NICE(prio - 1 + MAX_RT_PRIO);
+}
+
+static int cpu_weight_nice_write_s64(struct cgroup_subsys_state *css,
+				     struct cftype *cft, s64 nice)
+{
+	unsigned long weight;
+
+	if (nice < MIN_NICE || nice > MAX_NICE)
+		return -ERANGE;
+
+	weight = sched_prio_to_weight[NICE_TO_PRIO(nice) - MAX_RT_PRIO];
+	return sched_group_set_shares(css_tg(css), scale_load(weight));
+}
+#endif
+
+static void __maybe_unused cpu_period_quota_print(struct seq_file *sf,
+						  long period, long quota)
+{
+	if (quota < 0)
+		seq_puts(sf, "max");
+	else
+		seq_printf(sf, "%ld", quota);
+
+	seq_printf(sf, " %ld\n", period);
+}
+
+/* caller should put the current value in *@periodp before calling */
+static int __maybe_unused cpu_period_quota_parse(char *buf,
+						 u64 *periodp, u64 *quotap)
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
+#ifdef CONFIG_CFS_BANDWIDTH
+static int cpu_max_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+
+	cpu_period_quota_print(sf, tg_get_cfs_period(tg), tg_get_cfs_quota(tg));
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
+	ret = cpu_period_quota_parse(buf, &period, &quota);
+	if (!ret)
+		ret = tg_set_cfs_bandwidth(tg, period, quota);
+	return ret ?: nbytes;
+}
+#endif
+
+static struct cftype cpu_files[] = {
+	{
+		.name = "stat",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cpu_stats_show,
+	},
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	{
+		.name = "weight",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_u64 = cpu_weight_read_u64,
+		.write_u64 = cpu_weight_write_u64,
+	},
+	{
+		.name = "weight.nice",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.read_s64 = cpu_weight_nice_read_s64,
+		.write_s64 = cpu_weight_nice_write_s64,
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
+	{ }	/* terminate */
+};
+
 struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_alloc	= cpu_cgroup_css_alloc,
 	.css_online	= cpu_cgroup_css_online,
@@ -6666,7 +6835,16 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
 	.legacy_cftypes	= cpu_legacy_files,
+	.dfl_cftypes	= cpu_files,
 	.early_init	= true,
+	.threaded	= true,
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
index 6151c23..ee4976a 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -347,6 +347,29 @@ static struct cftype files[] = {
 	{ }	/* terminate */
 };
 
+/* used to print cpuacct stats in cpu.stat on the unified hierarchy */
+void cpuacct_cpu_stats_show(struct seq_file *sf)
+{
+	struct cgroup_subsys_state *css;
+	u64 usage, val[CPUACCT_STAT_NSTATS];
+
+	css = cgroup_get_e_css(seq_css(sf)->cgroup, &cpuacct_cgrp_subsys);
+
+	usage = cpuusage_read(css, seq_cft(sf));
+	cpuacct_stats_read(css_ca(css), &val);
+
+	do_div(usage, NSEC_PER_USEC);
+	do_div(val[CPUACCT_STAT_USER], NSEC_PER_USEC);
+	do_div(val[CPUACCT_STAT_SYSTEM], NSEC_PER_USEC);
+
+	seq_printf(sf, "usage_usec %llu\n"
+		   "user_usec %llu\n"
+		   "system_usec %llu\n",
+		   usage, val[CPUACCT_STAT_USER], val[CPUACCT_STAT_SYSTEM]);
+
+	css_put(css);
+}
+
 /*
  * charge this task's execution time to its accounting group.
  *
@@ -389,4 +412,5 @@ struct cgroup_subsys cpuacct_cgrp_subsys = {
 	.css_free	= cpuacct_css_free,
 	.legacy_cftypes	= files,
 	.early_init	= true,
+	.threaded	= true,
 };
diff --git a/kernel/sched/cpuacct.h b/kernel/sched/cpuacct.h
index ba72807..ddf7af4 100644
--- a/kernel/sched/cpuacct.h
+++ b/kernel/sched/cpuacct.h
@@ -2,6 +2,7 @@
 
 extern void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 extern void cpuacct_account_field(struct task_struct *tsk, int index, u64 val);
+extern void cpuacct_cpu_stats_show(struct seq_file *sf);
 
 #else
 
@@ -14,4 +15,8 @@ cpuacct_account_field(struct task_struct *tsk, int index, u64 val)
 {
 }
 
+static inline void cpuacct_cpu_stats_show(struct seq_file *sf)
+{
+}
+
 #endif
-- 
2.9.3

