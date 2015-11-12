From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/6] memcg: only account kmem allocations marked as
 __GFP_ACCOUNT
Date: Thu, 12 Nov 2015 17:04:10 +0100
Message-ID: <20151112160409.GM1174@dhcp22.suse.cz>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <14d7a7f5e696d71793ddd835604de309af1963fd.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14d7a7f5e696d71793ddd835604de309af1963fd.1447172835.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 10-11-15 21:34:04, Vladimir Davydov wrote:
> Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
> fragile and difficult to maintain, because there seem to be many more
> allocations that should not be accounted than those that should be.
> Besides, false accounting an allocation might result in much worse
> consequences than not accounting at all, namely increased memory
> consumption due to pinned dead kmem caches.
> 
> So this patch switches kmem accounting to the white-policy: now only
> those kmem allocations that are marked as __GFP_ACCOUNT are accounted to
> memcg. Currently, no kmem allocations are marked like this. The
> following patches will mark several kmem allocations that are known to
> be easily triggered from userspace and therefore should be accounted to
> memcg.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

As mentioned previously I would simply squash 1-3 into a single patch.
Anyway
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/gfp.h        | 4 ++++
>  include/linux/memcontrol.h | 2 ++
>  mm/page_alloc.c            | 3 ++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 2b917ce34efc..61305a492356 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -30,6 +30,7 @@ struct vm_area_struct;
>  #define ___GFP_HARDWALL		0x20000u
>  #define ___GFP_THISNODE		0x40000u
>  #define ___GFP_RECLAIMABLE	0x80000u
> +#define ___GFP_ACCOUNT		0x100000u
>  #define ___GFP_NOTRACK		0x200000u
>  #define ___GFP_NO_KSWAPD	0x400000u
>  #define ___GFP_OTHER_NODE	0x800000u
> @@ -90,6 +91,8 @@ struct vm_area_struct;
>  #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL) /* Enforce hardwall cpuset memory allocs */
>  #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)/* No fallback, no policies */
>  #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
> +#define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)	/* Account to memcg (only relevant
> +							 * to kmem allocations) */
>  #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
>  
>  #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
> @@ -112,6 +115,7 @@ struct vm_area_struct;
>  #define GFP_NOIO	(__GFP_WAIT)
>  #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
>  #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)
> +#define GFP_KERNEL_ACCOUNT	(GFP_KERNEL | __GFP_ACCOUNT)
>  #define GFP_TEMPORARY	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
>  			 __GFP_RECLAIMABLE)
>  #define GFP_USER	(__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 2103f36b3bd3..c9d9a8e7b45f 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -773,6 +773,8 @@ static inline bool __memcg_kmem_bypass(gfp_t gfp)
>  {
>  	if (!memcg_kmem_enabled())
>  		return true;
> +	if (!(gfp & __GFP_ACCOUNT))
> +		return true;
>  	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
>  		return true;
>  	return false;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 446bb36ee59d..8e22f5b27de0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3420,7 +3420,8 @@ EXPORT_SYMBOL(__free_page_frag);
>  
>  /*
>   * alloc_kmem_pages charges newly allocated pages to the kmem resource counter
> - * of the current memory cgroup.
> + * of the current memory cgroup if __GFP_ACCOUNT is set, other than that it is
> + * equivalent to alloc_pages.
>   *
>   * It should be used when the caller would like to use kmalloc, but since the
>   * allocation is large, it has to fall back to the page allocator.
> -- 
> 2.1.4

-- 
Michal Hocko
SUSE Labs
