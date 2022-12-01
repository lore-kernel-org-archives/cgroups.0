From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Thu, 1 Dec 2022 18:14:32 +0800
Message-ID: <de04965e-1341-3053-0f4b-395b8390d00c@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-10-linan122@huawei.com>
 <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
 <c028dd77-cabf-edd6-c893-8ee24762ac8c@huaweicloud.com>
 <Y4h7RxdT83g+zFN0@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4h7RxdT83g+zFN0-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2022/12/01 18:00, Tejun Heo =D0=B4=B5=C0:
> On Thu, Dec 01, 2022 at 09:19:54AM +0800, Yu Kuai wrote:
>>>> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
>>>> index 710cf63a1643..d2b873908f88 100644
>>>> --- a/block/blk-iocost.c
>>>> +++ b/block/blk-iocost.c
>>>> @@ -2813,13 +2813,14 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
>>>>    {
>>>>    	struct ioc *ioc =3D rqos_to_ioc(rqos);
>>>> +	del_timer_sync(&ioc->timer);
>>>> +
>>>>    	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
>>>>    	spin_lock_irq(&ioc->lock);
>>>>    	ioc->running =3D IOC_STOP;
>>>>    	spin_unlock_irq(&ioc->lock);
>>>> -	del_timer_sync(&ioc->timer);
>>>
>>> I don't about this workaround. Let's fix properly?
>>
>> Ok, and by the way, is there any reason to delete timer after
>> deactivate policy? This seems a litter wreid to me.
>=20
> ioc->running is what controls whether the timer gets rescheduled or not. =
If
> we don't shut that down, the timer may as well get rescheduled after being
> deleted. Here, the only extra activation point is IO issue which shouldn't
> trigger during rq_qos_exit, so the ordering shouldn't matter but this is =
the
> right order for anything which can get restarted.

Thanks for the explanation.

I'm trying to figure out how to make sure child blkg pins it's parent,
btw, do you think following cleanup make sense?

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index a645184aba4a..6ad8791af9d7 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2810,13 +2810,13 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
  {
         struct ioc *ioc =3D rqos_to_ioc(rqos);

-       blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
-
         spin_lock_irq(&ioc->lock);
         ioc->running =3D IOC_STOP;
         spin_unlock_irq(&ioc->lock);

         del_timer_sync(&ioc->timer);
+       blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
+
         free_percpu(ioc->pcpu_stat);
         kfree(ioc);
  }

Thanks,
Kuai

