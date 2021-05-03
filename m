From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] psi: fix psi state corruption when schedule() races with cgroup move
Date: Mon,  3 May 2021 13:49:17 -0400
Message-ID: <20210503174917.38579-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=px9JwR74/bTPwn0UoWBvquYLMAYEbFs8/lK92VClKzo=;
        b=dWdCr/MLTjCiUzt2xEIBacRzgkQbmQFG8s2VKZ6dfClQjeqaiwKd9BmmnfQxlwMaZF
         Gh5/+IT1kb+lec6jYWZsMacsc/0r3uPb2+F5H5VGdBNVxjsA9SY7MR3zZa/vH+gUzycY
         9w1bVqt1AUKgIrri6H9rlvaRyWpMO7jlJVAHfOVtLurOnc8x8fUQXSaR9AcAKSBurTWo
         y+RsYuxlna1wMn1exVQ4FhuKWAW2RCOK94XU/nq7WvSU5jfK8Z+EP4ITTLm+EeM1htPb
         e2uWCQn/TDY0aAah5DWjWUcnG1hQUZ8G9CZjGab4Jf7XuoOUq6e6QZHF+V6S0vsGSq5O
         jNQg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
introduced a race condition that corrupts internal psi state. This
manifests as kernel warnings, sometimes followed by bogusly high IO
pressure:

  psi: task underflow! cpu=1 t=2 tasks=[0 0 0 0] clear=c set=0
  (schedule() decreasing RUNNING and ONCPU, both of which are 0)

  psi: incosistent task state! task=2412744:systemd cpu=17 psi_flags=e clear=3 set=0
  (cgroup_move_task() clearing MEMSTALL and IOWAIT, but task is MEMSTALL | RUNNING | ONCPU)

What the offending commit does is batch the two psi callbacks in
schedule() to reduce the number of cgroup tree updates. When prev is
deactivated and removed from the runqueue, nothing is done in psi at
first; when the task switch completes, TSK_RUNNING and TSK_IOWAIT are
updated along with TSK_ONCPU.

However, the deactivation and the task switch inside schedule() aren't
atomic: pick_next_task() may drop the rq lock for load balancing. When
this happens, cgroup_move_task() can run after the task has been
physically dequeued, but the psi updates are still pending. Since it
looks at the task's scheduler state, it doesn't move everything to the
new cgroup that the task switch that follows is about to clear from
it. cgroup_move_task() will leak the TSK_RUNNING count in the old
cgroup, and psi_sched_switch() will underflow it in the new cgroup.

A similar thing can happen for iowait. TSK_IOWAIT is usually set when
a p->in_iowait task is dequeued, but again this update is deferred to
the switch. cgroup_move_task() can see an unqueued p->in_iowait task
and move a non-existent TSK_IOWAIT. This results in the inconsistent
task state warning, as well as a counter underflow that will result in
permanent IO ghost pressure being reported.

Fix this bug by making cgroup_move_task() use task->psi_flags instead
of looking at the potentially mismatching scheduler state.

[ We used the scheduler state historically in order to not rely on
  task->psi_flags for anything but debugging. But that ship has sailed
  anyway, and this is simpler and more robust.

  We previously already batched TSK_ONCPU clearing with the
  TSK_RUNNING update inside the deactivation call from schedule(). But
  that ordering was safe and didn't result in TSK_ONCPU corruption:
  unlike most places in the scheduler, cgroup_move_task() only checked
  task_current() and handled TSK_ONCPU if the task was still queued. ]

Fixes: 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 kernel/sched/psi.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index db27b69fa92a..cc25a3cff41f 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -972,7 +972,7 @@ void psi_cgroup_free(struct cgroup *cgroup)
  */
 void cgroup_move_task(struct task_struct *task, struct css_set *to)
 {
-	unsigned int task_flags = 0;
+	unsigned int task_flags;
 	struct rq_flags rf;
 	struct rq *rq;
 
@@ -987,15 +987,31 @@ void cgroup_move_task(struct task_struct *task, struct css_set *to)
 
 	rq = task_rq_lock(task, &rf);
 
-	if (task_on_rq_queued(task)) {
-		task_flags = TSK_RUNNING;
-		if (task_current(rq, task))
-			task_flags |= TSK_ONCPU;
-	} else if (task->in_iowait)
-		task_flags = TSK_IOWAIT;
-
-	if (task->in_memstall)
-		task_flags |= TSK_MEMSTALL;
+	/*
+	 * We may race with schedule() dropping the rq lock between
+	 * deactivating prev and switching to next. Because the psi
+	 * updates from the deactivation are deferred to the switch
+	 * callback to save cgroup tree updates, the task's scheduling
+	 * state here is not coherent with its psi state:
+	 *
+	 * schedule()                   cgroup_move_task()
+	 *   rq_lock()
+	 *   deactivate_task()
+	 *     p->on_rq = 0
+	 *     psi_dequeue() // defers TSK_RUNNING & TSK_IOWAIT updates
+	 *   pick_next_task()
+	 *     rq_unlock()
+	 *                                rq_lock()
+	 *                                psi_task_change() // old cgroup
+	 *                                task->cgroups = to
+	 *                                psi_task_change() // new cgroup
+	 *                                rq_unlock()
+	 *     rq_lock()
+	 *   psi_sched_switch() // does deferred updates in new cgroup
+	 *
+	 * Don't rely on the scheduling state. Use psi_flags instead.
+	 */
+	task_flags = task->psi_flags;
 
 	if (task_flags)
 		psi_task_change(task, task_flags, 0);
-- 
2.31.0

