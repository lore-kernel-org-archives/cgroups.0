From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] mm, memcg: Prevent memory.swap.max load tearing
Date: Mon, 16 Mar 2020 15:58:59 +0100
Message-ID: <20200316145859.GQ11482@dhcp22.suse.cz>
References: <cover.1584034301.git.chris@chrisdown.name>
 <bbec2c3d822217334855c8877a9d28b2a6d395fb.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bbec2c3d822217334855c8877a9d28b2a6d395fb.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 12-03-20 17:33:11, Chris Down wrote:
> The write side of this is xchg()/smp_mb(), so that's all good. Just a
> few sites missing a READ_ONCE.
> 
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e0ed790a2a8c..57048a38c75d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1511,7 +1511,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
>  			K((u64)page_counter_read(&memcg->swap)),
> -			K((u64)memcg->swap.max), memcg->swap.failcnt);
> +			K((u64)READ_ONCE(memcg->swap.max)), memcg->swap.failcnt);
>  	else {
>  		pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %lu\n",
>  			K((u64)page_counter_read(&memcg->memsw)),
> @@ -1544,7 +1544,7 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>  		unsigned long swap_max;
>  
>  		memsw_max = memcg->memsw.max;
> -		swap_max = memcg->swap.max;
> +		swap_max = READ_ONCE(memcg->swap.max);
>  		swap_max = min(swap_max, (unsigned long)total_swap_pages);
>  		max = min(max + swap_max, memsw_max);
>  	}
> @@ -7025,7 +7025,8 @@ bool mem_cgroup_swap_full(struct page *page)
>  		return false;
>  
>  	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
> -		if (page_counter_read(&memcg->swap) * 2 >= memcg->swap.max)
> +		if (page_counter_read(&memcg->swap) * 2 >=
> +		    READ_ONCE(memcg->swap.max))
>  			return true;
>  
>  	return false;
> -- 
> 2.25.1
> 

-- 
Michal Hocko
SUSE Labs
