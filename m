From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/9] mm: memcontrol: rearrange charging fast path
Date: Wed, 7 May 2014 16:33:34 +0200
Message-ID: <20140507143334.GH9489@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1398889543-23671-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 30-04-14 16:25:36, Johannes Weiner wrote:
> The charging path currently starts out with OOM condition checks when
> OOM is the rarest possible case.
> 
> Rearrange this code to run OOM/task dying checks only after trying the
> percpu charge and the res_counter charge and bail out before entering
> reclaim.  Attempting a charge does not hurt an (oom-)killed task as
> much as every charge attempt having to check OOM conditions. 

OK, I've never considered those to be measurable but it is true that the
numbers accumulate over time.

So yes, this makes sense.

> Also, only check __GFP_NOFAIL when the charge would actually fail.

OK, but return ENOMEM as pointed below.

> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 75dfeb8fa98b..6ce59146fec7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2598,21 +2598,6 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  
>  	if (mem_cgroup_is_root(memcg))
>  		goto done;
> -	/*
> -	 * Unlike in global OOM situations, memcg is not in a physical
> -	 * memory shortage.  Allow dying and OOM-killed tasks to
> -	 * bypass the last charges so that they can exit quickly and
> -	 * free their memory.
> -	 */
> -	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
> -		     fatal_signal_pending(current)))
> -		goto bypass;

This is missing "memcg: do not hang on OOM when killed by userspace OOM
access to memory reserves" - trivial to resolve.

> -
> -	if (unlikely(task_in_memcg_oom(current)))
> -		goto nomem;
> -
> -	if (gfp_mask & __GFP_NOFAIL)
> -		oom = false;
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		goto done;
[...]
> @@ -2662,6 +2660,9 @@ retry:
>  	if (mem_cgroup_wait_acct_move(mem_over_limit))
>  		goto retry;
>  
> +	if (gfp_mask & __GFP_NOFAIL)
> +		goto bypass;
> +

This is a behavior change because we have returned ENOMEM previously

>  	if (fatal_signal_pending(current))
>  		goto bypass;
>  
	if (!oom)
		goto nomem;

-- 
Michal Hocko
SUSE Labs
