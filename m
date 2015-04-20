From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 15/49] writeback: move backing_dev_info->wb_lock and
 ->worklist into bdi_writeback
Date: Mon, 20 Apr 2015 17:32:24 +0200
Message-ID: <20150420153224.GD17020@quack.suse.cz>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-16-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1428350318-8215-16-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon 06-04-15 15:58:04, Tejun Heo wrote:
> Currently, a bdi (backing_dev_info) embeds single wb (bdi_writeback)
> and the role of the separation is unclear.  For cgroup support for
> writeback IOs, a bdi will be updated to host multiple wb's where each
> wb serves writeback IOs of a different cgroup on the bdi.  To achieve
> that, a wb should carry all states necessary for servicing writeback
> IOs for a cgroup independently.
> 
> This patch moves bdi->wb_lock and ->worklist into wb.
> 
> * The lock protects bdi->worklist and bdi->wb.dwork scheduling.  While
>   moving, rename it to wb->work_lock as wb->wb_lock is confusing.
>   Also, move wb->dwork downwards so that it's colocated with the new
>   ->work_lock and ->work_list fields.
> 
> * bdi_writeback_workfn()		-> wb_workfn()
>   bdi_wakeup_thread_delayed(bdi)	-> wb_wakeup_delayed(wb)
>   bdi_wakeup_thread(bdi)		-> wb_wakeup(wb)
>   bdi_queue_work(bdi, ...)		-> wb_queue_work(wb, ...)
>   __bdi_start_writeback(bdi, ...)	-> __wb_start_writeback(wb, ...)
>   get_next_work_item(bdi)		-> get_next_work_item(wb)
> 
> * bdi_wb_shutdown() is renamed to wb_shutdown() and now takes @wb.
>   The function contained parts which belong to the containing bdi
>   rather than the wb itself - testing cap_writeback_dirty and
>   bdi_remove_from_list() invocation.  Those are moved to
>   bdi_unregister().
> 
> * bdi_wb_{init|exit}() are renamed to wb_{init|exit}().
>   Initializations of the moved bdi->wb_lock and ->work_list are
>   relocated from bdi_init() to wb_init().
> 
> * As there's still only one bdi_writeback per backing_dev_info, all
>   uses of bdi->state are mechanically replaced with bdi->wb.state
>   introducing no behavior changes.
> 
...
> @@ -454,9 +451,9 @@ EXPORT_SYMBOL(bdi_init);
>  
>  void bdi_destroy(struct backing_dev_info *bdi)
>  {
> -	bdi_wb_shutdown(bdi);
> -
> -	WARN_ON(!list_empty(&bdi->work_list));
> +	/* make sure nobody finds us on the bdi_list anymore */
> +	bdi_remove_from_list(bdi);
> +	wb_shutdown(&bdi->wb);
>  
>  	if (bdi->dev) {
>  		bdi_debug_unregister(bdi);
  But if someone ends up calling bdi_destroy() on unregistered bdi,
bdi_remove_from_list() will be corrupting memory, won't it? And if I
remember right there were some corner cases where this really happened.
Previously we were careful and checked WB_registered. I guess we could
check for !list_empty(&bdi->bdi_list) and also reinit bdi_list in
bdi_remove_from_list() after synchronize_rcu_expedited().

								Honza

-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
