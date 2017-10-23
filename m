From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.15] cgroup, sched: Move basic cpu stats from
 cgroup.stat to cpu.stat
Date: Mon, 23 Oct 2017 16:18:27 -0700
Message-ID: <20171023231827.GA8598@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=NqY9rK3XAZz9GCuOuwHfp5f3I8ZNOJQiIx6tlPJ0knc=;
        b=rDDC9R/gqzmKhpR2jiU4WLWkn/z2AlWrFpELS+gw/CXRvXHbmNUjS2y0G3U3I1mGZB
         VO3xz/iVvQpPSt/ce7UVwh9tfYTDq4p/IqRH0ZLB+kwL+fDYW/1mWvvELZCtoeoICjPa
         xXDzKshLAFA6y6wBLFQyLe5H9+Ml/4ZZLdWHQD4kSJ2A+SVTb1h4wVpm2bCtXR3Xfb6g
         2tEgPugbgjDPiA2hPdQTMJXWbElI7koTEn6YfrkG+PidQbLbuG80uXH2hvCevxV6p+Gd
         1obpNI1S9DsETyc9kfbGb8CMlQOjFAU11BCvk17M5osY32wcTlJqS1aaXPE0uiQVbAQ5
         aBKQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

The basic cpu stat is currently shown with "cpu." prefix in
cgroup.stat, and the same information is duplicated in cpu.stat when
cpu controller is enabled.  This is ugly and not very scalable as we
want to expand the coverage of stat information which is always
available.

This patch makes cgroup core always create "cpu.stat" file and show
the basic cpu stat there and calls the cpu controller to show the
extra stats when enabled.  This ensures that the same information
isn't presented in multiple places and makes future expansion of basic
stats easier.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello,

The more I think about showing cpu stat in cgroup.stat, the uglier it
seems.  This patch flips it so that "cpu.stat" is always available
with basic cpu stat instead.  It only changes the presentation and
changes to the scheduler code is minimal.  Will route with the other
cpu controller changes through cgroup/for-4.15 unless there are
objections.

Thanks!

 Documentation/cgroup-v2.txt     |   15 +++-------
 include/linux/cgroup-defs.h     |    2 +
 include/linux/cgroup.h          |    2 -
 kernel/cgroup/cgroup-internal.h |    1 
 kernel/cgroup/cgroup.c          |   60 ++++++++++++++++++++++++++++++++++++++--
 kernel/cgroup/stat.c            |   10 +++---
 kernel/sched/core.c             |   13 ++------
 7 files changed, 75 insertions(+), 28 deletions(-)

--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -886,15 +886,6 @@ All cgroup core files are prefixed with
 		A dying cgroup can consume system resources not exceeding
 		limits, which were active at the moment of cgroup deletion.
 
-	  cpu.usage_usec
-		CPU time consumed in the subtree.
-
-	  cpu.user_usec
-		User CPU time consumed in the subtree.
-
-	  cpu.system_usec
-		System CPU time consumed in the subtree.
-
 
 Controllers
 ===========
@@ -915,12 +906,16 @@ All time durations are in microseconds.
 
   cpu.stat
 	A read-only flat-keyed file which exists on non-root cgroups.
+	This file exists whether the controller is enabled or not.
 
-	It reports the following six stats:
+	It always reports the following three stats:
 
 	- usage_usec
 	- user_usec
 	- system_usec
+
+	and the following three when the controller is enabled:
+
 	- nr_periods
 	- nr_throttled
 	- throttled_usec
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -569,6 +569,8 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
+	int (*css_extra_stat_show)(struct seq_file *seq,
+				   struct cgroup_subsys_state *css);
 
 	int (*can_attach)(struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_taskset *tset);
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -703,8 +703,6 @@ static inline void cpuacct_account_field
 					 u64 val) {}
 #endif
 
-void cgroup_stat_show_cputime(struct seq_file *seq, const char *prefix);
-
 void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec);
 void __cgroup_account_cputime_field(struct cgroup *cgrp,
 				    enum cpu_usage_stat index, u64 delta_exec);
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -205,6 +205,7 @@ int cgroup_task_count(const struct cgrou
 void cgroup_stat_flush(struct cgroup *cgrp);
 int cgroup_stat_init(struct cgroup *cgrp);
 void cgroup_stat_exit(struct cgroup *cgrp);
+void cgroup_stat_show_cputime(struct seq_file *seq);
 void cgroup_stat_boot(void);
 
 /*
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -464,6 +464,28 @@ static struct cgroup_subsys_state *cgrou
 }
 
 /**
+ * cgroup_tryget_css - try to get a cgroup's css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @ss: the subsystem of interest
+ *
+ * Find and get @cgrp's css assocaited with @ss.  If the css doesn't exist
+ * or is offline, %NULL is returned.
+ */
+static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
+						     struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+	css = cgroup_css(cgrp, ss);
+	if (!css || !css_tryget_online(css))
+		css = NULL;
+	rcu_read_unlock();
+
+	return css;
+}
+
+/**
  * cgroup_e_css - obtain a cgroup's effective css for the specified subsystem
  * @cgrp: the cgroup of interest
  * @ss: the subsystem of interest (%NULL returns @cgrp->self)
@@ -3311,11 +3333,40 @@ static int cgroup_stat_show(struct seq_f
 	seq_printf(seq, "nr_dying_descendants %d\n",
 		   cgroup->nr_dying_descendants);
 
-	cgroup_stat_show_cputime(seq, "cpu.");
-
 	return 0;
 }
 
+static int __maybe_unused cgroup_extra_stat_show(struct seq_file *seq,
+						 struct cgroup *cgrp, int ssid)
+{
+	struct cgroup_subsys *ss = cgroup_subsys[ssid];
+	struct cgroup_subsys_state *css;
+	int ret;
+
+	if (!ss->css_extra_stat_show)
+		return 0;
+
+	css = cgroup_tryget_css(cgrp, ss);
+	if (!css)
+		return 0;
+
+	ret = ss->css_extra_stat_show(seq, css);
+	css_put(css);
+	return ret;
+}
+
+static int cpu_stat_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	int ret = 0;
+
+	cgroup_stat_show_cputime(seq);
+#ifdef CONFIG_CGROUP_SCHED
+	ret = cgroup_extra_stat_show(seq, cgrp, cpu_cgrp_id);
+#endif
+	return ret;
+}
+
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of->kn->priv;
@@ -4423,6 +4474,11 @@ static struct cftype cgroup_base_files[]
 		.name = "cgroup.stat",
 		.seq_show = cgroup_stat_show,
 	},
+	{
+		.name = "cpu.stat",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.seq_show = cpu_stat_show,
+	},
 	{ }	/* terminate */
 };
 
--- a/kernel/cgroup/stat.c
+++ b/kernel/cgroup/stat.c
@@ -256,7 +256,7 @@ void __cgroup_account_cputime_field(stru
 	cgroup_cpu_stat_account_end(cgrp, cstat);
 }
 
-void cgroup_stat_show_cputime(struct seq_file *seq, const char *prefix)
+void cgroup_stat_show_cputime(struct seq_file *seq)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
 	u64 usage, utime, stime;
@@ -278,10 +278,10 @@ void cgroup_stat_show_cputime(struct seq
 	do_div(utime, NSEC_PER_USEC);
 	do_div(stime, NSEC_PER_USEC);
 
-	seq_printf(seq, "%susage_usec %llu\n"
-		   "%suser_usec %llu\n"
-		   "%ssystem_usec %llu\n",
-		   prefix, usage, prefix, utime, prefix, stime);
+	seq_printf(seq, "usage_usec %llu\n"
+		   "user_usec %llu\n"
+		   "system_usec %llu\n",
+		   usage, utime, stime);
 }
 
 int cgroup_stat_init(struct cgroup *cgrp)
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6678,13 +6678,12 @@ static struct cftype cpu_legacy_files[]
 	{ }	/* Terminate */
 };
 
-static int cpu_stat_show(struct seq_file *sf, void *v)
+static int cpu_extra_stat_show(struct seq_file *sf,
+			       struct cgroup_subsys_state *css)
 {
-	cgroup_stat_show_cputime(sf, "");
-
 #ifdef CONFIG_CFS_BANDWIDTH
 	{
-		struct task_group *tg = css_tg(seq_css(sf));
+		struct task_group *tg = css_tg(css);
 		struct cfs_bandwidth *cfs_b = &tg->cfs_bandwidth;
 		u64 throttled_usec;
 
@@ -6817,11 +6816,6 @@ static ssize_t cpu_max_write(struct kern
 #endif
 
 static struct cftype cpu_files[] = {
-	{
-		.name = "stat",
-		.flags = CFTYPE_NOT_ON_ROOT,
-		.seq_show = cpu_stat_show,
-	},
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "weight",
@@ -6852,6 +6846,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.css_online	= cpu_cgroup_css_online,
 	.css_released	= cpu_cgroup_css_released,
 	.css_free	= cpu_cgroup_css_free,
+	.css_extra_stat_show = cpu_extra_stat_show,
 	.fork		= cpu_cgroup_fork,
 	.can_attach	= cpu_cgroup_can_attach,
 	.attach		= cpu_cgroup_attach,
