From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] sched: RT bandwidth interface for cgroup unified hierarchy
Date: Tue, 21 Jun 2022 20:35:42 +0800
Message-ID: <20220621123542.1444-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EjlDmuV/uOVKT3BSmFT2nXl++EN3szZ0zzti8E6q644=;
        b=3VQV7AhNbEPddrWLGOd8BC8ju9GERSEC+GjCVKfDY9DBIs9bLhRYp56IQtNtupvHvR
         64ceScHBlOiAtQdDXzQQipdPSMZnVn2/nmHovXnkbOKdICbg2ocSBdXZ0BJ2eaPERXJQ
         wqhLg5735a5oxSmK1XYnFFJT74fh3JEOncfmiKZ7ndvZlvRFvAZ+lvbernA9KKUwLDpd
         HB5LZjcihcSITR+WCOys22YdE7q1rFUfkvIB0LVvZYegrHu8c7jxYG4riYiqjXw4G0LN
         /JyQ1d4BButexZoooYeeoeUxc/IxHY6c01RJs0VwViNEdkvTEZZpjx86+zB6dz4aN++J
         KuqA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We need to run RT threads in cgroup unified hierarchy, but we can't
since the default rt_bandwidth.rt_runtime of non-root task_group is 0
and we haven't interface to update it.

This patch add RT bandwidth interface "cpu.max.rt" and update the
documentation accordingly.

Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 13 +++++++++++
 kernel/sched/core.c                     | 31 +++++++++++++++++++++++++
 kernel/sched/rt.c                       |  2 +-
 kernel/sched/sched.h                    |  1 +
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 176298f2f4de..3d2949e16e04 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1055,6 +1055,19 @@ All time durations are in microseconds.
 
 	The burst in the range [0, $MAX].
 
+  cpu.max.rt
+	A read-write two value file which exists on all cgroups when
+	CONFIG_RT_GROUP_SCHED enabled, to control CPU bandwidth for
+	RT threads in the task group.
+
+	The maximum bandwidth limit.  It's in the following format::
+
+	  $MAX $PERIOD
+
+	which indicates that RT threads in the group may consume upto
+	$MAX in each $PERIOD duration.  "max" for $MAX indicates no
+	limit.  If only one number is written, $MAX is updated.
+
   cpu.pressure
 	A read-write nested-keyed file.
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index daadedc78fd9..c16f8cc5de08 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -11047,6 +11047,30 @@ static ssize_t cpu_max_write(struct kernfs_open_file *of,
 }
 #endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
+static int cpu_max_rt_show(struct seq_file *sf, void *v)
+{
+	struct task_group *tg = css_tg(seq_css(sf));
+
+	cpu_period_quota_print(sf, sched_group_rt_period(tg), sched_group_rt_runtime(tg));
+	return 0;
+}
+
+static ssize_t cpu_max_rt_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct task_group *tg = css_tg(of_css(of));
+	u64 period = sched_group_rt_period(tg);
+	u64 runtime;
+	int ret;
+
+	ret = cpu_period_quota_parse(buf, &period, &runtime);
+	if (!ret)
+		ret = tg_set_rt_bandwidth(tg, period, runtime);
+	return ret ?: nbytes;
+}
+#endif
+
 static struct cftype cpu_files[] = {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	{
@@ -11082,6 +11106,13 @@ static struct cftype cpu_files[] = {
 		.write_u64 = cpu_cfs_burst_write_u64,
 	},
 #endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	{
+		.name = "max.rt",
+		.seq_show = cpu_max_rt_show,
+		.write = cpu_max_rt_write,
+	},
+#endif
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 	{
 		.name = "uclamp.min",
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8c9ed9664840..319ce586446f 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2819,7 +2819,7 @@ static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 	return ret;
 }
 
-static int tg_set_rt_bandwidth(struct task_group *tg,
+int tg_set_rt_bandwidth(struct task_group *tg,
 		u64 rt_period, u64 rt_runtime)
 {
 	int i, err = 0;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7b19a72408b1..317480d535b0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -486,6 +486,7 @@ extern int alloc_rt_sched_group(struct task_group *tg, struct task_group *parent
 extern void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 		struct sched_rt_entity *rt_se, int cpu,
 		struct sched_rt_entity *parent);
+extern int tg_set_rt_bandwidth(struct task_group *tg, u64 rt_period, u64 rt_runtime);
 extern int sched_group_set_rt_runtime(struct task_group *tg, long rt_runtime_us);
 extern int sched_group_set_rt_period(struct task_group *tg, u64 rt_period_us);
 extern long sched_group_rt_runtime(struct task_group *tg);
-- 
2.36.1

