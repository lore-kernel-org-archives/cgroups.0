From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 32/51] writeback: implement
 backing_dev_info->tot_write_bandwidth
Date: Tue, 30 Jun 2015 18:14:58 +0200
Message-ID: <20150630161458.GR7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-33-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-33-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:46, Tejun Heo wrote:
> cgroup writeback support needs to keep track of the sum of
> avg_write_bandwidth of all wb's (bdi_writeback's) with dirty inodes to
> distribute write workload.  This patch adds bdi->tot_write_bandwidth
> and updates inode_wb_list_move_locked(), inode_wb_list_del_locked()
> and wb_update_write_bandwidth() to adjust it as wb's gain and lose
> dirty inodes and its avg_write_bandwidth gets updated.
> 
> As the update events are not synchronized with each other,
> bdi->tot_write_bandwidth is an atomic_long_t.

So I was looking into what tot_write_bandwidth is used for and if I look
right it is used for bdi_has_dirty_io() and for distribution of dirty pages
when writeback is started against the whole bdi.

Now neither of these cases seem to be really performance critical (in all
the cases we iterate the list of all wbs of the bdi anyway) so why don't we
just compute the total write bandwidth when needed, instead of maintaining
it all the time?

								Honza

> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/fs-writeback.c                | 7 ++++++-
>  include/linux/backing-dev-defs.h | 2 ++
>  mm/page-writeback.c              | 3 +++
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 0a90dc55..bbccf68 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -99,6 +99,8 @@ static bool wb_io_lists_populated(struct bdi_writeback *wb)
>  		return false;
>  	} else {
>  		set_bit(WB_has_dirty_io, &wb->state);
> +		atomic_long_add(wb->avg_write_bandwidth,
> +				&wb->bdi->tot_write_bandwidth);
>  		return true;
>  	}
>  }
> @@ -106,8 +108,11 @@ static bool wb_io_lists_populated(struct bdi_writeback *wb)
>  static void wb_io_lists_depopulated(struct bdi_writeback *wb)
>  {
>  	if (wb_has_dirty_io(wb) && list_empty(&wb->b_dirty) &&
> -	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io))
> +	    list_empty(&wb->b_io) && list_empty(&wb->b_more_io)) {
>  		clear_bit(WB_has_dirty_io, &wb->state);
> +		atomic_long_sub(wb->avg_write_bandwidth,
> +				&wb->bdi->tot_write_bandwidth);
> +	}
>  }
>  
>  /**
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 7a94b78..d631a61 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -142,6 +142,8 @@ struct backing_dev_info {
>  	unsigned int min_ratio;
>  	unsigned int max_ratio, max_prop_frac;
>  
> +	atomic_long_t tot_write_bandwidth; /* sum of active avg_write_bw */
> +
>  	struct bdi_writeback wb;  /* the root writeback info for this bdi */
>  	struct bdi_writeback_congested wb_congested; /* its congested state */
>  #ifdef CONFIG_CGROUP_WRITEBACK
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index e31dea9..c95eb24 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -881,6 +881,9 @@ static void wb_update_write_bandwidth(struct bdi_writeback *wb,
>  		avg += (old - avg) >> 3;
>  
>  out:
> +	if (wb_has_dirty_io(wb))
> +		atomic_long_add(avg - wb->avg_write_bandwidth,
> +				&wb->bdi->tot_write_bandwidth);
>  	wb->write_bandwidth = bw;
>  	wb->avg_write_bandwidth = avg;
>  }
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
