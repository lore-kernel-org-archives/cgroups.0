From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v4 4/5] sched/core: Prevent race condition between cpuset and __sched_setscheduler()
Date: Wed, 13 Jun 2018 14:17:10 +0200
Message-ID: <20180613121711.5018-5-juri.lelli@redhat.com>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

No synchronisation mechanism exist between the cpuset subsystem and calls
to function __sched_setscheduler().  As such it is possible that new root
domains are created on the cpuset side while a deadline acceptance test
is carried out in __sched_setscheduler(), leading to a potential oversell
of CPU bandwidth.

By making available the cpuset_mutex to the core scheduler it is possible
to prevent situations such as the one described above from happening.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
[fixed missing cpuset_unlock() and changed to use mutex_trylock()]
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
---
 include/linux/cpuset.h |  6 ++++++
 kernel/cgroup/cpuset.c | 16 ++++++++++++++++
 kernel/sched/core.c    | 14 ++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 934633a05d20..a1970862ab8e 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -55,6 +55,8 @@ extern void cpuset_init_smp(void);
 extern void cpuset_force_rebuild(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_wait_for_hotplug(void);
+extern int cpuset_lock(void);
+extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -176,6 +178,10 @@ static inline void cpuset_update_active_cpus(void)
 
 static inline void cpuset_wait_for_hotplug(void) { }
 
+static inline int cpuset_lock(void) { return 1; }
+
+static inline void cpuset_unlock(void) { }
+
 static inline void cpuset_cpus_allowed(struct task_struct *p,
 				       struct cpumask *mask)
 {
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b42037e6e81d..d26fd4795aa3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2409,6 +2409,22 @@ void __init cpuset_init_smp(void)
 	BUG_ON(!cpuset_migrate_mm_wq);
 }
 
+/**
+ * cpuset_lock - Grab the cpuset_mutex from another subsysytem
+ */
+int cpuset_lock(void)
+{
+	return mutex_trylock(&cpuset_mutex);
+}
+
+/**
+ * cpuset_unlock - Release the cpuset_mutex from another subsysytem
+ */
+void cpuset_unlock(void)
+{
+	mutex_unlock(&cpuset_mutex);
+}
+
 /**
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ca788f74259d..a5b0c6c25b44 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4218,6 +4218,14 @@ static int __sched_setscheduler(struct task_struct *p,
 		if (attr->sched_flags & SCHED_FLAG_SUGOV)
 			return -EINVAL;
 
+		/*
+		 * Make sure we don't race with the cpuset subsystem where root
+		 * domains can be rebuilt or modified while operations like DL
+		 * admission checks are carried out.
+		 */
+		if (!cpuset_lock())
+			return -EBUSY;
+
 		retval = security_task_setscheduler(p);
 		if (retval)
 			return retval;
@@ -4295,6 +4303,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
 		task_rq_unlock(rq, p, &rf);
+		if (user)
+			cpuset_unlock();
 		goto recheck;
 	}
 
@@ -4352,6 +4362,8 @@ static int __sched_setscheduler(struct task_struct *p,
 	/* Avoid rq from going away on us: */
 	preempt_disable();
 	task_rq_unlock(rq, p, &rf);
+	if (user)
+		cpuset_unlock();
 
 	if (pi)
 		rt_mutex_adjust_pi(p);
@@ -4364,6 +4376,8 @@ static int __sched_setscheduler(struct task_struct *p,
 
 unlock:
 	task_rq_unlock(rq, p, &rf);
+	if (user)
+		cpuset_unlock();
 	return retval;
 }
 
-- 
2.14.3

