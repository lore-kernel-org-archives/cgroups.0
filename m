From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Tue, 10 Jan 2023 09:39:44 +0800
Message-ID: <a71f997f-6cae-d57b-85dd-2fd499d238f6@huaweicloud.com>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
 <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
 <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
 <Y7cX0SJ0y6+EIY5Q@slm.duckdns.org>
 <7dcdaef3-65c1-8175-fea7-53076f39697f@huaweicloud.com>
 <Y7iCId3pnEnLqY8G@slm.duckdns.org>
 <875eb43e-202d-5b81-0bff-ef0434358d99@huaweicloud.com>
 <Y7xbpidpq7+DqJan@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y7xbpidpq7+DqJan-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/10 2:23, Tejun Heo =D0=B4=B5=C0:
> Yeah, that's unfortunate. There are several options here:
>=20
> 1. Do what you originally suggested - bypass to root after offline. I feel
>     uneasy about this. Both iolatency and throtl clear their configs on
>     offline but that's punting to the parent. For iocost it'd be bypassing
>     all controls, which can actually be exploited.
>=20
> 2. Make all possible IO issuers use blkcg_[un]pin_online() and shift the
>     iocost shutdown to pd_offline_fn(). This likely is the most canonical
>     solution given the current situation but it's kinda nasty to add anot=
her
>     layer of refcnting all over the place.
>=20
> 3. Order blkg free so that parents are never freed before children. You d=
id
>     this by adding refcnts in iocost but shouldn't it be possible to simp=
ly
>     shift blkg_put(blkg->parent) in __blkg_release() to blkg_free_workfn(=
)?

As I tried to explain before, we can make sure blkg_free() is called
in order, but blkg_free() from remove cgroup can concurrent with
deactivate policy, and we can't guarantee the order of ioc_pd_free()
that is called both from blkg_free() and blkcg_deactivate_policy().
Hence I don't think #3 is possible.

I personaly prefer #1, I don't see any real use case about the defect
that you described, and actually in cgroup v1 blk-throtl is bypassed to
no limit as well.

I'm not sure about #2, that sounds a possible solution but I'm not quite
familiar with the implementations here.

Consider that bfq already has such refcounting for bfqg, perhaps
similiar refcounting is acceptable?

Thanks,
Kuai

