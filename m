From: Yu Kuai <yukuai3@huawei.com>
Subject: Re: [PATCH -next v5 4/8] blk-throttle: fix io hung due to config
 updates
Date: Sun, 26 Jun 2022 10:39:45 +0800
Message-ID: <65dac189-92f5-f2bc-b322-cbda10f897b4@huawei.com>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-5-yukuai3@huawei.com>
 <20220622172621.GA28246@blackbody.suse.cz>
 <f5165488-2461-8946-593f-14154e404850@huawei.com>
 <20220623162620.GB16004@blackbody.suse.cz>
 <75b3cdcc-1aa3-7259-4900-f09a2a081716@huawei.com>
 <7e14a11b-225e-13c4-35ff-762eafd20b70@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7e14a11b-225e-13c4-35ff-762eafd20b70@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, tj@kernel.org
Cc: ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2022/06/26 0:41, Jens Axboe 写道:
> On 6/25/22 2:36 AM, Yu Kuai wrote:
>> ? 2022/06/24 0:26, Michal Koutn? ??:
>>> On Thu, Jun 23, 2022 at 08:27:11PM +0800, Yu Kuai <yukuai3@huawei.com> wrote:
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

My apologize for that, I'm quite annoied that our IT still can't solve
this. I'll stop sending new emails with this address for now..

Thanks,
Kuai
