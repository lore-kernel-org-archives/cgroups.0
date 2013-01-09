From: Glauber Costa <glommer@parallels.com>
Subject: [PATCH v5 10/11] sched: change nr_context_switches calculation.
Date: Wed,  9 Jan 2013 15:45:37 +0400
Message-ID: <1357731938-8417-11-git-send-email-glommer@parallels.com>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>, Glauber Costa <glommer@parallels.com>

This patch changes the calculation of nr_context_switches. The variable
"nr_switches" is now used to account for the number of transition to the
idle task, or stop task. It is removed from the schedule() path.

The total calculation can be made using the fact that the transitions to
fair and rt classes are recorded in the root_task_group. One can easily
derive the total figure by adding those quantities together.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
---
 kernel/sched/core.c      | 17 +++++++++++++++--
 kernel/sched/idle_task.c |  3 +++
 kernel/sched/stop_task.c |  2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c36df03..6bb56f0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2001,13 +2001,27 @@ unsigned long nr_uninterruptible(void)
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
@@ -2929,7 +2943,6 @@ need_resched:
 	rq->skip_clock_update = 0;
 
 	if (likely(prev != next)) {
-		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;
 
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 07e6027..652d98c 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -28,6 +28,9 @@ pick_next_task_idle(struct rq *rq, struct task_struct *prev)
 	if (prev)
 		prev->sched_class->put_prev_task(rq, prev);
 
+	if (prev != rq->idle)
+		rq->nr_switches++;
+
 	schedstat_inc(rq, sched_goidle);
 	return rq->idle;
 }
diff --git a/kernel/sched/stop_task.c b/kernel/sched/stop_task.c
index 5f10918..d1e9b82 100644
--- a/kernel/sched/stop_task.c
+++ b/kernel/sched/stop_task.c
@@ -32,6 +32,8 @@ pick_next_task_stop(struct rq *rq, struct task_struct *prev)
 		stop->se.exec_start = rq->clock_task;
 		if (prev)
 			prev->sched_class->put_prev_task(rq, prev);
+		if (prev != rq->stop)
+			rq->nr_switches++;
 		return stop;
 	}
 
-- 
1.7.11.7
