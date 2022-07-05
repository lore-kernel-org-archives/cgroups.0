From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v5 4/8] blk-throttle: fix io hung due to config
 updates
Date: Tue, 5 Jul 2022 19:42:44 +0800
Message-ID: <2b3d9f87-a5e2-75e0-b6bc-b8588ffec8cd@huaweicloud.com>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-5-yukuai3@huawei.com>
 <20220622172621.GA28246@blackbody.suse.cz>
 <f5165488-2461-8946-593f-14154e404850@huawei.com>
 <20220623162620.GB16004@blackbody.suse.cz>
 <75b3cdcc-1aa3-7259-4900-f09a2a081716@huawei.com>
 <7e14a11b-225e-13c4-35ff-762eafd20b70@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7e14a11b-225e-13c4-35ff-762eafd20b70-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

在 2022/06/26 0:41, Jens Axboe 写道:
> On 6/25/22 2:36 AM, Yu Kuai wrote:
>> ? 2022/06/24 0:26, Michal Koutn? ??:
>>> On Thu, Jun 23, 2022 at 08:27:11PM +0800, Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>>>> Here we may allow to dispatch a bio above current slice's
>>>>> calculate_bytes_allowed() if bytes_skipped is already >0.
>>>>
>>>> Hi, I don't expect that to happen. For example, if a bio is still
>>>> throttled, then old slice is keeped with proper 'bytes_skipped',
>>>> then new wait time is caculated based on (bio_size - bytes_skipped).
>>>>
>>>> After the bio is dispatched(I assum that other bios can't preempt),
>>>
>>> With this assumptions it adds up as you write. I believe we're in
>>> agreement.
>>>
>>> It's the same assumption I made below (FIFO everywhere, i.e. no
>>> reordering). So the discussed difference shouldn't really be negative
>>> (and if the assumption didn't hold, so the modular arithmetic yields
>>> corerct bytes_skipped value).
>> Yes, nice that we're in aggreement.
>>
>> I'll wait to see if Tejun has any suggestions.
> 
> I flushed more emails from spam again. Please stop using the buggy
> huawei address until this gets resolved, your patches are getting lost
> left and right and I don't have time to go hunting for emails.
> 

Hi, Jens

Can you please take a look if this patchset is ok?

https://lore.kernel.org/all/20220701093441.885741-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org/

This is sent by huaweicloud.com（DMARC record is empty).

Thanks,
Kuai

