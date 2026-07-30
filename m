Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E97D37EFF0
	for <cgroups@vger.kernel.org>; Thu, 30 Jul 2026 11:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410541; cv=none; b=gJ7pW0nYfP2nWOvBGY6MLZWbeFXf7T0rIyw6sbxD59i6VUP9L0P0Hf42SmmBfwy6+Fax4BG3OYQsOMOi78X5nLZNytJ/34Z53mG7Zq0cD4Igbf9W9yv369n+tccqnVaG1I0w7hmYL2CMEo6xqZDaRx1tfOOnTaoVkOI16WJXrdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410541; c=relaxed/simple;
	bh=4c6g8wzdh6Gl7P51OiYB51v9k74xjGrrTpZaVBxr95Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiivqDrucwf9DU5G8yMoz5ZGiUwVYNyngWz7CELPMxE4RjAlAYOn5f1GqePYXUJWlEYCpfntWgPwfGQg0ARtUMGMs7PMO9+3T97rwPQxewgbnYhGbZiHX9L3LdKk45KRlXnViVmSa1ol7wuRKrT8SyUyo/aMEpEMCy+npz8LOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OvZ8YvEL; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OvZ8YvEL"
Date: Thu, 30 Jul 2026 19:22:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785410536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TKND6MQhitky6AK8I8URBuiLbKqrzysrMataDDQjVEA=;
	b=OvZ8YvELSC6kq5gZn5UmKYrOkmnr2uti1utheoSblTZ9jCzUsfwb0W/GG5WGKVHatpCuIq
	1CHPTXQ08w3MMgkQ9JsFHANRvDL3XH5dN3fBMpXzUPDQJcqgqpS5ve81v11fVmo5q1HHyG
	fAKp4Odt0FfNCBSm4GYC4qgBOm3GR5I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 02/13] mm/slab: remove objs_per_slab()
Message-ID: <amszNthftz0OVxxA@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-2-c29ef0f1f257@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260727-b4-objext_split-v3-2-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 27, 2026 at 02:53:56PM +0200, Vlastimil Babka (SUSE) wrote:
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
> to a bit-field" but we don't need to keep a wrapper just for that.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasayan <surenb@google.com>

Oops, the r-b tag got duplicated :)

> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/kfence_test.c | 2 +-
>  mm/slab.h               | 6 ------
>  mm/slub.c               | 3 +--
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index de2d0f7d62b1..9867c03ef0ae 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
>  			 * memcg accounting works correctly.
>  			 */
>  			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
> -			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
> +			KUNIT_EXPECT_EQ(test, ((unsigned int)slab->objects), 1);
>  
>  			if (policy == ALLOCATE_ANY)
>  				return alloc;
> diff --git a/mm/slab.h b/mm/slab.h
> index f5e336b6b6b0..01535e1e2d3c 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
>  	return __obj_to_index(cache, slab_address(slab), obj);
>  }
>  
> -static inline int objs_per_slab(const struct kmem_cache *cache,
> -				const struct slab *slab)
> -{
> -	return slab->objects;
> -}
> -
>  /*
>   * State of the slab allocator.
>   *
> diff --git a/mm/slub.c b/mm/slub.c
> index d702d273253c..b94482830637 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2130,7 +2130,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  			gfp_t gfp, unsigned int alloc_flags)
>  {
>  	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
> -	unsigned int objects = objs_per_slab(s, slab);
>  	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
>  	unsigned long new_exts;
>  	unsigned long old_exts;
> @@ -2186,7 +2185,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  #endif
>  retry:
>  	old_exts = READ_ONCE(slab->obj_exts);
> -	handle_failed_objexts_alloc(old_exts, vec, objects);
> +	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
>  
>  	if (new_slab) {
>  		/*
> 
> -- 
> 2.55.0
> 

-- 
Thanks,
Hao
