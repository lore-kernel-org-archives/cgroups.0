From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v4 23/32] mm/memcg: Convert slab objcgs from struct page
 to struct slab
Date: Tue, 4 Jan 2022 18:41:33 -0800
Message-ID: <YdUFXUbeYGdFbVbq@carbon.dhcp.thefacebook.com>
References: <20220104001046.12263-1-vbabka@suse.cz>
 <20220104001046.12263-24-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=2JKALd0e4lP+WrJfsg9C4lrp3tw2nN+vlPsIuNo0Qjc=;
 b=BFWvrczTj8RzAxk7IcT7UK5swk7S78KHJFE0gvGnAI+QK1+LUNvgkqBWBR/hQJiSYaKd
 /fNtoSWtE6U5518A/iq81nBYl6DgQOc/OxNNaTU36iseI6Cr8tWkhxxRmn4R0COWSvMA
 cOA4aDaw1b+EPobAr49fg9MR1G8HlIOmJis= 
Content-Disposition: inline
In-Reply-To: <20220104001046.12263-24-vbabka-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hyeonggon Yoo <42.hyeyoo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, patches-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 04, 2022 at 01:10:37AM +0100, Vlastimil Babka wrote:
> page->memcg_data is used with MEMCG_DATA_OBJCGS flag only for slab pages
> so convert all the related infrastructure to struct slab. Also use
> struct folio instead of struct page when resolving object pointers.
> 
> This is not just mechanistic changing of types and names. Now in
> mem_cgroup_from_obj() we use folio_test_slab() to decide if we interpret
> the folio as a real slab instead of a large kmalloc, instead of relying
> on MEMCG_DATA_OBJCGS bit that used to be checked in page_objcgs_check().
> Similarly in memcg_slab_free_hook() where we can encounter
> kmalloc_large() pages (here the folio slab flag check is implied by
> virt_to_slab()). As a result, page_objcgs_check() can be dropped instead
> of converted.
> 
> To avoid include cycles, move the inline definition of slab_objcgs()
> from memcontrol.h to mm/slab.h.
> 
> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 48 ------------------------
>  mm/memcontrol.c            | 47 ++++++++++++-----------
>  mm/slab.h                  | 76 ++++++++++++++++++++++++++------------
>  3 files changed, 79 insertions(+), 92 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0c5c403f4be6..e34112f6a369 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -536,45 +536,6 @@ static inline bool folio_memcg_kmem(struct folio *folio)
>  	return folio->memcg_data & MEMCG_DATA_KMEM;
>  }
>  
> -/*
> - * page_objcgs - get the object cgroups vector associated with a page
> - * @page: a pointer to the page struct
> - *
> - * Returns a pointer to the object cgroups vector associated with the page,
> - * or NULL. This function assumes that the page is known to have an
> - * associated object cgroups vector. It's not safe to call this function
> - * against pages, which might have an associated memory cgroup: e.g.
> - * kernel stack pages.
> - */
> -static inline struct obj_cgroup **page_objcgs(struct page *page)
> -{
> -	unsigned long memcg_data = READ_ONCE(page->memcg_data);
> -
> -	VM_BUG_ON_PAGE(memcg_data && !(memcg_data & MEMCG_DATA_OBJCGS), page);
> -	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
> -
> -	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
> -}
> -
> -/*
> - * page_objcgs_check - get the object cgroups vector associated with a page
> - * @page: a pointer to the page struct
> - *
> - * Returns a pointer to the object cgroups vector associated with the page,
> - * or NULL. This function is safe to use if the page can be directly associated
> - * with a memory cgroup.
> - */
> -static inline struct obj_cgroup **page_objcgs_check(struct page *page)
> -{
> -	unsigned long memcg_data = READ_ONCE(page->memcg_data);
> -
> -	if (!memcg_data || !(memcg_data & MEMCG_DATA_OBJCGS))
> -		return NULL;
> -
> -	VM_BUG_ON_PAGE(memcg_data & MEMCG_DATA_KMEM, page);
> -
> -	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
> -}
>  
>  #else
>  static inline bool folio_memcg_kmem(struct folio *folio)
> @@ -582,15 +543,6 @@ static inline bool folio_memcg_kmem(struct folio *folio)
>  	return false;
>  }
>  
> -static inline struct obj_cgroup **page_objcgs(struct page *page)
> -{
> -	return NULL;
> -}
> -
> -static inline struct obj_cgroup **page_objcgs_check(struct page *page)
> -{
> -	return NULL;
> -}
>  #endif
>  
>  static inline bool PageMemcgKmem(struct page *page)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f7b789e692a0..f4fdd5675991 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2816,31 +2816,31 @@ static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
>  	rcu_read_unlock();
>  }
>  
> -int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
> -				 gfp_t gfp, bool new_page)
> +int memcg_alloc_slab_cgroups(struct slab *slab, struct kmem_cache *s,
> +				 gfp_t gfp, bool new_slab)
>  {
> -	unsigned int objects = objs_per_slab(s, page_slab(page));
> +	unsigned int objects = objs_per_slab(s, slab);
>  	unsigned long memcg_data;
>  	void *vec;
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
>  	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
> -			   page_to_nid(page));
> +			   slab_nid(slab));
>  	if (!vec)
>  		return -ENOMEM;
>  
>  	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJCGS;
> -	if (new_page) {
> +	if (new_slab) {
>  		/*
> -		 * If the slab page is brand new and nobody can yet access
> -		 * it's memcg_data, no synchronization is required and
> -		 * memcg_data can be simply assigned.
> +		 * If the slab is brand new and nobody can yet access its
> +		 * memcg_data, no synchronization is required and memcg_data can
> +		 * be simply assigned.
>  		 */
> -		page->memcg_data = memcg_data;
> -	} else if (cmpxchg(&page->memcg_data, 0, memcg_data)) {
> +		slab->memcg_data = memcg_data;
> +	} else if (cmpxchg(&slab->memcg_data, 0, memcg_data)) {
>  		/*
> -		 * If the slab page is already in use, somebody can allocate
> -		 * and assign obj_cgroups in parallel. In this case the existing
> +		 * If the slab is already in use, somebody can allocate and
> +		 * assign obj_cgroups in parallel. In this case the existing
>  		 * objcg vector should be reused.
>  		 */
>  		kfree(vec);
> @@ -2865,26 +2865,31 @@ int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
>   */
>  struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  {
> -	struct page *page;
> +	struct folio *folio;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	page = virt_to_head_page(p);
> +	folio = virt_to_folio(p);
>  
>  	/*
>  	 * Slab objects are accounted individually, not per-page.
>  	 * Memcg membership data for each individual object is saved in
>  	 * the page->obj_cgroups.
               ^^^^^^^^^^^^^^^^^
	       slab->memcg_data

>  	 */
> -	if (page_objcgs_check(page)) {
> -		struct obj_cgroup *objcg;
> +	if (folio_test_slab(folio)) {
> +		struct obj_cgroup **objcgs;
> +		struct slab *slab;
>  		unsigned int off;
>  
> -		off = obj_to_index(page->slab_cache, page_slab(page), p);
> -		objcg = page_objcgs(page)[off];
> -		if (objcg)
> -			return obj_cgroup_memcg(objcg);
> +		slab = folio_slab(folio);
> +		objcgs = slab_objcgs(slab);
> +		if (!objcgs)
> +			return NULL;
> +
> +		off = obj_to_index(slab->slab_cache, slab, p);
> +		if (objcgs[off])
> +			return obj_cgroup_memcg(objcgs[off]);
>  
>  		return NULL;
>  	}

There is a comment below, which needs some changes:
	/*
	 * page_memcg_check() is used here, because page_has_obj_cgroups()
	 * check above could fail because the object cgroups vector wasn't set
	 * at that moment, but it can be set concurrently.
	 * page_memcg_check(page) will guarantee that a proper memory
	 * cgroup pointer or NULL will be returned.
	 */

In reality the folio's slab flag can be cleared before releasing the objcgs \
vector. It seems that there is no such possibility at setting the flag,
it's always set before allocating and assigning the objcg vector.

> @@ -2896,7 +2901,7 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
>  	 * page_memcg_check(page) will guarantee that a proper memory
>  	 * cgroup pointer or NULL will be returned.
>  	 */
> -	return page_memcg_check(page);
> +	return page_memcg_check(folio_page(folio, 0));
>  }
>  
>  __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
> diff --git a/mm/slab.h b/mm/slab.h
> index bca9181e96d7..36e0022d8267 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -412,15 +412,36 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
>  }
>  
>  #ifdef CONFIG_MEMCG_KMEM
> -int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
> -				 gfp_t gfp, bool new_page);
> +/*
> + * slab_objcgs - get the object cgroups vector associated with a slab
> + * @slab: a pointer to the slab struct
> + *
> + * Returns a pointer to the object cgroups vector associated with the slab,
> + * or NULL. This function assumes that the slab is known to have an
> + * associated object cgroups vector. It's not safe to call this function
> + * against slabs with underlying pages, which might have an associated memory
> + * cgroup: e.g.  kernel stack pages.

Hm, is it still true? I don't think so. It must be safe to call it for any
slab now.

The rest looks good to me, please feel free to add
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
after fixing these comments.

Thanks!
