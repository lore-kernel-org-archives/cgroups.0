From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/7] mm: memcontrol: fix cpuhotplug statistics flushing
Date: Thu, 4 Feb 2021 14:28:52 +0100
Message-ID: <YBv2lAkaxcPD22dd@dhcp22.suse.cz>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612445333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TRSYMjQRAzEHtFevMwBdexoUuf46f9eJ8r1i3WMioDI=;
        b=GcyhMd8vU7FiMUrjfpReK3jejf2JcNNuC/9fOqe8iI3GUHpmlS3W1NeI89vJMlKOm5Jq6S
        fDZJH9tjinKCe3lpv0vatkQWG57RzHKmtJxoGv6c+0wPresT11A9qR5KACB3Al8NZ421tf
        /rv2Z0u8UcaKLgD2rl/LNbc/H8TKIKE=
Content-Disposition: inline
In-Reply-To: <20210202184746.119084-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 02-02-21 13:47:40, Johannes Weiner wrote:
> The memcg hotunplug callback erroneously flushes counts on the local
> CPU, not the counts of the CPU going away; those counts will be lost.
> 
> Flush the CPU that is actually going away.
> 
> Also simplify the code a bit by using mod_memcg_state() and
> count_memcg_events() instead of open-coding the upward flush - this is
> comparable to how vmstat.c handles hotunplug flushing.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Shakeel has already pointed out Fixes.

> ---
>  mm/memcontrol.c | 35 +++++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ed5cc78a8dbf..8120d565dd79 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2411,45 +2411,52 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
>  static int memcg_hotplug_cpu_dead(unsigned int cpu)
>  {
>  	struct memcg_stock_pcp *stock;
> -	struct mem_cgroup *memcg, *mi;
> +	struct mem_cgroup *memcg;
>  
>  	stock = &per_cpu(memcg_stock, cpu);
>  	drain_stock(stock);
>  
>  	for_each_mem_cgroup(memcg) {
> +		struct memcg_vmstats_percpu *statc;
>  		int i;
>  
> +		statc = per_cpu_ptr(memcg->vmstats_percpu, cpu);
> +
>  		for (i = 0; i < MEMCG_NR_STAT; i++) {
>  			int nid;
> -			long x;
>  
> -			x = this_cpu_xchg(memcg->vmstats_percpu->stat[i], 0);
> -			if (x)
> -				for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
> -					atomic_long_add(x, &memcg->vmstats[i]);
> +			if (statc->stat[i]) {
> +				mod_memcg_state(memcg, i, statc->stat[i]);
> +				statc->stat[i] = 0;
> +			}
>  
>  			if (i >= NR_VM_NODE_STAT_ITEMS)
>  				continue;
>  
>  			for_each_node(nid) {
> +				struct batched_lruvec_stat *lstatc;
>  				struct mem_cgroup_per_node *pn;
> +				long x;
>  
>  				pn = mem_cgroup_nodeinfo(memcg, nid);
> -				x = this_cpu_xchg(pn->lruvec_stat_cpu->count[i], 0);
> -				if (x)
> +				lstatc = per_cpu_ptr(pn->lruvec_stat_cpu, cpu);
> +
> +				x = lstatc->count[i];
> +				lstatc->count[i] = 0;
> +
> +				if (x) {
>  					do {
>  						atomic_long_add(x, &pn->lruvec_stat[i]);
>  					} while ((pn = parent_nodeinfo(pn, nid)));
> +				}
>  			}
>  		}
>  
>  		for (i = 0; i < NR_VM_EVENT_ITEMS; i++) {
> -			long x;
> -
> -			x = this_cpu_xchg(memcg->vmstats_percpu->events[i], 0);
> -			if (x)
> -				for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
> -					atomic_long_add(x, &memcg->vmevents[i]);
> +			if (statc->events[i]) {
> +				count_memcg_events(memcg, i, statc->events[i]);
> +				statc->events[i] = 0;
> +			}
>  		}
>  	}
>  
> -- 
> 2.30.0
> 

-- 
Michal Hocko
SUSE Labs
