From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: [PATCH 2/3] sched: fix cgroup movement of forking process
Date: Thu, 15 Dec 2011 14:36:55 +0900
Message-ID: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
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

There is a small race between task_fork_fair() and sched_move_task(),
which is trying to move the parent.

        task_fork_fair()                 sched_move_task()
--------------------------------+---------------------------------
  cfs_rq = task_cfs_rq(current)
    -> cfs_rq is the "old" one.
  curr = cfs_rq->curr
    -> curr is set to the parent.
                                    task_rq_lock()
                                    dequeue_task()
                                      ->parent.se.vruntime -= (old)cfs_rq->min_vruntime
                                    enqueue_task()
                                      ->parent.se.vruntime += (new)cfs_rq->min_vruntime
                                    task_rq_unlock()
  raw_spin_lock_irqsave(rq->lock)
  se->vruntime = curr->vruntime
    -> vruntime of the child is set to that of the parent
       which has already been updated by sched_move_task().
  se->vruntime -= (old)cfs_rq->min_vruntime.
  raw_spin_unlock_irqrestore(rq->lock)

As a result, vruntime of the child becomes far bigger than expected,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by setting "cfs_rq" and "curr" after
holding the rq->lock.

Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Acked-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/fair.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43cadd0..b1db01b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5191,8 +5191,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
  */
 static void task_fork_fair(struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(current);
-	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &p->se, *curr;
 	int this_cpu = smp_processor_id();
 	struct rq *rq = this_rq();
 	unsigned long flags;
@@ -5201,6 +5201,9 @@ static void task_fork_fair(struct task_struct *p)
 
 	update_rq_clock(rq);
 
+	cfs_rq = task_cfs_rq(current);
+	curr = cfs_rq->curr;
+
 	if (unlikely(task_cpu(p) != this_cpu)) {
 		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
