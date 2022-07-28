From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH RESEND v6 2/8] blk-throttle: prevent overflow while
 calculating wait time
Date: Thu, 28 Jul 2022 18:23:41 +0800
Message-ID: <d09703dd-d733-4e93-4219-96353a3f6551@huaweicloud.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-3-yukuai1@huaweicloud.com>
 <YuGD1s2TJ9euYpCv@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YuGD1s2TJ9euYpCv-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

=D4=DA 2022/07/28 2:28, Tejun Heo =D0=B4=B5=C0:
> On Fri, Jul 01, 2022 at 05:34:35PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> In tg_with_in_bps_limit(), 'bps_limit * jiffy_elapsed_rnd' might
>> overflow. FIx the problem by calling mul_u64_u64_div_u64() instead.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> BTW, have you observed this happening or is it from just reviewing the co=
de?

It's just from code review.

Thanks.
>=20
> Thanks.
>=20

