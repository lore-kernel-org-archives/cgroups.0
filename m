From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 3/9] blk-throttle: factor out code to calculate
 ios/bytes_allowed
Date: Wed, 17 Aug 2022 09:32:16 +0800
Message-ID: <886ebc8f-5b7e-e281-c985-030bc687bb7f@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-4-yukuai1@huaweicloud.com>
 <Yvv0P5YXf2HdEC1d@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yvv0P5YXf2HdEC1d-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/08/17 3:47, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 02, 2022 at 10:04:09PM +0800, Yu Kuai wrote:
>> +static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bi=
o,
>> +				  u32 iops_limit, unsigned long *wait)
>=20
> While at it, can you please rename these functions to tg_within_iops_limi=
t?
> "within" is a single word. Other than that,

Of course, I'll do that in next version.
>=20
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Thanks.
>=20

