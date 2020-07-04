From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v14 15/20] mm/swap: serialize memcg changes during
 pagevec_lru_move_fn
Date: Sat, 4 Jul 2020 23:47:11 +0800
Message-ID: <4a42888e-4d7e-0d76-358c-9a073e6e4794@linux.alibaba.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-16-git-send-email-alex.shi@linux.alibaba.com>
 <CALYGNiOkA_ZsycF_hqm3XLk55Ek1Mo9w1gO=6EeE35fUtA0i_w@mail.gmail.com>
 <56e395c6-81e7-7163-0d4f-42b91573289f@linux.alibaba.com>
 <20200704113944.GN25523@casper.infradead.org>
 <b6caf0d7-266e-55ea-0c88-656c800af1e3@linux.alibaba.com>
 <20200704133330.GP25523@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200704133330.GP25523@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, =?UTF-8?B?0JrQvtC90YHRgtCw0L3RgtC40L0g0KXQu9C10LHQvdC40LrQvtCy?= <khlebnikov@yandex-team.ru>, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, lkp@intel.com, linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, shakeelb@google.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>, richard.weiyang@gmail.com



在 2020/7/4 下午9:33, Matthew Wilcox 写道:
> On Sat, Jul 04, 2020 at 09:12:46PM +0800, Alex Shi wrote:
>> 在 2020/7/4 下午7:39, Matthew Wilcox 写道:
>>> On Sat, Jul 04, 2020 at 07:34:59PM +0800, Alex Shi wrote:
>>>> That's a great idea! Guess what the new struct we need would be like this?
>>>> I like to try this. :)
>>>>
>>>>
>>>> diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
>>>> index 081d934eda64..d62778c8c184 100644
>>>> --- a/include/linux/pagevec.h
>>>> +++ b/include/linux/pagevec.h
>>>> @@ -20,7 +20,7 @@
>>>>  struct pagevec {
>>>>         unsigned char nr;
>>>>         bool percpu_pvec_drained;
>>>> -       struct page *pages[PAGEVEC_SIZE];
>>>> +       struct list_head veclist;
>>>>  };
>>>
>>> pagevecs are used not just for LRU.  If you want to use a list_head for
>>> LRU then define a new structure.
>>
>> yes, there are much page don't use page->lru, like slab etc. we need a new struct> 
> That's not what I mean.  Slab pages aren't on the LRU anyway.

Right. I mean, that's reason for a new struct if we change to list.

> 
> Consider the callers of page_cache_delete_batch().  These use a pagevec
> for a non-LRU purpose, and they will be much slower with a list_head than
> with an array.
> 

Thanks for the info.
If the list is slower than pagevec, maybe it's not worth to do the change.
Since pagevec could handle any kind of pages, anon/file, non-active/active, but one
list only fit for just one kind of list. 5 kinds of list adding would increase the
complexity. Consider this, I am wondering if it's worth?

Thanks
Alex
