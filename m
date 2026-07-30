Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A12408602
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 11:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410239; cv=none; b=S1bBwMXILvrDvP6XUn/TV+t41EasJ4O+BxXy8HznW6Cl4XYNqKHwhu+i9Q3rYufPtmplzL96Ykuya0MaRv62SKey4DNpQbtwOtE8VWCWm3nbw00mawCxdOKAqOAc9rd78g6F3bj2oXovbPr2fJu4U2MZ3zarsLQaXgrHAA4iNbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410239; c=relaxed/simple;
	bh=pjYAvpv2B2aLitHM+e4dQq/B4BB5NzDpAN/fA/RPMf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lrhce+8xEBncLLbSMBANZroqG0brmRnxt+ygCza2AX0WCngTQq7mjJPI2//cyplNNI1qUgP6o+jwTJHs870nSaEzVsDgDie06JeKNJ2R0zTB3bKxTmEkfUphoiDsxx2Bty+JZDuqoGPHZ7fT6K5kFysmTnz77d/CqWXhnEEgmKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YaPbCgjo; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YaPbCgjo"
Date: Thu, 30 Jul 2026 19:16:47 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785410234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O62DfahAFLdgUNQd+mEROE3kc1IiFSoToX+T1c6EMNs=;
	b=YaPbCgjoftbhSR29RzI9Advqe32g7LQ+h0mgAHtNfh88j26Di9HQPwtfZ2qZL8RShRsfg+
	X9u9qjJROPUyXbjGsv9JAAGTvz08KdUC6F2SlIH/17UBk2C6BLlkTOvFewXBx3wMSD3Rkj
	jWoAh/y38URdus2BcU5fMHYXHePLsaM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 01/13] mm/slab: skip kfence objects in allocation
 profiling
Message-ID: <amsxmCmsUTYM26Fh@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-1-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 02:53:55PM +0200, Vlastimil Babka (SUSE) wrote:
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
>  Documentation/mm/allocation-profiling.rst | 7 +++++++
>  mm/slub.c                                 | 9 +++++++++
>  2 files changed, 16 insertions(+)
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

should this be 'allocation profiling is skipped' instead?

Otherwise, looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

> +  KFENCE allocations are rare and limited to a small number, so this omission
> +  is negligible.
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..d702d273253c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2067,6 +2067,9 @@ static inline void mark_obj_codetag_empty(const void *obj)
>  	struct slab *obj_slab;
>  	unsigned long slab_exts;
>  
> +	if (is_kfence_address(obj))
> +		return;
> +
>  	obj_slab = virt_to_slab(obj);
>  	slab_exts = slab_obj_exts(obj_slab);
>  	if (slab_exts) {
> @@ -2352,6 +2355,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>  		return;
>  
> +	if (is_kfence_address(object))
> +		return;
> +
>  	slab = virt_to_slab(object);
>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
>  	/*
> @@ -2399,6 +2405,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
>  	for (i = 0; i < objects; i++) {
>  		unsigned int off = obj_to_index(s, slab, p[i]);
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
