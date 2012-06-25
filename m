From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3 4/4] memcg: cleanup all typo in memory cgroup
Date: Mon, 25 Jun 2012 19:22:33 +0900
Message-ID: <4FE83BE9.7050701@jp.fujitsu.com>
References: <1340613910-9629-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340613910-9629-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2012/06/25 17:45), Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

my thunderbird's spell checker founds some more ;)

> ---
>   mm/memcontrol.c |   21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4520b57..d474bf6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -115,8 +115,8 @@ static const char * const mem_cgroup_events_names[] = {
>   
>   /*
>    * Per memcg event counter is incremented at every pagein/pageout. With THP,
> - * it will be incremated by the number of pages. This counter is used for
> - * for trigger some periodic events. This is straightforward and better
> + * it will be incremented by the number of pages. This counter is used to
> + * trigger some periodic events. This is straightforward and better
>    * than using jiffies etc. to handle periodic memcg event.
>    */
>   enum mem_cgroup_events_target {
> @@ -667,7 +667,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>    * Both of vmstat[] and percpu_counter has threshold and do periodic
>    * synchronization to implement "quick" read. There are trade-off between
>    * reading cost and precision of value. Then, we may have a chance to implement
> - * a periodic synchronizion of counter in memcg's counter.
> + * a periodic synchronization of counter in memcg's counter.
>    *
>    * But this _read() function is used for user interface now. The user accounts
>    * memory usage by memory cgroup and he _always_ requires exact value because
> @@ -677,7 +677,7 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>    *
>    * If there are kernel internal actions which can make use of some not-exact
>    * value, and reading all cpu value can be performance bottleneck in some
> - * common workload, threashold and synchonization as vmstat[] should be
> + * common workload, threshold and synchonization as vmstat[] should be

synchronization

>    * implemented.
>    */
>   static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
> @@ -1304,7 +1304,7 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>    *
>    * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
>    *			  under hierarchy of moving cgroups. This is for
> - *			  waiting at hith-memory prressure caused by "move".
> + *			  waiting at hit-memory pressure caused by "move".
>    */
>   
>   static bool mem_cgroup_stolen(struct mem_cgroup *memcg)
> @@ -1597,7 +1597,7 @@ int mem_cgroup_select_victim_node(struct mem_cgroup *memcg)
>   /*
>    * Check all nodes whether it contains reclaimable pages or not.
>    * For quick scan, we make use of scan_nodes. This will allow us to skip
> - * unused nodes. But scan_nodes is lazily updated and may not cotain
> + * unused nodes. But scan_nodes is lazily updated and may not contain
>    * enough new information. We need to do double check.
>    */
>   static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
> @@ -2211,7 +2211,6 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   	if (mem_cgroup_wait_acct_move(mem_over_limit))
>   		return CHARGE_RETRY;
>   
> -	/* If we don't need to call oom-killer at el, return immediately */
>   	if (!oom_check)
>   		return CHARGE_NOMEM;
>   	/* check OOM */
> @@ -2289,7 +2288,7 @@ again:
>   		 * In that case, "memcg" can point to root or p can be NULL with
>   		 * race with swapoff. Then, we have small risk of mis-accouning.
accounting 

Could you update ?

Thanks,
-Kame

(*) In my experience, too rapid update doesn't work well, maintainers cannot review it.
