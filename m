From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v4 2/4] mm: memcg: add a helper for non-unified stats
 flushing
Date: Mon, 4 Sep 2023 16:45:14 +0200
Message-ID: <ZPXtejIUIKg/IyZ6@dhcp22.suse.cz>
References: <20230831165611.2610118-1-yosryahmed@google.com>
 <20230831165611.2610118-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1693838715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vSixAjVtVtfBwEqUtETr7utTBGs453Bf8e7AyvXCIfg=;
        b=hnXnfiKkyovgWnaOElnC8H6D5iP+jTVvwybpfB2qyJcRyAQnX37i2H2bAOqzxktGv28NjF
        96YNowWYuMT2KNQPWD80TK1qkpQ0HJEHQqtJOujInksPH5N+atrrezecobwiJvuS50Oa0o
        Q0hwb+MovOybiYKL20NWwduVbXq/2N4=
Content-Disposition: inline
In-Reply-To: <20230831165611.2610118-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 31-08-23 16:56:09, Yosry Ahmed wrote:
> Some contexts flush memcg stats outside of unified flushing, directly
> using cgroup_rstat_flush(). Add a helper for non-unified flushing, a
> counterpart for do_unified_stats_flush(), and use it in those contexts,
> as well as in do_unified_stats_flush() itself.
> 
> This abstracts the rstat API and makes it easy to introduce
> modifications to either unified or non-unified flushing functions
> without changing callers.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2d0ec828a1c4..8c046feeaae7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -639,6 +639,17 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  	}
>  }
>  
> +/*
> + * do_stats_flush - do a flush of the memory cgroup statistics
> + * @memcg: memory cgroup to flush
> + *
> + * Only flushes the subtree of @memcg, does not skip under any conditions.
> + */
> +static void do_stats_flush(struct mem_cgroup *memcg)
> +{
> +	cgroup_rstat_flush(memcg->css.cgroup);
> +}
> +
>  /*
>   * do_unified_stats_flush - do a unified flush of memory cgroup statistics
>   *
> @@ -656,7 +667,7 @@ static void do_unified_stats_flush(void)
>  
>  	WRITE_ONCE(flush_next_time, jiffies_64 + 2*FLUSH_TIME);
>  
> -	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);
> +	do_stats_flush(root_mem_cgroup);
>  
>  	atomic_set(&stats_flush_threshold, 0);
>  	atomic_set(&stats_unified_flush_ongoing, 0);
> @@ -7790,7 +7801,7 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
>  			break;
>  		}
>  
> -		cgroup_rstat_flush(memcg->css.cgroup);
> +		do_stats_flush(memcg);
>  		pages = memcg_page_state(memcg, MEMCG_ZSWAP_B) / PAGE_SIZE;
>  		if (pages < max)
>  			continue;
> @@ -7855,8 +7866,10 @@ void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size)
>  static u64 zswap_current_read(struct cgroup_subsys_state *css,
>  			      struct cftype *cft)
>  {
> -	cgroup_rstat_flush(css->cgroup);
> -	return memcg_page_state(mem_cgroup_from_css(css), MEMCG_ZSWAP_B);
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +
> +	do_stats_flush(memcg);
> +	return memcg_page_state(memcg, MEMCG_ZSWAP_B);
>  }
>  
>  static int zswap_max_show(struct seq_file *m, void *v)
> -- 
> 2.42.0.rc2.253.gd59a3bf2b4-goog

-- 
Michal Hocko
SUSE Labs
