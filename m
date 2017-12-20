From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/2] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Wed, 20 Dec 2017 11:33:37 +0100
Message-ID: <20171220103337.GL4831@dhcp22.suse.cz>
References: <20171220102429.31601-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171220102429.31601-1-aryabinin@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed 20-12-17 13:24:28, Andrey Ryabinin wrote:
> mem_cgroup_resize_[memsw]_limit() tries to free only 32 (SWAP_CLUSTER_MAX)
> pages on each iteration. This makes practically impossible to decrease
> limit of memory cgroup. Tasks could easily allocate back 32 pages,
> so we can't reduce memory usage, and once retry_count reaches zero we return
> -EBUSY.
> 
> It's easy to reproduce the problem by running the following commands:
> 
>   mkdir /sys/fs/cgroup/memory/test
>   echo $$ >> /sys/fs/cgroup/memory/test/tasks
>   cat big_file > /dev/null &
>   sleep 1 && echo $((100*1024*1024)) > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>   -bash: echo: write error: Device or resource busy
> 
> Instead of trying to free small amount of pages, it's much more
> reasonable to free 'usage - limit' pages.

But that only makes the issue less probable. It doesn't fix it because 
		if (curusage >= oldusage)
			retry_count--;
can still be true because allocator might be faster than the reclaimer.
Wouldn't it be more reasonable to simply remove the retry count and keep
trying until interrupted or we manage to update the limit. Another
option would be to commit the new limit and allow temporal overcommit
of the hard limit. New allocations and the limit update paths would
reclaim to the hard limit.

> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
> ---
>  mm/memcontrol.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f40b5ad3f959..09ee052cf684 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2476,7 +2476,7 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
>  		      mem_cgroup_count_children(memcg);
>  
> -	oldusage = page_counter_read(&memcg->memory);
> +	curusage = oldusage = page_counter_read(&memcg->memory);
>  
>  	do {
>  		if (signal_pending(current)) {
> @@ -2498,7 +2498,8 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, true);
> +		try_to_free_mem_cgroup_pages(memcg, curusage - limit,
> +					GFP_KERNEL, true);
>  
>  		curusage = page_counter_read(&memcg->memory);
>  		/* Usage is reduced ? */
> @@ -2527,7 +2528,7 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  	retry_count = MEM_CGROUP_RECLAIM_RETRIES *
>  		      mem_cgroup_count_children(memcg);
>  
> -	oldusage = page_counter_read(&memcg->memsw);
> +	curusage = oldusage = page_counter_read(&memcg->memsw);
>  
>  	do {
>  		if (signal_pending(current)) {
> @@ -2549,7 +2550,8 @@ static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL, false);
> +		try_to_free_mem_cgroup_pages(memcg, curusage - limit,
> +					GFP_KERNEL, false);
>  
>  		curusage = page_counter_read(&memcg->memsw);
>  		/* Usage is reduced ? */
> -- 
> 2.13.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
