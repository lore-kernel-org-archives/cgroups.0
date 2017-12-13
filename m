From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] writeback: synchronize sync(2) against cgroup
 writeback membership switches
Date: Wed, 13 Dec 2017 12:00:04 +0100
Message-ID: <20171213110004.GB23068@quack2.suse.cz>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
 <20171211195052.GN2421075@devbig577.frc2.facebook.com>
 <20171212163830.GC3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171212163830.GC3919388-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 12-12-17 08:38:30, Tejun Heo wrote:
> sync_inodes_sb() can race against cgwb (cgroup writeback) membership
> switches and fail to writeback some inodes.  For example, if an inode
> switches to another wb while sync_inodes_sb() is in progress, the new
> wb might not be visible to bdi_split_work_to_wbs() at all or the inode
> might jump from a wb which hasn't issued writebacks yet to one which
> already has.
> 
> This patch adds backing_dev_info->wb_switch_rwsem to synchronize cgwb
> switch path against sync_inodes_sb() so that sync_inodes_sb() is
> guaranteed to see all the target wbs and inodes can't jump wbs to
> escape syncing.
> 
> v2: Fixed misplaced rwsem init.  Spotted by Jiufei.

OK, but this effectively prevents writeback from sync_inodes_sb() to ever
make inode switch wbs. Cannot that be abused in some way like making sure
writeback of our memcg is "invisible" by forcing it out using sync(2)? It
just looks a bit dangerous to me...

								Honza

> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Jiufei Xue <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Link: http://lkml.kernel.org/r/dc694ae2-f07f-61e1-7097-7c8411cee12d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> ---
>  fs/fs-writeback.c                |   40 +++++++++++++++++++++++++++++++++++++--
>  include/linux/backing-dev-defs.h |    1 
>  mm/backing-dev.c                 |    1 
>  3 files changed, 40 insertions(+), 2 deletions(-)
> 
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -331,11 +331,22 @@ struct inode_switch_wbs_context {
>  	struct work_struct	work;
>  };
>  
> +static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi)
> +{
> +	down_write(&bdi->wb_switch_rwsem);
> +}
> +
> +static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi)
> +{
> +	up_write(&bdi->wb_switch_rwsem);
> +}
> +
>  static void inode_switch_wbs_work_fn(struct work_struct *work)
>  {
>  	struct inode_switch_wbs_context *isw =
>  		container_of(work, struct inode_switch_wbs_context, work);
>  	struct inode *inode = isw->inode;
> +	struct backing_dev_info *bdi = inode_to_bdi(inode);
>  	struct address_space *mapping = inode->i_mapping;
>  	struct bdi_writeback *old_wb = inode->i_wb;
>  	struct bdi_writeback *new_wb = isw->new_wb;
> @@ -344,6 +355,12 @@ static void inode_switch_wbs_work_fn(str
>  	void **slot;
>  
>  	/*
> +	 * If @inode switches cgwb membership while sync_inodes_sb() is
> +	 * being issued, sync_inodes_sb() might miss it.  Synchronize.
> +	 */
> +	down_read(&bdi->wb_switch_rwsem);
> +
> +	/*
>  	 * By the time control reaches here, RCU grace period has passed
>  	 * since I_WB_SWITCH assertion and all wb stat update transactions
>  	 * between unlocked_inode_to_wb_begin/end() are guaranteed to be
> @@ -435,6 +452,8 @@ skip_switch:
>  	spin_unlock(&new_wb->list_lock);
>  	spin_unlock(&old_wb->list_lock);
>  
> +	up_read(&bdi->wb_switch_rwsem);
> +
>  	if (switched) {
>  		wb_wakeup(new_wb);
>  		wb_put(old_wb);
> @@ -475,9 +494,18 @@ static void inode_switch_wbs(struct inod
>  	if (inode->i_state & I_WB_SWITCH)
>  		return;
>  
> +	/*
> +	 * Avoid starting new switches while sync_inodes_sb() is in
> +	 * progress.  Otherwise, if the down_write protected issue path
> +	 * blocks heavily, we might end up starting a large number of
> +	 * switches which will block on the rwsem.
> +	 */
> +	if (!down_read_trylock(&bdi->wb_switch_rwsem))
> +		return;
> +
>  	isw = kzalloc(sizeof(*isw), GFP_ATOMIC);
>  	if (!isw)
> -		return;
> +		goto out_unlock;
>  
>  	/* find and pin the new wb */
>  	rcu_read_lock();
> @@ -511,12 +539,14 @@ static void inode_switch_wbs(struct inod
>  	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
>  	 */
>  	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
> -	return;
> +	goto out_unlock;
>  
>  out_free:
>  	if (isw->new_wb)
>  		wb_put(isw->new_wb);
>  	kfree(isw);
> +out_unlock:
> +	up_read(&bdi->wb_switch_rwsem);
>  }
>  
>  /**
> @@ -893,6 +923,9 @@ fs_initcall(cgroup_writeback_init);
>  
>  #else	/* CONFIG_CGROUP_WRITEBACK */
>  
> +static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
> +static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi) { }
> +
>  static struct bdi_writeback *
>  locked_inode_to_wb_and_lock_list(struct inode *inode)
>  	__releases(&inode->i_lock)
> @@ -2422,8 +2455,11 @@ void sync_inodes_sb(struct super_block *
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> +	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
> +	bdi_down_write_wb_switch_rwsem(bdi);
>  	bdi_split_work_to_wbs(bdi, &work, false);
>  	wb_wait_for_completion(bdi, &done);
> +	bdi_up_write_wb_switch_rwsem(bdi);
>  
>  	wait_sb_inodes(sb);
>  }
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -189,6 +189,7 @@ struct backing_dev_info {
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
>  	struct rb_root cgwb_congested_tree; /* their congested states */
> +	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
>  #else
>  	struct bdi_writeback_congested *wb_congested;
>  #endif
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -706,6 +706,7 @@ static int cgwb_bdi_init(struct backing_
>  
>  	INIT_RADIX_TREE(&bdi->cgwb_tree, GFP_ATOMIC);
>  	bdi->cgwb_congested_tree = RB_ROOT;
> +	init_rwsem(&bdi->wb_switch_rwsem);
>  
>  	ret = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
>  	if (!ret) {
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
