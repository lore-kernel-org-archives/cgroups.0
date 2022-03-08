From: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [RFC PATCH v2 4/4] cpuset, gb: Add stat for group balancer
Date: Tue,  8 Mar 2022 17:26:29 +0800
Message-ID: <20220308092629.40431-5-dtcccc@linux.alibaba.com>
References: <20220308092629.40431-1-dtcccc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220308092629.40431-1-dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Michael Wang <yun.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Cruz Zhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Masahiro Yamada <masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nathan Chancellor <nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka@suse.>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When group balancer is enabled by:
  echo 200000 > $CGROUP_PATH/cpuset.gb.period_us

Then you can check:
  $CPU_CGROUP_PATH/childX/cpuset.gb.stat

which give output as:
  PART-0 0-15 1008 1086  *
  PART-1 16-31 0 2
  PART-2 32-47 0 0
  PART-3 48-63 0 1024

The partition ID followed by it's CPUs range, load of group, load
of partition and a star mark as preferred.

Signed-off-by: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 include/linux/sched/gb.h |  2 ++
 kernel/cgroup/cpuset.c   | 24 ++++++++++++++++++++++++
 kernel/sched/gb.c        | 25 +++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/include/linux/sched/gb.h b/include/linux/sched/gb.h
index 7af91662b740..ec5a97d8160a 100644
--- a/include/linux/sched/gb.h
+++ b/include/linux/sched/gb.h
@@ -63,6 +63,8 @@ static inline struct cpumask *part_cpus(struct gb_part_info *pi, int id)
 
 #ifdef CONFIG_GROUP_BALANCER
 extern unsigned int sysctl_gb_settle_period;
+int gb_stat_show(struct seq_file *sf, struct cgroup_subsys_state *css,
+		 struct gb_info *gi, struct gb_part_info *pi);
 #endif
 
 #endif
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index de13c22c1921..035606e8fa95 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2863,6 +2863,24 @@ static ssize_t gb_partition_write(struct kernfs_open_file *of, char *buf,
 	cpus_read_unlock();
 	return retval ?: nbytes;
 }
+
+static int gb_stat_seq_show(struct seq_file *sf, void *v)
+{
+	struct cgroup_subsys_state *css = seq_css(sf);
+	struct gb_info *control_gi;
+	int retval = -EINVAL;
+
+	rcu_read_lock();
+	control_gi = css_gi(css, true);
+	if (!control_gi || !control_gi->gb_period)
+		goto out_unlock;
+
+	retval = gb_stat_show(sf, css, css_gi(css, false), control_gi->part_info);
+
+out_unlock:
+	rcu_read_unlock();
+	return retval;
+}
 #else
 static inline void init_gb(struct cpuset *cs) { }
 static inline void remove_gb(struct cpuset *cs) { }
@@ -3179,6 +3197,12 @@ static struct cftype dfl_files[] = {
 		.max_write_len = (100U + 6 * NR_CPUS),
 		.private = FILE_GB_CPULIST,
 	},
+
+	{
+		.name = "gb.stat",
+		.seq_show = gb_stat_seq_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 #endif
 	{ }	/* terminate */
 };
diff --git a/kernel/sched/gb.c b/kernel/sched/gb.c
index f7da96253ad0..8ae1db83b587 100644
--- a/kernel/sched/gb.c
+++ b/kernel/sched/gb.c
@@ -46,6 +46,31 @@ static u64 load_of_part(struct gb_part_info *pi, int id)
 	return load;
 }
 
+int gb_stat_show(struct seq_file *sf, struct cgroup_subsys_state *css,
+		 struct gb_info *gi, struct gb_part_info *pi)
+{
+	struct cgroup_subsys_state *tg_css;
+	struct task_group *tg;
+	int i;
+
+	tg_css = cgroup_e_css(css->cgroup, &cpu_cgrp_subsys);
+	/* Make sure that "cpu" and "cpuset" subsys belonging to the same cgroup. */
+	if (tg_css->cgroup != css->cgroup)
+		return -EINVAL;
+	tg = container_of(tg_css, struct task_group, css);
+
+	for_each_gbpart(i, pi) {
+		seq_printf(sf, "PART-%d ", i);
+		seq_printf(sf, "%*pbl ", cpumask_pr_args(part_cpus(pi, i)));
+		seq_printf(sf, "%llu ", tg_load_of_part(pi, tg, i));
+		seq_printf(sf, "%llu ", load_of_part(pi, i));
+		if (gi->gb_prefer == i)
+			seq_puts(sf, " *");
+		seq_putc(sf, '\n');
+	}
+	return 0;
+}
+
 static inline int part_mgrt_lock(struct gb_part_info *pi, int src, int dst)
 {
 	struct gb_part *src_part, *dst_part;
-- 
2.27.0

