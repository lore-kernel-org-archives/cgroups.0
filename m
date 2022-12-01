From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Thu, 1 Dec 2022 09:19:54 +0800
Message-ID: <c028dd77-cabf-edd6-c893-8ee24762ac8c@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-10-linan122@huawei.com>
 <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Li Nan <linan122@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2022/12/01 4:59, Tejun Heo =D0=B4=B5=C0:
> On Wed, Nov 30, 2022 at 09:21:56PM +0800, Li Nan wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Our test report a problem:
>>
>> ------------[ cut here ]------------
>> list_del corruption. next->prev should be ffff888127e0c4b0, but was ffff=
888127e090b0
>> WARNING: CPU: 2 PID: 3117789 at lib/list_debug.c:62 __list_del_entry_val=
id+0x119/0x130
>> RIP: 0010:__list_del_entry_valid+0x119/0x130
>> RIP: 0010:__list_del_entry_valid+0x119/0x130
>> Call Trace:
>>   <IRQ>
>>   iocg_flush_stat.isra.0+0x11e/0x230
>>   ? ioc_rqos_done+0x230/0x230
>>   ? ioc_now+0x14f/0x180
>>   ioc_timer_fn+0x569/0x1640
>>
>> We haven't reporduced it yet, but we think this is due to parent iocg is
>> freed before child iocg, and then in ioc_timer_fn, walk_list is
>> corrupted.
>>
>> 1) Remove child cgroup can concurrent with remove parent cgroup, and
>> ioc_pd_free for parent iocg can be called before child iocg. This can be
>> fixed by moving the handle of walk_list to ioc_pd_offline, since that
>> offline from child is ensured to be called before parent.
>=20
> Which you already did in a previous patch, right?

yes, this is already did in patch 7.

>=20
>> 2) ioc_pd_free can be triggered from both removing device and removing
>> cgroup, this patch fix the problem by deleting timer before deactivating
>> policy, so that free parent iocg first in this case won't matter.
>=20
> Okay, so, yeah, css's pin parents but blkg's don't. I think the right thi=
ng
> to do here is making sure that a child blkg pins its parent (and eventual=
ly
> ioc).

Ok, I can try to do that.

>=20
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   block/blk-iocost.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
>> index 710cf63a1643..d2b873908f88 100644
>> --- a/block/blk-iocost.c
>> +++ b/block/blk-iocost.c
>> @@ -2813,13 +2813,14 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
>>   {
>>   	struct ioc *ioc =3D rqos_to_ioc(rqos);
>>  =20
>> +	del_timer_sync(&ioc->timer);
>> +
>>   	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iocost);
>>  =20
>>   	spin_lock_irq(&ioc->lock);
>>   	ioc->running =3D IOC_STOP;
>>   	spin_unlock_irq(&ioc->lock);
>>  =20
>> -	del_timer_sync(&ioc->timer);
>=20
> I don't about this workaround. Let's fix properly?

Ok, and by the way, is there any reason to delete timer after
deactivate policy? This seems a litter wreid to me.

Thanks,
Kuai
>=20

