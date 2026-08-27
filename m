Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3062222D0;
	Thu, 27 Aug 2026 07:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787815953; cv=none; b=RgkwmgGLhOgyhWgzFJNm0Sv5ngxaQuj6PWcdHXrjMwiwGudzgWB9+CaZTZO0ySWocWjrI38sOXClERJ+cr/Z8pUQK9XEF9jxZtlWTFrKM7IW4CMt1f0Rr+tnZM/TBCD/gmjqt0DHEB+Wb+lbKNAmM6V4QAjE6WyA+7MvuP7lULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787815953; c=relaxed/simple;
	bh=m/IUh5vWdp05I91FdU9FFCUbneRH2ablukvqioB+QN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OyDIjB7iA6RTV/zolaQ9e+OqBWXGvRKlCjXhkZGuw1wJW7rssy/eAEJ6brqHnXRK5AfuPgJZ27e39BI4fVab19uA6DCWePUne1MUHYRFnopScPa9pLOdWPkUOVodEJVGzIYuXF8t7/Uo96XqqtvrpNdv6c1n2rh9DdxtCBOvPgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=FupuD1xs; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="FupuD1xs"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787815941; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4sG7+nBmHRwh15LAkXXadWbM2qxgBs1B91w5R9xHSTk=;
	b=FupuD1xsOnJ9ecbAqSlkUl0iZ/LQx3LWZKnE5WQyiMx7q7aN4bilh4vxkNPbvcDG/XXbYjuKyL3CaW/AzuDmA1Z58l6mUpsuUsqBJruYjAYUTtOrAixFlOn2vsXiYdmSbg3s936FNON+PIl922ZXdZ8+CIR0BY5b5m84j3iNsxQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X9iwBVj_1787815939;
Received: from 30.74.144.120(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9iwBVj_1787815939 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 15:32:19 +0800
Message-ID: <fbb40ab7-6942-4983-9621-ab8d5d50474f@linux.alibaba.com>
Date: Thu, 27 Aug 2026 15:32:18 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/26/26 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting a folio's refs and generation info, making the code easier
> to debug and understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states. There is
> no measurable performance impact, and some paths even look slightly
> better in the generated assembly.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
>   include/linux/mmzone.h    |  1 +
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
>   4 files changed, 114 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..edfaf2661812 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +	gen -= 1;
> +	VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> +	return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and (MAX_NR_GENS - 1), inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS || gen < 0);
> +
> +	*flags &= ~LRU_GEN_MASK;
> +	*flags |= (gen + 1UL) << LRU_GEN_PGOFF;
> +}
>   
> +/**
> + * lru_refs_from_flags - Return LRU referenced / access count from folio flags.
> + * @flags: folio flags
> + */
> +static inline int lru_refs_from_flags(unsigned long flags)
> +{
>   	if (!(flags & BIT(PG_referenced)))
>   		return 0;
>   	/*
> @@ -155,11 +187,40 @@ static inline int folio_lru_refs(const struct folio *folio)
>   	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
>   }
>   
> -static inline int folio_lru_gen(const struct folio *folio)
> +/**
> + * lru_refs_set_flags - Set the LRU referenced / access count to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @refs: referenced / access count number, between 0 and LRU_REFS_MAX, inclusive.
> + */
> +static inline void lru_refs_set_flags(unsigned long *flags, unsigned int refs)
> +{
> +	VM_WARN_ON_ONCE(refs > LRU_REFS_MAX);
> +	BUILD_BUG_ON(LRU_REFS_MAX != (LRU_REFS_MASK >> LRU_REFS_PGOFF) + 1);
> +
> +	*flags &= ~LRU_REFS_FLAGS;
> +	if (!refs)
> +		return;
> +	*flags |= (BIT(PG_referenced) | ((refs - 1UL) << LRU_REFS_PGOFF));
> +}
> +
> +static inline int folio_lru_refs(const struct folio *folio)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	return lru_refs_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
> +}
> +
> +static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +
> +	do {
> +		new_flags = old_flags;
> +		lru_refs_set_flags(&new_flags, refs);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +}
>   
> -	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +	return lru_gen_from_flags(READ_ONCE(*const_folio_flags(folio, 0)));
>   }
>   
>   static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
> @@ -270,7 +331,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	gen = lru_gen_from_seq(seq);
>   	flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   	/* see the comment on MIN_NR_GENS about PG_active */
> -	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> +	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
>   
>   	lru_gen_update_size(lruvec, folio, -1, gen);
>   	/* for folio_rotate_reclaimable() */
> @@ -295,7 +356,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   	/* for folio_migrate_flags() */
>   	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
> -	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
>   	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>   
>   	lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +400,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>   {
> -
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..c9ecf370cd9f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -497,6 +497,7 @@ enum lruvec_flags {
>   
>   #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
>   #define LRU_REFS_MASK		((BIT(LRU_REFS_WIDTH) - 1) << LRU_REFS_PGOFF)
> +#define LRU_REFS_MAX		BIT(LRU_REFS_WIDTH)
>   
>   /*
>    * For folios accessed multiple times through file descriptors,
> diff --git a/mm/folio.c b/mm/folio.c
> index c02dcea9c03c..a932059057ac 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
>   
>   static void lru_gen_inc_refs(struct folio *folio)
>   {
> -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	int refs;
>   
>   	if (folio_test_unevictable(folio))
>   		return;
>   
>   	/* see the comment on LRU_REFS_FLAGS */
> -	if (!folio_test_referenced(folio)) {
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> +	if (!folio_lru_refs(folio)) {
> +		folio_set_lru_refs(folio, 1);
>   		return;
>   	}
>   
>   	do {
> -		if ((old_flags & LRU_REFS_MASK) == LRU_REFS_MASK) {
> +		new_flags = old_flags;
> +		refs = lru_refs_from_flags(old_flags);
> +		if (refs == LRU_REFS_MAX) {
>   			if (!folio_test_workingset(folio))
>   				folio_set_workingset(folio);
>   			return;
>   		}
> -
> -		new_flags = old_flags + BIT(LRU_REFS_PGOFF);
> -	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
> +		lru_refs_set_flags(&new_flags, refs + 1);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   }
>   
>   static bool lru_gen_clear_refs(struct folio *folio)
> @@ -384,7 +386,8 @@ static bool lru_gen_clear_refs(struct folio *folio)
>   	if (gen < 0)
>   		return true;
>   
> -	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
> +	folio_set_lru_refs(folio, 0);

Actually this clears the folio's refs counter. Would it be more readable 
to introduce a folio_clear_lru_refs(folio) helper and use it for all the 
other folio_set_lru_refs(folio, 0) calls too?

Otherwise LGTM. Thanks for the cleanup.
