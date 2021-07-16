From: brookxu <brookxu.cn@gmail.com>
Subject: Re: [PATCH] blk-throtl: optimize IOPS throttle for large IO scenarios
Date: Sat, 17 Jul 2021 07:07:25 +0800
Message-ID: <9d8b584a-738b-a0a8-ea8c-e617c2f79408@gmail.com>
References: <1626416569-30907-1-git-send-email-brookxu.cn@gmail.com>
 <YPGvIzZUI+QxP1js@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P6K+M5gqphiIlNgiFVLzyTugz5hPofZVAtQFiBp7d9s=;
        b=ullVU331i6gIy4bDcdWB3Z/mYU0uuO8Zz4+zTPF4DwwlLYBpWuoLo8phBHSXV0zQ7I
         SnHGjhyqsblUks+TDqDyRg4ZJkN2L9qsQLpMeWKT7t2h8zLaPWdo1UYACdUf3Xt6tIwd
         xB4cZZL3MNrmfbw7bGVtnvkjs5Vu7ZmfUO4pZ8XbSiiJeBdR3nAAJ+Su2ue+vfNRElSD
         5PG0YGgodlVwx9uT7QnwAZcpoSzxV7h1nEUvVATn3P0i1EsFusZbwh3n3m8MC2cgND5M
         fw4uP+kNHZBoBmDmHLFdtj6j4Wj3usLgezpO6JfVgH0i+0WPB26yOjAL/vNUUtDFWces
         mi6Q==
In-Reply-To: <YPGvIzZUI+QxP1js@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



Tejun Heo wrote on 2021/7/17 0:09:
> Hello,
> 
> On Fri, Jul 16, 2021 at 02:22:49PM +0800, brookxu wrote:
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
> I don't think we're holding the queue lock here.

sorry, some kind of synchronization mechanism is really needed here. But the use of queue_lock
here may be unsafe, since it is difficult for us to control the lock on the split path.

>>  	}
>>  }
>>  
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index b1b22d8..1967438 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -2176,6 +2176,40 @@ static inline void throtl_update_latency_buckets(struct throtl_data *td)
>>  }
>>  #endif
>>  
>> +void blk_throtl_recharge_bio(struct bio *bio)
>> +{
>> +	bool rw = bio_data_dir(bio);
>> +	struct blkcg_gq *blkg = bio->bi_blkg;
>> +	struct throtl_grp *tg = blkg_to_tg(blkg);
>> +	u32 iops_limit = tg_iops_limit(tg, rw);
>> +
>> +	if (iops_limit == UINT_MAX)
>> +		return;
>> +
>> +	/*
>> +	 * If previous slice expired, start a new one otherwise renew/extend
>> +	 * existing slice to make sure it is at least throtl_slice interval
>> +	 * long since now. New slice is started only for empty throttle group.
>> +	 * If there is queued bio, that means there should be an active
>> +	 * slice and it should be extended instead.
>> +	 */
>> +	if (throtl_slice_used(tg, rw) && !(tg->service_queue.nr_queued[rw]))
>> +		throtl_start_new_slice(tg, rw);
>> +	else {
>> +		if (time_before(tg->slice_end[rw],
>> +		    jiffies + tg->td->throtl_slice))
>> +			throtl_extend_slice(tg, rw,
>> +				jiffies + tg->td->throtl_slice);
>> +	}
>> +
>> +	/* Recharge the bio to the group, as some BIOs will be further split
>> +	 * after passing through the throttle, causing the actual IOPS to
>> +	 * be greater than the expected value.
>> +	 */
>> +	tg->last_io_disp[rw]++;
>> +	tg->io_disp[rw]++;
>> +}
> 
> But blk-throtl expects queue lock to be held.
> 
> How about doing something simpler? Just estimate how many bios a given bio
> is gonna be and charge it outright? The calculation will be duplicated
> between the split path but that seems like the path of least resistance
> here.

I have tried this method, the code redundancy is indeed a bit high, it may not be
very convenient for code maintenance. In addition to this problem, since we add
a large value at a time, the fluctuation of IOPS will be relatively large. Since
blk_throtl_recharge_bio() does not need to participate in the maintenance of the
state machine, we only need to protect some fields of tg, so can we add a new
spin_lock to tg instead of queue_lock to solve the synchronization problem ? Just
a idea, Thanks.

> Thanks.
> 
