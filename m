From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: use spin_lock_irqsave in
 adjust_inuse_and_calc_cost
Date: Mon, 29 May 2023 21:04:05 +0800
Message-ID: <33d41ddd-73bd-8e12-9aba-e074c4d67deb@huaweicloud.com>
References: <20230527091904.3001833-1-linan666@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230527091904.3001833-1-linan666-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: linan666-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/05/27 17:19, linan666-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org =
=D0=B4=B5=C0:
> From: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> adjust_inuse_and_calc_cost() use spin_lock_irq() and IRQ will be enabled
> when unlock. DEADLOCK might happen if we have held other locks and disabl=
ed
> IRQ before invoking it.
>=20
> Fix it by using spin_lock_irqsave() instead, which can keep IRQ state
> consistent with before when unlock.
>=20
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    WARNING: inconsistent lock state
>    5.10.0-02758-g8e5f91fd772f #26 Not tainted
>    --------------------------------
>    inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
>    kworker/2:3/388 [HC0[0]:SC0[0]:HE0:SE1] takes:
>    ffff888118c00c28 (&bfqd->lock){?.-.}-{2:2}, at: spin_lock_irq
>    ffff888118c00c28 (&bfqd->lock){?.-.}-{2:2}, at: bfq_bio_merge+0x141/0x=
390
>    {IN-HARDIRQ-W} state was registered at:
>      __lock_acquire+0x3d7/0x1070
>      lock_acquire+0x197/0x4a0
>      __raw_spin_lock_irqsave
>      _raw_spin_lock_irqsave+0x3b/0x60
>      bfq_idle_slice_timer_body
>      bfq_idle_slice_timer+0x53/0x1d0
>      __run_hrtimer+0x477/0xa70
>      __hrtimer_run_queues+0x1c6/0x2d0
>      hrtimer_interrupt+0x302/0x9e0
>      local_apic_timer_interrupt
>      __sysvec_apic_timer_interrupt+0xfd/0x420
>      run_sysvec_on_irqstack_cond
>      sysvec_apic_timer_interrupt+0x46/0xa0
>      asm_sysvec_apic_timer_interrupt+0x12/0x20
>    irq event stamp: 837522
>    hardirqs last  enabled at (837521): [<ffffffff84b9419d>] __raw_spin_un=
lock_irqrestore
>    hardirqs last  enabled at (837521): [<ffffffff84b9419d>] _raw_spin_unl=
ock_irqrestore+0x3d/0x40
>    hardirqs last disabled at (837522): [<ffffffff84b93fa3>] __raw_spin_lo=
ck_irq
>    hardirqs last disabled at (837522): [<ffffffff84b93fa3>] _raw_spin_loc=
k_irq+0x43/0x50
>    softirqs last  enabled at (835852): [<ffffffff84e00558>] __do_softirq+=
0x558/0x8ec
>    softirqs last disabled at (835845): [<ffffffff84c010ff>] asm_call_irq_=
on_stack+0xf/0x20
>=20
>    other info that might help us debug this:
>     Possible unsafe locking scenario:
>=20
>           CPU0
>           ----
>      lock(&bfqd->lock);
>      <Interrupt>
>        lock(&bfqd->lock);
>=20
>     *** DEADLOCK ***
>=20
>    3 locks held by kworker/2:3/388:
>     #0: ffff888107af0f38 ((wq_completion)kthrotld){+.+.}-{0:0}, at: proce=
ss_one_work+0x742/0x13f0
>     #1: ffff8881176bfdd8 ((work_completion)(&td->dispatch_work)){+.+.}-{0=
:0}, at: process_one_work+0x777/0x13f0
>     #2: ffff888118c00c28 (&bfqd->lock){?.-.}-{2:2}, at: spin_lock_irq
>     #2: ffff888118c00c28 (&bfqd->lock){?.-.}-{2:2}, at: bfq_bio_merge+0x1=
41/0x390
>=20
>    stack backtrace:
>    CPU: 2 PID: 388 Comm: kworker/2:3 Not tainted 5.10.0-02758-g8e5f91fd77=
2f #26
>    Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0=
-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
>    Workqueue: kthrotld blk_throtl_dispatch_work_fn
>    Call Trace:
>     __dump_stack lib/dump_stack.c:77 [inline]
>     dump_stack+0x107/0x167
>     print_usage_bug
>     valid_state
>     mark_lock_irq.cold+0x32/0x3a
>     mark_lock+0x693/0xbc0
>     mark_held_locks+0x9e/0xe0
>     __trace_hardirqs_on_caller
>     lockdep_hardirqs_on_prepare.part.0+0x151/0x360
>     trace_hardirqs_on+0x5b/0x180
>     __raw_spin_unlock_irq
>     _raw_spin_unlock_irq+0x24/0x40
>     spin_unlock_irq
>     adjust_inuse_and_calc_cost+0x4fb/0x970
>     ioc_rqos_merge+0x277/0x740
>     __rq_qos_merge+0x62/0xb0
>     rq_qos_merge
>     bio_attempt_back_merge+0x12c/0x4a0
>     blk_mq_sched_try_merge+0x1b6/0x4d0
>     bfq_bio_merge+0x24a/0x390
>     __blk_mq_sched_bio_merge+0xa6/0x460
>     blk_mq_sched_bio_merge
>     blk_mq_submit_bio+0x2e7/0x1ee0
>     __submit_bio_noacct_mq+0x175/0x3b0
>     submit_bio_noacct+0x1fb/0x270
>     blk_throtl_dispatch_work_fn+0x1ef/0x2b0
>     process_one_work+0x83e/0x13f0
>     process_scheduled_works
>     worker_thread+0x7e3/0xd80
>     kthread+0x353/0x470
>     ret_from_fork+0x1f/0x30

So this happens when iocost is used together with bfq, performance will
be quite bad in this case, I don't think there will be any real use
case. However, the changes looks reasonable, feel free to add:

Reviewed-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Fixes: b0853ab4a238 ("blk-iocost: revamp in-period donation snapbacks")
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   block/blk-iocost.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 82e634d552d9..7581893e0d82 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2438,6 +2438,7 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_gq=
 *iocg, u64 vtime,
>   	u32 hwi, adj_step;
>   	s64 margin;
>   	u64 cost, new_inuse;
> +	unsigned long flags;
>  =20
>   	current_hweight(iocg, NULL, &hwi);
>   	old_hwi =3D hwi;
> @@ -2456,11 +2457,11 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_=
gq *iocg, u64 vtime,
>   	    iocg->inuse =3D=3D iocg->active)
>   		return cost;
>  =20
> -	spin_lock_irq(&ioc->lock);
> +	spin_lock_irqsave(&ioc->lock, flags);
>  =20
>   	/* we own inuse only when @iocg is in the normal active state */
>   	if (iocg->abs_vdebt || list_empty(&iocg->active_list)) {
> -		spin_unlock_irq(&ioc->lock);
> +		spin_unlock_irqrestore(&ioc->lock, flags);
>   		return cost;
>   	}
>  =20
> @@ -2481,7 +2482,7 @@ static u64 adjust_inuse_and_calc_cost(struct ioc_gq=
 *iocg, u64 vtime,
>   	} while (time_after64(vtime + cost, now->vnow) &&
>   		 iocg->inuse !=3D iocg->active);
>  =20
> -	spin_unlock_irq(&ioc->lock);
> +	spin_unlock_irqrestore(&ioc->lock, flags);
>  =20
>   	TRACE_IOCG_PATH(inuse_adjust, iocg, now,
>   			old_inuse, iocg->inuse, old_hwi, hwi);
>=20

