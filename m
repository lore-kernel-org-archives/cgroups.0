From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [RFC PATCH v2 4/5] mm: Split release_pages work into 3 passes
Date: Thu, 20 Aug 2020 17:49:49 +0800
Message-ID: <a88eef1b-242d-78c6-fecb-35ea00cd739b@linux.alibaba.com>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
 <20200819042730.23414.41309.stgit@localhost.localdomain>
 <15edf807-ce03-83f7-407d-5929341b2b4e@linux.alibaba.com>
 <CAKgT0UepdfjXn=j8e4xEBFmsNJdzJyN57em8dscr-Er4OBZCOg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UepdfjXn=j8e4xEBFmsNJdzJyN57em8dscr-Er4OBZCOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>



在 2020/8/19 下午10:57, Alexander Duyck 写道:
>>>       lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
>> the lock bounce is better with the patch, would you like to do further
>> like using add_lruvecs to reduce bounce more?
>>
>> Thanks
>> Alex
> I'm not sure how much doing something like that would add. In my case
> I had a very specific issue that this is addressing which is the fact
> that every compound page was taking the LRU lock and zone lock
> separately. With this patch that is reduced to one LRU lock per 15
> pages and then the zone lock per page. By adding or sorting pages by
> lruvec I am not sure there will be much benefit as I am not certain
> how often we will end up with pages being interleaved between multiple
> lruvecs. In addition as I am limiting the quantity to a pagevec which
> limits the pages to 15 I am not sure there will be much benefit to be
> seen for sorting the pages beforehand.
> 

the relock will unlock and get another lock again, the cost in that, the 2nd
lock need to wait for fairness for concurrency lruvec locking.
If we can do sort before, we should remove the fairness waiting here. Of course, 
perf result depends on scenarios.

Thanks
Alex
