From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 2/4] blk-iocost: don't throttle bio if iocg is
 offlined
Date: Tue, 20 Dec 2022 17:38:05 +0800
Message-ID: <beb75b37-6088-5f23-6602-5aff22213e41@huaweicloud.com>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
 <20221217030527.1250083-3-yukuai1@huaweicloud.com>
 <Y6DXkLeOmu7VWovz@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y6DXkLeOmu7VWovz-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2022/12/20 5:28, Tejun Heo =D0=B4=B5=C0:
> On Sat, Dec 17, 2022 at 11:05:25AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> bio will grab blkg reference, however, blkcg->online_pin is not grabbed,
>> hence cgroup can be removed after thread exit while bio is still in
>> progress. Bypass io in this case since it doesn't make sense to
>> throttle bio while cgroup is removed.
>=20
> I don't get it. Why wouldn't that make sense? ISTR some occasions where we
> clear the config to mitigate exits stalling for too long but in general a
> policy being active on a draining cgroup shouldn't be a problem.

The main reason here for patch 2/3 is for patch 4, since bio can still
reach rq_qos after pd_offline_fn is called.

Currently, it's not consistent and seems messy how different policies
implement pd_alloc/free_fn, pd_online/offline_fn, and pd_init_fn. For
iocost, iocg is exited in pd_free_fn, and parent iocg can exits before
child, which will cause many problems.

Patch 2/3 are not necessary if we don't choose to fix such problems by
exiting iocg in ioc_pd_offline() in patch 4.

I'll try to think about how to use refcnting, either from blkg layer or
add refcnting for iocg.

Thanks,
Kuai
>=20
> Thanks.
>=20

