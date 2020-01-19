From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Sun, 19 Jan 2020 19:32:02 +0800
Message-ID: <36a55567-a701-ad6c-e4ea-79fd2021a648@linux.alibaba.com>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200116215222.GA64230-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku


> In a previous review, I pointed out the following race condition
> between page charging and compaction:
> 
> compaction:				generic_file_buffered_read:
> 
> 					page_cache_alloc()
> 
> !PageBuddy()
> 
> lock_page_lruvec(page)
>   lruvec = mem_cgroup_page_lruvec()
>   spin_lock(&lruvec->lru_lock)
>   if lruvec != mem_cgroup_page_lruvec()
>     goto again
> 
> 					add_to_page_cache_lru()
> 					  mem_cgroup_commit_charge()
> 					    page->mem_cgroup = foo
> 					  lru_cache_add()
> 					    __pagevec_lru_add()
> 					      SetPageLRU()
> 
> if PageLRU(page):
>   __isolate_lru_page()
> 
> As far as I can see, you have not addressed this. You have added
> lock_page_memcg(), but that prevents charged pages from moving between
> cgroups, it does not prevent newly allocated pages from being charged.
> 

yes, it's my fault to oversee this problem.

...

> 
> So here is a crazy idea that may be worth exploring:
> 
> Right now, pgdat->lru_lock protects both PageLRU *and* the lruvec's
> linked list.
> 
> Can we make PageLRU atomic and use it to stabilize the lru_lock
> instead, and then use the lru_lock only serialize list operations?
> 

Sounds a good idea. I will try this.

Thanks
Alex

> I.e. in compaction, you'd do
> 
> 	if (!TestClearPageLRU(page))
> 		goto isolate_fail;
> 	/*
> 	 * We isolated the page's LRU state and thereby locked out all
> 	 * other isolators, including cgroup page moving, page reclaim,
> 	 * page freeing etc. That means page->mem_cgroup is now stable
> 	 * and we can safely look up the correct lruvec and take the
> 	 * page off its physical LRU list.
> 	 */
> 	lruvec = mem_cgroup_page_lruvec(page);
> 	spin_lock_irq(&lruvec->lru_lock);
> 	del_page_from_lru_list(page, lruvec, page_lru(page));
> 
> Putback would mostly remain the same (although you could take the
> PageLRU setting out of the list update locked section, as long as it's
> set after the page is physically linked):
> 
> 	/* LRU isolation pins page->mem_cgroup */
> 	lruvec = mem_cgroup_page_lruvec(page)
> 	spin_lock_irq(&lruvec->lru_lock);
> 	add_page_to_lru_list(...);
> 	spin_unlock_irq(&lruvec->lru_lock);
> 
> 	SetPageLRU(page);
> 
> And you'd have to carefully review and rework other sites that rely on
> PageLRU: reclaim, __page_cache_release(), __activate_page() etc.
> 
> Especially things like activate_page(), which used to only check
> PageLRU to shuffle the page on the LRU list would now have to briefly
> clear PageLRU and then set it again afterwards.
> 
> However, aside from a bit more churn in those cases, and the
> unfortunate additional atomic operations, I currently can't think of a
> fundamental reason why this wouldn't work.
> 
> Hugh, what do you think?
> 
