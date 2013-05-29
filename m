From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 05/11] cpuacct: don't actually do anything.
Date: Wed, 29 May 2013 15:03:16 +0400
Message-ID: <1369825402-31046-6-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>

All the information we have that is needed for cpuusage (and
cpuusage_percpu) is present in schedstats. It is already recorded
in a sane hierarchical way.

If we have CONFIG_SCHEDSTATS, we don't really need to do any extra
work. All former functions become empty inlines.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c  | 102 ++++++++++++++++++++++++++++++++++++++++++---------
 kernel/sched/sched.h |  10 +++--
 2 files changed, 90 insertions(+), 22 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ae1adf..0fa0f87 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6787,6 +6787,7 @@ void sched_move_task(struct task_struct *tsk)
 	task_rq_unlock(rq, tsk, &flags);
 }
 
+#ifndef CONFIG_SCHEDSTATS
 void task_group_charge(struct task_struct *tsk, u64 cputime)
 {
 	struct task_group *tg;
@@ -6804,6 +6805,7 @@ void task_group_charge(struct task_struct *tsk, u64 cputime)
 
 	rcu_read_unlock();
 }
+#endif
 #endif /* CONFIG_CGROUP_SCHED */
 
 #if defined(CONFIG_RT_GROUP_SCHED) || defined(CONFIG_CFS_BANDWIDTH)
@@ -7199,22 +7201,92 @@ cpu_cgroup_exit(struct cgroup *cgrp, struct cgroup *old_cgrp,
 	sched_move_task(task);
 }
 
-static u64 task_group_cpuusage_read(struct task_group *tg, int cpu)
+/*
+ * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+ */
+static inline void lock_rq_dword(int cpu)
 {
-	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
-	u64 data;
-
 #ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
-	 */
 	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
-	data = *cpuusage;
+#endif
+}
+
+static inline void unlock_rq_dword(int cpu)
+{
+#ifndef CONFIG_64BIT
 	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
+#endif
+}
+
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static inline u64 cfs_exec_clock(struct task_group *tg, int cpu)
+{
+	return tg->cfs_rq[cpu]->exec_clock - tg->cfs_rq[cpu]->prev_exec_clock;
+}
+
+static inline void cfs_exec_clock_reset(struct task_group *tg, int cpu)
+{
+	tg->cfs_rq[cpu]->prev_exec_clock = tg->cfs_rq[cpu]->exec_clock;
+}
 #else
-	data = *cpuusage;
+static inline u64 cfs_exec_clock(struct task_group *tg, int cpu)
+{
+}
+
+static inline void cfs_exec_clock_reset(struct task_group *tg, int cpu)
+{
+}
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+static inline u64 rt_exec_clock(struct task_group *tg, int cpu)
+{
+	return tg->rt_rq[cpu]->exec_clock - tg->rt_rq[cpu]->prev_exec_clock;
+}
+
+static inline void rt_exec_clock_reset(struct task_group *tg, int cpu)
+{
+	tg->rt_rq[cpu]->prev_exec_clock = tg->rt_rq[cpu]->exec_clock;
+}
+#else
+static inline u64 rt_exec_clock(struct task_group *tg, int cpu)
+{
+	return 0;
+}
+
+static inline void rt_exec_clock_reset(struct task_group *tg, int cpu)
+{
+}
 #endif
 
+static u64 task_group_cpuusage_read(struct task_group *tg, int cpu)
+{
+	u64 ret = 0;
+
+	lock_rq_dword(cpu);
+	ret = cfs_exec_clock(tg, cpu) + rt_exec_clock(tg, cpu);
+	unlock_rq_dword(cpu);
+
+	return ret;
+}
+
+static void task_group_cpuusage_write(struct task_group *tg, int cpu, u64 val)
+{
+	lock_rq_dword(cpu);
+	cfs_exec_clock_reset(tg, cpu);
+	rt_exec_clock_reset(tg, cpu);
+	unlock_rq_dword(cpu);
+}
+#else
+static u64 task_group_cpuusage_read(struct task_group *tg, int cpu)
+{
+	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
+	u64 data;
+
+	lock_rq_dword(cpu);
+	data = *cpuusage;
+	unlock_rq_dword(cpu);
+
 	return data;
 }
 
@@ -7222,17 +7294,11 @@ static void task_group_cpuusage_write(struct task_group *tg, int cpu, u64 val)
 {
 	u64 *cpuusage = per_cpu_ptr(tg->cpuusage, cpu);
 
-#ifndef CONFIG_64BIT
-	/*
-	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
-	 */
-	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
+	lock_rq_dword(cpu);
 	*cpuusage = val;
-	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
-#else
-	*cpuusage = val;
-#endif
+	unlock_rq_dword(cpu);
 }
+#endif
 
 /* return total cpu usage (in nanoseconds) of a group */
 static u64 cpucg_cpuusage_read(struct cgroup *cgrp, struct cftype *cft)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b05dd84..0e5e795 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -710,8 +710,6 @@ static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 #endif
 }
 
-extern void task_group_charge(struct task_struct *tsk, u64 cputime);
-
 #else /* CONFIG_CGROUP_SCHED */
 
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
@@ -719,10 +717,14 @@ static inline struct task_group *task_group(struct task_struct *p)
 {
 	return NULL;
 }
-static inline void task_group_charge(struct task_struct *tsk, u64 cputime) { }
-
 #endif /* CONFIG_CGROUP_SCHED */
 
+#if defined(CONFIG_CGROUP_SCHED) && !defined(CONFIG_SCHEDSTATS)
+extern void task_group_charge(struct task_struct *tsk, u64 cputime);
+#else
+static inline void task_group_charge(struct task_struct *tsk, u64 cputime) {}
+#endif
+
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
 	set_task_rq(p, cpu);
-- 
1.8.1.4
