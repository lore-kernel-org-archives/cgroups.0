From: Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next v2] block: remove init_mutex and open-code
 blk_iolatency_try_init
Date: Thu, 10 Aug 2023 11:20:03 +0800
Message-ID: <e5539fc2-9c30-3da5-ce81-fd67fc0fd53a@huaweicloud.com>
References: <20230809112928.2009183-1-lilingfeng@huaweicloud.com>
 <6dcshmol4oz4hpsm42s3ocfdg7rtykkx2vjg6fd6zdvmkbmg7w@4liecv2rxqqk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6dcshmol4oz4hpsm42s3ocfdg7rtykkx2vjg6fd6zdvmkbmg7w@4liecv2rxqqk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lilingfeng3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


在 2023/8/9 20:11, Michal Koutný 写道:
> On Wed, Aug 09, 2023 at 07:29:28PM +0800, Li Lingfeng <lilingfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
>>   1 file changed, 10 insertions(+), 24 deletions(-)
> I like this bottom line.
>
>> @@ -861,7 +838,16 @@ static ssize_t iolatency_set_limit(struct kernfs_open_file *of, char *buf,
>>   
>>   	blkg_conf_init(&ctx, buf);
>>   
>> -	ret = blk_iolatency_try_init(&ctx);
>> +	ret = blkg_conf_open_bdev(&ctx);
>> +	if (ret)
>> +		goto out;
>> +
>> +	/*
>> +	 * blk_iolatency_init() may fail after rq_qos_add() succeeds which can
>> +	 * confuse iolat_rq_qos() test. Make the test and init atomic.
>> +	 */
> Perhaps add here
> 	lockdep_assert_held(ctx.bdev->bd_queue->rq_qos_mutex);
>
> because without that the last sentence of the comment misses the
> context.

Yes, it looks better.

Thanks.

Li

>
>> +	if (!iolat_rq_qos(ctx.bdev->bd_queue))
>> +		ret = blk_iolatency_init(ctx.bdev->bd_disk);
>>   	if (ret)
>>   		goto out;
> Thanks,
> Michal

