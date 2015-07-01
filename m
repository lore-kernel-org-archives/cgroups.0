From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 48/51] writeback: dirty inodes against their matching
 cgroup bdi_writeback's
Date: Wed, 1 Jul 2015 21:16:46 +0200
Message-ID: <20150701191646.GJ7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-49-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-49-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:14:02, Tejun Heo wrote:
> __mark_inode_dirty() always dirtied the inode against the root wb
> (bdi_writeback).  The previous patches added all the infrastructure
> necessary to attribute an inode against the wb of the dirtying cgroup.
> 
> This patch updates __mark_inode_dirty() so that it uses the wb
> associated with the inode instead of unconditionally using the root
> one.
> 
> Currently, none of the filesystems has FS_CGROUP_WRITEBACK and all
> pages will keep being dirtied against the root wb.
> 
> v2: Updated for per-inode wb association.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

								Honza

> ---
>  fs/fs-writeback.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 59d76f6..881ea5d 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1504,7 +1504,6 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
>  void __mark_inode_dirty(struct inode *inode, int flags)
>  {
>  	struct super_block *sb = inode->i_sb;
> -	struct backing_dev_info *bdi = NULL;
>  	int dirtytime;
>  
>  	trace_writeback_mark_inode_dirty(inode, flags);
> @@ -1574,30 +1573,30 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  		 * reposition it (that would break b_dirty time-ordering).
>  		 */
>  		if (!was_dirty) {
> +			struct bdi_writeback *wb = inode_to_wb(inode);
>  			struct list_head *dirty_list;
>  			bool wakeup_bdi = false;
> -			bdi = inode_to_bdi(inode);
>  
>  			spin_unlock(&inode->i_lock);
> -			spin_lock(&bdi->wb.list_lock);
> +			spin_lock(&wb->list_lock);
>  
> -			WARN(bdi_cap_writeback_dirty(bdi) &&
> -			     !test_bit(WB_registered, &bdi->wb.state),
> -			     "bdi-%s not registered\n", bdi->name);
> +			WARN(bdi_cap_writeback_dirty(wb->bdi) &&
> +			     !test_bit(WB_registered, &wb->state),
> +			     "bdi-%s not registered\n", wb->bdi->name);
>  
>  			inode->dirtied_when = jiffies;
>  			if (dirtytime)
>  				inode->dirtied_time_when = jiffies;
>  
>  			if (inode->i_state & (I_DIRTY_INODE | I_DIRTY_PAGES))
> -				dirty_list = &bdi->wb.b_dirty;
> +				dirty_list = &wb->b_dirty;
>  			else
> -				dirty_list = &bdi->wb.b_dirty_time;
> +				dirty_list = &wb->b_dirty_time;
>  
> -			wakeup_bdi = inode_wb_list_move_locked(inode, &bdi->wb,
> +			wakeup_bdi = inode_wb_list_move_locked(inode, wb,
>  							       dirty_list);
>  
> -			spin_unlock(&bdi->wb.list_lock);
> +			spin_unlock(&wb->list_lock);
>  			trace_writeback_dirty_inode_enqueue(inode);
>  
>  			/*
> @@ -1606,8 +1605,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  			 * to make sure background write-back happens
>  			 * later.
>  			 */
> -			if (bdi_cap_writeback_dirty(bdi) && wakeup_bdi)
> -				wb_wakeup_delayed(&bdi->wb);
> +			if (bdi_cap_writeback_dirty(wb->bdi) && wakeup_bdi)
> +				wb_wakeup_delayed(wb);
>  			return;
>  		}
>  	}
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
