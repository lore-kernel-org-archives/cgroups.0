From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v7 1/6] writeback, cgroup: do not switch inodes with
 I_WILL_FREE flag
Date: Mon, 7 Jun 2021 10:48:31 +0200
Message-ID: <20210607084831.GA30275@quack2.suse.cz>
References: <20210604013159.3126180-1-guro@fb.com>
 <20210604013159.3126180-2-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623055712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2naVyNld0ZhkvsKE1x+NGtELQ4K5HYayJF8p+hq+SbA=;
        b=tlwLnyGH7VawMI7TcGGozb5AZI4f7IC46ovtT2AQ/LyWGYibtVAvNF61Pouzn6rmQe9dnK
        XB60/c9yqXN5aYWMOfzBtQqDArsCUjRLtBa9BYxnUdt+gGzSHAfHj4zcmH3Tls8GUWaGSZ
        NKxENUvyEJ91B0t2QNZlD3DoWNZyw+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623055712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2naVyNld0ZhkvsKE1x+NGtELQ4K5HYayJF8p+hq+SbA=;
        b=VO25FqWanA88lV8Aezh36mNO3tBqzGfACUq9loSFJ3S7BQUk14Om3e22ixlhnFVZDCMHfi
        2L0GG4lBbKUVk4DQ==
Content-Disposition: inline
In-Reply-To: <20210604013159.3126180-2-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 03-06-21 18:31:54, Roman Gushchin wrote:
> If an inode's state has I_WILL_FREE flag set, the inode will be
> freed soon, so there is no point in trying to switch the inode
> to a different cgwb.
> 
> I_WILL_FREE was ignored since the introduction of the inode switching,
> so it looks like it doesn't lead to any noticeable issues for a user.
> This is why the patch is not intended for a stable backport.
> 
> Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/fs-writeback.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e91980f49388..bd99890599e0 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -389,10 +389,10 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
>  	xa_lock_irq(&mapping->i_pages);
>  
>  	/*
> -	 * Once I_FREEING is visible under i_lock, the eviction path owns
> -	 * the inode and we shouldn't modify ->i_io_list.
> +	 * Once I_FREEING or I_WILL_FREE are visible under i_lock, the eviction
> +	 * path owns the inode and we shouldn't modify ->i_io_list.
>  	 */
> -	if (unlikely(inode->i_state & I_FREEING))
> +	if (unlikely(inode->i_state & (I_FREEING | I_WILL_FREE)))
>  		goto skip_switch;
>  
>  	trace_inode_switch_wbs(inode, old_wb, new_wb);
> @@ -517,7 +517,7 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
>  	/* while holding I_WB_SWITCH, no one else can update the association */
>  	spin_lock(&inode->i_lock);
>  	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
> -	    inode->i_state & (I_WB_SWITCH | I_FREEING) ||
> +	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
>  	    inode_to_wb(inode) == isw->new_wb) {
>  		spin_unlock(&inode->i_lock);
>  		goto out_free;
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
