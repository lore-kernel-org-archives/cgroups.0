From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v2 5/5] memcg: do not walk all the way to the root for
 memcg
Date: Wed, 06 Mar 2013 10:08:11 +0900
Message-ID: <513696FB.9080705@jp.fujitsu.com>
References: <1362489058-3455-1-git-send-email-glommer@parallels.com> <1362489058-3455-6-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362489058-3455-6-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

(2013/03/05 22:10), Glauber Costa wrote:
> Since the root is special anyway, and we always get its figures from
> global counters anyway, there is no make all cgroups its descendants,
> wrt res_counters. The sad effect of doing that is that we need to lock
> the root for all allocations, since it is a common ancestor of
> everybody.
> 
> Not having the root as a common ancestor should lead to better
> scalability for not-uncommon case of tasks in the cgroup being
> node-bound to different nodes in NUMA systems.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

> ---
>   mm/memcontrol.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6019a32..252dc00 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6464,7 +6464,7 @@ mem_cgroup_css_online(struct cgroup *cont)
>   	memcg->oom_kill_disable = parent->oom_kill_disable;
>   	memcg->swappiness = mem_cgroup_swappiness(parent);
>   
> -	if (parent->use_hierarchy) {
> +	if (parent && !mem_cgroup_is_root(parent) && parent->use_hierarchy) {
>   		res_counter_init(&memcg->res, &parent->res);
>   		res_counter_init(&memcg->memsw, &parent->memsw);
>   		res_counter_init(&memcg->kmem, &parent->kmem);
> 

