From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 1/5] mm/memcg: Revert ("mm/memcg: optimize user
 context object stock access")
Date: Mon, 21 Feb 2022 15:26:49 +0100
Message-ID: <YhOhKedktkyA8nR+@dhcp22.suse.cz>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645453610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=erFIj+CqDafIPHSlUauOlPFan3dbHqIvMXOe9E+uD7E=;
        b=dvBudZUIwiPAa88w5PCfHStdKNp+fGaML18owRLK1BWqsMEHnWmBC0Km+ACMsfjZ3EysyA
        4DzUgfQ/WAkVGp0wc6AIWYMW8Ry1vwQPgWsYOBCT0yVY5NMlCW8dhjOW/c9bNH3uSdtJq5
        EllLNXbCw13lEtn6/BWwc6bkZGMT2IM=
Content-Disposition: inline
In-Reply-To: <20220217094802.3644569-2-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu 17-02-22 10:47:58, Sebastian Andrzej Siewior wrote:
> From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> 
> The optimisation is based on a micro benchmark where local_irq_save() is
> more expensive than a preempt_disable(). There is no evidence that it is
> visible in a real-world workload and there are CPUs where the opposite is
> true (local_irq_save() is cheaper than preempt_disable()).
> 
> Based on micro benchmarks, the optimisation makes sense on PREEMPT_NONE
> where preempt_disable() is optimized away. There is no improvement with
> PREEMPT_DYNAMIC since the preemption counter is always available.
> 
> The optimization makes also the PREEMPT_RT integration more complicated
> since most of the assumption are not true on PREEMPT_RT.
> 
> Revert the optimisation since it complicates the PREEMPT_RT integration
> and the improvement is hardly visible.
> 
> [ bigeasy: Patch body around Michal's diff ]

Thanks for preparing the changelog for this. I was planning to post mine
but I was waiting for a feedback from Waiman. Anyway this looks good to
me.

> 
> Link: https://lore.kernel.org/all/YgOGkXXCrD%2F1k+p4-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
> Link: https://lkml.kernel.org/r/YdX+INO9gQje6d0S-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 94 ++++++++++++++-----------------------------------
>  1 file changed, 27 insertions(+), 67 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3c4816147273a..8ab2dc75e70ec 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2078,23 +2078,17 @@ void unlock_page_memcg(struct page *page)
>  	folio_memcg_unlock(page_folio(page));
>  }
>  
> -struct obj_stock {
> +struct memcg_stock_pcp {
> +	struct mem_cgroup *cached; /* this never be root cgroup */
> +	unsigned int nr_pages;
> +
>  #ifdef CONFIG_MEMCG_KMEM
>  	struct obj_cgroup *cached_objcg;
>  	struct pglist_data *cached_pgdat;
>  	unsigned int nr_bytes;
>  	int nr_slab_reclaimable_b;
>  	int nr_slab_unreclaimable_b;
> -#else
> -	int dummy[0];
>  #endif
> -};
> -
> -struct memcg_stock_pcp {
> -	struct mem_cgroup *cached; /* this never be root cgroup */
> -	unsigned int nr_pages;
> -	struct obj_stock task_obj;
> -	struct obj_stock irq_obj;
>  
>  	struct work_struct work;
>  	unsigned long flags;
> @@ -2104,13 +2098,13 @@ static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
>  static DEFINE_MUTEX(percpu_charge_mutex);
>  
>  #ifdef CONFIG_MEMCG_KMEM
> -static void drain_obj_stock(struct obj_stock *stock);
> +static void drain_obj_stock(struct memcg_stock_pcp *stock);
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  				     struct mem_cgroup *root_memcg);
>  static void memcg_account_kmem(struct mem_cgroup *memcg, int nr_pages);
>  
>  #else
> -static inline void drain_obj_stock(struct obj_stock *stock)
> +static inline void drain_obj_stock(struct memcg_stock_pcp *stock)
>  {
>  }
>  static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
> @@ -2190,9 +2184,7 @@ static void drain_local_stock(struct work_struct *dummy)
>  	local_irq_save(flags);
>  
>  	stock = this_cpu_ptr(&memcg_stock);
> -	drain_obj_stock(&stock->irq_obj);
> -	if (in_task())
> -		drain_obj_stock(&stock->task_obj);
> +	drain_obj_stock(stock);
>  	drain_stock(stock);
>  	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
>  
> @@ -2767,41 +2759,6 @@ static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
>   */
>  #define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
>  
> -/*
> - * Most kmem_cache_alloc() calls are from user context. The irq disable/enable
> - * sequence used in this case to access content from object stock is slow.
> - * To optimize for user context access, there are now two object stocks for
> - * task context and interrupt context access respectively.
> - *
> - * The task context object stock can be accessed by disabling preemption only
> - * which is cheap in non-preempt kernel. The interrupt context object stock
> - * can only be accessed after disabling interrupt. User context code can
> - * access interrupt object stock, but not vice versa.
> - */
> -static inline struct obj_stock *get_obj_stock(unsigned long *pflags)
> -{
> -	struct memcg_stock_pcp *stock;
> -
> -	if (likely(in_task())) {
> -		*pflags = 0UL;
> -		preempt_disable();
> -		stock = this_cpu_ptr(&memcg_stock);
> -		return &stock->task_obj;
> -	}
> -
> -	local_irq_save(*pflags);
> -	stock = this_cpu_ptr(&memcg_stock);
> -	return &stock->irq_obj;
> -}
> -
> -static inline void put_obj_stock(unsigned long flags)
> -{
> -	if (likely(in_task()))
> -		preempt_enable();
> -	else
> -		local_irq_restore(flags);
> -}
> -
>  /*
>   * mod_objcg_mlstate() may be called with irq enabled, so
>   * mod_memcg_lruvec_state() should be used.
> @@ -3082,10 +3039,13 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
>  void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  		     enum node_stat_item idx, int nr)
>  {
> +	struct memcg_stock_pcp *stock;
>  	unsigned long flags;
> -	struct obj_stock *stock = get_obj_stock(&flags);
>  	int *bytes;
>  
> +	local_irq_save(flags);
> +	stock = this_cpu_ptr(&memcg_stock);
> +
>  	/*
>  	 * Save vmstat data in stock and skip vmstat array update unless
>  	 * accumulating over a page of vmstat data or when pgdat or idx
> @@ -3136,26 +3096,29 @@ void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
>  	if (nr)
>  		mod_objcg_mlstate(objcg, pgdat, idx, nr);
>  
> -	put_obj_stock(flags);
> +	local_irq_restore(flags);
>  }
>  
>  static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
>  {
> +	struct memcg_stock_pcp *stock;
>  	unsigned long flags;
> -	struct obj_stock *stock = get_obj_stock(&flags);
>  	bool ret = false;
>  
> +	local_irq_save(flags);
> +
> +	stock = this_cpu_ptr(&memcg_stock);
>  	if (objcg == stock->cached_objcg && stock->nr_bytes >= nr_bytes) {
>  		stock->nr_bytes -= nr_bytes;
>  		ret = true;
>  	}
>  
> -	put_obj_stock(flags);
> +	local_irq_restore(flags);
>  
>  	return ret;
>  }
>  
> -static void drain_obj_stock(struct obj_stock *stock)
> +static void drain_obj_stock(struct memcg_stock_pcp *stock)
>  {
>  	struct obj_cgroup *old = stock->cached_objcg;
>  
> @@ -3211,13 +3174,8 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  {
>  	struct mem_cgroup *memcg;
>  
> -	if (in_task() && stock->task_obj.cached_objcg) {
> -		memcg = obj_cgroup_memcg(stock->task_obj.cached_objcg);
> -		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
> -			return true;
> -	}
> -	if (stock->irq_obj.cached_objcg) {
> -		memcg = obj_cgroup_memcg(stock->irq_obj.cached_objcg);
> +	if (stock->cached_objcg) {
> +		memcg = obj_cgroup_memcg(stock->cached_objcg);
>  		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
>  			return true;
>  	}
> @@ -3228,10 +3186,13 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
>  static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  			     bool allow_uncharge)
>  {
> +	struct memcg_stock_pcp *stock;
>  	unsigned long flags;
> -	struct obj_stock *stock = get_obj_stock(&flags);
>  	unsigned int nr_pages = 0;
>  
> +	local_irq_save(flags);
> +
> +	stock = this_cpu_ptr(&memcg_stock);
>  	if (stock->cached_objcg != objcg) { /* reset if necessary */
>  		drain_obj_stock(stock);
>  		obj_cgroup_get(objcg);
> @@ -3247,7 +3208,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  		stock->nr_bytes &= (PAGE_SIZE - 1);
>  	}
>  
> -	put_obj_stock(flags);
> +	local_irq_restore(flags);
>  
>  	if (nr_pages)
>  		obj_cgroup_uncharge_pages(objcg, nr_pages);
> @@ -6812,7 +6773,6 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
>  	long nr_pages;
>  	struct mem_cgroup *memcg;
>  	struct obj_cgroup *objcg;
> -	bool use_objcg = folio_memcg_kmem(folio);
>  
>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>  
> @@ -6821,7 +6781,7 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
>  	 * folio memcg or objcg at this point, we have fully
>  	 * exclusive access to the folio.
>  	 */
> -	if (use_objcg) {
> +	if (folio_memcg_kmem(folio)) {
>  		objcg = __folio_objcg(folio);
>  		/*
>  		 * This get matches the put at the end of the function and
> @@ -6849,7 +6809,7 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
>  
>  	nr_pages = folio_nr_pages(folio);
>  
> -	if (use_objcg) {
> +	if (folio_memcg_kmem(folio)) {
>  		ug->nr_memory += nr_pages;
>  		ug->nr_kmem += nr_pages;
>  
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs
