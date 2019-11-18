From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 18 Nov 2019 20:23:12 +0800
Message-ID: <3f179d84-85e2-bace-2dbc-e77f73883c71@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <CALvZod7oUmUCk96ATrRwYvrROFNqL1gPGt7fy949M8TMwCQrWA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALvZod7oUmUCk96ATrRwYvrROFNqL1gPGt7fy949M8TMwCQrWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kirill A. Shu



在 2019/11/16 下午3:03, Shakeel Butt 写道:
>> +reget_lruvec:
>> +               lruvec = mem_cgroup_page_lruvec(page, pgdat);
>> +
>>                 /* If we already hold the lock, we can skip some rechecking */
>> -               if (!locked) {
>> -                       locked = compact_lock_irqsave(&pgdat->lru_lock,
>> -                                                               &flags, cc);
>> +               if (lruvec != locked_lruvec) {
>> +                       if (locked_lruvec) {
>> +                               spin_unlock_irqrestore(&locked_lruvec->lru_lock,
>> +                                               locked_lruvec->irqflags);
>> +                               locked_lruvec = NULL;
>> +                       }
> What guarantees the lifetime of lruvec? You should read the comment on
> mem_cgroup_page_lruvec(). Have you seen the patches Hugh had shared?
> Please look at the  trylock_page_lruvec().
> 

Thanks for comments, Shakeel.

lruvec lifetime is same as memcg, which allocted in mem_cgroup_alloc()->alloc_mem_cgroup_per_node_info()
I have read Hugh's patchset, even not every lines. But what's point of you here?

> BTW have you tested Hugh's patches?
> 

yes, I have tried the case-lru-file-readtwice on my machine w/o containers, it show a bit more regression.

Thanks
Alex
