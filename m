From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v4 3/9] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Fri, 22 Nov 2019 10:36:32 +0800
Message-ID: <d3bbbbf5-52c5-374c-0897-899e787cecb4@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
 <1574166203-151975-4-git-send-email-alex.shi@linux.alibaba.com>
 <20191119160456.GD382712@cmpxchg.org>
 <bcf6a952-5b92-50ad-cfc1-f4d9f8f63172@linux.alibaba.com>
 <20191121220613.GB487872@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191121220613.GB487872@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, David Rientjes <rientjes@google.com>, Aneesh Ku



在 2019/11/22 上午6:06, Johannes Weiner 写道:
>>
>> Forgive my idiot, I still don't know the details of unsafe lruvec here.
>> From my shortsight, the spin_lock_irq(embedded a preempt_disable) could block all rcu syncing thus, keep all memcg alive until the preempt_enabled in unspinlock, is this right?
>> If so even the page->mem_cgroup is migrated to others cgroups, the new and old cgroup should still be alive here.
> You are right about the freeing part, I missed this. And I should have
> read this email here before sending out my "fix" to the current code;
> thankfully Hugh re-iterated my mistake on that thread. My apologies.
> 

That's all right. You and Hugh do give me a lot of help! :)

> But I still don't understand how the moving part is safe. You look up
> the lruvec optimistically, lock it, then verify the lookup. What keeps
> page->mem_cgroup from changing after you verified it?
> 
> lock_page_lruvec():				mem_cgroup_move_account():
> again:
> rcu_read_lock()
> lruvec = page->mem_cgroup->lruvec
> 						isolate_lru_page()
> spin_lock_irq(&lruvec->lru_lock)
> rcu_read_unlock()
> if page->mem_cgroup->lruvec != lruvec:
>   spin_unlock_irq(&lruvec->lru_lock)
>   goto again;
> 						page->mem_cgroup = new cgroup
> 						putback_lru_page() // new lruvec
> 						  SetPageLRU()
> return lruvec; // old lruvec
> 
> The caller assumes page belongs to the returned lruvec and will then
> change the page's lru state with a mismatched page and lruvec.
> 
Yes, that's the problem we have to deal.

> If we could restrict lock_page_lruvec() to working only on PageLRU
> pages, we could fix the problem with memory barriers. But this won't
> work for split_huge_page(), which is AFAICT the only user that needs
> to freeze the lru state of a page that could be isolated elsewhere.
> 
> So AFAICS the only option is to lock out mem_cgroup_move_account()
> entirely when the lru_lock is held. Which I guess should be fine.

I guess we can try from lock_page_memcg, is that a good start?


diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7e6387ad01f0..f4bbbf72c5b8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1224,7 +1224,7 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
                goto out;
        }

-       memcg = page->mem_cgroup;
+       memcg = lock_page_memcg(page);
        /*
         * Swapcache readahead pages are added to the LRU - and
         * possibly migrated - before they are charged.


Thanks a lot!
Alex
