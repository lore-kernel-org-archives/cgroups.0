From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: do not allow task about to OOM kill to
 bypass the limit
Date: Thu, 5 Dec 2013 14:14:44 +0100
Message-ID: <20131205131444.GC16711@dhcp22.suse.cz>
References: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
 <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1386197114-5317-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 04-12-13 17:45:14, Johannes Weiner wrote:
> 4942642080ea ("mm: memcg: handle non-error OOM situations more
> gracefully") allowed tasks that already entered a memcg OOM condition
> to bypass the memcg limit on subsequent allocation attempts hoping
> this would expedite finishing the page fault and executing the kill.
> 
> David Rientjes is worried that this breaks memcg isolation guarantees
> and since there is no evidence that the bypass actually speeds up
> fault processing just change it so that these subsequent charge
> attempts fail outright.  The notable exception being __GFP_NOFAIL
> charges which are required to bypass the limit regardless.
> 
> Reported-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

We want this in stable as well IMHO.
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f6a63f5b3827..bf5e89457149 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2694,7 +2694,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  		goto bypass;
>  
>  	if (unlikely(task_in_memcg_oom(current)))
> -		goto bypass;
> +		goto nomem;
>  
>  	if (gfp_mask & __GFP_NOFAIL)
>  		oom = false;
> -- 
> 1.8.4.2
> 

-- 
Michal Hocko
SUSE Labs
