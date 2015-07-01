From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 44/51] writeback: implement bdi_wait_for_completion()
Date: Wed, 1 Jul 2015 18:04:37 +0200
Message-ID: <20150701160437.GG7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-45-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-45-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:58, Tejun Heo wrote:
> If the completion of a wb_writeback_work can be waited upon by setting
> its ->done to a struct completion and waiting on it; however, for
> cgroup writeback support, it's necessary to issue multiple work items
> to multiple bdi_writebacks and wait for the completion of all.
> 
> This patch implements wb_completion which can wait for multiple work
> items and replaces the struct completion with it.  It can be defined
> using DEFINE_WB_COMPLETION_ONSTACK(), used for multiple work items and
> waited for by wb_wait_for_completion().
> 
> Nobody currently issues multiple work items and this patch doesn't
> introduce any behavior changes.

I'd find it better to extend completions to allow doing what you need. It
isn't that special. It seems it would be enough to implement

void wait_for_completions(struct completion *x, int n);

where @n is the number of completions to wait for. And the implementation
can stay as is, only in do_wait_for_common() we change checks for x->done ==
0 to "x->done < n". That's about it...

								Honza


> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/fs-writeback.c                | 58 +++++++++++++++++++++++++++++++---------
>  include/linux/backing-dev-defs.h |  2 ++
>  mm/backing-dev.c                 |  1 +
>  3 files changed, 49 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 22f1def..d7d4a1b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -34,6 +34,10 @@
>   */
>  #define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_CACHE_SHIFT - 10))
>  
> +struct wb_completion {
> +	atomic_t		cnt;
> +};
> +
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -51,10 +55,23 @@ struct wb_writeback_work {
>  	enum wb_reason reason;		/* why was writeback initiated? */
>  
>  	struct list_head list;		/* pending work list */
> -	struct completion *done;	/* set if the caller waits */
> +	struct wb_completion *done;	/* set if the caller waits */
>  };
>  
>  /*
> + * If one wants to wait for one or more wb_writeback_works, each work's
> + * ->done should be set to a wb_completion defined using the following
> + * macro.  Once all work items are issued with wb_queue_work(), the caller
> + * can wait for the completion of all using wb_wait_for_completion().  Work
> + * items which are waited upon aren't freed automatically on completion.
> + */
> +#define DEFINE_WB_COMPLETION_ONSTACK(cmpl)				\
> +	struct wb_completion cmpl = {					\
> +		.cnt		= ATOMIC_INIT(1),			\
> +	}
> +
> +
> +/*
>   * If an inode is constantly having its pages dirtied, but then the
>   * updates stop dirtytime_expire_interval seconds in the past, it's
>   * possible for the worst case time between when an inode has its
> @@ -161,17 +178,34 @@ static void wb_queue_work(struct bdi_writeback *wb,
>  	trace_writeback_queue(wb->bdi, work);
>  
>  	spin_lock_bh(&wb->work_lock);
> -	if (!test_bit(WB_registered, &wb->state)) {
> -		if (work->done)
> -			complete(work->done);
> +	if (!test_bit(WB_registered, &wb->state))
>  		goto out_unlock;
> -	}
> +	if (work->done)
> +		atomic_inc(&work->done->cnt);
>  	list_add_tail(&work->list, &wb->work_list);
>  	mod_delayed_work(bdi_wq, &wb->dwork, 0);
>  out_unlock:
>  	spin_unlock_bh(&wb->work_lock);
>  }
>  
> +/**
> + * wb_wait_for_completion - wait for completion of bdi_writeback_works
> + * @bdi: bdi work items were issued to
> + * @done: target wb_completion
> + *
> + * Wait for one or more work items issued to @bdi with their ->done field
> + * set to @done, which should have been defined with
> + * DEFINE_WB_COMPLETION_ONSTACK().  This function returns after all such
> + * work items are completed.  Work items which are waited upon aren't freed
> + * automatically on completion.
> + */
> +static void wb_wait_for_completion(struct backing_dev_info *bdi,
> +				   struct wb_completion *done)
> +{
> +	atomic_dec(&done->cnt);		/* put down the initial count */
> +	wait_event(bdi->wb_waitq, !atomic_read(&done->cnt));
> +}
> +
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  
>  /**
> @@ -1143,7 +1177,7 @@ static long wb_do_writeback(struct bdi_writeback *wb)
>  
>  	set_bit(WB_writeback_running, &wb->state);
>  	while ((work = get_next_work_item(wb)) != NULL) {
> -		struct completion *done = work->done;
> +		struct wb_completion *done = work->done;
>  
>  		trace_writeback_exec(wb->bdi, work);
>  
> @@ -1151,8 +1185,8 @@ static long wb_do_writeback(struct bdi_writeback *wb)
>  
>  		if (work->auto_free)
>  			kfree(work);
> -		if (done)
> -			complete(done);
> +		if (done && atomic_dec_and_test(&done->cnt))
> +			wake_up_all(&wb->bdi->wb_waitq);
>  	}
>  
>  	/*
> @@ -1518,7 +1552,7 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  			    unsigned long nr,
>  			    enum wb_reason reason)
>  {
> -	DECLARE_COMPLETION_ONSTACK(done);
> +	DEFINE_WB_COMPLETION_ONSTACK(done);
>  	struct wb_writeback_work work = {
>  		.sb			= sb,
>  		.sync_mode		= WB_SYNC_NONE,
> @@ -1533,7 +1567,7 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  	wb_queue_work(&bdi->wb, &work);
> -	wait_for_completion(&done);
> +	wb_wait_for_completion(bdi, &done);
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr);
>  
> @@ -1600,7 +1634,7 @@ EXPORT_SYMBOL(try_to_writeback_inodes_sb);
>   */
>  void sync_inodes_sb(struct super_block *sb)
>  {
> -	DECLARE_COMPLETION_ONSTACK(done);
> +	DEFINE_WB_COMPLETION_ONSTACK(done);
>  	struct wb_writeback_work work = {
>  		.sb		= sb,
>  		.sync_mode	= WB_SYNC_ALL,
> @@ -1618,7 +1652,7 @@ void sync_inodes_sb(struct super_block *sb)
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
>  	wb_queue_work(&bdi->wb, &work);
> -	wait_for_completion(&done);
> +	wb_wait_for_completion(bdi, &done);
>  
>  	wait_sb_inodes(sb);
>  }
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 8c857d7..97a92fa 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -155,6 +155,8 @@ struct backing_dev_info {
>  	struct rb_root cgwb_congested_tree; /* their congested states */
>  	atomic_t usage_cnt; /* counts both cgwbs and cgwb_contested's */
>  #endif
> +	wait_queue_head_t wb_waitq;
> +
>  	struct device *dev;
>  
>  	struct timer_list laptop_mode_wb_timer;
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index d2f16fc9..ad5608d 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -768,6 +768,7 @@ int bdi_init(struct backing_dev_info *bdi)
>  	bdi->max_ratio = 100;
>  	bdi->max_prop_frac = FPROP_FRAC_BASE;
>  	INIT_LIST_HEAD(&bdi->bdi_list);
> +	init_waitqueue_head(&bdi->wb_waitq);
>  
>  	err = wb_init(&bdi->wb, bdi, GFP_KERNEL);
>  	if (err)
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
