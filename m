From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -next 6/8] block, bfq: remove dead code for updating
 'rq_in_driver'
Date: Thu, 19 May 2022 13:06:25 +0200
Message-ID: <20220519110625.wobgihgbtyadgykp@quack3.lan>
References: <20220514090522.1669270-1-yukuai3@huawei.com>
 <20220514090522.1669270-7-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652958385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HlX9V2kwUqlaTsfZgmTmF/cQ1kOaxEblkPsnhaP8BrY=;
        b=olR7yqt0ft1lzAE1gwqNyfTmGtnFtFtRSjRvkUF3E6Ut7hmVkuBz0wC79JhPZdqeg2+H7+
        /TyFDuv+pK3/NMJFxtq2yDM3L2y6jXlRetJyHeyWg04/U8/AdwafzGZ/t0+3WsPMojNdSo
        P+L4qbOVar0XTxvqYapGj6VzAkx0X4c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652958385;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HlX9V2kwUqlaTsfZgmTmF/cQ1kOaxEblkPsnhaP8BrY=;
        b=vNtlrNDpXGIB8zsDZfps405lLXcZvWHrBaQs8DAw0zwMWjvbAsqTA45KPJ4JJjTg/FhLAs
        B4leCEXQDxMUu0BQ==
Content-Disposition: inline
In-Reply-To: <20220514090522.1669270-7-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sat 14-05-22 17:05:20, Yu Kuai wrote:
> Such code are not even compiled since they are inside marco "#if 0".
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  block/bfq-iosched.c | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 1d0141c450c0..e36a16684fb4 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -2322,22 +2322,6 @@ static sector_t get_sdist(sector_t last_pos, struct request *rq)
>  	return 0;
>  }
>  
> -#if 0 /* Still not clear if we can do without next two functions */
> -static void bfq_activate_request(struct request_queue *q, struct request *rq)
> -{
> -	struct bfq_data *bfqd = q->elevator->elevator_data;
> -
> -	bfqd->rq_in_driver++;
> -}
> -
> -static void bfq_deactivate_request(struct request_queue *q, struct request *rq)
> -{
> -	struct bfq_data *bfqd = q->elevator->elevator_data;
> -
> -	bfqd->rq_in_driver--;
> -}
> -#endif
> -
>  static void bfq_remove_request(struct request_queue *q,
>  			       struct request *rq)
>  {
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
