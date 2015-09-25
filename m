From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: make mem_cgroup_read_stat() unsigned
Date: Fri, 25 Sep 2015 17:25:34 +0200
Message-ID: <20150925152533.GP16497@dhcp22.suse.cz>
References: <1442960192-83405-1-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442960192-83405-1-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 22-09-15 15:16:32, Greg Thelen wrote:
> mem_cgroup_read_stat() returns a page count by summing per cpu page
> counters.  The summing is racy wrt. updates, so a transient negative sum
> is possible.  Callers don't want negative values:
> - mem_cgroup_wb_stats() doesn't want negative nr_dirty or nr_writeback.

OK, this can confuse dirty throttling AFAIU

> - oom reports and memory.stat shouldn't show confusing negative usage.

I guess this is not earth shattering.

> - tree_usage() already avoids negatives.
> 
> Avoid returning negative page counts from mem_cgroup_read_stat() and
> convert it to unsigned.
> 
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I guess we want that for stable 4.2 because of the dirty throttling
part. Longterm we should use generic per-cpu counter.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 30 ++++++++++++++++++------------
>  1 file changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6ddaeba34e09..2633e9be4a99 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -644,12 +644,14 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>  }
>  
>  /*
> + * Return page count for single (non recursive) @memcg.
> + *
>   * Implementation Note: reading percpu statistics for memcg.
>   *
>   * Both of vmstat[] and percpu_counter has threshold and do periodic
>   * synchronization to implement "quick" read. There are trade-off between
>   * reading cost and precision of value. Then, we may have a chance to implement
> - * a periodic synchronizion of counter in memcg's counter.
> + * a periodic synchronization of counter in memcg's counter.
>   *
>   * But this _read() function is used for user interface now. The user accounts
>   * memory usage by memory cgroup and he _always_ requires exact value because
> @@ -659,17 +661,24 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
>   *
>   * If there are kernel internal actions which can make use of some not-exact
>   * value, and reading all cpu value can be performance bottleneck in some
> - * common workload, threashold and synchonization as vmstat[] should be
> + * common workload, threashold and synchronization as vmstat[] should be
>   * implemented.
>   */
> -static long mem_cgroup_read_stat(struct mem_cgroup *memcg,
> -				 enum mem_cgroup_stat_index idx)
> +static unsigned long
> +mem_cgroup_read_stat(struct mem_cgroup *memcg, enum mem_cgroup_stat_index idx)
>  {
>  	long val = 0;
>  	int cpu;
>  
> +	/* Per-cpu values can be negative, use a signed accumulator */
>  	for_each_possible_cpu(cpu)
>  		val += per_cpu(memcg->stat->count[idx], cpu);
> +	/*
> +	 * Summing races with updates, so val may be negative.  Avoid exposing
> +	 * transient negative values.
> +	 */
> +	if (val < 0)
> +		val = 0;
>  	return val;
>  }
>  
> @@ -1254,7 +1263,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  		for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>  			if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
>  				continue;
> -			pr_cont(" %s:%ldKB", mem_cgroup_stat_names[i],
> +			pr_cont(" %s:%luKB", mem_cgroup_stat_names[i],
>  				K(mem_cgroup_read_stat(iter, i)));
>  		}
>  
> @@ -2819,14 +2828,11 @@ static unsigned long tree_stat(struct mem_cgroup *memcg,
>  			       enum mem_cgroup_stat_index idx)
>  {
>  	struct mem_cgroup *iter;
> -	long val = 0;
> +	unsigned long val = 0;
>  
> -	/* Per-cpu values can be negative, use a signed accumulator */
>  	for_each_mem_cgroup_tree(iter, memcg)
>  		val += mem_cgroup_read_stat(iter, idx);
>  
> -	if (val < 0) /* race ? */
> -		val = 0;
>  	return val;
>  }
>  
> @@ -3169,7 +3175,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>  		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
>  			continue;
> -		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
> +		seq_printf(m, "%s %lu\n", mem_cgroup_stat_names[i],
>  			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
>  	}
>  
> @@ -3194,13 +3200,13 @@ static int memcg_stat_show(struct seq_file *m, void *v)
>  			   (u64)memsw * PAGE_SIZE);
>  
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> -		long long val = 0;
> +		unsigned long long val = 0;
>  
>  		if (i == MEM_CGROUP_STAT_SWAP && !do_swap_account)
>  			continue;
>  		for_each_mem_cgroup_tree(mi, memcg)
>  			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
> -		seq_printf(m, "total_%s %lld\n", mem_cgroup_stat_names[i], val);
> +		seq_printf(m, "total_%s %llu\n", mem_cgroup_stat_names[i], val);
>  	}
>  
>  	for (i = 0; i < MEM_CGROUP_EVENTS_NSTATS; i++) {
> -- 
> 2.6.0.rc0.131.gf624c3d

-- 
Michal Hocko
SUSE Labs
