From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 18/49] bdi: make inode_to_bdi() inline
Date: Mon, 20 Apr 2015 17:40:50 +0200
Message-ID: <20150420154050.GH17020@quack.suse.cz>
References: <1428350318-8215-1-git-send-email-tj@kernel.org>
 <1428350318-8215-19-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1428350318-8215-19-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon 06-04-15 15:58:07, Tejun Heo wrote:
> Now that bdi definitions are moved to backing-dev-defs.h,
> backing-dev.h can include blkdev.h and inline inode_to_bdi() without
> worrying about introducing circular include dependency.  The function
> gets called from hot paths and fairly trivial.
> 
> This patch makes inode_to_bdi() and sb_is_blkdev_sb() that the
> function calls inline.  blockdev_superblock and noop_backing_dev_info
> are EXPORT_GPL'd to allow the inline functions to be used from
> modules.
  I somewhat hate making blockdev_superblock exported just for this. But
OK.
 
> While at it, maske sb_is_blkdev_sb() return bool instead of int.
               ^^^ make

  Otherwise the patch looks good. You can add:
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza
 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  fs/block_dev.c              |  8 ++------
>  fs/fs-writeback.c           | 16 ----------------
>  include/linux/backing-dev.h | 18 ++++++++++++++++--
>  include/linux/fs.h          |  8 +++++++-
>  mm/backing-dev.c            |  1 +
>  5 files changed, 26 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index e4f5f71..875d41a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -549,7 +549,8 @@ static struct file_system_type bd_type = {
>  	.kill_sb	= kill_anon_super,
>  };
>  
> -static struct super_block *blockdev_superblock __read_mostly;
> +struct super_block *blockdev_superblock __read_mostly;
> +EXPORT_SYMBOL_GPL(blockdev_superblock);
>  
>  void __init bdev_cache_init(void)
>  {
> @@ -690,11 +691,6 @@ static struct block_device *bd_acquire(struct inode *inode)
>  	return bdev;
>  }
>  
> -int sb_is_blkdev_sb(struct super_block *sb)
> -{
> -	return sb == blockdev_superblock;
> -}
> -
>  /* Call when you free inode */
>  
>  void bd_forget(struct inode *inode)
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 7c2f0bd..4fd264d 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -66,22 +66,6 @@ int writeback_in_progress(struct backing_dev_info *bdi)
>  }
>  EXPORT_SYMBOL(writeback_in_progress);
>  
> -struct backing_dev_info *inode_to_bdi(struct inode *inode)
> -{
> -	struct super_block *sb;
> -
> -	if (!inode)
> -		return &noop_backing_dev_info;
> -
> -	sb = inode->i_sb;
> -#ifdef CONFIG_BLOCK
> -	if (sb_is_blkdev_sb(sb))
> -		return blk_get_backing_dev_info(I_BDEV(inode));
> -#endif
> -	return sb->s_bdi;
> -}
> -EXPORT_SYMBOL_GPL(inode_to_bdi);
> -
>  static inline struct inode *wb_inode(struct list_head *head)
>  {
>  	return list_entry(head, struct inode, i_wb_list);
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 5e39f7a..7857820 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -11,11 +11,10 @@
>  #include <linux/kernel.h>
>  #include <linux/fs.h>
>  #include <linux/sched.h>
> +#include <linux/blkdev.h>
>  #include <linux/writeback.h>
>  #include <linux/backing-dev-defs.h>
>  
> -struct backing_dev_info *inode_to_bdi(struct inode *inode);
> -
>  int __must_check bdi_init(struct backing_dev_info *bdi);
>  void bdi_destroy(struct backing_dev_info *bdi);
>  
> @@ -149,6 +148,21 @@ extern struct backing_dev_info noop_backing_dev_info;
>  
>  int writeback_in_progress(struct backing_dev_info *bdi);
>  
> +static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
> +{
> +	struct super_block *sb;
> +
> +	if (!inode)
> +		return &noop_backing_dev_info;
> +
> +	sb = inode->i_sb;
> +#ifdef CONFIG_BLOCK
> +	if (sb_is_blkdev_sb(sb))
> +		return blk_get_backing_dev_info(I_BDEV(inode));
> +#endif
> +	return sb->s_bdi;
> +}
> +
>  static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
>  {
>  	if (bdi->congested_fn)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b4d71b5..ccf4b64 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2205,7 +2205,13 @@ extern struct super_block *freeze_bdev(struct block_device *);
>  extern void emergency_thaw_all(void);
>  extern int thaw_bdev(struct block_device *bdev, struct super_block *sb);
>  extern int fsync_bdev(struct block_device *);
> -extern int sb_is_blkdev_sb(struct super_block *sb);
> +
> +extern struct super_block *blockdev_superblock;
> +
> +static inline bool sb_is_blkdev_sb(struct super_block *sb)
> +{
> +	return sb == blockdev_superblock;
> +}
>  #else
>  static inline void bd_forget(struct inode *inode) {}
>  static inline int sync_blockdev(struct block_device *bdev) { return 0; }
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index ff85ecb..b0707d1 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -18,6 +18,7 @@ struct backing_dev_info noop_backing_dev_info = {
>  	.name		= "noop",
>  	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
>  };
> +EXPORT_SYMBOL_GPL(noop_backing_dev_info);
>  
>  static struct class *bdi_class;
>  
> -- 
> 2.1.0
> 
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
