From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Wed, 29 Jul 2020 08:48:00 +0800
Message-ID: <cb49a573-8d24-d289-199d-8058cd79b89b@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com>
 <1fd45e69-3a50-aae8-bcc4-47d891a5e263@linux.alibaba.com>
 <CAKgT0UfWckn0npij5UhEEmMKuG0bRytN3kPDtvvE3AdJuEZjJg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgT0UfWckn0npij5UhEEmMKuG0bRytN3kPDtvvE3AdJuEZjJg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>



在 2020/7/28 下午11:55, Alexander Duyck 写道:
>>  /*
>> @@ -511,11 +511,11 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
>>   *             scheduled)
>>   */
>>  static bool compact_unlock_should_abort(spinlock_t *lock,
>> -               unsigned long flags, bool *locked, struct compact_control *cc)
>> +               unsigned long flags, void **locked, struct compact_control *cc)
> Instead of passing both a void pointer and the lock why not just pass
> the pointer to the lock pointer? You could combine lock and locked
> into a single argument and save yourself some extra effort.
> 

the passed locked pointer could be rewrite in the func, that is unacceptable if it is a lock which could
be used other place.

And it is alreay dangerous to NULL a local pointer. In fact, I perfer the orignal verion, not so smart
but rebust enough for future changes, right?

Thanks
Alex


>>  {
>>         if (*locked) {
>>                 spin_unlock_irqrestore(lock, flags);
>> -               *locked = false;
>> +               *locked = NULL;
>>         }
>>
>>         if (fatal_signal_pending(current)) {
