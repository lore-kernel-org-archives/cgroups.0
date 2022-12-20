From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [External] Re: [PATCH] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Tue, 20 Dec 2022 10:38:08 +0800
Message-ID: <78028f86-4fb4-e24e-a01b-d1f8a51cff87@bytedance.com>
References: <20221218111314.55525-1-hanjinke.666@bytedance.com>
 <Y6DWGBQSP/DA7apC@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdsW29O/6Xn6rXQsu5aPcLciaxL4xlcszGahdv8fEa4=;
        b=JX+Yf4WHK86OHRDqIF+sLMufhIcZDg+3+srs173HnZoa49DGsPAWF5Dr5GAckDMRWz
         FKHkNX+zSoaW4T6mj7PFoBB+R7aIPFkoDT6C/zaKh7Fr6YFcJKKB+3TP03RHpygnFjIk
         zT4pk334VL7ur7W5QNW3BqlUa/W794r2umr3pX1aAVp3AXfUJGFwSzJu8dGpw7ZCgTEG
         4NVifBZ8i6VMj0URqFcOG+fZKYrG0HAfPsGfyCS0BgcNENC/nKgRAk4PMZc5vosOwenc
         Y434W1ZNjXPpGBrbmjcVPOpgMpveICUYsPsb8oI5lQrxmvtyQ5C3+4gEoXEATonYs6ZV
         7YBw==
In-Reply-To: <Y6DWGBQSP/DA7apC@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com



在 2022/12/20 上午5:22, Tejun Heo 写道:
> Hello,
> 
> This looks generally fine to me. Some nits below.
> 
>> +static inline struct bio *throtl_qnode_bio_peek(struct throtl_qnode *qn)
>> +{
>> +	struct bio *bio1, *bio2;
>> +
>> +	/* qn for read ios */
>> +	if (qn->dispatch_sync_cnt == UINT_MAX)
>> +		return bio_list_peek(&qn->bios[SYNC]);
>> +
>> +	/* qn for write ios */
>> +	bio1 = bio_list_peek(&qn->bios[SYNC]);
>> +	bio2 = bio_list_peek(&qn->bios[ASYNC]);
>> +
>> +	if (bio1 && bio2) {
>> +		if (qn->dispatch_sync_cnt == THROTL_SYNC_FACTOR)
>> +			return bio2;
>> +		return bio1;
>> +	}
>> +
>> +	return bio1 ?: bio2;
>> +}
> 
> Wouldn't it be simpler to write:
> 
>          if (qn->dispatch_sync_count < THROTL_SYNC_FACTOR)
>                  return bio1 ?: bio2;
>          else
>                  return bio2 ?: bio1;
> 
>> +/**
>> + * throtl_qnode_bio_pop: pop a bio from a qnode
>> + * @qn: the qnode to pop a bio from
>> + *
>> + * For read io qn, just pop bio from sync queu and return.
>> + * For write io qn, the target queue to pop was determined by the dispatch_sync_cnt.
>> + * Try to pop bio from target queue, fetch the bio and return when it is not empty.
>> + * If the target queue empty, pop bio from other queue instead.
>> + */
>> +static inline struct bio *throtl_qnode_bio_pop(struct throtl_qnode *qn)
>> +{
>> +	struct bio *bio;
>> +
>> +	/* qn for read ios */
>> +	if (qn->dispatch_sync_cnt == UINT_MAX)
>> +		return bio_list_pop(&qn->bios[SYNC]);
>> +
>> +	/* try to dispatch sync io */
>> +	if (qn->dispatch_sync_cnt < THROTL_SYNC_FACTOR) {
>> +		bio = bio_list_pop(&qn->bios[SYNC]);
>> +		if (bio) {
>> +			qn->dispatch_sync_cnt++;
>> +			return bio;
>> +		}
>> +		bio = bio_list_pop(&qn->bios[ASYNC]);
>> +		qn->dispatch_sync_cnt = 0;
>> +		return bio;
>> +	}
>> +
>> +	/* try to dispatch async io */
>> +	bio = bio_list_pop(&qn->bios[ASYNC]);
>> +	if (bio) {
>> +		qn->dispatch_sync_cnt = 0;
>> +		return bio;
>> +	}
>> +	bio = bio_list_pop(&qn->bios[SYNC]);
>> +
>> +	return bio;
>> +}
> 
> This also seems like it can be simplified a bit.
> 
> Thanks.
> 

Indeed, I will make it more clear and send the v2.

Thanks.
