From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v2 2/9] blk-iocost: improve hanlder of match_u64()
Date: Thu, 1 Dec 2022 21:47:35 +0800
Message-ID: <46bd7f33-6f24-a7a0-6359-3dc9aad98e6f@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-3-linan122@huawei.com>
 <Y4e90zFnhhq764lP@slm.duckdns.org>
 <7e4f1cea-2691-9b81-35f6-0dd236149f56@huaweicloud.com>
 <Y4h9MEd3q4LXDGQq@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y4h9MEd3q4LXDGQq@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Li Nan <linan122@huawei.com>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2022/12/01 18:08, Tejun Heo 写道:
> On Thu, Dec 01, 2022 at 10:15:53AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2022/12/01 4:32, Tejun Heo 写道:
>>> On Wed, Nov 30, 2022 at 09:21:49PM +0800, Li Nan wrote:
>>>> From: Yu Kuai <yukuai3@huawei.com>
>>>>
>>>> 1) There are one place that return value of match_u64() is not checked.
>>>> 2) If match_u64() failed, return value is set to -EINVAL despite that
>>>>      there are other possible errnos.
>>>
>>> Ditto. Does this matter?
>>>
>>
>> It's not a big deal, but I think at least return value of match_u64()
>> should be checked, we don't want to continue with invalid input, right?
> 
> Yeah, sure.
> 
>> By the way, match_u64() can return -ERANGE, which can provide more
>> specific error messge to user.
> 
> I'm really not convinced going over 64bit range would be all that difficult
> to spot whether the error code is -EINVAL or -ERANGE. There isn't anything
> wrong with returning -ERANGE but the fact that that particular function
> returns an error code doesn't necessarily mean that it *must* be forwarded.
> 
> Imagine that we used sscanf(buf, "%llu", &value) to parse the number
> instead. We'd only know whether the parsing would have succeeded or not and
> would probably return -EINVAL on failure and the behavior would be just
> fine. This does not matter *at all*.
> 
> So, idk, I'm not necessarily against it but changing -EINVAL to -ERANGE is
> pure churn. Nothing material is being improved by that change.

Thanks for the review and explanation, I'll just keep the addition of
return value  checking of the former 2 patches.

Thanks,
Kuai

