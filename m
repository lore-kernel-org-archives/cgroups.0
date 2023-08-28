From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] mm: vmscan: try to reclaim swapcache pages if no
 swap space
Date: Mon, 28 Aug 2023 09:51:07 +0800
Message-ID: <87il9053zo.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20230826034401.640861-1-liushixin2@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693187600; x=1724723600;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=9PUQL+UG8cSDSXi335re1KStoEMye9svOM9enea2wTY=;
  b=b3gD65tUNMGbRRzAyE9hNmqsbBJskQw0vcgeiRRm/fTL6Ne5grXm5WqC
   gmsKOxbgerKABJWgYmi8+N1XeWKWvuUK7WC9kODiQfBrxgzfhIiZJBhPg
   4YgsgNVyXxI95Fr+zWVsnPFEbfd+DbNwwKjC2bVLuXeSRyC68GFUh651q
   UsPB/8CU33K51yplUefHMfJXHAcxXQ+LA5cysWEFVMmiS2EyIZ6FJm2iU
   eafHzHVblpbZ06MSeG1TowGJ30JPR/BUDkKQGCidmi/VINBtTt8dO+Vcz
   hdsL8Y0n9y6RWvaUTEXd5E8u2TgdsONdGKJEoyVzr+0AA/+7H6oNeWoVF
   A==;
In-Reply-To: <20230826034401.640861-1-liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> (Liu Shixin's
        message of "Sat, 26 Aug 2023 11:44:01 +0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> writes:

> When spaces of swap devices are exhausted, only file pages can be reclaimed.
> But there are still some swapcache pages in anon lru list. This can lead
> to a premature out-of-memory.
>
> This problem can be fixed by checking number of swapcache pages in
> can_reclaim_anon_pages().
>
> Add a new bit swapcache_only in struct scan_control to skip isolating anon
> pages that are not in the swap cache when only swap cache can be reclaimed.

Better to describe how you test the patch and test results.

> Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/swap.h |  6 ++++++
>  mm/memcontrol.c      |  8 ++++++++
>  mm/vmscan.c          | 29 +++++++++++++++++++++++++++--
>  3 files changed, 41 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 456546443f1f..0318e918bfa4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -669,6 +669,7 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_p
>  }
>  
>  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
> +extern long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg);
>  extern bool mem_cgroup_swap_full(struct folio *folio);
>  #else
>  static inline void mem_cgroup_swapout(struct folio *folio, swp_entry_t entry)
> @@ -691,6 +692,11 @@ static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>  	return get_nr_swap_pages();
>  }
>  
> +static inline long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
> +{
> +	return total_swapcache_pages();
> +}
> +
>  static inline bool mem_cgroup_swap_full(struct folio *folio)
>  {
>  	return vm_swap_full();
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8ca4bdcb03c..c465829db92b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7567,6 +7567,14 @@ long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>  	return nr_swap_pages;
>  }
>  
> +long mem_cgroup_get_nr_swapcache_pages(struct mem_cgroup *memcg)
> +{
> +	if (mem_cgroup_disabled())
> +		return total_swapcache_pages();
> +
> +	return memcg_page_state(memcg, NR_SWAPCACHE);
> +}
> +
>  bool mem_cgroup_swap_full(struct folio *folio)
>  {
>  	struct mem_cgroup *memcg;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7c33c5b653ef..5cb4adf6642b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -137,6 +137,9 @@ struct scan_control {
>  	/* Always discard instead of demoting to lower tier memory */
>  	unsigned int no_demotion:1;
>  
> +	/* Swap space is exhausted, only reclaim swapcache for anon LRU */
> +	unsigned int swapcache_only:1;
> +
>  	/* Allocation order */
>  	s8 order;
>  
> @@ -613,10 +616,20 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
>  		 */
>  		if (get_nr_swap_pages() > 0)
>  			return true;
> +		/* Is there any swapcache pages to reclaim? */
> +		if (total_swapcache_pages() > 0) {
> +			sc->swapcache_only = 1;
> +			return true;
> +		}
>  	} else {
>  		/* Is the memcg below its swap limit? */
>  		if (mem_cgroup_get_nr_swap_pages(memcg) > 0)
>  			return true;
> +		/* Is there any swapcache pages in memcg to reclaim? */
> +		if (mem_cgroup_get_nr_swapcache_pages(memcg) > 0) {
> +			sc->swapcache_only = 1;
> +			return true;
> +		}
>  	}
>  
>  	/*
> @@ -2280,6 +2293,19 @@ static bool skip_cma(struct folio *folio, struct scan_control *sc)
>  }
>  #endif
>  
> +static bool skip_isolate(struct folio *folio, struct scan_control *sc,
> +			 enum lru_list lru)
> +{
> +	if (folio_zonenum(folio) > sc->reclaim_idx)
> +		return true;
> +	if (skip_cma(folio, sc))
> +		return true;
> +	if (unlikely(sc->swapcache_only && !is_file_lru(lru) &&
> +	    !folio_test_swapcache(folio)))

Just

	if (unlikely(sc->swapcache_only && !folio_test_swapcache(folio)))

is enough.

> +		return true;
> +	return false;
> +}
> +
>  /*
>   * Isolating page from the lruvec to fill in @dst list by nr_to_scan times.
>   *
> @@ -2326,8 +2352,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>  		nr_pages = folio_nr_pages(folio);
>  		total_scan += nr_pages;
>  
> -		if (folio_zonenum(folio) > sc->reclaim_idx ||
> -				skip_cma(folio, sc)) {
> +		if (skip_isolate(folio, sc, lru)) {
>  			nr_skipped[folio_zonenum(folio)] += nr_pages;
>  			move_to = &folios_skipped;
>  			goto move;
