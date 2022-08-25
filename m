From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Date: Thu, 25 Aug 2022 08:43:46 +0200
Message-ID: <YwcaIlJUtaYB7cKI@dhcp22.suse.cz>
References: <20220825000506.239406-1-shakeelb@google.com>
 <20220825000506.239406-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661409827; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Qj/G2DClTBDyDxLgwNY63LBJXmgLPhCgE3PiOW9WEs=;
        b=pkOPSm7KZh7KiGtgBVxVig947gAUgLX0C96Gk0/bANJ02johnIDhHEuQe1pL0Ib271ELms
        reO9MbRbZCMLkrpO2rT2xDlx/qU4ieZZfpALWCZY4NgAnw3/JYSRHnJSbr8pYoxulznjLs
        f/m5yaMC6GaXOc1rCK9PXVNnuUvfWqo=
Content-Disposition: inline
In-Reply-To: <20220825000506.239406-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 25-08-22 00:05:04, Shakeel Butt wrote:
> For cgroups using low or min protections, the function
> propagate_protected_usage() was doing an atomic xchg() operation
> irrespectively. We can optimize out this atomic operation for one
> specific scenario where the workload is using the protection (i.e.
> min > 0) and the usage is above the protection (i.e. usage > min).
> 
> This scenario is actually very common where the users want a part of
> their workload to be protected against the external reclaim. Though this
> optimization does introduce a race when the usage is around the
> protection and concurrent charges and uncharged trip it over or under
> the protection. In such cases, we might see lower effective protection
> but the subsequent charge/uncharge will correct it.

Thanks this is much more useful

> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately to see if this optimization
> is effective for the mentioned case.
> 
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> 
> Results (average throughput of netperf):
> Without (6.0-rc1)	10482.7 Mbps
> With patch		14542.5 Mbps (38.7% improvement)
> 
> With the patch, the throughput improved by 38.7%
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Acked-by: Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
> Changes since v1:
> - Commit message update with more detail on which scenario is getting
>   optimized and possible race condition.
> 
>  mm/page_counter.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index eb156ff5d603..47711aa28161 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
>  				      unsigned long usage)
>  {
>  	unsigned long protected, old_protected;
> -	unsigned long low, min;
>  	long delta;
>  
>  	if (!c->parent)
>  		return;
>  
> -	min = READ_ONCE(c->min);
> -	if (min || atomic_long_read(&c->min_usage)) {
> -		protected = min(usage, min);
> +	protected = min(usage, READ_ONCE(c->min));
> +	old_protected = atomic_long_read(&c->min_usage);
> +	if (protected != old_protected) {
>  		old_protected = atomic_long_xchg(&c->min_usage, protected);
>  		delta = protected - old_protected;
>  		if (delta)
>  			atomic_long_add(delta, &c->parent->children_min_usage);
>  	}
>  
> -	low = READ_ONCE(c->low);
> -	if (low || atomic_long_read(&c->low_usage)) {
> -		protected = min(usage, low);
> +	protected = min(usage, READ_ONCE(c->low));
> +	old_protected = atomic_long_read(&c->low_usage);
> +	if (protected != old_protected) {
>  		old_protected = atomic_long_xchg(&c->low_usage, protected);
>  		delta = protected - old_protected;
>  		if (delta)
> -- 
> 2.37.1.595.g718a3a8f04-goog

-- 
Michal Hocko
SUSE Labs
