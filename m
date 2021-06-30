From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 13/18] mm/memcg: Add folio_memcg_lock() and
 folio_memcg_unlock()
Date: Wed, 30 Jun 2021 10:32:02 +0200
Message-ID: <YNwsAh5u2h34tGDb@dhcp22.suse.cz>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-14-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625041923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BU8f/y6bjZp8hilPWlfwJ8tYxOf5hmQ+DmvYBvx3LGw=;
        b=czhBKD6nSfh29IFqX7OG1qjmZWFiR9yh/UZnEHgqbkKSRZCqA+m71nq6QSq6xBAv76KRI9
        65Ni0WmHno53pLBR5ofM4SI3P/PyiDArZj8xui8YcebNHJx7yTUdFRya3b3rSYeSRHEVde
        h0sXmMMCp/YmogpSJ+SAeVlDdEM5bwg=
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-14-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 30-06-21 05:00:29, Matthew Wilcox wrote:
> These are the folio equivalents of lock_page_memcg() and
> unlock_page_memcg().  Reimplement them as wrappers.

Is there any reason why you haven't followed the same approach as for
the previous patches. I mean callers can call page_folio and then
lock_page_memcg wrapper shouldn't be really needed.

I do not really want to be annoying here but I have to say that I like
the conversion by previous patches much better than this wrapper
approach as mentioned during the previous review already. If you have
some reasons to stick with this approach for this particular case then
make it explicit in the changelog.

> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 10 +++++++++
>  mm/memcontrol.c            | 45 ++++++++++++++++++++++++--------------
>  2 files changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ef79f9c0b296..279ea2640365 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -951,6 +951,8 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
>  extern bool cgroup_memory_noswap;
>  #endif
>  
> +void folio_memcg_lock(struct folio *folio);
> +void folio_memcg_unlock(struct folio *folio);
>  void lock_page_memcg(struct page *page);
>  void unlock_page_memcg(struct page *page);
>  
> @@ -1363,6 +1365,14 @@ static inline void unlock_page_memcg(struct page *page)
>  {
>  }
>  
> +static inline void folio_memcg_lock(struct folio *folio)
> +{
> +}
> +
> +static inline void folio_memcg_unlock(struct folio *folio)
> +{
> +}
> +
>  static inline void mem_cgroup_handle_over_high(void)
>  {
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b925bdce0c6e..b94a6122f27d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1960,18 +1960,17 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
>  }
>  
>  /**
> - * lock_page_memcg - lock a page and memcg binding
> - * @page: the page
> + * folio_memcg_lock - Bind a folio to its memcg.
> + * @folio: The folio.
>   *
> - * This function protects unlocked LRU pages from being moved to
> + * This function prevents unlocked LRU folios from being moved to
>   * another cgroup.
>   *
> - * It ensures lifetime of the locked memcg. Caller is responsible
> - * for the lifetime of the page.
> + * It ensures lifetime of the bound memcg.  The caller is responsible
> + * for the lifetime of the folio.
>   */
> -void lock_page_memcg(struct page *page)
> +void folio_memcg_lock(struct folio *folio)
>  {
> -	struct page *head = compound_head(page); /* rmap on tail pages */
>  	struct mem_cgroup *memcg;
>  	unsigned long flags;
>  
> @@ -1985,7 +1984,7 @@ void lock_page_memcg(struct page *page)
>  	if (mem_cgroup_disabled())
>  		return;
>  again:
> -	memcg = page_memcg(head);
> +	memcg = folio_memcg(folio);
>  	if (unlikely(!memcg))
>  		return;
>  
> @@ -1999,7 +1998,7 @@ void lock_page_memcg(struct page *page)
>  		return;
>  
>  	spin_lock_irqsave(&memcg->move_lock, flags);
> -	if (memcg != page_memcg(head)) {
> +	if (memcg != folio_memcg(folio)) {
>  		spin_unlock_irqrestore(&memcg->move_lock, flags);
>  		goto again;
>  	}
> @@ -2013,9 +2012,15 @@ void lock_page_memcg(struct page *page)
>  	memcg->move_lock_task = current;
>  	memcg->move_lock_flags = flags;
>  }
> +EXPORT_SYMBOL(folio_memcg_lock);
> +
> +void lock_page_memcg(struct page *page)
> +{
> +	folio_memcg_lock(page_folio(page));
> +}
>  EXPORT_SYMBOL(lock_page_memcg);
>  
> -static void __unlock_page_memcg(struct mem_cgroup *memcg)
> +static void __memcg_unlock(struct mem_cgroup *memcg)
>  {
>  	if (memcg && memcg->move_lock_task == current) {
>  		unsigned long flags = memcg->move_lock_flags;
> @@ -2030,14 +2035,22 @@ static void __unlock_page_memcg(struct mem_cgroup *memcg)
>  }
>  
>  /**
> - * unlock_page_memcg - unlock a page and memcg binding
> - * @page: the page
> + * folio_memcg_unlock - Release the binding between a folio and its memcg.
> + * @folio: The folio.
> + *
> + * This releases the binding created by folio_memcg_lock().  This does
> + * not change the accounting of this folio to its memcg, but it does
> + * permit others to change it.
>   */
> -void unlock_page_memcg(struct page *page)
> +void folio_memcg_unlock(struct folio *folio)
>  {
> -	struct page *head = compound_head(page);
> +	__memcg_unlock(folio_memcg(folio));
> +}
> +EXPORT_SYMBOL(folio_memcg_unlock);
>  
> -	__unlock_page_memcg(page_memcg(head));
> +void unlock_page_memcg(struct page *page)
> +{
> +	folio_memcg_unlock(page_folio(page));
>  }
>  EXPORT_SYMBOL(unlock_page_memcg);
>  
> @@ -5661,7 +5674,7 @@ static int mem_cgroup_move_account(struct page *page,
>  
>  	page->memcg_data = (unsigned long)to;
>  
> -	__unlock_page_memcg(from);
> +	__memcg_unlock(from);
>  
>  	ret = 0;
>  	nid = page_to_nid(page);
> -- 
> 2.30.2

-- 
Michal Hocko
SUSE Labs
