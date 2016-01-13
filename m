From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/7] mm: vmscan: pass memcg to get_scan_count()
Date: Wed, 13 Jan 2016 17:47:14 +0100
Message-ID: <20160113164713.GF17512@dhcp22.suse.cz>
References: <cover.1450352791.git.vdavydov@virtuozzo.com>
 <daacf7e0dbe2ba11ed44facc36ac2fed3546ffe0.1450352792.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <daacf7e0dbe2ba11ed44facc36ac2fed3546ffe0.1450352792.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 17-12-15 15:29:55, Vladimir Davydov wrote:
> memcg will come in handy in get_scan_count(). It can already be used for
> getting swappiness immediately in get_scan_count() instead of passing it
> around. The following patches will add more memcg-related values, which
> will be used there.

OK, the down side would be that every user (even outside of memcg
proper) has to be aware that the memcg might be NULL but this makes
the code a bit easier so...

> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/vmscan.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bb01b04154ad..acc6bff84e26 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1957,10 +1957,11 @@ enum scan_balance {
>   * nr[0] = anon inactive pages to scan; nr[1] = anon active pages to scan
>   * nr[2] = file inactive pages to scan; nr[3] = file active pages to scan
>   */
> -static void get_scan_count(struct lruvec *lruvec, int swappiness,
> +static void get_scan_count(struct lruvec *lruvec, struct mem_cgroup *memcg,
>  			   struct scan_control *sc, unsigned long *nr,
>  			   unsigned long *lru_pages)
>  {
> +	int swappiness = mem_cgroup_swappiness(memcg);
>  	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
>  	u64 fraction[2];
>  	u64 denominator = 0;	/* gcc */
> @@ -2184,9 +2185,10 @@ static inline void init_tlb_ubc(void)
>  /*
>   * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
>   */
> -static void shrink_lruvec(struct lruvec *lruvec, int swappiness,
> -			  struct scan_control *sc, unsigned long *lru_pages)
> +static void shrink_zone_memcg(struct zone *zone, struct mem_cgroup *memcg,
> +			      struct scan_control *sc, unsigned long *lru_pages)
>  {
> +	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
>  	unsigned long nr[NR_LRU_LISTS];
>  	unsigned long targets[NR_LRU_LISTS];
>  	unsigned long nr_to_scan;
> @@ -2196,7 +2198,7 @@ static void shrink_lruvec(struct lruvec *lruvec, int swappiness,
>  	struct blk_plug plug;
>  	bool scan_adjusted;
>  
> -	get_scan_count(lruvec, swappiness, sc, nr, lru_pages);
> +	get_scan_count(lruvec, memcg, sc, nr, lru_pages);
>  
>  	/* Record the original scan target for proportional adjustments later */
>  	memcpy(targets, nr, sizeof(nr));
> @@ -2400,8 +2402,6 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  			unsigned long lru_pages;
>  			unsigned long reclaimed;
>  			unsigned long scanned;
> -			struct lruvec *lruvec;
> -			int swappiness;
>  
>  			if (mem_cgroup_low(root, memcg)) {
>  				if (!sc->may_thrash)
> @@ -2409,12 +2409,10 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  				mem_cgroup_events(memcg, MEMCG_LOW, 1);
>  			}
>  
> -			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> -			swappiness = mem_cgroup_swappiness(memcg);
>  			reclaimed = sc->nr_reclaimed;
>  			scanned = sc->nr_scanned;
>  
> -			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
> +			shrink_zone_memcg(zone, memcg, sc, &lru_pages);
>  			zone_lru_pages += lru_pages;
>  
>  			if (memcg && is_classzone)
> @@ -2884,8 +2882,6 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
>  		.may_unmap = 1,
>  		.may_swap = !noswap,
>  	};
> -	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> -	int swappiness = mem_cgroup_swappiness(memcg);
>  	unsigned long lru_pages;
>  
>  	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> @@ -2902,7 +2898,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
>  	 * will pick up pages from other mem cgroup's as well. We hack
>  	 * the priority and make it zero.
>  	 */
> -	shrink_lruvec(lruvec, swappiness, &sc, &lru_pages);
> +	shrink_zone_memcg(zone, memcg, &sc, &lru_pages);
>  
>  	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
