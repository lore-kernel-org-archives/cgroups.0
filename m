From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 08/11] mm: memcg: remove needless !mm fixup to init_mm
 when charging
Date: Mon, 9 Jul 2012 17:20:58 +0200
Message-ID: <20120709152058.GK4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-9-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341449103-1986-9-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-07-12 02:45:00, Johannes Weiner wrote:
> It does not matter to __mem_cgroup_try_charge() if the passed mm is
> NULL or init_mm, it will charge the root memcg in either case.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 418b47d..6fe4101 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2766,8 +2766,6 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  		ret = 0;
>  	return ret;
>  charge_cur_mm:
> -	if (unlikely(!mm))
> -		mm = &init_mm;
>  	ret = __mem_cgroup_try_charge(mm, mask, 1, memcgp, true);
>  	if (ret == -EINTR)
>  		ret = 0;
> @@ -2832,9 +2830,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  	if (PageCompound(page))
>  		return 0;
>  
> -	if (unlikely(!mm))
> -		mm = &init_mm;
> -
>  	if (!PageSwapCache(page))
>  		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
>  	else { /* page is swapcache/shmem */
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
