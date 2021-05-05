From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 2/2] mm: memcg/slab: Create a new set of
 kmalloc-cg-<n> caches
Date: Wed, 5 May 2021 10:30:31 -0700
Message-ID: <YJLWN6bNBYyKRPEN@carbon.DHCP.thefacebook.com>
References: <20210505154613.17214-1-longman@redhat.com>
 <20210505154613.17214-3-longman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lCKnktCkBi4YxBOjzx3vBVE/A4hxadBhCdQSILNLPkY=;
 b=BoDBdWeSaDRfE7VaSoCaajcvBTr6CbVPITLc25mqL8rZKcwjMhfXmCKSjPEIPbshsDGp
 TkfCbwSbGlAqJdTDykdrCXdDnMKhSj1xmkwVh3HCroA3YiKxW4AiQEdlZKPUm5u6/Kk3
 aCxWMdsxrgoL6p1w+vMFzJ9LcfNYh8U6bKA= 
Content-Disposition: inline
In-Reply-To: <20210505154613.17214-3-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, May 05, 2021 at 11:46:13AM -0400, Waiman Long wrote:
> There are currently two problems in the way the objcg pointer array
> (memcg_data) in the page structure is being allocated and freed.
> 
> On its allocation, it is possible that the allocated objcg pointer
> array comes from the same slab that requires memory accounting. If this
> happens, the slab will never become empty again as there is at least
> one object left (the obj_cgroup array) in the slab.
> 
> When it is freed, the objcg pointer array object may be the last one
> in its slab and hence causes kfree() to be called again. With the
> right workload, the slab cache may be set up in a way that allows the
> recursive kfree() calling loop to nest deep enough to cause a kernel
> stack overflow and panic the system.
> 
> One way to solve this problem is to split the kmalloc-<n> caches
> (KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
> (KMALLOC_NORMAL) caches for non-accounted objects only and a new set of
> kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
> the other caches can still allow a mix of accounted and non-accounted
> objects.

I agree that it's likely the best approach here. Thanks for discovering
and fixing the problem!

> 
> With this change, all the objcg pointer array objects will come from
> KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
> both the recursive kfree() problem and non-freeable slab problem are
> gone. Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer
> have mixed accounted and unaccounted objects, this will slightly reduce
> the number of objcg pointer arrays that need to be allocated and save
> a bit of memory.

Unfortunately the positive effect of this change will be likely
reversed by a lower utilization due to a larger number of caches.

Btw, I wonder if we also need a change in the slab caches merging procedure?
KMALLOC_NORMAL caches should not be merged with caches which can potentially
include accounted objects.

> 
> The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
> KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
> will include the newly added caches without change.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  include/linux/slab.h | 42 ++++++++++++++++++++++++++++++++++--------
>  mm/slab_common.c     | 23 +++++++++++++++--------
>  2 files changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 0c97d788762c..f2d9ebc34f5c 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -305,9 +305,16 @@ static inline void __check_heap_object(const void *ptr, unsigned long n,
>  /*
>   * Whenever changing this, take care of that kmalloc_type() and
>   * create_kmalloc_caches() still work as intended.
> + *
> + * KMALLOC_NORMAL is for non-accounted objects only whereas KMALLOC_CGROUP
> + * is for accounted objects only. All the other kmem caches can have both
> + * accounted and non-accounted objects.
>   */
>  enum kmalloc_cache_type {
>  	KMALLOC_NORMAL = 0,
> +#ifdef CONFIG_MEMCG_KMEM
> +	KMALLOC_CGROUP,
> +#endif
>  	KMALLOC_RECLAIM,
>  #ifdef CONFIG_ZONE_DMA
>  	KMALLOC_DMA,
> @@ -315,28 +322,47 @@ enum kmalloc_cache_type {
>  	NR_KMALLOC_TYPES
>  };
>  
> +#ifndef CONFIG_MEMCG_KMEM
> +#define KMALLOC_CGROUP	KMALLOC_NORMAL
> +#endif
> +#ifndef CONFIG_ZONE_DMA
> +#define KMALLOC_DMA	KMALLOC_NORMAL
> +#endif
> +
>  #ifndef CONFIG_SLOB
>  extern struct kmem_cache *
>  kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
>  
> +/*
> + * Define gfp bits that should not be set for KMALLOC_NORMAL.
> + */
> +#define KMALLOC_NOT_NORMAL_BITS					\
> +	(__GFP_RECLAIMABLE |					\
> +	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
> +	(IS_ENABLED(CONFIG_MEMCG_KMEM) ? __GFP_ACCOUNT : 0))
> +
>  static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
>  {
> -#ifdef CONFIG_ZONE_DMA
>  	/*
>  	 * The most common case is KMALLOC_NORMAL, so test for it
>  	 * with a single branch for both flags.
>  	 */
> -	if (likely((flags & (__GFP_DMA | __GFP_RECLAIMABLE)) == 0))
> +	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
>  		return KMALLOC_NORMAL;

Likely KMALLOC_CGROUP is also very popular, so maybe we want to change the
optimization here a bit.

>  
>  	/*
> -	 * At least one of the flags has to be set. If both are, __GFP_DMA
> -	 * is more important.
> +	 * At least one of the flags has to be set. Their priorities in
> +	 * decreasing order are:
> +	 *  1) __GFP_DMA
> +	 *  2) __GFP_RECLAIMABLE
> +	 *  3) __GFP_ACCOUNT
>  	 */
> -	return flags & __GFP_DMA ? KMALLOC_DMA : KMALLOC_RECLAIM;
> -#else
> -	return flags & __GFP_RECLAIMABLE ? KMALLOC_RECLAIM : KMALLOC_NORMAL;
> -#endif
> +	if (IS_ENABLED(CONFIG_ZONE_DMA) && (flags & __GFP_DMA))
> +		return KMALLOC_DMA;
> +	if (!IS_ENABLED(CONFIG_MEMCG_KMEM) || (flags & __GFP_RECLAIMABLE))
> +		return KMALLOC_RECLAIM;
> +	else
> +		return KMALLOC_CGROUP;
>  }
>  
>  /*
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index f8833d3e5d47..d750e3ba7af5 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -727,21 +727,25 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
>  }
>  
>  #ifdef CONFIG_ZONE_DMA
> -#define INIT_KMALLOC_INFO(__size, __short_size)			\
> -{								\
> -	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
> -	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
> -	.name[KMALLOC_DMA]     = "dma-kmalloc-" #__short_size,	\
> -	.size = __size,						\
> -}
> +#define KMALLOC_DMA_NAME(sz)	.name[KMALLOC_DMA] = "dma-kmalloc-" #sz,
> +#else
> +#define KMALLOC_DMA_NAME(sz)
> +#endif
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +#define KMALLOC_CGROUP_NAME(sz)	.name[KMALLOC_CGROUP] = "kmalloc-cg-" #sz,
>  #else
> +#define KMALLOC_CGROUP_NAME(sz)
> +#endif
> +
>  #define INIT_KMALLOC_INFO(__size, __short_size)			\
>  {								\
>  	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
>  	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
> +	KMALLOC_CGROUP_NAME(__short_size)			\
> +	KMALLOC_DMA_NAME(__short_size)				\
>  	.size = __size,						\
>  }
> -#endif
>  
>  /*
>   * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
> @@ -847,6 +851,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
>  	int i;
>  	enum kmalloc_cache_type type;
>  
> +	/*
> +	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
> +	 */
>  	for (type = KMALLOC_NORMAL; type <= KMALLOC_RECLAIM; type++) {
>  		for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
>  			if (!kmalloc_caches[type][i])
> -- 
> 2.18.1
> 
