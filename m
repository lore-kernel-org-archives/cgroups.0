From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger-yRdLqooqVXZ9NkuW+OO3NY3UfPj+9hkl@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix uaf for bfqq in bic_set_bfqq()
Date: Tue, 21 Feb 2023 11:19:21 +0100
Message-ID: <3e8c8567-f41d-66ae-0633-dcdbed007228@applied-asynchrony.com>
References: <20230113094410.2907223-1-yukuai3@huawei.com>
 <ca9fefd4-7109-042c-3b25-9eb795141145@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ca9fefd4-7109-042c-3b25-9eb795141145-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 2023-02-21 08:04, Yu Kuai wrote:
> Hi, Jens
> 
> 在 2023/01/13 17:44, Yu Kuai 写道:
>> After commit 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'"),
>> bic->bfqq will be accessed in bic_set_bfqq(), however, in some context
>> bic->bfqq will be freed first, and bic_set_bfqq() is called with the freed
>> bic->bfqq.
>>
>> Fix the problem by always freeing bfqq after bic_set_bfqq().
>>
>> Fixes: 64dc8c732f5c ("block, bfq: fix possible uaf for 'bfqq->bic'")
>> Reported-and-tested-by: Shinichiro Kawasaki <shinichiro.kawasaki-Sjgp3cTcYWE@public.gmane.org>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   block/bfq-cgroup.c  | 2 +-
>>   block/bfq-iosched.c | 4 +++-
>>   2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index a6e8da5f5cfd..feb13ac25557 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -749,8 +749,8 @@ static void bfq_sync_bfqq_move(struct bfq_data *bfqd,
>>            * old cgroup.
>>            */
>>           bfq_put_cooperator(sync_bfqq);
>> -        bfq_release_process_ref(bfqd, sync_bfqq);
>>           bic_set_bfqq(bic, NULL, true, act_idx);
>> +        bfq_release_process_ref(bfqd, sync_bfqq);
>>       }
>>   }
>>
> 
> It seems this change is missed in GIT PULL for-6.3. I'll send a seperate
> patch to fix this...
> 

It was already applied in time for 6.2 as b600de2d7d3a16f9007fad1bdae82a3951a26af2
and also already merged to 6.1-stable.

cheers
Holger
