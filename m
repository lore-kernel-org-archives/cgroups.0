From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 14 Apr 2020 12:36:58 -0400
Message-ID: <20200414163658.GB136578@cmpxchg.org>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <cdcdb710-1d78-6fac-48d7-35519ddcdc6a@linux.alibaba.com>
 <20200413180725.GA99267@cmpxchg.org>
 <42d5c2cb-3019-993f-eba7-33a1d69ef699@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DYImV4WFqfjPjnkhvl2nD8nYSEJboQaYtVJWAd3b//Q=;
        b=KS5KSsAg991FP2nFTxhky8wQhQOu9BwakhqYU+efKhtive2f3PbE42bLxc5ZIjZRzc
         PNWD/LEGWAtMm5/XDuYn/2V4ghpqNkIk8WmZzEJDhpzW4YQNMk1oJKjjSmLLHWlxNlwS
         SRUHNobeIH59Sg0OvosYB0vVt4FtWC7jtzla2qHmPJoefzLEY2MgbK5IVRlVcrYE4yjp
         pbtJ8ktGppKUT+kjFT9pc36mAcNXqgmuiq2LD/VFTMh5hdHNLBGM4atG+Z8QcePqRbK+
         Va56KXOZ1ODNr3uJ0s9LW7EOHOBYLzqekZ1OIXQgckvam6fjqxNU8ywgqJZiDaF17jON
         qxUw==
Content-Disposition: inline
In-Reply-To: <42d5c2cb-3019-993f-eba7-33a1d69ef699@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Ku

On Tue, Apr 14, 2020 at 04:19:01PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/4/14 上午2:07, Johannes Weiner 写道:
> > But isolation actually needs to lock out charging, or it would operate
> > on the wrong list:
> > 
> > isolation:                                     commit_charge:
> > if (TestClearPageLRU(page))
> >                                                page->mem_cgroup = new
> >   // page is still physically on
> >   // the root_mem_cgroup's LRU. We're
> >   // updating the wrong list:
> >   memcg = page->mem_cgroup
> >   spin_lock(memcg->lru_lock)
> >   del_page_from_lru_list(page, memcg)
> >   spin_unlock(memcg->lru_lock)
> > 
> > lrucare really is a mess. Even before this patch series, it makes
> > things tricky and subtle and error prone.
> > 
> > The only reason we're doing it is for when there is swapping without
> > swap tracking, in which case swap reahadead needs to put pages on the
> > LRU but cannot charge them until we have a faulting vma later.
> > 
> > But it's not clear how practical such a configuration is. Both memory
> > and swap are shared resources, and isolation isn't really effective
> > when you restrict access to memory but then let workloads swap freely.
> > 
> > Plus, the overhead of tracking is tiny - 512k per G of swap (0.04%).
> > 
> > Maybe we should just delete MEMCG_SWAP and unconditionally track swap
> > entry ownership when the memory controller is enabled. I don't see a
> > good reason not to, and it would simplify the entire swapin path, the
> > LRU locking, and the page->mem_cgroup stabilization rules.
> 
> Hi Johannes,
> 
> I think what you mean here is to keep swap_cgroup id even it was swaped,
> then we read back the page from swap disk, we don't need to charge it.
> So all other memcg charge are just happens on non lru list, thus we have
> no isolation required in above awkward scenario.

We don't need to change how swap recording works, we just need to
always do it when CONFIG_MEMCG && CONFIG_SWAP.

We can uncharge the page once it's swapped out. The only difference is
that with a swap record, we know who owned the page and can charge
readahead pages right awya, before setting PageLRU; whereas without a
record, we read pages onto the LRU, and then wait until we hit a page
fault with an mm to charge. That's why we have this lrucare mess.
