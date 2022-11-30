From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2 6/9] blk-iocost: change div64_u64 to
 DIV64_U64_ROUND_UP in ioc_refresh_params()
Date: Wed, 30 Nov 2022 10:22:33 -1000
Message-ID: <Y4e7ibMMu4quJMO5@slm.duckdns.org>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-7-linan122@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXdxFhxTXJMZHC2K4jUkxh/OKutSS9K9Oo99ntvx5PA=;
        b=fwyygy/fIcGISnxM7SLd6HwKX/itaYN7ne1sCrDpxfbyLvA/cYTRPkVgulkb4I5K1h
         1ubPvLIZte+QIp4MCfHDL3whCyHeHroidEc7paAJ2LlFvK5lP17RnutOxvtk3AKlMYJR
         tzfQ56dgLwAYEw8BEVndHTMEIlj3V4iFc6cTpaGKvgw3/pQS6tjnLOQ9ap6SPdS/xjwD
         ho9jq2NS9Yfxyt20H3vwHJqav1tRRKrHuEvj8vuJPuyDB4o8htsopWsUszs2VaYuPqFb
         O01oWFIDJjIUhYyH99AoZmGQDceqxvisTkY1V37hhitb88QrslKdeXpoO4wwgoPbnohC
         LG4A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221130132156.2836184-7-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Wed, Nov 30, 2022 at 09:21:53PM +0800, Li Nan wrote:
> vrate_min is calculated by DIV64_U64_ROUND_UP, but vrate_max is calculated
> by div64_u64. Vrate_min may be 1 greater than vrate_max if the input
> values min and max of cost.qos are equal.
> 
> Signed-off-by: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-iocost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
> index f4a754b9d10f..2316ba93e7d6 100644
> --- a/block/blk-iocost.c
> +++ b/block/blk-iocost.c
> @@ -926,7 +926,7 @@ static bool ioc_refresh_params(struct ioc *ioc, bool force)
>  
>  	ioc->vrate_min = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MIN] *
>  					    VTIME_PER_USEC, MILLION);
> -	ioc->vrate_max = div64_u64((u64)ioc->params.qos[QOS_MAX] *
> +	ioc->vrate_max = DIV64_U64_ROUND_UP((u64)ioc->params.qos[QOS_MAX] *
>  				   VTIME_PER_USEC, MILLION);

Can you please align the parameters line? Other than that

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
