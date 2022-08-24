From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v8 1/4] blk-throttle: fix that io throttle can only work
 for single bio
Date: Wed, 24 Aug 2022 09:15:32 +0800
Message-ID: <73c72914-e27d-b261-e040-2dd31e8a6b9f@huaweicloud.com>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
 <20220823033130.874230-2-yukuai1@huaweicloud.com>
 <YwUXTL+8E/sPcEUB@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YwUXTL+8E/sPcEUB-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun

=D4=DA 2022/08/24 2:07, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> Should have asked you earlier but with the BIO_THROTTLED flag setting from
> clone removed, with single BIO_THROTTLED flag, does the fix still require
> bytes subtraction? If we can do single flag and we don't need the bytes
> subtraction, might as well just stay with single flag?

Do you mean 'compensate the over-accounting' for bytes subtraction? If
so, yes, it's not required.

This patch actually set two flags when bio is throttled and
dispatched, and only iops flag is cleared after the original bio is
split. If only one flag can be used, the way that I come up with is
that let iops limit become default, which means bio is always counted
for iops limit each time blk_throtl_bio() is called. I'm not quite
sure yet if iops limit can be counted excessively this way in some
special scenario...

Thanks,
Kuai
>=20
> Thanks.
>=20

