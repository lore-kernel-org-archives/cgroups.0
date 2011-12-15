From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: [PATCH 1/3] sched: fix cgroup movement of newly created process
Date: Thu, 15 Dec 2011 14:36:07 +0900
Message-ID: <20111215143607.2ee12c5d.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	<20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111215143506.335e443e.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>

There is a small race between do_fork() and sched_move_task(), which is
trying to move the child.

            do_fork()                 sched_move_task()
--------------------------------+---------------------------------
  copy_process()
    sched_fork()
      task_fork_fair()
        -> vruntime of the child is initialized
           based on that of the parent.
  -> we can see the child in "tasks" file now.
                                    task_rq_lock()
                                    task_move_group_fair()
                                      -> child.se.vruntime
                                           -= (old)cfs_rq->min_vruntime
                                           += (new)cfs_rq->min_vruntime
                                    task_rq_unlock()
  wake_up_new_task()
    ...
    enqueue_entity()
      child.se.vruntime += cfs_rq->min_vruntime

As a result, vruntime of the child becomes far bigger than min_vruntime,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by just ignoring such process in
task_move_group_fair(), because the vruntime has already been normalized in
task_fork_fair().

Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..43cadd0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5336,6 +5336,19 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * to another cgroup's rq. This does somewhat interfere with the
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
+	/*
+	 * When !on_rq, vruntime of the task has usually NOT been normalized.
+	 * But there are some cases where it has already been normalized:
+	 *
+	 * - Moving a forked child which is waiting for being woken up by
+	 *   wake_up_new_task().
+	 *
+	 * To prevent boost or penalty in the new cfs_rq caused by delta
+	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
+	 */
+	if (!on_rq && !p->se.sum_exec_runtime)
+		on_rq = 1;
+
 	if (!on_rq)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
