From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Wed, 29 Jul 2020 09:00:06 +0800
Message-ID: <09aeced7-cc36-0c9a-d40b-451db9dc54cc@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com>
 <ccd01046-451c-463d-7c5d-9c32794f4b1e@linux.alibaba.com>
 <CAKgT0UdrQpa9OSusi=TZoj4RgC63-BNiF1GmeTG=rS47r7rGvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgT0UdrQpa9OSusi=TZoj4RgC63-BNiF1GmeTG=rS47r7rGvQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>



在 2020/7/28 下午10:54, Alexander Duyck 写道:
> On Tue, Jul 28, 2020 at 4:20 AM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>>
>>
>>
>> 在 2020/7/28 上午7:34, Alexander Duyck 写道:
>>>> @@ -1876,6 +1876,12 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>>>>                  *                                        list_add(&page->lru,)
>>>>                  *     list_add(&page->lru,) //corrupt
>>>>                  */
>>>> +               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
>>>> +               if (new_lruvec != lruvec) {
>>>> +                       if (lruvec)
>>>> +                               spin_unlock_irq(&lruvec->lru_lock);
>>>> +                       lruvec = lock_page_lruvec_irq(page);
>>>> +               }
>>>>                 SetPageLRU(page);
>>>>
>>>>                 if (unlikely(put_page_testzero(page))) {
>>> I was going through the code of the entire patch set and I noticed
>>> these changes in move_pages_to_lru. What is the reason for adding the
>>> new_lruvec logic? My understanding is that we are moving the pages to
>>> the lruvec provided are we not?If so why do we need to add code to get
>>> a new lruvec? The code itself seems to stand out from the rest of the
>>> patch as it is introducing new code instead of replacing existing
>>> locking code, and it doesn't match up with the description of what
>>> this function is supposed to do since it changes the lruvec.
>>
>> this new_lruvec is the replacement of removed line, as following code:
>>>> -               lruvec = mem_cgroup_page_lruvec(page, pgdat);
>> This recheck is for the page move the root memcg, otherwise it cause the bug:
> 
> Okay, now I see where the issue is. You moved this code so now it has
> a different effect than it did before. You are relocking things before
> you needed to. Don't forget that when you came into this function you
> already had the lock. In addition the patch is broken as it currently
> stands as you aren't using similar logic in the code just above this
> addition if you encounter an evictable page. As a result this is
> really difficult to review as there are subtle bugs here.

Why you think its a bug? the relock only happens if locked lruvec is different.
and unlock the old one.

> 
> I suppose the correct fix is to get rid of this line, but  it should
> be placed everywhere the original function was calling
> spin_lock_irq().
> 
> In addition I would consider changing the arguments/documentation for
> move_pages_to_lru. You aren't moving the pages to lruvec, so there is
> probably no need to pass that as an argument. Instead I would pass
> pgdat since that isn't going to be moving and is the only thing you
> actually derive based on the original lruvec.

yes, The comments should be changed with the line was introduced from long ago. :)
Anyway, I am wondering if it worth a v18 version resend?

> 
