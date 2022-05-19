From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next 1/8] block, bfq: cleanup bfq_weights_tree
 add/remove apis
Date: Thu, 19 May 2022 12:59:35 +0200
Message-ID: <20220519105935.psejehys7uwlzmmk@quack3.lan>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-2-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652957976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jMNnoNJa2b5+2J40iT0inx4nRccR2PWVfWoFKpUpFbQ=;
        b=K1to2AvtMDvcqfY6d7f+MZRQJg3j3EXLUKbxDk6DGYgfAw1IOz8sRKa18OWNCDddxM+pRQ
        ME9XP51iug2ximVhum/LXib4aNLUI5yRyZ3znHP11+0Xo/hKd4fgugpQ73F9O4FU9kVlRH
        fItMSip5j6K1dCMw5fjDRNeG/EyBHQo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652957976;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jMNnoNJa2b5+2J40iT0inx4nRccR2PWVfWoFKpUpFbQ=;
        b=Uwk9F1qU36LD4onNKj6zYEBLXpB+98fUh2gawQ0ywGOSkaGSF2HGAgb28Y5vczg6cnAcys
        I/UTEJuR8PjjFGDQ==
Content-Disposition: inline
In-Reply-To: <20220514090522.1669270-2-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3@huawei.com>
Cc: jack@suse.cz, paolo.valente@linaro.org, axboe@kernel.dk, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Sat 14-05-22 17:05:15, Yu Kuai wrote:
> They already pass 'bfqd' as the first parameter, there is no need to
> pass 'bfqd->queue_weights_tree' as another parameter.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Looks good. Just one nit below:

> @@ -945,12 +945,13 @@ void bfq_weights_tree_add(struct bfq_data *bfqd, struct bfq_queue *bfqq,
>   * about overhead.
>   */
>  void __bfq_weights_tree_remove(struct bfq_data *bfqd,
> -			       struct bfq_queue *bfqq,
> -			       struct rb_root_cached *root)
> +			       struct bfq_queue *bfqq)
>  {
> +	struct rb_root_cached *root;

Add empty line here please.

>  	if (!bfqq->weight_counter)
>  		return;
>  
> +	root = &bfqd->queue_weights_tree;
>  	bfqq->weight_counter->num_active--;
>  	if (bfqq->weight_counter->num_active > 0)
>  		goto reset_entity_pointer;

Otherwise the patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
