From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/2] super: fix calculation of shrinkable objects for
 small numbers
Date: Thu, 20 Dec 2012 18:06:57 +1100
Message-ID: <20121220070657.GV15182@dastard>
References: <1355906418-3603-1-git-send-email-glommer@parallels.com>
 <1355906418-3603-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1355906418-3603-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On Wed, Dec 19, 2012 at 12:40:17PM +0400, Glauber Costa wrote:
> The sysctl knob sysctl_vfs_cache_pressure is used to determine which
> percentage of the shrinkable objects in our cache we should actively try
> to shrink.
> 
> It works great in situations in which we have many objects (at least
> more than 100), because the aproximation errors will be negligible. But
> if this is not the case, specially when total_objects < 100, we may end
> up concluding that we have no objects at all (total / 100 = 0,  if total
> < 100).
> 
> This is certainly not the biggest killer in the world, but may matter in
> very low kernel memory situations.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
> CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
> CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
>  fs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/super.c b/fs/super.c
> index 12f1237..660552c 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -104,7 +104,7 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  				sb->s_nr_inodes_unused + fs_objects;
>  	}
>  
> -	total_objects = (total_objects / 100) * sysctl_vfs_cache_pressure;
> +	total_objects = mult_frac(total_objects, sysctl_vfs_cache_pressure, 100);
>  	drop_super(sb);
>  	return total_objects;

Hi Glauber,

sysctl_vfs_cache_pressure all over the place with exactly the same
calculation. Can you fix all of them in one pass?

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
