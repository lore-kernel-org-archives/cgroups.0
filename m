From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v3 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Fri, 20 May 2022 09:36:11 +0800
Message-ID: <fe3c03f7-9b52-7948-075d-cbdf431363e1@huawei.com>
References: <20220519085811.879097-1-yukuai3@huawei.com>
 <20220519085811.879097-3-yukuai3@huawei.com>
 <20220519095857.GE16096@blackbody.suse.cz>
 <a8953189-af42-0225-3031-daf61347524a@huawei.com>
 <20220519161026.GG16096@blackbody.suse.cz>
 <73464ca6-9412-cc55-d9c0-f2e8a10f0607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <73464ca6-9412-cc55-d9c0-f2e8a10f0607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/05/20 9:22, yukuai (C) 写道:
> 在 2022/05/20 0:10, Michal Koutný 写道:
>> On Thu, May 19, 2022 at 08:14:28PM +0800, "yukuai (C)" 
>> <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>> tg_with_in_bps_limit:
>>>   jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
>>>   tmp = bps_limit * jiffy_elapsed_rnd;
>>>   do_div(tmp, HZ);
>>>   bytes_allowed = tmp; -> how many bytes are allowed in this slice,
>>>                  incluing dispatched.
>>>   if (tg->bytes_disp[rw] + bio_size <= bytes_allowed)
>>>    *wait = 0 -> no need to wait if this bio is within limit
>>>
>>>   extra_bytes = tg->bytes_disp[rw] + bio_size - bytes_allowed;
>>>   -> extra_bytes is based on 'bytes_disp'
>>>
>>> For example:
>>>
>>> 1) bps_limit is 2k, we issue two io, (1k and 9k)
>>> 2) the first io(1k) will be dispatched, bytes_disp = 1k, slice_start = 0
>>>     the second io(9k) is waiting for (9 - (2 - 1)) / 2 = 4 s
>>
>> The 2nd io arrived at 1s, the wait time is 4s, i.e. it can be dispatched
>> at 5s (i.e. 10k/*2kB/s = 5s).
> No, the example is that the second io arrived together with first io.
>>
>>> 3) after 3 s, we update bps_limit to 1k, then new waiting is caculated:
>>>
>>> without this patch:  bytes_disp = 0, slict_start =3:
>>> bytes_allowed = 1k                                <--- why 1k and not 0?
> Because slice_start == jiffies, bytes_allowed is equal to bps_limit
>>> extra_bytes = 9k - 1k = 8k
>>> wait = 8s
>>
>> This looks like it was calculated at time 4s (1s after new config was
>> set).
> No... it was caculated at time 3s:
> 
> jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
> 
> jiffies should be greater than 3s here, thus jiffy_elapsed_rnd is
> 3s + throtl_slice (I'm using throtl_slice = 1s here, it should not
> affect result)
Hi,

Just to simplify explanation (assum that throtl_slice is greater than
0.5s):
Without this patch:
wait time is caculated based on issuing 9k from now(3s) without any
bytes aready dispatched.

With this patch:
wait time is caculated based on issuing 9k from 0s with 0.5 bytes
aready dispatched.
>>
>>>
>>> whth this patch: bytes_disp = 0.5k, slice_start =  0,
>>> bytes_allowed = 1k * 3 + 1k = 4k
>>> extra_bytes =  0.5k + 9k - 4k = 5.5k
>>> wait = 5.5s
>>
>> This looks like calculated at 4s, so the IO would be waiting till
>> 4s+5.5s = 9.5s.
> wait time is based on extra_bytes, this is really 5.5s, add 4s is
> wrong here.
> 
> bytes_allowed = ((jiffies - slice_start) / Hz + 1) * bps_limit
> extra_bytes = bio_size + bytes_disp - bytes_allowed
> wait = extra_bytes / bps_limit
>>
>> As I don't know why using time 4s, I'll shift this calculation to the
>> time 3s (when the config changes):
>>
>> bytes_disp = 0.5k, slice_start =  0,
>> bytes_allowed = 1k * 3  = 3k
>> extra_bytes =  0.5k + 9k - 3k = 7.5k
> 6.5k
>> wait = 7.5s
>>
>> In absolute time, the IO would wait till 3s+7.5s = 10.5s
> Like I said above, wait time should not add (jiffies - slice_start)
>>
>> OK, either your 9.5s or my 10.5s looks weird (although earlier than
>> original 4s+8s=12s).
>> However, the IO should ideally only wait till
>>
>>      3s + (9k -   (6k    -    1k)     ) / 1k/s =
>>           bio - (allowed - dispatched)  / new_limit
>>
>>     =3s + 4k / 1k/s = 7s
>>
>>     ('allowed' is based on old limit)
>>
>> Or in another example, what if you change the config from 2k/s to ∞k/s
>> (unlimited, let's neglect the arithmetic overflow that you handle
>> explicitly, imagine a big number but not so big to be greater than
>> division result).
>>
>> In such a case, the wait time should be zero, i.e. IO should be
>> dispatched right at the time of config change.
> 
> I thought about it, however, IMO, this is not a good idea. If user
> updated config quite frequently, io throttle will be invalid.
> 
> Thanks,
> Kuai
>> (With your patch that still calculates >0 wait time (and the original
>> behavior gives >0 wait too.)
>>
>>> I hope I can expliain it clearly...
>>
>> Yes, thanks for pointing me to relevant parts.
>> I hope I grasped them correctly.
>>
>> IOW, your patch and formula make the wait time shorter but still IO can
>> be delayed indefinitely if you pass a sequence of new configs. (AFAIU)
>>
>> Regards,
>> Michal
>> .
>>
