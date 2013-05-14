From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH V2 0/3] memcg: simply lock of page stat accounting
Date: Tue, 14 May 2013 09:13:41 +0200
Message-ID: <20130514071341.GC5198@dhcp22.suse.cz>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com>
 <51918846.7090006@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51918846.7090006-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue 14-05-13 09:41:42, KAMEZAWA Hiroyuki wrote:
> If you want to rewrite all things and make memcg cleaner, I don't stop it.
> But, how about starting with this simeple one for your 1st purpose ? 
> doesn't work ? dirty ?
> 
> == this patch is untested. ==

And it is unnecessary as the trace is no longer possible as
set_page_dirty is no longer called from page_remove_rmap see
abf09bed3cceadd809f0356065c2ada6cee90d4a

> From 95e405451f56933c4777e64bb02326ec0462f7a7 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Date: Tue, 14 May 2013 09:40:55 +0900
> Subject: [PATCH] Allow nesting lock of memcg's page stat accouting.
> 
> Sha Zhengju and Michal Hocko pointed out that
> mem_cgroup_begin/end_update_page_stat() should be nested lock.
> https://lkml.org/lkml/2013/1/2/48
> 
> page_remove_rmap
>   mem_cgroup_begin_update_page_stat		<<< 1
>     set_page_dirty
>       __set_page_dirty_buffers
>         __set_page_dirty
>           mem_cgroup_begin_update_page_stat	<<< 2
>             move_lock_mem_cgroup
>               spin_lock_irqsave(&memcg->move_lock, *flags);
> 
> This patch add a nesting functionality with per-thread counter.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  include/linux/sched.h |    1 +
>  mm/memcontrol.c       |   22 +++++++++++++++++++++-
>  2 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 84ceef5..cca3229 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1402,6 +1402,7 @@ struct task_struct {
>  		unsigned long memsw_nr_pages; /* uncharged mem+swap usage */
>  	} memcg_batch;
>  	unsigned int memcg_kmem_skip_account;
> +	unsigned int memcg_page_stat_accounting;
>  #endif
>  #ifdef CONFIG_HAVE_HW_BREAKPOINT
>  	atomic_t ptrace_bp_refcnt;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 357371a..152f8df 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2352,12 +2352,30 @@ again:
>  	 */
>  	if (!mem_cgroup_stolen(memcg))
>  		return;
> +	/*
> +	 * In some case, we need nested lock of this.
> +	 * page_remove_rmap
> +	 *   mem_cgroup_begin_update_page_stat		<<< 1
> +	 *     set_page_dirty
> +	 *       __set_page_dirty_buffers
> +	 *         __set_page_dirty
> +	 *           mem_cgroup_begin_update_page_stat	<<< 2
> +	 *             move_lock_mem_cgroup
> +	 *               spin_lock_irqsave(&memcg->move_lock, *flags);
> +	 *
> +	 * We avoid this deadlock by having per thread counter.
> +	 */
> +	if (current->memcg_page_stat_accounting > 0) {
> +		current->memcg_page_stat_accounting++;
> +		return;
> +	}
>  
>  	move_lock_mem_cgroup(memcg, flags);
>  	if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
>  		move_unlock_mem_cgroup(memcg, flags);
>  		goto again;
>  	}
> +	current->memcg_page_stat_accounting = 1;
>  	*locked = true;
>  }
>  
> @@ -2370,7 +2388,9 @@ void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
>  	 * lock is held because a routine modifies pc->mem_cgroup
>  	 * should take move_lock_mem_cgroup().
>  	 */
> -	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
> +	current->memcg_page_stat_accounting--;
> +	if (!current->memcg_page_stat_accounting)
> +		move_unlock_mem_cgroup(pc->mem_cgroup, flags);
>  }
>  
>  void mem_cgroup_update_page_stat(struct page *page,
> -- 
> 1.7.4.1
> 
> 
> 

-- 
Michal Hocko
SUSE Labs
