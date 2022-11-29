From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 7/8] blk-iocost: fix possible UAF in ioc_pd_free
Date: Tue, 29 Nov 2022 20:18:54 +0800
Message-ID: <265d253a-15c2-ead4-da94-8915454bcca4@huaweicloud.com>
References: <20221128154434.4177442-1-linan122@huawei.com>
 <20221128154434.4177442-8-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221128154434.4177442-8-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>



=D4=DA 2022/11/28 23:44, Li Nan =D0=B4=B5=C0:
> Our test found the following problem in kernel 5.10, and the same problem
> should exist in mainline:
>=20
>    BUG: KASAN: use-after-free in _raw_spin_lock_irqsave+0x71/0xe0
>    Write of size 4 at addr ffff8881432000e0 by task swapper/4/0
>    ...
>    Call Trace:
>     <IRQ>
>     dump_stack+0x9c/0xd3
>     print_address_description.constprop.0+0x19/0x170
>     __kasan_report.cold+0x6c/0x84
>     kasan_report+0x3a/0x50
>     check_memory_region+0xfd/0x1f0
>     _raw_spin_lock_irqsave+0x71/0xe0
>     ioc_pd_free+0x9d/0x250
>     blkg_free.part.0+0x80/0x100
>     __blkg_release+0xf3/0x1c0
>     rcu_do_batch+0x292/0x700
>     rcu_core+0x270/0x2d0
>     __do_softirq+0xfd/0x402
>      </IRQ>
>     asm_call_irq_on_stack+0x12/0x20
>     do_softirq_own_stack+0x37/0x50
>     irq_exit_rcu+0x134/0x1a0
>     sysvec_apic_timer_interrupt+0x36/0x80
>     asm_sysvec_apic_timer_interrupt+0x12/0x20
>=20
>     Freed by task 57:
>     kfree+0xba/0x680
>     rq_qos_exit+0x5a/0x80
>     blk_cleanup_queue+0xce/0x1a0
>     virtblk_remove+0x77/0x130 [virtio_blk]
>     virtio_dev_remove+0x56/0xe0
>     __device_release_driver+0x2ba/0x450
>     device_release_driver+0x29/0x40
>     bus_remove_device+0x1d8/0x2c0
>     device_del+0x333/0x7e0
>     device_unregister+0x27/0x90
>     unregister_virtio_device+0x22/0x40
>     virtio_pci_remove+0x53/0xb0
>     pci_device_remove+0x7a/0x130
>     __device_release_driver+0x2ba/0x450
>     device_release_driver+0x29/0x40
>     pci_stop_bus_device+0xcf/0x100
>     pci_stop_and_remove_bus_device+0x16/0x20
>     disable_slot+0xa1/0x110
>     acpiphp_disable_and_eject_slot+0x35/0xe0
>     hotplug_event+0x1b8/0x3c0
>     acpiphp_hotplug_notify+0x37/0x70
>     acpi_device_hotplug+0xee/0x320
>     acpi_hotplug_work_fn+0x69/0x80
>     process_one_work+0x3c5/0x730
>     worker_thread+0x93/0x650
>     kthread+0x1ba/0x210
>     ret_from_fork+0x22/0x30
>=20
> It happened as follow:
>=20
> 	T1		    T2			T3
>    //rmdir cgroup
>    blkcg_destroy_blkgs
>     blkg_destroy
>      percpu_ref_kill
>       blkg_release
>        call_rcu
> 			//delete device
> 			del_gendisk

del_gendisk will synchronize_rcu, hence this is wrong.

call_rcu from blkcg_destroy_blkgs should be called after
synchronize_rcu.

Thanks,
Kuai
> 			 rq_qos_exit
> 			  ioc_rqos_exit
> 			   kfree(ioc)
> 					   __blkg_release
> 					    blkg_free
> 					     blkg_free_workfn
> 					      pd_free_fn
> 					       ioc_pd_free
> 						spin_lock_irqsave
> 						 ->ioc is freed
>=20
> Fix the problem by moving the operation on ioc in ioc_pd_free() to
> ioc_pd_offline(), and just free resource in ioc_pd_free() like iolatency
> and throttle.
>=20
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   block/blk-iocost.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index 03977385449f..1b855babfc35 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -2978,7 +2978,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
>   	spin_unlock_irqrestore(&ioc->lock, flags);
>   }
>  =20
> -static void ioc_pd_free(struct blkg_policy_data *pd)
> +static void ioc_pd_offline(struct blkg_policy_data *pd)
>   {
>   	struct ioc_gq *iocg =3D pd_to_iocg(pd);
>   	struct ioc *ioc =3D iocg->ioc;
> @@ -3002,6 +3002,12 @@ static void ioc_pd_free(struct blkg_policy_data *p=
d)
>  =20
>   		hrtimer_cancel(&iocg->waitq_timer);
>   	}
> +}
> +
> +static void ioc_pd_free(struct blkg_policy_data *pd)
> +{
> +	struct ioc_gq *iocg =3D pd_to_iocg(pd);
> +
>   	free_percpu(iocg->pcpu_stat);
>   	kfree(iocg);
>   }
> @@ -3488,6 +3494,7 @@ static struct blkcg_policy blkcg_policy_iocost =3D {
>   	.cpd_free_fn	=3D ioc_cpd_free,
>   	.pd_alloc_fn	=3D ioc_pd_alloc,
>   	.pd_init_fn	=3D ioc_pd_init,
> +	.pd_offline_fn	=3D ioc_pd_offline,
>   	.pd_free_fn	=3D ioc_pd_free,
>   	.pd_stat_fn	=3D ioc_pd_stat,
>   };
>=20

