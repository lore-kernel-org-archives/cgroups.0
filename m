Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A16470E8F
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 10:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800907; cv=none; b=rLPsoio+2iBRXvTnmZPXw8CmNI9yZYtRP6QywBg0nNT4JRH/NFc6CFkhQR0hjYyFtN/g4UV1Kc7WYg+PZc+SX1uaxZAb5p5sjt1PIaUi/Wwe88EMji0yWWS+t7VcnvmPXwE6zz4tStF412t2y5mjr3oUGAipfyQtIsOb6qFAY5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800907; c=relaxed/simple;
	bh=yfrEDFu9UaoMIQSZG9pCLNWhm9daxd4yc4e0cmU1nGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRabJd89XnI2qvetz/wJIRcEkTFlQOZYn1Yps8q18hm8iznoj53mqkVZcnc2rc5TuYrlPUBqoj864edwCau4bu90biQK+7LJ88QGLggxLcXYCzvEAmDMbHlGF8yQloqXZ12mT3289oNFTRcpbbynlY4PpnxI256ll0ZiD0CG/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B3tN3CMm; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B3tN3CMm"
Date: Thu, 23 Jul 2026 18:01:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784800889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/IOPEWFyLCrkOKDL5TmCaxllcKhpBFa1PGm5TdS+JwA=;
	b=B3tN3CMmCpKLZ3NrTYsrJ4RLkX3LFQJRJLgVEIuQsXk/GkMvH5ZafyBK62EAo0LIvT2D50
	fAKJeIjSiLb7ygdHnxWK0DaWeYIXONIZaWgnhZYOEC7DvUfbyNhUa9RtOtJ0mXfO3rfymO
	FwBtaicdmtSjfbwmIZf+DeT8vEaPrX4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Message-ID: <amHldYIo_-Bgm7Ek@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
 <amHbnLLrpOmwmusv@fedora>
 <e8b503fe-c97f-4747-aa95-97be42cdd832@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b503fe-c97f-4747-aa95-97be42cdd832@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 23, 2026 at 11:30:49AM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/23/26 11:25, Hao Li wrote:
> > On Mon, Jul 20, 2026 at 04:16:26PM +0200, Vlastimil Babka (SUSE) wrote:
> >> @@ -359,6 +359,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
> >>  		goto out_unlock;
> >>  	}
> >>  
> >> +	/*
> >> +	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
> >> +	 * may need to store objcg pointers for objects
> >> +	 */
> >> +	if (!mem_cgroup_kmem_disabled())
> >> +		flags |= SLAB_MAY_ACCOUNT;
> > 
> > if memcg itself is disabled via `cgroup_disable`, mem_cgroup_kmem_disabled()
> > still return false, so maybe we can use:
> 
> Aha, but then shouldn't rather mem_cgroup_kmem_disabled() take that into
> account on its own?

Yeah, it's better to handle two cases in mem_cgroup_kmem_disabled!
This could also be a standalone patch, but including it to this patchset it totally
fine.

> 
> > if (!mem_cgroup_disabled() && !mem_cgroup_kmem_disabled())
> > 	flags |= SLAB_MAY_ACCOUNT;
> > 
> >> +
> >>  	/* Fail closed on bad usersize of useroffset values. */
> >>  	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
> >>  	    WARN_ON(!args->usersize && args->useroffset) ||
> >> @@ -984,11 +991,19 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
> >>  #endif
> >>  
> >>  	/*
> >> -	 * If CONFIG_MEMCG is enabled, disable cache merging for
> >> -	 * KMALLOC_NORMAL caches.
> >> +	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and  not
> >> +	 * aliased with any other type, make sure it's never merged with any other
> >> +	 * cache.
> >> +	 *
> >> +	 * In other cases the kmalloc cache may end up being used for a
> >> +	 * __GFP_ACCOUNT allocation so mark it as such
> >>  	 */
> >> -	if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_NORMAL))
> >> -		flags |= SLAB_NO_MERGE;
> >> +	if (!mem_cgroup_kmem_disabled()) {
> > 
> > the same as above
> > 
> > Others look good to me.
> > 
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> 
> Thanks!
> 
> > 
> >> +		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
> >> +			flags |= SLAB_NO_MERGE;
> >> +		else
> >> +			flags |= SLAB_MAY_ACCOUNT;
> >> +	}
> >>  
> >>  	if (minalign > ARCH_KMALLOC_MINALIGN) {
> >>  		aligned_size = ALIGN(aligned_size, minalign);
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index d78d3e50c877..30435e2509ea 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2557,7 +2557,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
> >>  	 * of slab_obj_exts being allocated from the same slab and thus the slab
> >>  	 * becoming effectively unfreeable.
> >>  	 */
> >> -	if (is_kmalloc_normal(s))
> >> +	if (!cache_needs_objcg(s))
> >>  		return true;
> >>  
> >>  	/* Ignore already charged objects. */
> >> @@ -3435,6 +3435,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
> >>  
> >>  	slab->objects = oo_objects(oo);
> >>  
> >> +#ifdef CONFIG_64BIT
> >> +	if (cache_needs_objcg(s))
> >> +		slab->obj_exts_needs_objcg = 1;
> >> +#endif
> >>  	slab->slab_cache = s;
> >>  
> >>  	kasan_poison_slab(slab);
> >> 
> >> -- 
> >> 2.55.0
> >> 
> > 
> 

-- 
Thanks,
Hao
