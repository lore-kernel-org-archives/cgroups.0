Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C85C3290BD;
	Fri, 12 Jun 2026 05:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781242031; cv=none; b=OQ6RoGvHGc6Vs/SDmAq2OskCBFFnPWUV07WJbljOLta17mKElh81ZSQDFEgF3mpb/7oLstwsx9tUNGoeGpJ/Y7nIV2AFV9Jsza4Fpelpb+ocnvggwgJCowcsgD143/L/SjlQYulnyhSz7hEio9VEnxngLvWI+Z4FTJ3wi6X7LPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781242031; c=relaxed/simple;
	bh=J228wGjhBNa3gtDG9PaBh/hqV6p77KV8odXCtoWxFhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zdyk/B29aSHkqzhGmyBhROPijSypa3U7f7MNyhj5HtHE7bl0Hs7rvSjLJvXN8EWC/aoheVaX/8Fb6lAP1HCxPLvynSpP3RgIzTKmvsOC15/VE/xAD9Hzn8hTytCu9M1TOVlzGaMdqYDy1drA/sn+wKnya1u84z2c5dbOU8ahY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FhKVk9tP; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FhKVk9tP"
Date: Fri, 12 Jun 2026 13:26:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781242026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4h74kcxJkFPwFOo5Mrw9gW8GX36OPR00MRCmR90JPNU=;
	b=FhKVk9tPR9od9h9I7gPVRNxgWrFle6W6cYkv2sScxzuHrqE+O5WO6CoLjTgIs7QeogntS8
	RzrIpsfM0UjJOLH4cGzjwP18JOd7L7VfgvUxMNHdCdeWLLvlMAoC/8mTVGQPqsal6+wB09
	pdeW7MKR+F/sKHu2EsIlxXSFJFiZezU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
Message-ID: <aiuX6SRATJoaq-jH@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Jun 10, 2026 at 05:40:10PM +0200, Vlastimil Babka (SUSE) wrote:
> Add the alloc_flags parameter to allocate_slab() and new_slab()
> so it can be used to determine if spinning is allowed, independently
> from gfp flags.
> 
> refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
> reached from contexts that allow spinning.
> 
> Also change how trynode_flags are constructed in ___slab_alloc() to
> achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
> of a branch. It will now also not upgrade in cases where gfp is weaker
> than GFP_NOWAIT (i.e. lacks __GFP_KSWAPD_RECLAIM) but doesn't come from
> kmalloc_nolock() - which is more correct anyway.
> 
> During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
> Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
> eliminate them, but it's not a big problem that would need a separate
> fix.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 98b79e5e7679..8f6ca3d5fdfa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3378,9 +3378,10 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
>  }
>  
>  /* Allocate and initialize a slab without building its freelist. */
> -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
> +				  unsigned int alloc_flags, int node)
>  {
> -	bool allow_spin = gfpflags_allow_spinning(flags);
> +	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);

nit: allow_spin doesn't depend on `flags` now, so it seems we can delete the
comments:

/*
 * __GFP_RECLAIM could be cleared on the first allocation attempt,
 * so pass allow_spin flag directly.
 */

Otherwise, looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao
