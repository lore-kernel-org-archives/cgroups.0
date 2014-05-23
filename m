From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 6/9] mm: memcontrol: remove ordering between
 pc->mem_cgroup and PageCgroupUsed
Date: Fri, 23 May 2014 15:20:43 +0200
Message-ID: <20140523132043.GB22135@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-7-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1398889543-23671-7-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 30-04-14 16:25:40, Johannes Weiner wrote:
> There is a write barrier between setting pc->mem_cgroup and
> PageCgroupUsed, which was added to allow LRU operations to lookup the
> memcg LRU list of a page without acquiring the page_cgroup lock.  But
> ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new rule"),
> pages are ensured to be off-LRU while charging, so nobody else is
> changing LRU state while pc->mem_cgroup is being written.

This is quite confusing. Why do we have the lrucare path then?
The code is quite tricky so this deserves a more detailed explanation
IMO.

There are only 3 paths which check both the flag and mem_cgroup (
without page_cgroup_lock) get_mctgt_type* and mem_cgroup_page_lruvec AFAICS.
None of them have rmb so there was no guarantee about ordering anyway.

> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Anyway, the change is welcome
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 34407d99262a..c528ae9ac230 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2823,14 +2823,6 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>  	}
>  
>  	pc->mem_cgroup = memcg;
> -	/*
> -	 * We access a page_cgroup asynchronously without lock_page_cgroup().
> -	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
> -	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
> -	 * before USED bit, we need memory barrier here.
> -	 * See mem_cgroup_add_lru_list(), etc.
> -	 */
> -	smp_wmb();
>  	SetPageCgroupUsed(pc);
>  
>  	if (lrucare) {
> @@ -3609,7 +3601,6 @@ void mem_cgroup_split_huge_fixup(struct page *head)
>  	for (i = 1; i < HPAGE_PMD_NR; i++) {
>  		pc = head_pc + i;
>  		pc->mem_cgroup = memcg;
> -		smp_wmb();/* see __commit_charge() */
>  		pc->flags = head_pc->flags & ~PCGF_NOCOPY_AT_SPLIT;
>  	}
>  	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS_HUGE],
> -- 
> 1.9.2
> 

-- 
Michal Hocko
SUSE Labs
