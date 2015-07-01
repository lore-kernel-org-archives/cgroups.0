From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 39/51] writeback: make writeback_in_progress() take
 bdi_writeback instead of backing_dev_info
Date: Wed, 1 Jul 2015 09:47:08 +0200
Message-ID: <20150701074708.GZ7252@quack.suse.cz>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-40-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432329245-5844-40-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org

On Fri 22-05-15 17:13:53, Tejun Heo wrote:
> writeback_in_progress() currently takes @bdi and returns whether
> writeback is in progress on its root wb (bdi_writeback).  In
> preparation for cgroup writeback support, make it take wb instead.
> While at it, make it an inline function.
> 
> This patch doesn't make any functional difference.

Looks good. You can add:

Reviewed-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

BTW: It would have been easier for me to review this if e.g. a move from
bdi to wb parameter was split among less patches. The intermediate state
where some functions call partly bdi and party wb functions is strange and
it always makes me go search in the series whether the other part of the
function gets converted and whether they play well together...

								Honza

> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/fs-writeback.c           | 15 +--------------
>  include/linux/backing-dev.h | 12 +++++++++++-
>  mm/page-writeback.c         |  4 ++--
>  3 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 79f11af..45baf6c 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -65,19 +65,6 @@ struct wb_writeback_work {
>   */
>  unsigned int dirtytime_expire_interval = 12 * 60 * 60;
>  
> -/**
> - * writeback_in_progress - determine whether there is writeback in progress
> - * @bdi: the device's backing_dev_info structure.
> - *
> - * Determine whether there is writeback waiting to be handled against a
> - * backing device.
> - */
> -int writeback_in_progress(struct backing_dev_info *bdi)
> -{
> -	return test_bit(WB_writeback_running, &bdi->wb.state);
> -}
> -EXPORT_SYMBOL(writeback_in_progress);
> -
>  static inline struct inode *wb_inode(struct list_head *head)
>  {
>  	return list_entry(head, struct inode, i_wb_list);
> @@ -1532,7 +1519,7 @@ int try_to_writeback_inodes_sb_nr(struct super_block *sb,
>  				  unsigned long nr,
>  				  enum wb_reason reason)
>  {
> -	if (writeback_in_progress(sb->s_bdi))
> +	if (writeback_in_progress(&sb->s_bdi->wb))
>  		return 1;
>  
>  	if (!down_read_trylock(&sb->s_umount))
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 0ff40c2..f04956c 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -156,7 +156,17 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
>  
>  extern struct backing_dev_info noop_backing_dev_info;
>  
> -int writeback_in_progress(struct backing_dev_info *bdi);
> +/**
> + * writeback_in_progress - determine whether there is writeback in progress
> + * @wb: bdi_writeback of interest
> + *
> + * Determine whether there is writeback waiting to be handled against a
> + * bdi_writeback.
> + */
> +static inline bool writeback_in_progress(struct bdi_writeback *wb)
> +{
> +	return test_bit(WB_writeback_running, &wb->state);
> +}
>  
>  static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
>  {
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 682e3a6..e3b5c1d 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1455,7 +1455,7 @@ static void balance_dirty_pages(struct address_space *mapping,
>  			break;
>  		}
>  
> -		if (unlikely(!writeback_in_progress(bdi)))
> +		if (unlikely(!writeback_in_progress(wb)))
>  			bdi_start_background_writeback(bdi);
>  
>  		if (!strictlimit)
> @@ -1573,7 +1573,7 @@ static void balance_dirty_pages(struct address_space *mapping,
>  	if (!dirty_exceeded && wb->dirty_exceeded)
>  		wb->dirty_exceeded = 0;
>  
> -	if (writeback_in_progress(bdi))
> +	if (writeback_in_progress(wb))
>  		return;
>  
>  	/*
> -- 
> 2.4.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
