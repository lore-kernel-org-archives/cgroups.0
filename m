From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next v8 1/4] block, bfq: support to track if bfqq has
 pending requests
Date: Wed, 1 Jun 2022 10:31:54 +0200
Message-ID: <20220601083154.5ip7r6w7kjb3bof2@quack3.lan>
References: <20220531140858.3324294-1-yukuai3@huawei.com>
 <20220531140858.3324294-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654072318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N+sBqa5KqKk9l80H2r4a0EQswvDm6hf4uMYYGP+soqU=;
        b=UxNmGl10x6Mtb4IZHTscIz8gWRW6HgF7JeSkIFA3/SMZ5MwO0itfPzFfdXeKigeq6uDjFv
        4bN0nY9B+vKQGrWWuPqxBwF5Z497j6B5lQghIy91xnE+J+DE61r32CWreN75yDmIIi/rxx
        YqGgm/bp0Nehl08MPwXkSt/rXYKsbtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654072318;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N+sBqa5KqKk9l80H2r4a0EQswvDm6hf4uMYYGP+soqU=;
        b=Vs/bVFe2dUMiW8BMd3aoA58GmzvJhI2Br3qV3wc/S6BZRK+F80A/62NZGf4xz6rrZK0LnZ
        x5Ym+gWftWBAPUBA==
Content-Disposition: inline
In-Reply-To: <20220531140858.3324294-2-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: paolo.valente@linaro.org, jack@suse.cz, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Tue 31-05-22 22:08:55, Yu Kuai wrote:
> If entity belongs to bfqq, then entity->in_groups_with_pending_reqs
> is not used currently. This patch use it to track if bfqq has pending
> requests through callers of weights_tree insertion and removal.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-iosched.c |  1 +
>  block/bfq-iosched.h |  1 +
>  block/bfq-wf2q.c    | 24 ++++++++++++++++++++++--
>  3 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0d46cb728bbf..0ec21018daba 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -6263,6 +6263,7 @@ static void bfq_completed_request(struct bfq_queue *bfqq, struct bfq_data *bfqd)
>  		 */
>  		bfqq->budget_timeout = jiffies;
>  
> +		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
>  		bfq_weights_tree_remove(bfqd, bfqq);
>  	}
>  
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index ca8177d7bf7c..3b9b1a0e7c1c 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -1080,6 +1080,7 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		       bool expiration);
>  void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq);
> +void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq);
>  
>  /* --------------- end of interface of B-WF2Q+ ---------------- */
>  
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index f8eb340381cf..12d20f26ad69 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -1647,6 +1647,22 @@ void bfq_requeue_bfqq(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  				    bfqq == bfqd->in_service_queue, expiration);
>  }
>  
> +static void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
> +{
> +	struct bfq_entity *entity = &bfqq->entity;
> +
> +	if (!entity->in_groups_with_pending_reqs)
> +		entity->in_groups_with_pending_reqs = true;
> +}
> +
> +void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
> +{
> +	struct bfq_entity *entity = &bfqq->entity;
> +
> +	if (entity->in_groups_with_pending_reqs)
> +		entity->in_groups_with_pending_reqs = false;
> +}
> +
>  /*
>   * Called when the bfqq no longer has requests pending, remove it from
>   * the service tree. As a special case, it can be invoked during an
> @@ -1668,8 +1684,10 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  
>  	bfq_deactivate_bfqq(bfqd, bfqq, true, expiration);
>  
> -	if (!bfqq->dispatched)
> +	if (!bfqq->dispatched) {
> +		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
>  		bfq_weights_tree_remove(bfqd, bfqq);
> +	}
>  }
>  
>  /*
> @@ -1684,10 +1702,12 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>  	bfq_mark_bfqq_busy(bfqq);
>  	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
>  
> -	if (!bfqq->dispatched)
> +	if (!bfqq->dispatched) {
> +		bfq_add_bfqq_in_groups_with_pending_reqs(bfqq);
>  		if (bfqq->wr_coeff == 1)
>  			bfq_weights_tree_add(bfqd, bfqq,
>  					     &bfqd->queue_weights_tree);
> +	}
>  
>  	if (bfqq->wr_coeff > 1)
>  		bfqd->wr_busy_queues++;
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
