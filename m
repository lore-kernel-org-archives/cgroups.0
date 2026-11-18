Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019065;
	b=q/DV42IJUXPiMuk9x6yA3/DRSiNvNwDeWWRlIDdZ308l3D4RfDd553u1jxd2NU0SLxB1
	 6qvAag/sF/JqJPg7XCeelHJoZuDTHmbenzNMfvVm7jMaQXXLe70s8DlKkLWugjrt8hi32
	 rBSOGrbjRzSegC+GrTe2SlBGlGia4LvSpXYo/b9eBKhmp2TGANpRKxTcpC40SCbiPcVir
	 Nma/AhqotnqThpTzveKZfC7V7wozvz83V1jg1Y/p4M1ugDutR4Yqbqy1fd65jTQ+AnV4t
	 l4y8VvkwyvXOc7cofXry9WgC6xDq9YPLCicLfbMRVBxMZZEN3f88Sc2FjC0MHEEOV0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019065;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=hyyvwqh0yUCrKvJZHku7usPSuKgxk7/6YeOVXPVE234=;
	b=NLdgR1mvsI8RRFQtNDpOOzATRxUlteMp13nF1FTpFl2H1hUpZ0k29qC+bCzf2oBO1CvV
	 kWvEhcz45JCjgo0FLPQtCN6CRDFJKUw5I1pajfGvJTEVDEkdTMaGr34g/TNW9TXTQwrU5
	 7dleW19z8xbNeLCasB7jyqaPXw2wdXLOKetbFQFQB6bVzjBpDb5M/pEWqcuQKl+gQg/Rw
	 MeMQx+hd0uhiC7kp/NnxS7GBlRRKhHK82wC3KO1cCFUcuoJjb7X96iQ+YFj1fsK3MNNMR
	 bX23YWf6wBHoXX1oeyu6CTNodP4ep/kaTfsA6FCI0ZBi+tMlr7vgSzP+DfJn+xOAUnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYQ6iK1v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2581060A262E;
	Wed, 18 Nov 2026 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYQ6iK1v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEF51F000C5;
	Wed, 18 Nov 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795019064;
	bh=hyyvwqh0yUCrKvJZHku7usPSuKgxk7/6YeOVXPVE234=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VYQ6iK1vi6FHFW84MrhdkFONbt4aEau9XczusyK5CLhQaKISBgiYb9QEf+pMVSAZC
	 7CS7yb2kyDszUaZVo4m6EjIIYx0AgTpRIGFoJqZ2l0THzAAC7tCdolmeWTJk0hVT+j
	 vLYFsbBA1lZ173kFzYIBhEhmgyd0/XlKq8bTr3s8YbxDYXdRv/ou8P1BCjbckSoiqw
	 6YroToxg40CQAFHKtUr5oGvZ+98pujuxWDEuGK11S2xMJtqrCBH0GV7397ngf3xNC9
	 vtzs8fYfKBNXsug2DAwNIrwmN+t1++HWGwVk/IO/HD+jAyxv+l2X3Hmymi/9B8sNn0
	 mWvWbR9ojFiVQ==
Message-ID: <02c600ac-c968-4143-9e70-ccd2da858e09@kernel.org>
Date: Wed, 18 Nov 2026 17:24:19 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 4/7] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Content-Language: en-US
To: "Harry Yoo (Meta)" <harry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-4-9034dd4ecaab@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-4-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/26 16:09, Harry Yoo (Meta) wrote:
> When kmalloc_nolock() successfully grabs a slab object but memcg aborts
> the allocation, the object is freed via __slab_free(). Calling
> __slab_free() in unknown context is not allowed and can lead to a
> deadlock.
> 
> Free the object via defer_free() when spinning is not allowed.
> 
> While at it, try freeing the object to the percpu sheaves first in both
> contexts, as kmem_cache_free_bulk() already does for bulk allocations.
> This also avoids queueing an irq_work for every failed charge when
> spinning is not allowed.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

nit (not worth respinning just for that)

> ---
>  mm/slab.h |  8 ++++++++
>  mm/slub.c | 22 +++++++++++++++++-----
>  2 files changed, 25 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 15b0d98ae1d4..fb80a72ad952 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -37,6 +37,14 @@ static inline unsigned int to_alloc_flags(unsigned int free_flags)
>  		return SLAB_ALLOC_DEFAULT;
>  }
>  
> +static inline unsigned int to_free_flags(unsigned int alloc_flags)
> +{
> +	if (alloc_flags & SLAB_ALLOC_NOLOCK)
> +		return SLAB_FREE_NOLOCK;
> +	else
> +		return SLAB_FREE_DEFAULT;
> +}
> +
>  static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
>  {
>  	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
> diff --git a/mm/slub.c b/mm/slub.c
> index 7c0adc104988..8252c0b681cc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2531,7 +2531,8 @@ static inline void slab_obj_ext_has_codetag_init(void)
>  
>  #ifdef CONFIG_MEMCG
>  
> -static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
> +static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
> +				     unsigned int alloc_flags);
>  
>  static __fastpath_inline
>  bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
> @@ -2549,7 +2550,7 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
>  		return true;
>  
>  	if (likely(size == 1)) {
> -		memcg_alloc_abort_single(s, *p);
> +		memcg_alloc_abort_single(s, *p, ac->alloc_flags);
>  		*p = NULL;
>  	} else {
>  		kmem_cache_free_bulk(s, size, p);
> @@ -6647,18 +6648,29 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  #ifdef CONFIG_MEMCG
>  /* Do not inline the rare memcg charging failed path into the allocation path */
>  static noinline
> -void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
> +void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
> +			      unsigned int alloc_flags)
>  {
>  	struct slab *slab = virt_to_slab(object);
> -	unsigned int free_flags = SLAB_FREE_DEFAULT;
> +	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
> +	unsigned int free_flags = to_free_flags(alloc_flags);
>  
>  	if (slab_want_init_on_free(s))
>  		free_flags |= SLAB_FREE_INIT;
>  
>  	alloc_tagging_slab_free_hook(s, slab, &object, 1);
>  
> -	if (likely(slab_free_hook(s, object, free_flags)))
> +	if (unlikely(!slab_free_hook(s, object, free_flags)))
> +		return;
> +
> +	if (likely(can_free_to_pcs(slab)) &&
> +	    likely(free_to_pcs(s, object, allow_spin)))

I think it could be a single likely(x && y)

> +		return;
> +
> +	if (likely(allow_spin))
>  		__slab_free(s, slab, object, object, 1, _RET_IP_);
> +	else
> +		defer_free(s, object);
>  }
>  #endif
>  
> 

