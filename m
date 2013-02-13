From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix kmemcg registration for late caches
Date: Wed, 13 Feb 2013 19:00:02 +0900
Message-ID: <511B6422.8030408@jp.fujitsu.com>
References: <1360600797-27793-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360600797-27793-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

(2013/02/12 1:39), Glauber Costa wrote:
> The designed workflow for the caches in kmemcg is: register it with
> memcg_register_cache() if kmemcg is already available or later on when a
> new kmemcg appears at memcg_update_cache_sizes() which will handle all
> caches in the system. The caches created at boot time will be handled by
> the later, and the memcg-caches as well as any system caches that are
> registered later on by the former.
> 
> There is a bug, however, in memcg_register_cache: we correctly set up
> the array size, but do not mark the cache as a root cache. This means
> that allocations for any cache appearing late in the game will see
> memcg->memcg_params->is_root_cache == false, and in particular, trigger
> VM_BUG_ON(!cachep->memcg_params->is_root_cache) in
> __memcg_kmem_cache_get.
> 
> The obvious fix is to include the missing assignment.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

> ---
>   mm/memcontrol.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 03ebf68..d4e83d0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3147,7 +3147,9 @@ int memcg_register_cache(struct mem_cgroup *memcg, struct kmem_cache *s,
>   	if (memcg) {
>   		s->memcg_params->memcg = memcg;
>   		s->memcg_params->root_cache = root_cache;
> -	}
> +	} else
> +		s->memcg_params->is_root_cache = true;
> +
>   	return 0;
>   }
>   
> 

