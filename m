From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] memcg: refactor mem_cgroup_resize_limit()
Date: Tue, 13 Jun 2017 13:35:45 +0200
Message-ID: <20170613113545.GH10819@dhcp22.suse.cz>
References: <20170601230212.30578-1-yuzhao@google.com>
 <20170604211807.32685-1-yuzhao@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170604211807.32685-1-yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, n.borisov.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

[Sorry for a late reponse]

On Sun 04-06-17 14:18:07, Yu Zhao wrote:
> mem_cgroup_resize_limit() and mem_cgroup_resize_memsw_limit() have
> identical logics. Refactor code so we don't need to keep two pieces
> of code that does same thing.
> 
> Signed-off-by: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

It is nice to see removal of the code duplication. I have one comment
though

[...]

> @@ -2498,22 +2449,24 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		}
>  
>  		mutex_lock(&memcg_limit_mutex);
> -		if (limit < memcg->memory.limit) {
> +		inverted = memsw ? limit < memcg->memory.limit :
> +				   limit > memcg->memsw.limit;
> +		if (inverted) {
>  			mutex_unlock(&memcg_limit_mutex);
>  			ret = -EINVAL;
>  			break;
>  		}

This is just too ugly and hard to understand. inverted just doesn't give
you a good clue what is going on. What do you think about something like

		/*
		 * Make sure that the new limit (memsw or hard limit) doesn't
		 * break our basic invariant that memory.limit <= memsw.limit
		 */
		limits_invariant = memsw ? limit >= memcg->memory.limit :
					limit <= mmecg->memsw.limit;
		if (!limits_invariant) {
			mutex_unlock(&memcg_limit_mutex);
			ret = -EINVAL;
			break;
		}

with that feel free to add
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
-- 
Michal Hocko
SUSE Labs
