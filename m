From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/12] blkcg: fix minor bug in blkg_alloc()
Date: Mon, 17 Dec 2012 14:10:41 -0500
Message-ID: <20121217191041.GD7235@redhat.com>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
 <1355524885-22719-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1355524885-22719-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Dec 14, 2012 at 02:41:14PM -0800, Tejun Heo wrote:
> blkg_alloc() was mistakenly checking blkcg_policy_enabled() twice.
> The latter test should have been on whether pol->pd_init_fn() exists.
> This doesn't cause actual problems because both blkcg policies
> implement pol->pd_init_fn().  Fix it.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Vivek

> ---
>  block/blk-cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 3f6d39d..feda49f 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -114,7 +114,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
>  		pd->blkg = blkg;
>  
>  		/* invoke per-policy init */
> -		if (blkcg_policy_enabled(blkg->q, pol))
> +		if (pol->pd_init_fn)
>  			pol->pd_init_fn(blkg);
>  	}
>  
> -- 
> 1.7.11.7
