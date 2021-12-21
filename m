From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/4] block, bfq: avoid moving bfqq to it's parent bfqg
Date: Tue, 21 Dec 2021 11:16:59 +0100
Message-ID: <20211221101659.GB24748@quack2.suse.cz>
References: <20211221032135.878550-1-yukuai3@huawei.com>
 <20211221032135.878550-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640081819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DwlLWjduFMONq98dJAYAgeIdej/YjReYCrkxEXLrVeA=;
        b=gTM2jBePOjSM4DDR4GxbKx29ve2KrQJ/s6U6GOPwbNhu/MovBndTVqvLoiJhslnliZDvRP
        id/HKrlPLQxnxYP+Kk3Jdc1ZfeoeUIA9i+7NiEGE9oE3VYYovO9Egtc0Xjt76+rc3Ccefu
        fSKCI6wX5T38bhTNJrEkHgPpk6qlQ1Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640081819;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DwlLWjduFMONq98dJAYAgeIdej/YjReYCrkxEXLrVeA=;
        b=EFBZzDXhptWBR7NjK8IO6gJJwX6pwu7jcO4h2NUDvhHwr4Pc3I537H7C3jdEdxNWz7N7oj
        eSd0GrSYrlNPueDA==
Content-Disposition: inline
In-Reply-To: <20211221032135.878550-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue 21-12-21 11:21:33, Yu Kuai wrote:
> Moving bfqq to it's parent bfqg is pointless.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Did you notice that this is happening often enough that the check is worth
it? Where do we do this?

								Honza

> ---
>  block/bfq-cgroup.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
> index 24a5c5329bcd..0f62546a72d4 100644
> --- a/block/bfq-cgroup.c
> +++ b/block/bfq-cgroup.c
> @@ -645,6 +645,11 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		   struct bfq_group *bfqg)
>  {
>  	struct bfq_entity *entity = &bfqq->entity;
> +	struct bfq_group *old_parent = bfq_group(bfqq);
> +
> +	/* No point to move bfqq to the same group */
> +	if (old_parent == bfqg)
> +		return;
>  
>  	/*
>  	 * Get extra reference to prevent bfqq from being freed in
> @@ -666,7 +671,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>  		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
>  	else if (entity->on_st_or_in_serv)
>  		bfq_put_idle_entity(bfq_entity_service_tree(entity), entity);
> -	bfqg_and_blkg_put(bfqq_group(bfqq));
> +	bfqg_and_blkg_put(old_parent);
>  
>  	if (entity->parent &&
>  	    entity->parent->last_bfqq_created == bfqq)
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
