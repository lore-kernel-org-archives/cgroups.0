From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 1/5] memcg: make nocpu_base available for non hotplug
Date: Wed, 06 Mar 2013 09:04:52 +0900
Message-ID: <51368824.7050601@jp.fujitsu.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com> <1362489058-3455-2-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362489058-3455-2-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2013/03/05 22:10), Glauber Costa wrote:
> We are using nocpu_base to accumulate charges on the main counters
> during cpu hotplug. I have a similar need, which is transferring charges
> to the root cgroup when lazily enabling memcg. Because system wide
> information is not kept per-cpu, it is hard to distribute it. This field
> works well for this. So we need to make it available for all usages, not
> only hotplug cases.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hmm..comments on nocpu_base definition will be updated in later patch ?

> ---
>   mm/memcontrol.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 669d16a..b8b363f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -921,11 +921,11 @@ static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
>   	get_online_cpus();
>   	for_each_online_cpu(cpu)
>   		val += per_cpu(memcg->stat->count[idx], cpu);
> -#ifdef CONFIG_HOTPLUG_CPU
> +
>   	spin_lock(&memcg->pcp_counter_lock);
>   	val += memcg->nocpu_base.count[idx];
>   	spin_unlock(&memcg->pcp_counter_lock);
> -#endif
> +
>   	put_online_cpus();
>   	return val;
>   }
> @@ -945,11 +945,11 @@ static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
>   
>   	for_each_online_cpu(cpu)
>   		val += per_cpu(memcg->stat->events[idx], cpu);
> -#ifdef CONFIG_HOTPLUG_CPU
> +
>   	spin_lock(&memcg->pcp_counter_lock);
>   	val += memcg->nocpu_base.events[idx];
>   	spin_unlock(&memcg->pcp_counter_lock);
> -#endif
> +
>   	return val;
>   }
>   
> 

