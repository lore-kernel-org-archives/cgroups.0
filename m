From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: avoid charge statistics churn during
 page migration
Date: Tue, 5 Aug 2014 14:24:34 +0200
Message-ID: <20140805122434.GD15908@dhcp22.suse.cz>
References: <1407184469-20741-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1407184469-20741-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 04-08-14 16:34:29, Johannes Weiner wrote:
> Charge migration currently disables IRQs twice to update the charge
> statistics for the old page and then again for the new page.
> 
> But migration is a seemless transition of a charge from one physical
> page to another one of the same size, so this should be a non-event
> from an accounting point of view.  Leave the statistics alone.

Moving stats to mem_cgroup_commit_charge sounds logical to me but does
this work properly even for the fuse replace page cache case when old
and new pages can already live in different memcgs?

> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 35 ++++++++++-------------------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 475ecadd9646..8d65dadeec1b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2728,7 +2728,7 @@ static void unlock_page_lru(struct page *page, int isolated)
>  }
>  
>  static void commit_charge(struct page *page, struct mem_cgroup *memcg,
> -			  unsigned int nr_pages, bool lrucare)
> +			  bool lrucare)
>  {
>  	struct page_cgroup *pc = lookup_page_cgroup(page);
>  	int isolated;
> @@ -2765,16 +2765,6 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
>  
>  	if (lrucare)
>  		unlock_page_lru(page, isolated);
> -
> -	local_irq_disable();
> -	mem_cgroup_charge_statistics(memcg, page, nr_pages);
> -	/*
> -	 * "charge_statistics" updated event counter. Then, check it.
> -	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
> -	 * if they exceeds softlimit.
> -	 */
> -	memcg_check_events(memcg, page);
> -	local_irq_enable();
>  }
>  
>  static DEFINE_MUTEX(set_limit_mutex);
> @@ -6460,12 +6450,17 @@ void mem_cgroup_commit_charge(struct page *page, struct mem_cgroup *memcg,
>  	if (!memcg)
>  		return;
>  
> +	commit_charge(page, memcg, lrucare);
> +
>  	if (PageTransHuge(page)) {
>  		nr_pages <<= compound_order(page);
>  		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
>  	}
>  
> -	commit_charge(page, memcg, nr_pages, lrucare);
> +	local_irq_disable();
> +	mem_cgroup_charge_statistics(memcg, page, nr_pages);
> +	memcg_check_events(memcg, page);
> +	local_irq_enable();
>  
>  	if (do_swap_account && PageSwapCache(page)) {
>  		swp_entry_t entry = { .val = page_private(page) };
> @@ -6651,7 +6646,6 @@ void mem_cgroup_uncharge_list(struct list_head *page_list)
>  void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  			bool lrucare)
>  {
> -	unsigned int nr_pages = 1;
>  	struct page_cgroup *pc;
>  	int isolated;
>  
> @@ -6660,6 +6654,8 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	VM_BUG_ON_PAGE(!lrucare && PageLRU(oldpage), oldpage);
>  	VM_BUG_ON_PAGE(!lrucare && PageLRU(newpage), newpage);
>  	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
> +	VM_BUG_ON_PAGE(PageTransHuge(oldpage) != PageTransHuge(newpage),
> +		       newpage);
>  
>  	if (mem_cgroup_disabled())
>  		return;
> @@ -6677,12 +6673,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
>  	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
>  
> -	if (PageTransHuge(oldpage)) {
> -		nr_pages <<= compound_order(oldpage);
> -		VM_BUG_ON_PAGE(!PageTransHuge(oldpage), oldpage);
> -		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
> -	}
> -
>  	if (lrucare)
>  		lock_page_lru(oldpage, &isolated);
>  
> @@ -6691,12 +6681,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (lrucare)
>  		unlock_page_lru(oldpage, isolated);
>  
> -	local_irq_disable();
> -	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
> -	memcg_check_events(pc->mem_cgroup, oldpage);
> -	local_irq_enable();
> -
> -	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
> +	commit_charge(newpage, pc->mem_cgroup, lrucare);
>  }
>  
>  /*
> -- 
> 2.0.3
> 

-- 
Michal Hocko
SUSE Labs
