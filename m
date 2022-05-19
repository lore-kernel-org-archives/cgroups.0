From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next 4/8] block, bfq: don't declare 'bfqd' as type 'void
 *' in bfq_group
Date: Thu, 19 May 2022 13:01:32 +0200
Message-ID: <20220519110132.g2hpugtzbfhxpfiv@quack3.lan>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-5-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652958092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d2LJTHb7bIL86JRNxFoPv0Vzh38Dtv/r3lFZcMZIkjA=;
        b=mi5Ln/NvtJgbrqgbuHpDqWsAGcT/ERt1PK5gyJc4Ao31t1MabjZ6YdvkSXA3X8aK4uaq6b
        Mn7IJ9dnrJTykEm5foEY+fXFin+P/SGrPqSo3VnuK0A3zzUcpSfFbaWswU1SwP0a6ehy5f
        XFczdxyoJYcQq18kSGohsLvsR37deUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652958092;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d2LJTHb7bIL86JRNxFoPv0Vzh38Dtv/r3lFZcMZIkjA=;
        b=XCHwI9V7L9qFZa1vtjV1bfZs/BBA1lOkhFJV64b5O9a/FiJlpfsg1XeyjbCaORk9nBra+N
        zYHuKYeOf2fMktCA==
Content-Disposition: inline
In-Reply-To: <20220514090522.1669270-5-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Sat 14-05-22 17:05:18, Yu Kuai wrote:
> Prevent unnecessary format conversion for bfqg->bfqd in multiple
> places.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Yeah, this was annoying me as well :) Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-cgroup.c  | 2 +-
>  block/bfq-iosched.h | 2 +-
>  block/bfq-wf2q.c    | 8 +++-----
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 4d516879d9fa..b4e39ab4ad17 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -224,7 +224,7 @@ void bfqg_stats_update_io_add(struct bfq_group *bfqg, struct bfq_queue *bfqq,
>  {
>  	blkg_rwstat_add(&bfqg->stats.queued, op, 1);
>  	bfqg_stats_end_empty_time(&bfqg->stats);
> -	if (!(bfqq == ((struct bfq_data *)bfqg->bfqd)->in_service_queue))
> +	if (!(bfqq == bfqg->bfqd->in_service_queue))
>  		bfqg_stats_set_start_group_wait_time(bfqg, bfqq_group(bfqq));
>  }
>  
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index bc54b9824b1e..d57e4848f57f 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -894,7 +894,7 @@ struct bfq_group {
>  	struct bfq_entity entity;
>  	struct bfq_sched_data sched_data;
>  
> -	void *bfqd;
> +	struct bfq_data *bfqd;
>  
>  	struct bfq_queue *async_bfqq[2][IOPRIO_NR_LEVELS];
>  	struct bfq_queue *async_idle_bfqq;
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index c58568a4b009..15b97687493a 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -234,9 +234,8 @@ static void bfq_inc_active_entities(struct bfq_entity *entity)
>  {
>  	struct bfq_sched_data *sd = entity->sched_data;
>  	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
> -	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
>  
> -	if (bfqg != bfqd->root_group)
> +	if (bfqg != bfqg->bfqd->root_group)
>  		bfqg->active_entities++;
>  }
>  
> @@ -244,9 +243,8 @@ static void bfq_dec_active_entities(struct bfq_entity *entity)
>  {
>  	struct bfq_sched_data *sd = entity->sched_data;
>  	struct bfq_group *bfqg = container_of(sd, struct bfq_group, sched_data);
> -	struct bfq_data *bfqd = (struct bfq_data *)bfqg->bfqd;
>  
> -	if (bfqg != bfqd->root_group)
> +	if (bfqg != bfqg->bfqd->root_group)
>  		bfqg->active_entities--;
>  }
>  
> @@ -741,7 +739,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
>  		else {
>  			sd = entity->my_sched_data;
>  			bfqg = container_of(sd, struct bfq_group, sched_data);
> -			bfqd = (struct bfq_data *)bfqg->bfqd;
> +			bfqd = bfqg->bfqd;
>  		}
>  #endif
>  
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
