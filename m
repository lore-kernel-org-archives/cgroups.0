From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v13 10/16] vmscan: shrink slab on memcg pressure
Date: Tue, 10 Dec 2013 13:11:52 +1100
Message-ID: <20131210021152.GZ31386@dastard>
References: <cover.1386571280.git.vdavydov@parallels.com>
 <24314b9f3b299bac988ea3570f71f9e6919bbc4e.1386571280.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <24314b9f3b299bac988ea3570f71f9e6919bbc4e.1386571280.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Mon, Dec 09, 2013 at 12:05:51PM +0400, Vladimir Davydov wrote:
> This patch makes direct reclaim path shrink slab not only on global
> memory pressure, but also when we reach the user memory limit of a
> memcg. To achieve that, it makes shrink_slab() walk over the memcg
> hierarchy and run shrinkers marked as memcg-aware on the target memcg
> and all its descendants. The memcg to scan is passed in a shrink_control
> structure; memcg-unaware shrinkers are still called only on global
> memory pressure with memcg=NULL. It is up to the shrinker how to
> organize the objects it is responsible for to achieve per-memcg reclaim.
> 
> The idea lying behind the patch as well as the initial implementation
> belong to Glauber Costa.
...
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -311,6 +311,58 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
>  	return freed;
>  }
>  
> +static unsigned long
> +run_shrinker(struct shrink_control *shrinkctl, struct shrinker *shrinker,
> +	     unsigned long nr_pages_scanned, unsigned long lru_pages)
> +{
> +	unsigned long freed = 0;
> +
> +	/*
> +	 * If we don't have a target mem cgroup, we scan them all. Otherwise
> +	 * we will limit our scan to shrinkers marked as memcg aware.
> +	 */
> +	if (!(shrinker->flags & SHRINKER_MEMCG_AWARE) &&
> +	    shrinkctl->target_mem_cgroup != NULL)
> +		return 0;
> +	/*
> +	 * In a hierarchical chain, it might be that not all memcgs are kmem
> +	 * active. kmemcg design mandates that when one memcg is active, its
> +	 * children will be active as well. But it is perfectly possible that
> +	 * its parent is not.
> +	 *
> +	 * We also need to make sure we scan at least once, for the global
> +	 * case. So if we don't have a target memcg, we proceed normally and
> +	 * expect to break in the next round.
> +	 */
> +	shrinkctl->memcg = shrinkctl->target_mem_cgroup;
> +	do {
> +		if (shrinkctl->memcg && !memcg_kmem_is_active(shrinkctl->memcg))
> +			goto next;
> +
> +		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
> +			shrinkctl->nid = 0;
> +			freed += shrink_slab_node(shrinkctl, shrinker,
> +					nr_pages_scanned, lru_pages);
> +			goto next;
> +		}
> +
> +		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
> +			if (node_online(shrinkctl->nid))
> +				freed += shrink_slab_node(shrinkctl, shrinker,
> +						nr_pages_scanned, lru_pages);
> +
> +		}
> +next:
> +		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE))
> +			break;
> +		shrinkctl->memcg = mem_cgroup_iter(shrinkctl->target_mem_cgroup,
> +						   shrinkctl->memcg, NULL);
> +	} while (shrinkctl->memcg);
> +
> +	return freed;
> +}

Ok, I think we need to improve the abstraction here, because I find
this quite messy and hard to follow the code flow differences
between memcg and non-memg shrinker invocations..

> +
>  /*
>   * Call the shrink functions to age shrinkable caches
>   *
> @@ -352,20 +404,10 @@ unsigned long shrink_slab(struct shrink_control *shrinkctl,
>  	}
>  
>  	list_for_each_entry(shrinker, &shrinker_list, list) {
> -		if (!(shrinker->flags & SHRINKER_NUMA_AWARE)) {
> -			shrinkctl->nid = 0;
> -			freed += shrink_slab_node(shrinkctl, shrinker,
> -					nr_pages_scanned, lru_pages);
> -			continue;
> -		}
> -
> -		for_each_node_mask(shrinkctl->nid, shrinkctl->nodes_to_scan) {
> -			if (node_online(shrinkctl->nid))
> -				freed += shrink_slab_node(shrinkctl, shrinker,
> -						nr_pages_scanned, lru_pages);
> -
> -		}

This code is the "run_shrinker()" helper function, not the entire
memcg loop.

> +		freed += run_shrinker(shrinkctl, shrinker,
> +				      nr_pages_scanned, lru_pages);
>  	}

i.e. the shrinker execution control loop becomes much clearer if
we separate the memcg and non-memcg shrinker execution from the
node awareness of the shrinker like so:

	list_for_each_entry(shrinker, &shrinker_list, list) {

		/*
		 * If we aren't doing targeted memcg shrinking, then run
		 * the shrinker with a global context and move on.
		 */
		if (!shrinkctl->target_mem_cgroup) {
			freed += run_shrinker(shrinkctl, shrinker,
					      nr_pages_scanned, lru_pages);
			continue;
		}

		if (!(shrinker->flags & SHRINKER_MEMCG_AWARE))
			continue;

		/*
		 * memcg shrinking: Iterate the target memcg heirarchy
		 * and run the shrinker on each memcg context that
		 * is found in the heirarchy.
		 */
		shrinkctl->memcg = shrinkctl->target_mem_cgroup;
		do {
			if (memcg_kmem_is_active(shrinkctl->memcg))
				continue;

			freed += run_shrinker(shrinkctl, shrinker,
					      nr_pages_scanned, lru_pages);
		while ((shrinkctl->memcg =
				mem_cgroup_iter(shrinkctl->target_mem_cgroup,
						shrinkctl->memcg, NULL)));
	}

That makes the code much easier to read and clearly demonstrates the
differences betwen non-memcg and memcg shrinking contexts, and
separates them cleanly from the shrinker implementation.  IMO,
that's much nicer than trying to handle all contexts in the one
do-while loop.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
