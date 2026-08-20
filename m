Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133652D7DE9
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 02:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787192038; cv=none; b=gZUMdnTaXSy8O86iEWWYqewqJtz9EJFHzSkhIbuJ8Xu8u2XvAoICW7DLvP2CZWV+gzsJuUASGHWUD839Vz434BSHqsDxIUk8zfHG6nXbBXM2ChPn1V9eFP7Kit88eS0pYDLrlshtJ1mlfymSP5Qo7Qk5V4BVvDUpiosrCLzxHiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787192038; c=relaxed/simple;
	bh=LuPpbLrg2mFJpP3Oijmcwi0b1Io6UxYacsdMENBArMg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nc0751FhA8PUPzyXiCf3YLCkSAirOmlT2xFeHUUzY6Wgmef2+zOlWgqingL6pgD44+U5uTh7qnuWG1taKx7EFwW0afp9IIRoVuxsApUVq/esDQGMg3HBzh60NR6FgKjkrq4wC7lcxqqezF0sI2QPNEwqN4CgCn1dIqJGqS4jYDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wneUFUWU; arc=none smtp.client-ip=91.218.175.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wneUFUWU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LuPpbLrg2mFJpP3Oijmcwi0b1Io6UxYacsdMENBArMg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787192033; v=1; x=1787796833;
 b=wneUFUWUm2IeWp8KP5Pw0LjIcMkzU9p+6+WGUQ4uODh1W7iL6TCVMCRyVX1UU7acPAz/lY6O
 ryHTQ2vyV5Sx1OVTpBXWekABvDWwF+AzkV9SK0ETL9OKSirxHZOzXDb/LdPln4taONtov1z5JJi
 b/BXCfRb1qVYEeU1byARKzHw=
X-Envelope-To: cgroups@vger.kernel.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id e44608bd8b5d53f7;
	Thu, 20 Aug 2026 02:13:42 +0000
X-Mizu-Trace-ID: e44608bd8b5d53f7
X-Migadu-Flow: FLOW_OUT
Message-ID: <e25532ec-04c8-4d88-974d-17478da87a3b@linux.dev>
Date: Thu, 20 Aug 2026 10:13:36 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] mm/mglru: move max_seq read into walk_update_folio
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
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-4-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/2026 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation used by
> walk_update_folio(), then pass it as a parameter. Move the read into
> walk_update_folio() itself so the callers no longer need to compute
> or pass the value.
> 
> The max_seq read now happens once per folio update rather than once
> per walk range, so folios always get promoted to the current youngest
> generation.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> ---
>   mm/vmscan.c | 29 ++++++++++++-----------------
>   1 file changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 080132997d87..a819be6b7ae9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3517,13 +3517,15 @@ static bool suitable_to_scan(int total, int young)
>   }
>   
>   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> -		struct folio *folio, int new_gen, bool dirty)
> +			      struct lruvec *lruvec, struct folio *folio, bool dirty)
>   {
> -	int old_gen;
> +	int new_gen, old_gen;
>   
>   	if (!folio)
>   		return;
>   
> +	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
> +
>   	if (dirty && !folio_test_dirty(folio) &&
>   	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>   	      !folio_test_swapcache(folio)))
> @@ -3554,8 +3556,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>   	struct lru_gen_mm_walk *walk = args->private;
>   	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>   	unsigned int nr;
>   	pmd_t pmdval;
>   
> @@ -3606,7 +3606,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>   			continue;
>   
>   		if (last != folio) {
> -			walk_update_folio(walk, args->vma, last, gen, dirty);
> +			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>   
>   			last = folio;
>   			dirty = false;
> @@ -3619,7 +3619,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>   		walk->mm_stats[MM_LEAF_YOUNG] += nr;
>   	}
>   
> -	walk_update_folio(walk, args->vma, last, gen, dirty);
> +	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>   	last = NULL;
>   
>   	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
> @@ -3642,8 +3642,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>   	struct lru_gen_mm_walk *walk = args->private;
>   	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>   	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>   
>   	VM_WARN_ON_ONCE(pud_leaf(*pud));
>   
> @@ -3697,7 +3695,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>   			goto next;
>   
>   		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>   
>   			last = folio;
>   			dirty = false;
> @@ -3711,7 +3709,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>   		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
>   	} while (i <= MIN_LRU_BATCH);
>   
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>   
>   	lazy_mmu_mode_disable();
>   	spin_unlock(ptl);
> @@ -4275,8 +4273,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   	struct pglist_data *pgdat = folio_pgdat(folio);
>   	struct lruvec *lruvec;
>   	struct lru_gen_mm_state *mm_state;
> -	unsigned long max_seq;
> -	int gen;
>   
>   	lockdep_assert_held(pvmw->ptl);
>   	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> @@ -4313,8 +4309,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   
>   	memcg = get_mem_cgroup_from_folio(folio);
>   	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
> -	gen = lru_gen_from_seq(max_seq);
>   	mm_state = get_mm_state(lruvec);
>   
>   	lazy_mmu_mode_enable();
> @@ -4346,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   			continue;
>   
>   		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, lruvec, last, dirty);
>   
>   			last = folio;
>   			dirty = false;
> @@ -4358,13 +4352,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>   		young += nr;
>   	}
>   
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, lruvec, last, dirty);
>   
>   	lazy_mmu_mode_disable();
>   
>   	/* feedback from rmap walkers to page table walkers */
>   	if (mm_state && suitable_to_scan(i, young))
> -		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
> +				    pvmw->pmd);
>   
>   	mem_cgroup_put(memcg);
>   
> 

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

-- 
Best regards
Ridong

