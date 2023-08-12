From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v3] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Sat, 12 Aug 2023 09:42:26 +0800
Message-ID: <b93e426e-d9b6-34df-be28-90b715c7a711@huaweicloud.com>
References: <20230810035111.2236335-1-lilingfeng@huaweicloud.com>
 <169176317573.160467.10047297090390573799.b4-ty@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <169176317573.160467.10047297090390573799.b4-ty-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jens

在 2023/08/11 22:12, Jens Axboe 写道:
> 
> On Thu, 10 Aug 2023 11:51:11 +0800, Li Lingfeng wrote:
>> Commit a13696b83da4 ("blk-iolatency: Make initialization lazy") adds
>> a mutex named "init_mutex" in blk_iolatency_try_init for the race
>> condition of initializing RQ_QOS_LATENCY.
>> Now a new lock has been add to struct request_queue by commit a13bd91be223
>> ("block/rq_qos: protect rq_qos apis with a new lock"). And it has been
>> held in blkg_conf_open_bdev before calling blk_iolatency_init.
>> So it's not necessary to keep init_mutex in blk_iolatency_try_init, just
>> remove it.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] block: remove init_mutex and open-code blk_iolatency_try_init
>        commit: 4eb44d10766ac0fae5973998fd2a0103df1d3fe1

This version has a minor problem that pss in mutex for
lockdep_assert_held() is not a pointer:

 > lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);

should be:
lockdep_assert_held(&ctx.bdev->bd_queue->rq_qos_mutex);

Perhaps can you drop this patch for now, and Lingfeng can send a v4?

Thanks,
Kuai

> 
> Best regards,
> 

