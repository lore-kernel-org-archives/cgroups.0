From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 11/11] mm: memcg: only check anon swapin page charges for
 swap cache
Date: Mon, 9 Jul 2012 17:34:52 +0200
Message-ID: <20120709153452.GN4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-12-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341449103-1986-12-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-07-12 02:45:03, Johannes Weiner wrote:
> shmem knows for sure that the page is in swap cache when attempting to
> charge a page, because the cache charge entry function has a check for
> it.  Only anon pages may be removed from swap cache already when
> trying to charge their swapin.
> 
> Adjust the comment, though: '4969c11 mm: fix swapin race condition'
> added a stable PageSwapCache check under the page lock in the
> do_swap_page() before calling the memory controller, so it's
> unuse_pte()'s pte_same() that may fail.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Looks good
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |   22 ++++++++++++++--------
>  1 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d3701cd..9b7e256 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2751,14 +2751,6 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  		return 0;
>  	if (!do_swap_account)
>  		goto charge_cur_mm;
> -	/*
> -	 * A racing thread's fault, or swapoff, may have already updated
> -	 * the pte, and even removed page from swap cache: in those cases
> -	 * do_swap_page()'s pte_same() test will fail; but there's also a
> -	 * KSM case which does need to charge the page.
> -	 */
> -	if (!PageSwapCache(page))
> -		goto charge_cur_mm;
>  	memcg = try_get_mem_cgroup_from_page(page);
>  	if (!memcg)
>  		goto charge_cur_mm;
> @@ -2781,6 +2773,20 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm, struct page *page,
>  	*memcgp = NULL;
>  	if (mem_cgroup_disabled())
>  		return 0;
> +	/*
> +	 * A racing thread's fault, or swapoff, may have already
> +	 * updated the pte, and even removed page from swap cache: in
> +	 * those cases unuse_pte()'s pte_same() test will fail; but
> +	 * there's also a KSM case which does need to charge the page.
> +	 */
> +	if (!PageSwapCache(page)) {
> +		int ret;
> +
> +		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, memcgp, true);
> +		if (ret == -EINTR)
> +			ret = 0;
> +		return ret;
> +	}
>  	return __mem_cgroup_try_charge_swapin(mm, page, gfp_mask, memcgp);
>  }
>  
> -- 
> 1.7.7.6
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
