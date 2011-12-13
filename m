From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] sched: fix cgroup movement of forking process
Date: Tue, 13 Dec 2011 04:22:24 -0800
Message-ID: <CAPM31R+fpQYJQo54RQ27HT6_OiYTeka86aX-37QyKxryidWLYA@mail.gmail.com>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp> <20111213155856.aebd6cd0.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=viwtHcOweRLNKdYp85SayZ1QLd3xOrXdZcvMtoQuZnE=;
        b=enQutNSwwjKWdG5s+0d2aRmveFQtggbQVnI7KgE4xEWLBt4ZT5UOTlQBwpVyuDMnVo
         t0JptVwOBSOte4nmHXuA==
In-Reply-To: <20111213155856.aebd6cd0.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

On Mon, Dec 12, 2011 at 10:58 PM, Daisuke Nishimura
<nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org> wrote:
> There is a small race between task_fork_fair() and sched_move_task(),
> which is trying to move the parent.
>
> =A0 =A0 =A0 =A0task_fork_fair() =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sched=
_move_task()
> --------------------------------+---------------------------------
> =A0cfs_rq =3D task_cfs_rq(current)
> =A0 =A0-> cfs_rq is the "old" one.
> =A0curr =3D cfs_rq->curr
> =A0 =A0-> curr is set to the parent.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
task_rq_lock()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
dequeue_task()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0->parent.se.vruntime -=3D (old)cfs_rq->min_vruntime
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
enqueue_task()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0->parent.se.vruntime +=3D (new)cfs_rq->min_vruntime
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
task_rq_unlock()
> =A0raw_spin_lock_irqsave(rq->lock)
> =A0se->vruntime =3D curr->vruntime
> =A0 =A0-> vruntime of the child is set to that of the parent
> =A0 =A0 =A0 which has already been updated by sched_move_task().
> =A0se->vruntime -=3D (old)cfs_rq->min_vruntime.
> =A0raw_spin_unlock_irqrestore(rq->lock)
>
> As a result, vruntime of the child becomes far bigger than expected,
> if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
>
> This patch fixes this problem by setting "cfs_rq" and "curr" after ho=
lding
> the rq->lock.
>
> Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
> ---
> =A0kernel/sched_fair.c | =A0 =A07 +++++--
> =A01 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index df145a9..bdaa4ab 100644
> --- a/kernel/sched_fair.cthis
> +++ b/kernel/sched_fair.c
> @@ -4787,14 +4787,17 @@ static void task_tick_fair(struct rq *rq, str=
uct task_struct *curr, int queued)
> =A0*/this
> =A0static void task_fork_fair(struct task_struct *p)
> =A0{
> - =A0 =A0 =A0 struct cfs_rq *cfs_rq =3D task_cfs_rq(current);
> - =A0 =A0 =A0 struct sched_entity *se =3D &p->se, *curr =3D cfs_rq->c=
urr;

Strictly speaking we're calling
current->sched_class-(*)->task_fork_fair() so we know current is in
sched_fair, which means it has to be cfs_rq->curr.

Because of that this could become be *curr =3D &current->se and then
cfs_rq_of(curr) below.

But the current healthy paranoia is ok too.

> + =A0 =A0 =A0 struct cfs_rq *cfs_rq;
> + =A0 =A0 =A0 struct sched_entity *se =3D &p->se, *curr;
> =A0 =A0 =A0 =A0int this_cpu =3D smp_processor_id();
> =A0 =A0 =A0 =A0struct rq *rq =3D this_rq();
> =A0 =A0 =A0 =A0unsigned long flags;
>
> =A0 =A0 =A0 =A0raw_spin_lock_irqsave(&rq->lock, flags);
>
> + =A0 =A0 =A0 cfs_rq =3D task_cfs_rq(current);
> + =A0 =A0 =A0 curr =3D cfs_rq->curr;
> +
> =A0 =A0 =A0 =A0update_rq_clock(rq);
>
> =A0 =A0 =A0 =A0if (unlikely(task_cpu(p) !=3D this_cpu)) {
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Acked-by: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
