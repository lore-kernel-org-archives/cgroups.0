From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] block, bfq: cleanup bfq_bfqq_to_bfqg()
Date: Tue, 21 Dec 2021 11:15:17 +0100
Message-ID: <20211221101517.GA24748@quack2.suse.cz>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640081717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tw4XdfqKEnDXFIq4KJAkTaIZVJn1UjG86AxtNcsugP8=;
        b=Hjyte8ENHdsPrBGaVKpNFn1mwcPxGe7gGmzQMk577eS/xg7Pz8BF7k5gk9VW2Sck6Eq61M
        A6fT0Z6/hDxsTH4hAJdSSOKKZez+Hyn+fY03LdgZdjsuEArzOZYvCTAGFiwCzVGI68RGuw
        aNqrAysr/+N8GWNpt7852Prl0Wd4DSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640081717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Tw4XdfqKEnDXFIq4KJAkTaIZVJn1UjG86AxtNcsugP8=;
        b=/iFnvAG4RtesCazLS7MFQDjGh3UnSiR0emxt3HUEhp0xgT6K6zgWlDSxErALSjimAWHqOo
        WfH9FJNrpG9+C8BA==
Content-Disposition: inline
In-Reply-To: <20211221032135.878550-2-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, paolo.valente@linaro.org, jack@suse.cz, fchecconi@gmail.com, avanzini.arianna@gmail.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Tue 21-12-21 11:21:32, Yu Kuai wrote:
> Use bfq_group() instead, which do the same thing.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Nice. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-iosched.c |  4 ++--
>  block/bfq-iosched.h |  1 -
>  block/bfq-wf2q.c    | 15 ---------------
>  3 files changed, 2 insertions(+), 18 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0c612a911696..2f2b97cad980 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -774,7 +774,7 @@ bfq_pos_tree_add_move(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>  	if (!bfqq->next_rq)
>  		return;
>  
> -	bfqq->pos_root = &bfq_bfqq_to_bfqg(bfqq)->rq_pos_tree;
> +	bfqq->pos_root = &bfqq_group(bfqq)->rq_pos_tree;
>  	__bfqq = bfq_rq_pos_tree_lookup(bfqd, bfqq->pos_root,
>  			blk_rq_pos(bfqq->next_rq), &parent, &p);
>  	if (!__bfqq) {
> @@ -2669,7 +2669,7 @@ static struct bfq_queue *bfqq_find_close(struct bfq_data *bfqd,
>  					 struct bfq_queue *bfqq,
>  					 sector_t sector)
>  {
> -	struct rb_root *root = &bfq_bfqq_to_bfqg(bfqq)->rq_pos_tree;
> +	struct rb_root *root = &bfqq_group(bfqq)->rq_pos_tree;
>  	struct rb_node *parent, *node;
>  	struct bfq_queue *__bfqq;
>  
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 07288b9da389..99949548896e 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -1051,7 +1051,6 @@ extern struct blkcg_policy blkcg_policy_bfq;
>  	for (parent = NULL; entity ; entity = parent)
>  #endif /* CONFIG_BFQ_GROUP_IOSCHED */
>  
> -struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq);
>  struct bfq_queue *bfq_entity_to_bfqq(struct bfq_entity *entity);
>  unsigned int bfq_tot_busy_queues(struct bfq_data *bfqd);
>  struct bfq_service_tree *bfq_entity_service_tree(struct bfq_entity *entity);
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index b74cc0da118e..e1f5ca5c1fdb 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -142,16 +142,6 @@ static bool bfq_update_next_in_service(struct bfq_sched_data *sd,
>  
>  #ifdef CONFIG_BFQ_GROUP_IOSCHED
>  
> -struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq)
> -{
> -	struct bfq_entity *group_entity = bfqq->entity.parent;
> -
> -	if (!group_entity)
> -		group_entity = &bfqq->bfqd->root_group->entity;
> -
> -	return container_of(group_entity, struct bfq_group, entity);
> -}
> -
>  /*
>   * Returns true if this budget changes may let next_in_service->parent
>   * become the next_in_service entity for its parent entity.
> @@ -230,11 +220,6 @@ static bool bfq_no_longer_next_in_service(struct bfq_entity *entity)
>  
>  #else /* CONFIG_BFQ_GROUP_IOSCHED */
>  
> -struct bfq_group *bfq_bfqq_to_bfqg(struct bfq_queue *bfqq)
> -{
> -	return bfqq->bfqd->root_group;
> -}
> -
>  static bool bfq_update_parent_budget(struct bfq_entity *next_in_service)
>  {
>  	return false;
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
