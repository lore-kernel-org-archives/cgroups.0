From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch] mm, memcg: do not allow tasks to be attached with zero
 limit
Date: Thu, 8 Mar 2012 15:15:21 +0900
Message-ID: <20120308151521.82187123.kamezawa.hiroyu@jp.fujitsu.com>
References: <alpine.DEB.2.00.1203071914150.15244@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1203071914150.15244-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, 7 Mar 2012 19:14:49 -0800 (PST)
David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> This patch prevents tasks from being attached to a memcg if there is a
> hard limit of zero.  Additionally, the hard limit may not be changed to
> zero if there are tasks attached.
> 
> This is consistent with cpusets which do not allow tasks to be attached
> if there are no mems and prevents all mems from being removed if there
> are tasks attached.
> 
> Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I hope Documenation/cgroup/memory.txt should be updated and make this behavior as 'spec'.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>


> ---
>  mm/memcontrol.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3868,9 +3868,14 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
>  		ret = res_counter_memparse_write_strategy(buffer, &val);
>  		if (ret)
>  			break;
> -		if (type == _MEM)
> +		if (type == _MEM) {
> +			/* Don't allow zero limit with tasks attached */
> +			if (!val && cgroup_task_count(cont)) {
> +				ret = -ENOSPC;
> +				break;
> +			}
>  			ret = mem_cgroup_resize_limit(memcg, val);
> -		else
> +		} else
>  			ret = mem_cgroup_resize_memsw_limit(memcg, val);
>  		break;
>  	case RES_SOFT_LIMIT:
> @@ -5306,6 +5311,10 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
>  	int ret = 0;
>  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
>  
> +	/* Don't allow tasks attached with a zero limit */
> +	if (!res_counter_read_u64(&memcg->res, RES_LIMIT))
> +		return -ENOSPC;
> +
>  	if (memcg->move_charge_at_immigrate) {
>  		struct mm_struct *mm;
>  		struct mem_cgroup *from = mem_cgroup_from_task(p);
> 
