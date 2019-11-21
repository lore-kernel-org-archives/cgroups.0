From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH] mm: fix unsafe page -> lruvec lookups with cgroup charge
 migration
Date: Thu, 21 Nov 2019 21:03:36 +0800
Message-ID: <14b15e52-9fff-5497-d30c-2c7c4b99c35a@linux.alibaba.com>
References: <20191120165847.423540-1-hannes@cmpxchg.org>
 <alpine.LSU.2.11.1911201836220.1090@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.1911201836220.1090@eggly.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com


> It like the way you've rearranged isolate_lru_page() there, but I
> don't think it amounts to more than a cleanup.  Very good thinking
> about the odd "lruvec->pgdat = pgdat" case tucked away inside
> mem_cgroup_page_lruvec(), but actually, what harm does it do, if
> mem_cgroup_move_account() changes page->mem_cgroup concurrently?

Maybe the page could be added to root_mem_cgroup?

> 
> You say use-after-free, but we have spin_lock_irq here, and the
> struct mem_cgroup (and its lruvecs) cannot be freed until an RCU
> grace period expires, which we rely upon in many places, and which
> cannot happen until after the spin_unlock_irq.
> 
> And the same applies in the pagevec_lru_move functions, doesn't it?
> 
> I think now is not the time for such cleanups. If this fits well
> with Alex's per-lruvec locking (or represents an initial direction
> that you think he should follow), fine, but better to let him take it
> into his patchset in that case, than change the base unnecessarily
> underneath him.
> 
> (It happens to go against my own direction, since it separates the
> locking from the determination of lruvec, which I insist must be
> kept together; but perhaps that won't be quite the same for Alex.)
> 

It looks like we share the same base.

Before this patch, root memcg's lruvc lock could guards !PageLRU and it followings, But now, there are much holes in the wall. :)

Thanks
Alex
