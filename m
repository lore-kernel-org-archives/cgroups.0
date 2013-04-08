From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 7/8] memcg: don't use css_id any more
Date: Mon, 8 Apr 2013 17:01:47 +0200
Message-ID: <20130408150147.GO17178@dhcp22.suse.cz>
References: <51627DA9.7020507@huawei.com>
 <51627E74.5020300@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51627E74.5020300-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon 08-04-13 16:23:16, Li Zefan wrote:
> Now memcg uses cgroup->id instead of css_id. Update some comments and
> set mem_cgroup_subsys->use_id to 0.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 947dff1..26ee672 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -574,16 +574,11 @@ static void disarm_sock_keys(struct mem_cgroup *memcg)
>  #ifdef CONFIG_MEMCG_KMEM
>  /*
>   * This will be the memcg's index in each cache's ->memcg_params->memcg_caches.
> - * There are two main reasons for not using the css_id for this:
> - *  1) this works better in sparse environments, where we have a lot of memcgs,
> - *     but only a few kmem-limited. Or also, if we have, for instance, 200
> - *     memcgs, and none but the 200th is kmem-limited, we'd have to have a
> - *     200 entry array for that.
> - *
> - *  2) In order not to violate the cgroup API, we would like to do all memory
> - *     allocation in ->create(). At that point, we haven't yet allocated the
> - *     css_id. Having a separate index prevents us from messing with the cgroup
> - *     core for this
> + * The main reason for not using cgrp_id for this:
> + *  this works better in sparse environments, where we have a lot of memcgs,
> + *  but only a few kmem-limited. Or also, if we have, for instance, 200
> + *  memcgs, and none but the 200th is kmem-limited, we'd have to have a
> + *  200 entry array for that.
>   *
>   * The current size of the caches array is stored in
>   * memcg_limited_groups_array_size.  It will double each time we have to
> @@ -598,10 +593,10 @@ int memcg_limited_groups_array_size;
>   * cgroups is a reasonable guess. In the future, it could be a parameter or
>   * tunable, but that is strictly not necessary.
>   *
> - * MAX_SIZE should be as large as the number of css_ids. Ideally, we could get
> + * MAX_SIZE should be as large as the number of cgrp_ids. Ideally, we could get
>   * this constant directly from cgroup, but it is understandable that this is
>   * better kept as an internal representation in cgroup.c. In any case, the
> - * css_id space is not getting any smaller, and we don't have to necessarily
> + * cgrp_id space is not getting any smaller, and we don't have to necessarily
>   * increase ours as well if it increases.
>   */
>  #define MEMCG_CACHES_MIN_SIZE 4
> @@ -6065,7 +6060,6 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
>  	size_t size = memcg_size();
>  
>  	mem_cgroup_remove_from_trees(memcg);
> -	free_css_id(&mem_cgroup_subsys, &memcg->css);
>  
>  	for_each_node(node)
>  		free_mem_cgroup_per_zone_info(memcg, node);
> @@ -6846,7 +6840,6 @@ struct cgroup_subsys mem_cgroup_subsys = {
>  	.attach = mem_cgroup_move_task,
>  	.base_cftypes = mem_cgroup_files,
>  	.early_init = 0,
> -	.use_id = 1,
>  };
>  
>  #ifdef CONFIG_MEMCG_SWAP
> -- 
> 1.8.0.2
> 

-- 
Michal Hocko
SUSE Labs
