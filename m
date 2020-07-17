From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v16 13/22] mm/lru: introduce TestClearPageLRU
Date: Fri, 17 Jul 2020 15:45:28 +0800
Message-ID: <072b39ac-b95a-94f1-67a2-3293d4550ff8@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-14-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UfLbVRQ4+TOw-XnjuyZqoVmRmWb5_rbEZZ0povYv-n_Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgT0UfLbVRQ4+TOw-XnjuyZqoVmRmWb5_rbEZZ0povYv-n_Lg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>



在 2020/7/17 上午5:12, Alexander Duyck 写道:
> On Fri, Jul 10, 2020 at 5:59 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>>
>> Combine PageLRU check and ClearPageLRU into a function by new
>> introduced func TestClearPageLRU. This function will be used as page
>> isolation precondition to prevent other isolations some where else.
>> Then there are may non PageLRU page on lru list, need to remove BUG
>> checking accordingly.
>>
>> Hugh Dickins pointed that __page_cache_release and release_pages
>> has no need to do atomic clear bit since no user on the page at that
>> moment. and no need get_page() before lru bit clear in isolate_lru_page,
>> since it '(1) Must be called with an elevated refcount on the page'.
>>
>> As Andrew Morton mentioned this change would dirty cacheline for page
>> isn't on LRU. But the lost would be acceptable with Rong Chen
>> <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> report:
>> https://lkml.org/lkml/2020/3/4/173
>>

...

>> diff --git a/mm/swap.c b/mm/swap.c
>> index f645965fde0e..5092fe9c8c47 100644
>> --- a/mm/swap.c
>> +++ b/mm/swap.c
>> @@ -83,10 +83,9 @@ static void __page_cache_release(struct page *page)
>>                 struct lruvec *lruvec;
>>                 unsigned long flags;
>>
>> +               __ClearPageLRU(page);
>>                 spin_lock_irqsave(&pgdat->lru_lock, flags);
>>                 lruvec = mem_cgroup_page_lruvec(page, pgdat);
>> -               VM_BUG_ON_PAGE(!PageLRU(page), page);
>> -               __ClearPageLRU(page);
>>                 del_page_from_lru_list(page, lruvec, page_off_lru(page));
>>                 spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>>         }
> 
> So this piece doesn't make much sense to me. Why not use
> TestClearPageLRU(page) here? Just a few lines above you are testing
> for PageLRU(page) and it seems like if you are going to go for an
> atomic test/clear and then remove the page from the LRU list you
> should be using it here as well otherwise it seems like you could run
> into a potential collision since you are testing here without clearing
> the bit.
> 

Hi Alex,

Thanks a lot for comments! 

In this func's call path __page_cache_release, the page is unlikely be
ClearPageLRU, since this page isn't used by anyone, and going to be freed.
just __ClearPageLRU would be safe, and could save a non lru page flags disturb.


>> @@ -878,9 +877,8 @@ void release_pages(struct page **pages, int nr)
>>                                 spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
>>                         }
>>
>> -                       lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>> -                       VM_BUG_ON_PAGE(!PageLRU(page), page);
>>                         __ClearPageLRU(page);
>> +                       lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>>                         del_page_from_lru_list(page, lruvec, page_off_lru(page));
>>                 }
>>
> 
> Same here. You are just moving the flag clearing, but you didn't
> combine it with the test. It seems like if you are expecting this to
> be treated as an atomic operation. It should be a relatively low cost
> to do since you already should own the cacheline as a result of
> calling put_page_testzero so I am not sure why you are not combining
> the two.

before the ClearPageLRU, there is a put_page_testzero(), that means no one using
this page, and isolate_lru_page can not run on this page the in func checking. 
	VM_BUG_ON_PAGE(!page_count(page), page);
So it would be safe here.


> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index c1c4259b4de5..18986fefd49b 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1548,16 +1548,16 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
>>  {
>>         int ret = -EINVAL;
>>
>> -       /* Only take pages on the LRU. */
>> -       if (!PageLRU(page))
>> -               return ret;
>> -
>>         /* Compaction should not handle unevictable pages but CMA can do so */
>>         if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
>>                 return ret;
>>
>>         ret = -EBUSY;
>>
>> +       /* Only take pages on the LRU. */
>> +       if (!PageLRU(page))
>> +               return ret;
>> +
>>         /*
>>          * To minimise LRU disruption, the caller can indicate that it only
>>          * wants to isolate pages it will be able to operate on without
>> @@ -1671,8 +1671,6 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>>                 page = lru_to_page(src);
>>                 prefetchw_prev_lru_page(page, src, flags);
>>
>> -               VM_BUG_ON_PAGE(!PageLRU(page), page);
>> -
>>                 nr_pages = compound_nr(page);
>>                 total_scan += nr_pages;
>>
> 
> So effectively the changes here are making it so that a !PageLRU page
> will cycle to the start of the LRU list. Now if I understand correctly
> we are guaranteed that if the flag is not set it cannot be set while
> we are holding the lru_lock, however it can be cleared while we are
> holding the lock, correct? Thus that is why isolate_lru_pages has to
> call TestClearPageLRU after the earlier check in __isolate_lru_page.

Right. 

> 
> It might make it more readable to pull in the later patch that
> modifies isolate_lru_pages that has it using TestClearPageLRU.
As to this change, It has to do in this patch, since any TestClearPageLRU may
cause lru bit miss in the lru list, so the precondication check has to
removed here.

Thank
Alex
