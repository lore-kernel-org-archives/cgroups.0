From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: clean up force_empty_list() return value check
Date: Mon, 18 Jun 2012 15:31:50 +0200
Message-ID: <20120618133149.GC2313@tiehlicka.suse.cz>
References: <4FDF17A3.9060202@jp.fujitsu.com>
 <4FDF1830.1000504@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FDF1830.1000504-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon 18-06-12 20:59:44, KAMEZAWA Hiroyuki wrote:
> 
> By commit "memcg: move charges to root cgroup if use_hierarchy=0"
> mem_cgroup_move_parent() only returns -EBUSY, -EINVAL.
> So, we can remove -ENOMEM and -EINTR checks.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cf8a0f6..726b7c6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3847,8 +3847,6 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
>  		pc = lookup_page_cgroup(page);
>  
>  		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
> -		if (ret == -ENOMEM || ret == -EINTR)
> -			break;
>  
>  		if (ret == -EBUSY || ret == -EINVAL) {
>  			/* found lock contention or "pc" is obsolete. */
> @@ -3910,9 +3908,6 @@ move_account:
>  		}
>  		mem_cgroup_end_move(memcg);
>  		memcg_oom_recover(memcg);
> -		/* it seems parent cgroup doesn't have enough mem */
> -		if (ret == -ENOMEM)
> -			goto try_to_free;
>  		cond_resched();
>  	/* "ret" should also be checked to ensure all lists are empty. */
>  	} while (res_counter_read_u64(&memcg->res, RES_USAGE) > 0 || ret);
> -- 
> 1.7.4.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
