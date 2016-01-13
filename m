From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/7] mm: vmscan: do not scan anon pages if memcg swap
 limit is hit
Date: Wed, 13 Jan 2016 17:54:50 +0100
Message-ID: <20160113165450.GI17512@dhcp22.suse.cz>
References: <cover.1450352791.git.vdavydov@virtuozzo.com>
 <6f6fa6cbfe005917911f89b2b12d5fbfa0b071e4.1450352792.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6f6fa6cbfe005917911f89b2b12d5fbfa0b071e4.1450352792.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 17-12-15 15:29:58, Vladimir Davydov wrote:
> We don't scan anonymous memory if we ran out of swap, neither should we
> do it in case memcg swap limit is hit, because swap out is impossible
> anyway.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
> Changes in v2:
>  - Do not check swap limit on the legacy hierarchy.
> 
>  include/linux/swap.h |  6 ++++++
>  mm/memcontrol.c      | 13 +++++++++++++
>  mm/vmscan.c          |  2 +-
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index f8fb4e06c4bd..c544998dfbe7 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -551,6 +551,7 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
>  extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
>  extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
>  extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
> +extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
>  #else
>  static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  {
> @@ -565,6 +566,11 @@ static inline int mem_cgroup_try_charge_swap(struct page *page,
>  static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
>  {
>  }
> +
> +static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> +{
> +	return get_nr_swap_pages();
> +}
>  #endif
>  
>  #endif /* __KERNEL__*/
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 567b56da2c23..e0e498f5ca32 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5736,6 +5736,19 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry)
>  	rcu_read_unlock();
>  }
>  
> +long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
> +{
> +	long nr_swap_pages = get_nr_swap_pages();
> +
> +	if (!do_swap_account || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return nr_swap_pages;
> +	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
> +		nr_swap_pages = min_t(long, nr_swap_pages,
> +				      READ_ONCE(memcg->swap.limit) -
> +				      page_counter_read(&memcg->swap));
> +	return nr_swap_pages;
> +}
> +
>  /* for remember boot option*/
>  #ifdef CONFIG_MEMCG_SWAP_ENABLED
>  static int really_do_swap_account __initdata = 1;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b220e6cda25d..ab52d865d922 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1995,7 +1995,7 @@ static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
>  		force_scan = true;
>  
>  	/* If we have no swap space, do not bother scanning anon pages. */
> -	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
> +	if (!sc->may_swap || mem_cgroup_get_nr_swap_pages(memcg) <= 0) {
>  		scan_balance = SCAN_FILE;
>  		goto out;
>  	}
> -- 
> 2.1.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
