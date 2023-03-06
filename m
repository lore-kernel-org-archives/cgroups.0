From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2, 2/4] mm, memcg: Prevent memory.swappiness load/store
 tearing
Date: Mon, 6 Mar 2023 18:50:15 +0100
Message-ID: <ZAYn19jFPO9KR2Si@dhcp22.suse.cz>
References: <20230306154138.3775-1-findns94@gmail.com>
 <20230306154138.3775-3-findns94@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678125016; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w38yPDPoNW7meWXht3zLss0FQ6ef9zy/ciQDyUVGN8Q=;
        b=bvUIaVCPQdKJVm5AsdMuBwe3iqky2mqSyazjiFZKsfUjRKx3lcIfadlu/zbSPmqq25EUXQ
        rEOgyXUrfZPMgNfc5n+XOlJnyT5TUnZDngf0I6qEiec/hMnlgm8vpOBzTkTH3I3jncpx9q
        wlXWHFKSDWz9XoyG9bxJqkkRC9LjseE=
Content-Disposition: inline
In-Reply-To: <20230306154138.3775-3-findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tangyeechou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon 06-03-23 23:41:36, Yue Zhao wrote:
> The knob for cgroup v1 memory controller: memory.swappiness
> is not protected by any locking so it can be modified while it is used.
> This is not an actual problem because races are unlikely.
> But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
> doing anything funky.
> 
> The access of memcg->swappiness and vm_swappiness is lockless,
> so both of them can be concurrently set at the same time
> as we are trying to read them. 
> 
> Signed-off-by: Yue Zhao <findns94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Thanks!

> ---
>  include/linux/swap.h | 8 ++++----
>  mm/memcontrol.c      | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 209a425739a9..3f3fe43d1766 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -620,18 +620,18 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
>  {
>  	/* Cgroup2 doesn't have per-cgroup swappiness */
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> -		return vm_swappiness;
> +		return READ_ONCE(vm_swappiness);
>  
>  	/* root ? */
>  	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> -		return vm_swappiness;
> +		return READ_ONCE(vm_swappiness);
>  
> -	return memcg->swappiness;
> +	return READ_ONCE(memcg->swappiness);
>  }
>  #else
>  static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
>  {
> -	return vm_swappiness;
> +	return READ_ONCE(vm_swappiness);
>  }
>  #endif
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 06821e5f7604..dca895c66a9b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4179,9 +4179,9 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
>  		return -EINVAL;
>  
>  	if (!mem_cgroup_is_root(memcg))
> -		memcg->swappiness = val;
> +		WRITE_ONCE(memcg->swappiness, val);
>  	else
> -		vm_swappiness = val;
> +		WRITE_ONCE(vm_swappiness, val);
>  
>  	return 0;
>  }
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs
