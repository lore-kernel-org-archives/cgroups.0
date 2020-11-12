From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v21 17/19] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Thu, 12 Nov 2020 22:19:33 +0800
Message-ID: <fe584528-9d9b-ac6d-bc9a-4be2d6b98cf4@linux.alibaba.com>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-18-git-send-email-alex.shi@linux.alibaba.com>
 <f9cfab13-fae2-c384-90b2-9e3107273734@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f9cfab13-fae2-c384-90b2-9e3107273734-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>



在 2020/11/12 下午8:19, Vlastimil Babka 写道:
> On 11/5/20 9:55 AM, Alex Shi wrote:
>> This patch moves per node lru_lock into lruvec, thus bring a lru_lock for
>> each of memcg per node. So on a large machine, each of memcg don't
>> have to suffer from per node pgdat->lru_lock competition. They could go
>> fast with their self lru_lock.
>>
>> After move memcg charge before lru inserting, page isolation could
>> serialize page's memcg, then per memcg lruvec lock is stable and could
>> replace per node lru lock.
>>
>> In func isolate_migratepages_block, compact_unlock_should_abort and
>> lock_page_lruvec_irqsave are open coded to work with compact_control.
>> Also add a debug func in locking which may give some clues if there are
>> sth out of hands.
>>
>> Daniel Jordan's testing show 62% improvement on modified readtwice case
>> on his 2P * 10 core * 2 HT broadwell box.
>> https://lore.kernel.org/lkml/20200915165807.kpp7uhiw7l3loofu-S51bK0XF4qpuJJETbFA3a0B3C2bhBk7L0E9HWUfgJXw@public.gmane.org/
>>
>> On a large machine with memcg enabled but not used, the page's lruvec
>> seeking pass a few pointers, that may lead to lru_lock holding time
>> increase and a bit regression.
>>
>> Hugh Dickins helped on the patch polish, thanks!
>>
>> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
>> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> I think I need some explanation about the rcu_read_lock() usage in lock_page_lruvec*() (and places effectively opencoding it).
> Preferably in form of some code comment, but that can be also added as a additional patch later, I don't want to block the series.
> 

Hi Vlastimil, 

Thanks for comments!

Oh, we did talk about the rcu_read_lock which is used to block memcg destroy during locking.
and the spin_lock actually includes a rcu_read_lock(). Yes, we could add this comments later.

> mem_cgroup_page_lruvec() comment says
> 
>  * This function relies on page->mem_cgroup being stable - see the
>  * access rules in commit_charge().
> 
> commit_charge() comment:
> 
>          * Any of the following ensures page->mem_cgroup stability:
>          *
>          * - the page lock
>          * - LRU isolation
>          * - lock_page_memcg()
>          * - exclusive reference
> 
> "LRU isolation" used to be quite clear, but now is it after TestClearPageLRU(page) or after deleting from the lru list as well?
> Also it doesn't mention rcu_read_lock(), should it?

The lru isolation still is same as old conception, a set actions that take a page from a lru list, and commit_charge do
need a isoltion for the page.

but the condition of page_memcg could be change since we don't rely on lru isolation for it. The comments
could be changed later.

> 
> So what exactly are we protecting by rcu_read_lock() in e.g. lock_page_lruvec()?
> 
>         rcu_read_lock();
>         lruvec = mem_cgroup_page_lruvec(page, pgdat);
>         spin_lock(&lruvec->lru_lock);
>         rcu_read_unlock();
> 
> Looks like we are protecting the lruvec from going away and it can't go away anymore after we take the lru_lock?
> 
> But then e.g. in __munlock_pagevec() we are doing this without an rcu_read_lock():
> 
>     new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));

TestClearPageLRU could block the page from memcg migration/destory.

Thanks
Alex

> 
> where new_lruvec is potentionally not the one that we have locked
> 
> And the last thing mem_cgroup_page_lruvec() is doing is:
> 
>         if (unlikely(lruvec->pgdat != pgdat))
>                 lruvec->pgdat = pgdat;
>         return lruvec;
> 
> So without the rcu_read_lock() is this potentionally accessing the pgdat field of lruvec that might have just gone away?
> 
> Thanks,
> Vlastimil
