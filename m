From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Thu, 17 Sep 2015 17:10:49 +0200
Message-ID: <20150917151049.GB11639@twins.programming.kicks-ass.net>
References: <20150822182916.GE20768@mtj.duckdns.org>
 <CAPM31RKPUzuiwVs3rs=4M1Kt=+c9WX8o84r-iO4semfznvYmHw@mail.gmail.com>
 <20150824213600.GK28944@mtj.duckdns.org>
 <CAPM31RKCO-yxtVf+iUs8FOqk6uGSyixEXtx9zSzxQ1uOGtkDqQ@mail.gmail.com>
 <20150824221935.GN28944@mtj.duckdns.org>
 <CAPM31RK08pC3g9qx+TEw6PQvtHk8idKE3OALQN8cFr_QOuT3FA@mail.gmail.com>
 <20150825210234.GE26785@mtj.duckdns.org>
 <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <20150917143527.GJ3604@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150917143527.GJ3604-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Thu, Sep 17, 2015 at 04:35:27PM +0200, Peter Zijlstra wrote:
> I'd be happy to fail a CPU down for user tasks where this is the last
> runnable CPU of.

A little like so. Completely untested.

---
Subject: sched: Refuse to unplug a CPU if this will violate user task affinity

Its bad policy to allow unplugging a CPU for which a user set explicit
affinity, either strictly on this CPU or in case this was the last
online CPU in its mask.

Either would end up forcing the thread on a random other CPU, violating
the sys_sched_setaffinity() constraint.

Disallow this by default; root might not be aware of all user
affinities, but can negotiate and change affinities for all tasks.

Provide a sysctl to go back to the old behaviour.

Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 include/linux/sched/sysctl.h |  1 +
 kernel/sched/core.c          | 46 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c              |  9 +++++++++
 3 files changed, 56 insertions(+)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index c9e4731cf10b..9444b549914b 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -39,6 +39,7 @@ extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_child_runs_first;
+extern unsigned int sysctl_sched_strict_affinity;
 
 enum sched_tunable_scaling {
 	SCHED_TUNABLESCALING_NONE,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6ab415aa15c4..457c8b912fc6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -284,6 +284,11 @@ __read_mostly int scheduler_running;
  */
 int sysctl_sched_rt_runtime = 950000;
 
+/*
+ * Disallows cpu unplug if that would result in a task without runnable CPUs.
+ */
+unsigned int sysctl_sched_strict_affinity = 1;
+
 /* cpus with isolated domains */
 cpumask_var_t cpu_isolated_map;
 
@@ -5430,6 +5435,42 @@ static void set_rq_offline(struct rq *rq)
 }
 
 /*
+ * Test if there's a user task for which @cpu is the last runnable CPU
+ */
+static bool migration_possible(int cpu)
+{
+	struct task_struct *g, *p;
+	bool ret = true;
+	int next;
+
+	read_lock(&tasklist_lock);
+	for_each_process_thread(g, p) {
+		/* if its running elsewhere, this cannot be its last cpu */
+		if (task_cpu(p) != cpu)
+			continue;
+
+		/* we only care about user state */
+		if (p->flags & PF_KTHREAD)
+			continue;
+
+		next = -1;
+again:
+		next = cpumask_next_and(next, tsk_cpus_allowed(p), cpu_active_mask);
+		if (next >= nr_cpu_ids) {
+			printk(KERN_WARNING "task %s-%d refused unplug of CPU %d\n",
+					p->comm, p->pid, cpu);
+			ret = false;
+			break;
+		}
+		if (next == cpu)
+			goto again;
+	}
+	read_unlock(&tasklist_lock);
+
+	return ret;
+}
+
+/*
  * migration_call - callback that gets triggered when a CPU is added.
  * Here we can start up the necessary migration thread for the new CPU.
  */
@@ -5440,6 +5481,11 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	unsigned long flags;
 	struct rq *rq = cpu_rq(cpu);
 
+	if (action == CPU_DOWN_PREPARE && sysctl_sched_strict_affinity) {
+		if (!migration_possible(cpu))
+			return notifier_from_errno(-EBUSY);
+	}
+
 	switch (action & ~CPU_TASKS_FROZEN) {
 
 	case CPU_UP_PREPARE:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e69201d8094e..9d0edcc73cc3 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -283,6 +283,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "sched_strict_affinity",
+		.data		= &sysctl_sched_strict_affinity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_SMP */
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.procname	= "sched_min_granularity_ns",
