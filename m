From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 15/22] mm/compaction: do page isolation first in
 compaction
Date: Fri, 17 Jul 2020 13:09:43 +0800
Message-ID: <e724c44b-4135-3302-16fa-1df624fa81fa@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-16-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0Ue72SfAmxCS+tay1NjioW9WBOvVgrhwUtVPz2aDCrcHPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0Ue72SfAmxCS+tay1NjioW9WBOvVgrhwUtVPz2aDCrcHPQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>


>> @@ -950,6 +951,21 @@ static bool too_many_isolated(pg_data_t *pgdat)
>>                 if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
>>                         goto isolate_fail;
>>
>> +               /*
>> +                * Be careful not to clear PageLRU until after we're
>> +                * sure the page is not being freed elsewhere -- the
>> +                * page release code relies on it.
>> +                */
>> +               if (unlikely(!get_page_unless_zero(page)))
>> +                       goto isolate_fail;
>> +
>> +               if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
>> +                       goto isolate_fail_put;
>> +
>> +               /* Try isolate the page */
>> +               if (!TestClearPageLRU(page))
>> +                       goto isolate_fail_put;
>> +
>>                 /* If we already hold the lock, we can skip some rechecking */
>>                 if (!locked) {
>>                         locked = compact_lock_irqsave(&pgdat->lru_lock,
> 
> Why not do the __isolate_lru_page_prepare before getting the page?
> That way you can avoid performing an extra atomic operation on non-LRU
> pages.
>

This change come from Hugh Dickins as mentioned from commit log:
>> trylock_page() is not safe to use at this time: its setting PG_locked
>> can race with the page being freed or allocated ("Bad page"), and can
>> also erase flags being set by one of those "sole owners" of a freshly
>> allocated page who use non-atomic __SetPageFlag().

Hi Hugh,

would you like to show more details of the bug?

...

>> +                        * sure the page is not being freed elsewhere -- the
>> +                        * page release code relies on it.
>> +                        */
>> +                       if (unlikely(!get_page_unless_zero(page)))
>> +                               goto busy;
>> +
>> +                       if (!TestClearPageLRU(page)) {
>> +                               /*
>> +                                * This page may in other isolation path,
>> +                                * but we still hold lru_lock.
>> +                                */
>> +                               put_page(page);
>> +                               goto busy;
>> +                       }
>> +
> 
> I wonder if it wouldn't make sense to combine these two atomic ops
> with tests and the put_page into a single inline function? Then it
> could be possible to just do one check and if succeeds you do the
> block of code below, otherwise you just fall-through into the -EBUSY
> case.
> 

Uh, since get_page changes page->_refcount, TestClearPageLRU changes page->flags,
So I don't know how to combine them, could you make it more clear with code?

Thanks
Alex
