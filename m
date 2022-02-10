From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v3 0/3] block, bfq: minor cleanup and fix
Date: Thu, 10 Feb 2022 19:46:04 +0800
Message-ID: <0215f548-5d5f-107d-9c8e-3a802a51e00f@huawei.com>
References: <20220129015924.3958918-1-yukuai3@huawei.com>
 <7cb40388-02e9-712a-6a40-ccabd5605880@kernel.dk>
 <9ed6bf05-4c31-eef1-1736-65915e55eb8e@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <9ed6bf05-4c31-eef1-1736-65915e55eb8e@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe@kernel.dk>
Cc: paolo.valente@linaro.org, jack@suse.cz, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

在 2022/01/29 10:05, yukuai (C) 写道:
> 在 2022/01/29 9:51, Jens Axboe 写道:
>> On 1/28/22 6:59 PM, Yu Kuai wrote:
>>> Changes in v3:
>>>   - fix a clerical error in patch 2
>>>
>>> Chagnes in v2:
>>>   - add comment in patch 2
>>>   - remove patch 4, since the problem do not exist.
>>>
>>> Yu Kuai (3):
>>>    block, bfq: cleanup bfq_bfqq_to_bfqg()
>>>    block, bfq: avoid moving bfqq to it's parent bfqg
>>>    block, bfq: don't move oom_bfqq
>>>
>>>   block/bfq-cgroup.c  | 16 +++++++++++++++-
>>>   block/bfq-iosched.c |  4 ++--
>>>   block/bfq-iosched.h |  1 -
>>>   block/bfq-wf2q.c    | 15 ---------------
>>>   4 files changed, 17 insertions(+), 19 deletions(-)
>>
>> I'm not even looking at this until you tell me that:
>>
>> a) you've actually compiled this one. which, btw, I can't believe
>>     needs mentioning, particularly when you had enough time to keep
>>     pinging about this patchset.
>>
>> b) it's actually be run. last one was clearly not.
>>
> Hi,
> 
> I compiled and tested the patchset locally in a different version,
> v4.19 specifically. However, after I decide to send them to mainline,
> I made such clerical mistake and forgot to check the patches.
> 
> My sincerely apologize again...
> Kuai

Hi, Jens

Can you please apply this patch this time?

Thanks,
Kuai
