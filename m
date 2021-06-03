From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v6 3/5] writeback, cgroup: split out the functional part
 of inode_switch_wbs_work_fn()
Date: Thu, 3 Jun 2021 10:57:47 +0200
Message-ID: <20210603085747.GF23647@quack2.suse.cz>
References: <20210603005517.1403689-1-guro@fb.com>
 <20210603005517.1403689-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622710668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9sDgb2emqxYptX4dZY9/zDI4UOgLdVYYIQHPfS6+CF8=;
        b=KmJzr1J1myTp5jdxv36oVqaDps4jrGcdLt7HVHm6Rojl8scqhDwIgAwqGBhQu7GLL63uTs
        wNIpR08sqqmJC0ZURSzsPZzjgY8788AO3BwYKh2qk8Suzd5UW7DzC4HoH7CDilTQkaeTSf
        1qQ6+0Xb4Rpf63S9QkgWd2VD1oM6+/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622710668;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9sDgb2emqxYptX4dZY9/zDI4UOgLdVYYIQHPfS6+CF8=;
        b=R9Tg+TsvkEsLSruud73rOCf4IqRCfMpQzTyhB11G/1qRomiz9EbadycD7gnCmGaI1Sx9xQ
        nC8g688z9lHro6Bg==
Content-Disposition: inline
In-Reply-To: <20210603005517.1403689-4-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 02-06-21 17:55:15, Roman Gushchin wrote:
> Split out the functional part of the inode_switch_wbs_work_fn()
> function as inode_do switch_wbs() to reuse it later for switching
                      ^ underscore here

> inodes attached to dying cgwbs.
> 
> This commit doesn't bring any functional changes.
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

The patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza

> ---
>  fs/fs-writeback.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 09d2770449ef..212494d89cc2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -351,15 +351,12 @@ static void bdi_up_write_wb_switch_rwsem(struct backing_dev_info *bdi)
>  	up_write(&bdi->wb_switch_rwsem);
>  }
>  
> -static void inode_switch_wbs_work_fn(struct work_struct *work)
> +static void inode_do_switch_wbs(struct inode *inode,
> +				struct bdi_writeback *new_wb)
>  {
> -	struct inode_switch_wbs_context *isw =
> -		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
> -	struct inode *inode = isw->inode;
>  	struct backing_dev_info *bdi = inode_to_bdi(inode);
>  	struct address_space *mapping = inode->i_mapping;
>  	struct bdi_writeback *old_wb = inode->i_wb;
> -	struct bdi_writeback *new_wb = isw->new_wb;
>  	XA_STATE(xas, &mapping->i_pages, 0);
>  	struct page *page;
>  	bool switched = false;
> @@ -470,11 +467,17 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
>  		wb_wakeup(new_wb);
>  		wb_put(old_wb);
>  	}
> -	wb_put(new_wb);
> +}
>  
> -	iput(inode);
> -	kfree(isw);
> +static void inode_switch_wbs_work_fn(struct work_struct *work)
> +{
> +	struct inode_switch_wbs_context *isw =
> +		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work);
>  
> +	inode_do_switch_wbs(isw->inode, isw->new_wb);
> +	wb_put(isw->new_wb);
> +	iput(isw->inode);
> +	kfree(isw);
>  	atomic_dec(&isw_nr_in_flight);
>  }
>  
> -- 
> 2.31.1
> 
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
