From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Fri, 22 Nov 2019 16:58:34 -0800 (PST)
Message-ID: <alpine.LSU.2.11.1911221616580.1144@eggly.anvils>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com> <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com> <20191119160456.GD382712@cmpxchg.org> <bcf6a952-5b92-50ad-cfc1-f4d9f8f63172@linux.alibaba.com> <20191121220613.GB487872@cmpxchg.org>
 <d3bbbbf5-52c5-374c-0897-899e787cecb4@linux.alibaba.com> <20191122161652.GA489821@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=IuWeFnrYeJCjuhCM2V1dA58lGjRpOtXacus/IBoPj+E=;
        b=SWT9RPbbH0wqbnY590Ng1zNYJSEYMwqyk2hjYVStgfe3cn8J9xhspUE/IhAhMyiyYF
         ITsmkvVswijzNTydtgsNqLfWO5AlPmHZfgbeP/ck3vqmG8WD1AthVOBjQq/7wIxhNj6N
         IhmPbMJDedgw7loa0CC2hR6GkM41ieeXfMen6GAXTZZY2Y0aEjcK/Bj1BejspvEmOXyA
         zo/hn1dh/4KxioncezIii0LXRSfDqEwYu6VZbBVGOhhR7OLAyWwJhZLPdB9oGfMaULZa
         gsxPSmoSKUVsQOHxRh4sawj5xROFzr/xaOzGB7fddbIKF3FVjM+LXYaqj5zXQ27i30Lz
         iu+g==
In-Reply-To: <20191122161652.GA489821@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jerome Glisse <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@goo>

On Fri, 22 Nov 2019, Johannes Weiner wrote:
> 
> But that leaves me with one more worry: compaction. We locked out
> charge moving now, so between that and knowing that the page is alive,
> we have page->mem_cgroup stable. But compaction doesn't know whether
> the page is alive - it comes from a pfn and finds out using PageLRU.
> 
> In the current code, pgdat->lru_lock remains the same before and after
> the page is charged to a cgroup, so once compaction has that locked
> and it observes PageLRU, it can go ahead and isolate the page.
> 
> But lruvec->lru_lock changes during charging, and then compaction may
> hold the wrong lock during isolation:
> 
> compaction:				generic_file_buffered_read:
> 
> 					page_cache_alloc()
> 
> !PageBuddy()
> 
> lock_page_lruvec(page)
>   lruvec = mem_cgroup_page_lruvec()
>   spin_lock(&lruvec->lru_lock)
>   if lruvec != mem_cgroup_page_lruvec()
>     goto again
> 
> 					add_to_page_cache_lru()
> 					  mem_cgroup_commit_charge()
> 					    page->mem_cgroup = foo
> 					  lru_cache_add()
> 					    __pagevec_lru_add()
> 					      SetPageLRU()
> 
> if PageLRU(page):
>   __isolate_lru_page()
> 
> I don't see what prevents the lruvec from changing under compaction,
> neither in your patches nor in Hugh's. Maybe I'm missing something?

Speaking for my patches only: I'm humbled, I think you have caught me,
I cannot find any argument against the race you suggest here.

The race with mem_cgroup_move_account(), which Konstantin pointed out
in 2012's https://lore.kernel.org/lkml/4F433418.3010401@openvz.org/
but I later misunderstood, and came to think I needed no patch against,
until this week coming to perceive the same race in isolate_lru_page():
that one is easily and satisfactorily fixed by holding lruvec lock in
mem_cgroup_move_account() - embarrassing, but not too serious.

Your race here (again, lruvec lock taken then PageLRU observed, but
page->mem_cgroup changed in between) really questions my whole scheme:
I am not going to propose a solution now, I'll have to go back and
recheck my assumptions all over.  Certainly isolate_migratepage_block()
has a harder job than any other, but I need to re-review it all.

Maybe we got it right back in the days of PageCgroupUsed, and then I
paid too little attention when rebasing to your welcome simplifications.
I don't think any of us want to bring back PageCgroupUsed! And maybe we
could get it right by always holding lruvec lock in commit_charge(),
lrucare or not; but that's a much hotter path, and not a change I'd
expect anyone to embrace.

I'll go away and re-examine it all; probably start by verifying that
your race actually happens in practice, though we never observed it.

Heavy-hearted thanks, Hannes!
Hugh
