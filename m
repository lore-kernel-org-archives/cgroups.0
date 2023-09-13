From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 10/19] USB: gadget/legacy: remove sb_mutex
Date: Wed, 13 Sep 2023 12:10:56 -0400
Message-ID: <7f839be1-4898-41ad-8eda-10d5a0350bdf@rowland.harvard.edu>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-11-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-11-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linu

On Wed, Sep 13, 2023 at 08:10:04AM -0300, Christoph Hellwig wrote:
> Creating new a new super_block vs freeing the old one for single instance
> file systems is serialized by the wait for SB_DEAD.
> 
> Remove the superfluous sb_mutex.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

You might mention that this is essentially a reversion of commit 
d18dcfe9860e ("USB: gadgetfs: Fix race between mounting and 
unmounting").

Alan Stern

>  drivers/usb/gadget/legacy/inode.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
> index ce9e31f3d26bcc..a203266bc0dc82 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -229,7 +229,6 @@ static void put_ep (struct ep_data *data)
>   */
>  
>  static const char *CHIP;
> -static DEFINE_MUTEX(sb_mutex);		/* Serialize superblock operations */
>  
>  /*----------------------------------------------------------------------*/
>  
> @@ -2012,8 +2011,6 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
>  	struct dev_data	*dev;
>  	int		rc;
>  
> -	mutex_lock(&sb_mutex);
> -
>  	if (the_device) {
>  		rc = -ESRCH;
>  		goto Done;
> @@ -2069,7 +2066,6 @@ gadgetfs_fill_super (struct super_block *sb, struct fs_context *fc)
>  	rc = -ENOMEM;
>  
>   Done:
> -	mutex_unlock(&sb_mutex);
>  	return rc;
>  }
>  
> @@ -2092,7 +2088,6 @@ static int gadgetfs_init_fs_context(struct fs_context *fc)
>  static void
>  gadgetfs_kill_sb (struct super_block *sb)
>  {
> -	mutex_lock(&sb_mutex);
>  	kill_litter_super (sb);
>  	if (the_device) {
>  		put_dev (the_device);
> @@ -2100,7 +2095,6 @@ gadgetfs_kill_sb (struct super_block *sb)
>  	}
>  	kfree(CHIP);
>  	CHIP = NULL;
> -	mutex_unlock(&sb_mutex);
>  }
>  
>  /*----------------------------------------------------------------------*/
> -- 
> 2.39.2
> 
