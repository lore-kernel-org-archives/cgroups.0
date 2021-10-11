From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: check blkcg policy is enabled in
 blkg_create()
Date: Mon, 11 Oct 2021 07:16:59 -1000
Message-ID: <YWRxi2OaIHhG9rOc@slm.duckdns.org>
References: <20211008072720.797814-1-yukuai3@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=47MxuwjdGXsg6hhuLv8z6fw88ymx9GeX72SLuyGJTok=;
        b=a4RrVVdJ7cUmlCzggWQlfbsOGdWJ2MPLEG7CalU7wsqMn5r+DmcveNvP/dyXMNR51w
         JtU8Ih35Ce+uEy4ncY5JylViwvaU0igXgKz2jaopbXllKs4Y/NmCftllt9Er3ysq5hxH
         VPtWr48EAAqhK7X9th7UFB+LRnFN9m99A2smY07IoxO7ZFdPJ7mXc6Pu3qkj4fBcKTyb
         2Iv2hIOIVZVA3TbxCeJx5383kucVuJsrJ2aavndyzcUgCH8omLECpFhzAfSfBEBllQwh
         97IPyg91TL5MFJMujwLsnFD+T4IWTukC9iJ8bqhU/7D+IlUe2KDpBVFaOCk696vZlb+a
         SsYA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211008072720.797814-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri, Oct 08, 2021 at 03:27:20PM +0800, Yu Kuai wrote:
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index eb48090eefce..00e1d97621ea 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -226,6 +226,20 @@ struct blkcg_gq *blkg_lookup_slowpath(struct blkcg *blkcg,
>  }
>  EXPORT_SYMBOL_GPL(blkg_lookup_slowpath);
>  
> +static void blkg_check_pd(struct request_queue *q, struct blkcg_gq *blkg)
> +{
> +	int i;
> +
> +	for (i = 0; i < BLKCG_MAX_POLS; i++) {
> +		struct blkcg_policy *pol = blkcg_policy[i];
> +
> +		if (blkg->pd[i] && !blkcg_policy_enabled(q, pol)) {
> +			pol->pd_free_fn(blkg->pd[i]);
> +			blkg->pd[i] = NULL;
> +		}
> +	}
> +}
> +
>  /*
>   * If @new_blkg is %NULL, this function tries to allocate a new one as
>   * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return.
> @@ -252,6 +266,9 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  		goto err_free_blkg;
>  	}
>  
> +	if (new_blkg)
> +		blkg_check_pd(q, new_blkg);
> +

Can't this happen the other way around too? ie. Linking a pd which doesn't
have an entry for a policy which got enabled inbetween? And what if an
existing policy was de-registered and another policy got the policy id
inbetween? I think the correct solution here would be synchronizing alloc -
create blocks against policy deactivation rather than trying to patch an
allocated blkg later. Deactivation being a really slow path, there are
plenty of options. The main challenge would making it difficult to make
mistakes with, I guess.

Thanks.

-- 
tejun
