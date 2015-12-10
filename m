From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] mm: memcontrol: separate kmem code from legacy tcp
 accounting code
Date: Thu, 10 Dec 2015 13:59:11 +0100
Message-ID: <20151210125911.GK19496@dhcp22.suse.cz>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-6-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449599665-18047-6-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 08-12-15 13:34:22, Johannes Weiner wrote:
> The cgroup2 memory controller will include important in-kernel memory
> consumers per default, including socket memory, but it will no longer
> carry the historic tcp control interface.
> 
> Separate the kmem state init from the tcp control interface init in
> preparation for that.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 33 ++++++++++++---------------------
>  1 file changed, 12 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5118618..55a3f07 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2925,17 +2925,6 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
>  	return ret;
>  }
>  
> -static int memcg_init_kmem(struct mem_cgroup *memcg)
> -{
> -	int ret;
> -
> -	ret = memcg_propagate_kmem(memcg);
> -	if (ret)
> -		return ret;
> -
> -	return tcp_init_cgroup(memcg);
> -}
> -
>  static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  {
>  	struct cgroup_subsys_state *css;
> @@ -2988,7 +2977,6 @@ static void memcg_free_kmem(struct mem_cgroup *memcg)
>  		static_branch_dec(&memcg_kmem_enabled_key);
>  		WARN_ON(page_counter_read(&memcg->kmem));
>  	}
> -	tcp_destroy_cgroup(memcg);
>  }
>  #else
>  static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
> @@ -2996,16 +2984,9 @@ static int memcg_update_kmem_limit(struct mem_cgroup *memcg,
>  {
>  	return -EINVAL;
>  }
> -static int memcg_init_kmem(struct mem_cgroup *memcg)
> -{
> -	return 0;
> -}
>  static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  {
>  }
> -static void memcg_free_kmem(struct mem_cgroup *memcg)
> -{
> -}
>  #endif /* CONFIG_MEMCG_KMEM */
>  
>  /*
> @@ -4241,9 +4222,14 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	}
>  	mutex_unlock(&memcg_create_mutex);
>  
> -	ret = memcg_init_kmem(memcg);
> +#ifdef CONFIG_MEMCG_KMEM
> +	ret = memcg_propagate_kmem(memcg);
>  	if (ret)
>  		return ret;
> +	ret = tcp_init_cgroup(memcg);
> +	if (ret)
> +		return ret;
> +#endif
>  
>  #ifdef CONFIG_INET
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
> @@ -4288,11 +4274,16 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
> -	memcg_free_kmem(memcg);
>  #ifdef CONFIG_INET
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
>  		static_branch_dec(&memcg_sockets_enabled_key);
>  #endif
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +	memcg_free_kmem(memcg);
> +	tcp_destroy_cgroup(memcg);
> +#endif
> +
>  	__mem_cgroup_free(memcg);
>  }
>  
> -- 
> 2.6.3

-- 
Michal Hocko
SUSE Labs
