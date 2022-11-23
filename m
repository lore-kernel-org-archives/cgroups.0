From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Wed, 23 Nov 2022 18:22:29 +0800
Message-ID: <ec3754a6-3249-51ab-b659-fd795884e346@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
 <3da991c6-21e4-8ed8-ba75-ccb92059f0ae@huaweicloud.com>
 <Y306xJV6aNXd94kb@slm.duckdns.org>
 <1f52ccb1-c357-a2a0-ef9d-48d7e2eb51f8@kernel.dk>
 <Y31sYFdA2lHIvjt3@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y31sYFdA2lHIvjt3-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun

=D4=DA 2022/11/23 8:42, Tejun Heo =D0=B4=B5=C0:
> On Tue, Nov 22, 2022 at 05:14:29PM -0700, Jens Axboe wrote:
>>>> Then match_strdup() and kfree() in match_NUMBER() can be replaced with
>>>> get_buffer() and put_buffer().
>>>
>>> Sorry about the late reply. Yeah, something like this.

Thanks for the feedback. I'll remove patch 4 from this seies and send a
new patch separately soon.

Thanks,
Kuai
>>
>> Doesn't local_irq_disable() imply preemption disable as well?
>=20
> Right, I was thinking about spin_lock_irq() which doesn't imply disabling
> preemption in PREEMPT_RT. local_irq_disable() is actual irq disable even =
on
> RT. It should be fine on its own.
>=20
> Thanks.
>=20

