From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 2/3] psi: optimize switching tasks inside shared cgroups
Date: Mon, 16 Mar 2020 15:13:32 -0400
Message-ID: <20200316191333.115523-3-hannes@cmpxchg.org>
References: <20200316191333.115523-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=khwS4toKf6D+DVV7MNME1Tx0UEPy+NTQSpLO/dCP8hg=;
        b=fskKj2fnyAqGP5sXUZVY11JWJAFy/swvEwszQx9S2O5xcibUiW25SdUiEzks/+MHII
         TfOllR0qH841Vwq6JydD2OolpB36o1u5sve0UOzbLKDGbZMWj6HkBV07wBX16BeQSzxZ
         g9slUVHbYyICdyCGiL9hXTGsjR3WKJJPifFXxFFUTdH8Ml4zvJgsVnWhCGSmphDAgUAU
         EHRZF3f98FKq46UG+eHB36sysYaUZPpytN9TasCw+jQIItHsYtiYbc//hPRn84LJkruk
         xgA98z3f3FyuGIOmfiFMln8cZocfrv3HnqNx59Ort6AKRftVnq1b6jiBpcwPEsIRdRLA
         HDkg==
In-Reply-To: <20200316191333.115523-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

When switching tasks running on a CPU, the psi state of a cgroup
containing both of these tasks does not change. Right now, we don't
exploit that, and can perform many unnecessary state changes in nested
hierarchies, especially when most activity comes from one leaf cgroup.

This patch implements an optimization where we only update cgroups
whose state actually changes during a task switch. These are all
cgroups that contain one task but not the other, up to the first
shared ancestor. When both tasks are in the same group, we don't need
to update anything at all.

We can identify the first shared ancestor by walking the groups of the
incoming task until we see TSK_ONCPU set on the local CPU; that's the
first group that also contains the outgoing task.

The new psi_task_switch() is similar to psi_task_change(). To allow
code reuse, move the task flag maintenance code into a new function
and the poll/avg worker wakeups into the shared psi_group_change().

Suggested-by: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 include/linux/psi.h  |  2 +
 kernel/sched/psi.c   | 87 ++++++++++++++++++++++++++++++++++----------
 kernel/sched/stats.h |  9 +----
 3 files changed, 70 insertions(+), 28 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index 7b3de7321219..7361023f3fdd 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -17,6 +17,8 @@ extern struct psi_group psi_system;
 void psi_init(void);
 
 void psi_task_change(struct task_struct *task, int clear, int set);
+void psi_task_switch(struct task_struct *prev, struct task_struct *next,
+		     bool sleep);
 
 void psi_memstall_tick(struct task_struct *task, int cpu);
 void psi_memstall_enter(unsigned long *flags);
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 50128297a4f9..955a124bae81 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -669,13 +669,14 @@ static void record_times(struct psi_group_cpu *groupc, int cpu,
 		groupc->times[PSI_NONIDLE] += delta;
 }
 
-static u32 psi_group_change(struct psi_group *group, int cpu,
-			    unsigned int clear, unsigned int set)
+static void psi_group_change(struct psi_group *group, int cpu,
+			     unsigned int clear, unsigned int set,
+			     bool wake_clock)
 {
 	struct psi_group_cpu *groupc;
+	u32 state_mask = 0;
 	unsigned int t, m;
 	enum psi_states s;
-	u32 state_mask = 0;
 
 	groupc = per_cpu_ptr(group->pcpu, cpu);
 
@@ -717,7 +718,11 @@ static u32 psi_group_change(struct psi_group *group, int cpu,
 
 	write_seqcount_end(&groupc->seq);
 
-	return state_mask;
+	if (state_mask & group->poll_states)
+		psi_schedule_poll_work(group, 1);
+
+	if (wake_clock && !delayed_work_pending(&group->avgs_work))
+		schedule_delayed_work(&group->avgs_work, PSI_FREQ);
 }
 
 static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
@@ -744,27 +749,32 @@ static struct psi_group *iterate_groups(struct task_struct *task, void **iter)
 	return &psi_system;
 }
 
-void psi_task_change(struct task_struct *task, int clear, int set)
+static void psi_flags_change(struct task_struct *task, int clear, int set)
 {
-	int cpu = task_cpu(task);
-	struct psi_group *group;
-	bool wake_clock = true;
-	void *iter = NULL;
-
-	if (!task->pid)
-		return;
-
 	if (((task->psi_flags & set) ||
 	     (task->psi_flags & clear) != clear) &&
 	    !psi_bug) {
 		printk_deferred(KERN_ERR "psi: inconsistent task state! task=%d:%s cpu=%d psi_flags=%x clear=%x set=%x\n",
-				task->pid, task->comm, cpu,
+				task->pid, task->comm, task_cpu(task),
 				task->psi_flags, clear, set);
 		psi_bug = 1;
 	}
 
 	task->psi_flags &= ~clear;
 	task->psi_flags |= set;
+}
+
+void psi_task_change(struct task_struct *task, int clear, int set)
+{
+	int cpu = task_cpu(task);
+	struct psi_group *group;
+	bool wake_clock = true;
+	void *iter = NULL;
+
+	if (!task->pid)
+		return;
+
+	psi_flags_change(task, clear, set);
 
 	/*
 	 * Periodic aggregation shuts off if there is a period of no
@@ -777,14 +787,51 @@ void psi_task_change(struct task_struct *task, int clear, int set)
 		     wq_worker_last_func(task) == psi_avgs_work))
 		wake_clock = false;
 
-	while ((group = iterate_groups(task, &iter))) {
-		u32 state_mask = psi_group_change(group, cpu, clear, set);
+	while ((group = iterate_groups(task, &iter)))
+		psi_group_change(group, cpu, clear, set, wake_clock);
+}
+
+void psi_task_switch(struct task_struct *prev, struct task_struct *next,
+		     bool sleep)
+{
+	struct psi_group *group, *common = NULL;
+	int cpu = task_cpu(prev);
+	void *iter;
+
+	if (next->pid) {
+		psi_flags_change(next, 0, TSK_ONCPU);
+		/*
+		 * When moving state between tasks, the group that
+		 * contains them both does not change: we can stop
+		 * updating the tree once we reach the first common
+		 * ancestor. Iterate @next's ancestors until we
+		 * encounter @prev's state.
+		 */
+		iter = NULL;
+		while ((group = iterate_groups(next, &iter))) {
+			if (per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
+				common = group;
+				break;
+			}
+
+			psi_group_change(group, cpu, 0, TSK_ONCPU, true);
+		}
+	}
+
+	/*
+	 * If this is a voluntary sleep, dequeue will have taken care
+	 * of the outgoing TSK_ONCPU alongside TSK_RUNNING already. We
+	 * only need to deal with it during preemption.
+	 */
+	if (sleep)
+		return;
 
-		if (state_mask & group->poll_states)
-			psi_schedule_poll_work(group, 1);
+	if (prev->pid) {
+		psi_flags_change(prev, TSK_ONCPU, 0);
 
-		if (wake_clock && !delayed_work_pending(&group->avgs_work))
-			schedule_delayed_work(&group->avgs_work, PSI_FREQ);
+		iter = NULL;
+		while ((group = iterate_groups(prev, &iter)) && group != common)
+			psi_group_change(group, cpu, TSK_ONCPU, 0, true);
 	}
 }
 
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 6ff0ac1a803f..1339f5bfe513 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -141,14 +141,7 @@ static inline void psi_sched_switch(struct task_struct *prev,
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	/*
-	 * Clear the TSK_ONCPU state if the task was preempted. If
-	 * it's a voluntary sleep, dequeue will have taken care of it.
-	 */
-	if (!sleep)
-		psi_task_change(prev, TSK_ONCPU, 0);
-
-	psi_task_change(next, 0, TSK_ONCPU);
+	psi_task_switch(prev, next, sleep);
 }
 
 static inline void psi_task_tick(struct rq *rq)
-- 
2.25.1

