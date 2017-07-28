From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Use int for event/state parameter in
 several functions
Date: Fri, 28 Jul 2017 08:58:15 +0200
Message-ID: <20170728065815.GD2274@dhcp22.suse.cz>
References: <20170727211004.34435-1-mka@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170727211004.34435-1-mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Thu 27-07-17 14:10:04, Matthias Kaehlcke wrote:
> Several functions use an enum type as parameter for an event/state,
> but are called in some locations with an argument of a different enum
> type. Adjust the interface of these functions to reality by changing the
> parameter to int.

enums are mostly for documentation purposes. Using defines would be
possible but less elegant. If for anything else then things like
MEMCG_NR_STAT.

> This fixes a ton of enum-conversion warnings that are generated when
> building the kernel with clang.
> 
> Signed-off-by: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!
> ---
>  include/linux/memcontrol.h | 20 ++++++++++++--------
>  mm/memcontrol.c            |  4 +++-
>  2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 3914e3dd6168..80edbc04361e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -487,8 +487,9 @@ extern int do_swap_account;
>  void lock_page_memcg(struct page *page);
>  void unlock_page_memcg(struct page *page);
>  
> +/* idx can be of type enum memcg_stat_item or node_stat_item */
>  static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
> -					     enum memcg_stat_item idx)
> +					     int idx)
>  {
>  	long val = 0;
>  	int cpu;
> @@ -502,15 +503,17 @@ static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
>  	return val;
>  }
>  
> +/* idx can be of type enum memcg_stat_item or node_stat_item */
>  static inline void __mod_memcg_state(struct mem_cgroup *memcg,
> -				     enum memcg_stat_item idx, int val)
> +				     int idx, int val)
>  {
>  	if (!mem_cgroup_disabled())
>  		__this_cpu_add(memcg->stat->count[idx], val);
>  }
>  
> +/* idx can be of type enum memcg_stat_item or node_stat_item */
>  static inline void mod_memcg_state(struct mem_cgroup *memcg,
> -				   enum memcg_stat_item idx, int val)
> +				   int idx, int val)
>  {
>  	if (!mem_cgroup_disabled())
>  		this_cpu_add(memcg->stat->count[idx], val);
> @@ -631,8 +634,9 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
>  		this_cpu_add(memcg->stat->events[idx], count);
>  }
>  
> +/* idx can be of type enum memcg_stat_item or node_stat_item */
>  static inline void count_memcg_page_event(struct page *page,
> -					  enum memcg_stat_item idx)
> +					  int idx)
>  {
>  	if (page->mem_cgroup)
>  		count_memcg_events(page->mem_cgroup, idx, 1);
> @@ -840,19 +844,19 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
>  }
>  
>  static inline unsigned long memcg_page_state(struct mem_cgroup *memcg,
> -					     enum memcg_stat_item idx)
> +					     int idx)
>  {
>  	return 0;
>  }
>  
>  static inline void __mod_memcg_state(struct mem_cgroup *memcg,
> -				     enum memcg_stat_item idx,
> +				     int idx,
>  				     int nr)
>  {
>  }
>  
>  static inline void mod_memcg_state(struct mem_cgroup *memcg,
> -				   enum memcg_stat_item idx,
> +				   int idx,
>  				   int nr)
>  {
>  }
> @@ -918,7 +922,7 @@ static inline void count_memcg_events(struct mem_cgroup *memcg,
>  }
>  
>  static inline void count_memcg_page_event(struct page *page,
> -					  enum memcg_stat_item idx)
> +					  int idx)
>  {
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3df3c04d73ab..460130d2a796 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -550,10 +550,12 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
>   * value, and reading all cpu value can be performance bottleneck in some
>   * common workload, threshold and synchronization as vmstat[] should be
>   * implemented.
> + *
> + * The parameter idx can be of type enum memcg_event_item or vm_event_item.
>   */
>  
>  static unsigned long memcg_sum_events(struct mem_cgroup *memcg,
> -				      enum memcg_event_item event)
> +				      int event)
>  {
>  	unsigned long val = 0;
>  	int cpu;
> -- 
> 2.14.0.rc0.400.g1c36432dff-goog

-- 
Michal Hocko
SUSE Labs
