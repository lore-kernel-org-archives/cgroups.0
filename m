From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v13 09/16] fs: consolidate {nr,free}_cached_objects args
 in shrink_control
Date: Tue, 10 Dec 2013 12:38:41 +1100
Message-ID: <20131210013841.GY31386@dastard>
References: <cover.1386571280.git.vdavydov@parallels.com>
 <43660b83b58531ccf4d45f626283484441441943.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <43660b83b58531ccf4d45f626283484441441943.1386571280.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Mon, Dec 09, 2013 at 12:05:50PM +0400, Vladimir Davydov wrote:
> We are going to make the FS shrinker memcg-aware. To achieve that, we
> will have to pass the memcg to scan to the nr_cached_objects and
> free_cached_objects VFS methods, which currently take only the NUMA node
> to scan. Since the shrink_control structure already holds the node, and
> the memcg to scan will be added to it as we introduce memcg-aware
> vmscan, let us consolidate the methods' arguments in this structure to
> keep things clean.
> 
> Thanks to David Chinner for the tip.

Ok, you dealt with this as a separate patch...

> 
> Signed-off-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
>  fs/super.c         |    8 +++-----
>  fs/xfs/xfs_super.c |    6 +++---
>  include/linux/fs.h |    6 ++++--
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index a039dba..8f9a81b 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -76,7 +76,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  		return SHRINK_STOP;
>  
>  	if (sb->s_op->nr_cached_objects)
> -		fs_objects = sb->s_op->nr_cached_objects(sb, sc->nid);
> +		fs_objects = sb->s_op->nr_cached_objects(sb, sc);
>  
>  	inodes = list_lru_count(&sb->s_inode_lru, sc);
>  	dentries = list_lru_count(&sb->s_dentry_lru, sc);
> @@ -96,8 +96,7 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
>  	if (fs_objects) {
>  		fs_objects = mult_frac(sc->nr_to_scan, fs_objects,
>  								total_objects);
> -		freed += sb->s_op->free_cached_objects(sb, fs_objects,
> -						       sc->nid);
> +		freed += sb->s_op->free_cached_objects(sb, sc, fs_objects);
>  	}

Again, pass the number to scan in sc->nr_to_scan, please.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
