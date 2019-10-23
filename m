From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 7/8] mm: vmscan: split shrink_node() into node part and
 memcgs part
Date: Wed, 23 Oct 2019 16:24:37 +0200
Message-ID: <20191023142437.GH17610@dhcp22.suse.cz>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191022144803.302233-8-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue 22-10-19 10:48:02, Johannes Weiner wrote:
> This function is getting long and unwieldy, split out the memcg bits.
> 
> The updated shrink_node() handles the generic (node) reclaim aspects:
>   - global vmpressure notifications
>   - writeback and congestion throttling
>   - reclaim/compaction management
>   - kswapd giving up on unreclaimable nodes
> 
> It then calls a new shrink_node_memcgs() which handles cgroup specifics:
>   - the cgroup tree traversal
>   - memory.low considerations
>   - per-cgroup slab shrinking callbacks
>   - per-cgroup vmpressure notifications
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/vmscan.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index db073b40c432..65baa89740dd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2722,18 +2722,10 @@ static bool pgdat_memcg_congested(pg_data_t *pgdat, struct mem_cgroup *memcg)
>  		(memcg && memcg_congested(pgdat, memcg));
>  }
>  
> -static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> +static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>  {
> -	struct reclaim_state *reclaim_state = current->reclaim_state;
>  	struct mem_cgroup *root = sc->target_mem_cgroup;
> -	unsigned long nr_reclaimed, nr_scanned;
> -	bool reclaimable = false;
>  	struct mem_cgroup *memcg;
> -again:
> -	memset(&sc->nr, 0, sizeof(sc->nr));
> -
> -	nr_reclaimed = sc->nr_reclaimed;
> -	nr_scanned = sc->nr_scanned;
>  
>  	memcg = mem_cgroup_iter(root, NULL, NULL);
>  	do {
> @@ -2786,6 +2778,22 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  			   sc->nr_reclaimed - reclaimed);
>  
>  	} while ((memcg = mem_cgroup_iter(root, memcg, NULL)));
> +}
> +
> +static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
> +{
> +	struct reclaim_state *reclaim_state = current->reclaim_state;
> +	struct mem_cgroup *root = sc->target_mem_cgroup;
> +	unsigned long nr_reclaimed, nr_scanned;
> +	bool reclaimable = false;
> +
> +again:
> +	memset(&sc->nr, 0, sizeof(sc->nr));
> +
> +	nr_reclaimed = sc->nr_reclaimed;
> +	nr_scanned = sc->nr_scanned;
> +
> +	shrink_node_memcgs(pgdat, sc);
>  
>  	if (reclaim_state) {
>  		sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> @@ -2793,7 +2801,7 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
>  	}
>  
>  	/* Record the subtree's reclaim efficiency */
> -	vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
> +	vmpressure(sc->gfp_mask, root, true,
>  		   sc->nr_scanned - nr_scanned,
>  		   sc->nr_reclaimed - nr_reclaimed);
>  
> -- 
> 2.23.0
> 

-- 
Michal Hocko
SUSE Labs
