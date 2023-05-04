From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] blk-throttle: Fix io statistics for
 cgroup v1
Date: Thu, 4 May 2023 23:08:53 +0800
Message-ID: <eb2eeb6b-07da-4e98-142c-da1e7ea35c2b@bytedance.com>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
 <ZEwY5Oo+5inO9UFf@righiandr-XPS-13-7390>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683212939; x=1685804939;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFa1D5Tpf/QrQJM5h3CrUwGz4UKarPH+tDSx3KZiqW0=;
        b=DNqvvH4fVrTxxmy3uWocPqMrVQzGrvn1bKV/DBRhuLaJP6xVuRfHqmbHfrevd1owR/
         jiCrzjiOJ6WKw3SidjtKGTAo3Kw6pc6zVNOe6oEJ3Q7NwivVlUyL5fyWvqWOdTYm67kg
         bB8EjQA5ooh95ZqFlEOhksFT0f1AAMr4Zq0N5VHLOQUfiSYQ2Jc4c9mMxf5zpl9GlztJ
         79At54zrwpPkmPzu2hgVlWkTkzYQtfrDyMp6XW8rtYcSI5MAQsYKVXYMVqd667juw5MI
         6RoawcuDBmVVXahW627FRVPS71JWh8CGrpk9MFh7Dh0Tq7PtZCP2VYWXY72KPg5byozj
         1LIA==
In-Reply-To: <ZEwY5Oo+5inO9UFf@righiandr-XPS-13-7390>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Andrea Righi <andrea.righi-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi

Sorry for delay（Chinese Labor Day holiday).

在 2023/4/29 上午3:05, Andrea Righi 写道:
> On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han wrote:
>> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
>> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
>> the only stable io stats interface of cgroup v1, and these statistics
>> are done in the blk-throttle code. But the current code only counts the
>> bios that are actually throttled. When the user does not add the throttle
>> limit, the io stats for cgroup v1 has nothing. I fix it according to the
>> statistical method of v2, and made it count all ios accurately.
>>
>> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
>> Signed-off-by: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Thanks for fixing this!
> 
> The code looks correct to me, but this seems to report io statistics
> only if at least one throttling limit is defined. IIRC with cgroup v1 it
> was possible to see the io statistics inside a cgroup also with no
> throttling limits configured.
> 
> Basically to restore the old behavior we would need to drop the
> cgroup_subsys_on_dfl() check, something like the following (on top of
> your patch).
> 
> But I'm not sure if we're breaking other behaviors in this way...
> opinions?
> 
>   block/blk-cgroup.c   |  3 ---
>   block/blk-throttle.h | 12 +++++-------
>   2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 79138bfc6001..43af86db7cf3 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -2045,9 +2045,6 @@ void blk_cgroup_bio_start(struct bio *bio)
>   	struct blkg_iostat_set *bis;
>   	unsigned long flags;
>   
> -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
> -		return;
> -
>   	/* Root-level stats are sourced from system-wide IO stats */
>   	if (!cgroup_parent(blkcg->css.cgroup))
>   		return;
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index d1ccbfe9f797..bcb40ee2eeba 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -185,14 +185,12 @@ static inline bool blk_should_throtl(struct bio *bio)
>   	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
>   	int rw = bio_data_dir(bio);
>   
> -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
> -		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> -			bio_set_flag(bio, BIO_CGROUP_ACCT);
> -			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> -					bio->bi_iter.bi_size);
> -		}
> -		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> +	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> +		bio_set_flag(bio, BIO_CGROUP_ACCT);
> +		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> +				bio->bi_iter.bi_size);
>   	}
> +	blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);

It seems that statistics have been carried out in both v1 and v2，we can 
get the statistics of v2 from io.stat, is it necessary to count v2 here?


