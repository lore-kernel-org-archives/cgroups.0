From: zhangq95 <qiangzh.hust@gmail.com>
Subject: [PATCH] Add a file named cgroup.procs_stat in cgroup
Date: Fri,  4 May 2018 22:28:20 +0800
Message-ID: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zyxDPeyZ9czd6yew9/ojJ03B5QIgGkSe0DGBSRdktZ4=;
        b=axoqvJa1eHTN9s/0CNWex8hLaOjHa6UtmLUCd6fAMPkAvL0fJv0CXs9GJ8PFKgfzCA
         CgxJvhtoYv1f8He2w4Bjz+yyUVCEJ4a7BF5ht+CoXnQLgRFkpOL50MO1hPvdVpMNyQ1V
         g4MHJ3LfAoDVtcxyh9v44VJVDAcKOLB7WO3pngj8WaDrOqHcktklPlpChMfP3i7EtSh3
         jYmQtCipT7+6dpLqJRRHB/T8aq3QALS2dmw3ZS4mEAXtqL2fM8yjigKl0j3qtZP2BR98
         2jMyFumbKmn4a2D8Z2cs/C9f6Isk2q94jt0inVFSbJBjZ3HtFDdVaE1DSbl1xyqUCkOA
         O5Yw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, peterz@infradead.org, cgroups@vger.kernel.org, riel@redhat.com, gs051095@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de, keescook@chromium.org, gregkh@linuxfoundation.org, longman@redhat.com, prsood@codeaurora.org, guro@fb.com, davem@davemloft.net, mhocko@suse.com, kirill.shutemov@linux.intel.com, marcos.souza.org@gmail.com, hoeun.ryu@gmail.com, rostedt@goodmis.org, bigeasy@linutronix.de, alexander.levin@verizon.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, zhangq95 <qiangzh.hust@gmail.com>

When I run "cat /proc/stat" in a container, container will access
host's file directly which is a security risk. LXCFS is a good way
to strengthen the isolation among containers. However, I can not
get a container's correct status because LXCFS just transfer host's
status to container. So I track status of a task group and record it
on cgroup.procs_stat so that LXCFS can read correct status of a cont-
ainer.

cgroup.procs_stat record context switches, boot time, the number of
running processes, blocked processes, fork and softirq of a task group.
Actually, container is just a process for linux kernel and container's
children processes belong to a same task group so I can get container's
status as long as I find task group to which the container belongs.

Add two data structures in CPU accounting group to save the status of
a task grooup. For each task, find CPU accounting group to which this
task belongs, then update the corresponding data. So, I can get the co-
rrect status data of a container in the cgroup to which the container
belongs.

Signed-off-by: zhangq95 <qiangzh.hust@gmail.com>
---
 include/linux/cgroup.h        |  31 ++++++++++++
 include/linux/cpuset.h        |   1 +
 include/linux/pid_namespace.h |   6 +++
 kernel/cgroup/cgroup-v1.c     | 108 ++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup/cgroup.c        |   8 ++++
 kernel/cgroup/cpuset.c        |  26 ++++++++++
 kernel/fork.c                 |   3 ++
 kernel/sched/core.c           |  14 ++++++
 kernel/sched/cpuacct.c        | 103 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/fair.c           |  23 +++++++++
 kernel/sched/rt.c             |   2 +
 kernel/softirq.c              |   5 ++
 12 files changed, 330 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 473e0c0..63aa652 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -113,6 +113,8 @@ int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry);
 int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 		     struct pid *pid, struct task_struct *tsk);
+extern struct cgroup_subsys_state *global_cgroup_css(struct cgroup *cgrp,
+						     int ssid);
 
 void cgroup_fork(struct task_struct *p);
 extern int cgroup_can_fork(struct task_struct *p);
@@ -696,12 +698,41 @@ static inline void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
 #ifdef CONFIG_CGROUPS
 
 #ifdef CONFIG_CGROUP_CPUACCT
+enum {
+	CPUACCT_PROCS_RUNNING = 0,
+	CPUACCT_PROCS_IOWAIT,
+	CPUACCT_PROCS_FORKS,
+	CPUACCT_PROCS_SWITCHES,
+
+	CPUACCT_PROCS_STAT_NSTATS,
+};
 void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 void cpuacct_account_field(struct task_struct *tsk, int index, u64 val);
+unsigned long task_ca_procs_stat(struct task_struct *tsk, int cpu,
+	int index, int m_index);
+void update_cpuacct_procs_stat(struct task_struct *tsk, int cpu,
+	int index, int inc, int m_index);
+bool task_in_nonroot_cpuacct(struct task_struct *tsk);
+void update_cpuacct_running_from_tg(struct task_group *tg,
+	int cpu, int inc);
 #else
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
 static inline void cpuacct_account_field(struct task_struct *tsk, int index,
 					 u64 val) {}
+static inline unsigned long
+task_ca_procs_stat(struct task_struct *tsk, int cpu,
+	int index, int m_index) { return 0; }
+
+static inline void
+update_cpuacct_procs_stat(struct task_struct *tsk, int cpu,
+	int index, int inc, int m_index) {}
+
+static inline bool
+task_in_nonroot_cpuacct(struct task_struct *tsk) { return false; }
+
+static inline void
+update_cpuacct_running_from_tg(struct task_group *tg,
+	int cpu, int inc) {}
 #endif
 
 void __cgroup_account_cputime(struct cgroup *cgrp, u64 delta_exec);
diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 934633a..4ce5372 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -56,6 +56,7 @@ extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_wait_for_hotplug(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
+extern void get_tsk_cpu_allowed(struct task_struct *tsk, struct cpumask *pmask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 49538b1..2d84f7b 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -100,4 +100,10 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
 void pidhash_init(void);
 void pid_idr_init(void);
 
+/* Determine if task is in root_namespace */
+static inline bool in_noninit_pid_ns(struct task_struct *tsk)
+{
+	return task_active_pid_ns(tsk) != &init_pid_ns;
+}
+
 #endif /* _LINUX_PID_NS_H */
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index a2c05d2..95cafc2 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -7,12 +7,15 @@
 #include <linux/mm.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
+#include <linux/sched/stat.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/delayacct.h>
 #include <linux/pid_namespace.h>
+#include <linux/kernel_stat.h>
 #include <linux/cgroupstats.h>
+#include <linux/cpuset.h>
 
 #include <trace/events/cgroup.h>
 
@@ -604,6 +607,106 @@ static int cgroup_sane_behavior_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static int cgroup_procs_stat_show(struct seq_file *s, void *v)
+{
+	struct kernfs_open_file *of = s->private;
+	struct cgroup *cgrp = seq_css(s)->cgroup;
+	struct cgroup_pidlist *l;
+	enum cgroup_filetype type = seq_cft(s)->private;
+	struct task_struct *tsk;
+	int ret, i = 0, j = 0, tmp = 0;
+	unsigned long forks = 0, iowait = 0, nr_runnable = 0;
+	pid_t *start;
+	struct timespec64 boottime;
+	unsigned long long start_time, switches = 0;
+	unsigned long per_softirq_nums[NR_SOFTIRQS] = {0};
+	unsigned long sum_softirq = 0;
+	struct cpumask cpus_allowed;
+
+	mutex_lock(&cgrp->pidlist_mutex);
+	if (of->priv)
+		of->priv = cgroup_pidlist_find(cgrp, type);
+
+	if (!of->priv) {
+		ret = pidlist_array_load(cgrp, type,
+					 (struct cgroup_pidlist **)&of->priv);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+	l = of->priv;
+
+	start = l->list;
+
+	tsk = find_task_by_pid_ns(*start, &init_pid_ns);
+	getboottime64(&boottime);
+
+	if (in_noninit_pid_ns(tsk) &&
+		task_in_nonroot_cpuacct(tsk)) {
+		if (task_css(tsk, cpuset_cgrp_id)) {
+			memset(&cpus_allowed, 0, sizeof(cpus_allowed));
+			get_tsk_cpu_allowed(tsk, &cpus_allowed);
+		}
+
+		start_time = tsk->real_start_time / NSEC_PER_SEC;
+		start_time += (unsigned long long)boottime.tv_sec;
+
+		for_each_cpu_and(i, cpu_possible_mask, &cpus_allowed) {
+			switches += task_ca_procs_stat(tsk, i,
+				CPUACCT_PROCS_SWITCHES, 0);
+			forks += task_ca_procs_stat(tsk, i,
+				CPUACCT_PROCS_FORKS, 0);
+			nr_runnable += task_ca_procs_stat(tsk, i,
+				CPUACCT_PROCS_RUNNING, 0);
+			iowait += task_ca_procs_stat(tsk, i,
+				CPUACCT_PROCS_IOWAIT, 0);
+
+			for (j = 0; j < NR_SOFTIRQS; j++) {
+				tmp = task_ca_procs_stat(tsk, i, j, 1);
+				per_softirq_nums[j] += tmp;
+				sum_softirq += tmp;
+			}
+		}
+
+	} else {
+		cpumask_copy(&cpus_allowed, cpu_possible_mask);
+		nr_runnable = nr_running();
+		forks = total_forks;
+		iowait = nr_iowait();
+		switches = nr_context_switches();
+		start_time = (unsigned long long)boottime.tv_sec;
+
+		for (j = 0; j < NR_SOFTIRQS; j++) {
+			unsigned long softirq_stat = kstat_softirqs_cpu(j, i);
+
+			per_softirq_nums[j] += softirq_stat;
+			sum_softirq += softirq_stat;
+		}
+	}
+
+	seq_printf(s, "softirq %lu ", sum_softirq);
+	for (j = 0; j < NR_SOFTIRQS; j++)
+		seq_printf(s, "%lu ", per_softirq_nums[j]);
+
+	seq_puts(s, "\n");
+	seq_printf(s,
+		"ctxt %llu\n"
+		"btime %llu\n"
+		"processes %lu\n"
+		"procs_running %lu\n"
+		"procs_blocked %lu\n",
+		switches,
+		start_time,
+		forks,
+		nr_runnable,
+		iowait);
+
+	mod_delayed_work(cgroup_pidlist_destroy_wq, &l->destroy_dwork,
+		CGROUP_PIDLIST_DESTROY_DELAY);
+	mutex_unlock(&cgrp->pidlist_mutex);
+
+	return 0;
+}
+
 static u64 cgroup_read_notify_on_release(struct cgroup_subsys_state *css,
 					 struct cftype *cft)
 {
@@ -678,6 +781,11 @@ struct cftype cgroup1_base_files[] = {
 		.write = cgroup_release_agent_write,
 		.max_write_len = PATH_MAX - 1,
 	},
+	{
+		.name = "cgroup.procs_stat",
+		.seq_show = cgroup_procs_stat_show,
+		.write = cgroup1_procs_write,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index a662bfc..ec0f181 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -54,6 +54,8 @@
 #include <linux/proc_ns.h>
 #include <linux/nsproxy.h>
 #include <linux/file.h>
+#include <linux/cgroup.h>
+#include <linux/pid_namespace.h>
 #include <net/sock.h>
 
 #define CREATE_TRACE_POINTS
@@ -485,6 +487,12 @@ static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
 	return css;
 }
 
+struct cgroup_subsys_state *global_cgroup_css(struct cgroup *cgrp,
+						     int ssid)
+{
+	return cgroup_tryget_css(cgrp, cgroup_subsys[(ssid)]);
+}
+
 /**
  * cgroup_e_css - obtain a cgroup's effective css for the specified subsystem
  * @cgrp: the cgroup of interest
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b42037e..52c4c71 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2431,6 +2431,32 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	spin_unlock_irqrestore(&callback_lock, flags);
 }
 
+/**
+ * get_tsk_cpu_allowed - get cpus_allowed mask of a tsk.
+ * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
+ * @pmask: pointer to struct cpumask variable to receive cpus_allowed set.
+ *
+ * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
+ * according to the specified @tsk.
+ **/
+void get_tsk_cpu_allowed(struct task_struct *tsk, struct cpumask *pmask)
+{
+	unsigned long flags;
+	struct cpuset *cs = NULL;
+
+	spin_lock_irqsave(&callback_lock, flags);
+	rcu_read_lock();
+
+	cs = task_cs(tsk);
+	if (cs)
+		cpumask_and(pmask, cs->cpus_allowed, cpu_possible_mask);
+	else
+		cpumask_copy(pmask, cpu_possible_mask);
+
+	rcu_read_unlock();
+	spin_unlock_irqrestore(&callback_lock, flags);
+}
+
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	rcu_read_lock();
diff --git a/kernel/fork.c b/kernel/fork.c
index a5d21c4..72449b0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1958,6 +1958,9 @@ static __latent_entropy struct task_struct *copy_process(
 	}
 
 	total_forks++;
+	update_cpuacct_procs_stat(task_active_pid_ns(p)->child_reaper,
+			task_active_pid_ns(p)->child_reaper->cpu,
+			CPUACCT_PROCS_FORKS, 1, 0);
 	spin_unlock(&current->sighand->siglock);
 	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5e10aae..ba969af 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3404,11 +3404,19 @@ static void __sched notrace __schedule(bool preempt)
 	struct rq_flags rf;
 	struct rq *rq;
 	int cpu;
+	struct task_struct *prev_root = NULL, *next_root = NULL;
 
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	prev = rq->curr;
 
+	if (task_active_pid_ns(prev)) {
+		prev_root = task_active_pid_ns(prev)->child_reaper;
+		if (prev_root != init_pid_ns.child_reaper)
+			update_cpuacct_procs_stat(prev, prev->cpu,
+				CPUACCT_PROCS_SWITCHES, 1, 0);
+	}
+
 	schedule_debug(prev);
 
 	if (sched_feat(HRTICK))
@@ -3462,6 +3470,12 @@ static void __sched notrace __schedule(bool preempt)
 	}
 
 	next = pick_next_task(rq, prev, &rf);
+	if (task_active_pid_ns(next)) {
+		next_root = task_active_pid_ns(next)->child_reaper;
+		if (prev_root && prev_root != next_root)
+			update_cpuacct_procs_stat(next, next->cpu,
+				CPUACCT_PROCS_SWITCHES, 1, 0);
+	}
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 9fbb103..a822eb9 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -24,12 +24,20 @@ struct cpuacct_usage {
 	u64	usages[CPUACCT_STAT_NSTATS];
 };
 
+/* Processes status of a group of task and its child cgroups */
+struct cpuacct_procs_stat {
+	unsigned long procs_stat[CPUACCT_PROCS_STAT_NSTATS];
+	unsigned long irq[NR_SOFTIRQS];
+};
+
 /* track CPU usage of a group of tasks and its child groups */
 struct cpuacct {
 	struct cgroup_subsys_state	css;
 	/* cpuusage holds pointer to a u64-type object on every CPU */
 	struct cpuacct_usage __percpu	*cpuusage;
 	struct kernel_cpustat __percpu	*cpustat;
+	struct cpuacct_procs_stat *procs_stat;
+	struct cpuacct_softirq *softirq;
 };
 
 static inline struct cpuacct *css_ca(struct cgroup_subsys_state *css)
@@ -37,6 +45,12 @@ static inline struct cpuacct *css_ca(struct cgroup_subsys_state *css)
 	return css ? container_of(css, struct cpuacct, css) : NULL;
 }
 
+/*return cpu accounting group corresponding to this container*/
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+{
+	return container_of(global_cgroup_css(cgrp, cpuacct_cgrp_id),
+					struct cpuacct, css);
+}
 /* Return CPU accounting group to which this task belongs */
 static inline struct cpuacct *task_ca(struct task_struct *tsk)
 {
@@ -49,11 +63,94 @@ static inline struct cpuacct *parent_ca(struct cpuacct *ca)
 }
 
 static DEFINE_PER_CPU(struct cpuacct_usage, root_cpuacct_cpuusage);
+static DEFINE_PER_CPU(struct cpuacct_procs_stat, root_cpuacct_procs_stat);
 static struct cpuacct root_cpuacct = {
 	.cpustat	= &kernel_cpustat,
 	.cpuusage	= &root_cpuacct_cpuusage,
+	.procs_stat = &root_cpuacct_procs_stat,
 };
 
+/* Determine the task is in the root_cpuacct */
+bool task_in_nonroot_cpuacct(struct task_struct *tsk)
+{
+	struct cpuacct *ca = task_ca(tsk);
+
+	if (ca && (ca != &root_cpuacct))
+		return true;
+	else
+		return false;
+}
+
+/* return processes stat of a group to which this task belongs */
+unsigned long task_ca_procs_stat(struct task_struct *tsk, int cpu,
+	int index, int m_index)
+{
+	struct cpuacct *ca;
+	unsigned long res = 0;
+
+	if (!tsk)
+		return 0;
+
+	ca = task_ca(tsk);
+	if (ca) {
+		if (m_index == 0)
+			res = per_cpu_ptr(ca->procs_stat,
+				cpu)->procs_stat[index];
+		else
+			res = per_cpu_ptr(ca->procs_stat,
+				cpu)->irq[index];
+	}
+
+	return res;
+}
+
+/* update processes stat of a group to which this task belongs */
+void update_cpuacct_procs_stat(struct task_struct *tsk, int cpu, int index,
+	int inc, int m_index)
+{
+	struct cpuacct *ca;
+	unsigned long *res;
+
+	if (!tsk)
+		return;
+
+	ca = task_ca(tsk);
+	if (ca) {
+		if (m_index == 0) {
+			res = &(per_cpu_ptr(ca->procs_stat,
+				cpu)->procs_stat[index]);
+			*res += inc;
+		} else {
+			res = &(per_cpu_ptr(ca->procs_stat,
+				cpu)->irq[index]);
+			*res += inc;
+		}
+	}
+}
+
+/* update cpuacct of a group to which this task belongs from a task_group */
+void update_cpuacct_running_from_tg(struct task_group *tg, int cpu, int inc)
+{
+	struct cgroup *cgrp;
+	struct cpuacct *ca;
+	unsigned long *nr_running;
+	struct cpuacct_procs_stat *procs_stat;
+
+	if (!tg)
+		return;
+
+	cgrp = tg->css.cgroup;
+	if (!cgrp)
+		return;
+
+	ca = cgroup_ca(cgrp);
+	if (ca && (ca != &root_cpuacct)) {
+		procs_stat = per_cpu_ptr(ca->procs_stat, cpu);
+		nr_running = &(procs_stat->procs_stat[CPUACCT_PROCS_RUNNING]);
+		*nr_running += inc;
+	}
+}
+
 /* Create a new CPU accounting group */
 static struct cgroup_subsys_state *
 cpuacct_css_alloc(struct cgroup_subsys_state *parent_css)
@@ -74,9 +171,14 @@ cpuacct_css_alloc(struct cgroup_subsys_state *parent_css)
 	ca->cpustat = alloc_percpu(struct kernel_cpustat);
 	if (!ca->cpustat)
 		goto out_free_cpuusage;
+	ca->procs_stat = alloc_percpu(struct cpuacct_procs_stat);
+	if (!ca->procs_stat)
+		goto out_free_stat;
 
 	return &ca->css;
 
+out_free_stat:
+	free_percpu(ca->procs_stat);
 out_free_cpuusage:
 	free_percpu(ca->cpuusage);
 out_free_ca:
@@ -92,6 +194,7 @@ static void cpuacct_css_free(struct cgroup_subsys_state *css)
 
 	free_percpu(ca->cpustat);
 	free_percpu(ca->cpuusage);
+	free_percpu(ca->procs_stat);
 	kfree(ca);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 54dc31e..46adf63 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -23,6 +23,7 @@
 #include "sched.h"
 
 #include <trace/events/sched.h>
+#include <linux/cgroup.h>
 
 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -4732,6 +4733,22 @@ static int tg_throttle_down(struct task_group *tg, void *data)
 	return 0;
 }
 
+void update_cpuacct_running_from_cfs(struct cfs_rq *cfs_rq, int inc)
+{
+	struct rq *rq;
+	int cpu = 0;
+
+	if (!cfs_rq)
+		return;
+
+	rq = rq_of(cfs_rq);
+	if (!rq)
+		return;
+
+	cpu = cpu_of(rq);
+	update_cpuacct_running_from_tg(cfs_rq->tg, cpu, inc);
+}
+
 static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	struct rq *rq = rq_of(cfs_rq);
@@ -4757,6 +4774,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 		if (dequeue)
 			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
 		qcfs_rq->h_nr_running -= task_delta;
+		update_cpuacct_running_from_cfs(qcfs_rq, -task_delta);
 
 		if (qcfs_rq->load.weight)
 			dequeue = 0;
@@ -4820,6 +4838,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 		if (enqueue)
 			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
 		cfs_rq->h_nr_running += task_delta;
+		update_cpuacct_running_from_cfs(cfs_rq, task_delta);
 
 		if (cfs_rq_throttled(cfs_rq))
 			break;
@@ -5379,6 +5398,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 		cfs_rq->h_nr_running++;
+		update_cpuacct_running_from_cfs(cfs_rq, 1);
 
 		flags = ENQUEUE_WAKEUP;
 	}
@@ -5386,6 +5406,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		cfs_rq->h_nr_running++;
+		update_cpuacct_running_from_cfs(cfs_rq, 1);
 
 		if (cfs_rq_throttled(cfs_rq))
 			break;
@@ -5427,6 +5448,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		if (cfs_rq_throttled(cfs_rq))
 			break;
 		cfs_rq->h_nr_running--;
+		update_cpuacct_running_from_cfs(cfs_rq, -1);
 
 		/* Don't dequeue parent if it has other entities besides us */
 		if (cfs_rq->load.weight) {
@@ -5446,6 +5468,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	for_each_sched_entity(se) {
 		cfs_rq = cfs_rq_of(se);
 		cfs_rq->h_nr_running--;
+		update_cpuacct_running_from_cfs(cfs_rq, -1);
 
 		if (cfs_rq_throttled(cfs_rq))
 			break;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7aef6b4..766ec16 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1327,6 +1327,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 		rt_se->timeout = 0;
 
 	enqueue_rt_entity(rt_se, flags);
+	update_cpuacct_procs_stat(p, cpu_of(rq), CPUACCT_PROCS_RUNNING, 1, 0);
 
 	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
 		enqueue_pushable_task(rq, p);
@@ -1338,6 +1339,7 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
 
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se, flags);
+	update_cpuacct_procs_stat(p, cpu_of(rq), CPUACCT_PROCS_RUNNING, -1, 0);
 
 	dequeue_pushable_task(rq, p);
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 177de36..9fa1995 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -26,6 +26,7 @@
 #include <linux/smpboot.h>
 #include <linux/tick.h>
 #include <linux/irq.h>
+#include <linux/cgroup.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -248,6 +249,7 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 	bool in_hardirq;
 	__u32 pending;
 	int softirq_bit;
+	struct task_struct *p = current;
 
 	/*
 	 * Mask out PF_MEMALLOC s current task context is borrowed for the
@@ -280,6 +282,9 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
 		prev_count = preempt_count();
 
 		kstat_incr_softirqs_this_cpu(vec_nr);
+		if (task_active_pid_ns(p))
+			update_cpuacct_procs_stat(p, p->cpu,
+				vec_nr, 1, 1);
 
 		trace_softirq_entry(vec_nr);
 		h->action(h);
-- 
2.7.4

