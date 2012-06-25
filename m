From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v3 4/4] memcg: cleanup all typo in memory cgroup
Date: Mon, 25 Jun 2012 11:54:26 +0200
Message-ID: <20120625095426.GG19805@tiehlicka.suse.cz>
References: <1340613910-9629-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1340613910-9629-1-git-send-email-liwp.linux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <eric.dumazet@gmail.com>, Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

s/all typo in/all typos in/

On Mon 25-06-12 16:45:10, Wanpeng Li wrote:
> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
 
Have you used any tool to find them all or you just read through all of
them and fixed everything you found?


> Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
> ---
>  mm/memcontrol.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4520b57..d474bf6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -115,8 +115,8 @@ static const char * const mem_cgroup_events_names[] = {
>  
>  /*
>   * Per memcg event counter is incremented at every pagein/pageout. With THP,
> - * it will be incremated by the number of pages. This counter is used for
> - * for trigger some periodic events. This is straightforward and better
> + * it will be incremented by the number of pages. This counter is used to
> + * trigger some periodic events. This is straightforward and better
>   * than using jiffies etc. to handle periodic memcg event.
>   */
>  enum mem_cgroup_events_target {
> @@ -667,7 +667,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>   * Both of vmstat[] and percpu_counter has threshold and do periodic
>   * synchronization to implement "quick" read. There are trade-off between
>   * reading cost and precision of value. Then, we may have a chance to implement
> - * a periodic synchronizion of counter in memcg's counter.
> + * a periodic synchronization of counter in memcg's counter.
>   *
>   * But this _read() function is used for user interface now. The user accounts
>   * memory usage by memory cgroup and he _always_ requires exact value because
> @@ -677,7 +677,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>   *
>   * If there are kernel internal actions which can make use of some not-exact
>   * value, and reading all cpu value can be performance bottleneck in some
> - * common workload, threashold and synchonization as vmstat[] should be
> + * common workload, threshold and synchonization as vmstat[] should be
>   * implemented.
>   */
>  static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
> @@ -1304,7 +1304,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>   *
>   * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
>   *			  under hierarchy of moving cgroups. This is for
> - *			  waiting at hith-memory prressure caused by "move".
> + *			  waiting at hit-memory pressure caused by "move".
>   */
>  
>  static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
> @@ -1597,7 +1597,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>  /*
>   * Check all nodes whether it contains reclaimable pages or not.
>   * For quick scan, we make use of scan_nodes. This will allow us to skip
> - * unused nodes. But scan_nodes is lazily updated and may not cotain
> + * unused nodes. But scan_nodes is lazily updated and may not contain
>   * enough new information. We need to do double check.
>   */
>  static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
> @@ -2211,7 +2211,6 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (mem_cgroup_wait_acct_move(mem_over_limit))
>  		return CHARGE_RETRY;
>  
> -	/* If we don't need to call oom-killer at el, return immediately */
>  	if (!oom_check)
>  		return CHARGE_NOMEM;
>  	/* check OOM */
> @@ -2289,7 +2288,7 @@ again:
>  		 * In that case, "memcg" can point to root or p can be NULL with
>  		 * race with swapoff. Then, we have small risk of mis-accouning.
>  		 * But such kind of mis-account by race always happens because
> -		 * we don't have cgroup_mutex(). It's overkill and we allo that
> +		 * we don't have cgroup_mutex(). It's overkill and we allow that
>  		 * small race, here.
>  		 * (*) swapoff at el will charge against mm-struct not against
>  		 * task-struct. So, mm->owner can be NULL.
> @@ -2303,7 +2302,7 @@ again:
>  		}
>  		if (nr_pages == 1 && consume_stock(memcg)) {
>  			/*
> -			 * It seems dagerous to access memcg without css_get().
> +			 * It seems dangerous to access memcg without css_get().
>  			 * But considering how consume_stok works, it's not
>  			 * necessary. If consume_stock success, some charges
>  			 * from this memcg are cached on this cpu. So, we
> @@ -2394,7 +2393,7 @@ static void __mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
>  }
>  
>  /*
> - * Cancel chrages in this cgroup....doesn't propagate to parent cgroup.
> + * Cancel charges in this cgroup....doesn't propagate to parent cgroup.
>   * This is useful when moving usage to parent cgroup.
>   */
>  static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
> @@ -3208,7 +3207,7 @@ int mem_cgroup_prepare_migration(struct page *page,
>  		 * C)
>  		 * The "old" page is under lock_page() until the end of
>  		 * migration, so, the old page itself will not be swapped-out.
> -		 * If the new page is swapped out before end_migraton, our
> +		 * If the new page is swapped out before end_migration, our
>  		 * hook to usual swap-out path will catch the event.
>  		 */
>  		if (PageAnon(page))
> -- 
> 1.7.9.5
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
