From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 04/10] mm: memcontrol: reclaim at least once for
 __GFP_NORETRY
Date: Tue, 3 Jun 2014 15:16:35 +0200
Message-ID: <20140603131635.GH1321@dhcp22.suse.cz>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
 <1401380162-24121-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1401380162-24121-5-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 29-05-14 12:15:56, Johannes Weiner wrote:
> Currently, __GFP_NORETRY tries charging once and gives up before even
> trying to reclaim.  Bring the behavior on par with the page allocator
> and reclaim at least once before giving up.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e8d5075c081f..8957d6c945b8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2614,13 +2614,13 @@ retry:
>  	if (!(gfp_mask & __GFP_WAIT))
>  		goto nomem;
>  
> -	if (gfp_mask & __GFP_NORETRY)
> -		goto nomem;
> -
>  	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
>  
>  	if (mem_cgroup_margin(mem_over_limit) >= batch)
>  		goto retry;
> +
> +	if (gfp_mask & __GFP_NORETRY)
> +		goto nomem;
>  	/*
>  	 * Even though the limit is exceeded at this point, reclaim
>  	 * may have been able to free some pages.  Retry the charge
> -- 
> 1.9.3
> 

-- 
Michal Hocko
SUSE Labs
