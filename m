From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: css_tryget_online cleanups
Date: Fri, 21 Feb 2020 17:10:46 -0800
Message-ID: <20200222011046.GB459391@carbon.DHCP.thefacebook.com>
References: <20200221195919.186576-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4eRmRnp8FS/CmnrSgyAD67jo6cjwwDO++cBE1P7DmxM=;
 b=o4SdbUDqPIaD6GzoXkPdGKWwnVuksrXzhxAEMMFS3u1TWsDLStzcVHfbUwRHfn3eRJ2I
 J8tMN99MM6pljb99mxMKHvuNMWYUZz7CSrltsGTjgcXPv5rRxC6c8jtSbEmI73nO17ee
 OgZrznzcgVW1HMWLJeqt90cKuZrgm/5WjuA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eRmRnp8FS/CmnrSgyAD67jo6cjwwDO++cBE1P7DmxM=;
 b=XadzIhL8iY2j71gL4NM4uf0RbghdM/tzr9pkkJwdhmUqUXJolVxsAUmXT8F+CvCbKONI5bNGA+c8i2flXvyjKxjA7x5965sGgKw+uuuJ36EUWYxwJi/jA5dP8nEgfkmsG5WfGK1n+YyC7d/bZtOQ1PwTHyqGTAbDfEFvokI9eGo=
Content-Disposition: inline
In-Reply-To: <20200221195919.186576-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 21, 2020 at 11:59:19AM -0800, Shakeel Butt wrote:
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
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Shakeel!

> ---
>  mm/memcontrol.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 63bb6a2aab81..75fa8123909e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -656,7 +656,7 @@ __mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
>  	 */
>  	__mem_cgroup_remove_exceeded(mz, mctz);
>  	if (!soft_limit_excess(mz->memcg) ||
> -	    !css_tryget_online(&mz->memcg->css))
> +	    !css_tryget(&mz->memcg->css))

Looks good.

>  		goto retry;
>  done:
>  	return mz;
> @@ -962,7 +962,8 @@ struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
>  		return NULL;
>  
>  	rcu_read_lock();
> -	if (!memcg || !css_tryget_online(&memcg->css))
> +	/* Page should not get uncharged and freed memcg under us. */
> +	if (!memcg || WARN_ON(!css_tryget(&memcg->css)))

I'm slightly worried about this WARN_ON().
As I understand the idea is that the caller must own the page and make
sure that page->memcg remains intact. Do we really need this?

Also, I'd go with WARN_ON_ONCE() to limit the dmesg flow in the case
if something will go wrong.

>  		memcg = root_mem_cgroup;
>  	rcu_read_unlock();
>  	return memcg;
> @@ -975,10 +976,13 @@ EXPORT_SYMBOL(get_mem_cgroup_from_page);
>  static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
>  {
>  	if (unlikely(current->active_memcg)) {
> -		struct mem_cgroup *memcg = root_mem_cgroup;
> +		struct mem_cgroup *memcg;
>  
>  		rcu_read_lock();
> -		if (css_tryget_online(&current->active_memcg->css))
> +		/* current->active_memcg must hold a ref. */

Hm, does it?
memalloc_use_memcg() isn't touching the memcg's reference counter.
And if it does hold a reference, why can't we just do css_get()?

> +		if (WARN_ON(!css_tryget(&current->active_memcg->css)))
> +			memcg = root_mem_cgroup;

Btw, if css_tryget() fails here, what does it mean?
I'd s/WARN_ON/WARN_ON_ONCE too.

> +		else
>  			memcg = current->active_memcg;
>  		rcu_read_unlock();
>  		return memcg;
> @@ -6703,7 +6707,7 @@ void mem_cgroup_sk_alloc(struct sock *sk)
>  		goto out;
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg->tcpmem_active)
>  		goto out;
> -	if (css_tryget_online(&memcg->css))
> +	if (css_tryget(&memcg->css))

So it can be offline, right? Makes sense.

>  		sk->sk_memcg = memcg;
>  out:
>  	rcu_read_unlock();
> -- 
> 2.25.0.265.gbab2e86ba0-goog
> 

Overall I have to admit it all is quite tricky. I had a patchset doing
a similar cleanup (but not only in the mm code), but dropped it after
Tejun showed me some edge cases, when it would cause a regression.

So I really think it's a valuable work, but we need to be careful here.

Thank you!
