From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC][PATCH 6/7] memcg: don't need to get a reference to the
 parent
Date: Thu, 4 Apr 2013 17:34:25 +0200
Message-ID: <20130404153425.GN29911@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
 <515BF2B1.9060909@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515BF2B1.9060909-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 03-04-13 17:13:21, Li Zefan wrote:
> The cgroup core guarantees it's always safe to access the parent.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

I would just prefer if you put a comment into place where we used to
take a reference to parent so that it is more obvious in the code.
See bellow.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ad576e8..45129cd 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6124,12 +6124,8 @@ static void mem_cgroup_get(struct mem_cgroup *memcg)
>  
>  static void __mem_cgroup_put(struct mem_cgroup *memcg, int count)
>  {
> -	if (atomic_sub_and_test(count, &memcg->refcnt)) {
> -		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
> +	if (atomic_sub_and_test(count, &memcg->refcnt))
>  		call_rcu(&memcg->rcu_freeing, free_rcu);
> -		if (parent)
> -			mem_cgroup_put(parent);
> -	}
>  }
>  
>  static void mem_cgroup_put(struct mem_cgroup *memcg)
> @@ -6229,14 +6225,6 @@ mem_cgroup_css_online(struct cgroup *cont)
>  		res_counter_init(&memcg->res, &parent->res);
>  		res_counter_init(&memcg->memsw, &parent->memsw);
>  		res_counter_init(&memcg->kmem, &parent->kmem);
> -
> -		/*
> -		 * We increment refcnt of the parent to ensure that we can
> -		 * safely access it on res_counter_charge/uncharge.
> -		 * This refcnt will be decremented when freeing this
> -		 * mem_cgroup(see mem_cgroup_put).
> -		 */
> -		mem_cgroup_get(parent);

Maybe a little note would be nice
		/*
		 * No need to take reference to parent because cgroup
		 * core guarantees its existence
		 */
>  	} else {
>  		res_counter_init(&memcg->res, NULL);
>  		res_counter_init(&memcg->memsw, NULL);
> -- 
> 1.8.0.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
