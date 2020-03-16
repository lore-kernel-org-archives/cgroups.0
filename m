From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] mm, memcg: Prevent memory.max load tearing
Date: Mon, 16 Mar 2020 15:56:30 +0100
Message-ID: <20200316145630.GN11482@dhcp22.suse.cz>
References: <cover.1584034301.git.chris@chrisdown.name>
 <50a31e5f39f8ae6c8fb73966ba1455f0924e8f44.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50a31e5f39f8ae6c8fb73966ba1455f0924e8f44.1584034301.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 12-03-20 17:32:56, Chris Down wrote:
> This one is a bit more nuanced because we have memcg_max_mutex, which is
> mostly just used for enforcing invariants, but we still need to
> READ_ONCE since (despite its name) it doesn't really protect memory.max
> access.
> 
> On write (page_counter_set_max() and memory_max_write()) we use xchg(),
> which uses smp_mb(), so that's already fine.
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
>  mm/memcontrol.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d32d3c0a16d4..aca2964ea494 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1507,7 +1507,7 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
>  
>  	pr_info("memory: usage %llukB, limit %llukB, failcnt %lu\n",
>  		K((u64)page_counter_read(&memcg->memory)),
> -		K((u64)memcg->memory.max), memcg->memory.failcnt);
> +		K((u64)READ_ONCE(memcg->memory.max)), memcg->memory.failcnt);
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		pr_info("swap: usage %llukB, limit %llukB, failcnt %lu\n",
>  			K((u64)page_counter_read(&memcg->swap)),
> @@ -1538,7 +1538,7 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>  {
>  	unsigned long max;
>  
> -	max = memcg->memory.max;
> +	max = READ_ONCE(memcg->memory.max);
>  	if (mem_cgroup_swappiness(memcg)) {
>  		unsigned long memsw_max;
>  		unsigned long swap_max;
> @@ -3006,7 +3006,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
>  		 * Make sure that the new limit (memsw or memory limit) doesn't
>  		 * break our basic invariant rule memory.max <= memsw.max.
>  		 */
> -		limits_invariant = memsw ? max >= memcg->memory.max :
> +		limits_invariant = memsw ? max >= READ_ONCE(memcg->memory.max) :
>  					   max <= memcg->memsw.max;
>  		if (!limits_invariant) {
>  			mutex_unlock(&memcg_max_mutex);
> @@ -3753,8 +3753,8 @@ static int memcg_stat_show(struct seq_file *m, void *v)
>  	/* Hierarchical information */
>  	memory = memsw = PAGE_COUNTER_MAX;
>  	for (mi = memcg; mi; mi = parent_mem_cgroup(mi)) {
> -		memory = min(memory, mi->memory.max);
> -		memsw = min(memsw, mi->memsw.max);
> +		memory = min(memory, READ_ONCE(mi->memory.max));
> +		memsw = min(memsw, READ_ONCE(mi->memsw.max));
>  	}
>  	seq_printf(m, "hierarchical_memory_limit %llu\n",
>  		   (u64)memory * PAGE_SIZE);
> @@ -4257,7 +4257,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
>  	*pheadroom = PAGE_COUNTER_MAX;
>  
>  	while ((parent = parent_mem_cgroup(memcg))) {
> -		unsigned long ceiling = min(memcg->memory.max,
> +		unsigned long ceiling = min(READ_ONCE(memcg->memory.max),
>  					    READ_ONCE(memcg->high));
>  		unsigned long used = page_counter_read(&memcg->memory);
>  
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs
