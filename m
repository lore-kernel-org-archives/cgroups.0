From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: css_tryget_online cleanups
Date: Tue, 3 Mar 2020 10:32:51 +0100
Message-ID: <20200303093251.GD4380@dhcp22.suse.cz>
References: <20200302203109.179417-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200302203109.179417-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 02-03-20 12:31:09, Shakeel Butt wrote:
> Currently multiple locations in memcg code, css_tryget_online() is being
> used. However it doesn't matter whether the cgroup is online for the
> callers. Online used to matter when we had reparenting on offlining and
> we needed a way to prevent new ones from showing up.
> 
> The failure case for couple of these css_tryget_online usage is to
> fallback to root_mem_cgroup which kind of make bypassing the memcg
> limits possible for some workloads. For example creating an inotify
> group in a subcontainer and then deleting that container after moving the
> process to a different container will make all the event objects
> allocated for that group to the root_mem_cgroup. So, using
> css_tryget_online() is dangerous for such cases.
> 
> Two locations still use the online version. The swapin of offlined
> memcg's pages and the memcg kmem cache creation. The kmem cache indeed
> needs the online version as the kernel does the reparenting of memcg
> kmem caches. For the swapin case, it has been left for later as the
> fallback is not really that concerning.

Could you be more specific about the swap in case please?

> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Other than that nothing really jumped at me although I have to confess
that I am far from deeply familiar with the sk_buff charging path.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> ---
> 
> Changes since v1:
> - replaced WARN_ON with WARN_ON_ONCE
> 
>  mm/memcontrol.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 62b574d0cd3c..75d8883bf975 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -656,7 +656,7 @@ __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
>  	 */
>  	__mem_cgroup_remove_exceeded(mz, mctz);
>  	if (!soft_limit_excess(mz->memcg) ||
> -	    !css_tryget_online(&mz->memcg->css))
> +	    !css_tryget(&mz->memcg->css))
>  		goto retry;
>  done:
>  	return mz;
> @@ -961,7 +961,8 @@ struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
>  		return NULL;
>  
>  	rcu_read_lock();
> -	if (!memcg || !css_tryget_online(&memcg->css))
> +	/* Page should not get uncharged and freed memcg under us. */
> +	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
>  		memcg = root_mem_cgroup;
>  	rcu_read_unlock();
>  	return memcg;
> @@ -974,10 +975,13 @@ EXPORT_SYMBOL(get_mem_cgroup_from_page);
>  static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
>  {
>  	if (unlikely(current->active_memcg)) {
> -		struct mem_cgroup *memcg = root_mem_cgroup;
> +		struct mem_cgroup *memcg;
>  
>  		rcu_read_lock();
> -		if (css_tryget_online(&current->active_memcg->css))
> +		/* current->active_memcg must hold a ref. */
> +		if (WARN_ON_ONCE(!css_tryget(&current->active_memcg->css)))
> +			memcg = root_mem_cgroup;
> +		else
>  			memcg = current->active_memcg;
>  		rcu_read_unlock();
>  		return memcg;
> @@ -6732,7 +6736,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
>  		goto out;
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
>  		goto out;
> -	if (css_tryget_online(&memcg->css))
> +	if (css_tryget(&memcg->css))
>  		sk->sk_memcg = memcg;
>  out:
>  	rcu_read_unlock();
> -- 
> 2.25.0.265.gbab2e86ba0-goog

-- 
Michal Hocko
SUSE Labs
