From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcontrol: factor out reclaim iterator loading
 and updating
Date: Thu, 6 Jun 2013 10:29:47 +0200
Message-ID: <20130606082947.GD7909@dhcp22.suse.cz>
References: <1370472826-29959-1-git-send-email-hannes@cmpxchg.org>
 <1370472826-29959-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370472826-29959-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 05-06-13 18:53:46, Johannes Weiner wrote:
> mem_cgroup_iter() is too hard to follow.  Factor out the lockless
> reclaim iterator loading and updating so it's easier to follow the big
> picture.
> 
> Also document the iterator invalidation mechanism a bit more
> extensively.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

I like this
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 86 ++++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 57 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2cbb44..23a9236 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1148,6 +1148,58 @@ skip_node:
>  	return NULL;
>  }
>  
> +static void mem_cgroup_iter_invalidate(struct mem_cgroup *root)
> +{
> +	/*
> +	 * When a group in the hierarchy below root is destroyed, the
> +	 * hierarchy iterator can no longer be trusted since it might
> +	 * have pointed to the destroyed group.  Invalidate it.
> +	 */
> +	atomic_inc(&root->dead_count);
> +}
> +
> +static struct mem_cgroup *
> +mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
> +		     struct mem_cgroup *root,
> +		     int *sequence)
> +{
> +	struct mem_cgroup *position = NULL;
> +	/*
> +	 * A cgroup destruction happens in two stages: offlining and
> +	 * release.  They are separated by a RCU grace period.
> +	 *
> +	 * If the iterator is valid, we may still race with an
> +	 * offlining.  The RCU lock ensures the object won't be
> +	 * released, tryget will fail if we lost the race.
> +	 */
> +	*sequence = atomic_read(&root->dead_count);
> +	if (iter->last_dead_count == *sequence) {
> +		smp_rmb();
> +		position = iter->last_visited;
> +		if (position && !css_tryget(&position->css))
> +			position = NULL;
> +	}
> +	return position;
> +}
> +
> +static void mem_cgroup_iter_update(struct mem_cgroup_reclaim_iter *iter,
> +				   struct mem_cgroup *last_visited,
> +				   struct mem_cgroup *new_position,
> +				   int sequence)
> +{
> +	if (last_visited)
> +		css_put(&last_visited->css);
> +	/*
> +	 * We store the sequence count from the time @last_visited was
> +	 * loaded successfully instead of rereading it here so that we
> +	 * don't lose destruction events in between.  We could have
> +	 * raced with the destruction of @new_position after all.
> +	 */
> +	iter->last_visited = new_position;
> +	smp_wmb();
> +	iter->last_dead_count = sequence;
> +}
> +
>  /**
>   * mem_cgroup_iter - iterate over memory cgroup hierarchy
>   * @root: hierarchy root
> @@ -1171,7 +1223,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  {
>  	struct mem_cgroup *memcg = NULL;
>  	struct mem_cgroup *last_visited = NULL;
> -	unsigned long uninitialized_var(dead_count);
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
> @@ -1191,6 +1242,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	rcu_read_lock();
>  	while (!memcg) {
>  		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
> +		int uninitialized_var(seq);
>  
>  		if (reclaim) {
>  			int nid = zone_to_nid(reclaim->zone);
> @@ -1204,37 +1256,13 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  				goto out_unlock;
>  			}
>  
> -			/*
> -			 * If the dead_count mismatches, a destruction
> -			 * has happened or is happening concurrently.
> -			 * If the dead_count matches, a destruction
> -			 * might still happen concurrently, but since
> -			 * we checked under RCU, that destruction
> -			 * won't free the object until we release the
> -			 * RCU reader lock.  Thus, the dead_count
> -			 * check verifies the pointer is still valid,
> -			 * css_tryget() verifies the cgroup pointed to
> -			 * is alive.
> -			 */
> -			dead_count = atomic_read(&root->dead_count);
> -			if (dead_count == iter->last_dead_count) {
> -				smp_rmb();
> -				last_visited = iter->last_visited;
> -				if (last_visited &&
> -				    !css_tryget(&last_visited->css))
> -					last_visited = NULL;
> -			}
> +			last_visited = mem_cgroup_iter_load(iter, root, &seq);
>  		}
>  
>  		memcg = __mem_cgroup_iter_next(root, last_visited);
>  
>  		if (reclaim) {
> -			if (last_visited)
> -				css_put(&last_visited->css);
> -
> -			iter->last_visited = memcg;
> -			smp_wmb();
> -			iter->last_dead_count = dead_count;
> +			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
>  
>  			if (!memcg)
>  				iter->generation++;
> @@ -6319,14 +6347,14 @@ static void mem_cgroup_invalidate_reclaim_iterators(struct mem_cgroup *memcg)
>  	struct mem_cgroup *parent = memcg;
>  
>  	while ((parent = parent_mem_cgroup(parent)))
> -		atomic_inc(&parent->dead_count);
> +		mem_cgroup_iter_invalidate(parent);
>  
>  	/*
>  	 * if the root memcg is not hierarchical we have to check it
>  	 * explicitely.
>  	 */
>  	if (!root_mem_cgroup->use_hierarchy)
> -		atomic_inc(&root_mem_cgroup->dead_count);
> +		mem_cgroup_iter_invalidate(root_mem_cgroup);
>  }
>  
>  static void mem_cgroup_css_offline(struct cgroup *cont)
> -- 
> 1.8.3
> 

-- 
Michal Hocko
SUSE Labs
