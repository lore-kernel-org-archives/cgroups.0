From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Sat, 12 Aug 2023 07:34:47 -0600
Message-ID: <00c3ae48-98c5-470d-ac0e-6096a06b7086@kernel.dk>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <169176317573.160467.10047297090390573799.b4-ty@kernel.dk>
 <b93e426e-d9b6-34df-be28-90b715c7a711@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691847290; x=1692452090;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zu6KYCTe3yYV+vjD7U9dsfBkqKtCevBqbtEfY4AodYs=;
        b=vgi9tpHvmPpSDbFGy6DqAGQh4+ePr41OZKekFkPcbZ+gCbQud6GMIL4bXNWm1rG9UD
         vOv2Odm8719ixKdi4QDjO0Iilweec8ic3O48BuH63MHZNHDPsMmlW6142m4JuVJAFeiq
         GO+KgxkHbV1b4pO+Q8Udb7KWG7npl2uuxIe1ZhQAzVrMWTpqren0W8aKz60b1yW5LIdx
         0tUcUCOK5SGHIo9OL0sxX3AZ8AZnx/TbC4gFvywiXbQgjMAF7mjCAty2DHfjGIq5OYUF
         m6YW4mZh0+eYukwyZsE69r7WeRS/HcKPJH5YLs6kSuqb8FuBiL7ape57rq9XBdc7dkmR
         R1rQ==
Content-Language: en-US
In-Reply-To: <b93e426e-d9b6-34df-be28-90b715c7a711@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, Li Lingfeng <lilingfeng@huaweicloud.com>
Cc: josef@toxicpanda.com, mkoutny@suse.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linan122@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, lilingfeng3@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

On 8/11/23 7:42 PM, Yu Kuai wrote:
> Hi, Jens
> 
> ? 2023/08/11 22:12, Jens Axboe ??:
>>
>> On Thu, 10 Aug 2023 11:51:11 +0800, Li Lingfeng wrote:
>>> Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
>>> a mutex named "init_mutex" in blk_iolatency_try_init for the race
>>> condition of initializing RQ_QOS_LATENCY.
>>> Now a new lock has been add to struct request_queue by commit a13bd91be223
>>> ("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
>>> held in blkg_conf_open_bdev before calling blk_iolatency_init.
>>> So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
>>> remove it.
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/1] block: remove init_mutex and open-code blk_iolatency_try_init
>>        commit: 4eb44d10766ac0fae5973998fd2a0103df1d3fe1
> 
> This version has a minor problem that pss in mutex for
> lockdep_assert_held() is not a pointer:
> 
>> lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);
> 
> should be:
> lockdep_assert_held(&ctx.bdev->bd_queue->rq_qos_mutex);

Yes, looked like that patch didn't get compiled... Shame.

> Perhaps can you drop this patch for now, and Lingfeng can send a v4?

I did fix that up 2 days ago myself.

-- 
Jens Axboe

