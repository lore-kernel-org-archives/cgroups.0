From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 2/9] memcg: rename mem_cgroup_flush_stats_"delayed" to
 "ratelimited"
Date: Wed, 29 Mar 2023 13:56:04 +0200
Message-ID: <ZCQnVNH9NMg4D9TB@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680090965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MgoqW9i5PP+a88cpUieall/Y5VXNVR+ZmdLSTwQcCUk=;
        b=gPDY7Zoa+PX03ws7DqJY76AlRsJnW8njixlmMYQFSry0Sm7LYXBffaSrEiEddrRh93lQ4b
        ta0+tMP2rFqm3q5t+9Dfe+XUHMrnimp8Y7siBb2qRrh+CyK+th4RsUG//OZ8FQ4e5R54q8
        ObR9oKGkhhZrGoyU+nMqPxNH4q//bhU=
Content-Disposition: inline
In-Reply-To: <20230328221644.803272-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 28-03-23 22:16:37, Yosry Ahmed wrote:
> mem_cgroup_flush_stats_delayed() suggests his is using a delayed_work,
> but this is actually sometimes flushing directly from the callsite.
> 
> What it's doing is ratelimited calls. A better name would be
> mem_cgroup_flush_stats_ratelimited().
> 
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  include/linux/memcontrol.h | 4 ++--
>  mm/memcontrol.c            | 2 +-
>  mm/workingset.c            | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b6eda2ab205d..ac3f3b3a45e2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1037,7 +1037,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  }
>  
>  void mem_cgroup_flush_stats(void);
> -void mem_cgroup_flush_stats_delayed(void);
> +void mem_cgroup_flush_stats_ratelimited(void);
>  
>  void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
>  			      int val);
> @@ -1535,7 +1535,7 @@ static inline void mem_cgroup_flush_stats(void)
>  {
>  }
>  
> -static inline void mem_cgroup_flush_stats_delayed(void)
> +static inline void mem_cgroup_flush_stats_ratelimited(void)
>  {
>  }
>  
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0205e58ea430..c3b6aae78901 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -653,7 +653,7 @@ void mem_cgroup_flush_stats(void)
>  		__mem_cgroup_flush_stats();
>  }
>  
> -void mem_cgroup_flush_stats_delayed(void)
> +void mem_cgroup_flush_stats_ratelimited(void)
>  {
>  	if (time_after64(jiffies_64, flush_next_time))
>  		mem_cgroup_flush_stats();
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 00c6f4d9d9be..af862c6738c3 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -462,7 +462,7 @@ void workingset_refault(struct folio *folio, void *shadow)
>  
>  	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
>  
> -	mem_cgroup_flush_stats_delayed();
> +	mem_cgroup_flush_stats_ratelimited();
>  	/*
>  	 * Compare the distance to the existing workingset size. We
>  	 * don't activate pages that couldn't stay resident even if
> -- 
> 2.40.0.348.gf938b09366-goog

-- 
Michal Hocko
SUSE Labs
