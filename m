From: Andrea Righi <andrea.righi@canonical.com>
Subject: Re: [PATCH v2] blk-throttle: Fix io statistics for cgroup v1
Date: Fri, 28 Apr 2023 21:05:08 +0200
Message-ID: <ZEwY5Oo+5inO9UFf@righiandr-XPS-13-7390>
References: <20230401094708.77631-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682708710;
        bh=5xdGcBrePTmDfHc6Jzw3JTLHbSAztKlpGArx8vpNt2k=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=rU3GquilWoTt+E66nkoXnDUfQpugdh42eX9qLk43mWrbcLE23a4kXk4GhJjPtiE2+
         OaUZ70g0ZpTIMmqyWhOik/GpIpfGeHAEyDAu5Dbe8wxTtkBSXAX/o3y5DZblYSAfBO
         A/CDMv9FMuq4+Y7iDq94d5NxUWMyCEkHWEegxBArMhblt1+mZvnqUt+BP+HHp3nZyj
         14N4wGPAxCUy4Q5qpoWeVRSYzb1O7tGFaGXK+ys3blTZmTA32aEGC0fjVWdhjv6SBr
         SA7PNFM3OGGXr7zUtEL6wDa248WYURapdfzYEjWe2eNlxOHXFNV9XAHmrivQfeHnZ3
         vw4p1wAkH18JQ==
Content-Disposition: inline
In-Reply-To: <20230401094708.77631-1-hanjinke.666@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666@bytedance.com>
Cc: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Apr 01, 2023 at 05:47:08PM +0800, Jinke Han wrote:
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
> Signed-off-by: Jinke Han <hanjinke.666@bytedance.com>

Thanks for fixing this!

The code looks correct to me, but this seems to report io statistics
only if at least one throttling limit is defined. IIRC with cgroup v1 it
was possible to see the io statistics inside a cgroup also with no
throttling limits configured.

Basically to restore the old behavior we would need to drop the
cgroup_subsys_on_dfl() check, something like the following (on top of
your patch).

But I'm not sure if we're breaking other behaviors in this way...
opinions?

 block/blk-cgroup.c   |  3 ---
 block/blk-throttle.h | 12 +++++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 79138bfc6001..43af86db7cf3 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2045,9 +2045,6 @@ void blk_cgroup_bio_start(struct bio *bio)
 	struct blkg_iostat_set *bis;
 	unsigned long flags;
 
-	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
-		return;
-
 	/* Root-level stats are sourced from system-wide IO stats */
 	if (!cgroup_parent(blkcg->css.cgroup))
 		return;
diff --git a/block/blk-throttle.h b/block/blk-throttle.h
index d1ccbfe9f797..bcb40ee2eeba 100644
--- a/block/blk-throttle.h
+++ b/block/blk-throttle.h
@@ -185,14 +185,12 @@ static inline bool blk_should_throtl(struct bio *bio)
 	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
 	int rw = bio_data_dir(bio);
 
-	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
-		if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
-			bio_set_flag(bio, BIO_CGROUP_ACCT);
-			blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
-					bio->bi_iter.bi_size);
-		}
-		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
+	if (!bio_flagged(bio, BIO_CGROUP_ACCT)) {
+		bio_set_flag(bio, BIO_CGROUP_ACCT);
+		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
+				bio->bi_iter.bi_size);
 	}
+	blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
 
 	/* iops limit is always counted */
 	if (tg->has_rules_iops[rw])

> ---
>  block/blk-cgroup.c   | 6 ++++--
>  block/blk-throttle.c | 6 ------
>  block/blk-throttle.h | 9 +++++++++
>  3 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index bd50b55bdb61..33263d0d0e0f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -2033,6 +2033,9 @@ void blk_cgroup_bio_start(struct bio *bio)
>  	struct blkg_iostat_set *bis;
>  	unsigned long flags;
>  
> +	if (!cgroup_subsys_on_dfl(io_cgrp_subsys))
> +		return;
> +
>  	/* Root-level stats are sourced from system-wide IO stats */
>  	if (!cgroup_parent(blkcg->css.cgroup))
>  		return;
> @@ -2064,8 +2067,7 @@ void blk_cgroup_bio_start(struct bio *bio)
>  	}
>  
>  	u64_stats_update_end_irqrestore(&bis->sync, flags);
> -	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
> -		cgroup_rstat_updated(blkcg->css.cgroup, cpu);
> +	cgroup_rstat_updated(blkcg->css.cgroup, cpu);
>  	put_cpu();
>  }
>  
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 47e9d8be68f3..2be66e9430f7 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -2174,12 +2174,6 @@ bool __blk_throtl_bio(struct bio *bio)
>  
>  	rcu_read_lock();
>  
> -	if (!cgroup_subsys_on_dfl(io_cgrp_subsys)) {
> -		blkg_rwstat_add(&tg->stat_bytes, bio->bi_opf,
> -				bio->bi_iter.bi_size);
> -		blkg_rwstat_add(&tg->stat_ios, bio->bi_opf, 1);
> -	}
> -
>  	spin_lock_irq(&q->queue_lock);
>  
>  	throtl_update_latency_buckets(td);
> diff --git a/block/blk-throttle.h b/block/blk-throttle.h
> index ef4b7a4de987..d1ccbfe9f797 100644
> --- a/block/blk-throttle.h
> +++ b/block/blk-throttle.h
> @@ -185,6 +185,15 @@ static inline bool blk_should_throtl(struct bio *bio)
>  	struct throtl_grp *tg = blkg_to_tg(bio->bi_blkg);
>  	int rw = bio_data_dir(bio);
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
>  	/* iops limit is always counted */
>  	if (tg->has_rules_iops[rw])
>  		return true;
> -- 
> 2.20.1
