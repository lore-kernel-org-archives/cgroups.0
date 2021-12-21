From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/4] block, bfq: update pos_root for idle bfq_queue in
 bfq_bfqq_move()
Date: Tue, 21 Dec 2021 12:50:01 +0100
Message-ID: <20211221115001.GD24748@quack2.suse.cz>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-5-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640087401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X2yJGv6PwZm+h69bbWkMgkF4JmLNrbjM8paByqi7U7s=;
        b=Ldra7s7/Icdw9g8CqDMD3k3J3YgK4h6W7Qje+x/Ww9btS1KinZLnrOEVjzvErpZKzO/VUw
        X+HcP7Kq5ZJp6wKuExHsWxy7hE1bu5VIKC/0geH8VJ/BrmYaNd1q4siTHvgr7b4vNXm28j
        sx5B0TPLBkLYMOQlRVgOv5ekBjuvwZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640087401;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X2yJGv6PwZm+h69bbWkMgkF4JmLNrbjM8paByqi7U7s=;
        b=2GsGrTbs8ZAXcwBiofE2gvBx/6TAWxMhJc3fTTPTvOzF0jU7NxZ8+ePErKlD9OEeTnvDF8
        IkLTLI/AhTf/M6Bw==
Content-Disposition: inline
In-Reply-To: <20211221032135.878550-5-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue 21-12-21 11:21:35, Yu Kuai wrote:
> During code review, we found that if bfqq is not busy in
> bfq_bfqq_move(), bfq_pos_tree_add_move() won't be called for the bfqq,
> thus bfqq->pos_root still points to the old bfqg. However, the ref
> that bfqq hold for the old bfqg will be released, so it's possible
> that the old bfqg can be freed. This is problematic because the freed
> bfqg can still be accessed by bfqq->pos_root.
> 
> Fix the problem by calling bfq_pos_tree_add_move() for idle bfqq
> as well.
> 
> Fixes: e21b7a0b9887 ("block, bfq: add full hierarchical scheduling and cgroups support")
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

I'm just wondering, how can it happen that !bfq_bfqq_busy() queue is in
pos_tree? Because bfq_remove_request() takes care to remove bfqq from the
pos_tree...

								Honza

> ---
>  block/bfq-cgroup.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 8e8cf6b3d946..822dd28ecf53 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -677,7 +677,6 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
>  	else if (entity->on_st_or_in_serv)
>  		bfq_put_idle_entity(bfq_entity_service_tree(entity), entity);
> -	bfqg_and_blkg_put(old_parent);
>  
>  	if (entity->parent &&
>  	    entity->parent->last_bfqq_created == bfqq)
> @@ -690,11 +689,16 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  	/* pin down bfqg and its associated blkg  */
>  	bfqg_and_blkg_get(bfqg);
>  
> -	if (bfq_bfqq_busy(bfqq)) {
> -		if (unlikely(!bfqd->nonrot_with_queueing))
> -			bfq_pos_tree_add_move(bfqd, bfqq);
> +	/*
> +	 * Don't leave the pos_root to old bfqg, since the ref to old bfqg will
> +	 * be released and the bfqg might be freed.
> +	 */
> +	if (unlikely(!bfqd->nonrot_with_queueing))
> +		bfq_pos_tree_add_move(bfqd, bfqq);
> +	bfqg_and_blkg_put(old_parent);
> +
> +	if (bfq_bfqq_busy(bfqq))
>  		bfq_activate_bfqq(bfqd, bfqq);
> -	}
>  
>  	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
>  		bfq_schedule_dispatch(bfqd);
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
