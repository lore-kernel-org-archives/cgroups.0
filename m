From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 3/3] mm: memcg/slab: Disable cache merging for
 KMALLOC_NORMAL caches
Date: Thu, 6 May 2021 18:02:45 +0200
Message-ID: <83135334-f85e-b587-82fe-1875de602f53@suse.cz>
References: <20210505200610.13943-1-longman@redhat.com>
 <20210505200610.13943-4-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210505200610.13943-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 5/5/21 10:06 PM, Waiman Long wrote:
> The KMALLOC_NORMAL (kmalloc-<n>) caches are for unaccounted objects only
> when CONFIG_MEMCG_KMEM is enabled. To make sure that this condition
> remains true, we will have to prevent KMALOC_NORMAL caches to merge
> with other kmem caches. This is now done by setting its refcount to -1
> right after its creation.
> 
> Suggested-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

(outside of scope of this patch/series, we should later replace this refcount
ugliness with a proper slab flag)

> ---
>  mm/slab_common.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index bbaf41a7c77e..a0ff8e1d8b67 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -841,6 +841,13 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
>  					kmalloc_info[idx].name[type],
>  					kmalloc_info[idx].size, flags, 0,
>  					kmalloc_info[idx].size);
> +
> +	/*
> +	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
> +	 * KMALLOC_NORMAL caches.
> +	 */
> +	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
> +		kmalloc_caches[type][idx]->refcount = -1;
>  }
>  
>  /*
> 

