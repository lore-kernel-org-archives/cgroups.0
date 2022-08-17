From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -next 2/3] block, bfq: remove useless checking in
 bfq_put_queue()
Date: Wed, 17 Aug 2022 13:54:20 +0200
Message-ID: <20220817115420.dmzldiybx5xs4wqf@quack3>
References: <20220816015631.1323948-1-yukuai1@huaweicloud.com>
 <20220816015631.1323948-3-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660737261; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rm8JEW/rIpBp4i/6Owi2Iji64ulIai4y9uLFGtCpOBA=;
        b=hKkVXPJiBiQFS8b7QVhOX4+28k2oSDhXJVTO47zQOtYJ0z/Ow1orIVYID0P6wXesFungW7
        fmTHzwFYkjsh7nRXpW9prkzkIf8eIp3/aeN/Er6LHxSwUcvLGWU8g9LsUlR5QscQCXHYxo
        DnIYtFdB+HwUtavwnESO5r9v415UkCI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660737261;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rm8JEW/rIpBp4i/6Owi2Iji64ulIai4y9uLFGtCpOBA=;
        b=vWyxR/SHYYfgDsRdknJ7ivO45nsMCiTE1l4jWdy6yKQO7PELmEH86Oh6PyozdI5oWhEbcy
        Dffwd97uuLPbCcBw==
Content-Disposition: inline
In-Reply-To: <20220816015631.1323948-3-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: jack@suse.cz, axboe@kernel.dk, paolo.valente@linaro.org, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue 16-08-22 09:56:30, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> 'bfqq->bfqd' is ensured to set in bfq_init_queue(), and it will never
> change afterwards.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bfq-iosched.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index c740b41fe0a4..f39067389b2b 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -5255,9 +5255,7 @@ void bfq_put_queue(struct bfq_queue *bfqq)
>  	struct hlist_node *n;
>  	struct bfq_group *bfqg = bfqq_group(bfqq);
>  
> -	if (bfqq->bfqd)
> -		bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d",
> -			     bfqq, bfqq->ref);
> +	bfq_log_bfqq(bfqq->bfqd, bfqq, "put_queue: %p %d", bfqq, bfqq->ref);
>  
>  	bfqq->ref--;
>  	if (bfqq->ref)
> @@ -5321,7 +5319,7 @@ void bfq_put_queue(struct bfq_queue *bfqq)
>  		hlist_del_init(&item->woken_list_node);
>  	}
>  
> -	if (bfqq->bfqd && bfqq->bfqd->last_completed_rq_bfqq == bfqq)
> +	if (bfqq->bfqd->last_completed_rq_bfqq == bfqq)
>  		bfqq->bfqd->last_completed_rq_bfqq = NULL;
>  
>  	kmem_cache_free(bfq_pool, bfqq);
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
