From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] rename MEM_CGROUP_STAT_SWAPOUT as MEM_CGROUP_STAT_NR_SWAP
Date: Fri, 1 Jun 2012 13:11:42 +0200
Message-ID: <20120601111142.GF30196@tiehlicka.suse.cz>
References: <4FC89BC4.9030604@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FC89BC4.9030604-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Fri 01-06-12 19:39:00, KAMEZAWA Hiroyuki wrote:
> MEM_CGROUP_STAT_SWAPOUT represents the usage of swap rather than
> the number of swap-out events. Rename it to be MEM_CGROUP_STAT_NR_SWAP.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0121ef3..76bc54c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -97,7 +97,7 @@ enum mem_cgroup_stat_index {
>  	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
>  	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
>  	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
> -	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> +	MEM_CGROUP_STAT_NR_SWAP, /* # of pages, swapped out */
>  	MEM_CGROUP_STAT_NSTATS,
>  };
>  
> @@ -722,7 +722,7 @@ static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
>  					 bool charge)
>  {
>  	int val = (charge) ? 1 : -1;
> -	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_SWAPOUT], val);
> +	this_cpu_add(memcg->stat->count[MEM_CGROUP_STAT_NR_SWAP], val);
>  }
>  
>  static unsigned long mem_cgroup_read_events(struct mem_cgroup *memcg,
> @@ -4042,7 +4042,7 @@ static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>  	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
>  
>  	if (swap)
> -		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAPOUT);
> +		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_NR_SWAP);
>  
>  	return val << PAGE_SHIFT;
>  }
> @@ -4303,7 +4303,7 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
>  	unsigned int i;
>  
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
> -		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
> +		if (i == MEM_CGROUP_STAT_NR_SWAP && !do_swap_account)
>  			continue;
>  		seq_printf(m, "%s %ld\n", mem_cgroup_stat_names[i],
>  			   mem_cgroup_read_stat(memcg, i) * PAGE_SIZE);
> @@ -4330,7 +4330,7 @@ static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
>  	for (i = 0; i < MEM_CGROUP_STAT_NSTATS; i++) {
>  		long long val = 0;
>  
> -		if (i == MEM_CGROUP_STAT_SWAPOUT && !do_swap_account)
> +		if (i == MEM_CGROUP_STAT_NR_SWAP && !do_swap_account)
>  			continue;
>  		for_each_mem_cgroup_tree(mi, memcg)
>  			val += mem_cgroup_read_stat(mi, i) * PAGE_SIZE;
> -- 
> 1.7.4.1
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
