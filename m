From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: fix cgroup movement of waking process
Date: Tue, 13 Dec 2011 04:24:23 -0800
Message-ID: <CAPM31R+Q2x2Mv+RGW+Yp11p=aB3aX8=jVT1OvSwHT2NFRcakqA@mail.gmail.com>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp> <20111213155933.36cd824a.nishimura@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=xoeAWnooHI4f/dvbLZRiZqKNxm+CiiDsoVofSfsBx8A=;
        b=upd/yFtLdHrmQ/92PnDJMGOBObHYu8XizMUOJm40wPEnYQJA32WvJ/V+HAmMGCRm4i
         VZ+BxvKr2tAT6WpzLB1A==
In-Reply-To: <20111213155933.36cd824a.nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

On Mon, Dec 12, 2011 at 10:59 PM, Daisuke Nishimura
<nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org> wrote:
> There is a small race between try_to_wake_up() and sched_move_task(),=
 which is trying
> to move the process being woken up.
>
> =A0 =A0try_to_wake_up() on CPU0 =A0 =A0 =A0 sched_move_task() on CPU1
> --------------------------------+---------------------------------
> =A0raw_spin_lock_irqsave(p->pi_lock)
> =A0task_waking_fair()
> =A0 =A0->p.se.vruntime -=3D cfs_rq->min_vruntime
> =A0ttwu_queue()
> =A0 =A0->send reschedule IPI to another CPU1
> =A0raw_spin_unlock_irqsave(p->pi_lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t=
ask_rq_lock()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 -> tring to aquire both p->pi_lock and rq->lock
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0with IRQ disabled
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t=
ask_move_group_fair()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 ->p.se.vruntime -=3D (old)cfs_rq->min_vruntime
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 ->p.se.vruntime +=3D (new)cfs_rq->min_vruntime
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 t=
ask_rq_unlock()
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (=
via IPI)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
ched_ttwu_pending()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 raw_spin_lock(rq->lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 ttwu_do_activate()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 ...
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 enqueue_entity()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 child.se->vruntime +=3D cfs_rq->min_vruntime
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 raw_spin_unlock(rq->lock)
>
> As a result, vruntime of the process becomes far bigger than min_vrun=
time,
> if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.
>
> This patch fixes this problem by just ignoring such process in task_m=
ove_group_fair(),
> because the vruntime has already been normalized in task_waking_fair(=
).
>
> Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
> ---
> =A0kernel/sched_fair.c | =A0 =A04 ++--
> =A01 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index bdaa4ab..3feb3a2 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -4925,10 +4925,10 @@ static void task_move_group_fair(struct task_=
struct *p, int on_rq)
> =A0 =A0 =A0 =A0 * to another cgroup's rq. This does somewhat interfer=
e with the
> =A0 =A0 =A0 =A0 * fair sleeper stuff for the first placement, but who=
 cares.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (!on_rq && p->state !=3D TASK_RUNNING)
> + =A0 =A0 =A0 if (!on_rq && p->state !=3D TASK_RUNNING && p->state !=3D=
 TASK_WAKING)

!p->se.sum_exec_runtime is starting to look more attractive here...

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p->se.vruntime -=3D cfs_rq_of(&p->se)-=
>min_vruntime;
> =A0 =A0 =A0 =A0set_task_rq(p, task_cpu(p));
> - =A0 =A0 =A0 if (!on_rq && p->state !=3D TASK_RUNNING)
> + =A0 =A0 =A0 if (!on_rq && p->state !=3D TASK_RUNNING && p->state !=3D=
 TASK_WAKING)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0p->se.vruntime +=3D cfs_rq_of(&p->se)-=
>min_vruntime;
> =A0}
> =A0#endif
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
