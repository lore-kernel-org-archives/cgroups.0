From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC][PATCH] memcg: remove PCG_ACCT_LRU.
Date: Fri, 2 Dec 2011 13:08:49 +0100
Message-ID: <20111202120849.GA1295@cmpxchg.org>
References: <20111202190622.8e0488d6.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111202190622.8e0488d6.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Dec 02, 2011 at 07:06:22PM +0900, KAMEZAWA Hiroyuki wrote:
> I'm now testing this patch, removing PCG_ACCT_LRU, onto mmotm.
> How do you think ?

> @@ -1024,18 +1026,8 @@ void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
>  		return;
>  
>  	pc = lookup_page_cgroup(page);
> -	/*
> -	 * root_mem_cgroup babysits uncharged LRU pages, but
> -	 * PageCgroupUsed is cleared when the page is about to get
> -	 * freed.  PageCgroupAcctLRU remembers whether the
> -	 * LRU-accounting happened against pc->mem_cgroup or
> -	 * root_mem_cgroup.
> -	 */
> -	if (TestClearPageCgroupAcctLRU(pc)) {
> -		VM_BUG_ON(!pc->mem_cgroup);
> -		memcg = pc->mem_cgroup;
> -	} else
> -		memcg = root_mem_cgroup;
> +	memcg = pc->mem_cgroup ? pc->mem_cgroup : root_mem_cgroup;
> +	VM_BUG_ON(memcg != pc->mem_cgroup_lru);
>  	mz = page_cgroup_zoneinfo(memcg, page);
>  	/* huge page split is done under lru_lock. so, we have no races. */
>  	MEM_CGROUP_ZSTAT(mz, lru) -= 1 << compound_order(page);

Nobody clears pc->mem_cgroup upon uncharge, so this may end up
mistakenly lru-unaccount a page that was never charged against the
stale pc->mem_cgroup (e.g. a swap readahead page that has not been
charged yet gets isolated by reclaim).

On the other hand, pages that were uncharged just before the lru_del
MUST be lru-unaccounted against pc->mem_cgroup.

PageCgroupAcctLRU made it possible to tell those two scenarios apart.

A possible solution could be to clear pc->mem_cgroup when the page is
finally freed so that only pages that have been charged since their
last allocation have pc->mem_cgroup set.  But this means that the page
freeing hotpath will have to grow a lookup_page_cgroup(), amortizing
the winnings at least to some extent.
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
