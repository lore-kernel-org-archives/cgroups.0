From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 4/9] blk-throttle: fix io hung due to configuration
 updates
Date: Thu, 18 Aug 2022 09:16:28 +0800
Message-ID: <d82305ef-1672-a648-f0b6-882bef1659f1@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-5-yukuai1@huaweicloud.com>
 <Yvv3jcycOguuEbA3@slm.duckdns.org>
 <215b4842-c09f-d622-7127-c8b1d9ce3aa9@huaweicloud.com>
 <Yv0q7T5Eg6MzOIuU@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yv0q7T5Eg6MzOIuU-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org >> yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/08/18 1:52, Tejun Heo =D0=B4=B5=C0:
> On Wed, Aug 17, 2022 at 09:30:30AM +0800, Yu Kuai wrote:
>>> Would it be easier if the fields were signed? It's fragile and odd to
>>> explain "these are unsigned but if they underflow they behave just like
>>> signed when added" when they can just be signed. Also, I have a hard ti=
me
>>> understand what "preempt" means above.
>>
>> I think preempt shound never happen based on current FIFO
>> implementation, perhaps
>=20
> Can you elaborate what "preempt" is?

Here preempt means that the bio that is throttled later somehow get
dispatched earlier, Michal thinks it's better to comment that the code
still works fine in this particular scenario.

>=20
>>>> +	if (bps_limit !=3D U64_MAX)
>>>> +		tg->bytes_skipped[rw] +=3D
>>>> +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
>>>> +			tg->bytes_disp[rw];
>>>> +	if (iops_limit !=3D UINT_MAX)
>>>> +		tg->io_skipped[rw] +=3D
>>>> +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
>>>> +			tg->io_disp[rw];
>>>
>>> So, this is calculating the budgets to carry over. Can we name them
>>> accordingly? I don't know what "skipped" means.
>>
>> Yeah, thanks for you advice, art of naming is a little hard for me...
>> How do you think about these name: extended_bytes/io_budget?
>=20
> How about carryover_{ios|bytes}?

Yes, that sounds good.

By the way, should I use 'ios' here instead of 'io'? I was confused
because there are many places that is using 'io' currently.

Thanks,
Kuai
>=20
> Thanks.
>=20

