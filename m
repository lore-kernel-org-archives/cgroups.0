From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 03/10] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Date: Tue, 3 Jun 2014 15:20:29 +0200
Message-ID: <20140603132029.GI1321@dhcp22.suse.cz>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
 <1401380162-24121-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1401380162-24121-4-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 29-05-14 12:15:55, Johannes Weiner wrote:
> There is no reason why oom-disabled and __GFP_NOFAIL charges should
> try to reclaim only once when every other charge tries several times
> before giving up.  Make them all retry the same number of times.

I have mentioned that already with the last iteration of the patch.
This can make THP charges stall unnecessarily when the allocation could
fall back to single page charges.
MEM_CGROUP_RECLAIM_RETRIES * SWAP_CLUSTER_MAX + CHARGE_BATCH * CPUS
reclaimed pages will not help for huge pages so multiple reclaims is
just pointless waisting of time.

I think you should just move the next patch in the series up and simply make
the thp charge __GFP_NORETRY:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b3a6deed66d5..ba822c27a55b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3703,10 +3703,13 @@ int mem_cgroup_charge_anon(struct page *page,
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 		/*
-		 * Never OOM-kill a process for a huge page.  The
-		 * fault handler will fall back to regular pages.
+		 * Never OOM-kill a process for a huge page. Also do not
+		 * reclaim memcg too much because it wouldn't help the
+		 * huge page charge anyway.
+		 * The fault handler will fall back to regular pages.
 		 */
 		oom = false;
+		gfp_mask |= __GFP_NORETRY;
 	}
 
 	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages, oom);


> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 46b3e37542ad..e8d5075c081f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2567,7 +2567,7 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  				 bool oom)
>  {
>  	unsigned int batch = max(CHARGE_BATCH, nr_pages);
> -	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>  	struct mem_cgroup *mem_over_limit;
>  	struct res_counter *fail_res;
>  	unsigned long nr_reclaimed;
> @@ -2639,6 +2639,9 @@ retry:
>  	if (mem_cgroup_wait_acct_move(mem_over_limit))
>  		goto retry;
>  
> +	if (nr_retries--)
> +		goto retry;
> +
>  	if (gfp_mask & __GFP_NOFAIL)
>  		goto bypass;
>  
> @@ -2648,9 +2651,6 @@ retry:
>  	if (!oom)
>  		goto nomem;
>  
> -	if (nr_oom_retries--)
> -		goto retry;
> -
>  	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
>  nomem:
>  	if (!(gfp_mask & __GFP_NOFAIL))
> -- 
> 1.9.3
> 

-- 
Michal Hocko
SUSE Labs
