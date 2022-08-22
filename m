From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 1/9] blk-throttle: fix that io throttle can only work
 for single bio
Date: Mon, 22 Aug 2022 11:06:44 +0800
Message-ID: <b1791e41-4945-a0d8-8067-3841ce10fddd@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-2-yukuai1@huaweicloud.com>
 <Yvvx+/d2+OMROUOe@slm.duckdns.org>
 <712e0f29-94ba-d3d3-ce21-cba4d6092008@huaweicloud.com>
 <Yv0qbDR+cxKeZ3nD@slm.duckdns.org>
 <83c8b253-2ebb-5af6-8ce1-6dc3b84cf182@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <83c8b253-2ebb-5af6-8ce1-6dc3b84cf182-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

在 2022/08/18 9:23, Yu Kuai 写道:
> Hi, Tejun!
> 
> 在 2022/08/18 1:50, Tejun Heo 写道:
>> Hello,
>>
>> On Wed, Aug 17, 2022 at 09:13:38AM +0800, Yu Kuai wrote:
>>>> So, as a fix for the immediate problem, I guess this might do but 
>>>> this feels
>>>> really fragile. How can we be certain that re-entering only happens 
>>>> because
>>>> of splitting? What if future core development changes that? It seems 
>>>> to be
>>>> solving the problem in the wrong place. Shouldn't we flag the bio 
>>>> indicating
>>>> that it's split when we're splitting the bio so that we only limit 
>>>> them for
>>>> iops in the first place?
>>>
>>> Splited bio is tracked in __bio_clone:
>>
>> As the word is used in commit messages and comments, the past perfect 
>> form
>> of the verb "split" is "split". It looks like "splitted" is used in rare
>> cases but dictionary says it's an archaic form.
> 
> Ok, thanks for pointing it out, I'll change that in next iteration.
>>
>>> if (bio_flagged(bio_src, BIO_THROTTLED))
>>>     bio_set_flag(bio, BIO_THROTTLED);

While implementing the new method, I found that there seems to be a
misunderstanding here, the code seems to try to add flag to split bio
so that it won't be throttled again for bps limit, however:

1) for blk throttle, split bio is issued directly and will never be
throttled again, while orignal bio will go through throttle path again.
2) if cloned bio is directed to a new disk, the flag is cleared anyway.
>>>
>>> And currenty, the iops limit and bps limit are treated differently,
>>> however there are only one flag 'BIO_THROTTLED' and they can't be
>>> distinguished.
>>>
>>> Perhaps I can use two flags, for example BIO_IOPS_THROTTLED and
>>> BIO_BPS_THROTTLED, this way only iops limit can be handled and bps
>>> limit can be skipped for splited bio.
>>>
>>> What do you think?
>>
>> I think the code would be a lot more intuitive and less fragile if we 
>> used
>> two flags but the bits in the bi_flags field are a scarce resource
>> unfortunately. Even then, I think the right thing to do here is using two
>> flags.
> 
> Yes, the field 'bio->bi_flags' is unsigned short, and there are only two
> bits left. I'll use the new sulution which will acquire a new bit.
> 
> Thanks,
> Kuai
>>
>> Thanks.
>>
> 
> .
> 

