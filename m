From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: [PATCH 1/3] sched: fix cgroup movement of newly created process
Date: Tue, 13 Dec 2011 15:57:58 +0900
Message-ID: <20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111213155710.5b453415.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

There is a small race between do_fork() and sched_move_task(), which is trying
to move the child.

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
                                      ->child.se.vruntime -= (old)cfs_rq->min_vruntime
                                      ->child.se.vruntime += (new)cfs_rq->min_vruntime
                                    task_rq_unlock()
  wake_up_new_task()
    ...
    enqueue_entity()
      child.se->vruntime += cfs_rq->min_vruntime

As a result, vruntime of the child becomes far bigger than min_vruntime,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by just ignoring such process in task_move_group_fair(),
because the vruntime has already been normalized in task_fork_fair().

Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..df145a9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4922,10 +4922,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * to another cgroup's rq. This does somewhat interfere with the
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
-	if (!on_rq)
+	if (!on_rq && p->state != TASK_RUNNING)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
-	if (!on_rq)
+	if (!on_rq && p->state != TASK_RUNNING)
 		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
