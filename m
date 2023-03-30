From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 6/9] memcg: sleep during flushing stats in safe
 contexts
Date: Thu, 30 Mar 2023 09:35:56 +0200
Message-ID: <ZCU73Ghje96Q0X7A@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-7-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680161757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fU7z0yHw4Ry/tQw4NzU0o63bQ+V0Qd8kX2CYBZv5RXc=;
        b=uykLa5wl1jleLVQ6elC+H2skYegC2uaQgOrhniRTyo0oiHO0cLN1xo67HvgCsAMt2/5tYw
        y0woZkDkwHmuuvVJteGxd8GCR06LvcbfoPMX3TYaH3/LEK6zekWk9zhX9MHemGQoYyeukU
        rG7ABcMf7DqojiNhm1Q+5nikcDzGNNg=
Content-Disposition: inline
In-Reply-To: <20230328221644.803272-7-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-03-23 22:16:41, Yosry Ahmed wrote:
> Currently, all contexts that flush memcg stats do so with sleeping not
> allowed. Some of these contexts are perfectly safe to sleep in, such as
> reading cgroup files from userspace or the background periodic flusher.
> 
> Refactor the code to make mem_cgroup_flush_stats() non-atomic (aka
> sleepable), and provide a separate atomic version. The atomic version is
> used in reclaim, refault, writeback, and in mem_cgroup_usage(). All
> other code paths are left to use the non-atomic version. This includes
> callbacks for userspace reads and the periodic flusher.
> 
> Since refault is the only caller of mem_cgroup_flush_stats_ratelimited(),
> change it to mem_cgroup_flush_stats_atomic_ratelimited(). Reclaim and
> refault code paths are modified to do non-atomic flushing in separate
> later patches -- so it will eventually be changed back to
> mem_cgroup_flush_stats_ratelimited().
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/memcontrol.h |  9 ++++++--
>  mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++--------
>  mm/vmscan.c                |  2 +-
>  mm/workingset.c            |  2 +-
>  4 files changed, 45 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ac3f3b3a45e2..b424ba3ebd09 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1037,7 +1037,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  }
>  
>  void mem_cgroup_flush_stats(void);
> -void mem_cgroup_flush_stats_ratelimited(void);
> +void mem_cgroup_flush_stats_atomic(void);
> +void mem_cgroup_flush_stats_atomic_ratelimited(void);
>  
>  void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  			      int val);
> @@ -1535,7 +1536,11 @@ static inline void mem_cgroup_flush_stats(void)
>  {
>  }
>  
> -static inline void mem_cgroup_flush_stats_ratelimited(void)
> +static inline void mem_cgroup_flush_stats_atomic(void)
> +{
> +}
> +
> +static inline void mem_cgroup_flush_stats_atomic_ratelimited(void)
>  {
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 65750f8b8259..a2ce3aa10d94 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -634,7 +634,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  	}
>  }
>  
> -static void __mem_cgroup_flush_stats(void)
> +static void do_flush_stats(bool atomic)
>  {
>  	/*
>  	 * We always flush the entire tree, so concurrent flushers can just
> @@ -646,26 +646,46 @@ static void __mem_cgroup_flush_stats(void)
>  		return;
>  
>  	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
> -	cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
> +
> +	if (atomic)
> +		cgroup_rstat_flush_atomic(root_mem_cgroup->css.cgroup);
> +	else
> +		cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> +
>  	atomic_set(&stats_flush_threshold, 0);
>  	atomic_set(&stats_flush_ongoing, 0);
>  }
>  
> +static bool should_flush_stats(void)
> +{
> +	return atomic_read(&stats_flush_threshold) > num_online_cpus();
> +}
> +
>  void mem_cgroup_flush_stats(void)
>  {
> -	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
> -		__mem_cgroup_flush_stats();
> +	if (should_flush_stats())
> +		do_flush_stats(false);
>  }
>  
> -void mem_cgroup_flush_stats_ratelimited(void)
> +void mem_cgroup_flush_stats_atomic(void)
> +{
> +	if (should_flush_stats())
> +		do_flush_stats(true);
> +}
> +
> +void mem_cgroup_flush_stats_atomic_ratelimited(void)
>  {
>  	if (time_after64(jiffies_64, READ_ONCE(flush_next_time)))
> -		mem_cgroup_flush_stats();
> +		mem_cgroup_flush_stats_atomic();
>  }
>  
>  static void flush_memcg_stats_dwork(struct work_struct *w)
>  {
> -	__mem_cgroup_flush_stats();
> +	/*
> +	 * Always flush here so that flushing in latency-sensitive paths is
> +	 * as cheap as possible.
> +	 */
> +	do_flush_stats(false);
>  	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
>  }
>  
> @@ -3685,9 +3705,12 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>  		 * done from irq context; use stale stats in this case.
>  		 * Arguably, usage threshold events are not reliable on the root
>  		 * memcg anyway since its usage is ill-defined.
> +		 *
> +		 * Additionally, other call paths through memcg_check_events()
> +		 * disable irqs, so make sure we are flushing stats atomically.
>  		 */
>  		if (in_task())
> -			mem_cgroup_flush_stats();
> +			mem_cgroup_flush_stats_atomic();
>  		val = memcg_page_state(memcg, NR_FILE_PAGES) +
>  			memcg_page_state(memcg, NR_ANON_MAPPED);
>  		if (swap)
> @@ -4610,7 +4633,11 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
>  	struct mem_cgroup *parent;
>  
> -	mem_cgroup_flush_stats();
> +	/*
> +	 * wb_writeback() takes a spinlock and calls
> +	 * wb_over_bg_thresh()->mem_cgroup_wb_stats(). Do not sleep.
> +	 */
> +	mem_cgroup_flush_stats_atomic();
>  
>  	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
>  	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9c1c5e8b24b8..a9511ccb936f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2845,7 +2845,7 @@ static void prepare_scan_count(pg_data_t *pgdat, struct scan_control *sc)
>  	 * Flush the memory cgroup stats, so that we read accurate per-memcg
>  	 * lruvec stats for heuristics.
>  	 */
> -	mem_cgroup_flush_stats();
> +	mem_cgroup_flush_stats_atomic();
>  
>  	/*
>  	 * Determine the scan balance between anon and file LRUs.
> diff --git a/mm/workingset.c b/mm/workingset.c
> index af862c6738c3..dab0c362b9e3 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -462,7 +462,7 @@ void workingset_refault(struct folio *folio, void *shadow)
>  
>  	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
>  
> -	mem_cgroup_flush_stats_ratelimited();
> +	mem_cgroup_flush_stats_atomic_ratelimited();
>  	/*
>  	 * Compare the distance to the existing workingset size. We
>  	 * don't activate pages that couldn't stay resident even if
> -- 
> 2.40.0.348.gf938b09366-goog

-- 
Michal Hocko
SUSE Labs
