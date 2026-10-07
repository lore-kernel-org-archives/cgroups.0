Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6953C10AD;
	Wed,  7 Oct 2026 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791394822; cv=none; b=fnrglGaHY9mJlTqSdsI4qRDHgeHz2IVlP5dIlBHYXCtI5LIv8qVfMiKWaap5n/Vq0e8GU478gBVGxptTLgBnr5ayJH0AdnIo3pfmN5lD4RytQcBcKnTwfwUtD9hLSQ64uy0oeyHp4ks9Nq4Sip+XhbpqReAMa/XZT4++7hQsb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791394822; c=relaxed/simple;
	bh=T3Xma10h/d1SxST1IbfpogqmDbrxWCnwUilCUKwFuY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnmwXlGRSp+wUpk39AOFxIaHrMC/ReAr9HeVHtocsDpxD8RgF0oHFqRCTo5M1BgRnUeQ2hpT0h/tmg18s+PjiIiZ9RTSA0d72Gypp43Hr/sBFCR8lOUnYt+82KcBGUyHdDFXnUnuoocSifNehVxmbxIr7b+wr5tRHbzTkIXcT/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8vwGyeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8vwGyeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C711F000FF;
	Wed,  7 Oct 2026 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791394821;
	bh=EkQUHitjzzlvo38RimBkUzV/B8Ac4BuALErE/4c4/Cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j8vwGyeh15j/C0j3QdVat9KunBD+RZBNpMIIUY+FlzKCCyu795O//KntARQ6+o5T4
	 IkjbWgfaRQd/I1N1B+SzruG6bYeeqoEJ2gxKfCuoGPoGGgXaslXXirvZk6nIYszTHm
	 vb6IRag2XLh5KFH/N/NiOWvWcXN9DI7zdEAEK7rdYNVSfLOBAQMoF5B00A/gbEvTEx
	 sAQLlwgNo9I/vj0ipvv59CFNMrdqSwDFt+Wqxj/EDFY2IsPXBCJ6OQhyrgv1wxAnGJ
	 JqEIcQNSP/SlznuJKtRD7aiKITMofq3QEx4g5+lpdgks0+i1CZjhCQhg0d4QMSHqLa
	 XGpvCiVJqOGbQ==
Date: Wed, 7 Oct 2026 19:40:17 +0200
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 1/2] mm/slub: preserve no-lock freeing after memcg charge
 failure
Message-ID: <asaAwg1KeZoEYd4K@thinkpad>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
 <20261001044056.75079-2-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001044056.75079-2-kmehltretter@gmail.com>

On Thu, Oct 01, 2026 at 06:40:55AM +0200, Karl Mehltretter wrote:
> kmalloc_nolock() can obtain an object before its memcg
> post-allocation charge fails.  For a single object,
> memcg_slab_post_alloc_hook() rolls the allocation back through
> memcg_alloc_abort_single().  That enters the regular SLUB free path,
> which can take a sleeping list_lock on PREEMPT_RT even though the caller
> selected a no-lock allocation.
> 
> Use kfree_nolock() when the allocation flags disallow spinning.  This
> keeps the SLUB object rollback on the no-lock free path.  The failed
> allocation continues to return NULL.

When this happens, the object is not charged by memcg.

The kernel should not invoke memcg_slab_free_hook() (called by
kfree_nolock()) for a slab object that is not charged by memcg.

> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/slub.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 54ec125033571..a1f08338102e2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2519,7 +2519,10 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
>  
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		if (alloc_flags_allow_spinning(ac->alloc_flags))
> +			memcg_alloc_abort_single(s, *p);
> +		else
> +			kfree_nolock(*p);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);
> -- 
> 2.53.0

-- 
Cheers,
Harry / Hyeonggon
