From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Tue, 4 Jun 2013 15:18:43 +0200
Message-ID: <20130604131843.GF31242@dhcp22.suse.cz>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370306679-13129-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon 03-06-13 17:44:39, Tejun Heo wrote:
[...]
> @@ -1267,7 +1226,20 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  			break;
>  
>  		iter->generation++;
> +		last_visited = NULL;
>  	}
> +
> +	/*
> +	 * Update @iter to the new position.  As multiple tasks could be
> +	 * executing this path, atomically swap the new and old.  We want
> +	 * RCU assignment here but there's no rcu_xchg() and the plain
> +	 * xchg() has enough memory barrier semantics.
> +	 */
> +	if (memcg)
> +		css_get(&memcg->css);

This is all good and nice but it re-introduces the same problem which
has been fixed by (5f578161: memcg: relax memcg iter caching). You are
pinning memcg in memory for unbounded amount of time because css
reference will not let object to leave and rest.

I understand your frustration about the complexity of the current
synchronization but we didn't come up with anything easier.
Originally I though that your tree walk updates which allow dropping rcu
would help here but then I realized that not really because the iterator
(resp. pos) has to be a valid pointer and there is only one possibility
to do that AFAICS here and that is css pinning. And is no-go.

> +	last_visited = xchg(&iter->last_visited, memcg);
> +	if (last_visited)
> +		css_put(&last_visited->css);
>  out_unlock:
>  	rcu_read_unlock();
>  out_css_put:
[...]
-- 
Michal Hocko
SUSE Labs
