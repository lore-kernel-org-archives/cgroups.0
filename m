From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm/memcg: Simplify mem_cgroup_get_max()
Date: Thu, 20 Aug 2020 13:35:46 -0400
Message-ID: <20200820173546.GB912520@cmpxchg.org>
References: <20200820130350.3211-1-longman@redhat.com>
 <20200820130350.3211-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LoboofYleSqsx6Po76z6KtFKykk6O4/M/law9ADONhQ=;
        b=bqapqgbGxSqIpTZ9lqM1OdRQ4ld0i+GkD+9Nmxa1GUtaiBn/O9VbQypsMHolHj0z6R
         O5BVPWUTxs1lPqRKqLIHUGDCBJLiJ4iTA7HIC6qB9jSaJjvKbm8SI/1kvGieeG0doLWJ
         OCDi+LYKIfxOKRk0/y7qOPc8DpMwu+WU3vD+l8KIvb21LNwGFGLgzaQthypuZUWvs+rs
         oJCpu+HfrIXROzi0WhrBWx4WpDDfRvE0lUwTcbI+9/X0czS0xt7v14LrRI0jg5MRRTp/
         LBDfwgBeTz7UfF8zOvwgvyF3yu6ue4PzybmMEWhEHmy34YliUAVBRRucg//JTWS0mIdc
         WDfA==
Content-Disposition: inline
In-Reply-To: <20200820130350.3211-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Aug 20, 2020 at 09:03:49AM -0400, Waiman Long wrote:
> The mem_cgroup_get_max() function used to get memory+swap max from
> both the v1 memsw and v2 memory+swap page counters & return the maximum
> of these 2 values. This is redundant and it is more efficient to just
> get either the v1 or the v2 values depending on which one is currently
> in use.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 26b7a48d3afb..d219dca5239f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1633,17 +1633,13 @@ void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
>   */
>  unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>  {
> -	unsigned long max;
> +	unsigned long max = READ_ONCE(memcg->memory.max);
>  
> -	max = READ_ONCE(memcg->memory.max);
>  	if (mem_cgroup_swappiness(memcg)) {
> -		unsigned long memsw_max;
> -		unsigned long swap_max;
> -
> -		memsw_max = memcg->memsw.max;
> -		swap_max = READ_ONCE(memcg->swap.max);
> -		swap_max = min(swap_max, (unsigned long)total_swap_pages);
> -		max = min(max + swap_max, memsw_max);
> +		if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +			max += READ_ONCE(memcg->swap.max);
> +		else
> +			max = memcg->memsw.max;

I agree with the premise of the patch, but v1 and v2 have sufficiently
different logic, and the way v1 overrides max from the innermost
branch again also doesn't help in understanding what's going on.

Can you please split out the v1 and v2 code?

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
		max = READ_ONCE(memcg->memory.max);
		if (mem_cgroup_swappiness(memcg))
			max += READ_ONCE(memcg->swap.max);
	} else {
		if (mem_cgroup_swappiness(memcg))
			max = memcg->memsw.max;
		else
			max = READ_ONCE(memcg->memory.max);
	}

It's slightly repetitive, but IMO much more readable.
