From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 4/5] block: move the bdi from the request_queue to the
 gendisk
Date: Mon, 9 Aug 2021 11:57:42 -0600
Message-ID: <2c007f99-b8f1-3f84-7575-cb6934704388@kernel.dk>
References: <20210809141744.1203023-1-hch@lst.de>
 <20210809141744.1203023-5-hch@lst.de> <20210809154728.GH30319@quack2.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CQFaNzQzJrk6MErWJ+eofTzgW919Cz/LICK5EdRu2O4=;
        b=OCsdWUkSNnhvzgS8bElHmmkjdbZS0zrbwwpAMlwY9cuFhsHQ8eDrMpfxpLsGR3WgKe
         tEU0/IEcBigi6V5cP+32KnLPrhFSzKQ9Zq62XuNJUf3GbAzBnYMfPnYxQT2bqMYv37gH
         jdppPqPVoZhuLhW8EN4nS7nE6aghrJvxPRTaTaepALonKUIde0paOsDMbo/8Y57uZw/Z
         zu/Z0xoSyMKC0lvkuPA/esnGbaon/tFO/jxgLqhLAm5b/E3cuE+nmXUirHzWH7Od59y8
         tDOpM5ut/q+/WvWAWxyP8KPIOl77vqpfjlJhxNe1icfxml6qI1k9LjIuCqnih/ERPyue
         a6jQ==
In-Reply-To: <20210809154728.GH30319-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 8/9/21 9:47 AM, Jan Kara wrote:
> On Mon 09-08-21 16:17:43, Christoph Hellwig wrote:
>> The backing device information only makes sense for file system I/O,
>> and thus belongs into the gendisk and not the lower level request_queue
>> structure.  Move it there.
>>
>> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> Looks mostly good. I'm just unsure whether some queue_to_disk() calls are
> safe.
> 
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index 2c4ac51e54eb..d2725f94491d 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -525,7 +525,7 @@ void blk_mq_free_request(struct request *rq)
>>  		__blk_mq_dec_active_requests(hctx);
>>  
>>  	if (unlikely(laptop_mode && !blk_rq_is_passthrough(rq)))
>> -		laptop_io_completion(q->backing_dev_info);
>> +		laptop_io_completion(queue_to_disk(q)->bdi);
>>
> 
> E.g. cannot this get called for a queue that is without a disk?

Should be fine, as it's checking for passthrough. Maybe famous last
words, but we should not be seeing regular IO before disk is setup.

>> @@ -359,8 +359,8 @@ static void wb_timer_fn(struct blk_stat_callback *cb)
>>  
>>  	status = latency_exceeded(rwb, cb->stat);
>>  
>> -	trace_wbt_timer(rwb->rqos.q->backing_dev_info, status, rqd->scale_step,
>> -			inflight);
>> +	trace_wbt_timer(queue_to_disk(rwb->rqos.q)->bdi, status,
>> +			rqd->scale_step, inflight);
>>  
>>  	/*
>>  	 * If we exceeded the latency target, step down. If we did not,
> 
> Or all these calls - is wbt guaranteed to only be setup for a queue with
> disk?

Same for this one.

-- 
Jens Axboe

