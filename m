From: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 3/3] sched/core: Force idle accounting per cgroup
Date: Tue, 11 Jan 2022 17:56:01 +0800
Message-ID: <1641894961-9241-4-git-send-email-CruzZhao@linux.alibaba.com>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1641894961-9241-1-git-send-email-CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Accounting for "force idle" time per cgroup, which is the time the tasks
of the cgroup forced its SMT siblings into idle.

Force idle time per cgroup is displayed via
  /sys/fs/cgroup/cpuacct/$cg/cpuacct.forceidle.
Force idle time per cgroup per cpu is displayed via
  /sys/fs/cgroup/cpuacct/$cg/cpuacct.forceidle_percpu.
The unit is ns.
It also requires that schedstats is enabled.

We can get the total system forced idle time by looking at the root cgroup,
and we can get how long the cgroup forced it SMT siblings into idle. If the
force idle time of a cgroup is high, that can be rectified by making some
changes(ie. affinity, cpu budget, etc.) to the cgroup.

Signed-off-by: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 include/linux/cgroup.h    |  7 +++++
 kernel/sched/core_sched.c |  1 +
 kernel/sched/cpuacct.c    | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 75c1514..0c1b616 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -774,10 +774,17 @@ static inline struct cgroup *cgroup_get_from_id(u64 id)
 #ifdef CONFIG_CGROUP_CPUACCT
 void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 void cpuacct_account_field(struct task_struct *tsk, int index, u64 val);
+#ifdef CONFIG_SCHED_CORE
+void cpuacct_account_forceidle(int cpu, struct task_struct *task, u64 cputime);
+#endif
 #else
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 static inline void cpuacct_account_field(struct task_struct *tsk, int index,
 					 u64 val) {}
+#ifdef CONFIG_SCHED_CORE
+static inline void cpuacct_account_forceidle(int cpu, struct task_struct *task,
+					     u64 cputime) {}
+#endif
 #endif
 
 void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec);
diff --git a/kernel/sched/core_sched.c b/kernel/sched/core_sched.c
index fe04805..add8672 100644
--- a/kernel/sched/core_sched.c
+++ b/kernel/sched/core_sched.c
@@ -284,6 +284,7 @@ void __sched_core_account_forceidle(struct rq *rq)
 			continue;
 
 		__schedstat_add(p->stats.core_forceidle_sum, delta);
+		cpuacct_account_forceidle(i, p, delta);
 	}
 }
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 3d06c5e..b5c5d99 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -27,6 +27,9 @@ struct cpuacct {
 	/* cpuusage holds pointer to a u64-type object on every CPU */
 	u64 __percpu	*cpuusage;
 	struct kernel_cpustat __percpu	*cpustat;
+#ifdef CONFIG_SCHED_CORE
+	u64 __percpu	*forceidle;
+#endif
 };
 
 static inline struct cpuacct *css_ca(struct cgroup_subsys_state *css)
@@ -46,9 +49,15 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 }
 
 static DEFINE_PER_CPU(u64, root_cpuacct_cpuusage);
+#ifdef CONFIG_SCHED_CORE
+static DEFINE_PER_CPU(u64, root_cpuacct_forceidle);
+#endif
 static struct cpuacct root_cpuacct = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
+#ifdef CONFIG_SCHED_CORE
+	.forceidle	= &root_cpuacct_forceidle,
+#endif
 };
 
 /* Create a new CPU accounting group */
@@ -72,8 +81,18 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 	if (!ca->cpustat)
 		goto out_free_cpuusage;
 
+#ifdef CONFIG_SCHED_CORE
+	ca->forceidle = alloc_percpu(u64);
+	if (!ca->forceidle)
+		goto out_free_cpustat;
+#endif
+
 	return &ca->css;
 
+#ifdef CONFIG_SCHED_CORE
+out_free_cpustat:
+	free_percpu(ca->cpustat);
+#endif
 out_free_cpuusage:
 	free_percpu(ca->cpuusage);
 out_free_ca:
@@ -290,6 +309,37 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+#ifdef CONFIG_SCHED_CORE
+static u64 __forceidle_read(struct cpuacct *ca, int cpu)
+{
+	return *per_cpu_ptr(ca->forceidle, cpu);
+}
+static int cpuacct_percpu_forceidle_seq_show(struct seq_file *m, void *V)
+{
+	struct cpuacct *ca = css_ca(seq_css(m));
+	u64 percpu;
+	int i;
+
+	for_each_possible_cpu(i) {
+		percpu = __forceidle_read(ca, i);
+		seq_printf(m, "%llu ", (unsigned long long) percpu);
+	}
+	seq_printf(m, "\n");
+	return 0;
+}
+static u64 cpuacct_forceidle_read(struct cgroup_subsys_state *css,
+				  struct cftype *cft)
+{
+	struct cpuacct *ca = css_ca(css);
+	u64 totalforceidle = 0;
+	int i;
+
+	for_each_possible_cpu(i)
+		totalforceidle += __forceidle_read(ca, i);
+	return totalforceidle;
+}
+#endif
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -324,6 +374,16 @@ static int cpuacct_stats_show(struct seq_file *sf, void *v)
 		.name = "stat",
 		.seq_show = cpuacct_stats_show,
 	},
+#ifdef CONFIG_SCHED_CORE
+	{
+		.name = "forceidle",
+		.read_u64 = cpuacct_forceidle_read,
+	},
+	{
+		.name = "forceidle_percpu",
+		.seq_show = cpuacct_percpu_forceidle_seq_show,
+	},
+#endif
 	{ }	/* terminate */
 };
 
@@ -359,6 +419,25 @@ void cpuacct_account_field(struct task_struct *tsk, int index, u64 val)
 	rcu_read_unlock();
 }
 
+#ifdef CONFIG_SCHED_CORE
+void cpuacct_account_forceidle(int cpu, struct task_struct *tsk, u64 cputime)
+{
+	struct cpuacct *ca;
+	u64 *fi;
+
+	rcu_read_lock();
+	/*
+	 * We have hold rq->core->__lock here, which protects ca->forceidle
+	 * percpu.
+	 */
+	for (ca = task_ca(tsk); ca; ca = parent_ca(ca)) {
+		fi = per_cpu_ptr(ca->forceidle, cpu);
+		*fi += cputime;
+	}
+	rcu_read_unlock();
+}
+#endif
+
 struct cgroup_subsys cpuacct_cgrp_subsys = {
 	.css_alloc	= cpuacct_css_alloc,
 	.css_free	= cpuacct_css_free,
-- 
1.8.3.1

