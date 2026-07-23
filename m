Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0C0470E99
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 03:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784775993; cv=none; b=bssXg6d/fagQT8tjc3fzHPRxbJZle4+ZgPqsMvMIUohai6E0cBbHkl4zqx5HOsBZWPLte7gQDuHweV5LIcxK3JTkHNuEsquB18tWKyRrZt8r+iQe8oE3dMf+fB55M7s1gtRBTTfiqGUJmMQUW1EmzqoFI0N5sDFKbd5JpPE7SmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784775993; c=relaxed/simple;
	bh=NOp2u7MtIeO6/+FYbDqAadAeTocT+0MH08QZBM7/8Cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hHpa1t1Piu51I9mVsbF9MQxdsiQxDg0MkNHAj//mQRO5Gih+ZdplQALYz7oSvyuAQ/LHraSvfMX68D8caC/DM8dXasCfFdWn+MOOIAFqXJa1J+rf6YuNeADZs0/SlAK2wuOquff9qfqgOFGpuPTwoPwUp9PO8NbX9LHfzW1B920=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lXXIzlBL; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lXXIzlBL"
Date: Thu, 23 Jul 2026 11:05:49 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784775979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gR/NCSV33JYMmMHnqisAYHsCi1Pk0aOBobkpC/mIj4s=;
	b=lXXIzlBL0OKuwlMWJsTKQuMa2q+crmjGo44URbyRWMUlTPNhqPVhtZrUA0L2TKuQQyWOgG
	0elMWbeC1NYn9eGNqg8amndzB9var5ZeoJU1yFaBzSrQTVrOv0Qb8yj5t9he7maWp9YwKR
	QePOPn3ymEPUhjh8BLFjJ6+Xs5PgAaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
Message-ID: <amGEY5w-cBm4_uhx@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:23PM +0200, Vlastimil Babka (SUSE) wrote:
> Currently, struct slabobj_ext can hold both objcg pointer and
> codetag_ref (when both are compile-enabled) and there is an array of as
> many slabobj_ext instances as there are objects in a slab.
> 
> This makes the layout fixed so even if codetag_ref is unused (because
> memory allocation profiling is disabled), the space for them is
> allocated and wasted. Similarly, some caches (currently kmalloc_normal)
> do not ever need objcg pointers, leading to wasted memory with memory
> allocation profiling enabled.
> 
> To make this more flexible, change the layout so that struct slabobj_ext
> becomes a union of objcg pointer and codetag_ref (to ensure uniform
> size; in practice both are the same size anyway). The slabobj_ext array
> then can have twice as many elements as before. For cache locality
> purposes, the effective memory layout is unchanged, so objcg and codetag
> ref for a given object are still adjacent.
> 
> cache_obj_ext_size() returns the effective size of (0-2) struct
> slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
> both return a constant value derived from the config options, but will
> be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.
> 
> No functional change intended, the layout is still effectively static.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
>  mm/slub.c | 19 +++++++++++--------
>  2 files changed, 50 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index e586798e4f16..f8446167e175 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
>  }
>  
>  /*
> - * Extended information for slab objects stored as an array in page->memcg_data
> - * if MEMCG_DATA_OBJEXTS is set.
> + * Extended information for slab objects stored as a pointer to an array in
> + * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
>   */
>  struct slabobj_ext {
> +	/*
> +	 * All elements of the union should be pointer-sized to avoid memory
> +	 * waste
> +	 */
> +	union {
>  #ifdef CONFIG_MEMCG
> -	struct obj_cgroup *_objcg;
> +		struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> -	union codetag_ref _ctref;
> +		union codetag_ref _ctref;
>  #endif
> +	};
>  } __aligned(8);

slabobj_ext is now acting as a generic struct, serving as either _objcg or
_ctref. However, because it's set to __aligned(8), I'm wondering if this might
waste half the memory on 32-bit?

>  
> +static inline size_t cache_obj_ext_size(struct kmem_cache *s)
> +{
> +	size_t sz = 0;
> +
> +	if (IS_ENABLED(CONFIG_MEMCG))
> +		sz += 1;
> +
> +	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
> +		sz += 1;
> +
> +	return sizeof(struct slabobj_ext) * sz;
> +}
> +
> +static inline size_t slab_obj_ext_size(struct slab *slab)
> +{
> +	return cache_obj_ext_size(slab->slab_cache);
> +}
> +
>  #ifdef CONFIG_SLAB_OBJ_EXT
>  
>  /*
> @@ -651,18 +675,18 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>  {
>  	struct slabobj_ext *obj_ext;
>  	unsigned int index;
> +	unsigned int stride;
>  
>  	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
>  
>  	index = obj_to_index(s, slab, obj);
>  
> -	if (!obj_exts_in_object(slab)) {
> -		obj_ext = ((struct slabobj_ext *)obj_exts) + index;
> -	} else {
> -		unsigned int stride = s->size;
> +	if (!obj_exts_in_object(slab))
> +		stride = slab_obj_ext_size(slab);
> +	else
> +		stride = s->size;
>  
> -		obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
> -	}
> +	obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
>  
>  	return kasan_reset_tag(obj_ext);
>  }
> @@ -670,12 +694,14 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>  #ifdef CONFIG_MEMCG
>  static inline struct obj_cgroup *slab_obj_ext_objcg(struct slabobj_ext *obj_ext)
>  {
> +	/* if objcg exists, it comes first, so we don't need to do anything */
>  	return obj_ext->_objcg;
>  }
>  
>  static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>  					  struct obj_cgroup *objcg)
>  {
> +	/* if objcg exists, it comes first, so we don't need to do anything */
>  	obj_ext->_objcg = objcg;
>  }
>  #endif
> @@ -684,6 +710,9 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
>  static inline union codetag_ref *
>  slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
>  {
> +	if (IS_ENABLED(CONFIG_MEMCG))
> +		obj_ext += 1;
> +
>  	return &obj_ext->_ctref;
>  }
>  #endif
> diff --git a/mm/slub.c b/mm/slub.c
> index f5b3eb44cb8a..287cbf3eddcc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -803,7 +803,7 @@ static inline bool need_slab_obj_exts(struct kmem_cache *s)
>  
>  static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
>  {
> -	return sizeof(struct slabobj_ext) * slab->objects;
> +	return slab_obj_ext_size(slab) * slab->objects;
>  }
>  
>  static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
> @@ -1199,7 +1199,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>  	off += kasan_metadata_size(s, false);
>  
>  	if (obj_exts_in_object(slab))
> -		off += sizeof(struct slabobj_ext);
> +		off += slab_obj_ext_size(slab);
>  
>  	if (off != size_from_object(s))
>  		/* Beginning of the filler is the free pointer */
> @@ -1404,7 +1404,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
>  	off += kasan_metadata_size(s, false);
>  
>  	if (obj_exts_in_object(slab))
> -		off += sizeof(struct slabobj_ext);
> +		off += slab_obj_ext_size(slab);
>  
>  	if (size_from_object(s) == off)
>  		return 1;
> @@ -2094,6 +2094,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
>  static inline void handle_failed_objexts_alloc(struct slab *slab,
>  		unsigned long obj_exts, struct slabobj_ext *vec)
>  {
> +	unsigned int stride;
> +
>  	if (!mem_alloc_profiling_enabled())
>  		return;
>  
> @@ -2105,11 +2107,13 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
>  	if (obj_exts != OBJEXTS_ALLOC_FAIL)
>  		return;
>  
> +	stride = slab_obj_ext_size(slab) / sizeof(*vec);
> +
>  	for (unsigned int i = 0; i < slab->objects; i++) {
>  		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
>  
>  		set_codetag_empty(ref);
> -		vec++;
> +		vec += stride;
>  	}
>  }
>  
> @@ -2135,7 +2139,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	unsigned long new_exts;
>  	unsigned long old_exts;
>  	struct slabobj_ext *vec;
> -	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
> +	size_t sz = slab_obj_ext_size(slab) * slab->objects;
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
>  	/*
> @@ -2278,8 +2282,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
>  
>  		get_slab_obj_exts(obj_exts);
>  		for_each_object(addr, s, slab_address(slab), slab->objects)
> -			memset(kasan_reset_tag(addr) + offset, 0,
> -			       sizeof(struct slabobj_ext));
> +			memset(kasan_reset_tag(addr) + offset, 0, slab_obj_ext_size(slab));
>  		put_slab_obj_exts(obj_exts);
>  
>  #ifdef CONFIG_MEMCG
> @@ -7938,7 +7941,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  	aligned_size = ALIGN(size, s->align);
>  #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
>  	if (slab_args_unmergeable(args, s->flags) &&
> -			(aligned_size - size >= sizeof(struct slabobj_ext)))
> +			(aligned_size - size >= cache_obj_ext_size(s)))
>  		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
>  #endif
>  	size = aligned_size;
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao
