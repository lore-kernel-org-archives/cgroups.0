From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Mon, 30 Jan 2023 09:06:41 +0800
Message-ID: <e0379fe4-68b4-5590-e9c4-dd0d85a635b6@huaweicloud.com>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
 <4d3f6183-f9d4-b657-0205-fc240bc24c76@huaweicloud.com>
 <7ae20fa2-d9b4-9e21-4209-81bf4845a3c5@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7ae20fa2-d9b4-9e21-4209-81bf4845a3c5-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

在 2023/01/30 5:51, Jens Axboe 写道:
> On 1/28/23 6:38 PM, Yu Kuai wrote:
>> Hi, Jens
>>
>> 在 2023/01/13 17:44, Yu Kuai 写道:
>>> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
>>> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
>>> bic->bfqq will be freed first, and bic_set_bfqq() is called with the freed
>>> bic->bfqq.
>>>
>>> Fix the problem by always freeing bfqq after bic_set_bfqq().
>>>
>>
>> Sorry that I send this patch will wrong email, and you might missed this
>> patch.
>>
>> Can you apply this patch? This patch can't be applied directly to lower
>> version due to Paolo's patchset, I'll send lts patch seperately.
> 
> I'm confused... So this patch only applies to the 6.3 branch, yet we
> need it in 6.2 as far as I can tell. Why isn't it against block-6.2
> then?
> 

Ok, I'll send a new patch against block-6.2.

Thanks,
Kuai

