From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/5] mm: Split release_pages work into 3 passes
Date: Wed, 19 Aug 2020 15:53:15 +0800
Message-ID: <15edf807-ce03-83f7-407d-5929341b2b4e@linux.alibaba.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042730.23414.41309.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200819042730.23414.41309.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org



在 2020/8/19 下午12:27, Alexander Duyck 写道:
> From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> The release_pages function has a number of paths that end up with the
> LRU lock having to be released and reacquired. Such an example would be the
> freeing of THP pages as it requires releasing the LRU lock so that it can
> be potentially reacquired by __put_compound_page.
> 
> In order to avoid that we can split the work into 3 passes, the first
> without the LRU lock to go through and sort out those pages that are not in
> the LRU so they can be freed immediately from those that can't. The second
> pass will then go through removing those pages from the LRU in batches as
> large as a pagevec can hold before freeing the LRU lock. Once the pages have
> been removed from the LRU we can then proceed to free the remaining pages
> without needing to worry about if they are in the LRU any further.
> 
> The general idea is to avoid bouncing the LRU lock between pages and to
> hopefully aggregate the lock for up to the full page vector worth of pages.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  mm/swap.c |  109 +++++++++++++++++++++++++++++++++++++------------------------
>  1 file changed, 67 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index fe53449fa1b8..b405f81b2c60 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -795,6 +795,54 @@ void lru_add_drain_all(void)
>  }
>  #endif
>  
> +static void __release_page(struct page *page, struct list_head *pages_to_free)
> +{
> +	if (PageCompound(page)) {
> +		__put_compound_page(page);
> +	} else {
> +		/* Clear Active bit in case of parallel mark_page_accessed */
> +		__ClearPageActive(page);
> +		__ClearPageWaiters(page);
> +
> +		list_add(&page->lru, pages_to_free);
> +	}
> +}
> +
> +static void __release_lru_pages(struct pagevec *pvec,
> +				struct list_head *pages_to_free)
> +{
> +	struct lruvec *lruvec = NULL;
> +	unsigned long flags = 0;
> +	int i;
> +
> +	/*
> +	 * The pagevec at this point should contain a set of pages with
> +	 * their reference count at 0 and the LRU flag set. We will now
> +	 * need to pull the pages from their LRU lists.
> +	 *
> +	 * We walk the list backwards here since that way we are starting at
> +	 * the pages that should be warmest in the cache.
> +	 */
> +	for (i = pagevec_count(pvec); i--;) {
> +		struct page *page = pvec->pages[i];
> +
> +		lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);

the lock bounce is better with the patch, would you like to do further
like using add_lruvecs to reduce bounce more?

Thanks
Alex

> +		VM_BUG_ON_PAGE(!PageLRU(page), page);
> +		__ClearPageLRU(page);
> +		del_page_from_lru_list(page, lruvec, page_off_lru(page));
> +	}
> +
> +	unlock_page_lruvec_irqrestore(lruvec, flags);
> +
> +	/*
> +	 * A batch of pages are no longer on the LRU list. Go through and
> +	 * start the final process of returning the deferred pages to their
> +	 * appropriate freelists.
> +	 */
> +	for (i = pagevec_count(pvec); i--;)
> +		__release_page(pvec->pages[i], pages_to_free);
> +}
> +
>  /**
>   * release_pages - batched put_page()
>   * @pages: array of pages to release
> @@ -806,32 +854,24 @@ void lru_add_drain_all(void)
>  void release_pages(struct page **pages, int nr)
>  {
>  	int i;
> +	struct pagevec pvec;
>  	LIST_HEAD(pages_to_free);
> -	struct lruvec *lruvec = NULL;
> -	unsigned long flags;
> -	unsigned int lock_batch;
>  
> +	pagevec_init(&pvec);
> +
> +	/*
> +	 * We need to first walk through the list cleaning up the low hanging
> +	 * fruit and clearing those pages that either cannot be freed or that
> +	 * are non-LRU. We will store the LRU pages in a pagevec so that we
> +	 * can get to them in the next pass.
> +	 */
>  	for (i = 0; i < nr; i++) {
>  		struct page *page = pages[i];
>  
> -		/*
> -		 * Make sure the IRQ-safe lock-holding time does not get
> -		 * excessive with a continuous string of pages from the
> -		 * same lruvec. The lock is held only if lruvec != NULL.
> -		 */
> -		if (lruvec && ++lock_batch == SWAP_CLUSTER_MAX) {
> -			unlock_page_lruvec_irqrestore(lruvec, flags);
> -			lruvec = NULL;
> -		}
> -
>  		if (is_huge_zero_page(page))
>  			continue;
>  
>  		if (is_zone_device_page(page)) {
> -			if (lruvec) {
> -				unlock_page_lruvec_irqrestore(lruvec, flags);
> -				lruvec = NULL;
> -			}
>  			/*
>  			 * ZONE_DEVICE pages that return 'false' from
>  			 * put_devmap_managed_page() do not require special
> @@ -848,36 +888,21 @@ void release_pages(struct page **pages, int nr)
>  		if (!put_page_testzero(page))
>  			continue;
>  
> -		if (PageCompound(page)) {
> -			if (lruvec) {
> -				unlock_page_lruvec_irqrestore(lruvec, flags);
> -				lruvec = NULL;
> -			}
> -			__put_compound_page(page);
> +		if (!PageLRU(page)) {
> +			__release_page(page, &pages_to_free);
>  			continue;
>  		}
>  
> -		if (PageLRU(page)) {
> -			struct lruvec *prev_lruvec = lruvec;
> -
> -			lruvec = relock_page_lruvec_irqsave(page, lruvec,
> -									&flags);
> -			if (prev_lruvec != lruvec)
> -				lock_batch = 0;
> -
> -			VM_BUG_ON_PAGE(!PageLRU(page), page);
> -			__ClearPageLRU(page);
> -			del_page_from_lru_list(page, lruvec, page_off_lru(page));
> +		/* record page so we can get it in the next pass */
> +		if (!pagevec_add(&pvec, page)) {
> +			__release_lru_pages(&pvec, &pages_to_free);
> +			pagevec_reinit(&pvec);
>  		}
> -
> -		/* Clear Active bit in case of parallel mark_page_accessed */
> -		__ClearPageActive(page);
> -		__ClearPageWaiters(page);
> -
> -		list_add(&page->lru, &pages_to_free);
>  	}
> -	if (lruvec)
> -		unlock_page_lruvec_irqrestore(lruvec, flags);
> +
> +	/* flush any remaining LRU pages that need to be processed */
> +	if (pagevec_count(&pvec))
> +		__release_lru_pages(&pvec, &pages_to_free);
>  
>  	mem_cgroup_uncharge_list(&pages_to_free);
>  	free_unref_page_list(&pages_to_free);
> 
