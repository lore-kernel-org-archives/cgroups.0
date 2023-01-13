From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Fri, 13 Jan 2023 09:10:25 +0800
Message-ID: <efa1c73b-e94f-373f-e535-2cfc32ce2433@huaweicloud.com>
References: <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
 <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
 <Y72wF/b0/xNRmP7f@slm.duckdns.org>
 <53b30ac8-d608-ba0b-8b1b-7fe5cfed6d61@huaweicloud.com>
 <Y77s0f741mFfGlTO@slm.duckdns.org>
 <4aeef320-c6c8-d9b4-8826-d58f00ea6264@huaweicloud.com>
 <Y8CrloCDGhbU42OH@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y8CrloCDGhbU42OH-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/13 8:53, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Thu, Jan 12, 2023 at 02:18:15PM +0800, Yu Kuai wrote:
>> remove the blkcg_deactivate_policy() from rq_qos_exit() from deleting
>> the device, and delay the policy cleanup and free to blkg_destroy_all().
>> Then the policies(other than bfq) can only call pd_free_fn() from
>> blkg_destroy(), and it's easy to guarantee the order. For bfq, it can
>> stay the same since bfq has refcounting itself.
>>
>> Then for the problem that ioc can be freed in pd_free_fn(), we can fix
>> it by freeing ioc in ioc_pd_free() for root blkg instead of
>> rq_qos_exit().
>>
>> What do you think?
>=20
> That would remove the ability to dynamically remove an rq_qos policy, rig=
ht?
> We don't currently do it but given that having an rq_qos registered comes
> with perf overhead, it's something we might want to do in the future - e.=
g.

Yes, that make sense, remove ioc and other policies dynamically.

> only activate the policy when the controller is actually enabled. So, idk.
> What's wrong with synchronizing the two removal paths? blkcg policies are
> combinations of cgroups and block device configurations, so having exit
> paths from both sides is kinda natural.

I still can't figure out how to synchronizing them will a mutex. Maybe
I'm being foolish...

Thanks,
Kuai

