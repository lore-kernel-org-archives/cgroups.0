From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup racy sum avoidance code
Date: Mon, 2 Aug 2021 08:57:56 +0200
Message-ID: <YQeXdPV8cUNIOUB5@dhcp22.suse.cz>
References: <20210728012243.3369123-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627887479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tUbU3ZzRUqhVzk9x8OM8/LVLgiQh8b75TwEVEjI/pNU=;
        b=u9FnFt7I8zkmPHO6z9sNU8KK593faYfo5bs0tUNTJh16t19zT5bFXpimOXs3mueplDYVkw
        U5DyEemPVD3nA7/YaiJ3vdjc55ZZGbcA9LKNxBcuqOrkay0Qi9XsACNWIL8O3wU9HKL1UU
        RrRiqtqE9aWaxXTMGbj3wpsJj4eW0SM=
Content-Disposition: inline
In-Reply-To: <20210728012243.3369123-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 27-07-21 18:22:43, Shakeel Butt wrote:
> We used to have per-cpu memcg and lruvec stats and the readers have to
> traverse and sum the stats from each cpu. This summing was racy and may
> expose transient negative values. So, an explicit check was added to
> avoid such scenarios. Now these stats are moved to rstat infrastructure
> and are no more per-cpu, so we can remove the fixup for transient
> negative values.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/memcontrol.h | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7028d8e4a3d7..5f2a39a43d47 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -991,30 +991,19 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
>  
>  static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
>  {
> -	long x = READ_ONCE(memcg->vmstats.state[idx]);
> -#ifdef CONFIG_SMP
> -	if (x < 0)
> -		x = 0;
> -#endif
> -	return x;
> +	return READ_ONCE(memcg->vmstats.state[idx]);
>  }
>  
>  static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
>  					      enum node_stat_item idx)
>  {
>  	struct mem_cgroup_per_node *pn;
> -	long x;
>  
>  	if (mem_cgroup_disabled())
>  		return node_page_state(lruvec_pgdat(lruvec), idx);
>  
>  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	x = READ_ONCE(pn->lruvec_stats.state[idx]);
> -#ifdef CONFIG_SMP
> -	if (x < 0)
> -		x = 0;
> -#endif
> -	return x;
> +	return READ_ONCE(pn->lruvec_stats.state[idx]);
>  }
>  
>  static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> -- 
> 2.32.0.432.gabb21c7263-goog

-- 
Michal Hocko
SUSE Labs
