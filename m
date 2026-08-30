Received: from mta0.migadu.com (out-201.mta0.migadu.com [91.218.175.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E222571DA
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 09:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788081822; cv=none; b=mlqzzRp/jnfwvy9NEbiCsGuM/0HxUZLdBI2buxL3H/o9Konkc88ShHA+dS1XMq6nVC4rA0r1eCiI6y+PiDGtL5nSuFZa8hREd0Vq+mbe7c6xjkcFwygyJAN8P3+6grl9CXU/AbcjP6+aQr2fspQ1fGpaeEDuKv1S23bGw73H1Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788081822; c=relaxed/simple;
	bh=jKjkjhNXcmDtFarhVB4q9KhIzqF2CfBDnbDyY+pXTh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZxVxS6QeWF8qCi91v/aXZwosy2rF2oklZT105ZOu7w3QPQkZbfYvn9QgHHtjU+UqrakDkC2magoP+gIYjHfvcskeFNd5GhLeHf1FxYUezvJxR4PsMPCzYjXAARSlLkwIxN3s2gw++MxfaZRTB6J6R9P4d4vSPsaQL+FtWTkcRwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z5qBH8oi; arc=none smtp.client-ip=91.218.175.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z5qBH8oi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jKjkjhNXcmDtFarhVB4q9KhIzqF2CfBDnbDyY+pXTh0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788081817; v=1; x=1788686617;
 b=Z5qBH8oi1GQxJg8h+SKU4TyvEw3ZuNh8YyxPEL6fJtaMJi06inn7XTCTvNsXYH2Ha/XM6Rdo
 pmBLwK9Ov6KVish8Zo6AMsCfRiDpNCR0rFPfn3YmCUG7E1LqwENFnd/EE7ApsOQ5czdj0kVVI1u
 BXJzviccRitczqhql7z8fOug=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 313c9a3f512e14d9;
	Sun, 30 Aug 2026 09:23:27 +0000
X-Mizu-Trace-ID: 313c9a3f512e14d9
X-Migadu-Flow: FLOW_OUT
Message-ID: <77a3aa03-a2ef-4c7f-a11b-6759b700c562@linux.dev>
Date: Sun, 30 Aug 2026 17:23:13 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately from the MGLRU
> refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
> PG_referenced and the refs counter bits together describe the
> referenced status of a folio.
> 
> Consolidate the two: rename folio_migrate_refs() to
> folio_migrate_lru_refs() and let it copy the complete referenced
> status, i.e., the MGLRU refs count including PG_referenced, or just
> PG_referenced for the active/inactive LRU. Drop the open-coded
> PG_referenced copy so the referenced status is transferred in one
> place. No behavior change is intended: under the active/inactive LRU
> the extra bits are unused, so operating on them is a noop.
> 
> Transfer the reference state first, before the destination folio is
> marked uptodate, so a concurrent lockless reader cannot have its
> reference update overwritten by the copy.
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 20 +++++++++++++++-----
>   mm/migrate.c              |  6 +++---
>   2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index edfaf2661812..7f91a89b5ba3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -365,11 +365,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   	return true;
>   }
>   
> -static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> +/**
> + * folio_migrate_lru_refs - copy the reference state to a new folio
> + * @new: the destination folio
> + * @old: the source folio
> + *
> + * Transfer the reference state to @new during migration: the MGLRU
> + * refs count, including PG_referenced, or just PG_referenced for the
> + * active/inactive LRU.
> + */
> +static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>   {
> -	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
> -
> -	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
> +	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
> +	folio_set_lru_refs(new, folio_lru_refs(old));
>   }
>   #else /* !CONFIG_LRU_GEN */
>   
> @@ -398,8 +406,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   	return false;
>   }
>   
> -static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> +static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>   {
> +	if (folio_test_referenced(old))
> +		folio_set_referenced(new);
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..a369d0c95c38 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>   {
>   	int cpupid;
>   
> -	if (folio_test_referenced(folio))
> -		folio_set_referenced(newfolio);
> +	/* Copy the reference state, including PG_referenced */
> +	folio_migrate_lru_refs(newfolio, folio);
> +
>   	if (folio_test_uptodate(folio))
>   		folio_mark_uptodate(newfolio);
>   	if (folio_test_clear_active(folio)) {
> @@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>   	if (folio_test_idle(folio))
>   		folio_set_idle(newfolio);
>   
> -	folio_migrate_refs(newfolio, folio);
>   	/*
>   	 * Copy NUMA information to the new page, to prevent over-eager
>   	 * future migrations of this same page.
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

