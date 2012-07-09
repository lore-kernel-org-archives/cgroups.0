From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 04/11] mm: memcg: push down PageSwapCache check into
 uncharge entry functions
Date: Mon, 9 Jul 2012 17:02:36 +0200
Message-ID: <20120709150236.GG4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341449103-1986-5-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-07-12 02:44:56, Johannes Weiner wrote:
> Not all uncharge paths need to check if the page is swapcache, some of
> them can know for sure.
> 
> Push down the check into all callsites of uncharge_common() so that
> the patch that removes some of them is more obvious.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

with the fix later in the thread
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |   18 ++++++++++++------
>  1 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4ea19c6..a3bf414 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2920,8 +2920,7 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype,
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	if (PageSwapCache(page))
> -		return NULL;
> +	VM_BUG_ON(PageSwapCache(page));
>  
>  	if (PageTransHuge(page)) {
>  		nr_pages <<= compound_order(page);
> @@ -3018,6 +3017,8 @@ void mem_cgroup_uncharge_page(struct page *page)
>  	if (page_mapped(page))
>  		return;
>  	VM_BUG_ON(page->mapping && !PageAnon(page));
> +	if (PageSwapCache(page))
> +		return;
>  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
>  }
>  
> @@ -3025,6 +3026,8 @@ void mem_cgroup_uncharge_cache_page(struct page *page)
>  {
>  	VM_BUG_ON(page_mapped(page));
>  	VM_BUG_ON(page->mapping);
> +	if (PageSwapCache(page))
> +		return;
>  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE, false);
>  }
>  
> @@ -3089,6 +3092,8 @@ mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout)
>  	if (!swapout) /* this was a swap cache but the swap is unused ! */
>  		ctype = MEM_CGROUP_CHARGE_TYPE_DROP;
>  
> +	if (PageSwapCache(page))
> +		return;
>  	memcg = __mem_cgroup_uncharge_common(page, ctype, false);
>  
>  	/*
> @@ -3278,10 +3283,11 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
>  		unused = oldpage;
>  	}
>  	anon = PageAnon(used);
> -	__mem_cgroup_uncharge_common(unused,
> -		anon ? MEM_CGROUP_CHARGE_TYPE_ANON
> -		     : MEM_CGROUP_CHARGE_TYPE_CACHE,
> -		true);
> +	if (!PageSwapCache(page))
> +		__mem_cgroup_uncharge_common(unused,
> +					     anon ? MEM_CGROUP_CHARGE_TYPE_ANON
> +					     : MEM_CGROUP_CHARGE_TYPE_CACHE,
> +					     true);
>  	css_put(&memcg->css);
>  	/*
>  	 * We disallowed uncharge of pages under migration because mapcount
> -- 
> 1.7.7.6
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
