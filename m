From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH RFC] mm/memcg: recalculate chargeable space after waiting
 migrating charges
Date: Thu, 12 Jul 2012 13:08:38 +0200
Message-ID: <20120712110838.GE21013@tiehlicka.suse.cz>
References: <1342089561-11211-1-git-send-email-liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1342089561-11211-1-git-send-email-liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 12-07-12 18:39:21, Wanpeng Li wrote:
> From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> Function mem_cgroup_do_charge will call mem_cgroup_reclaim,
> there are two break points in mem_cgroup_reclaim:
> if (total && (flag & MEM_CGROUP_RECLAIM_SHIRINK))
> 	break;
> if (mem_cgroup_margin(memcg))
> 	break;
> so mem_cgroup_reclaim can't guarantee reclaim enough pages(nr_pages) 
> which is requested from mem_cgroup_do_charge, if mem_cgroup_margin
> (mem_over_limit) >= nr_pages is not true, the process will go to
> mem_cgroup_wait_acct_move to wait doubly charge counted caused by
> task move. 

I am sorry but I have no idea what you are trying to say. The
mem_cgroup_wait_acct_move just makes sure that we are waiting until
charge is moved (which can potentially free some charges) rather than
OOM which should be the last resort so it makes sense to retry the
charge.

> But this time still can't guarantee enough pages(nr_pages) is
> ready, directly return CHARGE_RETRY is incorret. 

So you think it is better to oom? Why? What prevents you from a race
that your mem_cgroup_margin returns true but another CPU consumes those
charges right after that. See? The check is pointless. It doesn't
guarantee anything.

> We should add a check to confirm enough pages is ready, otherwise go
> to oom.

What you are trying to fix? How have you tested it? Why do you think it
makes any sense at all?
You are just changing the behavior without any rationale. And that's a
_no_go_!

> 
> Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f72b5e5..4ae3848 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2210,7 +2210,8 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * At task move, charge accounts can be doubly counted. So, it's
>  	 * better to wait until the end of task_move if something is going on.
>  	 */
> -	if (mem_cgroup_wait_acct_move(mem_over_limit))
> +	if (mem_cgroup_wait_acct_move(mem_over_limit)
> +			&& mem_cgroup_margin(mem_over_limit) >= nr_pages)
>  		return CHARGE_RETRY;
>  
>  	/* If we don't need to call oom-killer at el, return immediately */
> -- 
> 1.7.5.4
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
