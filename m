From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 16/18] mm/memcg: Add folio_lruvec_lock() and similar
 functions
Date: Wed, 30 Jun 2021 10:36:28 +0200
Message-ID: <YNwtDL1FqMyahvx9@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-17-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625042189; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J54t0kTKZFLGPC8GkpCa4mzBpDvbYK3QQwJ1xzMAaEE=;
        b=sJFOXuQbMzEgVJBtaasAH18mD7DQV8kGqI/BzeLiXU/Rd6hsSPnSp67puixRjb+MxHjtSD
        tiAlkLEghCFDET34WTOnAW3cgAALS457BptBepjSAl2UmKm4UepGmQi5kYhqDeUTFjY/V2
        2+b3EUudR4NJMIQJE89zcqaV4y4f9lk=
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-17-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 05:00:32, Matthew Wilcox wrote:
> These are the folio equivalents of lock_page_lruvec() and
> similar functions.  Retain lock_page_lruvec() as wrappers so we
> don't have to convert all these functions twice.  Also convert
> lruvec_memcg_debug() to take a folio.

Here again I would rather not go with wrappers. I can see how changing
all the callers (20+) is annoying but they all should be pretty trivial
so if we can avoid that I would go with a direct folio_lruvec_{un}lock

> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++-----------
>  mm/compaction.c            |  2 +-
>  mm/memcontrol.c            | 33 ++++++++++++++------------------
>  3 files changed, 43 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index a7e1ccbc7ed6..b21a77669277 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -769,15 +769,16 @@ struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
>  
>  struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
>  
> -struct lruvec *lock_page_lruvec(struct page *page);
> -struct lruvec *lock_page_lruvec_irq(struct page *page);
> -struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> +struct lruvec *folio_lruvec_lock(struct folio *folio);
> +struct lruvec *folio_lruvec_lock_irq(struct folio *folio);
> +struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
>  						unsigned long *flags);
>  
>  #ifdef CONFIG_DEBUG_VM
> -void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page);
> +void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio);
>  #else
> -static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
> +static inline
> +void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
>  {
>  }
>  #endif
> @@ -1257,26 +1258,26 @@ static inline void mem_cgroup_put(struct mem_cgroup *memcg)
>  {
>  }
>  
> -static inline struct lruvec *lock_page_lruvec(struct page *page)
> +static inline struct lruvec *folio_lruvec_lock(struct folio *folio)
>  {
> -	struct pglist_data *pgdat = page_pgdat(page);
> +	struct pglist_data *pgdat = folio_pgdat(folio);
>  
>  	spin_lock(&pgdat->__lruvec.lru_lock);
>  	return &pgdat->__lruvec;
>  }
>  
> -static inline struct lruvec *lock_page_lruvec_irq(struct page *page)
> +static inline struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
>  {
> -	struct pglist_data *pgdat = page_pgdat(page);
> +	struct pglist_data *pgdat = folio_pgdat(folio);
>  
>  	spin_lock_irq(&pgdat->__lruvec.lru_lock);
>  	return &pgdat->__lruvec;
>  }
>  
> -static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> +static inline struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
>  		unsigned long *flagsp)
>  {
> -	struct pglist_data *pgdat = page_pgdat(page);
> +	struct pglist_data *pgdat = folio_pgdat(folio);
>  
>  	spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);
>  	return &pgdat->__lruvec;
> @@ -1488,6 +1489,22 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page)
>  	return mem_cgroup_folio_lruvec(page_folio(page));
>  }
>  
> +static inline struct lruvec *lock_page_lruvec(struct page *page)
> +{
> +	return folio_lruvec_lock(page_folio(page));
> +}
> +
> +static inline struct lruvec *lock_page_lruvec_irq(struct page *page)
> +{
> +	return folio_lruvec_lock_irq(page_folio(page));
> +}
> +
> +static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> +						unsigned long *flags)
> +{
> +	return folio_lruvec_lock_irqsave(page_folio(page), flags);
> +}
> +
>  static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
>  {
>  	__mod_lruvec_kmem_state(p, idx, 1);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 3a509fbf2bea..8b0da04b70f2 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1038,7 +1038,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>  			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
>  			locked = lruvec;
>  
> -			lruvec_memcg_debug(lruvec, page);
> +			lruvec_memcg_debug(lruvec, page_folio(page));
>  
>  			/* Try get exclusive access under lock */
>  			if (!skip_updated) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 95795b65ae3e..23b166917def 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1153,19 +1153,19 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  }
>  
>  #ifdef CONFIG_DEBUG_VM
> -void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
> +void lruvec_memcg_debug(struct lruvec *lruvec, struct folio *folio)
>  {
>  	struct mem_cgroup *memcg;
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  
> -	memcg = page_memcg(page);
> +	memcg = folio_memcg(folio);
>  
>  	if (!memcg)
> -		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != root_mem_cgroup, page);
> +		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != root_mem_cgroup, folio);
>  	else
> -		VM_BUG_ON_PAGE(lruvec_memcg(lruvec) != memcg, page);
> +		VM_BUG_ON_FOLIO(lruvec_memcg(lruvec) != memcg, folio);
>  }
>  #endif
>  
> @@ -1179,38 +1179,33 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
>   * - lock_page_memcg()
>   * - page->_refcount is zero
>   */
> -struct lruvec *lock_page_lruvec(struct page *page)
> +struct lruvec *folio_lruvec_lock(struct folio *folio)
>  {
> -	struct lruvec *lruvec;
> +	struct lruvec *lruvec = mem_cgroup_folio_lruvec(folio);
>  
> -	lruvec = mem_cgroup_page_lruvec(page);
>  	spin_lock(&lruvec->lru_lock);
> -
> -	lruvec_memcg_debug(lruvec, page);
> +	lruvec_memcg_debug(lruvec, folio);
>  
>  	return lruvec;
>  }
>  
> -struct lruvec *lock_page_lruvec_irq(struct page *page)
> +struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
>  {
> -	struct lruvec *lruvec;
> +	struct lruvec *lruvec = mem_cgroup_folio_lruvec(folio);
>  
> -	lruvec = mem_cgroup_page_lruvec(page);
>  	spin_lock_irq(&lruvec->lru_lock);
> -
> -	lruvec_memcg_debug(lruvec, page);
> +	lruvec_memcg_debug(lruvec, folio);
>  
>  	return lruvec;
>  }
>  
> -struct lruvec *lock_page_lruvec_irqsave(struct page *page, unsigned long *flags)
> +struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
> +		unsigned long *flags)
>  {
> -	struct lruvec *lruvec;
> +	struct lruvec *lruvec = mem_cgroup_folio_lruvec(folio);
>  
> -	lruvec = mem_cgroup_page_lruvec(page);
>  	spin_lock_irqsave(&lruvec->lru_lock, *flags);
> -
> -	lruvec_memcg_debug(lruvec, page);
> +	lruvec_memcg_debug(lruvec, folio);
>  
>  	return lruvec;
>  }
> -- 
> 2.30.2

-- 
Michal Hocko
SUSE Labs
