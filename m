From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] memcg: allocate pages for swap cgroup until the
 first child memcg is alive
Date: Tue, 4 Dec 2012 13:54:45 +0100
Message-ID: <20121204125445.GC1343@dhcp22.suse.cz>
References: <50BDB5E0.7030906@oracle.com>
 <50BDB601.4090205@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50BDB601.4090205-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Tue 04-12-12 16:36:17, Jeff Liu wrote:
> - Call swap_cgroup_init() when the first child memcg was created.
> - Free pages from swap cgroup once the latest child memcg was removed.

This should be a separate patch

> - Teach swap_cgroup_record()/swap_cgroup_cmpxchg()/swap_cgroup_lookup_id()
>   to aware of the new static variable. i.e, swap_cgroup_initialized, so that
>   they would not perform further jobs if swap cgroup is not active.

This should be a preparatory patch.

> 
> Signed-off-by: Jie Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> CC: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> ---
>  mm/memcontrol.c  |    3 +++
>  mm/page_cgroup.c |    9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dd39ba0..1f14375 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4982,6 +4982,8 @@ mem_cgroup_create(struct cgroup *cont)
>  		}
>  		hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
>  	} else {
> +		if (swap_cgroup_init())
> +			goto free_out;
>  		parent = mem_cgroup_from_cont(cont->parent);
>  		memcg->use_hierarchy = parent->use_hierarchy;
>  		memcg->oom_kill_disable = parent->oom_kill_disable;
> @@ -5046,6 +5048,7 @@ static void mem_cgroup_destroy(struct cgroup *cont)
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
>  
>  	kmem_cgroup_destroy(memcg);
> +	swap_cgroup_destroy();
>  
>  	mem_cgroup_put(memcg);
>  }
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index f1b257b..63c6789 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -429,6 +429,9 @@ unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
>  	unsigned long flags;
>  	unsigned short retval;
>  
> +	if (!atomic_read(&swap_cgroup_initialized))
> +		return 0;
> +
>  	sc = lookup_swap_cgroup(ent, &ctrl);
>  
>  	spin_lock_irqsave(&ctrl->lock, flags);
> @@ -456,6 +459,9 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
>  	unsigned short old;
>  	unsigned long flags;
>  
> +	if (!atomic_read(&swap_cgroup_initialized))
> +		return 0;
> +
>  	sc = lookup_swap_cgroup(ent, &ctrl);
>  
>  	spin_lock_irqsave(&ctrl->lock, flags);
> @@ -474,6 +480,9 @@ unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
>   */
>  unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>  {
> +	if (!atomic_read(&swap_cgroup_initialized))
> +		return 0;
> +
>  	return lookup_swap_cgroup(ent, NULL)->id;

I think that the swap_cgroup_initialized test should be stuffed into
lookup_swap_cgroup because it would be less fragile.
-- 
Michal Hocko
SUSE Labs
