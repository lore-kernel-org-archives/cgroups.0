From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v5] mm: vmscan: try to reclaim swapcache pages if no swap
 space
Date: Mon, 4 Sep 2023 16:23:35 +0200
Message-ID: <ZPXoZ2dmqXLkf6UV@dhcp22.suse.cz>
References: <20230830035600.1656792-1-liushixin2@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693837416; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QWDCEvzHucuSQUBB7EY+oxf1co3O21NGQJ9fGF2Y0bg=;
        b=oQUkVC0NJ6QPqJQpJDPa7OPix6qR8zStud1/ci3OLV48lTmUQ2WMJ7pgtQY1YRD+U++3wB
        Tk1zo9Tt2H1u+IMRbQZBCeUC6DwVvUvm+W0lr4Pc0ofmQbQxdUjb8OTliiLutbx7qGdyvE
        NzXNQg5K9S378s83BDb9GA2a+otCE/w=
Content-Disposition: inline
In-Reply-To: <20230830035600.1656792-1-liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed 30-08-23 11:56:00, Liu Shixin wrote:
> When spaces of swap devices are exhausted, only file pages can be reclaimed.
> But there are still some swapcache pages in anon lru list. This can lead
> to a premature out-of-memory.
> 
> The problem is found with such step:
> 
>  Firstly, set a 9MB disk swap space, then create a cgroup with 10MB
>  memory limit, then runs an program to allocates about 15MB memory.
> 
> The problem occurs occasionally, which may need about 100 times.
> 
> Fix it by checking number of swapcache pages in can_reclaim_anon_pages().
> If the number is not zero, return true either. Moreover, add a new bit
> swapcache_only in struct scan_control to skip isolating anon pages that
> are not swapcache when only swapcache pages can be reclaimed to accelerate
> reclaim efficiency.

Have you tested this also for the global reclaim? Am I just missing
something or this could seriously stall the reclaim in swapcache_only
mode if the swap cache pages cannot be dropped for some reason?

Also how big of a deal this is with somehow more realistic scenarios
with limits that are not so small?

> Link: https://lore.kernel.org/lkml/CAJD7tkZAfgncV+KbKr36=eDzMnT=9dZOT0dpMWcurHLr6Do+GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> Signed-off-by: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Tested-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
> v3->v4: Add describe and link about how to reproduce the problem.
> v4->v5: Add Reviewed-by and reproducer link.
> 
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
> index 1080209a568b..e73e2df8828d 100644
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
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
