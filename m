From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: simplify lock of memcg page stat accounting
Date: Mon, 28 Jan 2013 15:10:10 +0100
Message-ID: <20130128141010.GD14241@dhcp22.suse.cz>
References: <1359198756-3752-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1359198756-3752-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Hi,
just a minor comment/suggestion. The patch would be much more easier to
review if you split it up into two parts. Preparatory with page->memcg
parameter change and the locking change you are proposing.

On Sat 26-01-13 19:12:36, Sha Zhengju wrote:
[...]
> So in order to make the lock simpler and clearer and also avoid the 'nesting'
> problem, a choice may be:
> (CPU-A does "page stat accounting" and CPU-B does "move")
> 
>        CPU-A                        CPU-B
> 
> move_lock_mem_cgroup()
> memcg = pc->mem_cgroup
> TestSetPageDirty(page)
> move_unlock_mem_cgroup()
>                              move_lock_mem_cgroup()
>                              if (PageDirty) {
>                                   old_memcg->nr_dirty --;
>                                   new_memcg->nr_dirty ++;
>                              }
>                              pc->mem_cgroup = new_memcg
>                              move_unlock_mem_cgroup()
> 
> memcg->nr_dirty ++
>
> For CPU-A, we save pc->mem_cgroup in a temporary variable just before
> TestSetPageDirty inside move_lock and then update stats if the page is set
> PG_dirty successfully.

Hmm, the description is a bit confising. You are talking about
TestSetPageDirty but dirty accounting is not directly handled in the
patch. It took me a bit to figure that it's actually set_page_dirty
called from page_remove_rmap which matters here.  So it is more a
dependency between MEMCG_NR_FILE_MAPPED and your future (currently
non-existent) MEMCG_NR_FILE_DIRTY accounting that you are preparing.
set_page_dirty now can take mem_cgroup_{begin,end}_update_page_stat.

> But CPU-B may do "moving" in advance that
> "old_memcg->nr_dirty --" will make old_memcg->nr_dirty incorrect but
> soon CPU-A will do "memcg->nr_dirty ++" finally that amend the stats.

The counter is per-cpu so we are safe wrt. atomic increments and we can
probably tolerate off-by 1 temporal errors (mem_cgroup_read_stat would
need val = min(val, 0);).
I am not sure I like this very much though. It adds an additional memcg
reference counting into page_add_file which is a hot path already.

I think the accounting side should be as lightweight as possible and the
additional price should be payed by mover.

> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/memcontrol.h |   14 +++++------
>  mm/memcontrol.c            |    8 ++-----
>  mm/rmap.c                  |   55 +++++++++++++++++++++++++++++++++-----------
>  3 files changed, 51 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0108a56..12de53b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -164,20 +164,20 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>  	rcu_read_unlock();
>  }
>  
> -void mem_cgroup_update_page_stat(struct page *page,
> +void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>  				 enum mem_cgroup_page_stat_item idx,
>  				 int val);
>  
> -static inline void mem_cgroup_inc_page_stat(struct page *page,
> +static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
>  					    enum mem_cgroup_page_stat_item idx)
>  {
> -	mem_cgroup_update_page_stat(page, idx, 1);
> +	mem_cgroup_update_page_stat(memcg, idx, 1);
>  }
>  
> -static inline void mem_cgroup_dec_page_stat(struct page *page,
> +static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
>  					    enum mem_cgroup_page_stat_item idx)
>  {
> -	mem_cgroup_update_page_stat(page, idx, -1);
> +	mem_cgroup_update_page_stat(memcg, idx, -1);
>  }
>  
>  unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
> @@ -354,12 +354,12 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>  {
>  }
>  
> -static inline void mem_cgroup_inc_page_stat(struct page *page,
> +static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
>  					    enum mem_cgroup_page_stat_item idx)
>  {
>  }
>  
> -static inline void mem_cgroup_dec_page_stat(struct page *page,
> +static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
>  					    enum mem_cgroup_page_stat_item idx)
>  {
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3817460..1b13e43 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2259,18 +2259,14 @@ void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
>  	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
>  }
>  
> -void mem_cgroup_update_page_stat(struct page *page,
> +void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>  				 enum mem_cgroup_page_stat_item idx, int val)
>  {
> -	struct mem_cgroup *memcg;
> -	struct page_cgroup *pc = lookup_page_cgroup(page);
> -	unsigned long uninitialized_var(flags);
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  
> -	memcg = pc->mem_cgroup;
> -	if (unlikely(!memcg || !PageCgroupUsed(pc)))
> +	if (unlikely(!memcg))
>  		return;
>  
>  	switch (idx) {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 59b0dca..0d74c48 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1112,13 +1112,25 @@ void page_add_file_rmap(struct page *page)
>  {
>  	bool locked;
>  	unsigned long flags;
> +	bool ret;
> +	struct mem_cgroup *memcg = NULL;
> +	struct cgroup_subsys_state *css = NULL;
>  
>  	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
> -	if (atomic_inc_and_test(&page->_mapcount)) {
> +	memcg = try_get_mem_cgroup_from_page(page);
> +	ret = atomic_inc_and_test(&page->_mapcount);
> +	mem_cgroup_end_update_page_stat(page, &locked, &flags);
> +
> +	if (ret) {
>  		__inc_zone_page_state(page, NR_FILE_MAPPED);
> -		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_MAPPED);
> +		if (memcg)
> +			mem_cgroup_inc_page_stat(memcg, MEMCG_NR_FILE_MAPPED);
> +	}
> +
> +	if (memcg) {
> +		css = mem_cgroup_css(memcg);
> +		css_put(css);
>  	}
> -	mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  }
>  
>  /**
> @@ -1133,18 +1145,32 @@ void page_remove_rmap(struct page *page)
>  	bool anon = PageAnon(page);
>  	bool locked;
>  	unsigned long flags;
> +	struct mem_cgroup *memcg = NULL;
> +	struct cgroup_subsys_state *css = NULL;
> +	bool ret;
>  
>  	/*
>  	 * The anon case has no mem_cgroup page_stat to update; but may
>  	 * uncharge_page() below, where the lock ordering can deadlock if
>  	 * we hold the lock against page_stat move: so avoid it on anon.
>  	 */
> -	if (!anon)
> +	if (!anon) {
>  		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
> +		memcg = try_get_mem_cgroup_from_page(page);
> +		if (memcg)
> +			css = mem_cgroup_css(memcg);
> +	}
> +
> +	ret = atomic_add_negative(-1, &page->_mapcount);
> +	if (!anon)
> +		mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  
>  	/* page still mapped by someone else? */
> -	if (!atomic_add_negative(-1, &page->_mapcount))
> -		goto out;
> +	if (!ret) {
> +		if (!anon && memcg)
> +			css_put(css);
> +		return;
> +	}
>  
>  	/*
>  	 * Now that the last pte has gone, s390 must transfer dirty
> @@ -1173,8 +1199,12 @@ void page_remove_rmap(struct page *page)
>  	 * Hugepages are not counted in NR_ANON_PAGES nor NR_FILE_MAPPED
>  	 * and not charged by memcg for now.
>  	 */
> -	if (unlikely(PageHuge(page)))
> -		goto out;
> +	if (unlikely(PageHuge(page))) {
> +		if (!anon && memcg)
> +			css_put(css);
> +		return;
> +	}
> +
>  	if (anon) {
>  		mem_cgroup_uncharge_page(page);
>  		if (!PageTransHuge(page))
> @@ -1184,8 +1214,10 @@ void page_remove_rmap(struct page *page)
>  					      NR_ANON_TRANSPARENT_HUGEPAGES);
>  	} else {
>  		__dec_zone_page_state(page, NR_FILE_MAPPED);
> -		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_MAPPED);
> -		mem_cgroup_end_update_page_stat(page, &locked, &flags);
> +		if (memcg) {
> +			mem_cgroup_dec_page_stat(memcg, MEMCG_NR_FILE_MAPPED);
> +			css_put(css);
> +		}
>  	}
>  	if (unlikely(PageMlocked(page)))
>  		clear_page_mlock(page);
> @@ -1199,9 +1231,6 @@ void page_remove_rmap(struct page *page)
>  	 * faster for those pages still in swapcache.
>  	 */
>  	return;
> -out:
> -	if (!anon)
> -		mem_cgroup_end_update_page_stat(page, &locked, &flags);
>  }
>  
>  /*
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
