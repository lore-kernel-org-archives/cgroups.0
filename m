From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 03/11] blk-throttle: ignore cgroup without io queued in
 blk_throtl_cancel_bios
Date: Wed, 23 Nov 2022 08:13:59 -1000
Message-ID: <Y35i54BnLjKce3Kc@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-4-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMUk2UqA8txZdZbMsTiuPaMt9b7Ay82RXjXskAbuDPs=;
        b=QAlAxOsEx24Cwf9tScvp0rAk8jnc3b8EhqyZVyTEUzMY+iffJxG+UTg2oo5xYUNszd
         672R0ISbxm5hWjLG31Lvt+uIB/W6X45fhUb3yktwB1ioI6w3ZAUq+xsbihEMtpGCk/tk
         rbTh1RYNawjVNsF66tpno4HWYq3IhBgEWzKwAesID2AUcPFOnKK/pOsZqXVE5e69/NVT
         WU2woTi4IZ91+E0sVX5QTpJmDgsRoZs6ar4Tw1Dd8m26mXphAzH0X9gs5238Ljbs6AtY
         ETcT2DHqHoHvEHW4pMIxk0CqJKz7GBBPXP5Ik/3uXCOLOADa0CxV9jX0HX9QNXg9XGAJ
         Jq0g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-4-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:03:53PM +0800, Kemeng Shi wrote:
> Ignore cgroup without io queued in blk_throtl_cancel_bios for two
> reasons:
> 1. Save cpu cycle for trying to dispatch cgroup which is no io queued.
> 2. Avoid non-consistent state that cgroup is inserted to service queue
> without THROTL_TG_PENDING set as tg_update_disptime will unconditional
> re-insert cgroup to service queue. If we are on the default hierarchy,
> IO dispatched from child in tg_dispatch_one_bio will trigger inserting
> cgroup to service queue without erase first and ruin the tree.
> 
> Signed-off-by: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index b33bcf53b36e..acfac916ed99 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1728,7 +1728,12 @@ void blk_throtl_cancel_bios(struct gendisk *disk)
>  		 * Set the flag to make sure throtl_pending_timer_fn() won't
>  		 * stop until all throttled bios are dispatched.
>  		 */
> -		blkg_to_tg(blkg)->flags |= THROTL_TG_CANCELING;
> +		tg->flags |= THROTL_TG_CANCELING;
> +
> +		/* No need to dispatch cgroup without io queued */

It's probably more important to mention that putting this in without PENDING
set can corrupt the tree in the future through double insertion.

> +		if (!(tg->flags & THROTL_TG_PENDING))
> +			continue;
> +

Other than than the above comment,

  Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
