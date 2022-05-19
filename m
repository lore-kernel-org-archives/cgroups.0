From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next 5/8] block, bfq: cleanup
 bfq_activate_requeue_entity()
Date: Thu, 19 May 2022 13:06:01 +0200
Message-ID: <20220519110601.vols2d4npm4pgvns@quack3.lan>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-6-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652958361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G691x8yrwjJK70XDCvEA+7NWlNJBNJSIMk+vjCwj6r4=;
        b=ffZsclxTGiPP66jx++30qK5ygHGXciw8DGTfMja+vtpK158/OzQ4uBR/+DPnSyLhif48hS
        azrAU86BygC16PEvrlGj7akvR2SzoqicB8rh36lOWcqB3IXCh9X1UIQMh+LySH1Rb4YaL4
        EDcnbTW+EcAg3mCIpkvWuRF8RHkRVpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652958361;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G691x8yrwjJK70XDCvEA+7NWlNJBNJSIMk+vjCwj6r4=;
        b=SSG3nh7xh6zpmisj7ikCyh/AqNy4rdasR0c0EwwIHpxze4mbx6Jno9Lc+17/F1NSr4NemN
        lFfmThT4xUi1sYAw==
Content-Disposition: inline
In-Reply-To: <20220514090522.1669270-6-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Sat 14-05-22 17:05:19, Yu Kuai wrote:
> Just make the code a litter cleaner by removing the unnecessary
> variable 'sd'.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

OK. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-wf2q.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index 15b97687493a..da189c732376 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -1085,12 +1085,12 @@ static void __bfq_requeue_entity(struct bfq_entity *entity)
>  }
>  
>  static void __bfq_activate_requeue_entity(struct bfq_entity *entity,
> -					  struct bfq_sched_data *sd,
>  					  bool non_blocking_wait_rq)
>  {
>  	struct bfq_service_tree *st = bfq_entity_service_tree(entity);
>  
> -	if (sd->in_service_entity == entity || entity->tree == &st->active)
> +	if (entity->sched_data->in_service_entity == entity ||
> +	    entity->tree == &st->active)
>  		 /*
>  		  * in service or already queued on the active tree,
>  		  * requeue or reposition
> @@ -1122,14 +1122,10 @@ static void bfq_activate_requeue_entity(struct bfq_entity *entity,
>  					bool non_blocking_wait_rq,
>  					bool requeue, bool expiration)
>  {
> -	struct bfq_sched_data *sd;
> -
>  	for_each_entity(entity) {
> -		sd = entity->sched_data;
> -		__bfq_activate_requeue_entity(entity, sd, non_blocking_wait_rq);
> -
> -		if (!bfq_update_next_in_service(sd, entity, expiration) &&
> -		    !requeue)
> +		__bfq_activate_requeue_entity(entity, non_blocking_wait_rq);
> +		if (!bfq_update_next_in_service(entity->sched_data, entity,
> +						expiration) && !requeue)
>  			break;
>  	}
>  }
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
