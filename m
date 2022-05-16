From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] block: fix io hung of setting throttle limit
 frequently
Date: Mon, 16 May 2022 09:29:12 -1000
Message-ID: <YoKmCOAzwzw3Lz7g@slm.duckdns.org>
References: <20220516014429.33723-1-zhangwensheng5@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mXWRWurGOojMt9BoJ/ZUzDoEo2cNP5eq4Kyj7hbR+eI=;
        b=YQsJY8b5fAVtiYmvMVSWoltJPRNnqMY3pKrwMyJDgJmEUKtZKCtCKahQQJM5+X8LC9
         uOmw7vSwYGbgzB4AqWOaQK3LVp9h+50SfmIuNtD8LYZYCYN9eIuZ/r/BGgpLsDcR4TEl
         FJXKlfrpNTlFkDGl3guVkFdEYjbxNgcBYkFkKYHnOb1EloheVPX8UnOQBM2Mu7DDqD8W
         EKsO+bc55zlCuxwpg3oKT/psVgapFxAezTVnF+ijUcwAMpPBOl/2GPkGi3Age9azCjnp
         v/QPcVVBo3hTi7jpSKCIvmm1xnN1VMaEGLLvdS5+Lsg9TSeduxOpSZh/h+Ego3oZrSU6
         OSRA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220516014429.33723-1-zhangwensheng5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhang Wensheng <zhangwensheng5-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon, May 16, 2022 at 09:44:29AM +0800, Zhang Wensheng wrote:
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 469c483719be..8acb205dfa85 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -1321,12 +1321,14 @@ static void tg_conf_updated(struct throtl_grp *tg, bool global)
>  	 * that a group's limit are dropped suddenly and we don't want to
>  	 * account recently dispatched IO with new low rate.
>  	 */
> -	throtl_start_new_slice(tg, READ);
> -	throtl_start_new_slice(tg, WRITE);
> +	if (!timer_pending(&sq->parent_sq->pending_timer)) {
> +		throtl_start_new_slice(tg, READ);
> +		throtl_start_new_slice(tg, WRITE);
>  
> -	if (tg->flags & THROTL_TG_PENDING) {
> -		tg_update_disptime(tg);
> -		throtl_schedule_next_dispatch(sq->parent_sq, true);
> +		if (tg->flags & THROTL_TG_PENDING) {
> +			tg_update_disptime(tg);
> +			throtl_schedule_next_dispatch(sq->parent_sq, true);
> +		}

Yeah, but this ends up breaking the reason why it's starting the new slices
in the first place explained in the commit above, right? I'm not sure what
the right solution is but this likely isn't it.

Thanks.

-- 
tejun
