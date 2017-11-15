From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 6/7] blkcg: account requests instead of bios for request
 based request_queues
Date: Wed, 15 Nov 2017 10:19:26 -0700
Message-ID: <9a2ddc6a-d618-a896-290c-254ffeb5e9d6@kernel.dk>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-7-tj@kernel.org>
 <20171114232355.vjxlzfbqbqj5ihq4@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RhV2hQuCzSaMq4Fs6KDBR1rrJ7X7EY/VVFEJ7KffRQY=;
        b=bPr9LnO1pInRVgch17yhsF1gbMTXYJsTKsWdvgvyiSrcazxeGYMglCvoFu/ijsbl9m
         MaaY1UVosvC6XxJwV8kEV2ozDn1EZSX5jThImTpei9OaOWP99kLS/zLrL+3Mu9X9swal
         NBOwApqjLldbaDXPXE3M//LrvrNcikZYoHEf4AVzFM6ujEN56ZIzkBi4cntjOR2OeNE3
         IeWdV2wwDa0TCjQYnPyVZvei0RkHDf3KKLGlf2n/6jRP/ckaWyGSEUZkS1bAkUG/Dzfk
         VPLPNv9bquYrvuBwq0b2H9KlQMxJIuk8rH/M24oJMBU9OlYqMw8vYlGUtI6UCaGOuMhw
         sy8A==
In-Reply-To: <20171114232355.vjxlzfbqbqj5ihq4-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 11/14/2017 04:23 PM, Shaohua Li wrote:
> On Sun, Nov 12, 2017 at 02:26:12PM -0800, Tejun Heo wrote:
>> blkcg accounting is currently bio based, which is silly for request
>> based request_queues.  This is silly as the number of bios doesn't
>> have much to do with the actual number of IOs issued to the underlying
>> device (can be significantly higher or lower) and may change depending
>> on the implementation details on how the bios are issued (e.g. from
>> the recent split-bios-while-issuing change).
>>
>> request based request_queues have QUEUE_FLAG_IO_STAT set by default
>> which controls the gendisk accounting.  Do cgroup accounting for those
>> request_queues together with gendisk accounting on request completion.
>>
>> This makes cgroup accounting consistent with gendisk accounting and
>> what's happening on the system.
>>
>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  block/blk-core.c           |  3 +++
>>  include/linux/blk-cgroup.h | 18 +++++++++++++++++-
>>  2 files changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 048be4a..ad23b96 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -2429,6 +2429,7 @@ void blk_account_io_completion(struct request *req, unsigned int bytes)
>>  		cpu = part_stat_lock();
>>  		part = req->part;
>>  		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
>> +		blkcg_account_io_completion(req, bytes);
>>  		part_stat_unlock();
>>  	}
>>  }
>> @@ -2454,6 +2455,8 @@ void blk_account_io_done(struct request *req)
>>  		part_round_stats(req->q, cpu, part);
>>  		part_dec_in_flight(req->q, part, rw);
>>  
>> +		blkcg_account_io_done(req);
>> +
>>  		hd_struct_put(part);
>>  		part_stat_unlock();
>>  	}
>> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
>> index 96eed0f..f2f9691 100644
>> --- a/include/linux/blk-cgroup.h
>> +++ b/include/linux/blk-cgroup.h
>> @@ -715,7 +715,8 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
>>  
>>  	throtl = blk_throtl_bio(q, blkg, bio);
>>  
>> -	if (!throtl) {
>> +	/* if @q does io stat, blkcg stats are updated together with them */
>> +	if (!blk_queue_io_stat(q) && !throtl) {
> 
> Reviewed-by: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> One nitpick, can we use q->request_fn to determine request based queue? I think
> that is more reliable and usual way for this.

That won't work for mq - but there is a helper for this, queue_is_rq_based().

-- 
Jens Axboe
