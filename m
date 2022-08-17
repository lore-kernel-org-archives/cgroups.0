From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 9/9] blk-throttle: clean up flag 'THROTL_TG_PENDING'
Date: Wed, 17 Aug 2022 09:45:13 +0800
Message-ID: <65d93ec6-2465-35f1-314f-f092ce631100@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-10-yukuai1@huaweicloud.com>
 <Yvv6kk/RD5LT+3dk@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yvv6kk/RD5LT+3dk-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/08/17 4:14, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 02, 2022 at 10:04:15PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> All related operations are inside 'queue_lock', there is no need to use
>> the flag, we only need to make sure throtl_enqueue_tg() is called when
>> the first bio is throttled, and throtl_dequeue_tg() is called when the
>> last throttled bio is dispatched. There are no functional changes in
>> this patch.
>=20
> I don't know whether this is better or not. It's minutely less lines of c=
ode
> but also makes the code a bit more fragile. I'm ambivalent. At any rate,
> please move these trivial patches to the head of the series or post them
> separately.

Can I ask why do you think this patch makes the code a bit more fragile?

By the way, I'll post these trivial patches separately.

Thanks,
Kuai
>=20
> Thanks.
>=20

