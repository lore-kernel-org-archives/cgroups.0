From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 28 Jul 2020 15:15:34 +0800
Message-ID: <49d2a784-3560-4d97-ece2-f2dfb6941495@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>



在 2020/7/28 上午7:34, Alexander Duyck 写道:

>> @@ -847,11 +847,21 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>                  * contention, to give chance to IRQs. Abort completely if
>>                  * a fatal signal is pending.
>>                  */
>> -               if (!(low_pfn % SWAP_CLUSTER_MAX)
>> -                   && compact_unlock_should_abort(&pgdat->lru_lock,
>> -                                           flags, &locked, cc)) {
>> -                       low_pfn = 0;
>> -                       goto fatal_pending;
>> +               if (!(low_pfn % SWAP_CLUSTER_MAX)) {
>> +                       if (locked_lruvec) {
>> +                               unlock_page_lruvec_irqrestore(locked_lruvec,
>> +                                                                       flags);
>> +                               locked_lruvec = NULL;
>> +                       }
>> +
>> +                       if (fatal_signal_pending(current)) {
>> +                               cc->contended = true;
>> +
>> +                               low_pfn = 0;
>> +                               goto fatal_pending;
>> +                       }
>> +
>> +                       cond_resched();
>>                 }
>>
>>                 if (!pfn_valid_within(low_pfn))
> 
> I'm noticing this patch introduces a bunch of noise. What is the
> reason for getting rid of compact_unlock_should_abort? It seems like
> you just open coded it here. If there is some sort of issue with it
> then it might be better to replace it as part of a preparatory patch
> before you introduce this one as changes like this make it harder to
> review.

Thanks for comments, Alex.

the func compact_unlock_should_abort should be removed since one of parameters
changed from 'bool *locked' to 'struct lruvec *lruvec'. So it's not applicable
now. I have to open it here instead of adding a only one user func.

> 
> It might make more sense to look at modifying
> compact_unlock_should_abort and compact_lock_irqsave (which always
> returns true so should probably be a void) to address the deficiencies
> they have that make them unusable for you.

I am wondering if people like a patch which just open compact_unlock_should_abort
func and move bool to void as a preparation patch, do you like this?


>> @@ -966,10 +975,20 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>                 if (!TestClearPageLRU(page))
>>                         goto isolate_fail_put;
>>
>> +               rcu_read_lock();
>> +               lruvec = mem_cgroup_page_lruvec(page, pgdat);
>> +
>>                 /* If we already hold the lock, we can skip some rechecking */
>> -               if (!locked) {
>> -                       locked = compact_lock_irqsave(&pgdat->lru_lock,
>> -                                                               &flags, cc);
>> +               if (lruvec != locked_lruvec) {
>> +                       if (locked_lruvec)
>> +                               unlock_page_lruvec_irqrestore(locked_lruvec,
>> +                                                                       flags);
>> +
>> +                       compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
>> +                       locked_lruvec = lruvec;
>> +                       rcu_read_unlock();
>> +
>> +                       lruvec_memcg_debug(lruvec, page);
>>
>>                         /* Try get exclusive access under lock */
>>                         if (!skip_updated) {
> 
> So this bit makes things a bit complicated. From what I can can tell
> the comment about exclusive access under the lock is supposed to apply
> to the pageblock via the lru_lock. However you are having to retest
> the lock for each page because it is possible the page was moved to
> another memory cgroup while the lru_lock was released correct? So in

The pageblock is aligned by pfn, so pages in them maynot on same memcg
originally. and yes, page may be changed memcg also.

> this case is the lru vector lock really providing any protection for
> the skip_updated portion of this code block if the lock isn't
> exclusive to the pageblock? In theory this would probably make more
> sense to have protected the skip bits under the zone lock, but I
> imagine that was avoided due to the additional overhead.

when we change to lruvec->lru_lock, it does the same thing as pgdat->lru_lock.
just may get a bit more chance to here, and find out this is a skipable
pageblock and quit. 
Yes, logically, pgdat lru_lock seems better, but since we are holding lru_lock.
It's fine to not bother more locks.

> 
>> @@ -1876,6 +1876,12 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>>                  *                                        list_add(&page->lru,)
>>                  *     list_add(&page->lru,) //corrupt
>>                  */
>> +               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
>> +               if (new_lruvec != lruvec) {
>> +                       if (lruvec)
>> +                               spin_unlock_irq(&lruvec->lru_lock);
>> +                       lruvec = lock_page_lruvec_irq(page);
>> +               }
>>                 SetPageLRU(page);
>>
>>                 if (unlikely(put_page_testzero(page))) {
> 
> I was going through the code of the entire patch set and I noticed
> these changes in move_pages_to_lru. What is the reason for adding the
> new_lruvec logic? My understanding is that we are moving the pages to
> the lruvec provided are we not?If so why do we need to add code to get
> a new lruvec? The code itself seems to stand out from the rest of the
> patch as it is introducing new code instead of replacing existing
> locking code, and it doesn't match up with the description of what
> this function is supposed to do since it changes the lruvec.

A code here since some bugs happened. I will check it again anyway.

Thanks!
