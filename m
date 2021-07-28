From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup racy sum avoidance code
Date: Wed, 28 Jul 2021 10:21:18 +0200
Message-ID: <8c35e469-b355-63b0-6cd4-ca39c39ddb79@redhat.com>
References: <20210728012243.3369123-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627460482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gWJqZpysylhm0r71/CN5q60nzTxNxEk/7whHXN4TyA=;
        b=fiF/vVqd9oN9e8dKNjUyYg0xm31UqV7R5Oqq9jjFaG7gd1TWS3PesPtjH8OueLizybbAk1
        VklP1xeyESVL10k13r9S5dx/Xo6Bk/DIa+Eh2T4JpCn36EWukF4X4xJdq/0ppKCcGi5Dns
        hpCvByTiWRFA1ki7zCT2xYF9p1MBy00=
In-Reply-To: <20210728012243.3369123-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 28.07.21 03:22, Shakeel Butt wrote:
> We used to have per-cpu memcg and lruvec stats and the readers have to
> traverse and sum the stats from each cpu. This summing was racy and may
> expose transient negative values. So, an explicit check was added to
> avoid such scenarios. Now these stats are moved to rstat infrastructure
> and are no more per-cpu, so we can remove the fixup for transient
> negative values.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/memcontrol.h | 15 ++-------------
>   1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7028d8e4a3d7..5f2a39a43d47 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -991,30 +991,19 @@ static inline void mod_memcg_state(struct mem_cgroup *memcg,
>   
>   static inline unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
>   {
> -	long x = READ_ONCE(memcg->vmstats.state[idx]);
> -#ifdef CONFIG_SMP
> -	if (x < 0)
> -		x = 0;
> -#endif
> -	return x;
> +	return READ_ONCE(memcg->vmstats.state[idx]);
>   }
>   
>   static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
>   					      enum node_stat_item idx)
>   {
>   	struct mem_cgroup_per_node *pn;
> -	long x;
>   
>   	if (mem_cgroup_disabled())
>   		return node_page_state(lruvec_pgdat(lruvec), idx);
>   
>   	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> -	x = READ_ONCE(pn->lruvec_stats.state[idx]);
> -#ifdef CONFIG_SMP
> -	if (x < 0)
> -		x = 0;
> -#endif
> -	return x;
> +	return READ_ONCE(pn->lruvec_stats.state[idx]);
>   }
>   
>   static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> 

Reviewed-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Thanks,

David / dhildenb

