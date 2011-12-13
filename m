From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] sched: fix cgroup movement of newly created process
Date: Tue, 13 Dec 2011 04:01:21 -0800
Message-ID: <CAPM31RJzALSAcxEYELUbM0ZXwT=WoOHj7w-rDVC73VujnQVH1A@mail.gmail.com>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp> <20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:x-system-of-record;
        bh=B81OrzUK8EB+sfGQ1lGsfw4cDOcXJUdq1Z9KOWfNduo=;
        b=DcJygAw310Fj6Fq73h3DF8bi272C6IJxOh8OeD7fGi1tB9kfxhRfDseBT7WXeNdqvL
         eF3aTA+J/wKsgzcai4nQ==
In-Reply-To: <20111213155758.30d2787e.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

On 12/12/2011 10:57 PM, Daisuke Nishimura wrote:

> There is a small race between do_fork() and sched_move_task(), which is trying
> to move the child.
>
>             do_fork()                 sched_move_task()
> --------------------------------+---------------------------------
>   copy_process()
>     sched_fork()
>       task_fork_fair()
>         -> vruntime of the child is initialized
>            based on that of the parent.


Hmm, so here vruntime of child is actually initialized to vruntime - min_V

>   -> we can see the child in "tasks" file now.
>                                     task_rq_lock()
>                                     task_move_group_fair()


So since on a regular fork we just copy and don't actually go through
the attach muck I'm assuming this is an external actor who's seen the
child in the tasks file and is moving it?

>                                       ->child.se.vruntime -= (old)cfs_rq->min_vruntime
>                                       ->child.se.vruntime += (new)cfs_rq->min_vruntime


This would then add delta min_V between the two cfs_rqs

>                                     task_rq_unlock()
>   wake_up_new_task()
>     ...
>     enqueue_entity()
>       child.se->vruntime += cfs_rq->min_vruntime

>
> As a result, vruntime of the child becomes far bigger than min_vruntime,
> if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
>
> This patch fixes this problem by just ignoring such process in task_move_group_fair(),
> because the vruntime has already been normalized in task_fork_fair().
>
> Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> ---This would need an explanatory
>  kernel/sched_fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5c9e679..df145a9 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -4922,10 +4922,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
>  	 * to another cgroup's rq. This does somewhat interfere with the
>  	 * fair sleeper stuff for the first placement, but who cares.
>  	 */
> -	if (!on_rq)
> +	if (!on_rq && p->state != TASK_RUNNING)
>  		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;


We also have the choice of keying off something like
!se.sum_exec_runtime here which is reset in sched_fork() which might
be less fragile/make the problem interaction more obvious to.  Either
way this is really a corner case deserving of an explanatory comment.
This is a little icky but I don't have any wildly better ideas.

>  	set_task_rq(p, task_cpu(p));
> -	if (!on_rq)
> +	if (!on_rq && p->state != TASK_RUNNING)
>  		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
>  }
>  #endif


Acked-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
