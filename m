From: Michael Larabel <Michael-HTCJPow0QItlHob0Tl0JvNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] memcg: flush lruvec stats in the refault
Date: Thu, 23 Sep 2021 05:02:08 -0500
Message-ID: <89476e46-d57c-48fa-54f5-ab2e8cf6e61e@MichaelLarabel.com>
References: <20210922224906.676151-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=michaellarabel.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/UMe8p7BLUCwEGQxHb9t/FCJBJvfDEtMn+TwcXnhsDE=; b=LxijJVqEYdBgo8K/gzXTo0zewS
        HloxbFfbqmsv45WNwQ8bEgReF32r1WsGzQvhk8HqbtCQCM+dr/QRt96AiXbsR7+DkkBlKZYPVacnt
        en52b6xKXQdCsoR0SeE60IrhjJVZ7Lwi2/kF5K6aynsTu1Q+tmTsoxB0uob9T6VELpqcoQYH2zf/R
        P4YB/bINr0TR1yALtWsUuN5xUxM/4vEeOFw0mJJzC95vMmnJAkQglnYhtTjGlS8OOF7GbnG+TXtg/
        vBVxWmDd1e0C+Gfs+VZOwrI8LhTaVoYeJQ6AH4fW45LYevcpZ6r6ugZ9QRvCFUfU4ruY6ZiaYhR0t
In-Reply-To: <20210922224906.676151-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/22/21 5:49 PM, Shakeel Butt wrote:
> Prior to the commit 7e1c0d6f5820 ("memcg: switch lruvec stats to rstat")
> and the commit aa48e47e3906 ("memcg: infrastructure to flush memcg
> stats"), each lruvec memcg stats can be off by (nr_cgroups * nr_cpus *
> 32) at worst and for unbounded amount of time. The commit aa48e47e3906
> moved the lruvec stats to rstat infrastructure and the commit
> 7e1c0d6f5820 bounded the error for all the lruvec stats to (nr_cpus *
> 32) at worst for at most 2 seconds. More specifically it decoupled the
> number of stats and the number of cgroups from the error rate.
>
> However this reduction in error comes with the cost of triggering the
> slowpath of stats update more frequently. Previously in the slowpath the
> kernel adds the stats up the memcg tree. After aa48e47e3906, the kernel
> triggers the asyn lruvec stats flush through queue_work(). This causes
> regression reports from 0day kernel bot [1] as well as from phoronix
> test suite [2].
>
> We tried two options to fix the regression:
>
> 1) Increase the threshold to trigger the slowpath in lruvec stats update
> codepath from 32 to 512.
>
> 2) Remove the slowpath from lruvec stats update codepath and instead
> flush the stats in the page refault codepath. The assumption is that the
> kernel timely flush the stats, so, the update tree would be small in the
> refault codepath to not cause the preformance impact.
>
> Following are the results of will-it-scale/page_fault[1|2|3] benchmark
> on four settings i.e. (1) 5.15-rc1 as baseline (2) 5.15-rc1 with
> aa48e47e3906 and 7e1c0d6f5820 reverted (3) 5.15-rc1 with option-1
> (4) 5.15-rc1 with option-2.
>
> test	(1)	(2)		(3)		(4)
> pg_f1	368563	406277 (10.23%)	399693 (8.44%)	416398 (12.97%)
> pg_f2	338399	372133 (9.96%)	369180 (9.09%)	381024 (12.59%)
> pg_f3	500853	575399 (14.88%)	570388 (13.88%)	576083 (15.02%)
>
>  From the above result, it seems like the option-2 not only solves the
> regression but also improves the performance for at least these
> benchmarks.
>
> Feng Tang (intel) ran the aim7 benchmark with these two options and
> confirms that option-1 reduces the regression but option-2 removes the
> regression.
>
> Michael Larabel (phoronix) ran multiple benchmarks with these options
> and reported the results at [3] and it shows for most benchmarks
> option-2 removes the regression introduced by the commit aa48e47e3906
> ("memcg: infrastructure to flush memcg stats").
>
> Based on the experiment results, this patch proposed the option-2 as the
> solution to resolve the regression.
>
> [1] https://lore.kernel.org/all/20210726022421.GB21872@xsang-OptiPlex-9020
> [2] https://www.phoronix.com/scan.php?page=article&item=linux515-compile-regress
> [3] https://openbenchmarking.org/result/2109226-DEBU-LINUX5104
>
> Fixes: aa48e47e3906 ("memcg: infrastructure to flush memcg stats")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c | 10 ----------
>   mm/workingset.c |  1 +
>   2 files changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b762215d73eb..6da5020a8656 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -106,9 +106,6 @@ static bool do_memsw_account(void)
>   /* memcg and lruvec stats flushing */
>   static void flush_memcg_stats_dwork(struct work_struct *w);
>   static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
> -static void flush_memcg_stats_work(struct work_struct *w);
> -static DECLARE_WORK(stats_flush_work, flush_memcg_stats_work);
> -static DEFINE_PER_CPU(unsigned int, stats_flush_threshold);
>   static DEFINE_SPINLOCK(stats_flush_lock);
>   
>   #define THRESHOLDS_EVENTS_TARGET 128
> @@ -682,8 +679,6 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>   
>   	/* Update lruvec */
>   	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
> -	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
> -		queue_work(system_unbound_wq, &stats_flush_work);
>   }
>   
>   /**
> @@ -5361,11 +5356,6 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
>   	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
>   }
>   
> -static void flush_memcg_stats_work(struct work_struct *w)
> -{
> -	mem_cgroup_flush_stats();
> -}
> -
>   static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> diff --git a/mm/workingset.c b/mm/workingset.c
> index d4268d8e9a82..d5b81e4f4cbe 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -352,6 +352,7 @@ void workingset_refault(struct page *page, void *shadow)
>   
>   	inc_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file);
>   
> +	mem_cgroup_flush_stats();
>   	/*
>   	 * Compare the distance to the existing workingset size. We
>   	 * don't activate pages that couldn't stay resident even if


This patch is still looking good in my additional testing so far.

With an Intel Core i9 11900K system where it was quite noticeably 
regressing in various workloads, things now seem to be under control[1] 
with this patch and inline with v5.14 / 5.15 with the memcg patches 
reverted.

If desired:

Tested-by: Michael Larabel <Michael-VPulBVZx9zJWk0Htik3J/w@public.gmane.org>

Michael

[1] 
https://openbenchmarking.org/result/2109221-DEBU-LINUX5143&sgm=1&hgv=flush-in-the-ref&sor

