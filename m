From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] blk-throttle: Fix io statistics for
 cgroup v1
Date: Sun, 7 May 2023 23:32:05 +0800
Message-ID: <9b3abfd1-e925-61fe-80c0-6076b03f49f9@bytedance.com>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
 <ZEwY5Oo+5inO9UFf@righiandr-XPS-13-7390>
 <eb2eeb6b-07da-4e98-142c-da1e7ea35c2b@bytedance.com>
 <ZFQf3TCs7DqsSR8l@righiandr-XPS-13-7390>
 <6696100e-e838-d96a-2894-bbca9783d2a3@bytedance.com>
 <ZFY9ocCi2EPU3Cu3@righiandr-XPS-13-7390>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683473531; x=1686065531;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAJuFKA2WbO5t/MWWkp+wgsDKDGBHsZX3U7rMhZW364=;
        b=UpbnHFU0yNMCgNV9dnHl4cjW83awcatKcDRhy2ig6Ca5S9Z3M94my+SMkCOVeNFnTl
         RAQfynxmMy0N2iLYGLBm5Az1588DhsKr6umonO9iVsKIg4VskyU0ABt3asFM4iEdqmr6
         uTHJsBxh4dFRGoxgZFmA7YNRcXzrdpD9P/dyvHQTmjSiC0dl2LutRFA0d7RsKavWGiNR
         WwNFi73Hd1VzqbCbKaO5MSTkw1+nIXtIfdlquAe0Mz+PmgvH3ZCetgaMwxwgxaCkn3Gf
         7BKZH0oX19hHHZ6TLmtytJ/cRW2hMBWKyRsaBKsFcwdNszfw9hY60KQq/B79zbfVUnHm
         Ybeg==
In-Reply-To: <ZFY9ocCi2EPU3Cu3@righiandr-XPS-13-7390>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2023/5/6 下午7:44, Andrea Righi 写道:
> On Fri, May 05, 2023 at 09:35:21PM +0800, hanjinke wrote:
>>
>>
>> 在 2023/5/5 上午5:13, Andrea Righi 写道:
>>> On Thu, May 04, 2023 at 11:08:53PM +0800, hanjinke wrote:
>>>> Hi
>>>>
>>>> Sorry for delay（Chinese Labor Day holiday).
>>>
>>> No problem, it was also Labor Day in Italy. :)
>>>
>>>>
>>>> 在 2023/4/29 上午3:05, Andrea Righi 写道:
>>>>> On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han wrote:
>>>>>> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>>>>>
>>>>>> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
>>>>>> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
>>>>>> the only stable io stats interface of cgroup v1, and these statistics
>>>>>> are done in the blk-throttle code. But the current code only counts the
>>>>>> bios that are actually throttled. When the user does not add the throttle
>>>>>> limit, the io stats for cgroup v1 has nothing. I fix it according to the
>>>>>> statistical method of v2, and made it count all ios accurately.
>>>>>>
>>>>>> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
>>>>>> Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>>>>
>>>>> Thanks for fixing this!
>>>>>
>>>>> The code looks correct to me, but this seems to report io statistics
>>>>> only if at least one throttling limit is defined. IIRC with cgroup v1 it
>>>>> was possible to see the io statistics inside a cgroup also with no
>>>>> throttling limits configured.
>>>>>
>>>>> Basically to restore the old behavior we would need to drop the
>>>>> cgroup_subsys_on_dfl() check, something like the following (on top of
>>>>> your patch).
>>>>>
>>>>> But I'm not sure if we're breaking other behaviors in this way...
>>>>> opinions?
>>>>>
>>>>>     block/blk-cgroup.c   |  3 ---
>>>>>     block/blk-throttle.h | 12 +++++-------
>>>>>     2 files changed, 5 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>>>>> index 79138bfc6001..43af86db7cf3 100644
>>>>> --- a/block/blk-cgroup.c
>>>>> +++ b/block/blk-cgroup.c
>>>>> @@ -2045,9 +2045,6 @@ void blk_cgroup_bio_start(struct bio *bio)
>>>>>     	struct blkg_iostat_set *bis;
>>>>>     	unsigned long flags;
>>>>> -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
>>>>> -		return;
>>>>> -
>>>>>     	/* Root-level stats are sourced from system-wide IO stats */
>>>>>     	if (!cgroup_parent(blkcg->css.cgroup))
>>>>>     		return;
>>>>> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
>>>>> index d1ccbfe9f797..bcb40ee2eeba 100644
>>>>> --- a/block/blk-throttle.h
>>>>> +++ b/block/blk-throttle.h
>>>>> @@ -185,14 +185,12 @@ static inline bool blk_should_throtl(struct bio *bio)
>>>>>     	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
>>>>>     	int rw = bio_data_dir(bio);
>>>>> -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
>>>>> -		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
>>>>> -			bio_set_flag(bio, BIO_CGROUP_ACCT);
>>>>> -			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
>>>>> -					bio->bi_iter.bi_size);
>>>>> -		}
>>>>> -		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
>>>>> +	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
>>>>> +		bio_set_flag(bio, BIO_CGROUP_ACCT);
>>>>> +		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
>>>>> +				bio->bi_iter.bi_size);
>>>>>     	}
>>>>> +	blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
>>>>
>>
>> I checked the code again. If we remove cgroup_subsys_on_dfl check here, io
>> statistics will still be performed in the case of v2, which I think is
>> unnecessary, and this information will be counted to
>> io_service_bytes/io_serviced, these two files are not visible in v2. Am I
>> missing something?
> 
> You are absolutely right. Sorry, I have just re-tested your fix and it
> seems to handle the cgroup v1 case correctly, you can add my:
> 
> Tested-by: Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> 
> And we definitely need the cgroup_subsys_on_dfl() check, otherwise we'd
> account extra IO in the v2 case that is not really needed.
> 

Thanks a lot! I will add it and send a v3.

Thanks，
Jinke
