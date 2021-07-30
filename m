From: brookxu <brookxu.cn@gmail.com>
Subject: Re: [PATCH v2] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Fri, 30 Jul 2021 10:09:34 +0800
Message-ID: <1ce9bcbb-8eea-f51f-f80a-22caf5f2e0d8@gmail.com>
References: <40915233274d31bb0659ff9f3be8900a5a0e81ba.1627462548.git.brookxu@tencent.com>
 <YQLhRrkZrmKTzfbP@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mQTBEXw5fXJfZ/TwuYgDsyZEqK+e8q8zwd2JV8rkUI4=;
        b=OfGWAGjzAWRnxyGCUY9JGgohLkj7/XotbZNbRMRePBmKhyRjovGp4Mil5rMe9Bfe8w
         28R6ip0kNr8cokWRSu+7t/PM0bcWy+SVysaVQg3HVxKhC064UJfUNHT+7HiPOY8OLYaV
         VQC9I7qXtGfo7eJoro5z1WriftwnGTe0NWAgEp5PTDldjw+L2KmlJYT5NBUP6EpGQ5Te
         26vFNtMlVFW7hQO/E65B5quQa9NuFlPS2YLbSjPWpuZ+ssAfOcDfRATVFkoV7H2/CelC
         vHj4AYfKOmdQWJcskAr8/ted2PMQXBvqb27RSFk06zZ2Me8zb44z55P0wTzyD8eSlwZ4
         61dw==
In-Reply-To: <YQLhRrkZrmKTzfbP@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Thanks for you time.

Tejun Heo wrote on 2021/7/30 1:11 上午:
> Hello,
> 
> On Wed, Jul 28, 2021 at 05:01:41PM +0800, brookxu wrote:
>> diff --git a/block/blk-merge.c b/block/blk-merge.c
>> index a11b3b5..86ff943 100644
>> --- a/block/blk-merge.c
>> +++ b/block/blk-merge.c
>> @@ -348,6 +348,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
>>  		trace_block_split(split, (*bio)->bi_iter.bi_sector);
>>  		submit_bio_noacct(*bio);
>>  		*bio = split;
>> +
>> +		blk_throtl_recharge_bio(*bio);
> 
> Can you rename this blk_throtl_charge_bio_split()?

Ok, i will do it in next version.

>> @@ -524,6 +537,11 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
>>  	tg->idletime_threshold = DFL_IDLE_THRESHOLD;
>>  	tg->idletime_threshold_conf = DFL_IDLE_THRESHOLD;
>>  
>> +	atomic_set(&tg->io_split_cnt[0], 0);
>> +	atomic_set(&tg->io_split_cnt[1], 0);
>> +	atomic_set(&tg->last_io_split_cnt[0], 0);
>> +	atomic_set(&tg->last_io_split_cnt[1], 0);
> 
> We likely don't need these. pd's zeroed on allocation.

Right, i will remove these init code.

>> @@ -877,10 +900,19 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
>>  	else
>>  		tg->bytes_disp[rw] = 0;
>>  
>> -	if (tg->io_disp[rw] >= io_trim)
>> +	if (tg_io_disp(tg, rw) >= io_trim) {
> 
> Instead of checking this in multiple places, would it be simpler to transfer
> the atomic counters to the existing counters whenever we enter blk-throtl
> and leave the rest of the code as-is?

If we do this, we need to do similar processing on the bio submission path and the bio
resubmission path in pending_timer. It seems that the code is more complicated?

> Thanks.
> 
