Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BA64207A
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 02:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787019844; cv=none; b=uQnoRFB7+EoxFC4AAPtdFSZEnD9mlGly4XBgdAMQcUGfTBYT5xT9Et9wnc8jTfgryUyn51H2Oq6tj4Xhjx/ZI7PlmnTQU85Yur2ULp19L5K5wiIt1PsUrN3Oq0ClB98QHcBez3HbuPSpOEZmPKYQ0HxLynU6O8wuRz1rxHTt9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787019844; c=relaxed/simple;
	bh=Kj2l2s2b8Q7rDIIPhTRWO4Dg9LJTGn1lCoLDlO7EmgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ro1NQK3O0BxHv1FmdJ46Uz1/NIjuXkCYNRi5mE9oAQAntV2so3juJbIAZDPGMxvpDlDhHb24auVZhPtn94LqCKg2c0sNpLWgloyCXVJM8u4xJKEqdzSt21b3f/Ia4v1QbG+seXnUfnX23++GmxGkzoZdn5u+sb7UTCZIKPcpTMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C9jlnSUc; arc=none smtp.client-ip=95.215.58.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C9jlnSUc"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Kj2l2s2b8Q7rDIIPhTRWO4Dg9LJTGn1lCoLDlO7EmgE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787019839; v=1; x=1787624639;
 b=C9jlnSUcGwHDmE3s0RPE+SKlAINM3jlE5a6QqyqzjIKdxichgmfnsI+SL6J0WHAjxrbjmKMM
 rGbpa39424hV5xrfQ2P68GOCZ91kxcwcZuEomTWz8LVpeeEp6bf6/aU8O3aSHYsFCDmA3TTj3CJ
 fheAYhQupPSsZxyS0C190b8o=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id d2aa8026bf3fbfef;
	Tue, 18 Aug 2026 02:23:59 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 10:23:51 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 05/15] mm/mglru: move max_seq read into
 walk_update_folio
Message-ID: <aoPCNxyRVpQFulwS@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-5-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-5-4d8dad39dad6@tencent.com>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> walk_pte_range(), walk_pmd_range_locked(), and lru_gen_look_around()
> each read lrugen->max_seq to compute the target generation for
> folio_update_gen(), then pass it as a parameter to
> walk_update_folio().  Move the read into walk_update_folio() itself
> so the callers no longer need to compute or pass the value.
> 
> This is a pure refactoring: no functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 29 ++++++++++++-----------------
>  1 file changed, 12 insertions(+), 17 deletions(-)

Nice clean up.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b02d2ec8ff4b..c2ea92c2b69e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3511,13 +3511,15 @@ static bool suitable_to_scan(int total, int young)
>  }
>  
>  static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
> -		struct folio *folio, int new_gen, bool dirty)
> +			      struct lruvec *lruvec, struct folio *folio, bool dirty)
>  {
> -	int old_gen;
> +	int new_gen, old_gen;
>  
>  	if (!folio)
>  		return;
>  
> +	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
> +
>  	if (dirty && !folio_test_dirty(folio) &&
>  	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>  	      !folio_test_swapcache(folio)))
> @@ -3548,8 +3550,6 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  	struct lru_gen_mm_walk *walk = args->private;
>  	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>  	unsigned int nr;
>  	pmd_t pmdval;
>  
> @@ -3600,7 +3600,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  			continue;
>  
>  		if (last != folio) {
> -			walk_update_folio(walk, args->vma, last, gen, dirty);
> +			walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>  
>  			last = folio;
>  			dirty = false;
> @@ -3613,7 +3613,7 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  		walk->mm_stats[MM_LEAF_YOUNG] += nr;
>  	}
>  
> -	walk_update_folio(walk, args->vma, last, gen, dirty);
> +	walk_update_folio(walk, args->vma, walk->lruvec, last, dirty);
>  	last = NULL;
>  
>  	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
> @@ -3636,8 +3636,6 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  	struct lru_gen_mm_walk *walk = args->private;
>  	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
>  	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
> -	DEFINE_MAX_SEQ(walk->lruvec);
> -	int gen = lru_gen_from_seq(max_seq);
>  
>  	VM_WARN_ON_ONCE(pud_leaf(*pud));
>  
> @@ -3691,7 +3689,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  			goto next;
>  
>  		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>  
>  			last = folio;
>  			dirty = false;
> @@ -3705,7 +3703,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
>  	} while (i <= MIN_LRU_BATCH);
>  
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, walk->lruvec, last, dirty);
>  
>  	lazy_mmu_mode_disable();
>  	spin_unlock(ptl);
> @@ -4270,8 +4268,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  	struct pglist_data *pgdat = folio_pgdat(folio);
>  	struct lruvec *lruvec;
>  	struct lru_gen_mm_state *mm_state;
> -	unsigned long max_seq;
> -	int gen;
>  
>  	lockdep_assert_held(pvmw->ptl);
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
> @@ -4308,8 +4304,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  
>  	memcg = get_mem_cgroup_from_folio(folio);
>  	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
> -	gen = lru_gen_from_seq(max_seq);
>  	mm_state = get_mm_state(lruvec);
>  
>  	lazy_mmu_mode_enable();
> @@ -4341,7 +4335,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  			continue;
>  
>  		if (last != folio) {
> -			walk_update_folio(walk, vma, last, gen, dirty);
> +			walk_update_folio(walk, vma, lruvec, last, dirty);
>  
>  			last = folio;
>  			dirty = false;
> @@ -4353,13 +4347,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>  		young += nr;
>  	}
>  
> -	walk_update_folio(walk, vma, last, gen, dirty);
> +	walk_update_folio(walk, vma, lruvec, last, dirty);
>  
>  	lazy_mmu_mode_disable();
>  
>  	/* feedback from rmap walkers to page table walkers */
>  	if (mm_state && suitable_to_scan(i, young))
> -		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> +		update_bloom_filter(mm_state, READ_ONCE(lruvec->lrugen.max_seq),
> +				    pvmw->pmd);
>  
>  	mem_cgroup_put(memcg);
>  
> 
> -- 
> 2.55.0
> 
> 
