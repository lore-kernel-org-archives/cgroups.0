From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 15/22] mm/compaction: do page isolation first in
 compaction
Date: Sun, 19 Jul 2020 11:59:36 +0800
Message-ID: <dd0a75b5-c8b2-8b66-79b9-0f6ce259e227@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-16-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0Ue72SfAmxCS+tay1NjioW9WBOvVgrhwUtVPz2aDCrcHPQ@mail.gmail.com>
 <e724c44b-4135-3302-16fa-1df624fa81fa@linux.alibaba.com>
 <CAKgT0UcbvTid8RqDgsZjewdEo1wTD8BDjPHo59UX9gKQEkZUtA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UcbvTid8RqDgsZjewdEo1wTD8BDjPHo59UX9gKQEkZUtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>



在 2020/7/18 上午12:09, Alexander Duyck 写道:
>>> I wonder if it wouldn't make sense to combine these two atomic ops
>>> with tests and the put_page into a single inline function? Then it
>>> could be possible to just do one check and if succeeds you do the
>>> block of code below, otherwise you just fall-through into the -EBUSY
>>> case.
>>>
>> Uh, since get_page changes page->_refcount, TestClearPageLRU changes page->flags,
>> So I don't know how to combine them, could you make it more clear with code?
> Actually it is pretty straight forward. Something like this:
> static inline bool get_page_unless_zero_or_nonlru(struct page *page)
> {
>     if (get_page_unless_zero(page)) {
>         if (TestClearPageLRU(page))
>             return true;
>         put_page(page);
>     }
>     return false;
> }
> 
> You can then add comments as necessary. The general idea is you are
> having to do this in two different spots anyway so why not combine the
> logic? Although it does assume you can change the ordering of the
> other test above.


It doesn't look different with original code, does it?

Thanks
Alex
