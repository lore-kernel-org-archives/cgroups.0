From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [patch 3/3] mm: memcontrol: continue cache reclaim from offlined
 groups
Date: Mon, 22 Sep 2014 12:32:04 +0400
Message-ID: <20140922083204.GC18526@esperanza>
References: <1411243235-24680-1-git-send-email-hannes@cmpxchg.org>
 <1411243235-24680-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1411243235-24680-4-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 04:00:35PM -0400, Johannes Weiner wrote:
> On cgroup deletion, outstanding page cache charges are moved to the
> parent group so that they're not lost and can be reclaimed during
> pressure on/inside said parent.  But this reparenting is fairly tricky
> and its synchroneous nature has led to several lock-ups in the past.
> 
> Since css iterators now also include offlined css, memcg iterators can
> be changed to include offlined children during reclaim of a group, and
> leftover cache can just stay put.
> 
> There is a slight change of behavior in that charges of deleted groups
> no longer show up as local charges in the parent.  But they are still
> included in the parent's hierarchical statistics.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 260 ++------------------------------------------------------
>  1 file changed, 5 insertions(+), 255 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 019a44ac25d6..48531433a2fc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -736,8 +736,6 @@ static void disarm_static_keys(struct mem_cgroup *memcg)
>  	disarm_kmem_keys(memcg);
>  }
>  
> -static void drain_all_stock_async(struct mem_cgroup *memcg);
> -
>  static struct mem_cgroup_per_zone *
>  mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
>  {
> @@ -1208,7 +1206,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  				goto out_unlock;
>  			continue;
>  		}
> -		if (css == &root->css || css_tryget_online(css)) {
> +		if (css == &root->css || css_tryget(css)) {
>  			memcg = mem_cgroup_from_css(css);
>  			break;
>  		}
> @@ -2349,10 +2347,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>   * of the hierarchy under it. sync flag says whether we should block

Please update the comment.

>   * until the work is done.
>   */
> -static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
> +static void drain_all_stock(struct mem_cgroup *root_memcg)
>  {
>  	int cpu, curcpu;
>  
> +	if (!mutex_trylock(&percpu_charge_mutex))
> +		return;

It's not obvious why we need it here. The old code has an explanatory
comment. Could you please add one?

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
