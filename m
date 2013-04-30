From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v4 04/31] dentry: move to per-sb LRU locks
Date: Tue, 30 Apr 2013 15:01:44 +0100
Message-ID: <20130430140144.GD6415@suse.de>
References: <1367018367-11278-1-git-send-email-glommer@openvz.org>
 <1367018367-11278-5-git-send-email-glommer@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1367018367-11278-5-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Apr 27, 2013 at 03:19:00AM +0400, Glauber Costa wrote:
> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> With the dentry LRUs being per-sb structures, there is no real need
> for a global dentry_lru_lock. The locking can be made more
> fine-grained by moving to a per-sb LRU lock, isolating the LRU
> operations of different filesytsems completely from each other.
> 
> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

But one comment below

> @@ -81,7 +81,6 @@
>  int sysctl_vfs_cache_pressure __read_mostly = 100;
>  EXPORT_SYMBOL_GPL(sysctl_vfs_cache_pressure);
>  
> -static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_lru_lock);
>  __cacheline_aligned_in_smp DEFINE_SEQLOCK(rename_lock);
>  
>  EXPORT_SYMBOL(rename_lock);

It made sense to cache-align these locks because you don't want two
unrelated global locks causing each other to bounce but ....

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8d47c9a..df3174d 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1263,7 +1263,9 @@ struct super_block {
>  	struct list_head	s_files;
>  #endif
>  	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
> -	/* s_dentry_lru, s_nr_dentry_unused protected by dcache.c lru locks */
> +
> +	/* s_dentry_lru_lock protects s_dentry_lru and s_nr_dentry_unused */
> +	spinlock_t		s_dentry_lru_lock ____cacheline_aligned_in_smp;
>  	struct list_head	s_dentry_lru;	/* unused dentry lru */
>  	int			s_nr_dentry_unused;	/* # of dentry on lru */
>  

It's less compelling to align within a structure like this. If move the
lock and the fields it protects to a read-mostly section then there
should be no need to cache-align the lock, create a large hole in the
struct and grow the size of struct super_block unnecessarily.

-- 
Mel Gorman
SUSE Labs
