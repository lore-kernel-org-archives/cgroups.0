Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475E2D593E;
	Wed, 19 Aug 2026 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787130199; cv=none; b=CUzQ2x5T2nZYbIh7Q0qY6i7+k6WCqLCptezAC2gyzakZ0VQd7aj4eHvlNJ61cxpkxZntYlDOcFOQ/H4Ax9iQAskNuHgwmEXkG8slTKKyg/pLj22jhiZtubT6DvzIzFBTzPrW9aGhz39tqjr+SnbEjefJ+15/WSYWlXpnlmrHqR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787130199; c=relaxed/simple;
	bh=FXhm+INXl6pRraNDbGN9idJd9TVgy36Mb6mOirGTX9U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mm+m4N5MD2pSEsZyhX8Q8Xgtunorrgj+cbfPGL9AJcYOaU/2GWaL/smC08l7IIjdWvdk4D82114MYyg6EEYI3mptYG0vss4ZkynchGwu7Amj6p0MElNfrfmc+u1cpZfxnDHFO25nYpZz2Q80I5x7xQy0usvmtlHS9Z0wUAY/szY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VN3rR5hI; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VN3rR5hI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787130187; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mD/Cl50XWzys0id4X5RVAR1gGagtP2IYMFAaW4ejKq4=;
	b=VN3rR5hIe2U2m+praqeDru6HfciQ+HdGqhDfWO/Rm+dz4aC7fACGfbM60HJzEOSiaQdGBpMexIJyglKmNxgGkkUDQsqrC7cRCdiQ3V7lF+8bjFwQRAij/RRTzdsKqN/X6UW+TecwEDkLndibAornQEYXBywSjn0J/4OXImofnVs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9GF3bp_1787130184;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9GF3bp_1787130184 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 17:03:05 +0800
Message-ID: <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
Date: Wed, 19 Aug 2026 17:03:04 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Instead of doing bit ops on folio->flags.f, introduce helpers for
> adjusting folio's refs and gen info, make the code easier to debug and
> understand.
> 
> No functional change is intended: some combined atomic operations are
> split into two, which only creates harmless transient states.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Thanks for the cleanups. One comment below.

>   include/linux/mm_inline.h | 79 +++++++++++++++++++++++++++++++++++++++++------
>   include/linux/mmzone.h    |  2 ++
>   mm/folio.c                | 19 +++++++-----
>   mm/vmscan.c               | 61 ++++++++++++++++++++----------------
>   4 files changed, 117 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7..93bf3fa221f8 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -142,10 +142,43 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
>   	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
>   }
>   
> -static inline int folio_lru_refs(const struct folio *folio)
> +/**
> + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> + * @flags: folio flags
> + *
> + * Returns: A number between 0 and LRU_GEN_MAX, inclusive. Returns -1 if the
> + * flags indicate the folio is off the list (e.g., isolated).
> + */
> +static inline int lru_gen_from_flags(unsigned long flags)
> +{
> +	int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> +
> +	BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> +	gen -= 1;
> +	VM_WARN_ON_ONCE(gen != -1 && gen > LRU_GEN_MAX);
> +	return gen;
> +}
> +
> +/**
> + * lru_gen_set_flags - Set the LRU generation number to specified folio flags.
> + * @flags: pointer to the folio flags
> + * @gen: generation number, between 0 and LRU_GEN_MAX, inclusive.
> + */
> +static inline void lru_gen_set_flags(unsigned long *flags, int gen)
>   {
> -	unsigned long flags = READ_ONCE(folio->flags.f);
> +	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX || gen < 0);
> +	BUILD_BUG_ON((LRU_GEN_MAX + 1) != MAX_NR_GENS);
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
> @@ -155,18 +188,47 @@ static inline int folio_lru_refs(const struct folio *folio)
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
>   {
>   	unsigned long max_seq = lruvec->lrugen.max_seq;
>   
> -	VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);
> +	VM_WARN_ON_ONCE(gen > LRU_GEN_MAX);
>   
>   	/* see the comment on MIN_NR_GENS */
>   	return gen == lru_gen_from_seq(max_seq) || gen == lru_gen_from_seq(max_seq - 1);
> @@ -270,7 +332,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   	gen = lru_gen_from_seq(seq);
>   	flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   	/* see the comment on MIN_NR_GENS about PG_active */
> -	set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> +	set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);
>   
>   	lru_gen_update_size(lruvec, folio, -1, gen);
>   	/* for folio_rotate_reclaimable() */
> @@ -295,7 +357,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   	/* for folio_migrate_flags() */
>   	flags = !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active) : 0;
> -	flags = set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
> +	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
>   	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>   
>   	lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -339,7 +401,6 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   
>   static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>   {
> -
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..32d9354a754f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -496,7 +496,9 @@ enum lruvec_flags {
>   #ifndef __GENERATING_BOUNDS_H
>   
>   #define LRU_GEN_MASK		((BIT(LRU_GEN_WIDTH) - 1) << LRU_GEN_PGOFF)
> +#define LRU_GEN_MAX		(BIT(LRU_GEN_WIDTH - 1) - 1)

There are still many places using MAX_NR_GENS to compare gen counters, 
so I'm concerned that introducing a new macro would make the use of the 
max gen counter even more confusing.
