From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] gfp: add __GFP_NOACCOUNT
Date: Wed, 6 May 2015 16:58:14 +0200
Message-ID: <20150506145814.GP14550@dhcp22.suse.cz>
References: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fdf631b3fa95567a830ea4f3e19d0b3b2fc99662.1430819044.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 05-05-15 12:45:42, Vladimir Davydov wrote:
[...]
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 97a9373e61e8..37c422df2a0f 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -30,6 +30,7 @@ struct vm_area_struct;
>  #define ___GFP_HARDWALL		0x20000u
>  #define ___GFP_THISNODE		0x40000u
>  #define ___GFP_RECLAIMABLE	0x80000u
> +#define ___GFP_NOACCOUNT	0x100000u
>  #define ___GFP_NOTRACK		0x200000u
>  #define ___GFP_NO_KSWAPD	0x400000u
>  #define ___GFP_OTHER_NODE	0x800000u
> @@ -87,6 +88,7 @@ struct vm_area_struct;
>  #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
>  #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
> +#define __GFP_NOACCOUNT	((__force gfp_t)___GFP_NOACCOUNT) /* Don't account to memcg */

The wording suggests that _any_ memcg charge might be skipped by this flag
but only kmem part is handled.

So either handle the flag in try_charge or, IMO preferably, update the
comment here and add WARN_ON{_ONCE}(gfp & __GFP_NOACCOUNT). I do not
think we should allow to skip the charge for user pages ATM and warning
could tell us about the abuse of the flag.

>  #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
>  
>  #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 72dff5fb0d0c..6c8918114804 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -463,6 +463,8 @@ memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
>  	if (!memcg_kmem_enabled())
>  		return true;
>  
> +	if (gfp & __GFP_NOACCOUNT)
> +		return true;
>  	/*
>  	 * __GFP_NOFAIL allocations will move on even if charging is not
>  	 * possible. Therefore we don't even try, and have this allocation
> @@ -522,6 +524,8 @@ memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
>  {
>  	if (!memcg_kmem_enabled())
>  		return cachep;
> +	if (gfp & __GFP_NOACCOUNT)
> +		return cachep;
>  	if (gfp & __GFP_NOFAIL)
>  		return cachep;
>  	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 5405aff5a590..f0fe4f2c1fa7 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -115,7 +115,8 @@
>  #define BYTES_PER_POINTER	sizeof(void *)
>  
>  /* GFP bitmask for kmemleak internal allocations */
> -#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC)) | \
> +#define gfp_kmemleak_mask(gfp)	(((gfp) & (GFP_KERNEL | GFP_ATOMIC | \
> +					   __GFP_NOACCOUNT)) | \
>  				 __GFP_NORETRY | __GFP_NOMEMALLOC | \
>  				 __GFP_NOWARN)
>  
> -- 
> 1.7.10.4
> 

-- 
Michal Hocko
SUSE Labs
