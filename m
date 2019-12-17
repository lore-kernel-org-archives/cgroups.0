From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v6 02/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 17 Dec 2019 21:11:18 +0800
Message-ID: <a7b5c7bb-022f-60de-2d61-696915df002a@linux.alibaba.com>
References: <1576488386-32544-1-git-send-email-alex.shi@linux.alibaba.com>
 <1576488386-32544-3-git-send-email-alex.shi@linux.alibaba.com>
 <20191216121427.GZ32169@bombadil.infradead.org>
 <286c11c2-480f-37d6-e9fe-91822f862cd6@linux.alibaba.com>
 <20191217021613.GB32169@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191217021613.GB32169@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, shakeelb@google.com, hannes@cmpxchg.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Kum



在 2019/12/17 上午10:16, Matthew Wilcox 写道:
>>> You still didn't fix this function.  Go back and look at my comment from
>>> the last time you sent this patch set.
>>>
>> Sorry for the misunderstanding. I guess what your want is fold the patch 9th into this, is that right?
>> Any comments for the 9th patch?
> I didn't get as far as looking at the ninth patch because I saw this
> one was wrong and stopped looking.  This is not the first time *with
> this patch set* that you've been told to *fix the patch*, not submit
> something that's broken and fix it in a later patch.
> 
> I'll look at patch 9 later.


Thanks a lot for the nice cocaching and quick response!

What the problem for me here is I didn't find a bug here. From the commit_charge's explanations and mem_cgroup_commit_charge comments, as well as call path when lrucare is ture, The lock is just to guard the task migration(which would be lead to move_account) So, It's just a clean up to give up locking when !PageLRU in patch 9. And even w/o patch 9, the page just locked root_mem_cgroup's lru_lock, same as old function does, while the page isn't on any LRU. Useless, but it's still safe.

Do you mind to point out anything else I missed?

Thanks a lot!
Alex

