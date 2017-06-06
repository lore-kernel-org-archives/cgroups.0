From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: exclude @root from checks in
 mem_cgroup_low
Date: Tue, 6 Jun 2017 12:29:41 +0200
Message-ID: <20170606102941.GI1189@dhcp22.suse.cz>
References: <1496434412-21005-1-git-send-email-sean.j.christopherson@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496434412-21005-1-git-send-email-sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 02-06-17 13:13:32, Sean Christopherson wrote:
> Make @root exclusive in mem_cgroup_low; it is never considered low
> when looked at directly and is not checked when traversing the tree.
> In effect, @root is handled identically to how root_mem_cgroup was
> previously handled by mem_cgroup_low.
> 
> If @root is not excluded from the checks, a cgroup underneath @root
> will never be considered low during targeted reclaim of @root, e.g.
> due to memory.current > memory.high, unless @root is misconfigured
> to have memory.low > memory.high.
> 
> Excluding @root enables using memory.low to prioritize memory usage
> between cgroups within a subtree of the hierarchy that is limited by
> memory.high or memory.max, e.g. when ROOT owns @root's controls but
> delegates the @root directory to a USER so that USER can create and
> administer children of @root.
> 
> For example, given cgroup A with children B and C:
> 
>     A
>    / \
>   B   C
> 
> and
> 
>   1. A/memory.current > A/memory.high
>   2. A/B/memory.current < A/B/memory.low
>   3. A/C/memory.current >= A/C/memory.low
> 
> As 'A' is high, i.e. triggers reclaim from 'A', and 'B' is low, we
> should reclaim from 'C' until 'A' is no longer high or until we can
> no longer reclaim from 'C'.  If 'A', i.e. @root, isn't excluded by
> mem_cgroup_low when reclaming from 'A', then 'B' won't be considered
> low and we will reclaim indiscriminately from both 'B' and 'C'.
 
Fixes: 241994ed8649 (mm: memcontrol: default hierarchy interface for memory)
and Cc: stable seems to be appropriate because the low limit protection
is simply broken for the usecase you have pointed out.

> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> ---
>  mm/memcontrol.c | 50 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 13998ab..690b7dc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5314,38 +5314,52 @@ struct cgroup_subsys memory_cgrp_subsys = {
>  
>  /**
>   * mem_cgroup_low - check if memory consumption is below the normal range
> - * @root: the highest ancestor to consider
> + * @root: the top ancestor of the sub-tree being checked
>   * @memcg: the memory cgroup to check
>   *
>   * Returns %true if memory consumption of @memcg, and that of all
> - * configurable ancestors up to @root, is below the normal range.
> + * ancestors up to (but not including) @root, is below the normal range.
> + *
> + * @root is exclusive; it is never low when looked at directly and isn't
> + * checked when traversing the hierarchy.
> + *
> + * Excluding @root enables using memory.low to prioritize memory usage
> + * between cgroups within a subtree of the hierarchy that is limited by
> + * memory.high or memory.max.
> + *
> + * For example, given cgroup A with children B and C:
> + *
> + *    A
> + *   / \
> + *  B   C
> + *
> + * and
> + *
> + *  1. A/memory.current > A/memory.high
> + *  2. A/B/memory.current < A/B/memory.low
> + *  3. A/C/memory.current >= A/C/memory.low
> + *
> + * As 'A' is high, i.e. triggers reclaim from 'A', and 'B' is low, we
> + * should reclaim from 'C' until 'A' is no longer high or until we can
> + * no longer reclaim from 'C'.  If 'A', i.e. @root, isn't excluded by
> + * mem_cgroup_low when reclaming from 'A', then 'B' won't be considered
> + * low and we will reclaim indiscriminately from both 'B' and 'C'.
>   */
>  bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
>  {
>  	if (mem_cgroup_disabled())
>  		return false;
>  
> -	/*
> -	 * The toplevel group doesn't have a configurable range, so
> -	 * it's never low when looked at directly, and it is not
> -	 * considered an ancestor when assessing the hierarchy.
> -	 */
> -
> -	if (memcg == root_mem_cgroup)
> -		return false;
> -
> -	if (page_counter_read(&memcg->memory) >= memcg->low)
> +	if (!root)
> +		root = root_mem_cgroup;
> +	if (memcg == root)
>  		return false;
>  
> -	while (memcg != root) {
> -		memcg = parent_mem_cgroup(memcg);
> -
> -		if (memcg == root_mem_cgroup)
> -			break;
> -
> +	for (; memcg != root; memcg = parent_mem_cgroup(memcg)) {
>  		if (page_counter_read(&memcg->memory) >= memcg->low)
>  			return false;
>  	}
> +
>  	return true;
>  }
>  
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
