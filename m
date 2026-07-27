Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BCF3BE15E;
	Mon, 27 Jul 2026 06:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785133288; cv=none; b=oxsDVOt96zAfY7pSN8Z5zUfbceLEK0VJvN5RyQDIE7dLnAdphaiK+rXvLT+wNufzdBTna7z21aWb8ZE72YOOAfyuZIu8XEaObSsp5j7H4mkdiPr0nZO6jECzAxcROYqLWbiEsHiaqH4pbPTU6+5o+E8eQyCsRHwdIg2jjbRKc9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785133288; c=relaxed/simple;
	bh=xzTt2z59QC8Q2Nk5Pd1XFFGw2YHnRkVkQPpnu40JYto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kN166Ru99pawKenPM6ZgdTLcRrWV7pKq880Y/GENJfGV2AJIgbikY49LynHmPBTr8CL/8q0Znr90ukPnX8FdAijbR/TVvulDsnHq5J2pKSzKMnhpreFXH2ljg0XLFraK7WVCBUsa5BQABZopPharvXMfL1PO+iiVmyITBGKAbw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=paWi0RpD; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="paWi0RpD"
Date: Mon, 27 Jul 2026 14:21:12 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785133284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/fgIomM+t2T3cQpKKoj4SNC1imJIcl8wBpZBAKlnU9I=;
	b=paWi0RpDJlvEn9JWEzhmuu1dzQj5I0SoPhXg10lFhGyhsZ6JfGv4JgmP//o//Y9g8URFoE
	ypLyygwDMPj6xYquuYt5ZQLa/sm43KrJLofswsr+LVr4z5ZgWcbmEo1uOIGzwnXldxQbkt
	1YeUDEMzwEnyeu74CAbGekuNrK3tDiQ=
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
Message-ID: <amb4KFF6nYyToYNC@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-1-2fa7c6f60dbe@kernel.org>
 <amC6frE3LoWYjTMh@fedora>
 <caddd662-a88d-4f04-8f04-01e3cd29c788@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caddd662-a88d-4f04-8f04-01e3cd29c788@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Jul 24, 2026 at 05:58:36PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/22/26 14:47, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:15PM +0200, Vlastimil Babka (SUSE) wrote:
> >> struct kfence_metadata only contains struct slabobj_ext with
> >> CONFIG_MEMCG, which is then used for the "fake" slab's obj_exts field.
> >> If CONFIG_MEMCG is enabled, the struct can also end up used for memory
> >> allocation profiling. If CONFIG_MEMCG is disabled but profiling is
> >> enabled, it will end up allocating its obj_exts via
> >> prepare_slab_obj_exts_hook() and assigning them to the fake struct slab.
> >> These will probably then never be freed.
> >> 
> >> So things sorta work, but not always in the intended and optimal way.
> >> The upcoming changes to slabobj_ext layout would additionally need a
> >> proper refactoring to keep working.
> >> 
> >> However, there's little benefit in accounting KFENCE objects. KFENCE
> >> allocations are rare and there can be only CONFIG_KFENCE_NUM_OBJECTS
> >> (default to 255) outstanding ones at any time. For any callsite
> >> prominent enough in the memory allocation profiling stats, allocations
> >> served from KFENCE will be lost in the noise.
> >> 
> >> Thus let's not complicate things and simply stop accounting KFENCE
> >> objects in allocation profiling and skip them in the related slab hooks.
> >> 
> >> We also need to skip kfence objects in mark_obj_codetag_empty() in case
> >> a sheaf is allocated from kfence, per earlier sashiko review.
> >> 
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  Documentation/mm/allocation-profiling.rst |  7 +++++++
> >>  mm/slub.c                                 | 11 +++++++++++
> >>  2 files changed, 18 insertions(+)
> >> 
> >> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> >> index 5389d241176a..d02eb54ee8f2 100644
> >> --- a/Documentation/mm/allocation-profiling.rst
> >> +++ b/Documentation/mm/allocation-profiling.rst
> >> @@ -112,3 +112,10 @@ break it out by rhashtable type.
> >>  
> >>  - Then, use the following form for your allocations:
> >>    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> >> +
> >> +Notes
> >> +=====
> >> +
> >> +- When a slab object is allocated from KFENCE, its accounting is skipped.
> >> +  KFENCE allocations are rare and limited to a small number, so this omission
> >> +  is negligible.
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 0337e60db5ac..76acb78f2655 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2076,6 +2076,11 @@ static inline void mark_obj_codetag_empty(const void *obj)
> >>  		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
> >>  						       slab_exts, offs);
> >>  
> >> +		if (is_kfence_address(obj)) {
> >> +			put_slab_obj_exts(slab_exts);
> >> +			return;
> >> +		}
> >> +
> >>  		if (unlikely(is_codetag_empty(&ext->ref))) {
> >>  			put_slab_obj_exts(slab_exts);
> >>  			return;
> >> @@ -2352,6 +2357,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
> >>  	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
> >>  		return;
> >>  
> >> +	if (is_kfence_address(object))
> >> +		return;
> >> +
> >>  	slab = virt_to_slab(object);
> >>  	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
> >>  	/*
> >> @@ -2399,6 +2407,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
> >>  	for (i = 0; i < objects; i++) {
> >>  		unsigned int off = obj_to_index(s, slab, p[i]);
> > 
> > I noticed obj_to_index also does the `if (is_kfence_address(obj))` check, so
> > maybe we could use:
> > 
> > if (is_kfence_address(p[i]))
> > 	continue;
> > off = __obj_to_index(cache, slab_address(slab), obj);
> 
> Hm it would work, but go away after patch 5/13 anyway, so will leave as is.

make sense!

> Thanks!
> 
> >>  
> >> +		if (is_kfence_address(p[i]))
> >> +			continue;
> >> +
> >>  		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
> >>  	}
> >>  	put_slab_obj_exts(obj_exts);
> >> 
> >> -- 
> >> 2.55.0
> >> 
> > 
> 

-- 
Thanks,
Hao
