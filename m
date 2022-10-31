From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 4/5] blk-iocost: fix sleeping in atomic context
 warnning in ioc_qos_write()
Date: Mon, 31 Oct 2022 09:33:07 +0800
Message-ID: <aa7cb8f2-0398-aff9-f572-fcb48271d20f@huaweicloud.com>
References: <20221028101056.1971715-1-yukuai1@huaweicloud.com>
 <20221028101056.1971715-5-yukuai1@huaweicloud.com>
 <Y15KC8Zb3rHlfTPu@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y15KC8Zb3rHlfTPu-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2022/10/30 17:55, Christoph Hellwig =D0=B4=B5=C0:
> This seems a little convoluted to me.  I'd suggest to add a new
> sleeping lock that protects the updates, then you just take the
> spinlock after parsing without much other changes.
>=20
> (The same comment also applies to patch 5).

Yes, add a new sleeping lock is ok, and changes will be much simpler.

Thanks for the suggestion, I'll send a new verion soon.

Kuai
> .
>=20

