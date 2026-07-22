Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEC3CA52
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724542; cv=none; b=JX+SOWQSSK/qCtQbRgFgO3s5x3OZSI4u4OMnS0y+P9lsfYi1LopIsaMfVkF7pi+qQCYp8TNioKIoY4Cd93wr0VB5qoZpO2oxhWzrXygTzDiBXY172Z6oqr9ZsWo77mPL8m3lFoNj+v5lZviSJGfGm2ImC9b7AFoilEKqIxPGs7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724542; c=relaxed/simple;
	bh=Z7GiHQzgOLmmCHoovQUTTYnria8wPNoFHnPJkJUQiMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JBHAL+Brh4+j2eR9WHQz4O/oQ7oW3MovTFv5lm4Cc9TNZVwl8fEg3OmsnibMJMUMgBL83zYIrFUmW7kKPb93Y9CqX5gDTC3c8SORHC+TKtOOuBI7oYHNcYmZRksVyf5OTgPuZZLtnwxNQDZ+n2L/fb4aNUI78DpB7LYx6kc/c3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tntCcpwE; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tntCcpwE"
Date: Wed, 22 Jul 2026 20:47:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784724528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfnrtyzHcc7q+v7KzgfWL76gnj0hMYo6SrwEr84OSvg=;
	b=tntCcpwEEhLS/XWXoNqPZperSBZt5F5W/sXXnga+w0LpJtzlyYRmmPtkIVN+6q09sqs/0e
	MBKLhGzAWfMEScfkDQqN2tzJwcoIJJMaLV/AiGzzB3xoYaQOKEo/ckDrFPJlKrtEDtIl+7
	+yyHHnZ8vfdChOnyoYqHc0L9ttrvdyc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 01/13] mm/slab: skip kfence objects in allocation
 profiling
Message-ID: <amC6frE3LoWYjTMh@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 20, 2026 at 04:16:15PM +0200, Vlastimil Babka (SUSE) wrote:
> struct kfence_metadata only contains struct slabobj_ext with
> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> enabled, it will end up allocating its obj_exts via
> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
> These will probably then never be freed.
> 
> So things sorta work, but not always in the intended and optimal way.
> The upcoming changes to slabobj_ext layout would additionally need a
> proper refactoring to keep working.
> 
> However, there's little benefit in accounting KFENCE objects. KFENCE
> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> (default to 255) outstanding ones at any time. For any callsite
> prominent enough in the memory allocation profiling stats, allocations
> served from KFENCE will be lost in the noise.
> 
> Thus let's not complicate things and simply stop accounting KFENCE
> objects in allocation profiling and skip them in the related slab hooks.
> 
> We also need to skip kfence objects in mark_obj_codetag_empty() in case
> a sheaf is allocated from kfence, per earlier sashiko review.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  Documentation/mm/allocation-profiling.rst |  7 +++++++
>  mm/slub.c                                 | 11 +++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> index 5389d241176a..d02eb54ee8f2 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -112,3 +112,10 @@ break it out by rhashtable type.
>  
>  - Then, use the following form for your allocations:
>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> +
> +Notes
> +=====
> +
> +- When a slab object is allocated from KFENCE, its accounting is skipped.
> +  KFENCE allocations are rare and limited to a small number, so this omission
> +  is negligible.
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..76acb78f2655 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
>  		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
>  						       slab_exts, offs);
>  
> +		if (is_kfence_address(obj)) {
> +			put_slab_obj_exts(slab_exts);
> +			return;
> +		}
> +
>  		if (unlikely(is_codetag_empty(&ext->ref))) {
>  			put_slab_obj_exts(slab_exts);
>  			return;
> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>  		return;
>  
> +	if (is_kfence_address(object))
> +		return;
> +
>  	slab = virt_to_slab(object);
>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>  	/*
> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>  	for (i = 0; i < objects; i++) {
>  		unsigned int off = obj_to_index(s, slab, p[i]);

I noticed obj_to_index also does the `if (is_kfence_address(obj))` check, so
maybe we could use:

if (is_kfence_address(p[i]))
	continue;
off = __obj_to_index(cache, slab_address(slab), obj);

>  
> +		if (is_kfence_address(p[i]))
> +			continue;
> +
>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
>  	}
>  	put_slab_obj_exts(obj_exts);
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao
