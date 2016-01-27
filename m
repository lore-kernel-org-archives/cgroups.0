From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH 5/5] mm: workingset: per-cgroup cache thrash detection
Date: Wed, 27 Jan 2016 17:58:27 +0300
Message-ID: <20160127145827.GE9623@esperanza>
References: <1453842006-29265-1-git-send-email-hannes@cmpxchg.org>
 <1453842006-29265-6-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453842006-29265-6-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Jan 26, 2016 at 04:00:06PM -0500, Johannes Weiner wrote:
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index b14a2bb33514..1cf3065c143b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -317,6 +317,7 @@ extern void lru_cache_add_active_or_unevictable(struct page *page,
>  
>  /* linux/mm/vmscan.c */
>  extern unsigned long zone_reclaimable_pages(struct zone *zone);
> +extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru);

Better declare it in mm/internal.h? And is there any point in renaming
it?

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 953f0f984392..864e237f32d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -202,11 +207,20 @@ static void unpack_shadow(void *shadow, struct zone **zonep,
>   */
>  void *workingset_eviction(struct address_space *mapping, struct page *page)
>  {
> +	struct mem_cgroup *memcg = page_memcg(page);
>  	struct zone *zone = page_zone(page);
> +	int memcgid = mem_cgroup_id(memcg);

This will crash in case memcg is disabled via boot param.

Thanks,
Vladimir
