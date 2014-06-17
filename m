From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 04/12] mm: memcontrol: retry reclaim for oom-disabled and
 __GFP_NOFAIL charges
Date: Tue, 17 Jun 2014 15:53:44 +0200
Message-ID: <20140617135344.GC19886@dhcp22.suse.cz>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-5-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1402948472-8175-5-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 16-06-14 15:54:24, Johannes Weiner wrote:
> There is no reason why oom-disabled and __GFP_NOFAIL charges should
> try to reclaim only once when every other charge tries several times
> before giving up.  Make them all retry the same number of times.

OK, this makes sense for oom-disabled and __GFP_NOFAIL but does it make
sense to do additional reclaim for tasks with fatal_signal_pending?

It is little bit unexpected, because we bypass if the condition happens
before the reclaim but then we ignore it.

> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e946f7439b16..52550bbff1ef 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2566,7 +2566,7 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  				 bool oom)
>  {
>  	unsigned int batch = max(CHARGE_BATCH, nr_pages);
> -	int nr_oom_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>  	struct mem_cgroup *mem_over_limit;
>  	struct res_counter *fail_res;
>  	unsigned long nr_reclaimed;
> @@ -2638,6 +2638,9 @@ retry:
>  	if (mem_cgroup_wait_acct_move(mem_over_limit))
>  		goto retry;
>  
> +	if (nr_retries--)
> +		goto retry;
> +
>  	if (gfp_mask & __GFP_NOFAIL)
>  		goto bypass;
>  
> @@ -2647,9 +2650,6 @@ retry:
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
> 2.0.0
> 

-- 
Michal Hocko
SUSE Labs
