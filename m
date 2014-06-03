From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 01/10] mm: memcontrol: fold mem_cgroup_do_charge()
Date: Tue, 3 Jun 2014 14:38:36 +0200
Message-ID: <20140603123836.GF1321@dhcp22.suse.cz>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
 <1401380162-24121-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1401380162-24121-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 29-05-14 12:15:53, Johannes Weiner wrote:
> This function was split out because mem_cgroup_try_charge() got too
> big.  But having essentially one sequence of operations arbitrarily
> split in half is not good for reworking the code.  Fold it back in.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 166 ++++++++++++++++++++++----------------------------------
>  1 file changed, 64 insertions(+), 102 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4df733e13727..c3c10ab98355 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2552,80 +2552,6 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
>  	return NOTIFY_OK;
>  }
>  
> -
> -/* See mem_cgroup_try_charge() for details */
> -enum {
> -	CHARGE_OK,		/* success */
> -	CHARGE_RETRY,		/* need to retry but retry is not bad */
> -	CHARGE_NOMEM,		/* we can't do more. return -ENOMEM */
> -	CHARGE_WOULDBLOCK,	/* GFP_WAIT wasn't set and no enough res. */
> -};
> -
> -static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
> -				unsigned int nr_pages, unsigned int min_pages,
> -				bool invoke_oom)
> -{
> -	unsigned long csize = nr_pages * PAGE_SIZE;
> -	struct mem_cgroup *mem_over_limit;
> -	struct res_counter *fail_res;
> -	unsigned long flags = 0;
> -	int ret;
> -
> -	ret = res_counter_charge(&memcg->res, csize, &fail_res);
> -
> -	if (likely(!ret)) {
> -		if (!do_swap_account)
> -			return CHARGE_OK;
> -		ret = res_counter_charge(&memcg->memsw, csize, &fail_res);
> -		if (likely(!ret))
> -			return CHARGE_OK;
> -
> -		res_counter_uncharge(&memcg->res, csize);
> -		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
> -		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
> -	} else
> -		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
> -	/*
> -	 * Never reclaim on behalf of optional batching, retry with a
> -	 * single page instead.
> -	 */
> -	if (nr_pages > min_pages)
> -		return CHARGE_RETRY;
> -
> -	if (!(gfp_mask & __GFP_WAIT))
> -		return CHARGE_WOULDBLOCK;
> -
> -	if (gfp_mask & __GFP_NORETRY)
> -		return CHARGE_NOMEM;
> -
> -	ret = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
> -	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> -		return CHARGE_RETRY;
> -	/*
> -	 * Even though the limit is exceeded at this point, reclaim
> -	 * may have been able to free some pages.  Retry the charge
> -	 * before killing the task.
> -	 *
> -	 * Only for regular pages, though: huge pages are rather
> -	 * unlikely to succeed so close to the limit, and we fall back
> -	 * to regular pages anyway in case of failure.
> -	 */
> -	if (nr_pages <= (1 << PAGE_ALLOC_COSTLY_ORDER) && ret)
> -		return CHARGE_RETRY;
> -
> -	/*
> -	 * At task move, charge accounts can be doubly counted. So, it's
> -	 * better to wait until the end of task_move if something is going on.
> -	 */
> -	if (mem_cgroup_wait_acct_move(mem_over_limit))
> -		return CHARGE_RETRY;
> -
> -	if (invoke_oom)
> -		mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(csize));
> -
> -	return CHARGE_NOMEM;
> -}
> -
>  /**
>   * mem_cgroup_try_charge - try charging a memcg
>   * @memcg: memcg to charge
> @@ -2642,7 +2568,11 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  {
>  	unsigned int batch = max(CHARGE_BATCH, nr_pages);
>  	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
> -	int ret;
> +	struct mem_cgroup *mem_over_limit;
> +	struct res_counter *fail_res;
> +	unsigned long nr_reclaimed;
> +	unsigned long flags = 0;
> +	unsigned long long size;
>  
>  	if (mem_cgroup_is_root(memcg))
>  		goto done;
> @@ -2662,44 +2592,76 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  
>  	if (gfp_mask & __GFP_NOFAIL)
>  		oom = false;
> -again:
> +retry:
>  	if (consume_stock(memcg, nr_pages))
>  		goto done;
>  
> -	do {
> -		bool invoke_oom = oom && !nr_oom_retries;
> +	size = batch * PAGE_SIZE;
> +	if (!res_counter_charge(&memcg->res, size, &fail_res)) {
> +		if (!do_swap_account)
> +			goto done_restock;
> +		if (!res_counter_charge(&memcg->memsw, size, &fail_res))
> +			goto done_restock;
> +		res_counter_uncharge(&memcg->res, size);
> +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
> +		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
> +	} else
> +		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
>  
> -		/* If killed, bypass charge */
> -		if (fatal_signal_pending(current))
> -			goto bypass;
> +	if (batch > nr_pages) {
> +		batch = nr_pages;
> +		goto retry;
> +	}
>  
> -		ret = mem_cgroup_do_charge(memcg, gfp_mask, batch,
> -					   nr_pages, invoke_oom);
> -		switch (ret) {
> -		case CHARGE_OK:
> -			break;
> -		case CHARGE_RETRY: /* not in OOM situation but retry */
> -			batch = nr_pages;
> -			goto again;
> -		case CHARGE_WOULDBLOCK: /* !__GFP_WAIT */
> -			goto nomem;
> -		case CHARGE_NOMEM: /* OOM routine works */
> -			if (!oom || invoke_oom)
> -				goto nomem;
> -			nr_oom_retries--;
> -			break;
> -		}
> -	} while (ret != CHARGE_OK);
> +	if (!(gfp_mask & __GFP_WAIT))
> +		goto nomem;
>  
> -	if (batch > nr_pages)
> -		refill_stock(memcg, batch - nr_pages);
> -done:
> -	return 0;
> +	if (gfp_mask & __GFP_NORETRY)
> +		goto nomem;
> +
> +	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
> +
> +	if (mem_cgroup_margin(mem_over_limit) >= batch)
> +		goto retry;
> +	/*
> +	 * Even though the limit is exceeded at this point, reclaim
> +	 * may have been able to free some pages.  Retry the charge
> +	 * before killing the task.
> +	 *
> +	 * Only for regular pages, though: huge pages are rather
> +	 * unlikely to succeed so close to the limit, and we fall back
> +	 * to regular pages anyway in case of failure.
> +	 */
> +	if (nr_reclaimed && batch <= (1 << PAGE_ALLOC_COSTLY_ORDER))
> +		goto retry;
> +	/*
> +	 * At task move, charge accounts can be doubly counted. So, it's
> +	 * better to wait until the end of task_move if something is going on.
> +	 */
> +	if (mem_cgroup_wait_acct_move(mem_over_limit))
> +		goto retry;
> +
> +	if (fatal_signal_pending(current))
> +		goto bypass;
> +
> +	if (!oom)
> +		goto nomem;
> +
> +	if (nr_oom_retries--)
> +		goto retry;
> +
> +	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
>  nomem:
>  	if (!(gfp_mask & __GFP_NOFAIL))
>  		return -ENOMEM;
>  bypass:
>  	return -EINTR;
> +
> +done_restock:
> +	if (batch > nr_pages)
> +		refill_stock(memcg, batch - nr_pages);
> +done:
> +	return 0;
>  }
>  
>  /**
> -- 
> 1.9.3
> 

-- 
Michal Hocko
SUSE Labs
