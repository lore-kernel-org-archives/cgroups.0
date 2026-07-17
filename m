Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98A93E92B0;
	Fri, 17 Jul 2026 10:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784282436; cv=none; b=Zc5hq6TiRNeZUN4XCU4v/9hMM9vUAAiqzUTV4vMsm3xW0S5Aj3NZA9u1g3EZ30U8EyKoDBgp+g39GxcOyO5vUv20RBXa30vJviV2AnBITrCf7hKz37UMKf8WyF+yYdAkiKks+zYBLTpmclnVSnJz84nBVcJ4XDec8+xPmsG6lbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784282436; c=relaxed/simple;
	bh=21SvuiXGb63/yGdgyprvkQaVhJu+r+1ZurssCMSiB0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VbfwYQ4C2YX+ecm+0RajwrIdCCbFF9jLVhysgFqhonHl7ZFJ8HTUT8oQEfX98k2gRc6U63hfsbZ3Xj7WtPyfWqnsGtGi4rdK+SXFeUqlDgqtC7ZJY7laxp5ZG4pv6GgF8TSU73FveFuKBq/n11GywBdM5ZPKhbMpPKfxwzSggAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsUNWYE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsUNWYE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA891F000E9;
	Fri, 17 Jul 2026 10:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784282434;
	bh=DF6HG8VRcKlp7PWGtfJlKS/XAeUYbsad4fOuP/0NSHk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WsUNWYE9hbLye9jbYYTr2L2WVzCZINOuxbayrBrAXK6Cz01pKIezn8IdD+EGo6Xr/
	 I8FDVn+XXdV/1lo1cFHQtucXPasWDUXFmAkbuQkm2JTGqk553ZHiEE5CUuUtIBhVmG
	 SL0tepNCQIHdD3Y2yXGVmYT0n2hfE8XukEKWE+8VLpq+eOKNZkdtCuyBSpf16rHiQ2
	 kUfF5oomr8F3VZWrLQCiYuVzuBOzyJPLnJU5INb/t9ycS0l9iCDNN9WFCTT5UXU+2f
	 RluCZoa83CNb9wPfHjcWQEBYZ9mFQOUxAySO60TB1iSqDh6cZc3U+vKgnXU52PePPd
	 6S2lIKsoBFEDA==
Message-ID: <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
Date: Fri, 17 Jul 2026 12:00:29 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Ye Liu <liuye@kylinos.cn>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Stephen Brennan <stephen.s.brennan@oracle.com>, SeongJae Park
 <sj@kernel.org>, Omar Sandoval <osandov@osandov.com>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract access to the
> objcg field with a slab_obj_ext_objcgp() function.
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
> 
> No functional change intended.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Hm sashiko finds [1] that this is breaks tools/mm/show_page_info.py

But I think it was already buggy. get_memcg_info() is supposed to return
memcg info for a page but in case of MEMCG_DATA_OBJEXTS there's no such info
for the whole page, there is only for individual slab objects and it doesn't
know which object so it effectively gets the first one. I think it should
just stop handling MEMCG_DATA_OBJEXTS, but that's a fix that should be sent
unrelated to this series.

There's also tools/cgroup/memcg_slabinfo.py and that I think has been
already broken with memalloc profiling as it assuems slab.memcg_data is
still a raw struct obj_cgroup * and not struct slabobj_ext.

I think it will be easier to fix it at once to handle the layout after this
series than trying to fix it first to handle the pre-series layout and then
update it with every relevant change.

[1]
https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=5

> ---
>  mm/kfence/core.c |  2 +-
>  mm/memcontrol.c  | 23 +++++++++++++++--------
>  mm/slab.h        |  9 ++++++++-
>  mm/slub.c        |  2 +-
>  4 files changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 6577bd76954e..717e8baf7e5d 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -1249,7 +1249,7 @@ void __kfence_free(void *addr)
>  	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
>  
>  #ifdef CONFIG_MEMCG
> -	KFENCE_WARN_ON(meta->obj_exts.objcg);
> +	KFENCE_WARN_ON(*slab_obj_ext_objcgp(&meta->obj_exts));
>  #endif
>  	/*
>  	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4e427286a88a..6303a2b1a9d0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2865,6 +2865,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>  	 */
>  	unsigned long obj_exts;
>  	struct slabobj_ext *obj_ext;
> +	struct obj_cgroup *objcg;
>  
>  	obj_exts = slab_obj_exts(slab);
>  	if (!obj_exts)
> @@ -2872,9 +2873,8 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
>  
>  	get_slab_obj_exts(obj_exts);
>  	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
> -	if (obj_ext->objcg) {
> -		struct obj_cgroup *objcg = obj_ext->objcg;
> -
> +	objcg = *slab_obj_ext_objcgp(obj_ext);
> +	if (objcg) {
>  		put_slab_obj_exts(obj_exts);
>  		return obj_cgroup_memcg(objcg);
>  	}
> @@ -3577,6 +3577,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  		unsigned long obj_exts;
>  		struct slabobj_ext *obj_ext;
>  		struct obj_stock_pcp *stock;
> +		struct obj_cgroup **objcgp;
>  
>  		slab = virt_to_slab(p[i]);
>  
> @@ -3612,10 +3613,15 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  		unlock_stock(stock);
>  
>  		obj_exts = slab_obj_exts(slab);
> +
>  		get_slab_obj_exts(obj_exts);
> +
>  		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
> +		objcgp = slab_obj_ext_objcgp(obj_ext);
> +
>  		obj_cgroup_get(objcg);
> -		obj_ext->objcg = objcg;
> +		*objcgp = objcg;
> +
>  		put_slab_obj_exts(obj_exts);
>  	}
>  
> @@ -3628,16 +3634,17 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
>  	size_t obj_size = obj_full_size(s);
>  
>  	for (int i = 0; i < objects; i++) {
> -		struct obj_cgroup *objcg;
> +		struct obj_cgroup **objcgp, *objcg;
>  		struct slabobj_ext *obj_ext;
>  		struct obj_stock_pcp *stock;
>  
>  		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
> -		objcg = obj_ext->objcg;
> -		if (!objcg)
> +		objcgp = slab_obj_ext_objcgp(obj_ext);
> +		if (!*objcgp)
>  			continue;
>  
> -		obj_ext->objcg = NULL;
> +		objcg = *objcgp;
> +		*objcgp = NULL;
>  
>  		stock = trylock_stock();
>  		__refill_obj_stock(objcg, stock, obj_size, true);
> diff --git a/mm/slab.h b/mm/slab.h
> index 36d067d6e7c0..789bd292075f 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
>   */
>  struct slabobj_ext {
>  #ifdef CONFIG_MEMCG
> -	struct obj_cgroup *objcg;
> +	struct obj_cgroup *_objcg;
>  #endif
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>  	union codetag_ref ref;
> @@ -661,6 +661,13 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
>  	return kasan_reset_tag(obj_ext);
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static inline struct obj_cgroup **slab_obj_ext_objcgp(struct slabobj_ext *obj_ext)
> +{
> +	return &obj_ext->_objcg;
> +}
> +#endif
> +
>  int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  			gfp_t gfp, unsigned int alloc_flags);
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index 5e3f53bcd0d3..48e10198a3ce 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2523,7 +2523,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>  	if (obj_exts) {
>  		get_slab_obj_exts(obj_exts);
>  		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
> -		if (unlikely(obj_ext->objcg)) {
> +		if (unlikely(*slab_obj_ext_objcgp(obj_ext))) {
>  			put_slab_obj_exts(obj_exts);
>  			return true;
>  		}
> 

