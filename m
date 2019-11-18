From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 18 Nov 2019 20:31:50 +0800
Message-ID: <296c7202-930e-4027-2e92-b8c64a908d88@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191116043806.GD20752@bombadil.infradead.org>
 <0bfa9a03-b095-df83-9cfd-146da9aab89a@linux.alibaba.com>
 <20191118121451.GG20752@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191118121451.GG20752@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <>



在 2019/11/18 下午8:14, Matthew Wilcox 写道:
>> Hi Matthew,
>>
>> Thanks for comments!
>>
>> Here, the irqflags is bound, and belong to lruvec, merging them into together helps us to take them as whole, and thus reduce a unnecessary code clues.
> It's not bound to the lruvec, though.  Call chain A uses it and call chain
> B doesn't.  If it was always used by every call chain, I'd see your point,
> but we have call chains which don't use it, and so it adds complexity.

Where is the call chain B, please?

> 
>> As your concern for a 'new' caller, since __split_huge_page is a static helper here, no distub for anyothers.
> Even though it's static, there may be other callers within the same file.
> Or somebody may decide to make it non-static in the future.  I think it's
> actually clearer to keep the irqflags as a separate parameter.
> 

But it's no one else using this function now. and no one get disturb, right? It's non sense to consider a 'possibility' issue.

