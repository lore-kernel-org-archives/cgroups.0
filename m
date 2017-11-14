From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/7] blkcg: relocate __blkg_release_rcu()
Date: Tue, 14 Nov 2017 15:12:26 -0800
Message-ID: <20171114231226.bnqrb2xadiw7ba2q@kernel.org>
References: <20171112222613.3613362-1-tj@kernel.org>
 <20171112222613.3613362-2-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171112222613.3613362-2-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On Sun, Nov 12, 2017 at 02:26:07PM -0800, Tejun Heo wrote:
> Move __blkg_release_rcu() above blkg_alloc().  This is a pure code
> reorganization to prepare for the switch to percpu_ref.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  block/blk-cgroup.c | 46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index d3f56ba..6482be5 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -81,6 +81,29 @@ static void blkg_free(struct blkcg_gq *blkg)
>  	kfree(blkg);
>  }
>  
> +/*
> + * A group is RCU protected, but having an rcu lock does not mean that one
> + * can access all the fields of blkg and assume these are valid.  For
> + * example, don't try to follow throtl_data and request queue links.
> + *
> + * Having a reference to blkg under an rcu allows accesses to only values
> + * local to groups like group stats and group rate limits.
> + */
> +void __blkg_release_rcu(struct rcu_head *rcu_head)
> +{
> +	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
> +
> +	/* release the blkcg and parent blkg refs this blkg has been holding */
> +	css_put(&blkg->blkcg->css);
> +	if (blkg->parent)
> +		blkg_put(blkg->parent);
> +
> +	wb_congested_put(blkg->wb_congested);
> +
> +	blkg_free(blkg);
> +}
> +EXPORT_SYMBOL_GPL(__blkg_release_rcu);
> +
>  /**
>   * blkg_alloc - allocate a blkg
>   * @blkcg: block cgroup the new blkg is associated with
> @@ -378,29 +401,6 @@ static void blkg_destroy_all(struct request_queue *q)
>  }
>  
>  /*
> - * A group is RCU protected, but having an rcu lock does not mean that one
> - * can access all the fields of blkg and assume these are valid.  For
> - * example, don't try to follow throtl_data and request queue links.
> - *
> - * Having a reference to blkg under an rcu allows accesses to only values
> - * local to groups like group stats and group rate limits.
> - */
> -void __blkg_release_rcu(struct rcu_head *rcu_head)
> -{
> -	struct blkcg_gq *blkg = container_of(rcu_head, struct blkcg_gq, rcu_head);
> -
> -	/* release the blkcg and parent blkg refs this blkg has been holding */
> -	css_put(&blkg->blkcg->css);
> -	if (blkg->parent)
> -		blkg_put(blkg->parent);
> -
> -	wb_congested_put(blkg->wb_congested);
> -
> -	blkg_free(blkg);
> -}
> -EXPORT_SYMBOL_GPL(__blkg_release_rcu);
> -
> -/*
>   * The next function used by blk_queue_for_each_rl().  It's a bit tricky
>   * because the root blkg uses @q->root_rl instead of its own rl.
>   */
> -- 
> 2.9.5
> 
