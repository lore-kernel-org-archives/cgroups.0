From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 2/3] memcg: restructure mem_cgroup_iter()
Date: Tue, 4 Jun 2013 15:21:20 +0200
Message-ID: <20130604132120.GG31242@dhcp22.suse.cz>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370306679-13129-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Mon 03-06-13 17:44:38, Tejun Heo wrote:
> mem_cgroup_iter() implements two iteration modes - plain and reclaim.
> The former is normal pre-order tree walk.  The latter tries to share
> iteration cursor per zone and priority pair among multiple reclaimers
> so that they all contribute to scanning forward rather than banging on
> the same cgroups simultaneously.
> 
> Implementing the two in the same function allows them to share code
> paths which is fine but the current structure is unnecessarily
> convoluted with conditionals on @reclaim spread across the function
> rather obscurely and with a somewhat strange control flow which checks
> for conditions which can't be and has duplicate tests for the same
> conditions in different forms.
> 
> This patch restructures the function such that there's single test on
> @reclaim and !reclaim path is contained in its block, which simplifies
> both !reclaim and reclaim paths.  Also, the control flow in the
> reclaim path is restructured and commented so that it's easier to
> follow what's going on why.
> 
> Note that after the patch reclaim->generation is synchronized to the
> iter's on success whether @prev was specified or not.  This doesn't
> cause any functional differences as the two generation numbers are
> guaranteed to be the same at that point if @prev and makes the code
> slightly easier to follow.
> 
> This patch is pure restructuring and shouldn't introduce any
> functional differences.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  mm/memcontrol.c | 131 ++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 71 insertions(+), 60 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index cb2f91c..99e7357 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1170,8 +1170,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  				   struct mem_cgroup_reclaim_cookie *reclaim)
>  {
>  	struct mem_cgroup *memcg = NULL;
> -	struct mem_cgroup *last_visited = NULL;
> -	unsigned long uninitialized_var(dead_count);
> +	struct mem_cgroup_per_zone *mz;
> +	struct mem_cgroup_reclaim_iter *iter;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
> @@ -1179,9 +1179,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	if (!root)
>  		root = root_mem_cgroup;
>  
> -	if (prev && !reclaim)
> -		last_visited = prev;
> -
>  	if (!root->use_hierarchy && root != root_mem_cgroup) {
>  		if (prev)
>  			goto out_css_put;
> @@ -1189,73 +1186,87 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	}
>  
>  	rcu_read_lock();
> -	while (!memcg) {
> -		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
> -
> -		if (reclaim) {
> -			int nid = zone_to_nid(reclaim->zone);
> -			int zid = zone_idx(reclaim->zone);
> -			struct mem_cgroup_per_zone *mz;
> -
> -			mz = mem_cgroup_zoneinfo(root, nid, zid);
> -			iter = &mz->reclaim_iter[reclaim->priority];
> -			last_visited = iter->last_visited;
> -			if (prev && reclaim->generation != iter->generation) {
> -				iter->last_visited = NULL;
> -				goto out_unlock;
> -			}
>  
> +	/* non reclaim case is simple - just iterate from @prev */
> +	if (!reclaim) {
> +		memcg = __mem_cgroup_iter_next(root, prev);
> +		goto out_unlock;
> +	}

I do not have objections for pulling !reclaim case like this, but could
you base this on top of the patch which adds predicates into the
operators, please?

[...]
-- 
Michal Hocko
SUSE Labs
