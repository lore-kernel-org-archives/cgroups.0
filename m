From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] kmemcg: don't allocate extra memory for root
 memcg_cache_params
Date: Wed, 14 Aug 2013 13:47:10 -0700
Message-ID: <20130814134710.ff123b0ea802efa7261d7e26@linux-foundation.org>
References: <1376476281-26559-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376476281-26559-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Wed, 14 Aug 2013 14:31:21 +0400 Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:

> The memcg_cache_params structure contains the common part and the union,
> which represents two different types of data: one for root cashes and
> another for child caches.
> 
> The size of child data is fixed. The size of the memcg_caches array is
> calculated in runtime.
> 
> Currently the size of memcg_cache_params for root caches is calculated
> incorrectly, because it includes the size of parameters for child caches.
> 
> ssize_t size = memcg_caches_array_size(num_groups);
> size *= sizeof(void *);
> 
> size += sizeof(struct memcg_cache_params);
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3140,7 +3140,7 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>  		ssize_t size = memcg_caches_array_size(num_groups);
>  
>  		size *= sizeof(void *);
> -		size += sizeof(struct memcg_cache_params);
> +		size += sizeof(offsetof(struct memcg_cache_params, memcg_caches));

This looks wrong. offsetof() returns size_t, so this is equivalent to

		size += sizeof(size_t);

>  		s->memcg_params = kzalloc(size, GFP_KERNEL);
>  		if (!s->memcg_params) {
> @@ -3183,13 +3183,16 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>  int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
>  			 struct kmem_cache *root_cache)
>  {
> -	size_t size = sizeof(struct memcg_cache_params);
> +	size_t size;
>  
>  	if (!memcg_kmem_enabled())
>  		return 0;
>  
> -	if (!memcg)
> +	if (!memcg) {
> +		size = offsetof(struct memcg_cache_params, memcg_caches);
>  		size += memcg_limited_groups_array_size * sizeof(void *);
> +	} else
> +		size = sizeof(struct memcg_cache_params);
>  
>  	s->memcg_params = kzalloc(size, GFP_KERNEL);
>  	if (!s->memcg_params)
