From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next v2 2/5] block, bfq: add fake weight_counter for
 weight-raised queue
Date: Mon, 25 Apr 2022 11:48:56 +0200
Message-ID: <20220425094856.qgkhba2klguduxot@quack3.lan>
References: <20220416093753.3054696-1-yukuai3@huawei.com>
 <20220416093753.3054696-3-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1650880138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n215KfJqkHmi9Mmq49cvfsGZ/OiTnyFPqnXnfcZ0qHY=;
        b=O/h/zQi9hrK066WJ3e/N9k1cERZXJmAywDnFMxEiP/8Ak03zf50M/34yUDFj/yA9dnVuBk
        nL7KAymiXMDyRs7i50snJXCrvxf+/6Tk/J1Xq/httxDAlHAA4cNdV1CANpR6A8yi9VgEvZ
        giGifkoxTEp0tgjkAc2mhyTZCLBW9d8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1650880138;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n215KfJqkHmi9Mmq49cvfsGZ/OiTnyFPqnXnfcZ0qHY=;
        b=KMXPa11Mj9t2r011fFWDg6Gvp9XR7amRkx+PRp8NltpciOjYcX8dTBsaT6kfNYVav2Axfh
        4o0CKWG1qJ+KOaCQ==
Content-Disposition: inline
In-Reply-To: <20220416093753.3054696-3-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat 16-04-22 17:37:50, Yu Kuai wrote:
> Weight-raised queue is not inserted to weights_tree, which makes it
> impossible to track how many queues have pending requests through
> weights_tree insertion and removel. This patch add fake weight_counter
> for weight-raised queue to do that.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

This is a bit hacky. I was looking into a better place where to hook to
count entities in a bfq_group with requests and I think bfq_add_bfqq_busy()
and bfq_del_bfqq_busy() are ideal for this. It also makes better sense
conceptually than hooking into weights tree handling.

Other than this the rest of the series looks fine to me.

								Honza

> ---
>  block/bfq-iosched.c | 11 +++++++++++
>  block/bfq-wf2q.c    |  5 ++---
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 2deea2d07a1f..a2977c938c70 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -134,6 +134,8 @@
>  #include "bfq-iosched.h"
>  #include "blk-wbt.h"
>  
> +#define BFQ_FAKE_WEIGHT_COUNTER ((void *) POISON_INUSE)
> +
>  #define BFQ_BFQQ_FNS(name)						\
>  void bfq_mark_bfqq_##name(struct bfq_queue *bfqq)			\
>  {									\
> @@ -884,6 +886,12 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>  	if (bfqq->weight_counter)
>  		return;
>  
> +	if (bfqq->wr_coeff != 1) {
> +		bfqq->weight_counter = BFQ_FAKE_WEIGHT_COUNTER;
> +		bfqq->ref++;
> +		return;
> +	}
> +
>  	while (*new) {
>  		struct bfq_weight_counter *__counter = container_of(*new,
>  						struct bfq_weight_counter,
> @@ -943,6 +951,9 @@ void __bfq_weights_tree_remove(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>  	if (!bfqq->weight_counter)
>  		return;
>  
> +	if (bfqq->weight_counter == BFQ_FAKE_WEIGHT_COUNTER)
> +		goto reset_entity_pointer;
> +
>  	root = &bfqd->queue_weights_tree;
>  	bfqq->weight_counter->num_active--;
>  	if (bfqq->weight_counter->num_active > 0)
> diff --git a/block/bfq-wf2q.c b/block/bfq-wf2q.c
> index a1296058c1ec..ae12c6b2c525 100644
> --- a/block/bfq-wf2q.c
> +++ b/block/bfq-wf2q.c
> @@ -776,7 +776,7 @@ __bfq_entity_update_weight_prio(struct bfq_service_tree *old_st,
>  		 * Add the entity, if it is not a weight-raised queue,
>  		 * to the counter associated with its new weight.
>  		 */
> -		if (prev_weight != new_weight && bfqq && bfqq->wr_coeff == 1)
> +		if (prev_weight != new_weight && bfqq)
>  			bfq_weights_tree_add(bfqd, bfqq);
>  
>  		new_st->wsum += entity->weight;
> @@ -1680,8 +1680,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, struct bfq_queue *bfqq)
>  	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
>  
>  	if (!bfqq->dispatched)
> -		if (bfqq->wr_coeff == 1)
> -			bfq_weights_tree_add(bfqd, bfqq);
> +		bfq_weights_tree_add(bfqd, bfqq);
>  
>  	if (bfqq->wr_coeff > 1)
>  		bfqd->wr_busy_queues++;
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
