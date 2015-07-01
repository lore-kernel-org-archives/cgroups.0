From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 37/51] writeback: remove bdi_start_writeback()
Date: Wed, 1 Jul 2015 09:30:50 +0200
Message-ID: <20150701073050.GX7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-38-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-38-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:51, Tejun Heo wrote:
> bdi_start_writeback() is a thin wrapper on top of
> __wb_start_writeback() which is used only by laptop_mode_timer_fn().
> This patches removes bdi_start_writeback(), renames
> __wb_start_writeback() to wb_start_writeback() and makes
> laptop_mode_timer_fn() use it instead.
> 
> This doesn't cause any functional difference and will ease making
> laptop_mode_timer_fn() cgroup writeback aware.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza

> ---
>  fs/fs-writeback.c           | 68 +++++++++++++++++----------------------------
>  include/linux/backing-dev.h |  4 +--
>  mm/page-writeback.c         |  4 +--
>  3 files changed, 29 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 921a9e4..79f11af 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -184,33 +184,6 @@ static void wb_queue_work(struct bdi_writeback *wb,
>  	spin_unlock_bh(&wb->work_lock);
>  }
>  
> -static void __wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
> -				 bool range_cyclic, enum wb_reason reason)
> -{
> -	struct wb_writeback_work *work;
> -
> -	if (!wb_has_dirty_io(wb))
> -		return;
> -
> -	/*
> -	 * This is WB_SYNC_NONE writeback, so if allocation fails just
> -	 * wakeup the thread for old dirty data writeback
> -	 */
> -	work = kzalloc(sizeof(*work), GFP_ATOMIC);
> -	if (!work) {
> -		trace_writeback_nowork(wb->bdi);
> -		wb_wakeup(wb);
> -		return;
> -	}
> -
> -	work->sync_mode	= WB_SYNC_NONE;
> -	work->nr_pages	= nr_pages;
> -	work->range_cyclic = range_cyclic;
> -	work->reason	= reason;
> -
> -	wb_queue_work(wb, work);
> -}
> -
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  
>  /**
> @@ -240,22 +213,31 @@ EXPORT_SYMBOL_GPL(inode_congested);
>  
>  #endif	/* CONFIG_CGROUP_WRITEBACK */
>  
> -/**
> - * bdi_start_writeback - start writeback
> - * @bdi: the backing device to write from
> - * @nr_pages: the number of pages to write
> - * @reason: reason why some writeback work was initiated
> - *
> - * Description:
> - *   This does WB_SYNC_NONE opportunistic writeback. The IO is only
> - *   started when this function returns, we make no guarantees on
> - *   completion. Caller need not hold sb s_umount semaphore.
> - *
> - */
> -void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
> -			enum wb_reason reason)
> +void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
> +			bool range_cyclic, enum wb_reason reason)
>  {
> -	__wb_start_writeback(&bdi->wb, nr_pages, true, reason);
> +	struct wb_writeback_work *work;
> +
> +	if (!wb_has_dirty_io(wb))
> +		return;
> +
> +	/*
> +	 * This is WB_SYNC_NONE writeback, so if allocation fails just
> +	 * wakeup the thread for old dirty data writeback
> +	 */
> +	work = kzalloc(sizeof(*work), GFP_ATOMIC);
> +	if (!work) {
> +		trace_writeback_nowork(wb->bdi);
> +		wb_wakeup(wb);
> +		return;
> +	}
> +
> +	work->sync_mode	= WB_SYNC_NONE;
> +	work->nr_pages	= nr_pages;
> +	work->range_cyclic = range_cyclic;
> +	work->reason	= reason;
> +
> +	wb_queue_work(wb, work);
>  }
>  
>  /**
> @@ -1219,7 +1201,7 @@ void wakeup_flusher_threads(long nr_pages, enum wb_reason reason)
>  
>  	rcu_read_lock();
>  	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
> -		__wb_start_writeback(&bdi->wb, nr_pages, false, reason);
> +		wb_start_writeback(&bdi->wb, nr_pages, false, reason);
>  	rcu_read_unlock();
>  }
>  
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c797980..0ff40c2 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -25,8 +25,8 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
>  int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
>  void bdi_unregister(struct backing_dev_info *bdi);
>  int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
> -void bdi_start_writeback(struct backing_dev_info *bdi, long nr_pages,
> -			enum wb_reason reason);
> +void wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
> +			bool range_cyclic, enum wb_reason reason);
>  void bdi_start_background_writeback(struct backing_dev_info *bdi);
>  void wb_workfn(struct work_struct *work);
>  void wb_wakeup_delayed(struct bdi_writeback *wb);
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 9b55f12..6301af2 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1729,8 +1729,8 @@ void laptop_mode_timer_fn(unsigned long data)
>  	 * threshold
>  	 */
>  	if (bdi_has_dirty_io(&q->backing_dev_info))
> -		bdi_start_writeback(&q->backing_dev_info, nr_pages,
> -					WB_REASON_LAPTOP_TIMER);
> +		wb_start_writeback(&q->backing_dev_info.wb, nr_pages, true,
> +				   WB_REASON_LAPTOP_TIMER);
>  }
>  
>  /*
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
