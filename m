From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: use per-cpu stocks for socket memory
 uncharging
Date: Wed, 30 Aug 2017 14:36:55 +0200
Message-ID: <20170830123655.6kce7yfkrhrhwubu@dhcp22.suse.cz>
References: <20170829100150.4580-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170829100150.4580-1-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 29-08-17 11:01:50, Roman Gushchin wrote:
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b9cf3cf4a3d0..a69d23082abf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1792,6 +1792,9 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  	}
>  	stock->nr_pages += nr_pages;
>  
> +	if (stock->nr_pages > CHARGE_BATCH)
> +		drain_stock(stock);
> +
>  	local_irq_restore(flags);
>  }

Why do we need this? In other words, why cannot we rely on draining we
already do?

>  
> @@ -5886,8 +5889,7 @@ void mem_cgroup_uncharge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  	this_cpu_sub(memcg->stat->count[MEMCG_SOCK], nr_pages);
>  
> -	page_counter_uncharge(&memcg->memory, nr_pages);
> -	css_put_many(&memcg->css, nr_pages);
> +	refill_stock(memcg, nr_pages);
>  }

This makes sense to me.
-- 
Michal Hocko
SUSE Labs
