From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] blk-throttle: cleanup throtl_dequeue_tg()
Date: Tue, 23 Aug 2022 08:34:10 -1000
Message-ID: <YwUdouGld9Z7K8r1@slm.duckdns.org>
References: <20220823013810.406075-1-yukuai1@huaweicloud.com>
 <20220823013810.406075-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=JfIVW5EAwcziVt6ePzGMkVRPbB2bi7yV+a8QRJJ7RgI=;
        b=q2ExPiLlmr3rFwyGKyFXlMV0seXxl2bOW/vbx0cJKPMa41O8h0U5Zh4IcGSH/ZVlfA
         tGxkmod7yD4lDznK3zTaxdLioXjnbXJuP5pTi8fvgtB4XP0Zw1RAjUNS19hYVgSqLprg
         Iu5kjJ4wOVLnNfmSZ0WYps4ZaILOqbrjOz6ENcqZ7z4BF23tEAPFkIJJGqJJsb65I4jL
         dWoWCcSPW5Xk+5pn15qtd/aOLzGUSPf4kzTDKOvcbryapOxCZResD/Jw7kbtaancyk97
         7zU6ZDOeKvDffRu3TqYryVn6skyhNVDmt5NIj8EC1ejkiew4bYHycaz+J/mb1mEpmwzf
         oVCA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220823013810.406075-5-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Aug 23, 2022 at 09:38:10AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Now that throtl_dequeue_tg() is called when the last bio is dispatched,
> there is no need to check the flag THROTL_TG_PENDING, since it's ensured
> to be set when bio is throttled.
> 
> There are no functional changes.
> 
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 47142a1dd102..e47506a8ef47 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -570,14 +570,11 @@ static void throtl_enqueue_tg(struct throtl_grp *tg)
>  
>  static void throtl_dequeue_tg(struct throtl_grp *tg)
>  {
> -	if (tg->flags & THROTL_TG_PENDING) {
> -		struct throtl_service_queue *parent_sq =
> -			tg->service_queue.parent_sq;
> +	struct throtl_service_queue *parent_sq = tg->service_queue.parent_sq;
>  
> -		throtl_rb_erase(&tg->rb_node, parent_sq);
> -		--parent_sq->nr_pending;
> -		tg->flags &= ~THROTL_TG_PENDING;
> -	}
> +	throtl_rb_erase(&tg->rb_node, parent_sq);
> +	--parent_sq->nr_pending;
> +	tg->flags &= ~THROTL_TG_PENDING;

Yeah, I don't know about this one. This breaks the symmetry with
throtl_enqueue_tg() and it's a bit odd that we aren't at least
WARN_ON_ONCE() on the flag given what the flag tracks. If you want to do
this, I think the prev approach of just removing the flag is better as that
was symmetric at least.

Thanks.

-- 
tejun
