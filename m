From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: optimize per-lruvec stats counter memory
 usage
Date: Mon, 7 Dec 2020 13:36:05 +0100
Message-ID: <20201207123605.GH25569@dhcp22.suse.cz>
References: <20201206085639.12627-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1607344567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rvs081RAGQPaFquBIFuFiPgtjv7glx+tVrBE85otOnw=;
        b=Eugiw6R2M3d1tGTGOVHNaxSZUo0OJvOH6z4OoBj3eg9W37zRl8JNEYrEQaCdQg7pgiLFRr
        3nm+3Dm6QgbPfpeXJZBLKD6S3UW6dUUENnu9me6G8pZOi6kOP8DXosWxYHw1VwuKdpS+TB
        3MJU7FKpT3t/nNHLNSZjswHItP6saVc=
Content-Disposition: inline
In-Reply-To: <20201206085639.12627-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun 06-12-20 16:56:39, Muchun Song wrote:
> The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
> of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
> to optimize memory usage.

How much savings are we talking about here? I am not deeply familiar
with the pcp allocator but can it compact smaller data types much
better?

> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 6 +++++-
>  mm/memcontrol.c            | 2 +-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index f9a496c4eac7..34cf119976b1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -92,6 +92,10 @@ struct lruvec_stat {
>  	long count[NR_VM_NODE_STAT_ITEMS];
>  };
>  
> +struct per_cpu_lruvec_stat {
> +	s32 count[NR_VM_NODE_STAT_ITEMS];
> +};
> +
>  /*
>   * Bitmap of shrinker::id corresponding to memcg-aware shrinkers,
>   * which have elements charged to this memcg.
> @@ -111,7 +115,7 @@ struct mem_cgroup_per_node {
>  	struct lruvec_stat __percpu *lruvec_stat_local;
>  
>  	/* Subtree VM stats (batched updates) */
> -	struct lruvec_stat __percpu *lruvec_stat_cpu;
> +	struct per_cpu_lruvec_stat __percpu *lruvec_stat_cpu;
>  	atomic_long_t		lruvec_stat[NR_VM_NODE_STAT_ITEMS];
>  
>  	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 49fbcf003bf5..c874ea37b05d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5184,7 +5184,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>  		return 1;
>  	}
>  
> -	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct lruvec_stat,
> +	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct per_cpu_lruvec_stat,
>  					       GFP_KERNEL_ACCOUNT);
>  	if (!pn->lruvec_stat_cpu) {
>  		free_percpu(pn->lruvec_stat_local);
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
