From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 38/51] writeback: make laptop_mode_timer_fn() handle
 multiple bdi_writeback's
Date: Wed, 1 Jul 2015 09:32:40 +0200
Message-ID: <20150701073240.GY7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-39-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-39-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:52, Tejun Heo wrote:
> For cgroup writeback support, all bdi-wide operations should be
> distributed to all its wb's (bdi_writeback's).
> 
> This patch updates laptop_mode_timer_fn() so that it invokes
> wb_start_writeback() on all wb's rather than just the root one.  As
> the intent is writing out all dirty data, there's no reason to split
> the number of pages to write.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza

> ---
>  mm/page-writeback.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 6301af2..682e3a6 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1723,14 +1723,20 @@ void laptop_mode_timer_fn(unsigned long data)
>  	struct request_queue *q = (struct request_queue *)data;
>  	int nr_pages = global_page_state(NR_FILE_DIRTY) +
>  		global_page_state(NR_UNSTABLE_NFS);
> +	struct bdi_writeback *wb;
> +	struct wb_iter iter;
>  
>  	/*
>  	 * We want to write everything out, not just down to the dirty
>  	 * threshold
>  	 */
> -	if (bdi_has_dirty_io(&q->backing_dev_info))
> -		wb_start_writeback(&q->backing_dev_info.wb, nr_pages, true,
> -				   WB_REASON_LAPTOP_TIMER);
> +	if (!bdi_has_dirty_io(&q->backing_dev_info))
> +		return;
> +
> +	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
> +		if (wb_has_dirty_io(wb))
> +			wb_start_writeback(wb, nr_pages, true,
> +					   WB_REASON_LAPTOP_TIMER);
>  }
>  
>  /*
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
