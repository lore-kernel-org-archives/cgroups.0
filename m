Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9342BFC8F
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 10:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787134332; cv=none; b=XrtaSL4WpsGAAq3U6sZzJolkdTjHRbh4PI5dVO+GJTKTOeaRq0zHCo/wFGjpua822A0kIMJfnzYwUm0sZqDCJoKOUTuHndcoYubeO8+r+dQot9pwxo5GFp2/rv542mk+cbzyP1Oj3TdkydyO2l+WOjRXj26on9TpNat0mEOXcTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787134332; c=relaxed/simple;
	bh=9UOPR3VqdNQVe5zByqIvc6J7eUFOw5VtzuU3+toi5KU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RjnN2T0w4GkVuY7cy8pnVOpilngBGUfl0H2gzkP+kkFFfoKvc29GW1r1tsM+Hvpg67UHGOr/DobJuMGdVldFS8v9yGMBRxc5bT8co3PqUHRG8xolwGuuXXySHRgGargOu+2aN9hb0HYMctUD+nCVCkIOR/ZJylptl7Ma6P4zHpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KKmhmIcQ; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KKmhmIcQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9UOPR3VqdNQVe5zByqIvc6J7eUFOw5VtzuU3+toi5KU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787134328; v=1; x=1787739128;
 b=KKmhmIcQYty2jYVD4tVwmt8tpqRA58SmBVXhXFoW4f/YaTWfMx+obp7Ow62x0hIpoHm0DxwG
 eJUR0yFI6VwG9ek5j9dlmrsKhNvCzIcLVSrr33ggut+dEcSQFIStWgG87XMEBYkQV8v45AgQZwc
 ZKFUftl0/q/1JJBDNTsx02/U=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 383ad5f4fd629cc5;
	Wed, 19 Aug 2026 10:12:07 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 19 Aug 2026 18:12:03 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH 3/7] mm/migrate: copy the referenced state via
 folio_migrate_refs()
Message-ID: <aoWBcz4sZH1iFzn5@MiWiFi-R3L-srv>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-mglru-flags-cleanup-v1-3-8dbbdac0d28c@tencent.com>

On 08/18/26 at 01:38pm, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately, while
> folio_migrate_refs() copies the rest of the reference state. Make
> folio_migrate_refs() copy the complete state, i.e., PG_referenced plus
> the MGLRU refs counter, in both LRU implementations, and drop the
> open-coded copy so the reference state is transferred in one place.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 16 +++++++++++++---
>  mm/migrate.c              |  4 ++--
>  2 files changed, 15 insertions(+), 5 deletions(-)

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 93bf3fa221f8..df62daaa2ee7 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -366,11 +366,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  	return true;
>  }
>  
> +/**
> + * folio_migrate_refs - copy the reference state to a new folio
> + * @new: the destination folio
> + * @old: the source folio
> + *
> + * Transfer the reference state to @new during migration: the MGLRU
> + * refs count, including PG_referenced, or just PG_referenced for the
> + * active/inactive LRU.
> + */
>  static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>  {
> -	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
> -
> -	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
> +	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
> +	folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>  #else /* !CONFIG_LRU_GEN */
>  
> @@ -401,6 +409,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>  
>  static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
>  {
> +	if (folio_test_referenced(old))
> +		folio_set_referenced(new);
>  }
>  #endif /* CONFIG_LRU_GEN */
>  
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..82307332711f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -776,8 +776,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  {
>  	int cpupid;
>  
> -	if (folio_test_referenced(folio))
> -		folio_set_referenced(newfolio);
>  	if (folio_test_uptodate(folio))
>  		folio_mark_uptodate(newfolio);
>  	if (folio_test_clear_active(folio)) {
> @@ -807,7 +805,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  	if (folio_test_idle(folio))
>  		folio_set_idle(newfolio);
>  
> +	/* Copy the reference state, including PG_referenced */
>  	folio_migrate_refs(newfolio, folio);
> +
>  	/*
>  	 * Copy NUMA information to the new page, to prevent over-eager
>  	 * future migrations of this same page.
> 
> -- 
> 2.55.0
> 
> 
