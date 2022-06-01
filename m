From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v9 2/4] block, bfq: record how many queues have
 pending requests
Date: Wed, 1 Jun 2022 15:18:06 +0200
Message-ID: <20220601131806.gs3txjgvhhbn5ign@quack3.lan>
References: <20220601114340.949953-1-yukuai3@huawei.com>
 <20220601114340.949953-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654089492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XlDIaOdMh++5TaTNkEqP7Z+0BP2y4tj9ghae6D/SYZ4=;
        b=gJ8P+L0egLun2U4orfffIleneGyLzcb0nvFFjoIh9nX10gj0nf00pmZSEv7YCtWpP+fP8X
        OBT5DAF02ElKH6ruRtP0Xb8moMWhZARCbVHKNqDeGHN9gOa50OaJ1r5ZZIApuzRIhvjsHK
        X1blH5INrkMj3wfNgfME6dveXH5usdI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654089492;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XlDIaOdMh++5TaTNkEqP7Z+0BP2y4tj9ghae6D/SYZ4=;
        b=vbc5jBV9j8HjUhgDLh7LRZCB2EFp6umMm1CuQgzSicrmsinShWGcQ0bcPnTa+JPEuYBwgE
        rWIVMANGhGgQjIAg==
Content-Disposition: inline
In-Reply-To: <20220601114340.949953-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed 01-06-22 19:43:38, Yu Kuai wrote:
> Prepare to refactor the counting of 'num_groups_with_pending_reqs'.
> 
> Add a counter in bfq_group, update it while tracking if bfqq have pending
> requests and when bfq_bfqq_move() is called.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza


> ---
>  block/bfq-cgroup.c  | 10 ++++++++++
>  block/bfq-iosched.h |  1 +
>  block/bfq-wf2q.c    | 12 ++++++++++--
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 09574af83566..88c0c320ddf3 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -557,6 +557,7 @@ static void bfq_pd_init(struct blkg_policy_data *pd)
>  				   */
>  	bfqg->bfqd = bfqd;
>  	bfqg->active_entities = 0;
> +	bfqg->num_queues_with_pending_reqs = 0;
>  	bfqg->online = true;
>  	bfqg->rq_pos_tree = RB_ROOT;
>  }
> @@ -646,6 +647,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  {
>  	struct bfq_entity *entity = &bfqq->entity;
>  	struct bfq_group *old_parent = bfqq_group(bfqq);
> +	bool has_pending_reqs = false;
>  
>  	/*
>  	 * No point to move bfqq to the same group, which can happen when
> @@ -666,6 +668,11 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  	 */
>  	bfqq->ref++;
>  
> +	if (entity->in_groups_with_pending_reqs) {
> +		has_pending_reqs = true;
> +		bfq_del_bfqq_in_groups_with_pending_reqs(bfqq);
> +	}
> +
>  	/* If bfqq is empty, then bfq_bfqq_expire also invokes
>  	 * bfq_del_bfqq_busy, thereby removing bfqq and its entity
>  	 * from data structures related to current group. Otherwise we
> @@ -693,6 +700,9 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  	/* pin down bfqg and its associated blkg  */
>  	bfqg_and_blkg_get(bfqg);
>  
> +	if (has_pending_reqs)
> +		bfq_add_bfqq_in_groups_with_pending_reqs(bfqq);
> +
>  	if (bfq_bfqq_busy(bfqq)) {
>  		if (unlikely(!bfqd->nonrot_with_queueing))
>  			bfq_pos_tree_add_move(bfqd, bfqq);
> diff --git a/block/bfq-iosched.h b/block/bfq-iosched.h
> index 69c7d15417e5..de2446a9b7ab 100644
> --- a/block/bfq-iosched.h
> +++ b/block/bfq-iosched.h
> @@ -943,6 +943,7 @@ struct bfq_group {
>  	struct bfq_entity *my_entity;
>  
>  	int active_entities;
> +	int num_queues_with_pending_reqs;
>  
>  	struct rb_root rq_pos_tree;
>  
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index 5704a0315cf2..6f36f3fe5cc8 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -1651,16 +1651,24 @@ void bfq_add_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
>  {
>  	struct bfq_entity *entity = &bfqq->entity;
>  
> -	if (!entity->in_groups_with_pending_reqs)
> +	if (!entity->in_groups_with_pending_reqs) {
>  		entity->in_groups_with_pending_reqs = true;
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +		bfqq_group(bfqq)->num_queues_with_pending_reqs++;
> +#endif
> +	}
>  }
>  
>  void bfq_del_bfqq_in_groups_with_pending_reqs(struct bfq_queue *bfqq)
>  {
>  	struct bfq_entity *entity = &bfqq->entity;
>  
> -	if (entity->in_groups_with_pending_reqs)
> +	if (entity->in_groups_with_pending_reqs) {
>  		entity->in_groups_with_pending_reqs = false;
> +#ifdef CONFIG_BFQ_GROUP_IOSCHED
> +		bfqq_group(bfqq)->num_queues_with_pending_reqs--;
> +#endif
> +	}
>  }
>  
>  /*
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
