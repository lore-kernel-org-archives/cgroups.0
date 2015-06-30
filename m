From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 24/51] writeback, blkcg: associate each blkcg_gq with the
 corresponding bdi_writeback_congested
Date: Tue, 30 Jun 2015 11:08:42 +0200
Message-ID: <20150630090842.GF7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-25-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-25-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:38, Tejun Heo wrote:
> A blkg (blkcg_gq) can be congested and decongested independently from
> other blkgs on the same request_queue.  Accordingly, for cgroup
> writeback support, the congestion status at bdi (backing_dev_info)
> should be split and updated separately from matching blkg's.
> 
> This patch prepares by adding blkg->wb_congested and associating a
> blkg with its matching per-blkcg bdi_writeback_congested on creation.
> 
> v2: Updated to associate bdi_writeback_congested instead of
>     bdi_writeback.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

> ---
>  block/blk-cgroup.c         | 17 +++++++++++++++--
>  include/linux/blk-cgroup.h |  6 ++++++
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 979cfdb..31610ae 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -182,6 +182,7 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  				    struct blkcg_gq *new_blkg)
>  {
>  	struct blkcg_gq *blkg;
> +	struct bdi_writeback_congested *wb_congested;
>  	int i, ret;
>  
>  	WARN_ON_ONCE(!rcu_read_lock_held());
> @@ -193,22 +194,30 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  		goto err_free_blkg;
>  	}
>  
> +	wb_congested = wb_congested_get_create(&q->backing_dev_info,
> +					       blkcg->css.id, GFP_ATOMIC);
> +	if (!wb_congested) {
> +		ret = -ENOMEM;
> +		goto err_put_css;
> +	}
> +
>  	/* allocate */
>  	if (!new_blkg) {
>  		new_blkg = blkg_alloc(blkcg, q, GFP_ATOMIC);
>  		if (unlikely(!new_blkg)) {
>  			ret = -ENOMEM;
> -			goto err_put_css;
> +			goto err_put_congested;
>  		}
>  	}
>  	blkg = new_blkg;
> +	blkg->wb_congested = wb_congested;
>  
>  	/* link parent */
>  	if (blkcg_parent(blkcg)) {
>  		blkg->parent = __blkg_lookup(blkcg_parent(blkcg), q, false);
>  		if (WARN_ON_ONCE(!blkg->parent)) {
>  			ret = -EINVAL;
> -			goto err_put_css;
> +			goto err_put_congested;
>  		}
>  		blkg_get(blkg->parent);
>  	}
> @@ -245,6 +254,8 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
>  	blkg_put(blkg);
>  	return ERR_PTR(ret);
>  
> +err_put_congested:
> +	wb_congested_put(wb_congested);
>  err_put_css:
>  	css_put(&blkcg->css);
>  err_free_blkg:
> @@ -391,6 +402,8 @@ void __blkg_release_rcu(struct rcu_head *rcu_head)
>  	if (blkg->parent)
>  		blkg_put(blkg->parent);
>  
> +	wb_congested_put(blkg->wb_congested);
> +
>  	blkg_free(blkg);
>  }
>  EXPORT_SYMBOL_GPL(__blkg_release_rcu);
> diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
> index 3033eb1..07a32b8 100644
> --- a/include/linux/blk-cgroup.h
> +++ b/include/linux/blk-cgroup.h
> @@ -99,6 +99,12 @@ struct blkcg_gq {
>  	struct hlist_node		blkcg_node;
>  	struct blkcg			*blkcg;
>  
> +	/*
> +	 * Each blkg gets congested separately and the congestion state is
> +	 * propagated to the matching bdi_writeback_congested.
> +	 */
> +	struct bdi_writeback_congested	*wb_congested;
> +
>  	/* all non-root blkcg_gq's are guaranteed to have access to parent */
>  	struct blkcg_gq			*parent;
>  
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
