From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: do not miss MEMCG_MAX events for
 enforced allocations
Date: Mon, 4 Jul 2022 17:12:54 +0200
Message-ID: <YsMDdjc5SXMAuV2l@dhcp22.suse.cz>
References: <20220702033521.64630-1-roman.gushchin@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656947575; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oVYS4bUOdNSsnRwjamBfXVxY7OYzKvz0dEnKnULT0m0=;
        b=vOdePtXjqkrtYTUiDZM/PSpsWTz3hI/lFsIqeA7Te+9fPmJnmkUo6UsDy3Lw8zQifjAOmj
        jGKhW6fCofSwiJadpjagD0gBDjoctYt6jNKPjCTcaeJaquJzE7jNXSpG/X6hpycqMcSAyZ
        RyYqM5I9fvWSREHqqKaoaAinKDszAvE=
Content-Disposition: inline
In-Reply-To: <20220702033521.64630-1-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 01-07-22 20:35:21, Roman Gushchin wrote:
> Yafang Shao reported an issue related to the accounting of bpf
> memory: if a bpf map is charged indirectly for memory consumed
> from an interrupt context and allocations are enforced, MEMCG_MAX
> events are not raised.

So I guess this will be a GFP_ATOMIC request failing due to the hard
limit, right? I think it would be easier to understand if the specific
allocation request type was mentioned.

> It's not/less of an issue in a generic case because consequent
> allocations from a process context will trigger the reclaim and
> MEMCG_MAX events. However a bpf map can belong to a dying/abandoned
> memory cgroup, so it might never happen. So the cgroup can
> significantly exceed the memory.max limit without even triggering
> MEMCG_MAX events.

More on that in other reply.

> Fix this by making sure that we never enforce allocations without
> raising a MEMCG_MAX event.
> 
> Reported-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The patch makes sense to me though even without the weird charge to a
dead memcg aspect. It is true that a very calm memcg can trigger the
even much later after a GFP_ATOMIC charge (or __GFP_HIGH in general)
fails.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 655c09393ad5..eb383695659a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2577,6 +2577,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool passed_oom = false;
>  	bool may_swap = true;
>  	bool drained = false;
> +	bool raised_max_event = false;
>  	unsigned long pflags;
>  
>  retry:
> @@ -2616,6 +2617,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		goto nomem;
>  
>  	memcg_memory_event(mem_over_limit, MEMCG_MAX);
> +	raised_max_event = true;
>  
>  	psi_memstall_enter(&pflags);
>  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> @@ -2682,6 +2684,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
>  		return -ENOMEM;
>  force:
> +	/*
> +	 * If the allocation has to be enforced, don't forget to raise
> +	 * a MEMCG_MAX event.
> +	 */
> +	if (!raised_max_event)
> +		memcg_memory_event(mem_over_limit, MEMCG_MAX);
> +
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
>  	 * being freed very soon.  Allow memory usage go over the limit
> -- 
> 2.36.1

-- 
Michal Hocko
SUSE Labs
