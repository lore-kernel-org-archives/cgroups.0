From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2 9/9] blk-iocost: fix walk_list corruption
Date: Mon, 5 Dec 2022 17:35:07 +0800
Message-ID: <2f9495ff-130a-ce1d-5887-0448bdbceedd@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-10-linan122@huawei.com>
 <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4fEKZy4rTE5rG/5@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun

=D4=DA 2022/12/01 4:59, Tejun Heo =D0=B4=B5=C0:
> On Wed, Nov 30, 2022 at 09:21:56PM +0800, Li Nan wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

Sorry about this, actually it's can be ensured that pd_offline
from child will be called before parent. Hence just moving he handle of
walk_list to ioc_pd_offline can fix this problem thoroughly.

Thanks,
Kuai

