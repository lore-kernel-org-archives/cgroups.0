From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcontrol: fix missed end-writeback page
 accounting
Date: Wed, 22 Oct 2014 13:39:36 -0700
Message-ID: <20141022133936.44f2d2931948ce13477b5e64@linux-foundation.org>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
	<1414002568-21042-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414002568-21042-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 22 Oct 2014 14:29:28 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") changed page
> migration to uncharge the old page right away.  The page is locked,
> unmapped, truncated, and off the LRU, but it could race with writeback
> ending, which then doesn't unaccount the page properly:
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
> The per-page statistics interface is heavily optimized to avoid a
> function call and a lookup_page_cgroup() in the file unmap fast path,
> which means it doesn't verify whether a page is still charged before
> clearing PageWriteback() and it has to do it in the stat update later.
> 
> Rework it so that it looks up the page's memcg once at the beginning
> of the transaction and then uses it throughout.  The charge will be
> verified before clearing PageWriteback() and migration can't uncharge
> the page as long as that is still set.  The RCU lock will protect the
> memcg past uncharge.
> 
> As far as losing the optimization goes, the following test results are
> from a microbenchmark that maps, faults, and unmaps a 4GB sparse file
> three times in a nested fashion, so that there are two negative passes
> that don't account but still go through the new transaction overhead.
> There is no actual difference:
> 
> old:     33.195102545 seconds time elapsed       ( +-  0.01% )
> new:     33.199231369 seconds time elapsed       ( +-  0.03% )
> 
> The time spent in page_remove_rmap()'s callees still adds up to the
> same, but the time spent in the function itself seems reduced:
> 
>     # Children      Self  Command        Shared Object       Symbol
> old:     0.12%     0.11%  filemapstress  [kernel.kallsyms]   [k] page_remove_rmap
> new:     0.12%     0.08%  filemapstress  [kernel.kallsyms]   [k] page_remove_rmap
> 
> ...
>
> @@ -2132,26 +2126,32 @@ cleanup:
>   * account and taking the move_lock in the slowpath.
>   */
>  
> -void __mem_cgroup_begin_update_page_stat(struct page *page,
> -				bool *locked, unsigned long *flags)
> +struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
> +					      bool *locked,
> +					      unsigned long *flags)

It would be useful to document the args here (especially `locked'). 
Also the new rcu_read_locking protocol is worth a mention: that it
exists, what it does, why it persists as long as it does.

>  {
>  	struct mem_cgroup *memcg;
>  	struct page_cgroup *pc;
>  
> +	rcu_read_lock();
> +
> +	if (mem_cgroup_disabled())
> +		return NULL;
> +
>  	pc = lookup_page_cgroup(page);
>  again:
>  	memcg = pc->mem_cgroup;
>  	if (unlikely(!memcg || !PageCgroupUsed(pc)))
> -		return;
> +		return NULL;
>  	/*
>  	 * If this memory cgroup is not under account moving, we don't
>  	 * need to take move_lock_mem_cgroup(). Because we already hold
>  	 * rcu_read_lock(), any calls to move_account will be delayed until
>  	 * rcu_read_unlock().
>  	 */
> -	VM_BUG_ON(!rcu_read_lock_held());
> +	*locked = false;
>  	if (atomic_read(&memcg->moving_account) <= 0)
> -		return;
> +		return memcg;
>  
>  	move_lock_mem_cgroup(memcg, flags);
>  	if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
> @@ -2159,36 +2159,26 @@ again:
>  		goto again;
>  	}
>  	*locked = true;
> +
> +	return memcg;
>  }
>  
> 
> ...
>
> @@ -1061,9 +1062,10 @@ void page_add_file_rmap(struct page *page)
>   */
>  void page_remove_rmap(struct page *page)
>  {
> +	struct mem_cgroup *uninitialized_var(memcg);
>  	bool anon = PageAnon(page);
> -	bool locked;
>  	unsigned long flags;
> +	bool locked;
>  
>  	/*
>  	 * The anon case has no mem_cgroup page_stat to update; but may
> @@ -1071,7 +1073,7 @@ void page_remove_rmap(struct page *page)
>  	 * we hold the lock against page_stat move: so avoid it on anon.
>  	 */
>  	if (!anon)
> -		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
> +		memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
>  
>  	/* page still mapped by someone else? */
>  	if (!atomic_add_negative(-1, &page->_mapcount))
> @@ -1096,8 +1098,7 @@ void page_remove_rmap(struct page *page)
>  				-hpage_nr_pages(page));
>  	} else {
>  		__dec_zone_page_state(page, NR_FILE_MAPPED);
> -		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
> -		mem_cgroup_end_update_page_stat(page, &locked, &flags);
> +		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
>  	}
>  	if (unlikely(PageMlocked(page)))
>  		clear_page_mlock(page);
> @@ -1110,10 +1111,9 @@ void page_remove_rmap(struct page *page)
>  	 * Leaving it set also helps swapoff to reinstate ptes
>  	 * faster for those pages still in swapcache.
>  	 */
> -	return;
>  out:
>  	if (!anon)
> -		mem_cgroup_end_update_page_stat(page, &locked, &flags);
> +		mem_cgroup_end_page_stat(memcg, locked, flags);
>  }

The anon and file paths have as much unique code as they do common
code.  I wonder if page_remove_rmap() would come out better if split
into two functions?  I gave that a quick try and it came out OK-looking.
