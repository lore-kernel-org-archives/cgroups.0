Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EC02D7DE9;
	Thu, 20 Aug 2026 01:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787190731; cv=none; b=DNtmCb8Gfp7lTnCYQ1u41FYUf6deGyagjAaaoYLbs+ysx6mhRc3tshum5l4DmuPX2zU6T8sAx7+tUy/t3qZwmCp0jHBfFR++V5Mq51s+I5jdQFeXLeKgUL2LA5hwSBZwu96dMijojoXOd9YInjmMH38L4uOKsTwAtbYKWItrI6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787190731; c=relaxed/simple;
	bh=EbByKZ5zZBjh8j5dQ4x1ELWBwrijWmKB/4Mc6CVgWFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9bLDDLp0fF9QZZDXODjsixYXuCseQTL17TaTbqd4bNvZUAzzi/rTYldpjiLsTylXDlBy8G4fiOKn1C1ZElWWaEpgWcDdXm3Rk8OizIOhXSHXS62mLB4KPfgG9LlASbsRCUyjP6GlZHEDT63R6uEHQh76PqCM8rbaD3bB5TAvmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fBaXobMy; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fBaXobMy"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787190725; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=qVu8SbPzt7/dSva3YZ9XkqmI4phhhFSkD/CIXqb94tE=;
	b=fBaXobMyQZBsw1AgFG+ognLHYNxSMEZMrZwi9Hx/hMemBxMDoqMWXc6bKXsl3aNDSyhsyJy+tbzaW2Shtce07WsCZm8RsYkx89cFiSYP9PTZ26TrD3+nBCwbUj/NiBUUy+I9JB/wvvbmHkBjIjW3FYWQawBw+/M/0B0eW/mv+nk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X9HoXSS_1787190723;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9HoXSS_1787190723 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Aug 2026 09:52:03 +0800
Message-ID: <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com>
Date: Thu, 20 Aug 2026 09:52:02 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
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
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Each generation of MGLRU accounts anon and file folio numbers
> separately. The page table walker's update_batch_size() derives the
> anon / file type of a folio from its current flags, but the page table
> walk holds neither the lruvec lock nor the folio lock, so the type can
> change during that period.

Right.

> MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
> so the folio is no longer considered on the anon LRU list. Lazyfreed
> folios can also be changed back to the anon list again. If the flip
> lands between folio_update_gen()'s cmpxchg and the type read in
> update_batch_size(), the batched delta pair is applied to the wrong
> type. The anon and file generation counters then carry phantom deltas
> that nothing reconciles, permanently skewing lrugen->nr_pages and the
> reclaim budgets derived from it.

But I think the problem occurs between update_batch_size() and 
sort_folio(). update_batch_size() only updates the anon or file folio 
statistics, while sort_folio() moves promoted folios to the 
corresponding type's list:

/* promoted */
if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
	list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
	return true;
}

If the folio's anon/file type changes between these two steps (e.g., a 
lazyfree folio), it would lead to what you described: "The anon and file 
generation counters then carry phantom deltas that nothing reconciles, 
permanently skewing lrugen->nr_pages and the reclaim budgets derived 
from it."

If you agree that this is where the problem lies, I don't see a good way 
to fix it, since the state of a lazyfree folio can change between 
update_batch_size() and sort_folio().

A simple approach would be to skip checking the access flag for lazyfree 
folios during the page table walk, and let shrink_folio_list() 
reactivate accessed lazyfree folios instead. What do you think?

> Fix it by capturing the type from the flags snapshot the cmpxchg
> linearized against: folio_update_gen() returns the type of the state
> it transitioned from, and update_batch_size() accounts with it instead
> of re-reading the live flags. The batched deltas then always match the
> type of the state the cmpxchg transitioned from.
> 
> Fixes: 018ee47f1489 ("mm: multi-gen LRU: exploit locality in rmap")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h |  7 ++++++-
>   mm/vmscan.c               | 13 +++++++------
>   2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index df62daaa2ee7..4bb390d9516e 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -10,6 +10,11 @@
>   #include <linux/userfaultfd_k.h>
>   #include <linux/leafops.h>
>   
> +static inline int folio_flags_is_file_lru(const unsigned long *flags)
> +{
> +	return !test_bit(PG_swapbacked, flags);
> +}
> +
>   /**
>    * folio_is_file_lru - Should the folio be on a file LRU or anon LRU?
>    * @folio: The folio to test.
> @@ -27,7 +32,7 @@
>    */
>   static inline int folio_is_file_lru(const struct folio *folio)
>   {
> -	return !folio_test_swapbacked(folio);
> +	return folio_flags_is_file_lru(const_folio_flags(folio, 0));
>   }
>   
>   static __always_inline void __update_lru_size(struct lruvec *lruvec,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a613bb8d7271..7169cac60869 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3269,7 +3269,8 @@ static bool positive_ctrl_err(struct ctrl_pos *sp, struct ctrl_pos *pv)
>    ******************************************************************************/
>   
>   /* promote pages accessed through page tables */
> -static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t *vma_flags)
> +static int folio_update_gen(struct folio *folio, int new_gen, int *is_file,
> +			    const vma_flags_t *vma_flags)
>   {
>   	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
>   	int old_gen;
> @@ -3298,6 +3299,7 @@ static int folio_update_gen(struct folio *folio, int new_gen, const vma_flags_t
>   		new_flags |= BIT(PG_workingset);
>   	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>   
> +	*is_file = folio_flags_is_file_lru(&old_flags);
>   	return old_gen;
>   }
>   
> @@ -3328,9 +3330,8 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
>   }
>   
>   static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
> -			      int old_gen, int new_gen)
> +			      int old_gen, int new_gen, int type)
>   {
> -	int type = folio_is_file_lru(folio);
>   	int zone = folio_zonenum(folio);
>   	int delta = folio_nr_pages(folio);
>   
> @@ -3519,7 +3520,7 @@ static bool suitable_to_scan(int total, int young)
>   static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struct *vma,
>   			      struct lruvec *lruvec, struct folio *folio, bool dirty)
>   {
> -	int new_gen, old_gen;
> +	int new_gen, old_gen, file;
>   
>   	if (!folio)
>   		return;
> @@ -3532,9 +3533,9 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct vm_area_struc
>   		folio_mark_dirty(folio);
>   
>   	if (walk) {
> -		old_gen = folio_update_gen(folio, new_gen, &vma->flags);
> +		old_gen = folio_update_gen(folio, new_gen, &file, &vma->flags);
>   		if (old_gen >= 0 && old_gen != new_gen)
> -			update_batch_size(walk, folio, old_gen, new_gen);
> +			update_batch_size(walk, folio, old_gen, new_gen, file);
>   	} else if (lru_gen_set_refs(folio, &vma->flags)) {
>   		old_gen = folio_lru_gen(folio);
>   		if (old_gen >= 0 && old_gen != new_gen)
> 

