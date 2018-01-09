From: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v3 1/2] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Tue, 9 Jan 2018 20:08:34 +0300
Message-ID: <99a37cfd-c134-6439-cb6e-81382bc03833@virtuozzo.com>
References: <20171220135329.GS4831@dhcp22.suse.cz>
 <20180109165815.8329-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4nKTZX0tXifW00sicRg/d/LSvejRnr2K+pfZws03Ye8=;
 b=IJV+IXmhD3CZGX5rq/Z4/mou575gajN2OJ0ARmXa3AqPVuNtQGB5wsmXxEe+p4oksGF0aYq+W7fma4pz9REdyD2hxFDB0qA3aZXphlREOjfOTUeJdVO0ynnewZQK2xe4+8dfDThaoaUjwEzHoJ0VjNG6ngXvj3WJ9Pn4wPiX7M4=
In-Reply-To: <20180109165815.8329-1-aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>



On 01/09/2018 07:58 PM, Andrey Ryabinin wrote:
> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> pages on each iteration. This makes practically impossible to decrease
> limit of memory cgroup. Tasks could easily allocate back 32 pages,
> so we can't reduce memory usage, and once retry_count reaches zero we return
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
> Instead of relying on retry_count, keep retrying the reclaim until
> the desired limit is reached or fail if the reclaim doesn't make
> any progress or a signal is pending.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
> 
> Changes since v2:
>  - Changelog wording per mhocko@
> 


Ugh, sorry, I forgot to +Cc Michal this time.

Changelog, is the only thing than changed between v2 and v3.


>  mm/memcontrol.c | 70 +++++++++++++--------------------------------------------
>  1 file changed, 16 insertions(+), 54 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f40b5ad3f959..0d26db9a665d 100644
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
> @@ -2462,22 +2448,10 @@ static DEFINE_MUTEX(memcg_limit_mutex);
>  static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  				   unsigned long limit)
>  {
> -	unsigned long curusage;
> -	unsigned long oldusage;
> +	unsigned long usage;
>  	bool enlarge = false;
> -	int retry_count;
>  	int ret;
>  
> -	/*
> -	 * For keeping hierarchical_reclaim simple, how long we should retry
> -	 * is depends on callers. We set our retry-count to be function
> -	 * of # of children which we should visit in this loop.
> -	 */
> -	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
> -		      mem_cgroup_count_children(memcg);
> -
> -	oldusage = page_counter_read(&memcg->memory);
> -
>  	do {
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
> @@ -2498,15 +2472,13 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
> -
> -		curusage = page_counter_read(&memcg->memory);
> -		/* Usage is reduced ? */
> -		if (curusage >= oldusage)
> -			retry_count--;
> -		else
> -			oldusage = curusage;
> -	} while (retry_count);
> +		usage = page_counter_read(&memcg->memory);
> +		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
> +					GFP_KERNEL, true)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +	} while (true);
>  
>  	if (!ret && enlarge)
>  		memcg_oom_recover(memcg);
> @@ -2517,18 +2489,10 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  					 unsigned long limit)
>  {
> -	unsigned long curusage;
> -	unsigned long oldusage;
> +	unsigned long usage;
>  	bool enlarge = false;
> -	int retry_count;
>  	int ret;
>  
> -	/* see mem_cgroup_resize_res_limit */
> -	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
> -		      mem_cgroup_count_children(memcg);
> -
> -	oldusage = page_counter_read(&memcg->memsw);
> -
>  	do {
>  		if (signal_pending(current)) {
>  			ret = -EINTR;
> @@ -2549,15 +2513,13 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
> -
> -		curusage = page_counter_read(&memcg->memsw);
> -		/* Usage is reduced ? */
> -		if (curusage >= oldusage)
> -			retry_count--;
> -		else
> -			oldusage = curusage;
> -	} while (retry_count);
> +		usage = page_counter_read(&memcg->memsw);
> +		if (!try_to_free_mem_cgroup_pages(memcg, usage - limit,
> +					GFP_KERNEL, false)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +	} while (true);
>  
>  	if (!ret && enlarge)
>  		memcg_oom_recover(memcg);
> 
