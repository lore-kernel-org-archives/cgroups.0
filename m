From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch 9/9] mm: memcontrol: rewrite uncharge API
Date: Tue, 27 May 2014 16:43:28 +0900
Message-ID: <53844220.5040507@jp.fujitsu.com>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org> <1398889543-23671-10-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1398889543-23671-10-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

(2014/05/01 5:25), Johannes Weiner wrote:
> The memcg uncharging code that is involved towards the end of a page's
> lifetime - truncation, reclaim, swapout, migration - is impressively
> complicated and fragile.
> 
> Because anonymous and file pages were always charged before they had
> their page->mapping established, uncharges had to happen when the page
> type could be known from the context, as in unmap for anonymous, page
> cache removal for file and shmem pages, and swap cache truncation for
> swap pages.  However, these operations also happen well before the
> page is actually freed, and so a lot of synchronization is necessary:
> 
> - On page migration, the old page might be unmapped but then reused,
>    so memcg code has to prevent an untimely uncharge in that case.
>    Because this code - which should be a simple charge transfer - is so
>    special-cased, it is not reusable for replace_page_cache().
> 
> - Swap cache truncation happens during both swap-in and swap-out, and
>    possibly repeatedly before the page is actually freed.  This means
>    that the memcg swapout code is called from many contexts that make
>    no sense and it has to figure out the direction from page state to
>    make sure memory and memory+swap are always correctly charged.
> 
> But now that charged pages always have a page->mapping, introduce
> mem_cgroup_uncharge(), which is called after the final put_page(),
> when we know for sure that nobody is looking at the page anymore.
> 
> For page migration, introduce mem_cgroup_migrate(), which is called
> after the migration is successful and the new page is fully rmapped.
> Because the old page is no longer uncharged after migration, prevent
> double charges by decoupling the page's memcg association (PCG_USED
> and pc->mem_cgroup) from the page holding an actual charge.  The new
> bits PCG_MEM and PCG_MEMSW represent the respective charges and are
> transferred to the new page during migration.
> 
> mem_cgroup_migrate() is suitable for replace_page_cache() as well.
> 
> Swap accounting is massively simplified: because the page is no longer
> uncharged as early as swap cache deletion, a new mem_cgroup_swapout()
> can transfer the page's memory+swap charge (PCG_MEMSW) to the swap
> entry before the final put_page() in page reclaim.
> 
> Finally, because pages are now charged under proper serialization
> (anon: exclusive; cache: page lock; swapin: page lock; migration: page
> lock), and uncharged under full exclusion, they can not race with
> themselves.  Because they are also off-LRU during charge/uncharge,
> charge migration can not race, with that, either.  Remove the crazily
> expensive the page_cgroup lock and set pc->flags non-atomically.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

The whole series seems wonderful to me. Thank you.
I'm not sure whether I have enough good eyes now but this seems good.

One thing in my mind is batched uncharge rework.

Because uncharge() is done in final put_page() path, 
mem_cgroup_uncharge_start()/mem_cgroup_uncharge_end() placement may not be good enough.

swap.c::release_pages() may be good to have mem_cgroup_uncharge_start()/end().
(and you may be able to remove unnecessary calls of mem_cgroup_uncharge_start/end())

Thanks,
-Kame



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
