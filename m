From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 10/11] sched: change nr_context_switches calculation.
Date: Wed, 29 May 2013 15:03:21 +0400
Message-ID: <1369825402-31046-11-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

This patch changes the calculation of nr_context_switches. The variable
"nr_switches" is now used to account for the number of transition to the
idle task, or stop task. It is removed from the schedule() path.

The total calculation can be made using the fact that the transitions to
fair and rt classes are recorded in the root_task_group. One can easily
derive the total figure by adding those quantities together.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c      | 17 +++++++++++++++--
 kernel/sched/idle_task.c |  3 +++
 kernel/sched/stop_task.c |  2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3b1441f..892c828 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2031,13 +2031,27 @@ unsigned long nr_running(void)
 	return sum;
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+#define cfs_nr_switches(tg, cpu) (tg)->cfs_rq[cpu]->nr_switches
+#else
+#define cfs_nr_switches(tg, cpu) cpu_rq(cpu)->cfs.nr_switches
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+#define rt_nr_switches(tg, cpu) (tg)->rt_rq[cpu]->rt_nr_switches
+#else
+#define rt_nr_switches(tg, cpu) cpu_rq(cpu)->rt.rt_nr_switches
+#endif
+
 unsigned long long nr_context_switches(void)
 {
 	int i;
 	unsigned long long sum = 0;
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
+		sum += cfs_nr_switches(&root_task_group, i);
+		sum += rt_nr_switches(&root_task_group, i);
 		sum += cpu_rq(i)->nr_switches;
+	}
 
 	return sum;
 }
@@ -2417,7 +2431,6 @@ need_resched:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
 
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 4f0a332..923286c 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -39,6 +39,9 @@ pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 	if (prev)
 		prev->sched_class->put_prev_task(rq, prev);
 
+	if (prev != rq->idle)
+		rq->nr_switches++;
+
 	schedstat_inc(rq, sched_goidle);
 #ifdef CONFIG_SMP
 	/* Trigger the post schedule to do an idle_enter for CFS */
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 6adf6a9..48c572a 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -32,6 +32,8 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 		stop->se.exec_start = rq_clock_task(rq);
 		if (prev)
 			prev->sched_class->put_prev_task(rq, prev);
+		if (prev != rq->stop)
+			rq->nr_switches++;
 		return stop;
 	}
 
-- 
1.8.1.4
