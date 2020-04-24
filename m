From: Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 16/18] mm: memcontrol: charge swapin pages on
 instantiation
Date: Fri, 24 Apr 2020 09:44:42 +0900
Message-ID: <20200424004441.GF13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-17-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/IkJb/MMZUEA8Z1/RSpT7PeJDUHsZdmZCfXGjsvU/uc=;
        b=Fmu89ZUP5jfOOeCAiKzazV69FxgZwVwGUi4cL767wILw6nY8cuQ+xv/ACV5WBrfgqK
         no7paEzqbJa+YJbhXps7u/WW19Gfms7v5/j/Hu/aga2I6MU+SxEKAZ3E5LptUDcjTC8+
         K23v3P8rsFBqmySgjQUV7NoC9XYXbUQMW0fhCMQHvcFBcujc+4lB1tjY0GslSsnWG25E
         4Wk/k1/14NlV73UEi7hmVFzgYi7kmnMRNpMhCMNUxQtWRp2yGiW5PRO7Qcj/mAzd7fcz
         /XBrXRoKV58Is5VnCQuY0+XY503P3n35Shjp1MknNT4sgOrMF68nKkaUDgpq6A7IRWkT
         107g==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-17-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, Shakeel Butt <shakeelb@google.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Apr 20, 2020 at 06:11:24PM -0400, Johannes Weiner wrote:
> Right now, users that are otherwise memory controlled can easily
> escape their containment and allocate significant amounts of memory
> that they're not being charged for. That's because swap readahead
> pages are not being charged until somebody actually faults them into
> their page table. This can be exploited with MADV_WILLNEED, which
> triggers arbitrary readahead allocations without charging the pages.
> 
> There are additional problems with the delayed charging of swap pages:
> 
> 1. To implement refault/workingset detection for anonymous pages, we
>    need to have a target LRU available at swapin time, but the LRU is
>    not determinable until the page has been charged.
> 
> 2. To implement per-cgroup LRU locking, we need page->mem_cgroup to be
>    stable when the page is isolated from the LRU; otherwise, the locks
>    change under us. But swapcache gets charged after it's already on
>    the LRU, and even if we cannot isolate it ourselves (since charging
>    is not exactly optional).
> 
> The previous patch ensured we always maintain cgroup ownership records
> for swap pages. This patch moves the swapcache charging point from the
> fault handler to swapin time to fix all of the above problems.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memory.c     | 15 ++++++---
>  mm/shmem.c      | 14 ++++----
>  mm/swap_state.c | 89 ++++++++++++++++++++++++++-----------------------
>  mm/swapfile.c   |  6 ----
>  4 files changed, 67 insertions(+), 57 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 3fa379d9b17d..5d266532fc40 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3127,9 +3127,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
>  							vmf->address);
>  			if (page) {
> +				int err;
> +
>  				__SetPageLocked(page);
>  				__SetPageSwapBacked(page);
>  				set_page_private(page, entry.val);
> +
> +				/* Tell memcg to use swap ownership records */
> +				SetPageSwapCache(page);
> +				err = mem_cgroup_charge(page, vma->vm_mm,
> +							GFP_KERNEL, false);
> +				ClearPageSwapCache(page);
> +				if (err)
> +					goto out_page;
> +
>  				lru_cache_add_anon(page);
>  				swap_readpage(page, true);
>  			}
> @@ -3191,10 +3202,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  		goto out_page;
>  	}
>  
> -	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL, true)) {
> -		ret = VM_FAULT_OOM;
> -		goto out_page;
> -	}
>  	cgroup_throttle_swaprate(page, GFP_KERNEL);
>  
>  	/*
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 363bd11eba85..966f150a4823 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -623,13 +623,15 @@ static int shmem_add_to_page_cache(struct page *page,
>  	page->mapping = mapping;
>  	page->index = index;
>  
> -	error = mem_cgroup_charge(page, charge_mm, gfp, PageSwapCache(page));
> -	if (error) {
> -		if (!PageSwapCache(page) && PageTransHuge(page)) {
> -			count_vm_event(THP_FILE_FALLBACK);
> -			count_vm_event(THP_FILE_FALLBACK_CHARGE);
> +	if (!PageSwapCache(page)) {
> +		error = mem_cgroup_charge(page, charge_mm, gfp, false);
> +		if (error) {
> +			if (PageTransHuge(page)) {
> +				count_vm_event(THP_FILE_FALLBACK);
> +				count_vm_event(THP_FILE_FALLBACK_CHARGE);
> +			}
> +			goto error;
>  		}
> -		goto error;
>  	}
>  	cgroup_throttle_swaprate(page, gfp);
>  
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ebed37bbf7a3..f3b9073bfff3 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -360,12 +360,13 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  			struct vm_area_struct *vma, unsigned long addr,
>  			bool *new_page_allocated)
>  {
> -	struct page *found_page = NULL, *new_page = NULL;
>  	struct swap_info_struct *si;
> -	int err;
> +	struct page *page;
> +
>  	*new_page_allocated = false;
>  
> -	do {
> +	for (;;) {
> +		int err;
>  		/*
>  		 * First check the swap cache.  Since this is normally
>  		 * called after lookup_swap_cache() failed, re-calling
> @@ -373,12 +374,12 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		 */
>  		si = get_swap_device(entry);
>  		if (!si)
> -			break;
> -		found_page = find_get_page(swap_address_space(entry),
> -					   swp_offset(entry));
> +			return NULL;
> +		page = find_get_page(swap_address_space(entry),
> +				     swp_offset(entry));
>  		put_swap_device(si);
> -		if (found_page)
> -			break;
> +		if (page)
> +			return page;
>  
>  		/*
>  		 * Just skip read ahead for unused swap slot.
> @@ -389,21 +390,15 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		 * else swap_off will be aborted if we return NULL.
>  		 */
>  		if (!__swp_swapcount(entry) && swap_slot_cache_enabled)
> -			break;
> -
> -		/*
> -		 * Get a new page to read into from swap.
> -		 */
> -		if (!new_page) {
> -			new_page = alloc_page_vma(gfp_mask, vma, addr);
> -			if (!new_page)
> -				break;		/* Out of memory */
> -		}
> +			return NULL;
>  
>  		/*
>  		 * Swap entry may have been freed since our caller observed it.
>  		 */
>  		err = swapcache_prepare(entry);
> +		if (!err)
> +			break;
> +
>  		if (err == -EEXIST) {
>  			/*
>  			 * We might race against get_swap_page() and stumble
> @@ -412,31 +407,43 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  			 */
>  			cond_resched();
>  			continue;
> -		} else if (err)		/* swp entry is obsolete ? */
> -			break;
> -
> -		/* May fail (-ENOMEM) if XArray node allocation failed. */
> -		__SetPageLocked(new_page);
> -		__SetPageSwapBacked(new_page);
> -		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
> -		if (likely(!err)) {
> -			/* Initiate read into locked page */
> -			SetPageWorkingset(new_page);
> -			lru_cache_add_anon(new_page);
> -			*new_page_allocated = true;
> -			return new_page;
>  		}
> -		__ClearPageLocked(new_page);
> -		/*
> -		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
> -		 * clear SWAP_HAS_CACHE flag.
> -		 */
> -		put_swap_page(new_page, entry);
> -	} while (err != -ENOMEM);
> +		if (err)		/* swp entry is obsolete ? */
> +			return NULL;

"if (err)" is not needed since "!err" is already exiting the loop.

> +	}
> +
> +	/*
> +	 * The swap entry is ours to swap in. Prepare a new page.
> +	 */
> +
> +	page = alloc_page_vma(gfp_mask, vma, addr);
> +	if (!page)
> +		goto fail_free;
> +
> +	__SetPageLocked(page);
> +	__SetPageSwapBacked(page);
> +
> +	/* May fail (-ENOMEM) if XArray node allocation failed. */
> +	if (add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL))
> +		goto fail_unlock;
> +
> +	if (mem_cgroup_charge(page, NULL, gfp_mask & GFP_KERNEL, false))
> +		goto fail_delete;
> +

I think that following order of operations is better than yours.

1. page alloc
2. memcg charge
3. swapcache_prepare
4. add_to_swap_cache

Reason is that page allocation and memcg charging could take for a
long time due to reclaim and other tasks waiting this swapcache page
could be blocked inbetween swapcache_prepare() and add_to_swap_cache().

Thanks.
