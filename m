From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: [PATCH 3/3] sched: fix cgroup movement of waking process
Date: Tue, 13 Dec 2011 15:59:33 +0900
Message-ID: <20111213155933.36cd824a.nishimura@mxp.nes.nec.co.jp>
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

There is a small race between try_to_wake_up() and sched_move_task(), which is trying
to move the process being woken up.

    try_to_wake_up() on CPU0       sched_move_task() on CPU1
--------------------------------+---------------------------------
  raw_spin_lock_irqsave(p->pi_lock)
  task_waking_fair()
    ->p.se.vruntime -= cfs_rq->min_vruntime
  ttwu_queue()
    ->send reschedule IPI to another CPU1
  raw_spin_unlock_irqsave(p->pi_lock)
                                   task_rq_lock()
                                     -> tring to aquire both p->pi_lock and rq->lock
                                        with IRQ disabled
                                   task_move_group_fair()
                                     ->p.se.vruntime -= (old)cfs_rq->min_vruntime
                                     ->p.se.vruntime += (new)cfs_rq->min_vruntime
                                   task_rq_unlock()

                                   (via IPI)
                                   sched_ttwu_pending()
                                     raw_spin_lock(rq->lock)
                                     ttwu_do_activate()
                                       ...
                                       enqueue_entity()
                                         child.se->vruntime += cfs_rq->min_vruntime
                                     raw_spin_unlock(rq->lock)

As a result, vruntime of the process becomes far bigger than min_vruntime,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by just ignoring such process in task_move_group_fair(),
because the vruntime has already been normalized in task_waking_fair().

Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bdaa4ab..3feb3a2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4925,10 +4925,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * to another cgroup's rq. This does somewhat interfere with the
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
-	if (!on_rq && p->state != TASK_RUNNING)
+	if (!on_rq && p->state != TASK_RUNNING && p->state != TASK_WAKING)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
-	if (!on_rq && p->state != TASK_RUNNING)
+	if (!on_rq && p->state != TASK_RUNNING && p->state != TASK_WAKING)
 		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
