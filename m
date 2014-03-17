From: lwcheng-E/cL/jq2xZNaa/9Udqfwiw@public.gmane.org
Subject: [Question] Linux CFS sched_entity
Date: Mon, 17 Mar 2014 13:05:35 +0800
Message-ID: <20140317130535.17434rbodaohuqgw@intranet.cs.hku.hk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; delsp="Yes"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I am studying Linux CFS recently. After numerous searches, I am still
unable to get rid of the following question. Finally I decide to bother
this group for the answer.

In group scheduling, sched_entity can represent both "task group" and "task",
indicated by "se->my_q".
When CFS tries to pick a new task, it first selects a "task group" and then
selects a "task" from that "task group":
--------------
static struct task_struct *pick_next_task_fair(struct rq *rq)
{
     struct task_struct *p;
     struct cfs_rq *cfs_rq = &rq->cfs;
     struct sched_entity *se;

     ... ...
     do {
         se = pick_next_entity(cfs_rq);
         set_next_entity(cfs_rq, se);
         cfs_rq = group_cfs_rq(se);
     } while (cfs_rq);

     p = task_of(se);
     ... ...
}
--------------
Therefore, cfs_rq->curr should *always* represent a "task" here, right?

However, cfs_rq->curr seems *not* to be a "task" sometimes:
--------------
static void update_curr(struct cfs_rq *cfs_rq)
{
     struct sched_entity *curr = cfs_rq->curr;

     ... ...
     if (entity_is_task(curr)) {              /* WHY? */
         struct task_struct *curtask = task_of(curr);

         trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
         cpuacct_charge(curtask, delta_exec);
         account_group_exec_runtime(curtask, delta_exec);
     }
     ... ...
}
--------------

My question is:
In what situations does cfs_rq->curr point to a task_group?
What's the sense? I thought it should always contain a "real" task.

Appreciated for anyone who is able to help. Thanks in advance!

Regards,
Luwei Cheng
--
CS Student
The University of Hong Kong
