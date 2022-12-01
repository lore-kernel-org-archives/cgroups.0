From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2 2/9] blk-iocost: improve hanlder of match_u64()
Date: Thu, 1 Dec 2022 10:15:53 +0800
Message-ID: <7e4f1cea-2691-9b81-35f6-0dd236149f56@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-3-linan122@huawei.com>
 <Y4e90zFnhhq764lP@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y4e90zFnhhq764lP-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2022/12/01 4:32, Tejun Heo =D0=B4=B5=C0:
> On Wed, Nov 30, 2022 at 09:21:49PM +0800, Li Nan wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> 1) There are one place that return value of match_u64() is not checked.
>> 2) If match_u64() failed, return value is set to -EINVAL despite that
>>     there are other possible errnos.
>=20
> Ditto. Does this matter?
>=20

It's not a big deal, but I think at least return value of match_u64()
should be checked, we don't want to continue with invalid input, right?

By the way, match_u64() can return -ERANGE, which can provide more
specific error messge to user.

Thanks,
Kuai

