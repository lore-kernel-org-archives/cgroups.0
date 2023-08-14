From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH 1/1] blk-throttle: fix throttle configuring not effective
Date: Mon, 14 Aug 2023 10:01:21 +0800
Message-ID: <d69f850a-ecfc-61dc-a970-64f57fff806f@huaweicloud.com>
References: <20230812072116.42321-1-zhuxiaohui.400@bytedance.com>
 <5ba76f5e-9b02-13c8-c2a3-b15fe016261d@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5ba76f5e-9b02-13c8-c2a3-b15fe016261d@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, zhuxiaohui <zhuxiaohui400@gmail.com>, tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhuxiaohui <zhuxiaohui.400@bytedance.com>, "yukuai (C)" <yukuai3@huawei.com>

+CC Michal.

在 2023/08/12 15:53, Yu Kuai 写道:
> Hi,
> 
> 在 2023/08/12 15:21, zhuxiaohui 写道:
>> when updating block throttle limit with persistence and stable io
>> pressure, especially a relative high io pressure, fio test e.g.,
>> there may never be a change to start a new slice, and carryover_ios &
>> carryover_bytes will not be cleared.
>>
>> As a result, when reconfiguring block throttle limit, we can notice that
>> the actual iops and throughput is a random value far away from what is
>> set
>>
>> So we need to update carryover value when dispatching bio
> 
> I don't understand, not clear carryover_bytes/ios is what expected, and
> how can they affect actual bandwith/iops.
> 
> Can you give a example how you tested and why current calculation is not
> correct?

I can reporduce this, but this patch is obviously wrong. You must
explaim how the calculation is not correct.

After a quick loock, I found that carryover_bytes/ios is not updated in
throtl_trim_slice(), while tg->io/bytes_disp[] can be cleared. This is
definitly a problem.

Thanks,
Kuai

> 
> Thanks,
> Kuai
> 
>>
>> Signed-off-by: zhuxiaohui <zhuxiaohui.400@bytedance.com>
>> ---
>>   block/blk-throttle.c | 26 ++++++++++++++++++++++++++
>>   block/blk-throttle.h |  4 ++--
>>   2 files changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 7397ff199d66..13c9d87a7201 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -821,6 +821,30 @@ static void tg_update_carryover(struct throtl_grp 
>> *tg)
>>              tg->carryover_ios[READ], tg->carryover_ios[WRITE]);
>>   }
>> +static void tg_charge_carryover(struct throtl_grp *tg, struct bio *bio)
>> +{
>> +    bool rw = bio_data_dir(bio);
>> +
>> +    if (unlikely(tg->carryover_bytes[rw])) {
>> +        unsigned int bio_size = throtl_bio_data_size(bio);
>> +        unsigned int carryout_size = abs(tg->carryover_bytes[rw]);
>> +
>> +        carryout_size = min(carryout_size, bio_size);
>> +
>> +        if (tg->carryover_bytes[rw] < 0)
>> +            tg->carryover_bytes[rw] += carryout_size;
>> +        else
>> +            tg->carryover_bytes[rw] -= carryout_size;
>> +    }
>> +
>> +    if (unlikely(tg->carryover_ios[rw])) {
>> +        if (tg->carryover_ios[rw] < 0)
>> +            tg->carryover_ios[rw] += 1;
>> +        else
>> +            tg->carryover_ios[rw] -= 1;
>> +    }
>> +}
>> +
>>   static unsigned long tg_within_iops_limit(struct throtl_grp *tg, 
>> struct bio *bio,
>>                    u32 iops_limit)
>>   {
>> @@ -965,6 +989,8 @@ static void throtl_charge_bio(struct throtl_grp 
>> *tg, struct bio *bio)
>>       tg->io_disp[rw]++;
>>       tg->last_io_disp[rw]++;
>> +
>> +    tg_charge_carryover(tg, bio);
>>   }
>>   /**
>> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
>> index d1ccbfe9f797..8f1642becb23 100644
>> --- a/block/blk-throttle.h
>> +++ b/block/blk-throttle.h
>> @@ -127,8 +127,8 @@ struct throtl_grp {
>>        * bytes/ios are waited already in previous configuration, and 
>> they will
>>        * be used to calculate wait time under new configuration.
>>        */
>> -    uint64_t carryover_bytes[2];
>> -    unsigned int carryover_ios[2];
>> +    int64_t carryover_bytes[2];
>> +    int carryover_ios[2];
>>       unsigned long last_check_time;
>>
> 
> .
> 

