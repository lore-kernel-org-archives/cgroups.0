From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [RFC][PATCH 2/7] memcg: don't use mem_cgroup_get() when creating
 a kmemcg cache
Date: Fri, 05 Apr 2013 14:51:10 +0900
Message-ID: <515E664E.5060005@jp.fujitsu.com>
References: <515BF233.6070308@huawei.com> <515BF275.5080408@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515BF275.5080408-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

(2013/04/03 18:12), Li Zefan wrote:
> Use css_get()/css_put() instead of mem_cgroup_get()/mem_cgroup_put().
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 43ca91d..dafacb8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3191,7 +3191,7 @@ void memcg_release_cache(struct kmem_cache *s)
>   	list_del(&s->memcg_params->list);
>   	mutex_unlock(&memcg->slab_caches_mutex);
>   
> -	mem_cgroup_put(memcg);
> +	css_put(&memcg->css);
>   out:
>   	kfree(s->memcg_params);
>   }
> @@ -3350,16 +3350,18 @@ static struct kmem_cache *memcg_create_kmem_cache(struct mem_cgroup *memcg,
>   
>   	mutex_lock(&memcg_cache_mutex);
>   	new_cachep = cachep->memcg_params->memcg_caches[idx];
> -	if (new_cachep)
> +	if (new_cachep) {
> +		css_put(&memcg->css);
>   		goto out;
> +	}

Where css_get() against this is done ?

Thanks,
-Kame
