From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.6-fixes] memcg: remove lru_add_drain_all()
 invocation from mem_cgroup_move_charge()
Date: Sun, 17 Apr 2016 08:07:48 -0400
Message-ID: <20160417120747.GC21757@dhcp22.suse.cz>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160415191719.GK12583-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 15-04-16 15:17:19, Tejun Heo wrote:
> mem_cgroup_move_charge() invokes lru_add_drain_all() so that the pvec
> pages can be moved too.  lru_add_drain_all() schedules and flushes
> work items on system_wq which depends on being able to create new
> kworkers to make forward progress.  Since 1ed1328792ff ("sched,
> cgroup: replace signal_struct->group_rwsem with a global
> percpu_rwsem"), a new task can't be created while in the cgroup
> migration path and the described lru_add_drain_all() invocation can
> easily lead to a deadlock.
> 
> Charge moving is best-effort and whether the pvec pages are migrated
> or not doesn't really matter.  Don't call it during charge moving.
> Eventually, we want to move the actual charge moving outside the
> migration path.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

I guess
Debugged-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Reported-by: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>

would be due

> Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: 1ed1328792ff ("sched, cgroup: replace signal_struct->group_rwsem with a global percpu_rwsem")
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> Hello,
> 
> So, this deadlock seems pretty easy to trigger.  We'll make the charge
> moving asynchronous eventually but let's not hold off fixing an
> immediate problem.

Although this looks rather straightforward and it fixes the immediate
problem I am little bit nervous about it. As already pointed out in
other email mem_cgroup_move_charge still depends on mmap_sem for
read and we might hit an even more subtle lockup if the current holder
of the mmap_sem for write depends on the task creation (e.g. some of the
direct reclaim path uses WQ which is really hard to rule out and I even
think that some shrinkers do this).

I liked your proposal when mem_cgroup_move_charge would be called from a
context which doesn't hold the problematic rwsem much more. Would that
be too intrusive for the stable backport?

> Thanks.
> 
>  mm/memcontrol.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 36db05f..56060c7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4859,7 +4859,6 @@ static void mem_cgroup_move_charge(struct mm_struct *mm)
>  		.mm = mm,
>  	};
>  
> -	lru_add_drain_all();
>  	/*
>  	 * Signal lock_page_memcg() to take the memcg's move_lock
>  	 * while we're moving its pages to another memcg. Then wait

-- 
Michal Hocko
SUSE Labs
