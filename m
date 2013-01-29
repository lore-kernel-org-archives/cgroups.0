From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: simplify lock of memcg page stat accounting
Date: Tue, 29 Jan 2013 09:41:05 +0900
Message-ID: <51071AA1.7000207@jp.fujitsu.com>
References: <1359198756-3752-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359198756-3752-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

(2013/01/26 20:12), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> 
> After removing duplicated information like PCG_*
> flags in 'struct page_cgroup'(commit 2ff76f1193), there's a problem
> between "move" and "page stat accounting"(only FILE_MAPPED is supported
> now but other stats will be added in future):
> assume CPU-A does "page stat accounting" and CPU-B does "move"
> 
> CPU-A                        CPU-B
> TestSet PG_dirty
> (delay)              	move_lock_mem_cgroup()
>                          if (PageDirty(page)) {
>                               old_memcg->nr_dirty --
>                               new_memcg->nr_dirty++
>                          }
>                          pc->mem_cgroup = new_memcg;
>                          move_unlock_mem_cgroup()
> 
> move_lock_mem_cgroup()
> memcg = pc->mem_cgroup
> memcg->nr_dirty++
> move_unlock_mem_cgroup()
> 
> while accounting information of new_memcg may be double-counted. So we
> use a bigger lock to solve this problem:  (commit: 89c06bd52f)
> 
>        move_lock_mem_cgroup() <-- mem_cgroup_begin_update_page_stat()
>        TestSetPageDirty(page)
>        update page stats (without any checks)
>        move_unlock_mem_cgroup() <-- mem_cgroup_begin_update_page_stat()
> 
> 
> But this method also has its pros and cons: at present we use two layers
> of lock avoidance(memcg_moving and memcg->moving_account) then spinlock
> on memcg (see mem_cgroup_begin_update_page_stat()), but the lock granularity
> is a little bigger that not only the critical section but also some code
> logic is in the range of locking which may be deadlock prone. As dirty
> writeack stats are added, it gets into further difficulty with the page
> cache radix tree lock and it seems that the lock requires nesting.
> (https://lkml.org/lkml/2013/1/2/48)
> 
> So in order to make the lock simpler and clearer and also avoid the 'nesting'
> problem, a choice may be:
> (CPU-A does "page stat accounting" and CPU-B does "move")
> 
>         CPU-A                        CPU-B
> 
> move_lock_mem_cgroup()
> memcg = pc->mem_cgroup
> TestSetPageDirty(page)
> move_unlock_mem_cgroup()
>                               move_lock_mem_cgroup()
>                               if (PageDirty) {
>                                    old_memcg->nr_dirty --;
>                                    new_memcg->nr_dirty ++;
>                               }
>                               pc->mem_cgroup = new_memcg
>                               move_unlock_mem_cgroup()
> 
> memcg->nr_dirty ++
> 

Hmm. no race with file truncate ?


> 
> For CPU-A, we save pc->mem_cgroup in a temporary variable just before
> TestSetPageDirty inside move_lock and then update stats if the page is set
> PG_dirty successfully. But CPU-B may do "moving" in advance that
> "old_memcg->nr_dirty --" will make old_memcg->nr_dirty incorrect but
> soon CPU-A will do "memcg->nr_dirty ++" finally that amend the stats.
> 
> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/memcontrol.h |   14 +++++------
>   mm/memcontrol.c            |    8 ++-----
>   mm/rmap.c                  |   55 +++++++++++++++++++++++++++++++++-----------
>   3 files changed, 51 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0108a56..12de53b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -164,20 +164,20 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>   	rcu_read_unlock();
>   }
>   
> -void mem_cgroup_update_page_stat(struct page *page,
> +void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>   				 enum mem_cgroup_page_stat_item idx,
>   				 int val);
>   
> -static inline void mem_cgroup_inc_page_stat(struct page *page,
> +static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
>   					    enum mem_cgroup_page_stat_item idx)
>   {
> -	mem_cgroup_update_page_stat(page, idx, 1);
> +	mem_cgroup_update_page_stat(memcg, idx, 1);
>   }
>   
> -static inline void mem_cgroup_dec_page_stat(struct page *page,
> +static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
>   					    enum mem_cgroup_page_stat_item idx)
>   {
> -	mem_cgroup_update_page_stat(page, idx, -1);
> +	mem_cgroup_update_page_stat(memcg, idx, -1);
>   }
>   
>   unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
> @@ -354,12 +354,12 @@ static inline void mem_cgroup_end_update_page_stat(struct page *page,
>   {
>   }
>   
> -static inline void mem_cgroup_inc_page_stat(struct page *page,
> +static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
>   					    enum mem_cgroup_page_stat_item idx)
>   {
>   }
>   
> -static inline void mem_cgroup_dec_page_stat(struct page *page,
> +static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
>   					    enum mem_cgroup_page_stat_item idx)
>   {
>   }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3817460..1b13e43 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2259,18 +2259,14 @@ void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
>   	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
>   }
>   
> -void mem_cgroup_update_page_stat(struct page *page,
> +void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
>   				 enum mem_cgroup_page_stat_item idx, int val)
>   {
> -	struct mem_cgroup *memcg;
> -	struct page_cgroup *pc = lookup_page_cgroup(page);
> -	unsigned long uninitialized_var(flags);
>   
>   	if (mem_cgroup_disabled())
>   		return;
>   
> -	memcg = pc->mem_cgroup;
> -	if (unlikely(!memcg || !PageCgroupUsed(pc)))
> +	if (unlikely(!memcg))
>   		return;

I can't catch why you can do accounting without checking PCG_USED.
Could you add comments like

  * while accounting ops, mapping->tree_lock() or lock_page() is held
    and we have any race with truncation 
  etc...

>   
>   	switch (idx) {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 59b0dca..0d74c48 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1112,13 +1112,25 @@ void page_add_file_rmap(struct page *page)
>   {
>   	bool locked;
>   	unsigned long flags;
> +	bool ret;
> +	struct mem_cgroup *memcg = NULL;
> +	struct cgroup_subsys_state *css = NULL;
>   
>   	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
> -	if (atomic_inc_and_test(&page->_mapcount)) {
> +	memcg = try_get_mem_cgroup_from_page(page);

Toooooo heavy ! I can say NACK to this patch only because of this try_get().

To hold memcg alive, rcu_read_lock() will work (as current code does).

BTW, does this patch fixes the nested-lock problem ?

Thanks,
-Kame

