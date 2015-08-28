From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/4] memcg: fix over-high reclaim amount
Date: Fri, 28 Aug 2015 19:06:13 +0200
Message-ID: <20150828170612.GA21463@dhcp22.suse.cz>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1440775530-18630-2-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

On Fri 28-08-15 11:25:27, Tejun Heo wrote:
> When memory usage is over the high limit, try_charge() performs direct
> reclaim; however, it uses the current charging amount @nr_pages as the
> reclamation target which is incorrect as we want to reclaim down to
> the high limit.  In practice, this doesn't matter all that much
> because the minimum target pages that try_to_free_mem_cgroup_pages()
> uses is SWAP_CLUSTER_MAX which is rather large.
> 
> Fix it by setting the target number of pages to the difference between
> the current usage and the high limit.

I do not think this a better behavior. If you have parallel charges to
the same memcg then you can easilly over-reclaim  because everybody
will reclaim the maximum rather than its contribution.

Sure we can fail to reclaim the target and slowly grow over high limit
but that is to be expected. This is not the max limit which cannot be
breached and external memory pressure/reclaim is there to mitigate that.

> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  mm/memcontrol.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aacc767..18ecf75 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2078,10 +2078,13 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * make the charging task trim their excess contribution.
>  	 */
>  	do {
> -		if (page_counter_read(&memcg->memory) <= memcg->high)
> +		unsigned long usage = page_counter_read(&memcg->memory);
> +		unsigned long high = ACCESS_ONCE(memcg->high);
> +
> +		if (usage <= high)
>  			continue;
>  		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
> -		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
> +		try_to_free_mem_cgroup_pages(memcg, high - usage, gfp_mask, true);
>  	} while ((memcg = parent_mem_cgroup(memcg)));
>  done:
>  	return ret;
> -- 
> 2.4.3

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
