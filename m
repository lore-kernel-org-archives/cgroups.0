From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v18 00/32] per memcg lru_lock: reviews
Date: Sun, 13 Sep 2020 22:22:48 +0800
Message-ID: <2fed13c0-1d78-fa92-b607-e997b1bc5fb2@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200824114204.cc796ca182db95809dd70a47@linux-foundation.org>
 <alpine.LSU.2.11.2008241231460.1065@eggly.anvils>
 <alpine.LSU.2.11.2008262301240.4405@eggly.anvils>
 <alpine.LSU.2.11.2009081640070.7256@eggly.anvils>
 <61a42a87-eec9-e300-f710-992756f70de6@linux.alibaba.com>
 <alpine.LSU.2.11.2009112216260.23961@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LSU.2.11.2009112216260.23961-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cai-J5quhbR+WMc@public.gmane.org



在 2020/9/12 下午4:38, Hugh Dickins 写道:
> On Wed, 9 Sep 2020, Alex Shi wrote:
>> 在 2020/9/9 上午7:41, Hugh Dickins 写道:
>>>
>>> The use of lock_page_memcg() in __munlock_pagevec() in 20/32,
>>> introduced in patchset v17, looks good but it isn't: I was lucky that
>>> systemd at reboot did some munlocking that exposed the problem to lockdep.
>>> The first time into the loop, lock_page_memcg() is done before lru_lock
>>> (as 06/32 has allowed); but the second time around the loop, it is done
>>> while still holding lru_lock.
>>
>> I don't know the details of lockdep show. Just wondering could it possible 
>> to solid the move_lock/lru_lock sequence?
>> or try other blocking way which mentioned in commit_charge()?
>>
>>>
>>> lock_page_memcg() really needs to be absorbed into (a variant of)
>>> relock_page_lruvec(), and I do have that (it's awkward because of
>>> the different ways in which the IRQ flags are handled).  And out of
>>> curiosity, I've also tried using that in mm/swap.c too, instead of the
>>> TestClearPageLRU technique: lockdep is happy, but an update_lru_size()
>>> warning showed that it cannot safely be mixed with the TestClearPageLRU
>>> technique (that I'd left in isolate_lru_page()).  So I'll stash away
>>> that relock_page_lruvec(), and consider what's best for mm/mlock.c:
>>> now that I've posted these comments so far, that's my priority, then
>>> to get the result under testing again, before resuming these comments.
>>
>> No idea of your solution, but looking forward for your good news! :)
> 
> Yes, it is good news, and simpler than anything suggested above.

Awesome!
> 
> The main difficulties will probably be to look good in the 80 columns
> (I know that limit has been lifted recently, but some of us use xterms
> side by side), and to explain it.
> 
> mm/mlock.c has not been kept up-to-date very well: and in particular,
> you have taken too seriously that "Serialize with any parallel
> __split_huge_page_refcount()..." comment that you updated to two
> comments "Serialize split tail pages in __split_huge_page_tail()...".
> 
> Delete them! The original comment was by Vlastimil for v3.14 in 2014.
> But Kirill redesigned THP refcounting for v4.5 in 2016: that's when
> __split_huge_page_refcount() went away.  And with the new refcounting,
> the THP splitting races that lru_lock protected munlock_vma_page()
> and __munlock_pagevec() from: those races have become impossible.
> 
> Or maybe there never was such a race in __munlock_pagevec(): you
> have added the comment there, assuming lru_lock was for that purpose,
> but that was probably just the convenient place to take it,
> to cover all the del_page_from_lru()s.
> 
> Observe how split_huge_page_to_list() uses unmap_page() to remove
> all pmds and all ptes for the huge page being split, and remap_page()
> only replaces the migration entries (used for anon but not for shmem
> or file) after doing all of the __split_huge_page_tail()s, before
> unlocking any of the pages.  Recall that munlock_vma_page() and
> __munlock_pagevec() are being applied to pages found mapped
> into userspace, by ptes or pmd: there are none of those while
> __split_huge_page_tail() is being used, so no race to protect from.
> 
> (Could a newly detached tail be freshly faulted into userspace just
> before __split_huge_page() has reached the head?  Not quite, the
> fault has to wait to get the tail's page lock. But even if it
> could, how would that be a problem for __munlock_pagevec()?)
> 
> There's lots more that could be said: for example, PageMlocked will
> always be clear on the THP head during __split_huge_page_tail(),
> because the last unmap of a PageMlocked page does clear_page_mlock().
> But that's not required to prove the case, it's just another argument
> against the "Serialize" comment you have in __munlock_pagevec().
> 
> So, no need for the problematic lock_page_memcg(page) there in
> __munlock_pagevec(), nor to lock (or relock) lruvec just below it.
> __munlock_pagevec() still needs lru_lock to del_page_from_lru_list(),
> of course, but that must be done after your TestClearPageMlocked has
> stabilized page->memcg.  Use relock_page_lruvec_irq() here?  I suppose
> that will be easiest, but notice how __munlock_pagevec_fill() has
> already made sure that all the pages in the pagevec are from the same
> zone (and it cannot do the same for memcg without locking page memcg);
> so some of relock's work will be redundant.

It sounds reasonable for me.

> 
> Otherwise, I'm much happier with your mm/mlock.c since looking at it
> in more detail: a couple of nits though - drop the clear_page_mlock()
> hunk from 25/32 - kernel style says do it the way you are undoing by
> -	if (!isolate_lru_page(page)) {
> +	if (!isolate_lru_page(page))
>  		putback_lru_page(page);
> -	} else {
> +	else {
> I don't always follow that over-braced style when making changes,
> but you should not touch otherwise untouched code just to make it
> go against the approved style.  And in munlock_vma_page(),
> -	if (!TestClearPageMlocked(page)) {
> +	if (!TestClearPageMlocked(page))
>  		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
> -		nr_pages = 1;
> -		goto unlock_out;
> -	}
> +		return 0;
> please restore the braces: with that comment line in there,
> the compiler does not need the braces, but the human eye does.

Yes, That's better to keep the brace there.

Thanks
Alex
