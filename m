From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 34/51] writeback: don't issue wb_writeback_work if clean
Date: Tue, 30 Jun 2015 18:18:03 +0200
Message-ID: <20150630161803.GS7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-35-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-35-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:48, Tejun Heo wrote:
> There are several places in fs/fs-writeback.c which queues
> wb_writeback_work without checking whether the target wb
> (bdi_writeback) has dirty inodes or not.  The only thing
> wb_writeback_work does is writing back the dirty inodes for the target
> wb and queueing a work item for a clean wb is essentially noop.  There
> are some side effects such as bandwidth stats being updated and
> triggering tracepoints but these don't affect the operation in any
> meaningful way.
> 
> This patch makes all writeback_inodes_sb_nr() and sync_inodes_sb()
> skip wb_queue_work() if the target bdi is clean.  Also, it moves
> dirtiness check from wakeup_flusher_threads() to
> __wb_start_writeback() so that all its callers benefit from the check.
> 
> While the overhead incurred by scheduling a noop work isn't currently
> significant, the overhead may be higher with cgroup writeback support
> as we may end up issuing noop work items to a lot of clean wb's.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza

> ---
>  fs/fs-writeback.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index c98d392..921a9e4 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -189,6 +189,9 @@ static void __wb_start_writeback(struct bdi_writeback *wb, long nr_pages,
>  {
>  	struct wb_writeback_work *work;
>  
> +	if (!wb_has_dirty_io(wb))
> +		return;
> +
>  	/*
>  	 * This is WB_SYNC_NONE writeback, so if allocation fails just
>  	 * wakeup the thread for old dirty data writeback
> @@ -1215,11 +1218,8 @@ void wakeup_flusher_threads(long nr_pages, enum wb_reason reason)
>  		nr_pages = get_nr_dirty_pages();
>  
>  	rcu_read_lock();
> -	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
> -		if (!bdi_has_dirty_io(bdi))
> -			continue;
> +	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list)
>  		__wb_start_writeback(&bdi->wb, nr_pages, false, reason);
> -	}
>  	rcu_read_unlock();
>  }
>  
> @@ -1512,11 +1512,12 @@ void writeback_inodes_sb_nr(struct super_block *sb,
>  		.nr_pages		= nr,
>  		.reason			= reason,
>  	};
> +	struct backing_dev_info *bdi = sb->s_bdi;
>  
> -	if (sb->s_bdi == &noop_backing_dev_info)
> +	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> -	wb_queue_work(&sb->s_bdi->wb, &work);
> +	wb_queue_work(&bdi->wb, &work);
>  	wait_for_completion(&done);
>  }
>  EXPORT_SYMBOL(writeback_inodes_sb_nr);
> @@ -1594,13 +1595,14 @@ void sync_inodes_sb(struct super_block *sb)
>  		.reason		= WB_REASON_SYNC,
>  		.for_sync	= 1,
>  	};
> +	struct backing_dev_info *bdi = sb->s_bdi;
>  
>  	/* Nothing to do? */
> -	if (sb->s_bdi == &noop_backing_dev_info)
> +	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> -	wb_queue_work(&sb->s_bdi->wb, &work);
> +	wb_queue_work(&bdi->wb, &work);
>  	wait_for_completion(&done);
>  
>  	wait_sb_inodes(sb);
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
