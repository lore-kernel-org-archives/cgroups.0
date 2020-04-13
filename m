From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 13 Apr 2020 14:07:25 -0400
Message-ID: <20200413180725.GA99267@cmpxchg.org>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <cdcdb710-1d78-6fac-48d7-35519ddcdc6a@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eYVEC8x9/ZJs/cJ45Aj5p7ZwEmZ1E13BchE174aWIpw=;
        b=BONlUzW5lB0GMqGIqY6nr+G0zxsPf6cfqeBoTKZbydbyfRIMLY3fzC3ceofshhChMr
         wDNA8JwKxOOVIp5VHRMrEjsxv+YX58RveKX/dERvRxJeyOAXL87jL/0lUzYWuogGTY3M
         R72M4+vU84VbWeEZeN+jXGLgITNa5YfMKNUhy8HNfPfwQqnQDCw17IUyv6W/5Qjd4NKa
         ZZYXSuSgzniM/RtWzcNhwVMp/8wqCah+IqXiqGt+ZWF9l6Q+lCSn3V6VbJpE1/HdsMQ9
         OG+VLT1Y05gcAsWm9J9yACdffUBEvcW8jh4vRF6cvjmoFhVmjOULPb3V7Mo0sYULS7wY
         dEpQ==
Content-Disposition: inline
In-Reply-To: <cdcdb710-1d78-6fac-48d7-35519ddcdc6a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku

On Mon, Apr 13, 2020 at 06:48:22PM +0800, Alex Shi wrote:
> > In a previous review, I pointed out the following race condition
> > between page charging and compaction:
> > 
> > compaction:				generic_file_buffered_read:
> > 
> > 					page_cache_alloc()
> > 
> > !PageBuddy()
> > 
> > lock_page_lruvec(page)
> >   lruvec = mem_cgroup_page_lruvec()
> >   spin_lock(&lruvec->lru_lock)
> >   if lruvec != mem_cgroup_page_lruvec()
> >     goto again
> > 
> > 					add_to_page_cache_lru()
> > 					  mem_cgroup_commit_charge()
> > 					    page->mem_cgroup = foo
> > 					  lru_cache_add()
> > 					    __pagevec_lru_add()
> > 					      SetPageLRU()
> > 
> > if PageLRU(page):
> >   __isolate_lru_page()
> > 
> > As far as I can see, you have not addressed this. You have added
> > lock_page_memcg(), but that prevents charged pages from moving between
> > cgroups, it does not prevent newly allocated pages from being charged.
> > 
> > It doesn't matter how many times you check the lruvec before and after
> > locking - if you're looking at a free page, it might get allocated,
> > charged and put on a new lruvec after you're done checking, and then
> > you isolate a page from an unlocked lruvec.
> > 
> > You simply cannot serialize on page->mem_cgroup->lruvec when
> > page->mem_cgroup isn't stable. You need to serialize on the page
> > itself, one way or another, to make this work.
> > 
> > 
> > So here is a crazy idea that may be worth exploring:
> > 
> > Right now, pgdat->lru_lock protects both PageLRU *and* the lruvec's
> > linked list.
> > 
> > Can we make PageLRU atomic and use it to stabilize the lru_lock
> > instead, and then use the lru_lock only serialize list operations?
> > 
> > I.e. in compaction, you'd do
> > 
> > 	if (!TestClearPageLRU(page))
> > 		goto isolate_fail;
> > 	/*
> > 	 * We isolated the page's LRU state and thereby locked out all
> > 	 * other isolators, including cgroup page moving, page reclaim,
> > 	 * page freeing etc. That means page->mem_cgroup is now stable
> > 	 * and we can safely look up the correct lruvec and take the
> > 	 * page off its physical LRU list.
> > 	 */
> > 	lruvec = mem_cgroup_page_lruvec(page);
> > 	spin_lock_irq(&lruvec->lru_lock);
> > 	del_page_from_lru_list(page, lruvec, page_lru(page));
> > 
> > Putback would mostly remain the same (although you could take the
> > PageLRU setting out of the list update locked section, as long as it's
> > set after the page is physically linked):
> > 
> > 	/* LRU isolation pins page->mem_cgroup */
> > 	lruvec = mem_cgroup_page_lruvec(page)
> > 	spin_lock_irq(&lruvec->lru_lock);
> > 	add_page_to_lru_list(...);
> > 	spin_unlock_irq(&lruvec->lru_lock);
> > 
> > 	SetPageLRU(page);
> > 
> > And you'd have to carefully review and rework other sites that rely on
> > PageLRU: reclaim, __page_cache_release(), __activate_page() etc.
> > 
> > Especially things like activate_page(), which used to only check
> > PageLRU to shuffle the page on the LRU list would now have to briefly
> > clear PageLRU and then set it again afterwards.
> > 
> > However, aside from a bit more churn in those cases, and the
> > unfortunate additional atomic operations, I currently can't think of a
> > fundamental reason why this wouldn't work.
> > 
> > Hugh, what do you think?
> > 
> 
> Hi Johannes
> 
> As to the idea of TestClearPageLRU, we except the following scenario
>     compaction                       commit_charge
>                                      if (TestClearPageLRU)
>         !TestClearPageLRU                 lock_page_lruvec
>             goto isolate_fail;            del_from_lru_list
>                                           unlock_page_lruvec
> 
> But there is a difficult situation to handle:
> 
>    compaction                        commit_charge
>         TestClearPageLRU
>                                     !TestClearPageLRU
> 
>                                     page possible state:
>                                     a, reclaiming, b, moving between lru list, c, migrating, like in compaction
>                                     d, mlocking,   e, split_huge_page,
> 
> If the page lru bit was cleared in commit_charge with lrucare,
> we still have no idea if the page was isolated by the reason from a~e
> or the page is never on LRU, to deal with different reasons is high cost.
> 
> So as to the above issue you mentioned, Maybe the better idea is to
> set lrucare when do mem_cgroup_commit_charge(), since the charge action
> is not often. What's your idea of this solution?

Hm, yes, the lrucare scenario is a real problem. If it can isolate the
page, fine, but if not, it changes page->mem_cgroup on a page that
somebody else has isolated, having indeed no idea who they are and how
they are going to access page->mem_cgroup.

Right now it's safe because of secondary protection on top of
isolation: split_huge_page keeps the lru_lock held throughout;
reclaim, cgroup migration, page migration, compaction etc. hold the
page lock which locks out swapcache charging.

But it complicates the serialization model immensely and makes it
subtle and error prone.

I'm not sure how unconditionally taking the lru_lock when charging
would help. Can you lay out what you have in mind in prototype code,
like I'm using below, for isolation, putback, charging, compaction?

That said, charging actually is a hotpath. I'm reluctant to
unconditionally take the LRU lock there. But if you can make things a
lot simpler this way, it could be worth exploring.

In the PageLRU locking scheme, I can see a way to make putback safe
wrt lrucare charging, but I'm not sure about isolation:

putback:
lruvec = page->mem_cgroup->lruvecs[pgdat]
spin_lock(lruvec->lru_lock)
if lruvec != page->mem_cgroup->lruvecs[pgdat]:
  /*
   * commit_charge(lrucare=true) can charge an uncharged swapcache
   * page while we had it isolated. This changes page->mem_cgroup,
   * but it can only happen once. Look up the new cgroup.
   */
  spin_unlock(lruvec->lru_lock)
  lruvec = page->mem_cgroup->lruvecs[pgdat]
  spin_lock(lruvec->lru_lock)
add_page_to_lru_list(page, lruvec, ...)
SetPageLRU(page);
spin_unlock(lruvec->lru_lock)

commit_charge:
if (lrucare)
  spin_lock(root_memcg->lru_lock)
  /*
   * If we can isolate the page, we'll move it to the new
   * cgroup's LRU list. If somebody else has the page
   * isolated, we need their putback to move it to the
   * new cgroup. If they see the old cgroup - the root -
   * they will spin until we're done and recheck.
   */
  if ((lru = TestClearPageLRU(page)))
    del_page_from_lru_list()
page->mem_cgroup = new;
if (lrucare)
  spin_unlock(root_memcg->lru_lock)
  if (lru)
    spin_lock(new->lru_lock)
    add_page_to_lru_list()
    spin_unlock(new->lru_lock);
    SetPageLRU(page)

putback would need to 1) recheck once after acquiring the lock and 2)
SetPageLRU while holding the lru_lock after all. But it works because
we know the old cgroup: if the putback sees the old cgroup, we know
it's the root cgroup, and we have that locked until we're done with
the update. And if putback manages to lock the old cgroup before us,
we will spin until the isolator is done, and then either be able to
isolate it ourselves or, if racing with yet another isolator, hold the
lock and delay putback until we're done.

But isolation actually needs to lock out charging, or it would operate
on the wrong list:

isolation:                                     commit_charge:
if (TestClearPageLRU(page))
                                               page->mem_cgroup = new
  // page is still physically on
  // the root_mem_cgroup's LRU. We're
  // updating the wrong list:
  memcg = page->mem_cgroup
  spin_lock(memcg->lru_lock)
  del_page_from_lru_list(page, memcg)
  spin_unlock(memcg->lru_lock)

lrucare really is a mess. Even before this patch series, it makes
things tricky and subtle and error prone.

The only reason we're doing it is for when there is swapping without
swap tracking, in which case swap reahadead needs to put pages on the
LRU but cannot charge them until we have a faulting vma later.

But it's not clear how practical such a configuration is. Both memory
and swap are shared resources, and isolation isn't really effective
when you restrict access to memory but then let workloads swap freely.

Plus, the overhead of tracking is tiny - 512k per G of swap (0.04%).

Maybe we should just delete MEMCG_SWAP and unconditionally track swap
entry ownership when the memory controller is enabled. I don't see a
good reason not to, and it would simplify the entire swapin path, the
LRU locking, and the page->mem_cgroup stabilization rules.
