From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Tue, 21 Feb 2023 21:36:53 +0800
Message-ID: <cb420c07-8143-2ff7-f6eb-57f9d9fda5aa@huaweicloud.com>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
 <ca9fefd4-7109-042c-3b25-9eb795141145@huaweicloud.com>
 <3e8c8567-f41d-66ae-0633-dcdbed007228@applied-asynchrony.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <3e8c8567-f41d-66ae-0633-dcdbed007228@applied-asynchrony.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>, Yu Kuai <yukuai1@huaweicloud.com>, jack@suse.cz, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, paolo.valente@linaro.org, shinichiro.kawasaki@wdc.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2023/02/21 18:19, Holger Hoffstätte 写道:
> On 2023-02-21 08:04, Yu Kuai wrote:
>> Hi, Jens
>>
>> 在 2023/01/13 17:44, Yu Kuai 写道:
>>> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 
>>> 'bfqq->bic'"),
>>> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
>>> bic->bfqq will be freed first, and bic_set_bfqq() is called with the 
>>> freed
>>> bic->bfqq.
>>>
>>> Fix the problem by always freeing bfqq after bic_set_bfqq().
>>>
>>> Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
>>> Reported-and-tested-by: Shinichiro Kawasaki 
>>> <shinichiro.kawasaki@wdc.com>
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> ---
>>>   block/bfq-cgroup.c  | 2 +-
>>>   block/bfq-iosched.c | 4 +++-
>>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>>> index a6e8da5f5cfd..feb13ac25557 100644
>>> --- a/block/bfq-cgroup.c
>>> +++ b/block/bfq-cgroup.c
>>> @@ -749,8 +749,8 @@ static void bfq_sync_bfqq_move(struct bfq_data 
>>> *bfqd,
>>>            * old cgroup.
>>>            */
>>>           bfq_put_cooperator(sync_bfqq);
>>> -        bfq_release_process_ref(bfqd, sync_bfqq);
>>>           bic_set_bfqq(bic, NULL, true, act_idx);
>>> +        bfq_release_process_ref(bfqd, sync_bfqq);
>>>       }
>>>   }
>>>
>>
>> It seems this change is missed in GIT PULL for-6.3. I'll send a seperate
>> patch to fix this...
>>
> 
> It was already applied in time for 6.2 as 
> b600de2d7d3a16f9007fad1bdae82a3951a26af2
> and also already merged to 6.1-stable.

Yes, 6.2 and 6.1 doesn't have such problem because bfq_sync_bfqq_move()
doesn't exist. The problem only exist in master branch currently.

Thanks,
Kuai
> 
> cheers
> Holger
> 
> .
> 

