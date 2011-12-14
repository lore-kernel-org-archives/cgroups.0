From: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: Re: [PATCH 1/3] sched: fix cgroup movement of newly created process
Date: Wed, 14 Dec 2011 10:04:38 +0900
Message-ID: <20111214100438.6226d661.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	<20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
	<CAPM31RJzALSAcxEYELUbM0ZXwT=WoOHj7w-rDVC73VujnQVH1A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPM31RJzALSAcxEYELUbM0ZXwT=WoOHj7w-rDVC73VujnQVH1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>

On Tue, 13 Dec 2011 04:01:21 -0800
Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On 12/12/2011 10:57 PM, Daisuke Nishimura wrote:
> 
> > There is a small race between do_fork() and sched_move_task(), which is trying
> > to move the child.
> >
> >             do_fork()                 sched_move_task()
> > --------------------------------+---------------------------------
> >   copy_process()
> >     sched_fork()
> >       task_fork_fair()
> >         -> vruntime of the child is initialized
> >            based on that of the parent.
> 
> 
> Hmm, so here vruntime of child is actually initialized to vruntime - min_V
> 
> >   -> we can see the child in "tasks" file now.
> >                                     task_rq_lock()
> >                                     task_move_group_fair()
> 
> 
> So since on a regular fork we just copy and don't actually go through
> the attach muck I'm assuming this is an external actor who's seen the
> child in the tasks file and is moving it?
> 
Right.

> >                                       ->child.se.vruntime -= (old)cfs_rq->min_vruntime
> >                                       ->child.se.vruntime += (new)cfs_rq->min_vruntime
> 
> 
> This would then add delta min_V between the two cfs_rqs
> 
> >                                     task_rq_unlock()
> >   wake_up_new_task()
> >     ...
> >     enqueue_entity()
> >       child.se->vruntime += cfs_rq->min_vruntime
> 
> >
> > As a result, vruntime of the child becomes far bigger than min_vruntime,
> > if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
> >
> > This patch fixes this problem by just ignoring such process in task_move_group_fair(),
> > because the vruntime has already been normalized in task_fork_fair().
> >
> > Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org>
> > ---This would need an explanatory
> >  kernel/sched_fair.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 5c9e679..df145a9 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -4922,10 +4922,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
> >  	 * to another cgroup's rq. This does somewhat interfere with the
> >  	 * fair sleeper stuff for the first placement, but who cares.
> >  	 */
> > -	if (!on_rq)
> > +	if (!on_rq && p->state != TASK_RUNNING)
> >  		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
> 
> 
> We also have the choice of keying off something like
> !se.sum_exec_runtime here which is reset in sched_fork() which might
> be less fragile/make the problem interaction more obvious to.  Either

sum_exec_runtime can be used for a process that has just been created,
but IIUC it cannot be used for a process that is being woken up from
sleeping(in [3/3] case).
Or, do you mean using p->se.sum_exec_runtime for [1/3] and p->state for [3/3] ?
If so, I'll do it in the next post.

> way this is really a corner case deserving of an explanatory comment.
> This is a little icky but I don't have any wildly better ideas.
> 
I'll add comments.

> >  	set_task_rq(p, task_cpu(p));
> > -	if (!on_rq)
> > +	if (!on_rq && p->state != TASK_RUNNING)
> >  		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
> >  }
> >  #endif
> 
> 
> Acked-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks you for your reviews.

Daisuke Nishimura.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
