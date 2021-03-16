From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: switch to rstat fix
Date: Tue, 16 Mar 2021 10:30:54 +0100
Message-ID: <YFB6zkqXx+Z+pO+q@dhcp22.suse.cz>
References: <20210315234100.64307-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615887056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lBGk+Iyq4CVjb4mLe0kBH+gokhgg7ZND2EOk7K2C61E=;
        b=JlKA6J2mMwOl6dNyPKwczKNqW5ujsCX/JNcnjD9w/a3KbTDxWdeRveY6v+nSQvzPy7cTga
        3jKZunIC3Fc8DEWQ6ZbMVPbPVTw1NjyL651SN0ROIRokZhD4hOlgVvuTLtujB+qwZOCFh+
        dXNnU/vEJ9SzwTymxFR0IdP57NeyXro=
Content-Disposition: inline
In-Reply-To: <20210315234100.64307-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon 15-03-21 19:41:00, Johannes Weiner wrote:
> Fix a sleep in atomic section problem: wb_writeback() takes a spinlock
> and calls wb_over_bg_thresh() -> mem_cgroup_wb_stats, but the regular
> rstat flushing function called from in there does lockbreaking and may
> sleep. Switch to the atomic variant, cgroup_rstat_irqsafe().
> 
> To be consistent with other memcg flush calls, but without adding
> another memcg wrapper, inline and drop memcg_flush_vmstats() instead.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f7fb12d3c2fc..9091913ec877 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -757,11 +757,6 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
>  	return mz;
>  }
>  
> -static void memcg_flush_vmstats(struct mem_cgroup *memcg)
> -{
> -	cgroup_rstat_flush(memcg->css.cgroup);
> -}
> -
>  /**
>   * __mod_memcg_state - update cgroup memory statistics
>   * @memcg: the memory cgroup
> @@ -1572,7 +1567,7 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
>  	 *
>  	 * Current memory state:
>  	 */
> -	memcg_flush_vmstats(memcg);
> +	cgroup_rstat_flush(memcg->css.cgroup);
>  
>  	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
>  		u64 size;
> @@ -3523,7 +3518,7 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
>  	unsigned long val;
>  
>  	if (mem_cgroup_is_root(memcg)) {
> -		memcg_flush_vmstats(memcg);
> +		cgroup_rstat_flush(memcg->css.cgroup);
>  		val = memcg_page_state(memcg, NR_FILE_PAGES) +
>  			memcg_page_state(memcg, NR_ANON_MAPPED);
>  		if (swap)
> @@ -3925,7 +3920,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>  	int nid;
>  	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
>  
> -	memcg_flush_vmstats(memcg);
> +	cgroup_rstat_flush(memcg->css.cgroup);
>  
>  	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
>  		seq_printf(m, "%s=%lu", stat->name,
> @@ -3997,7 +3992,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
>  
> -	memcg_flush_vmstats(memcg);
> +	cgroup_rstat_flush(memcg->css.cgroup);
>  
>  	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
>  		unsigned long nr;
> @@ -4500,7 +4495,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
>  	struct mem_cgroup *parent;
>  
> -	memcg_flush_vmstats(memcg);
> +	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
>  
>  	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
>  	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
> -- 
> 2.30.1

-- 
Michal Hocko
SUSE Labs
