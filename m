From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 35/51] writeback: make bdi->min/max_ratio handling cgroup
 writeback aware
Date: Wed, 1 Jul 2015 09:00:07 +0200
Message-ID: <20150701070007.GV7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-36-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-36-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:49, Tejun Heo wrote:
> bdi->min/max_ratio are user-configurable per-bdi knobs which regulate
> dirty limit of each bdi.  For cgroup writeback, they need to be
> further distributed across wb's (bdi_writeback's) belonging to the
> configured bdi.
> 
> This patch introduces wb_min_max_ratio() which distributes
> bdi->min/max_ratio according to a wb's proportion in the total active
> bandwidth of its bdi.
> 
> v2: Update wb_min_max_ratio() to fix a bug where both min and max were
>     assigned the min value and avoid calculations when possible.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza

> ---
>  mm/page-writeback.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 99b8846..9b55f12 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -155,6 +155,46 @@ static unsigned long writeout_period_time = 0;
>   */
>  #define VM_COMPLETIONS_PERIOD_LEN (3*HZ)
>  
> +#ifdef CONFIG_CGROUP_WRITEBACK
> +
> +static void wb_min_max_ratio(struct bdi_writeback *wb,
> +			     unsigned long *minp, unsigned long *maxp)
> +{
> +	unsigned long this_bw = wb->avg_write_bandwidth;
> +	unsigned long tot_bw = atomic_long_read(&wb->bdi->tot_write_bandwidth);
> +	unsigned long long min = wb->bdi->min_ratio;
> +	unsigned long long max = wb->bdi->max_ratio;
> +
> +	/*
> +	 * @wb may already be clean by the time control reaches here and
> +	 * the total may not include its bw.
> +	 */
> +	if (this_bw < tot_bw) {
> +		if (min) {
> +			min *= this_bw;
> +			do_div(min, tot_bw);
> +		}
> +		if (max < 100) {
> +			max *= this_bw;
> +			do_div(max, tot_bw);
> +		}
> +	}
> +
> +	*minp = min;
> +	*maxp = max;
> +}
> +
> +#else	/* CONFIG_CGROUP_WRITEBACK */
> +
> +static void wb_min_max_ratio(struct bdi_writeback *wb,
> +			     unsigned long *minp, unsigned long *maxp)
> +{
> +	*minp = wb->bdi->min_ratio;
> +	*maxp = wb->bdi->max_ratio;
> +}
> +
> +#endif	/* CONFIG_CGROUP_WRITEBACK */
> +
>  /*
>   * In a memory zone, there is a certain amount of pages we consider
>   * available for the page cache, which is essentially the number of
> @@ -539,9 +579,9 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
>   */
>  unsigned long wb_dirty_limit(struct bdi_writeback *wb, unsigned long dirty)
>  {
> -	struct backing_dev_info *bdi = wb->bdi;
>  	u64 wb_dirty;
>  	long numerator, denominator;
> +	unsigned long wb_min_ratio, wb_max_ratio;
>  
>  	/*
>  	 * Calculate this BDI's share of the dirty ratio.
> @@ -552,9 +592,11 @@ unsigned long wb_dirty_limit(struct bdi_writeback *wb, unsigned long dirty)
>  	wb_dirty *= numerator;
>  	do_div(wb_dirty, denominator);
>  
> -	wb_dirty += (dirty * bdi->min_ratio) / 100;
> -	if (wb_dirty > (dirty * bdi->max_ratio) / 100)
> -		wb_dirty = dirty * bdi->max_ratio / 100;
> +	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
> +
> +	wb_dirty += (dirty * wb_min_ratio) / 100;
> +	if (wb_dirty > (dirty * wb_max_ratio) / 100)
> +		wb_dirty = dirty * wb_max_ratio / 100;
>  
>  	return wb_dirty;
>  }
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
