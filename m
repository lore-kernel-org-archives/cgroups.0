From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 07/11] mm: memcg: remove unneeded shmem charge type
Date: Mon, 9 Jul 2012 17:17:52 +0200
Message-ID: <20120709151752.GJ4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-8-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341449103-1986-8-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-07-12 02:44:59, Johannes Weiner wrote:
> shmem page charges have not needed a separate charge type to tell them
> from regular file pages since 08e552c 'memcg: synchronized LRU'.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Yes, MEM_CGROUP_CHARGE_TYPE_SHMEM has been quite confusing.

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c |   11 +----------
>  1 files changed, 1 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4a41b55..418b47d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -379,7 +379,6 @@ static bool move_file(void)
>  enum charge_type {
>  	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
>  	MEM_CGROUP_CHARGE_TYPE_ANON,
> -	MEM_CGROUP_CHARGE_TYPE_SHMEM,	/* used by page migration of shmem */
>  	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
>  	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
>  	NR_CHARGE_TYPE,
> @@ -2835,8 +2834,6 @@ int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  
>  	if (unlikely(!mm))
>  		mm = &init_mm;
> -	if (!page_is_file_cache(page))
> -		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
>  
>  	if (!PageSwapCache(page))
>  		ret = mem_cgroup_charge_common(page, mm, gfp_mask, type);
> @@ -3243,10 +3240,8 @@ void mem_cgroup_prepare_migration(struct page *page, struct page *newpage,
>  	 */
>  	if (PageAnon(page))
>  		ctype = MEM_CGROUP_CHARGE_TYPE_ANON;
> -	else if (page_is_file_cache(page))
> -		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
>  	else
> -		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> +		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
>  	/*
>  	 * The page is committed to the memcg, but it's not actually
>  	 * charged to the res_counter since we plan on replacing the
> @@ -3340,10 +3335,6 @@ void mem_cgroup_replace_page_cache(struct page *oldpage,
>  	 */
>  	if (!memcg)
>  		return;
> -
> -	if (PageSwapBacked(oldpage))
> -		type = MEM_CGROUP_CHARGE_TYPE_SHMEM;
> -
>  	/*
>  	 * Even if newpage->mapping was NULL before starting replacement,
>  	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
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
