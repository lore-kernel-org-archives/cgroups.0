From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v16 19/22] mm/lru: introduce the relock_page_lruvec
 function
Date: Sat, 18 Jul 2020 22:01:40 +0800
Message-ID: <640e4081-3db3-c941-4b02-8a9aef26e7ba@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-20-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdL7ppCdszBNyY3O9d2stE0tCZ8vCzH7tBEnHG2ZwkZHg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgT0UdL7ppCdszBNyY3O9d2stE0tCZ8vCzH7tBEnHG2ZwkZHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>



在 2020/7/18 上午6:03, Alexander Duyck 写道:
>> index 129c532357a4..9fb906fbaed5 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -209,19 +209,12 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>>
>>         for (i = 0; i < pagevec_count(pvec); i++) {
>>                 struct page *page = pvec->pages[i];
>> -               struct lruvec *new_lruvec;
>> -
>> -               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
>> -               if (lruvec != new_lruvec) {
>> -                       if (lruvec)
>> -                               unlock_page_lruvec_irqrestore(lruvec, flags);
>> -                       lruvec = lock_page_lruvec_irqsave(page, &flags);
>> -               }
>>
>>                 /* block memcg migration during page moving between lru */
>>                 if (!TestClearPageLRU(page))
>>                         continue;
>>
>> +               lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
>>                 (*move_fn)(page, lruvec);
>>
>>                 SetPageLRU(page);
> So looking at this I realize that patch 18 probably should have
> ordered this the same way with the TestClearPageLRU happening before
> you fetched the new_lruvec. Otherwise I think you are potentially
> exposed to the original issue you were fixing the the previous patch
> that added the call to TestClearPageLRU.

Good catch. It's better to be aligned in next version.
Thanks!

> 
>> @@ -866,17 +859,12 @@ void release_pages(struct page **pages, int nr)
>>                 }
>>
>>                 if (PageLRU(page)) {
>> -                       struct lruvec *new_lruvec;
>> -
>> -                       new_lruvec = mem_cgroup_page_lruvec(page,
>> -                                                       page_pgdat(page));
>> -                       if (new_lruvec != lruvec) {
>> -                               if (lruvec)
>> -                                       unlock_page_lruvec_irqrestore(lruvec,
>> -                                                                       flags);
>> +                       struct lruvec *pre_lruvec = lruvec;
>> +
>> +                       lruvec = relock_page_lruvec_irqsave(page, lruvec,
>> +                                                                       &flags);
>> +                       if (pre_lruvec != lruvec)
> So this doesn't really read right. I suppose "pre_lruvec" should
> probably be "prev_lruvec" since I assume you mean "previous" not
> "before".

yes, it's previous, I will rename it.
Thanks
Alex
> 
