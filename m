From: Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] memcg: infrastructure to flush memcg stats
Date: Fri, 16 Jul 2021 17:03:53 +0200
Message-ID: <78005c4c-9233-7bc8-d50e-e3fe11f30b5d@samsung.com>
References: <20210714013948.270662-1-shakeelb@google.com>
        <20210714013948.270662-2-shakeelb@google.com>
        <CGME20210716150353eucas1p2c9ad1d1021ee584de587e5ec10b8467b@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210716150354euoutp029477b6a28d89040bb9cf916c1a6007a1~STbBHkmB12052520525euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626447834;
        bh=LOCs/2mBF1xQdHZWGjG7nJ493Pn7vzTndVuGZjYhqEE=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=mc5j3zWYYjis0C49ZdMoEo8FM51UtDZ3HBop1C2LaiZ2xbrpO1ZpFgdOOxvtKZFDJ
         p6pPbz5DZ98fiVoxIOjwGfxbwUS3nZ2JYfCvAqNhYerYjKVr7TqUClauL9J38WIHQK
         byV+/10nyolNh9Wg765pB7uAb+p0idP4Vpj10RAA=
In-Reply-To: <20210714013948.270662-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 14.07.2021 03:39, Shakeel Butt wrote:
> At the moment memcg stats are read in four contexts:
>
> 1. memcg stat user interfaces
> 2. dirty throttling
> 3. page fault
> 4. memory reclaim
>
> Currently the kernel flushes the stats for first two cases. Flushing the
> stats for remaining two casese may have performance impact. Always
> flushing the memcg stats on the page fault code path may negatively
> impacts the performance of the applications. In addition flushing in the
> memory reclaim code path, though treated as slowpath, can become the
> source of contention for the global lock taken for stat flushing because
> when system or memcg is under memory pressure, many tasks may enter the
> reclaim path.
>
> This patch uses following mechanisms to solve these challenges:
>
> 1. Periodically flush the stats from root memcg every 2 seconds. This
> will time limit the out of sync stats.
>
> 2. Asynchronously flush the stats after fixed number of stat updates.
> In the worst case the stat can be out of sync by O(nr_cpus * BATCH) for
> 2 seconds.
>
> 3. For avoiding thundering herd to flush the stats particularly from the
> memory reclaim context, introduce memcg local spinlock and let only one
> flusher active at a time. This could have been done through
> cgroup_rstat_lock lock but that lock is used by other subsystem and for
> userspace reading memcg stats. So, it is better to keep flushers
> introduced by this patch decoupled from cgroup_rstat_lock.
>
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This patch landed in today's linux-next (next-20210716) as commit 
42265e014ac7 ("memcg: infrastructure to flush memcg stats"). On my test 
system's I found that it triggers a kernel BUG on all ARM64 boards:

  BUG: sleeping function called from invalid context at 
kernel/cgroup/rstat.c:200
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 7, name: 
kworker/u8:0
  3 locks held by kworker/u8:0/7:
   #0: ffff00004000c938 ((wq_completion)events_unbound){+.+.}-{0:0}, at: 
process_one_work+0x200/0x718
   #1: ffff80001334bdd0 ((stats_flush_dwork).work){+.+.}-{0:0}, at: 
process_one_work+0x200/0x718
   #2: ffff8000124f6d40 (stats_flush_lock){+.+.}-{2:2}, at: 
mem_cgroup_flush_stats+0x20/0x48
  CPU: 2 PID: 7 Comm: kworker/u8:0 Tainted: G        W 5.14.0-rc1+ #3713
  Hardware name: Raspberry Pi 4 Model B (DT)
  Workqueue: events_unbound flush_memcg_stats_dwork
  Call trace:
   dump_backtrace+0x0/0x1d0
   show_stack+0x14/0x20
   dump_stack_lvl+0x88/0xb0
   dump_stack+0x14/0x2c
   ___might_sleep+0x1dc/0x200
   __might_sleep+0x4c/0x88
   cgroup_rstat_flush+0x2c/0x58
   mem_cgroup_flush_stats+0x34/0x48
   flush_memcg_stats_dwork+0xc/0x38
   process_one_work+0x2a8/0x718
   worker_thread+0x48/0x460
   kthread+0x12c/0x160
   ret_from_fork+0x10/0x18

This can be also reproduced with QEmu. Please let me know if I can help 
fixing this issue.

> ---
> Changes since v3:
> - Add back the sigoff
>
> Changes since v2:
> - Changed the subject of the patch
> - Added mechanism to bound errors to nr_cpus instead of nr_cgroups
> - memcg local lock to let one active flusher
>
> Changes since v1:
> - use system_unbound_wq for flushing the memcg stats
>
>   include/linux/memcontrol.h |  6 ++++++
>   mm/memcontrol.c            | 34 ++++++++++++++++++++++++++++++++++
>   mm/vmscan.c                |  6 ++++++
>   3 files changed, 46 insertions(+)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0bfa0409af22..fa095a94ae56 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -991,6 +991,8 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>   	return x;
>   }
>   
> +void mem_cgroup_flush_stats(void);
> +
>   void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>   			      int val);
>   void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
> @@ -1400,6 +1402,10 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>   	return node_page_state(lruvec_pgdat(lruvec), idx);
>   }
>   
> +static inline void mem_cgroup_flush_stats(void)
> +{
> +}
> +
>   static inline void __mod_memcg_lruvec_state(struct lruvec *lruvec,
>   					    enum node_stat_item idx, int val)
>   {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 848d711bf576..39a00991fc80 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -103,6 +103,14 @@ static bool do_memsw_account(void)
>   	return !cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_noswap;
>   }
>   
> +/* memcg and lruvec stats flushing */
> +static void flush_memcg_stats_dwork(struct work_struct *w);
> +static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
> +static void flush_memcg_stats_work(struct work_struct *w);
> +static DECLARE_WORK(stats_flush_work, flush_memcg_stats_work);
> +static DEFINE_PER_CPU(unsigned int, stats_flush_threshold);
> +static DEFINE_SPINLOCK(stats_flush_lock);
> +
>   #define THRESHOLDS_EVENTS_TARGET 128
>   #define SOFTLIMIT_EVENTS_TARGET 1024
>   
> @@ -685,6 +693,8 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>   
>   	/* Update lruvec */
>   	__this_cpu_add(pn->lruvec_stats_percpu->state[idx], val);
> +	if (!(__this_cpu_inc_return(stats_flush_threshold) % MEMCG_CHARGE_BATCH))
> +		queue_work(system_unbound_wq, &stats_flush_work);
>   }
>   
>   /**
> @@ -5248,6 +5258,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>   	/* Online state pins memcg ID, memcg ID pins CSS */
>   	refcount_set(&memcg->id.ref, 1);
>   	css_get(css);
> +
> +	if (unlikely(mem_cgroup_is_root(memcg)))
> +		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
> +				   2UL*HZ);
>   	return 0;
>   }
>   
> @@ -5339,6 +5353,26 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>   	memcg_wb_domain_size_changed(memcg);
>   }
>   
> +void mem_cgroup_flush_stats(void)
> +{
> +	if (!spin_trylock(&stats_flush_lock))
> +		return;
> +
> +	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> +	spin_unlock(&stats_flush_lock);
> +}
> +
> +static void flush_memcg_stats_dwork(struct work_struct *w)
> +{
> +	mem_cgroup_flush_stats();
> +	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, 2UL*HZ);
> +}
> +
> +static void flush_memcg_stats_work(struct work_struct *w)
> +{
> +	mem_cgroup_flush_stats();
> +}
> +
>   static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a7602f71ec04..1cc05ab8ca15 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2893,6 +2893,12 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>   	target_lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup, pgdat);
>   
>   again:
> +	/*
> +	 * Flush the memory cgroup stats, so that we read accurate per-memcg
> +	 * lruvec stats for heuristics.
> +	 */
> +	mem_cgroup_flush_stats();
> +
>   	memset(&sc->nr, 0, sizeof(sc->nr));
>   
>   	nr_reclaimed = sc->nr_reclaimed;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

