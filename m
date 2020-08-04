From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH RFC] mm: Add function for testing if the current lruvec
 lock is valid
Date: Tue, 4 Aug 2020 14:13:43 +0800
Message-ID: <c5130b1b-cc60-d518-75d6-7a182fe9d343@linux.alibaba.com>
References: <1595681998-19193-19-git-send-email-alex.shi@linux.alibaba.com>
 <159622999150.2576729.14455020813024958573.stgit@ahduyck-desk1.jf.intel.com>
 <0c0a415a-52a0-5c06-b4be-80cbd3cb49c2@linux.alibaba.com>
 <CAKgT0UcDbzb_MXynzZANvJ_bV4VEguhxgOt2-hp4cNtvwE-r_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgT0UcDbzb_MXynzZANvJ_bV4VEguhxgOt2-hp4cNtvwE-r_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: "Duyck, Alexander H" <alexander.h.duyck@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, cgroups@vger.kernel.org, Daniel Jordan <daniel.m.jordan@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, "Kirill A. Shutemov" <kirill@shutemov.name>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, kbuild test robot <lkp@intel.com>, Mel Gorman <mgorman@techsingularity.net>, Wei Yang <richard.weiyang@gmail.com>, Rong Chen <rong.a.chen@intel.com>, Shakeel Butt <shakeelb@google.com>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy>



在 2020/8/3 上午2:20, Alexander Duyck 写道:
> Feel free to fold it into your patches if you want.
> 
> I think Hugh was the one that had submitted a patch that addressed it,
> and it looks like you folded that into your v17 set. It was probably
> what he had identified which was the additional LRU checks needing to
> be removed from the code.

Yes, Hugh's patch was folded into patch [PATCH v17 16/21] mm/swap: serialize memcg changes in pagevec_lru_move_fn
and your change is on patch 18. seems there are no interfere with each other.
Both of patches are fine.

Thanks

> 
> Thanks.
> 
> - Alex
> 
> On Fri, Jul 31, 2020 at 4:55 PM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>>
>> It looks much better than mine. and could replace 'mm/lru: introduce the relock_page_lruvec function'
>> with your author signed. :)
>>
>> BTW,
>> it's the rcu_read_lock cause the will-it-scale/page_fault3 regression which you mentained in another
>> letter?
>>
>> Thanks
>> Alex
>>
>> 在 2020/8/1 上午5:14, alexander.h.duyck@intel.com 写道:
>>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>
>>> When testing for relock we can avoid the need for RCU locking if we simply
>>> compare the page pgdat and memcg pointers versus those that the lruvec is
>>> holding. By doing this we can avoid the extra pointer walks and accesses of
>>> the memory cgroup.
>>>
>>> In addition we can avoid the checks entirely if lruvec is currently NULL.
>>>
>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>> ---
>>>  include/linux/memcontrol.h |   52 +++++++++++++++++++++++++++-----------------
>>>  1 file changed, 32 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 6e670f991b42..7a02f00bf3de 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -405,6 +405,22 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>>>
>>>  struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
>>>
>>> +static inline bool lruvec_holds_page_lru_lock(struct page *page,
>>> +                                           struct lruvec *lruvec)
>>> +{
>>> +     pg_data_t *pgdat = page_pgdat(page);
>>> +     const struct mem_cgroup *memcg;
>>> +     struct mem_cgroup_per_node *mz;
>>> +
>>> +     if (mem_cgroup_disabled())
>>> +             return lruvec == &pgdat->__lruvec;
>>> +
>>> +     mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
>>> +     memcg = page->mem_cgroup ? : root_mem_cgroup;
>>> +
>>> +     return lruvec->pgdat == pgdat && mz->memcg == memcg;
>>> +}
>>> +
>>>  struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
>>>
>>>  struct mem_cgroup *get_mem_cgroup_from_mm(struct mm_struct *mm);
>>> @@ -880,6 +896,14 @@ static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
>>>       return &pgdat->__lruvec;
>>>  }
>>>
>>> +static inline bool lruvec_holds_page_lru_lock(struct page *page,
>>> +                                           struct lruvec *lruvec)
>>> +{
>>> +             pg_data_t *pgdat = page_pgdat(page);
>>> +
>>> +             return lruvec == &pgdat->__lruvec;
>>> +}
>>> +
>>>  static inline struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg)
>>>  {
>>>       return NULL;
>>> @@ -1317,18 +1341,12 @@ static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
>>>  static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
>>>               struct lruvec *locked_lruvec)
>>>  {
>>> -     struct pglist_data *pgdat = page_pgdat(page);
>>> -     bool locked;
>>> +     if (locked_lruvec) {
>>> +             if (lruvec_holds_page_lru_lock(page, locked_lruvec))
>>> +                     return locked_lruvec;
>>>
>>> -     rcu_read_lock();
>>> -     locked = mem_cgroup_page_lruvec(page, pgdat) == locked_lruvec;
>>> -     rcu_read_unlock();
>>> -
>>> -     if (locked)
>>> -             return locked_lruvec;
>>> -
>>> -     if (locked_lruvec)
>>>               unlock_page_lruvec_irq(locked_lruvec);
>>> +     }
>>>
>>>       return lock_page_lruvec_irq(page);
>>>  }
>>> @@ -1337,18 +1355,12 @@ static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
>>>  static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
>>>               struct lruvec *locked_lruvec, unsigned long *flags)
>>>  {
>>> -     struct pglist_data *pgdat = page_pgdat(page);
>>> -     bool locked;
>>> -
>>> -     rcu_read_lock();
>>> -     locked = mem_cgroup_page_lruvec(page, pgdat) == locked_lruvec;
>>> -     rcu_read_unlock();
>>> -
>>> -     if (locked)
>>> -             return locked_lruvec;
>>> +     if (locked_lruvec) {
>>> +             if (lruvec_holds_page_lru_lock(page, locked_lruvec))
>>> +                     return locked_lruvec;
>>>
>>> -     if (locked_lruvec)
>>>               unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
>>> +     }
>>>
>>>       return lock_page_lruvec_irqsave(page, flags);
>>>  }
>>>
>>
