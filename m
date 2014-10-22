From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: fix missed end-writeback accounting
Date: Wed, 22 Oct 2014 18:30:51 +0200
Message-ID: <20141022163051.GH30802@dhcp22.suse.cz>
References: <1413915550-5651-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1413915550-5651-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 21-10-14 14:19:10, Johannes Weiner wrote:
> 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") changed page
> migration to uncharge the old page right away.  The page is locked,
> unmapped, truncated, and off the LRU.  But it could race with a
> finishing writeback, which then doesn't get unaccounted properly:
> 
> test_clear_page_writeback()              migration
>   acquire pc->mem_cgroup->move_lock
>                                            wait_on_page_writeback()
>   TestClearPageWriteback()
>                                            mem_cgroup_migrate()
>                                              clear PCG_USED
>   if (PageCgroupUsed(pc))
>     decrease memcg pages under writeback
>   release pc->mem_cgroup->move_lock
> 
> One solution for this would be to simply remove the PageCgroupUsed()
> check, as RCU protects the memcg anyway.
> 
> However, it's more robust to acknowledge that migration is really
> modifying the charge state of alive pages in this case, and so it
> should participate in the protocol specifically designed for this.

It's been a long day so I might be missing something really obvious
here. But how can move_lock help here when the fast path (no task
migration is going on) takes only RCU read lock?

> Fixes: 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "3.17" <stable@vger.kernel.org>
> ---
>  mm/memcontrol.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3a203c7ec6c7..b35a44e9cd37 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6148,6 +6148,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  			bool lrucare)
>  {
>  	struct page_cgroup *pc;
> +	unsigned long flags;
>  	int isolated;
>  
>  	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> @@ -6177,7 +6178,14 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (lrucare)
>  		lock_page_lru(oldpage, &isolated);
>  
> +	/*
> +	 * The page is locked, unmapped, truncated, and off the LRU,
> +	 * but there might still be references, e.g. from finishing
> +	 * writeback.  Follow the charge moving protocol here.
> +	 */
> +	move_lock_mem_cgroup(pc->mem_cgroup, &flags);
>  	pc->flags = 0;
> +	move_unlock_mem_cgroup(pc->mem_cgroup, &flags);
>  
>  	if (lrucare)
>  		unlock_page_lru(oldpage, isolated);
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
