From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 09/19] zonefs: remove duplicate cleanup in
 zonefs_fill_super
Date: Thu, 14 Sep 2023 01:49:00 +0100
Message-ID: <20230914004900.GE800259@ZenIV>
References: <20230913111013.77623-1-hch@lst.de>
 <20230913111013.77623-10-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xd391DCoeJ0otc/wf6vG0zsYE7F5JC70Mi4jJ3xxJjA=; b=n+22JQMYrzItCb/bwKW0Rb/EJQ
        dwFQ8VSaoXqFBijd/Rd/ooWBNw3vLTu30WBEOhDvT25Q9qgRGG9JfuYzPT3UBPnlm2wCqNzCbO7By
        /iUao6NvaaDgKy8WqMgyBgZe3PZG5V5K+OO+orKOctFo1R9Jwb0SvwLw1aa6eobFX7cvJ9EUVmiLt
        gUDGMOe6eZXghVfiDysquUEc88hQJtc6ceYa23j0V58Q80ZcLI+tO/8o95/IQTOWF73wWpogK/bNA
        rNc7xLccZRUaK6i9AJPcd8KpubW/XLwjGB4f7jxGjXwh5jFtZxGCgzjUMnzyR95jfPksEubQg1Cpw
        Kuq5FGvA==;
Content-Disposition: inline
In-Reply-To: <20230913111013.77623-10-hch-jcswGhMUV9g@public.gmane.org>
Sender: Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reinette Chatre <reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Miquel Raynal <miquel.raynal-LDxbnhwyfcJBDgjK7y7TUQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vignesh Raghavendra <vigneshr-l0cyMroinI0@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ntyVByD3zXaTtA8H5PvdGFaTQe2KTcn/@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Trond Myklebust <trond.myklebust-F/q8l9xzQnoyLce1RVWEUA@public.gmane.org>, Anna Schumaker <anna-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Damien Le Moal <dlemoal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Naohiro Aota <naohiro.aota-Sjgp3cTcYWE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s39

On Wed, Sep 13, 2023 at 08:10:03AM -0300, Christoph Hellwig wrote:
> When ->fill_super fails, ->kill_sb is called which already cleans up
> the inodes and zgroups.

Ugh...  The use of "->" strongly suggests that you are talking about
a method; 'fill_super' here actually refers to callback passed to
mount_bdev().  Have a pity for those who'll be trying to parse it
- that might be yourself a couple of years down the road...

Something like

"If zonefs_fill_super() returns an error, its caller (mount_bdev()) will
make sure to call zonefs_kill_super(), which already cleans up
the inodes and zgroups.", perhaps?

> 
> Drop the extra cleanup code in zonefs_fill_super.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  fs/zonefs/super.c | 21 +++++----------------
>  1 file changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 9d1a9808fbbba6..35b2554ce2ac2e 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1309,13 +1309,12 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	/* Initialize the zone groups */
>  	ret = zonefs_init_zgroups(sb);
>  	if (ret)
> -		goto cleanup;
> +		return ret;
>  
>  	/* Create the root directory inode */
> -	ret = -ENOMEM;
>  	inode = new_inode(sb);
>  	if (!inode)
> -		goto cleanup;
> +		return -ENOMEM;
>  
>  	inode->i_ino = bdev_nr_zones(sb->s_bdev);
>  	inode->i_mode = S_IFDIR | 0555;
> @@ -1333,7 +1332,7 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	sb->s_root = d_make_root(inode);
>  	if (!sb->s_root)
> -		goto cleanup;
> +		return -ENOMEM;
>  
>  	/*
>  	 * Take a reference on the zone groups directory inodes
> @@ -1341,19 +1340,9 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
>  	 */
>  	ret = zonefs_get_zgroup_inodes(sb);
>  	if (ret)
> -		goto cleanup;
> -
> -	ret = zonefs_sysfs_register(sb);
> -	if (ret)
> -		goto cleanup;
> -
> -	return 0;
> -
> -cleanup:
> -	zonefs_release_zgroup_inodes(sb);
> -	zonefs_free_zgroups(sb);
> +		return ret;
>  
> -	return ret;
> +	return zonefs_sysfs_register(sb);
>  }
>  
>  static struct dentry *zonefs_mount(struct file_system_type *fs_type,
> -- 
> 2.39.2
> 
