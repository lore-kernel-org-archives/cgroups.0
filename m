From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v16 20/22] mm/vmscan: use relock for move_pages_to_lru
Date: Sat, 18 Jul 2020 22:15:25 +0800
Message-ID: <7176001a-fa58-3281-7c6b-b25eea54bd15@linux.alibaba.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com>
 <1594429136-20002-21-git-send-email-alex.shi@linux.alibaba.com>
 <CAKgT0Ufp2FsJd+Lz9U2c_w5Eeb121xRg4SJ5Xoj2=9qZnVKkrA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgT0Ufp2FsJd+Lz9U2c_w5Eeb121xRg4SJ5Xoj2=9qZnVKkrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>



在 2020/7/18 上午5:44, Alexander Duyck 写道:
>>                         if (unlikely(PageCompound(page))) {
>>                                 spin_unlock_irq(&lruvec->lru_lock);
>> +                               lruvec = NULL;
>>                                 destroy_compound_page(page);
>> -                               spin_lock_irq(&lruvec->lru_lock);
>>                         } else
>>                                 list_add(&page->lru, &pages_to_free);
>>
> It seems like this should just be rolled into patch 19. Otherwise if
> you are wanting to consider it as a "further optimization" type patch
> you might pull some of the optimizations you were pushing in patch 18
> into this patch as well and just call it out as adding relocks where
> there previously were none.

This patch is picked from Hugh Dickin's version in my review. It could be
fine to have a extra patch which no harm for anyone. :)

Thanks
Alex
