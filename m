From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcontrol: fix missed end-writeback page
 accounting
Date: Thu, 23 Oct 2014 17:00:39 +0200
Message-ID: <20141023150039.GI23011@dhcp22.suse.cz>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
 <1414002568-21042-3-git-send-email-hannes@cmpxchg.org>
 <20141022133936.44f2d2931948ce13477b5e64@linux-foundation.org>
 <20141023135412.GA24269@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141023135412.GA24269-HTCKtW7iVlxqnrmGgq4/JMIURNUf+fel@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 23-10-14 09:54:12, Johannes Weiner wrote:
[...]
> From 1808b8e2114a7d3cc6a0a52be2fe568ff6e1457e Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Date: Thu, 23 Oct 2014 09:12:01 -0400
> Subject: [patch] mm: memcontrol: fix missed end-writeback page accounting fix
> 
> Add kernel-doc to page state accounting functions.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Nice!
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 51 +++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 024177df7aae..ae9b630e928b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2109,21 +2109,31 @@ cleanup:
>  	return true;
>  }
>  
> -/*
> - * Used to update mapped file or writeback or other statistics.
> +/**
> + * mem_cgroup_begin_page_stat - begin a page state statistics transaction
> + * @page: page that is going to change accounted state
> + * @locked: &memcg->move_lock slowpath was taken
> + * @flags: IRQ-state flags for &memcg->move_lock
>   *
> - * Notes: Race condition
> + * This function must mark the beginning of an accounted page state
> + * change to prevent double accounting when the page is concurrently
> + * being moved to another memcg:
>   *
> - * Charging occurs during page instantiation, while the page is
> - * unmapped and locked in page migration, or while the page table is
> - * locked in THP migration.  No race is possible.
> + *   memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
> + *   if (TestClearPageState(page))
> + *     mem_cgroup_update_page_stat(memcg, state, -1);
> + *   mem_cgroup_end_page_stat(memcg, locked, flags);
>   *
> - * Uncharge happens to pages with zero references, no race possible.
> + * The RCU lock is held throughout the transaction.  The fast path can
> + * get away without acquiring the memcg->move_lock (@locked is false)
> + * because page moving starts with an RCU grace period.
>   *
> - * Charge moving between groups is protected by checking mm->moving
> - * account and taking the move_lock in the slowpath.
> + * The RCU lock also protects the memcg from being freed when the page
> + * state that is going to change is the only thing preventing the page
> + * from being uncharged.  E.g. end-writeback clearing PageWriteback(),
> + * which allows migration to go ahead and uncharge the page before the
> + * account transaction might be complete.
>   */
> -
>  struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
>  					      bool *locked,
>  					      unsigned long *flags)
> @@ -2141,12 +2151,7 @@ again:
>  	memcg = pc->mem_cgroup;
>  	if (unlikely(!memcg))
>  		return NULL;
> -	/*
> -	 * If this memory cgroup is not under account moving, we don't
> -	 * need to take move_lock_mem_cgroup(). Because we already hold
> -	 * rcu_read_lock(), any calls to move_account will be delayed until
> -	 * rcu_read_unlock().
> -	 */
> +
>  	*locked = false;
>  	if (atomic_read(&memcg->moving_account) <= 0)
>  		return memcg;
> @@ -2161,6 +2166,12 @@ again:
>  	return memcg;
>  }
>  
> +/**
> + * mem_cgroup_end_page_stat - finish a page state statistics transaction
> + * @memcg: the memcg that was accounted against
> + * @locked: value received from mem_cgroup_begin_page_stat()
> + * @flags: value received from mem_cgroup_begin_page_stat()
> + */
>  void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
>  			      unsigned long flags)
>  {
> @@ -2170,6 +2181,14 @@ void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
>  	rcu_read_unlock();
>  }
>  
> +/**
> + * mem_cgroup_update_page_stat - update page state statistics
> + * @memcg: memcg to account against
> + * @idx: page state item to account
> + * @val: number of pages (positive or negative)
> + *
> + * See mem_cgroup_begin_page_stat() for locking requirements.
> + */
>  void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>  				 enum mem_cgroup_stat_index idx, int val)
>  {
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
