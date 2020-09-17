From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/12] fs: remove the unused SB_I_MULTIROOT flag
Date: Thu, 17 Sep 2020 11:41:13 +0200
Message-ID: <20200917094113.GH7347@quack2.suse.cz>
References: <20200910144833.742260-1-hch@lst.de>
 <20200910144833.742260-2-hch@lst.de>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200910144833.742260-2-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>

On Thu 10-09-20 16:48:21, Christoph Hellwig wrote:
> The last user of SB_I_MULTIROOT is disappeared with commit f2aedb713c28
> ("NFS: Add fs_context support.")
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Nice. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/namei.c         | 4 ++--
>  include/linux/fs.h | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index e99e2a9da0f7de..f1eb8ccd2be958 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -568,8 +568,8 @@ static bool path_connected(struct vfsmount *mnt, struct dentry *dentry)
>  {
>  	struct super_block *sb = mnt->mnt_sb;
>  
> -	/* Bind mounts and multi-root filesystems can have disconnected paths */
> -	if (!(sb->s_iflags & SB_I_MULTIROOT) && (mnt->mnt_root == sb->s_root))
> +	/* Bind mounts can have disconnected paths */
> +	if (mnt->mnt_root == sb->s_root)
>  		return true;
>  
>  	return is_subdir(dentry, mnt->mnt_root);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7519ae003a082c..fbd74df5ce5f34 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1385,7 +1385,6 @@ extern int send_sigurg(struct fown_struct *fown);
>  #define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
>  #define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
>  #define SB_I_NODEV	0x00000004	/* Ignore devices on this fs */
> -#define SB_I_MULTIROOT	0x00000008	/* Multiple roots to the dentry tree */
>  
>  /* sb->s_iflags to limit user namespace mounts */
>  #define SB_I_USERNS_VISIBLE		0x00000010 /* fstype already mounted */
> -- 
> 2.28.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
