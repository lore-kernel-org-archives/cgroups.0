From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v6 1/5] writeback, cgroup: switch to rcu_work API in
 inode_switch_wbs()
Date: Thu, 3 Jun 2021 10:46:39 +0200
Message-ID: <20210603084639.GD23647@quack2.suse.cz>
References: <20210603005517.1403689-1-guro@fb.com>
 <20210603005517.1403689-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622710000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZGYew5SGmdoU7MaUMjCQJu6CUQQRyZgDm/ugr7FJkik=;
        b=UPdBAscVGcKfIB7r1rdiArP5E4b1W4s6cD6RmUVdMU5EgYQRCbmCPX7Qkx+g1xCdv/3Rdi
        DHnBiT88YrNR5y8rcINSabGbteTumqIaq9E3RRuJ6ahND8FbdUOgIS/PT2NnG8ZwaJDVrx
        Y57qWHI1PWHfiAByh8IrKX8SDb9DVv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622710000;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZGYew5SGmdoU7MaUMjCQJu6CUQQRyZgDm/ugr7FJkik=;
        b=8rGAUYu9J4Ro+7/kzBAGvQIRAbyD6+G0cvtEO8GNulsXy0sRHYzt0/SPREI5C17fltgMAS
        ktPOPIOwHMbo7CCg==
Content-Disposition: inline
In-Reply-To: <20210603005517.1403689-2-guro@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org

On Wed 02-06-21 17:55:13, Roman Gushchin wrote:
> Inode's wb switching requires two steps divided by an RCU grace
> period. It's currently implemented as an RCU callback
> inode_switch_wbs_rcu_fn(), which schedules inode_switch_wbs_work_fn()
> as a work.
> 
> Switching to the rcu_work API allows to do the same in a cleaner and
> slightly shorter form.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e91980f49388..1f51857e41d1 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -335,8 +335,7 @@ struct inode_switch_wbs_context {
>  	struct inode		*inode;
>  	struct bdi_writeback	*new_wb;
>  
> -	struct rcu_head		rcu_head;
> -	struct work_struct	work;
> +	struct rcu_work		work;
>  };
>  
>  static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi)
> @@ -352,7 +351,7 @@ static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi)
>  static void inode_switch_wbs_work_fn(struct work_struct *work)
>  {
>  	struct inode_switch_wbs_context *isw =
> -		container_of(work, struct inode_switch_wbs_context, work);
> +		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
>  	struct inode *inode = isw->inode;
>  	struct backing_dev_info *bdi = inode_to_bdi(inode);
>  	struct address_space *mapping = inode->i_mapping;
> @@ -469,16 +468,6 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
>  	atomic_dec(&isw_nr_in_flight);
>  }
>  
> -static void inode_switch_wbs_rcu_fn(struct rcu_head *rcu_head)
> -{
> -	struct inode_switch_wbs_context *isw = container_of(rcu_head,
> -				struct inode_switch_wbs_context, rcu_head);
> -
> -	/* needs to grab bh-unsafe locks, bounce to work item */
> -	INIT_WORK(&isw->work, inode_switch_wbs_work_fn);
> -	queue_work(isw_wq, &isw->work);
> -}
> -
>  /**
>   * inode_switch_wbs - change the wb association of an inode
>   * @inode: target inode
> @@ -534,7 +523,8 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
>  	 * lock so that stat transfer can synchronize against them.
>  	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
>  	 */
> -	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
> +	INIT_RCU_WORK(&isw->work, inode_switch_wbs_work_fn);
> +	queue_rcu_work(isw_wq, &isw->work);
>  
>  	atomic_inc(&isw_nr_in_flight);
>  	return;
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
