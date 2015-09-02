From: Juri Lelli <juri.lelli@arm.com>
Subject: [PATCH 1/4] sched/{cpuset,core}: restore complete root_domain status across hotplug
Date: Wed,  2 Sep 2015 11:01:33 +0100
Message-ID: <1441188096-23021-2-git-send-email-juri.lelli@arm.com>
References: <1441188096-23021-1-git-send-email-juri.lelli@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441188096-23021-1-git-send-email-juri.lelli@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, juri.lelli@arm.com, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

Hotplug operations are destructive w.r.t data associated with cpuset;
in this case we care about root_domains. SCHED_DEADLINE puts bandwidth
information regarding admitted tasks on root_domains, information that
is gone when an hotplug operation happens. Also, it is not currently
possible to tell to which task(s) the allocated bandwidth belongs, as
this link is lost after sched_setscheduler() succeeds.

This patch forces rebuilding of allocated bandwidth information at
root_domain level after cpuset_hotplug_workfn() callback is done
setting up scheduling and root domains.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org
Reported-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Juri Lelli <juri.lelli@arm.com>
---
 include/linux/sched.h |  2 ++
 kernel/cpuset.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c   | 17 +++++++++++++++++
 3 files changed, 60 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 81bb457..cc02c68 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2175,6 +2175,8 @@ extern int cpuset_cpumask_can_shrink(const struct cpumask *cur,
 				     const struct cpumask *trial);
 extern int task_can_attach(struct task_struct *p,
 			   const struct cpumask *cs_cpus_allowed);
+void sched_restore_dl_bw(struct task_struct *task,
+			 const struct cpumask *new_mask);
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p,
 			       const struct cpumask *new_mask);
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ee14e3a..d3962ea 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2221,6 +2221,45 @@ retry:
 }
 
 /**
+ * update_tasks_rd - Update tasks' root_domains status.
+ * @cs: the cpuset to which each task's root_domain belongs
+ *
+ * Iterate through each task of @cs updating state of its related
+ * root_domain.
+ */
+static void update_tasks_rd(struct cpuset *cs)
+{
+	struct css_task_iter it;
+	struct task_struct *task;
+
+	css_task_iter_start(&cs->css, &it);
+	while ((task = css_task_iter_next(&it)))
+		sched_restore_dl_bw(task, cs->effective_cpus);
+	css_task_iter_end(&it);
+}
+
+static void cpuset_hotplug_update_rd(void)
+{
+	struct cpuset *cs;
+	struct cgroup_subsys_state *pos_css;
+
+	mutex_lock(&cpuset_mutex);
+	rcu_read_lock();
+	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
+		if (!css_tryget_online(&cs->css))
+			continue;
+		rcu_read_unlock();
+
+		update_tasks_rd(cs);
+
+		rcu_read_lock();
+		css_put(&cs->css);
+	}
+	rcu_read_unlock();
+	mutex_unlock(&cpuset_mutex);
+}
+
+/**
  * cpuset_hotplug_workfn - handle CPU/memory hotunplug for a cpuset
  *
  * This function is called after either CPU or memory configuration has
@@ -2296,6 +2335,8 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	/* rebuild sched domains if cpus_allowed has changed */
 	if (cpus_updated)
 		rebuild_sched_domains();
+
+	cpuset_hotplug_update_rd();
 }
 
 void cpuset_update_active_cpus(bool cpu_online)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9917c96..c747e86 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2284,6 +2284,23 @@ static inline int dl_bw_cpus(int i)
 }
 #endif
 
+void sched_restore_dl_bw(struct task_struct *task,
+			 const struct cpumask *new_mask)
+{
+	struct dl_bw *dl_b;
+	unsigned long flags;
+
+	if (!task_has_dl_policy(task))
+		return;
+
+	rcu_read_lock_sched();
+	dl_b = dl_bw_of(cpumask_any(new_mask));
+	raw_spin_lock_irqsave(&dl_b->lock, flags);
+	dl_b->total_bw += task->dl.dl_bw;
+	raw_spin_unlock_irqrestore(&dl_b->lock, flags);
+	rcu_read_unlock_sched();
+}
+
 /*
  * We must be sure that accepting a new task (or allowing changing the
  * parameters of an existing one) is consistent with the bandwidth
-- 
2.2.2
