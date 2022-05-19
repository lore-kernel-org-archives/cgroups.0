From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next 7/8] block, bfq: cleanup
 bfq_bfqq_update_budg_for_activation()
Date: Thu, 19 May 2022 13:18:56 +0200
Message-ID: <20220519111856.wvk4oetm7odnkg3w@quack3.lan>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-8-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652959137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlBHEoYBfb1KPuoHgDe8/xW0NmuRzgrxMjHDSq311m8=;
        b=lVsFJVjM95QAf8BtL2346JAPhSEU0ZwWFI66R9OjINDXQSXzGoBgpeOgojzS6pe9iJFQhk
        vMysbdethLL2TQnCDPjVo0QErCXwHGYaUz+A2RJ5GpzT16ASSsydPX6tsgGIG2GitRVZvO
        v+t8IfUpmda/FmG9Yn1DNTPfH/LYEZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652959137;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xlBHEoYBfb1KPuoHgDe8/xW0NmuRzgrxMjHDSq311m8=;
        b=/mxkD//r/VYRBbyN6BYdva8Vo/reEZ1vWzfK8sTnpO84rr7WI0znDyAtaqAyCfa5hBRXUW
        D1fISg9+R2VKrBCQ==
Content-Disposition: inline
In-Reply-To: <20220514090522.1669270-8-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat 14-05-22 17:05:21, Yu Kuai wrote:
> It will only be called from bfq_bfqq_handle_idle_busy_switch() in
> specific code branch, there is no need to precaculate
> 'bfqq_wants_to_preempt' each time bfq_bfqq_handle_idle_busy_switch()
> is caleld.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Please see below:

> @@ -1816,14 +1807,6 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
>  		  (bfqq->bic || RQ_BIC(rq)->stably_merged) &&
>  		   (*interactive || soft_rt)));
>  
> -	/*
> -	 * Using the last flag, update budget and check whether bfqq
> -	 * may want to preempt the in-service queue.
> -	 */
> -	bfqq_wants_to_preempt =
> -		bfq_bfqq_update_budg_for_activation(bfqd, bfqq,
> -						    arrived_in_time);
> -
>  	/*
>  	 * If bfqq happened to be activated in a burst, but has been
>  	 * idle for much more than an interactive queue, then we
...
> @@ -1918,7 +1900,7 @@ static void bfq_bfqq_handle_idle_busy_switch(struct bfq_data *bfqd,
>  	 * (2) this switch of bfqq to busy changes the scenario.
>  	 */
>  	if (bfqd->in_service_queue &&
> -	    ((bfqq_wants_to_preempt &&
> +	    ((bfq_bfqq_update_budg_for_activation(bfqd, bfqq) &&
>  	      bfqq->wr_coeff >= bfqd->in_service_queue->wr_coeff) ||
>  	     bfq_bfqq_higher_class_or_weight(bfqq, bfqd->in_service_queue) ||
>  	     !bfq_better_to_idle(bfqd->in_service_queue)) &&

So these changes are actually wrong because
bfq_bfqq_update_budg_for_activation() relies on
bfq_bfqq_non_blocking_wait_rq() but bfq_add_bfqq_busy() clears that. And
bfq_add_bfqq_busy() is called between the place where
bfq_bfqq_update_budg_for_activation() was called previously and now so your
patch breaks this logic.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
