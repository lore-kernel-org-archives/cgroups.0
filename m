Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F054334C3
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 13:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786542521; cv=none; b=fJuj0sjKgiirNBftU6zaAxOF3KZIU+b8am2KhtMPoMYtlRp1ikGGA/K6lliO3PWkSh2eSecJFJPCnarNejWr2WPOAatWDxETo/FSAh2mT6nYyREn2P8cmY5Z7herQ+XwcLB5BJqrUxIXDNFNeaMps2V+imNnJv+yRTYF53BQMEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786542521; c=relaxed/simple;
	bh=ASMCgRYWFh1U8hGKVOolQ/aTQ/PK231J3u3FwxsWacs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b/XkMOjzJmzc/H/P32nNH9RIXGTjq6NwYv16wnMgYyI1wFjpcbtO0DOb0CcprT4b/BwBCj/LjamJhLvVFrnH9KIWQJXIYBN9MCn9uS4yWb1ONYNxO2SNOH77OtEQf4YtDSuLNk603GnEfDABMdYvCo4x12eXB6A9ILPAJOarHzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bqt6VLL2; arc=none smtp.client-ip=91.218.175.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bqt6VLL2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ASMCgRYWFh1U8hGKVOolQ/aTQ/PK231J3u3FwxsWacs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786542517; v=1; x=1787147317;
 b=bqt6VLL2oPMWtajSw0sxl/NU0Mo2Oiu8rit8fZeSxMtlJERaEfHNKZKZGumb5o1F/v0QRCK2
 qUUzXNLihvi8GGJFN+FA5creF05Y21skfBl4r/uq1Rk1GluMrGOYCYW47E7+tLQu4EMtBrQmm9x
 8hNvs/6pH89NGSVYK7fZ3GIY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [192.168.1.116] (111.162.215.50)
	by smtp.migadu.com with ESMTPS id 18dd0f5011e94cb8;
	Wed, 12 Aug 2026 13:48:37 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <3ab5e2cb-0660-4b20-9e67-cb47e17ae554@linux.dev>
Date: Wed, 12 Aug 2026 21:48:26 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Harry Yoo <harry@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: Re: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg
 metadata
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260812124858.73487-1-guopeng.zhang@linux.dev>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260812124858.73487-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/8/12 20:48, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> obj_full_size() adds the size of an obj_cgroup pointer to s->size to
> account for slabobj_ext storage, which normally resides outside the
> object.
> 
> Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
> unused space within s->size"), slabobj_ext can reside in object padding
> already covered by s->size. The extra charge then accounts for the same
> memory twice.
> 
> The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
> ("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
> layout. Use it to omit the extra charge only for in-object metadata.
> Unlike in-object metadata, slab-leftover and separately allocated metadata
> are not covered by the per-object s->size charge, so retain the existing
> charge for those cases.
> 
> Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
> Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d1312441a02b..aef480f46891 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3526,12 +3526,16 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>  	refill_obj_stock(objcg, size, true);
>  }
>  
> -static inline size_t obj_full_size(struct kmem_cache *s)
> +static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
>  {
>  	/*
>  	 * For each accounted object there is an extra space which is used
> -	 * to store obj_cgroup membership. Charge it too.
> +	 * to store obj_cgroup membership. Charge it too, unless it is stored
> +	 * in object padding already covered by s->size.
>  	 */
> +	if (obj_exts_in_object(slab))
> +		return s->size;
> +
>  	return s->size + sizeof(struct obj_cgroup *);
>  }
>  
> @@ -3539,7 +3543,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  				  gfp_t flags, unsigned int slab_alloc_flags,
>  				  size_t size, void **p)
>  {
> -	size_t obj_size = obj_full_size(s);
>  	struct obj_cgroup *objcg;
>  	struct slab *slab;
>  	size_t i;
> @@ -3580,6 +3583,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  		unsigned long obj_exts;
>  		struct slabobj_ext *obj_ext;
>  		struct obj_stock_pcp *stock;
> +		size_t obj_size;
>  
>  		slab = virt_to_slab(p[i]);
>  
> @@ -3590,6 +3594,8 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  				continue;
>  		}
>  
> +		obj_size = obj_full_size(s, slab);
> +
>  		/*
>  		 * if we fail and size is 1, memcg_alloc_abort_single() will
>  		 * just free the object, which is ok as we have not assigned
> @@ -3632,7 +3638,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
>  void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
>  			    void **p, int objects, unsigned long obj_exts)
>  {
> -	size_t obj_size = obj_full_size(s);
> +	size_t obj_size = obj_full_size(s, slab);
>  
>  	for (int i = 0; i < objects; i++) {
>  		struct obj_cgroup *objcg;
> 
> base-commit: e7f630142df2afccce90555e4972e60008222311
Reviewed-by: Tao Cui <cuitao@kylinos.cn>

