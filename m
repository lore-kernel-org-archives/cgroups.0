From: Andreas Herrmann <aherrmann@suse.de>
Subject: Re: [PATCH 01/15] blk-cgroup: don't defer blkg_free to a workqueue
Date: Fri, 20 Jan 2023 09:54:27 +0100
Message-ID: <Y8pWw3JGAh0olxBp@suselix>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-2-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674204869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QuC6EoxQ4hc8vHSLJ5TANMxoXRQ/KJ+BoF6V1R8R+Q=;
        b=wfzYjETl0eSPnWzDeUhCgwd7MFHL6Zq2+3rV3B3vstHYF/RKsAeGV0knGV7W52L9MqcuGP
        JJj6RVthgdWIvYGOLGEvvy3KeqA9VOHUhWo4FqQjLeW2zHLcNe5d27a0Zm0J0eeE94W2CR
        nQzc6yvTYeLY24WDVwKP5eiuftyanuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674204869;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5QuC6EoxQ4hc8vHSLJ5TANMxoXRQ/KJ+BoF6V1R8R+Q=;
        b=I61ICZaKx514MlB9T1yJylPrN3JxBItqqZmAXlAtNDeKec02MCH9hHjVXWI2xdoJYSsfZJ
        HTG/GIrvPzBUbvDw==
Content-Disposition: inline
In-Reply-To: <20230117081257.3089859-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org

On Tue, Jan 17, 2023 at 09:12:43AM +0100, Christoph Hellwig wrote:
> Now that blk_put_queue can be called from process context, ther is no
                                                             ^^^^
							     there
> need for the asynchronous execution.
> 
> This effectively reverts commit d578c770c85233af592e54537f93f3831bde7e9a.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-cgroup.c | 32 ++++++++++----------------------
>  block/blk-cgroup.h |  5 +----
>  2 files changed, 11 insertions(+), 26 deletions(-)

Looks good to me. Feel free to add
Reviewed-by: Andreas Herrmann <aherrmann@suse.de>

> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index ce6a2b7d3dfb2b..30d493b43f9272 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -114,12 +114,19 @@ static bool blkcg_policy_enabled(struct request_queue *q,
>  	return pol && test_bit(pol->plid, q->blkcg_pols);
>  }
>  
> -static void blkg_free_workfn(struct work_struct *work)
> +/**
> + * blkg_free - free a blkg
> + * @blkg: blkg to free
> + *
> + * Free @blkg which may be partially allocated.
> + */
> +static void blkg_free(struct blkcg_gq *blkg)
>  {
> -	struct blkcg_gq *blkg = container_of(work, struct blkcg_gq,
> -					     free_work);
>  	int i;
>  
> +	if (!blkg)
> +		return;
> +
>  	for (i = 0; i < BLKCG_MAX_POLS; i++)
>  		if (blkg->pd[i])
>  			blkcg_policy[i]->pd_free_fn(blkg->pd[i]);
> @@ -131,25 +138,6 @@ static void blkg_free_workfn(struct work_struct *work)
>  	kfree(blkg);
>  }
>  
> -/**
> - * blkg_free - free a blkg
> - * @blkg: blkg to free
> - *
> - * Free @blkg which may be partially allocated.
> - */
> -static void blkg_free(struct blkcg_gq *blkg)
> -{
> -	if (!blkg)
> -		return;
> -
> -	/*
> -	 * Both ->pd_free_fn() and request queue's release handler may
> -	 * sleep, so free us by scheduling one work func
> -	 */
> -	INIT_WORK(&blkg->free_work, blkg_free_workfn);
> -	schedule_work(&blkg->free_work);
> -}
> -
>  static void __blkg_release(struct rcu_head *rcu)
>  {
>  	struct blkcg_gq *blkg = container_of(rcu, struct blkcg_gq, rcu_head);
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index 1e94e404eaa80a..f126fe36001eb3 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -75,10 +75,7 @@ struct blkcg_gq {
>  
>  	spinlock_t			async_bio_lock;
>  	struct bio_list			async_bios;
> -	union {
> -		struct work_struct	async_bio_work;
> -		struct work_struct	free_work;
> -	};
> +	struct work_struct		async_bio_work;
>  
>  	atomic_t			use_delay;
>  	atomic64_t			delay_nsec;
> -- 
> 2.39.0
> 

-- 
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Frankenstrasse 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
(HRB 36809, AG Nürnberg)
