From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: flush stats only if updated
Date: Fri, 1 Oct 2021 10:28:10 -0400
Message-ID: <YVca+jJnjDn5RLsq@cmpxchg.org>
References: <20210930044711.2892660-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=upxggu0CKNjrWeg2+Dki72ksQiC45ABHkkWuHZ/aw84=;
        b=yrl8VKo4jwzyMKQoR3R0fXVFw1oymfqrdVi89dQGHlrRiU0WU2OtgYwcHTEOU+wkYj
         Q4sTiKEMlV9CQsbPW7r9/xcvm+AqH83mnI1OSsAF4S442Q0/Xk7YhFke/7SMBqCf+230
         3ffMHbx9IPY9JGW2EMYTkJ3d/KSlMyQx72VHkVzxjPcyrXzxYL7xcTzVH5xoV3pHIWfq
         D3mYwlDtt8BHeBBpP1DBQnC6PrbZTLtHFXDfE1xbNcXss4TsFm0tDENlkLeOPK46qaWh
         RAnGLXFGH0umVkOL2amkrE3YMKqv6J6Yj9teNId5gaz3E/noj7eOLdvwOlGTLqpEb1/x
         PyHw==
Content-Disposition: inline
In-Reply-To: <20210930044711.2892660-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 29, 2021 at 09:47:10PM -0700, Shakeel Butt wrote:
> At the moment, the kernel flushes the memcg stats on every refault and
> also on every reclaim iteration. Although rstat maintains per-cpu update
> tree but on the flush the kernel still has to go through all the cpu
> rstat update tree to check if there is anything to flush. This patch
> adds the tracking on the stats update side to make flush side more
> clever by skipping the flush if there is no update.
> 
> The stats update codepath is very sensitive performance wise for many
> workloads and benchmarks. So, we can not follow what the commit
> aa48e47e3906 ("memcg: infrastructure to flush memcg stats") did which
> was triggering async flush through queue_work() and caused a lot
> performance regression reports. That got reverted by the commit
> 1f828223b799 ("memcg: flush lruvec stats in the refault").
> 
> In this patch we kept the stats update codepath very minimal and let the
> stats reader side to flush the stats only when the updates are over a
> specific threshold. For now the threshold is (nr_cpus * CHARGE_BATCH).
> 
> To evaluate the impact of this patch, an 8 GiB tmpfs file is created on
> a system with swap-on-zram and the file was pushed to swap through
> memory.force_empty interface. On reading the whole file, the memcg stat
> flush in the refault code path is triggered. With this patch, we
> bserved 63% reduction in the read time of 8 GiB file.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This is a great idea.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

One minor nit:

> @@ -107,6 +107,8 @@ static bool do_memsw_account(void)
>  static void flush_memcg_stats_dwork(struct work_struct *w);
>  static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
>  static DEFINE_SPINLOCK(stats_flush_lock);
> +static DEFINE_PER_CPU(unsigned int, stats_updates);
> +static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
>  
>  #define THRESHOLDS_EVENTS_TARGET 128
>  #define SOFTLIMIT_EVENTS_TARGET 1024
> @@ -635,6 +637,13 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
>  	return mz;
>  }
>  
> +static inline void memcg_rstat_updated(struct mem_cgroup *memcg)
> +{
> +	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
> +	if (!(__this_cpu_inc_return(stats_updates) % MEMCG_CHARGE_BATCH))
> +		atomic_inc(&stats_flush_threshold);
> +}
> +
>  /**
>   * __mod_memcg_state - update cgroup memory statistics
>   * @memcg: the memory cgroup
> @@ -647,7 +656,7 @@ void __mod_memcg_state(struct mem_cgroup *memcg, int idx, int val)
>  		return;
>  
>  	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
> -	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
> +	memcg_rstat_updated(memcg);
>  }
>  
>  /* idx can be of type enum memcg_stat_item or node_stat_item. */
> @@ -675,10 +684,12 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  	memcg = pn->memcg;
>  
>  	/* Update memcg */
> -	__mod_memcg_state(memcg, idx, val);
> +	__this_cpu_add(memcg->vmstats_percpu->state[idx], val);
>  
>  	/* Update lruvec */
>  	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
> +
> +	memcg_rstat_updated(memcg);
>  }
>  
>  /**
> @@ -780,7 +791,7 @@ void __count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
>  		return;
>  
>  	__this_cpu_add(memcg->vmstats_percpu->events[idx], count);
> -	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
> +	memcg_rstat_updated(memcg);
>  }
>  
>  static unsigned long memcg_events(struct mem_cgroup *memcg, int event)
> @@ -5341,15 +5352,22 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  	memcg_wb_domain_size_changed(memcg);
>  }
>  
> -void mem_cgroup_flush_stats(void)
> +static void __mem_cgroup_flush_stats(void)
>  {
>  	if (!spin_trylock(&stats_flush_lock))
>  		return;
>  
>  	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
> +	atomic_set(&stats_flush_threshold, 0);
>  	spin_unlock(&stats_flush_lock);
>  }
>  
> +void mem_cgroup_flush_stats(void)
> +{
> +	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
> +		__mem_cgroup_flush_stats();
> +}

Because of the way the updates and the flush interact through these
variables now, it might be better to move these up and together.

It'd also be good to have a small explanation of the optimization in
the code as well - that we accept (limited) percpu fuzz in lieu of not
having to check all percpus for every flush.
