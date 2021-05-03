From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcg/slab: Don't create unfreeable slab
Date: Mon, 3 May 2021 14:22:26 +0200
Message-ID: <699e5ac8-9044-d664-f73f-778fe72fd09b@suse.cz>
References: <20210502180755.445-1-longman@redhat.com>
 <20210502180755.445-2-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210502180755.445-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/2/21 8:07 PM, Waiman Long wrote:
> The obj_cgroup array (memcg_data) embedded in the page structure is
> allocated at the first instance an accounted memory allocation happens.
> With the right size object, it is possible that the allocated obj_cgroup
> array comes from the same slab that requires memory accounting. If this
> happens, the slab will never become empty again as there is at least one
> object left (the obj_cgroup array) in the slab.
> 
> With instructmentation code added to detect this situation, I got 76
> hits on the kmalloc-192 slab when booting up a test kernel on a VM.
> So this can really happen.
> 
> To avoid the creation of these unfreeable slabs, a check is added to
> memcg_alloc_page_obj_cgroups() to detect that and double the size
> of the array in case it happens to make sure that it comes from a
> different kmemcache.
> 
> This change, however, does not completely eliminate the presence
> of unfreeable slabs which can still happen if a circular obj_cgroup
> array dependency is formed.

Hm this looks like only a half fix then.
I'm afraid the proper fix is for kmemcg to create own set of caches for the
arrays. It would also solve the recursive kfree() issue.

> Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b0695d3aa530..44852ac048c3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2876,12 +2876,24 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>  	 */
>  	objects = max(objs_per_slab_page(s, page),
>  		      (int)(sizeof(struct rcu_head)/sizeof(void *)));
> -
> +retry:
>  	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
>  			   page_to_nid(page));
>  	if (!vec)
>  		return -ENOMEM;
>  
> +	/*
> +	 * The allocated vector should not come from the same slab.
> +	 * Otherwise, this slab will never become empty. Double the size
> +	 * in this case to make sure that the vector comes from a different
> +	 * kmemcache.
> +	 */
> +	if (unlikely(virt_to_head_page(vec) == page)) {
> +		kfree(vec);
> +		objects *= 2;
> +		goto retry;
> +	}
> +
>  	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJCGS;
>  	if (new_page) {
>  		/*
> 

