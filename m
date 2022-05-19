From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next 2/8] block, bfq: cleanup __bfq_weights_tree_remove()
Date: Thu, 19 May 2022 13:02:04 +0200
Message-ID: <20220519110204.yf7j65ko5wnmsojr@quack3.lan>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652958125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5tCaNooOkaDcvcv6PCUEW0LqLLKKJTw0gD9Hod1PSGA=;
        b=1AiKxwZkumz5PQU0f03qy83y6g+kaSp+rGayk8zPMusm3N8Wdr/Q5KAlIayTsDOHtQJPH8
        b5Mb+PVSU43rt0QjCZH64AALhnVKpruOI/vz502lYVcgXJbK7vy3ljTXl9+7hviIGhymnY
        cS7rxy71rZRO+ulqb/iKevjdCJiLGtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652958125;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5tCaNooOkaDcvcv6PCUEW0LqLLKKJTw0gD9Hod1PSGA=;
        b=ROQdBvocG9Mar1VWAg+leJDJ6t6pHEeG84adMFhXpkyUIVsCK7E/LIDZnFXI2HL6hoxVCF
        oy43O/3EKigTscDA==
Content-Disposition: inline
In-Reply-To: <20220514090522.1669270-3-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Sat 14-05-22 17:05:16, Yu Kuai wrote:
> It's the same with bfq_weights_tree_remove() now.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-iosched.c | 13 +------------
>  block/bfq-iosched.h |  1 -
>  block/bfq-wf2q.c    |  2 +-
>  3 files changed, 2 insertions(+), 14 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index bcbe78d71143..1d0141c450c0 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -944,8 +944,7 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>   * See the comments to the function bfq_weights_tree_add() for considerations
>   * about overhead.
>   */
> -void __bfq_weights_tree_remove(struct bfq_data *bfqd,
> -			       struct bfq_queue *bfqq)
> +void bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>  {
>  	struct rb_root_cached *root;
>  	if (!bfqq->weight_counter)
> @@ -964,16 +963,6 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd,
>  	bfq_put_queue(bfqq);
>  }
>  
> -/*
> - * Invoke __bfq_weights_tree_remove on bfqq and decrement the number
> - * of active groups for each queue's inactive parent entity.
> - */
> -void bfq_weights_tree_remove(struct bfq_data *bfqd,
> -			     struct bfq_queue *bfqq)
> -{
> -	__bfq_weights_tree_remove(bfqd, bfqq);
> -}
> -
>  /*
>   * Return expired entry, or NULL to just start from scratch in rbtree.
>   */
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 0a3415abb994..bc54b9824b1e 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -933,7 +933,6 @@ void bic_set_bfqq(struct bfq_io_cq *bic, struct bfq_queue *bfqq, bool is_sync);
>  struct bfq_data *bic_to_bfqd(struct bfq_io_cq *bic);
>  void bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq);
>  void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq);
> -void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq);
>  void bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq);
>  void bfq_bfqq_expire(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		     bool compensate, enum bfqq_expiration reason);
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index ccd227fed1c3..2f3fb45a32c3 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -790,7 +790,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
>  		 * there is a counter associated with the entity).
>  		 */
>  		if (prev_weight != new_weight && bfqq)
> -			__bfq_weights_tree_remove(bfqd, bfqq);
> +			bfq_weights_tree_remove(bfqd, bfqq);
>  		entity->weight = new_weight;
>  		/*
>  		 * Add the entity, if it is not a weight-raised queue,
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
