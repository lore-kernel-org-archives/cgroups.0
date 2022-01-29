From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v2 0/3] block, bfq: minor cleanup and fix
Date: Sat, 29 Jan 2022 09:42:43 +0800
Message-ID: <8f0d2f92-96c5-f2c4-daa4-f2a59bd885a2@huawei.com>
References: <20211231032354.793092-1-yukuai3@huawei.com>
 <164338111974.263985.3933987922467783334.b4-ty@kernel.dk>
 <2579c500-549f-ff04-d1e1-6cf3db10b428@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2579c500-549f-ff04-d1e1-6cf3db10b428@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>, paolo.valente@linaro.org, jack@suse.cz, tj@kernel.org
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, yi.zhang@huawei.com, linux-kernel@vger.kernel.org

在 2022/01/29 3:27, Jens Axboe 写道:
> On 1/28/22 7:45 AM, Jens Axboe wrote:
>> On Fri, 31 Dec 2021 11:23:51 +0800, Yu Kuai wrote:
>>> Chagnes in v2:
>>>   - add comment in patch 2
>>>   - remove patch 4, since the problem do not exist.
>>>
>>> Yu Kuai (3):
>>>    block, bfq: cleanup bfq_bfqq_to_bfqg()
>>>    block, bfq: avoid moving bfqq to it's parent bfqg
>>>    block, bfq: don't move oom_bfqq
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/3] block, bfq: cleanup bfq_bfqq_to_bfqg()
>>        commit: a9c77f6ec0b566439182a10b64dd3e60a0408849
>> [2/3] block, bfq: avoid moving bfqq to it's parent bfqg
>>        commit: 36ad7fe0ec7485ee435f7a40452c7a58598779d4
>> [3/3] block, bfq: don't move oom_bfqq
>>        commit: a0b98e6fba18a40aa9672cc3e0abf980456f3ae6
> 
> For all those pings, this patchset sure didn't see a lot of compiles:
> 
> block/bfq-cgroup.c: In function ‘bfq_bfqq_move’:
> block/bfq-cgroup.c:648:40: error: implicit declaration of function ‘bfq_group’; did you mean ‘bfqq_group’? [-Werror=implicit-function-declaration]
>    648 |         struct bfq_group *old_parent = bfq_group(bfqq);
>        |                                        ^~~~~~~~~
>        |                                        bfqq_group
> block/bfq-cgroup.c:648:40: error: initialization of ‘struct bfq_group *’ from ‘int’ makes pointer from integer without a cast [-Werror=int-conversion]
> cc1: all warnings being treated as errors
> make[1]: *** [scripts/Makefile.build:288: block/bfq-cgroup.o] Error 1
> make: *** [Makefile:1831: block] Error 2
> 
> Dropped.
> 

Hi,

I'm sincerely sorry for this, I do forget to compiles this patchset,
and let this stupid clerical error exposure to you...

I'll send anothor version of patch 2.

Thanks,
Kuai
