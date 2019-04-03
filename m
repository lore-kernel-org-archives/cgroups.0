From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v7 4/7] sched/core: Prevent race condition between cpuset and __sched_setscheduler()
Date: Wed,  3 Apr 2019 10:46:47 +0200
Message-ID: <20190403084650.4414-5-juri.lelli@redhat.com>
References: <20190403084650.4414-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190403084650.4414-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

No synchronisation mechanism exists between the cpuset subsystem and calls
to function __sched_setscheduler(). As such, it is possible that new root
domains are created on the cpuset side while a deadline acceptance test
is carried out in __sched_setscheduler(), leading to a potential oversell
of CPU bandwidth.

Grab callback_lock from core scheduler, so to prevent situations such as
the one described above from happening.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>

---

v6->v7: take cpuset_read_only_lock before rq and pi locks, as to not
        introdue an unwanted dependency between the former and the
        latters (peterz)
---
 include/linux/cpuset.h | 14 ++++++++++++++
 kernel/cgroup/cpuset.c | 27 ++++++++++++++++++++++++++-
 kernel/sched/core.c    | 27 ++++++++++++++++++++++-----
 3 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 934633a05d20..34c58c4dd445 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -55,6 +55,8 @@ extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_wait_for_hotplug(void);
+extern void cpuset_read_only_lock(unsigned long *flags);
+extern void cpuset_read_only_unlock(unsigned long *flags);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -176,6 +178,18 @@ static inline void cpuset_update_active_cpus(void)
 
 static inline void cpuset_wait_for_hotplug(void) { }
 
+static inline void cpuset_read_only_lock(unsigned long *flags)
+{
+	local_irq_save(*flags);
+	preempt_disable();
+}
+
+static inline void cpuset_read_only_unlock(unsigned long *flags)
+{
+	local_irq_restore(*flags);
+	preempt_enable();
+}
+
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ff9bd5abe613..ca5364f037a1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -318,7 +318,8 @@ static struct cpuset top_cpuset = {
  * __alloc_pages().
  *
  * If a task is only holding callback_lock, then it has read-only
- * access to cpusets.
+ * access to cpusets. Mind that callback_lock might be grabbed from other
+ * subsystems as well (via cpuset_read_only_lock()).
  *
  * Now, the task_struct fields mems_allowed and mempolicy may be changed
  * by other task, we use alloc_lock in the task_struct fields to protect
@@ -3233,6 +3234,30 @@ void __init cpuset_init_smp(void)
 	BUG_ON(!cpuset_migrate_mm_wq);
 }
 
+/**
+ * cpuset_read_only_lock - Grab the callback_lock from cpuset subsystem.
+ *
+ * Description: As described in full details the comment above cpuset_mutex
+ * and callback_lock definitions, holding callback_lock gives the holder
+ * read-only access to cpusets. Even though it might look counter-intuitive
+ * (as callback_lock is a spinlock), in fact a task must hold both
+ * callback_lock _and_ cpuset_mutex to modify cpusets (write access).
+ */
+void cpuset_read_only_lock(unsigned long *flags)
+	__acquires(&callback_lock)
+{
+	raw_spin_lock_irqsave(&callback_lock, *flags);
+}
+
+/**
+ * cpuset_read_only_unlock - Release the callback_lock from cpuset subsystem.
+ */
+void cpuset_read_only_unlock(unsigned long *flags)
+	__releases(&callback_lock)
+{
+	raw_spin_unlock_irqrestore(&callback_lock, *flags);
+}
+
 /**
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 98e835de1e7b..543eb31aa243 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4260,14 +4260,25 @@ static int __sched_setscheduler(struct task_struct *p,
 			return retval;
 	}
 
+	/*
+	 * Make sure we don't race with the cpuset subsystem where root
+	 * domains can be rebuilt or modified while operations like DL
+	 * admission checks are carried out.
+	 */
+	cpuset_read_only_lock(&rf.flags);
+
 	/*
 	 * Make sure no PI-waiters arrive (or leave) while we are
 	 * changing the priority of the task:
-	 *
+	 */
+
+	raw_spin_lock(&p->pi_lock);
+
+	/*
 	 * To be able to change p->policy safely, the appropriate
 	 * runqueue lock must be held.
 	 */
-	rq = task_rq_lock(p, &rf);
+	rq = __task_rq_lock(p, &rf);
 	update_rq_clock(rq);
 
 	/*
@@ -4331,7 +4342,9 @@ static int __sched_setscheduler(struct task_struct *p,
 	/* Re-check policy now with rq lock held: */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
-		task_rq_unlock(rq, p, &rf);
+		__task_rq_unlock(rq, &rf);
+		raw_spin_unlock(&p->pi_lock);
+		cpuset_read_only_unlock(&rf.flags);
 		goto recheck;
 	}
 
@@ -4388,7 +4401,9 @@ static int __sched_setscheduler(struct task_struct *p,
 
 	/* Avoid rq from going away on us: */
 	preempt_disable();
-	task_rq_unlock(rq, p, &rf);
+	__task_rq_unlock(rq, &rf);
+	raw_spin_unlock(&p->pi_lock);
+	cpuset_read_only_unlock(&rf.flags);
 
 	if (pi)
 		rt_mutex_adjust_pi(p);
@@ -4400,7 +4415,9 @@ static int __sched_setscheduler(struct task_struct *p,
 	return 0;
 
 unlock:
-	task_rq_unlock(rq, p, &rf);
+	__task_rq_unlock(rq, &rf);
+	raw_spin_unlock(&p->pi_lock);
+	cpuset_read_only_unlock(&rf.flags);
 	return retval;
 }
 
-- 
2.17.2

