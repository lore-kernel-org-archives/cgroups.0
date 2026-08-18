Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00870383C7C
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 07:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037136; cv=none; b=E0ISHZRxt5QeujmlpgUHJgGMCRAlBKRHrrMDmT6KMoo89GYYFrEPPXTNkIr4R6NLIxk6/kw93Y4mw8oLo6OgAYSgcUXjc6Zkx76gXzpI+DBCMelEX9fn3ku/+KibwQy/N2LvNMpWuiTdyBlrV7spdTSzcKVobBIvqZHvrrODtBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037136; c=relaxed/simple;
	bh=FPJDATMWoGt1TFbDMRPs4zDCkqR5X1QfRmCXxZRdMd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuY8d1o67DRDAVDH96KTxmOm9sn3yqyOc6n16tBnnwxO60xu+sQG2Oia/w7rh3ZPB9kjQIbMQfa+vdxScFBI/bmqx0GIe4mOqJ1usPqDoQlf2LFq53wm54/nGQR1DS20bK9q6+S5uIgI2kfeiCAR2uY19skFYBs7/p/DzPJpOuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HQ1hs5OQ; arc=none smtp.client-ip=91.218.175.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HQ1hs5OQ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FPJDATMWoGt1TFbDMRPs4zDCkqR5X1QfRmCXxZRdMd4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787037128; v=1; x=1787641928;
 b=HQ1hs5OQrXx8E917fOnxlLZsSrG2kY9wwGPc0+p5Hzk2siG2I15Q4BpPXMUyl2pM0TU3LXQt
 dDrzDU2YkplWOo4TewW7WpogwU4WuqiVk0OkW42cajq4Kyvej7rn4hw9hH5P0qjD5P7xiKa8z6Z
 //WbGNQCGkvZwgsNYA1Z5dUk=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id a42f6392fa17638b;
	Tue, 18 Aug 2026 07:12:08 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 15:12:03 +0800
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
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset
 promotion (MGLRU-FG)
Message-ID: <aoQFw_SWJBAdO8w-@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
...snip...
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{
> +	int max_gen, min_gen;
> +	int type, refs, gen, new_gen;
> +	unsigned long new_flags, old_flags, max_seq;
> +	struct lru_gen_folio *lrugen;
> +	struct lruvec *lruvec;
> +
> +	type = folio_is_file_lru(folio);
> +	lruvec = folio_lruvec_live_get(folio);
> +	lrugen = &lruvec->lrugen;
> +
> +	old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	do {
> +		new_flags = old_flags;
> +		gen = lru_gen_from_flags(old_flags);
> +		refs = lru_refs_from_flags(old_flags) + 1;
> +		new_gen = gen;
> +		if (!(old_flags & BIT(PG_lru)) || gen < 0)
> +			goto out;
> +
> +		max_seq = READ_ONCE(lrugen->max_seq);
> +		max_gen = lru_gen_from_seq(max_seq);
> +		min_gen = lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
> +		if (gen == max_gen)
> +			goto out;
> +

I am a little confused about the new mechanism. In the current mglru, it
does have the issue both mm walk and fd read set PG_referenced at the
1st access, this is a obvious drawback. Now with the change, the ref
count is clearer, while the mm walk and fd read accessing is still mixed.
Imagine the cases below:
 - one fd read; then mm walk; directly move to max_gen;
 - one mm walk; then several times fd read; promote to next gen;

Can I understand the final effect as:
1) explicti ref count;
2) more drastically promote mm walk based on the mixing ref counting;
   - compared with the old behaviour: move to next gen when 2nd mm walk

I can only see one benefit and one significant change. Do I understand
it correctly, and is it worth?

Thanks
Baoquan

> +		if (is_fault || is_exec) {
> +			/* Promote second page table access or executable */
> +			if (refs > LRU_REFS_REFERENCED || is_exec)
> +				new_gen = max_gen;
> +			else
> +				new_gen = (gen + 1UL) % MAX_NR_GENS;
> +			refs = min(refs, LRU_REFS_PROTECTED);
> +		} else if (refs > LRU_REFS_MAX) {
> +			/* LRU refs counting overflow, bump the gen */
> +			new_gen = (gen + 1UL) % MAX_NR_GENS;
> +			refs = LRU_REFS_PROTECTED;
> +		} else if (gen == min_gen && refs >= LRU_REFS_WORKINGSET) {
> +			/* Defer eviction of just accessed workingset */
> +			new_gen = (gen + 1UL) % MAX_NR_GENS;
> +			refs = min(refs, LRU_REFS_PROTECTED);
>  		}
> +out:
> +		refs = min(refs, LRU_REFS_MAX);
> +		lru_refs_set_flags(&new_flags, refs);
> +		if (new_gen >= 0)
> +			lru_gen_set_flags(&new_flags, new_gen);
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>  
> -		folio_set_lru_refs(folio, 1);
> -		return false;
> +	if (new_gen != gen) {
> +		/*
> +		 * Gen can only go forward, so concurrent aging is
> +		 * usually fine, except when multiple aging increase
> +		 * max_seq multiple times, new_gen may have go beyond
> +		 * the new max_seq's current gen border and causes
> +		 * hotness inversion. In that very unlikely case,
> +		 * just activate the folio.
> +		 */
> +		lru_gen_update_size(lruvec, folio, gen, new_gen);
> +		if (unlikely(READ_ONCE(lrugen->max_seq) - max_seq > MIN_NR_GENS))
> +			folio_activate(folio);
>  	}
>  
> -	/* Promote on second access */
> -	if (folio_lru_refs(folio) > 1) {
> -		folio_set_lru_refs(folio, 0);
> -		folio_set_workingset(folio);
> -	} else {
> -		folio_mark_accessed(folio);
> -	}
> -	return true;
> +	folio_lruvec_live_put(lruvec);
> +	return refs;
> +}
> +
> +/*
> + * Update the folio's lru refs indicator during a page table walk.
> + * max_seq is stable since this runs inside the aging process.
> + *
> + * Returns the old generation and stores the new generation in @new_gen when
> + * the folio is promoted (to max_gen) or advanced by one generation.
> + * Returns -1 if no gen change occurred.
> + */
> +static int folio_inc_lru_refs_walk(struct folio *folio, struct lruvec *lruvec,
> +				   const vma_flags_t *vma_flags, int *new_gen)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	unsigned long max_seq = READ_ONCE(lruvec->lrugen.max_seq);
> +	int refs, gen, max_gen, ret;
> +
> +	max_gen = lru_gen_from_seq(max_seq);
> +
> +	do {
> +		gen = lru_gen_from_flags(old_flags);
> +		refs = lru_refs_from_flags(old_flags) + 1;
> +		new_flags = old_flags;
> +
> +		if (gen >= 0 && gen != max_gen) {
> +			ret = gen;
> +			/* Promote second page table access or executable */
> +			if (refs > LRU_REFS_REFERENCED || is_exec_file_folio(folio, vma_flags))
> +				*new_gen = max_gen;
> +			else
> +				*new_gen = (gen + 1) % MAX_NR_GENS;
> +			lru_gen_set_flags(&new_flags, *new_gen);
> +			lru_refs_set_flags(&new_flags, min(refs, LRU_REFS_PROTECTED));
> +		} else {
> +			ret = -1;
> +			lru_refs_set_flags(&new_flags, min(refs, LRU_REFS_MAX));
> +		}
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +
> +	return ret;
> +}
> +
> +/*
> + * Update the folio's lru refs indicator while the folio is isolated.
> + * Only used on mapped folios upon the final eviction, when the folio is
> + * off the LRU list (isolated).
> + *
> + * Increments the refs count (capped at LRU_REFS_PROTECTED).  Returns true
> + * if the caller should activate the folio (second access or
> + * executable), false to keep it in the eviction list.
> + */
> +static bool folio_inc_lru_refs_isolated(struct folio *folio, const vma_flags_t *vma_flags)
> +{
> +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> +	int refs;
> +
> +	do {
> +		new_flags = old_flags;
> +		refs = lru_refs_from_flags(old_flags) + 1;
> +		lru_refs_set_flags(&new_flags, min(refs, LRU_REFS_PROTECTED));
> +	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> +
> +	/* Promote second page table access or executable */
> +	return refs > LRU_REFS_REFERENCED || is_exec_file_folio(folio, vma_flags);
>  }
>  #else
> -static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
> +static bool folio_inc_lru_refs_isolated(struct folio *folio, const vma_flags_t *vma_flags)
>  {
>  	return false;
>  }
> @@ -896,7 +1035,8 @@ static enum folio_references folio_check_references(struct folio *folio,
>  		if (!referenced_ptes)
>  			return FOLIOREF_RECLAIM;
>  
> -		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
> +		return folio_inc_lru_refs_isolated(folio, &vma_flags) ?
> +		       FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
>  	}
>  
>  	referenced_folio = folio_test_clear_referenced(folio);
> @@ -3262,59 +3402,31 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>   *                          the aging
>   ******************************************************************************/
>  
> -/* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
> -{
> -	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> -	int old_gen;
> -
> -	/*
> -	 * See the comment on LRU_REFS_FLAGS, and activate file-backed
> -	 * executable folios after first usage to avoid typical IO
> -	 * thrashing from reclaiming.
> -	 */
> -	if (!folio_test_referenced(folio) && !folio_test_workingset(folio) &&
> -	    !is_exec_file_folio(folio, vma_flags)) {
> -		folio_set_lru_refs(folio, 1);
> -		return -1;
> -	}
> -
> -	do {
> -		old_gen = lru_gen_from_flags(old_flags);
> -		new_flags = old_flags;
> -
> -		/* lru_gen_del_folio() has isolated this page? */
> -		if (old_gen < 0)
> -			break;
> -
> -		lru_gen_set_flags(&new_flags, new_gen);
> -		lru_refs_set_flags(&new_flags, 0);
> -		new_flags |= BIT(PG_workingset);
> -	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> -
> -	return old_gen;
> -}
> -
> -/* protect pages accessed multiple times through file descriptors */
> +/*
> + * Force bump a folio's generation. Used for PID protection or defer the
> + * eviction of temporarily unevictable folio.
> + */
>  static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>  {
> +	int refs;
>  	int type = folio_is_file_lru(folio);
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	int old_gen, new_gen, min_gen = lru_gen_from_seq(lrugen->min_seq[type]);
>  	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>  
>  	do {
> +		new_flags = old_flags;
> +		refs = lru_refs_from_flags(old_flags);
>  		old_gen = lru_gen_from_flags(old_flags);
>  		VM_WARN_ON_ONCE_FOLIO(old_gen < 0, folio);
>  
> -		/* folio_update_gen() has promoted this page? */
> +		/* folio has been promoted? */
>  		if (old_gen >= 0 && old_gen != min_gen)
>  			return old_gen;
>  
> -		new_flags = old_flags;
>  		new_gen = (old_gen + 1) % MAX_NR_GENS;
>  		lru_gen_set_flags(&new_flags, new_gen);
> -		lru_refs_set_flags(&new_flags, 0);
> +		lru_refs_set_flags(&new_flags, min(refs, LRU_REFS_WORKINGSET));
>  	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>  
>  	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
> @@ -3518,21 +3630,17 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struc
>  	if (!folio)
>  		return;
>  
> -	new_gen = lru_gen_from_seq(READ_ONCE(lruvec->lrugen.max_seq));
> -
>  	if (dirty && !folio_test_dirty(folio) &&
>  	    !(folio_test_anon(folio) && folio_test_swapbacked(folio) &&
>  	      !folio_test_swapcache(folio)))
>  		folio_mark_dirty(folio);
>  
>  	if (walk) {
> -		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
> -		if (old_gen >= 0 && old_gen != new_gen)
> +		old_gen = folio_inc_lru_refs_walk(folio, lruvec, &vma->flags, &new_gen);
> +		if (old_gen >= 0)
>  			update_batch_size(walk, folio, old_gen, new_gen);
> -	} else if (lru_gen_set_refs(folio, &vma->flags)) {
> -		old_gen = folio_lru_gen(folio);
> -		if (old_gen >= 0 && old_gen != new_gen)
> -			folio_activate(folio);
> +	} else {
> +		folio_inc_lru_refs(folio, true, is_exec_file_folio(folio, &vma->flags));
>  	}
>  }
>  
> @@ -3917,7 +4025,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  		while (!list_empty(head)) {
>  			struct folio *folio = lru_to_folio(head);
>  			int refs = folio_lru_refs(folio);
> -			bool workingset = folio_test_workingset(folio);
> +			int delta = folio_nr_pages(folio);
> +			int tier = lru_tier_from_refs(refs);
>  
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
> @@ -3927,14 +4036,8 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  			new_gen = folio_inc_gen(lruvec, folio);
>  			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
>  
> -			/* don't count the workingset being lazily promoted */
> -			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> -				int tier = lru_tier_from_refs(refs, workingset);
> -				int delta = folio_nr_pages(folio);
> -
> -				WRITE_ONCE(lrugen->protected[hist][type][tier],
> -					   lrugen->protected[hist][type][tier] + delta);
> -			}
> +			WRITE_ONCE(lrugen->protected[hist][type][tier],
> +				   lrugen->protected[hist][type][tier] + delta);
>  
>  			if (!--remaining)
>  				return false;
> @@ -4649,8 +4752,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>  	int zone = folio_zonenum(folio);
>  	int delta = folio_nr_pages(folio);
>  	int refs = folio_lru_refs(folio);
> -	bool workingset = folio_test_workingset(folio);
> -	int tier = lru_tier_from_refs(refs, workingset);
> +	int tier = lru_tier_from_refs(refs);
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  
>  	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
> @@ -4672,17 +4774,15 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>  	}
>  
>  	/* protected */
> -	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
> +	if (tier > tier_idx) {
> +		int hist = lru_hist_from_seq(lrugen->min_seq[type]);
> +
>  		gen = folio_inc_gen(lruvec, folio);
>  		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>  
> -		/* don't count the workingset being lazily promoted */
> -		if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
> -			int hist = lru_hist_from_seq(lrugen->min_seq[type]);
> +		WRITE_ONCE(lrugen->protected[hist][type][tier],
> +			   lrugen->protected[hist][type][tier] + delta);
>  
> -			WRITE_ONCE(lrugen->protected[hist][type][tier],
> -				   lrugen->protected[hist][type][tier] + delta);
> -		}
>  		return true;
>  	}
>  
> @@ -4710,10 +4810,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>  		return false;
>  	}
>  
> -	/* see the comment on LRU_REFS_FLAGS */
> -	if (!folio_test_referenced(folio))
> -		folio_set_lru_refs(folio, 0);
> -
>  	success = lru_gen_del_folio(lruvec, folio, true);
>  	VM_WARN_ON_ONCE_FOLIO(!success, folio);
>  
> @@ -4801,13 +4897,13 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>  	struct ctrl_pos sp, pv = {};
>  
>  	/*
> -	 * To leave a margin for fluctuations, use a larger gain factor (2:3).
> +	 * To leave a margin for fluctuations, use a larger gain factor (1:2).
>  	 * This value is chosen because any other tier would have at least twice
>  	 * as many refaults as the first tier.
>  	 */
> -	read_ctrl_pos(lruvec, type, 0, 1, 2, &sp);
>  	for (tier = 1; tier < MAX_NR_TIERS; tier++) {
> -		read_ctrl_pos(lruvec, type, tier, tier + 1, 3, &pv);
> +		read_ctrl_pos(lruvec, type, 0, tier, 1, &sp);
> +		read_ctrl_pos(lruvec, type, tier, tier + 1, 2, &pv);
>  		if (!positive_ctrl_err(&sp, &pv))
>  			break;
>  	}
> @@ -4930,10 +5026,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  		}
>  
>  		/* don't add rejected folios to the oldest generation */
> -		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
> -			folio_set_lru_refs(folio, 0);
> +		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
>  			folio_set_active(folio);
> -		}
>  	}
>  
>  	move_folios_to_lru(&list);
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 5438e9390011..452fe8554990 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -189,6 +189,13 @@
>  #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
>  #define EVICTION_MASK_ANON	(~0UL >> EVICTION_SHIFT_ANON)
>  
> +/*
> + * LRU refs uses LRU_REFS_WIDTH + 2 bits, the 2 bits are PG_workingset and
> + * PG_referenced. But here we record PG_workingset separately (to reuse
> + * pack_shadow).
> + */
> +#define LRU_REFS_BITS ((LRU_REFS_WIDTH + 2) - 1)
> +
>  /*
>   * Eviction timestamps need to be able to cover the full range of
>   * actionable refaults. However, bits are tight in the xarray
> @@ -242,13 +249,12 @@ static void *lru_gen_eviction(struct folio *folio)
>  	int type = folio_is_file_lru(folio);
>  	int delta = folio_nr_pages(folio);
>  	int refs = folio_lru_refs(folio);
> -	bool workingset = folio_test_workingset(folio);
> -	int tier = lru_tier_from_refs(refs, workingset);
> +	int tier = lru_tier_from_refs(refs);
>  	struct mem_cgroup *memcg;
>  	struct pglist_data *pgdat = folio_pgdat(folio);
>  	unsigned short memcg_id;
>  
> -	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
> +	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_BITS >
>  		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
>  
>  	rcu_read_lock();
> @@ -256,14 +262,14 @@ static void *lru_gen_eviction(struct folio *folio)
>  	lruvec = mem_cgroup_lruvec(memcg, pgdat);
>  	lrugen = &lruvec->lrugen;
>  	min_seq = READ_ONCE(lrugen->min_seq[type]);
> -	token = (min_seq << LRU_REFS_WIDTH) | max(refs - 1, 0);
> +	token = (min_seq << LRU_REFS_BITS) | refs >> 1;
>  
>  	hist = lru_hist_from_seq(min_seq);
>  	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
>  	memcg_id = mem_cgroup_private_id(memcg);
>  	rcu_read_unlock();
>  
> -	return pack_shadow(memcg_id, pgdat, token, workingset, type);
> +	return pack_shadow(memcg_id, pgdat, token, refs & 1, type);
>  }
>  
>  /*
> @@ -284,11 +290,24 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
>  	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
>  
>  	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
> -	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
> +	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_BITS;
>  
> -	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
> +	return abs_diff(max_seq, *token >> LRU_REFS_BITS) < MAX_NR_GENS;
>  }
>  
> +/*
> + * Restore the refs of a refaulted folio from its shadow entry.
> + *
> + * Any folio that was accessed at least once before eviction (refs >=
> + * LRU_REFS_REFERENCED) is activated on a fault-driven refault, giving it a
> + * strong gen placement. Non-fault refaults (e.g. readahead) are not
> + * activated regardless of refs.
> + *
> + * The restored refs is capped at LRU_REFS_PROTECTED to prevent stale
> + * high-tier history from carrying over across eviction cycles. The
> + * WORKINGSET_RESTORE stat is bumped only for refs >= LRU_REFS_WORKINGSET
> + * to track genuine workingset restoration.
> + */
>  static void lru_gen_refault(struct folio *folio, void *shadow)
>  {
>  	bool recent;
> @@ -314,21 +333,29 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
>  	lrugen = &lruvec->lrugen;
>  
>  	hist = lru_hist_from_seq(READ_ONCE(lrugen->min_seq[type]));
> -	refs = (token & (BIT(LRU_REFS_WIDTH) - 1)) + 1;
> -	tier = lru_tier_from_refs(refs, workingset);
> +	refs = ((token & (BIT(LRU_REFS_BITS) - 1)) << 1) + workingset;
> +	tier = lru_tier_from_refs(refs);
>  
>  	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
>  
> -	if (workingset) {
> -		/* Send refaulted workingset folios to active generations. */
> +	/*
> +	 * Activate a fault-driven refault: the folio was accessed at
> +	 * least once before eviction and would have been promoted had
> +	 * it stayed in memory.
> +	 */
> +	if (refs >= LRU_REFS_REFERENCED) {
>  		if (lru_gen_in_fault()) {
>  			folio_set_active(folio);
>  			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
>  		}
> -		folio_set_workingset(folio);
> +		/* Cap restored refs to prevent stale high-tier carry-over */
> +		folio_set_lru_refs(folio, min(refs, LRU_REFS_PROTECTED));
> +	}
> +
> +	/* WORKINGSET_RESTORE tracks genuine workingset-level refaults */
> +	if (refs >= LRU_REFS_WORKINGSET)
>  		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
> -	} else
> -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, (refs - 1UL) << LRU_REFS_PGOFF);
> +
>  unlock:
>  	rcu_read_unlock();
>  }
> 
> -- 
> 2.55.0
> 
> 
