From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4 05/25] memcg: Always free struct memcg through schedule_work()
Date: Mon, 18 Jun 2012 21:07:41 +0900
Message-ID: <4FDF1A0D.6080204@jp.fujitsu.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340015298-14133-6-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

(2012/06/18 19:27), Glauber Costa wrote:
> Right now we free struct memcg with kfree right after a
> rcu grace period, but defer it if we need to use vfree() to get
> rid of that memory area. We do that by need, because we need vfree
> to be called in a process context.
> 
> This patch unifies this behavior, by ensuring that even kfree will
> happen in a separate thread. The goal is to have a stable place to
> call the upcoming jump label destruction function outside the realm
> of the complicated and quite far-reaching cgroup lock (that can't be
> held when calling neither the cpu_hotplug.lock nor the jump_label_mutex)
> 
> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Tejun Heo<tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Li Zefan<lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> CC: Kamezawa Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>

How about cut out this patch and merge first as simple cleanu up and
to reduce patch stack on your side ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

> ---
>   mm/memcontrol.c |   24 +++++++++++++-----------
>   1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e3b528e..ce15be4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -245,8 +245,8 @@ struct mem_cgroup {
>   		 */
>   		struct rcu_head rcu_freeing;
>   		/*
> -		 * But when using vfree(), that cannot be done at
> -		 * interrupt time, so we must then queue the work.
> +		 * We also need some space for a worker in deferred freeing.
> +		 * By the time we call it, rcu_freeing is not longer in use.
>   		 */
>   		struct work_struct work_freeing;
>   	};
> @@ -4826,23 +4826,28 @@ out_free:
>   }
> 
>   /*
> - * Helpers for freeing a vzalloc()ed mem_cgroup by RCU,
> + * Helpers for freeing a kmalloc()ed/vzalloc()ed mem_cgroup by RCU,
>    * but in process context.  The work_freeing structure is overlaid
>    * on the rcu_freeing structure, which itself is overlaid on memsw.
>    */
> -static void vfree_work(struct work_struct *work)
> +static void free_work(struct work_struct *work)
>   {
>   	struct mem_cgroup *memcg;
> +	int size = sizeof(struct mem_cgroup);
> 
>   	memcg = container_of(work, struct mem_cgroup, work_freeing);
> -	vfree(memcg);
> +	if (size<  PAGE_SIZE)
> +		kfree(memcg);
> +	else
> +		vfree(memcg);
>   }
> -static void vfree_rcu(struct rcu_head *rcu_head)
> +
> +static void free_rcu(struct rcu_head *rcu_head)
>   {
>   	struct mem_cgroup *memcg;
> 
>   	memcg = container_of(rcu_head, struct mem_cgroup, rcu_freeing);
> -	INIT_WORK(&memcg->work_freeing, vfree_work);
> +	INIT_WORK(&memcg->work_freeing, free_work);
>   	schedule_work(&memcg->work_freeing);
>   }
> 
> @@ -4868,10 +4873,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
>   		free_mem_cgroup_per_zone_info(memcg, node);
> 
>   	free_percpu(memcg->stat);
> -	if (sizeof(struct mem_cgroup)<  PAGE_SIZE)
> -		kfree_rcu(memcg, rcu_freeing);
> -	else
> -		call_rcu(&memcg->rcu_freeing, vfree_rcu);
> +	call_rcu(&memcg->rcu_freeing, free_rcu);
>   }
> 
>   static void mem_cgroup_get(struct mem_cgroup *memcg)

