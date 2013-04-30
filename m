From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 10/31] dcache: convert to use new lru list
 infrastructure
Date: Tue, 30 Apr 2013 17:04:11 +0100
Message-ID: <20130430160411.GJ6415@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-11-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367018367-11278-11-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Apr 27, 2013 at 03:19:06AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> [ glommer: don't reintroduce double decrement of nr_unused_dentries,
>   adapted for new LRU return codes ]
> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>
> <SNIP>
>
> @@ -361,35 +347,19 @@ static void dentry_lru_del(struct dentry *dentry)
>   */
>  static void dentry_lru_prune(struct dentry *dentry)
>  {
> -	if (!list_empty(&dentry->d_lru)) {
> +	int prune = dentry->d_flags & DCACHE_OP_PRUNE;
>  
> -		if (dentry->d_flags & DCACHE_OP_PRUNE)
> -			dentry->d_op->d_prune(dentry);
> -
> -		if ((dentry->d_flags & DCACHE_SHRINK_LIST))
> -			list_del_init(&dentry->d_lru);
> -		else {
> -			spin_lock(&dentry->d_sb->s_dentry_lru_lock);
> -			__dentry_lru_del(dentry);
> -			spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
> -		}
> -		dentry->d_flags &= ~DCACHE_SHRINK_LIST;
> -	}
> -}
> -
> -static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
> -{
> -	BUG_ON(dentry->d_flags & DCACHE_SHRINK_LIST);
> -
> -	spin_lock(&dentry->d_sb->s_dentry_lru_lock);
> -	if (list_empty(&dentry->d_lru)) {
> -		list_add_tail(&dentry->d_lru, list);
> -	} else {
> -		list_move_tail(&dentry->d_lru, list);
> -		dentry->d_sb->s_nr_dentry_unused--;
> +	if (!list_empty(&dentry->d_lru) &&
> +	    (dentry->d_flags & DCACHE_SHRINK_LIST))
> +		list_del_init(&dentry->d_lru);
> +	else if (list_lru_del(&dentry->d_sb->s_dentry_lru, &dentry->d_lru))
>  		this_cpu_dec(nr_dentry_unused);
> -	}
> -	spin_unlock(&dentry->d_sb->s_dentry_lru_lock);
> +	else
> +		prune = 0;
> +
> +	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
> +	if (prune)
> +		dentry->d_op->d_prune(dentry);
>  }
>  

It's a bit clearer now why list_lru_del deals with the object already
being deleted from the LRU. It's somewhat specific to the case where
an object on an LRU can also be looked up via an independent structure.
It's up to the user of list_lru to figure it out.

> <SNIP>
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 89cda65..fc47371 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1264,14 +1264,6 @@ struct super_block {
>  	struct list_head	s_files;
>  #endif
>  	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
> -
> -	/* s_dentry_lru_lock protects s_dentry_lru and s_nr_dentry_unused */
> -	spinlock_t		s_dentry_lru_lock ____cacheline_aligned_in_smp;
> -	struct list_head	s_dentry_lru;	/* unused dentry lru */
> -	int			s_nr_dentry_unused;	/* # of dentry on lru */
> -
> -	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
> -
>  	struct block_device	*s_bdev;
>  	struct backing_dev_info *s_bdi;
>  	struct mtd_info		*s_mtd;
> @@ -1322,6 +1314,13 @@ struct super_block {
>  
>  	/* Being remounted read-only */
>  	int s_readonly_remount;
> +
> +	/*
> +	 * Keep the lru lists last in the structure so they always sit on their
> +	 * own individual cachelines.
> +	 */
> +	struct list_lru		s_dentry_lru ____cacheline_aligned_in_smp;
> +	struct list_lru		s_inode_lru ____cacheline_aligned_in_smp;
>  };
>  

To save wasting space you could also put them each beside otherwise
read-mostly data, before s_mounts (per-cpu data before it should be
cache-aligned) and anywhere near the end of the structure without the
cache alignment directives.

Otherwise nothing jumped at me.

-- 
Mel Gorman
SUSE Labs
