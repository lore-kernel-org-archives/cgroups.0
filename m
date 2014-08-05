From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: clean up reclaim size variable use in
 try_charge()
Date: Tue, 5 Aug 2014 14:26:36 +0200
Message-ID: <20140805122636.GE15908@dhcp22.suse.cz>
References: <1407184502-20818-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1407184502-20818-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 04-08-14 16:35:02, Johannes Weiner wrote:
> Charge reclaim and OOM currently use the charge batch variable, but
> batching is already disabled at that point.  To simplify the charge
> logic, the batch variable is reset to the original request size when
> reclaim is entered, so it's functionally equal, but it's misleading.
> 
> Switch reclaim/OOM to nr_pages, which is the original request size.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8d65dadeec1b..ec4dcf1b9562 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2574,7 +2574,7 @@ retry:
>  
>  	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
>  
> -	if (mem_cgroup_margin(mem_over_limit) >= batch)
> +	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
>  		goto retry;
>  
>  	if (gfp_mask & __GFP_NORETRY)
> @@ -2588,7 +2588,7 @@ retry:
>  	 * unlikely to succeed so close to the limit, and we fall back
>  	 * to regular pages anyway in case of failure.
>  	 */
> -	if (nr_reclaimed && batch <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> +	if (nr_reclaimed && nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER))
>  		goto retry;
>  	/*
>  	 * At task move, charge accounts can be doubly counted. So, it's
> @@ -2606,7 +2606,7 @@ retry:
>  	if (fatal_signal_pending(current))
>  		goto bypass;
>  
> -	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
> +	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(nr_pages));
>  nomem:
>  	if (!(gfp_mask & __GFP_NOFAIL))
>  		return -ENOMEM;
> -- 
> 2.0.3
> 

-- 
Michal Hocko
SUSE Labs
