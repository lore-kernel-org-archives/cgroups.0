From: xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] writeback: synchronize sync(2) against cgroup writeback
 membership switches
Date: Tue, 12 Dec 2017 14:04:45 +0800
Message-ID: <ca999c10-5e8d-2bb1-c872-70bf13666849@gmail.com>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
 <20171211195052.GN2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nM8QCW+ptnhNXZdn4dEQLyzhavrKPjxww95Kq6mISW8=;
        b=oGEiocexeaT0nBId4fEGHWG6xnj0DIy9MeU/QOjVYi49Yr7P8NMp/zS5goLs7qCa5Z
         la2TUo4OpW7cLmqvCzcct3Hn5TR6+DIf/mF8lQLK8F5OmgIN+dl2Y6WjUffVPxYZlRWy
         vgn/dNqgwf3H1jTJm27M17VYsa1o6UrJEczVU9vL2feUeuW7fKxuJjPS67d6COlxbej4
         qzHpP0A/BLvDPl7uW3GR+9pnsmlTjt+P9qRUyEnEqpukLYJ7bSI9DMgvyBPlEPNJr5m5
         mwVUakqZhigJi4YVQ087zMgjHwA9owof3Id1/LKbULWNEA6DnMBf6gp+XArS1yy7sdfj
         7zGw==
In-Reply-To: <20171211195052.GN2421075-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On 2017/12/12 上午3:50, Tejun Heo wrote:
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
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Jiufei Xue <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Link: http://lkml.kernel.org/r/dc694ae2-f07f-61e1-7097-7c8411cee12d-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> ---
>  fs/fs-writeback.c                |   50 +++++++++++++++++++++++++++++++++++++--
>  include/linux/backing-dev-defs.h |    1 
>  mm/backing-dev.c                 |    3 ++
>  3 files changed, 52 insertions(+), 2 deletions(-)
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
> @@ -2422,8 +2455,21 @@ void sync_inodes_sb(struct super_block *
>  		return;
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
> +	/*
> +	 * Protect against inode wb switch in inode_switch_wbs_work_fn().
> +	 * We want to synchronize syncs against switches.  Synchronizing
> +	 * among syncs isn't necessary but it shouldn't matter especially
> +	 * as we're only protecting the issuing.
> +	 *
> +	 * Once we grab the rwsem, bdi_split_work_to_wbs() is guaranteed to
> +	 * see all the target wbs.  If the wb membership hasn't changed,
> +	 * through the ordering visible to the caller; otherwise, through
> +	 * the transitive ordering via the rwsem.
> +	 */
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
> @@ -813,6 +813,9 @@ static int cgwb_bdi_init(struct backing_
>  		wb_congested_put(bdi->wb_congested);
>  		return err;
>  	}
> +
> +	init_rwsem(&bdi->wb_switch_rwsem);
> +

The initialization of wb_switch_rwsem should be in
the conditional compilation of CONFIG_CGROUP_WRITEBACK,
right?

Thanks.

Xuejiufei
>  	return 0;
>  }
>  
> 
