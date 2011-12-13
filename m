From: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH 1/3] sched: fix cgroup movement of newly created process
Date: Tue, 13 Dec 2011 13:41:09 +0100
Message-ID: <1323780069.9082.15.camel@twins>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	 <20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111213155758.30d2787e.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>

On Tue, 2011-12-13 at 15:57 +0900, Daisuke Nishimura wrote:

>  kernel/sched_fair.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

you blink you loose, that file doesn't exist anymore.


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
>  	set_task_rq(p, task_cpu(p));
> -	if (!on_rq)
> +	if (!on_rq && p->state != TASK_RUNNING)
>  		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
>  }
>  #endif

The much saner way of writing that is something like:

 /*
  * Comment explaining stuff..
  */
 if (!on_rq && p->state == TASK_RUNNING)
	on_rq = 1;

 ...


--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
