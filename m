From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Fri, 11 Aug 2023 09:44:55 +0800
Message-ID: <d4050f7e-d491-c111-3e26-160e7d5a4208@huaweicloud.com>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <6637e6cd-20aa-110a-40ae-53ecd6eb4184@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, Li Lingfeng <lilingfeng@huaweicloud.com>, tj@kernel.org
Cc: josef@toxicpanda.com, axboe@kernel.dk, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linan122@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, lilingfeng3@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

在 2023/08/10 21:43, Yu Kuai 写道:
> 在 2023/08/10 11:51, Li Lingfeng 写道:
>> From: Li Lingfeng <lilingfeng3@huawei.com>
>>
>> Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
>> a mutex named "init_mutex" in blk_iolatency_try_init for the race
>> condition of initializing RQ_QOS_LATENCY.
>> Now a new lock has been add to struct request_queue by commit 
>> a13bd91be223
>> ("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
>> held in blkg_conf_open_bdev before calling blk_iolatency_init.
>> So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
>> remove it.
>>
>> Since init_mutex has been removed, blk_iolatency_try_init can be
>> open-coded back to iolatency_set_limit() like ioc_qos_write().
>>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> 
> Thanks,
> Kuai
>> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
>> ---
>>    v1->v2: open-code blk_iolatency_try_init()
>>    v2->v3: add lockdep check
>>   block/blk-iolatency.c | 35 +++++++++++------------------------
>>   1 file changed, 11 insertions(+), 24 deletions(-)
>>
>> diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
>> index fd5fec989e39..c16aef4be036 100644
>> --- a/block/blk-iolatency.c
>> +++ b/block/blk-iolatency.c
>> @@ -824,29 +824,6 @@ static void iolatency_clear_scaling(struct 
>> blkcg_gq *blkg)
>>       }
>>   }
>> -static int blk_iolatency_try_init(struct blkg_conf_ctx *ctx)
>> -{
>> -    static DEFINE_MUTEX(init_mutex);
>> -    int ret;
>> -
>> -    ret = blkg_conf_open_bdev(ctx);
>> -    if (ret)
>> -        return ret;
>> -
>> -    /*
>> -     * blk_iolatency_init() may fail after rq_qos_add() succeeds 
>> which can
>> -     * confuse iolat_rq_qos() test. Make the test and init atomic.
>> -     */
>> -    mutex_lock(&init_mutex);
>> -
>> -    if (!iolat_rq_qos(ctx->bdev->bd_queue))
>> -        ret = blk_iolatency_init(ctx->bdev->bd_disk);
>> -
>> -    mutex_unlock(&init_mutex);
>> -
>> -    return ret;
>> -}
>> -
>>   static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char 
>> *buf,
>>                    size_t nbytes, loff_t off)
>>   {
>> @@ -861,7 +838,17 @@ static ssize_t iolatency_set_limit(struct 
>> kernfs_open_file *of, char *buf,
>>       blkg_conf_init(&ctx, buf);
>> -    ret = blk_iolatency_try_init(&ctx);
>> +    ret = blkg_conf_open_bdev(&ctx);
>> +    if (ret)
>> +        goto out;
>> +
>> +    /*
>> +     * blk_iolatency_init() may fail after rq_qos_add() succeeds 
>> which can
>> +     * confuse iolat_rq_qos() test. Make the test and init atomic.
>> +     */

The original mutex and above comments is used to avoid the problem that
blk_iolatency_init() is not atomic:

t1:			t2:
if (!iolat_rq_qos)
// not exist
  blk_iolatency_init
   rq_qos_add
   blkcg_activate_policy
   // failed
			if (!iolat_rq_qos)
			// now exist
   rq_qos_del
			...
			// continue while rq_qos is deleted

Now that this problem doesn't exist, I think it's ok just to remove this
comment.

Thanks,
Kuai

>> +    lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);
>> +    if (!iolat_rq_qos(ctx.bdev->bd_queue))
>> +        ret = blk_iolatency_init(ctx.bdev->bd_disk);
>>       if (ret)
>>           goto out;
>>
> 
> .
> 

