From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v6 4/5] sched/core: Prevent race condition between cpuset and __sched_setscheduler()
Date: Thu, 17 Jan 2019 09:47:38 +0100
Message-ID: <20190117084739.17078-5-juri.lelli@redhat.com>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190117084739.17078-1-juri.lelli@redhat.com>
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

v5->v6: Added more descriptive comments about why callback_lock gives
the holder read-only access to cpusets.
---
 include/linux/cpuset.h |  6 ++++++
 kernel/cgroup/cpuset.c | 25 ++++++++++++++++++++++++-
 kernel/sched/core.c    | 10 ++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 934633a05d20..8e5a8dd0622b 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -55,6 +55,8 @@ extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_wait_for_hotplug(void);
+extern void cpuset_read_only_lock(void);
+extern void cpuset_read_only_unlock(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -176,6 +178,10 @@ static inline void cpuset_update_active_cpus(void)
 
 static inline void cpuset_wait_for_hotplug(void) { }
 
+static inline void cpuset_read_only_lock(void) { }
+
+static inline void cpuset_read_only_unlock(void) { }
+
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 54b8ff5de7c8..8ee1b24b6353 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -330,7 +330,8 @@ static struct cpuset top_cpuset = {
  * __alloc_pages().
  *
  * If a task is only holding callback_lock, then it has read-only
- * access to cpusets.
+ * access to cpusets. Mind that callback_lock might be grabbed from other
+ * subsystems as well (via cpuset_read_only_lock()).
  *
  * Now, the task_struct fields mems_allowed and mempolicy may be changed
  * by other task, we use alloc_lock in the task_struct fields to protect
@@ -3218,6 +3219,28 @@ void __init cpuset_init_smp(void)
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
+void cpuset_read_only_lock(void)
+{
+	raw_spin_lock(&callback_lock);
+}
+
+/**
+ * cpuset_read_only_unlock - Release the callback_lock from cpuset subsystem.
+ */
+void cpuset_read_only_unlock(void)
+{
+	raw_spin_unlock(&callback_lock);
+}
+
 /**
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5263383170e..d928a42b8852 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4224,6 +4224,13 @@ static int __sched_setscheduler(struct task_struct *p,
 	rq = task_rq_lock(p, &rf);
 	update_rq_clock(rq);
 
+	/*
+	 * Make sure we don't race with the cpuset subsystem where root
+	 * domains can be rebuilt or modified while operations like DL
+	 * admission checks are carried out.
+	 */
+	cpuset_read_only_lock();
+
 	/*
 	 * Changing the policy of the stop threads its a very bad idea:
 	 */
@@ -4285,6 +4292,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	/* Re-check policy now with rq lock held: */
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
+		cpuset_read_only_unlock();
 		task_rq_unlock(rq, p, &rf);
 		goto recheck;
 	}
@@ -4342,6 +4350,7 @@ static int __sched_setscheduler(struct task_struct *p,
 
 	/* Avoid rq from going away on us: */
 	preempt_disable();
+	cpuset_read_only_unlock();
 	task_rq_unlock(rq, p, &rf);
 
 	if (pi)
@@ -4354,6 +4363,7 @@ static int __sched_setscheduler(struct task_struct *p,
 	return 0;
 
 unlock:
+	cpuset_read_only_unlock();
 	task_rq_unlock(rq, p, &rf);
 	return retval;
 }
-- 
2.17.2

