From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 1/2] mm/memcontrol.c: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Fri, 19 Jan 2018 14:32:27 +0100
Message-ID: <20180119133227.GC6584@dhcp22.suse.cz>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
 <20180119132544.19569-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180119132544.19569-1-aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 19-01-18 16:25:43, Andrey Ryabinin wrote:
> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> pages on each iteration.  This makes it practically impossible to decrease
> limit of memory cgroup.  Tasks could easily allocate back 32 pages, so we
> can't reduce memory usage, and once retry_count reaches zero we return
> -EBUSY.
> 
> Easy to reproduce the problem by running the following commands:
> 
>   mkdir /sys/fs/cgroup/memory/test
>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>   cat big_file > /dev/null &
>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>   -bash: echo: write error: Device or resource busy
> 
> Instead of relying on retry_count, keep retrying the reclaim until the
> desired limit is reached or fail if the reclaim doesn't make any progress
> or a signal is pending.

Thanks for splitting the original patch. I am OK with this part.

> Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 42 ++++++------------------------------------
>  1 file changed, 6 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 13aeccf32c2e..9d987f3e79dc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1176,20 +1176,6 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  }
>  
>  /*
> - * This function returns the number of memcg under hierarchy tree. Returns
> - * 1(self count) if no children.
> - */
> -static int mem_cgroup_count_children(struct mem_cgroup *memcg)
> -{
> -	int num = 0;
> -	struct mem_cgroup *iter;
> -
> -	for_each_mem_cgroup_tree(iter, memcg)
> -		num++;
> -	return num;
> -}
> -
> -/*
>   * Return the memory (and swap, if configured) limit for a memcg.
>   */
>  unsigned long mem_cgroup_get_limit(struct mem_cgroup *memcg)
> @@ -2462,24 +2448,11 @@ static DEFINE_MUTEX(memcg_limit_mutex);
>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  				   unsigned long limit, bool memsw)
>  {
> -	unsigned long curusage;
> -	unsigned long oldusage;
>  	bool enlarge = false;
> -	int retry_count;
>  	int ret;
>  	bool limits_invariant;
>  	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
>  
> -	/*
> -	 * For keeping hierarchical_reclaim simple, how long we should retry
> -	 * is depends on callers. We set our retry-count to be function
> -	 * of # of children which we should visit in this loop.
> -	 */
> -	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
> -		      mem_cgroup_count_children(memcg);
> -
> -	oldusage = page_counter_read(counter);
> -
>  	do {
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
> @@ -2506,15 +2479,12 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, !memsw);
> -
> -		curusage = page_counter_read(counter);
> -		/* Usage is reduced ? */
> -		if (curusage >= oldusage)
> -			retry_count--;
> -		else
> -			oldusage = curusage;
> -	} while (retry_count);
> +		if (!try_to_free_mem_cgroup_pages(memcg, 1,
> +					GFP_KERNEL, !memsw)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +	} while (true);
>  
>  	if (!ret && enlarge)
>  		memcg_oom_recover(memcg);
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
