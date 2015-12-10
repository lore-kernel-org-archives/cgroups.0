From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: memcontrol: account "kmem" consumers in cgroup2
 memory controller
Date: Thu, 10 Dec 2015 14:28:33 +0100
Message-ID: <20151210132833.GM19496@dhcp22.suse.cz>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-8-git-send-email-hannes@cmpxchg.org>
 <20151209113037.GS11488@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151209113037.GS11488@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed 09-12-15 14:30:38, Vladimir Davydov wrote:
> From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Subject: [PATCH] mm: memcontrol: allow to disable kmem accounting for cgroup2
> 
> Kmem accounting might incur overhead that some users can't put up with.
> Besides, the implementation is still considered unstable. So let's
> provide a way to disable it for those users who aren't happy with it.

Yes there will be users who do not want to pay an additional overhead
and still accoplish what they need.
I haven't measured the overhead lately - especially after the opt-out ->
opt-in change so it might be much lower than my previous ~5% for kbuild
load.
 
> To disable kmem accounting for cgroup2, pass cgroup.memory=nokmem at
> boot time.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index c1bda3bbb7db..1b7a85dc6013 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -602,6 +602,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  	cgroup.memory=	[KNL] Pass options to the cgroup memory controller.
>  			Format: <string>
>  			nosocket -- Disable socket memory accounting.
> +			nokmem -- Disable kernel memory accounting.
>  
>  	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6faea81e66d7..6a5572241dc6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -83,6 +83,9 @@ struct mem_cgroup *root_mem_cgroup __read_mostly;
>  /* Socket memory accounting disabled? */
>  static bool cgroup_memory_nosocket;
>  
> +/* Kernel memory accounting disabled? */
> +static bool cgroup_memory_nokmem;
> +
>  /* Whether the swap controller is active */
>  #ifdef CONFIG_MEMCG_SWAP
>  int do_swap_account __read_mostly;
> @@ -2898,8 +2901,8 @@ static int memcg_propagate_kmem(struct mem_cgroup *memcg)
>  	 * onlined after this point, because it has at least one child
>  	 * already.
>  	 */
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) ||
> -	    memcg_kmem_online(parent))
> +	if (memcg_kmem_online(parent) ||
> +	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nokmem))
>  		ret = memcg_online_kmem(memcg);
>  	mutex_unlock(&memcg_limit_mutex);
>  	return ret;
> @@ -5587,6 +5590,8 @@ static int __init cgroup_memory(char *s)
>  			continue;
>  		if (!strcmp(token, "nosocket"))
>  			cgroup_memory_nosocket = true;
> +		if (!strcmp(token, "nokmem"))
> +			cgroup_memory_nokmem = true;
>  	}
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
