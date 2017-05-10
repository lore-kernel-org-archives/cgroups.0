From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH -mm -v10 1/3] mm, THP, swap: Delay splitting THP during
 swap out
Date: Wed, 10 May 2017 09:56:54 -0400
Message-ID: <20170510135654.GD17121@cmpxchg.org>
References: <20170425125658.28684-1-ying.huang@intel.com>
 <20170425125658.28684-2-ying.huang@intel.com>
 <20170427053141.GA1925@bbox>
 <87mvb21fz1.fsf@yhuang-dev.intel.com>
 <20170428084044.GB19510@bbox>
 <20170501104430.GA16306@cmpxchg.org>
 <20170501235332.GA4411@bbox>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mkrwtKsGyebRuN8t6Pnc+5UtmiP1rbOlM+2O5P8jOIw=; b=l2vs20uqBFROrgnR9YcAtpYFrn
	mwIOPipj7z0G2V2RALMYzsivJhTwapdEI/hizftzjYxHwpmElQumVZgCgCNuASvLoB7Ek2U3o3uxh
	VqbQbYhLu9OIRqDwMS41dtrbBVqytmvjtiQyc1z412CxGgV/wHwdUubbWOsoHCKR0WWo=;
Content-Disposition: inline
In-Reply-To: <20170501235332.GA4411@bbox>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Minchan Kim <minchan@kernel.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ebru Akagunduz <ebru.akagunduz@gmail.com>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>, cgroups@vger.kernel.org

Hi Michan,

On Tue, May 02, 2017 at 08:53:32AM +0900, Minchan Kim wrote:
> @@ -1144,7 +1144,7 @@ void swap_free(swp_entry_t entry)
>  /*
>   * Called after dropping swapcache to decrease refcnt to swap entries.
>   */
> -void swapcache_free(swp_entry_t entry)
> +void __swapcache_free(swp_entry_t entry)
>  {
>  	struct swap_info_struct *p;
>  
> @@ -1156,7 +1156,7 @@ void swapcache_free(swp_entry_t entry)
>  }
>  
>  #ifdef CONFIG_THP_SWAP
> -void swapcache_free_cluster(swp_entry_t entry)
> +void __swapcache_free_cluster(swp_entry_t entry)
>  {
>  	unsigned long offset = swp_offset(entry);
>  	unsigned long idx = offset / SWAPFILE_CLUSTER;
> @@ -1182,6 +1182,14 @@ void swapcache_free_cluster(swp_entry_t entry)
>  }
>  #endif /* CONFIG_THP_SWAP */
>  
> +void swapcache_free(struct page *page, swp_entry_t entry)
> +{
> +	if (!PageTransHuge(page))
> +		__swapcache_free(entry);
> +	else
> +		__swapcache_free_cluster(entry);
> +}

I don't think this is cleaner :/

On your second patch:

> @@ -1125,8 +1125,28 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  		    !PageSwapCache(page)) {
>  			if (!(sc->gfp_mask & __GFP_IO))
>  				goto keep_locked;
> -			if (!add_to_swap(page, page_list))
> +swap_retry:
> +			/*
> +			 * Retry after split if we fail to allocate
> +			 * swap space of a THP.
> +			 */
> +			if (!add_to_swap(page)) {
> +				if (!PageTransHuge(page) ||
> +				    split_huge_page_to_list(page, page_list))
> +					goto activate_locked;
> +				goto swap_retry;
> +			}

This is definitely better.

However, I think it'd be cleaner without the label here:

			if (!add_to_swap(page)) {
				if (!PageTransHuge(page))
					goto activate_locked;
				/* Split THP and swap individual base pages */
				if (split_huge_page_to_list(page, page_list))
					goto activate_locked;
				if (!add_to_swap(page))
					goto activate_locked;
			}

> +			/*
> +			 * Got swap space successfully. But unfortunately,
> +			 * we don't support a THP page writeout so split it.
> +			 */
> +			if (PageTransHuge(page) &&
> +				  split_huge_page_to_list(page, page_list)) {
> +				delete_from_swap_cache(page);
>  				goto activate_locked;
> +			}

Pulling this out of add_to_swap() is an improvement for sure. Add an
XXX: before that "we don't support THP writes" comment for good
measure :)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
