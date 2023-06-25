From: hanjinke <hanjinke.666@bytedance.com>
Subject: Re: [PATCH v3] blk-throttle: Fix io statistics for cgroup v1
Date: Sun, 25 Jun 2023 12:50:28 +0800
Message-ID: <a82fd11d-d346-4cba-fdbb-982359fb9faa@bytedance.com>
References: <20230507170631.89607-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687668641; x=1690260641;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WAXKmRxn/lGVEXnXeDsvJ+fu3YmCBSEAvX8M4/5L5VA=;
        b=bMuj7cwDdoXKISTDkzptBDyzYxrmMPhttiVwFLmhishVLlAo/0wcnWwOOKc5KaDNXp
         0k1HqVrE8Hx7iR7I7S4xdgjAcc5RhvCF5AELHTGX1kf+O9BpKUzHAOBQSa1iEErhttPG
         3b8+RInnKIdo158WvXe5DmpQDrKtM/VZ8zy1c1yjNq1BiAywsa7z+uXaapI0WPiNEIN2
         xYurTWq7Vuo8HrBQaeEzXCMEGA27/vW97vRYC2U9pTOkepUYpTbHjrTJjbKUb4nmrFuu
         bKGTE90OMX8RqnCmlESML1SKSVkVZ1RzSxXEdsvuOjJYEyq854vI3FsIqHl2KEiBEsFI
         y2sg==
In-Reply-To: <20230507170631.89607-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, andrea.righi@canonical.com

Hi,Jens

Can you consider merging this patch？I think this is a fix. It also
Acked-by Tejun, Muchun Song and Tested-by Andrea Righi.

在 2023/5/8 上午1:06, Jinke Han 写道:
> From: Jinke Han <hanjinke.666@bytedance.com>
> 
> After commit f382fb0bcef4 ("block: remove legacy IO schedulers"),
> blkio.throttle.io_serviced and blkio.throttle.io_service_bytes become
> the only stable io stats interface of cgroup v1, and these statistics
> are done in the blk-throttle code. But the current code only counts the
> bios that are actually throttled. When the user does not add the throttle
> limit, the io stats for cgroup v1 has nothing. I fix it according to the
> statistical method of v2, and made it count all ios accurately.
> 
> Fixes: a7b36ee6ba29 ("block: move blk-throtl fast path inline")
> Tested-by: Andrea Righi <andrea.righi@canonical.com>
> Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>
> ---
>   block/blk-cgroup.c   | 6 ++++--
>   block/blk-throttle.c | 6 ------
>   block/blk-throttle.h | 9 +++++++++
>   3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 0ce64dd73cfe..5b29912a0ee2 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -2048,6 +2048,9 @@ void blk_cgroup_bio_start(struct bio *bio)
>   	struct blkg_iostat_set *bis;
>   	unsigned long flags;
>   
> +	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
> +		return;
> +
>   	/* Root-level stats are sourced from system-wide IO stats */
>   	if (!cgroup_parent(blkcg->css.cgroup))
>   		return;
> @@ -2079,8 +2082,7 @@ void blk_cgroup_bio_start(struct bio *bio)
>   	}
>   
>   	u64_stats_update_end_irqrestore(&bis->sync, flags);
> -	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
> -		cgroup_rstat_updated(blkcg->css.cgroup, cpu);
> +	cgroup_rstat_updated(blkcg->css.cgroup, cpu);
>   	put_cpu();
>   }
>   
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 9d010d867fbf..7397ff199d66 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2178,12 +2178,6 @@ bool __blk_throtl_bio(struct bio *bio)
>   
>   	rcu_read_lock();
>   
> -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
> -		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> -				bio->bi_iter.bi_size);
> -		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> -	}
> -
>   	spin_lock_irq(&q->queue_lock);
>   
>   	throtl_update_latency_buckets(td);
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index ef4b7a4de987..d1ccbfe9f797 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -185,6 +185,15 @@ static inline bool blk_should_throtl(struct bio *bio)
>   	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
>   	int rw = bio_data_dir(bio);
>   
> +	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
> +		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
> +			bio_set_flag(bio, BIO_CGROUP_ACCT);
> +			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> +					bio->bi_iter.bi_size);
> +		}
> +		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> +	}
> +
>   	/* iops limit is always counted */
>   	if (tg->has_rules_iops[rw])
>   		return true;
