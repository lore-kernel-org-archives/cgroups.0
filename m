From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 17/21] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Mon, 27 Jul 2020 16:34:15 -0700
Message-ID: <CAKgT0UdaW4Rf43yULhQBuP07vQgmoPbaWHGKv1Z7fEPP6jH83w@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-18-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AO+bby3fQrE72leYP1n2je6ks21A/uP8mKj5EGiF67s=;
        b=dRgpUVuSC5dcXxQ/Vfe9qZcPwtJwZIvtWhLvwHHw/lhgRWym35ymZDLYmEQmR/TFQs
         ETMrcxeiAqb8qJkymi/vvp3JuqzXHWSQGIjJ5nabqf15rc3agutMlR8+4SzJahJbP60G
         GlRkp7O5wsMtHolD8rQUgytpSSm28YXdFAaoO3Gq0Cp03VkFs/NQ0T8b87gPgcDaoe+t
         fMgNn49VxXrmIg0bQnNaVmW2aY69HxevVlbbPXJFVqI+IRK4827zV3QOu0ZYbUxEAqxZ
         9gH/sYEBbbAlaGWI6GFqZYD7TRPlR8RPgdltM+Vs09kYxDMiGv0e7b1QJbnMn4F96PNo
         o79A==
In-Reply-To: <1595681998-19193-18-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Sat, Jul 25, 2020 at 6:01 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> This patch moves per node lru_lock into lruvec, thus bring a lru_lock for
> each of memcg per node. So on a large machine, each of memcg don't
> have to suffer from per node pgdat->lru_lock competition. They could go
> fast with their self lru_lock.
>
> After move memcg charge before lru inserting, page isolation could
> serialize page's memcg, then per memcg lruvec lock is stable and could
> replace per node lru lock.
>
> According to Daniel Jordan's suggestion, I run 208 'dd' with on 104
> containers on a 2s * 26cores * HT box with a modefied case:
> https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice
>
> With this and later patches, the readtwice performance increases about
> 80% within concurrent containers.
>
> Also add a debug func in locking which may give some clues if there are
> sth out of hands.
>
> Hugh Dickins helped on patch polish, thanks!
>
> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  include/linux/memcontrol.h |  58 +++++++++++++++++++++++++
>  include/linux/mmzone.h     |   2 +
>  mm/compaction.c            |  67 ++++++++++++++++++-----------
>  mm/huge_memory.c           |  11 ++---
>  mm/memcontrol.c            |  63 ++++++++++++++++++++++++++-
>  mm/mlock.c                 |  47 +++++++++++++-------
>  mm/mmzone.c                |   1 +
>  mm/swap.c                  | 104 +++++++++++++++++++++------------------------
>  mm/vmscan.c                |  70 ++++++++++++++++--------------
>  9 files changed, 288 insertions(+), 135 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e77197a62809..258901021c6c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -411,6 +411,19 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>
>  struct mem_cgroup *get_mem_cgroup_from_page(struct page *page);
>
> +struct lruvec *lock_page_lruvec(struct page *page);
> +struct lruvec *lock_page_lruvec_irq(struct page *page);
> +struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> +                                               unsigned long *flags);
> +
> +#ifdef CONFIG_DEBUG_VM
> +void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page);
> +#else
> +static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
> +{
> +}
> +#endif
> +
>  static inline
>  struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css){
>         return css ? container_of(css, struct mem_cgroup, css) : NULL;
> @@ -892,6 +905,31 @@ static inline void mem_cgroup_put(struct mem_cgroup *memcg)
>  {
>  }
>
> +static inline struct lruvec *lock_page_lruvec(struct page *page)
> +{
> +       struct pglist_data *pgdat = page_pgdat(page);
> +
> +       spin_lock(&pgdat->__lruvec.lru_lock);
> +       return &pgdat->__lruvec;
> +}
> +
> +static inline struct lruvec *lock_page_lruvec_irq(struct page *page)
> +{
> +       struct pglist_data *pgdat = page_pgdat(page);
> +
> +       spin_lock_irq(&pgdat->__lruvec.lru_lock);
> +       return &pgdat->__lruvec;
> +}
> +
> +static inline struct lruvec *lock_page_lruvec_irqsave(struct page *page,
> +               unsigned long *flagsp)
> +{
> +       struct pglist_data *pgdat = page_pgdat(page);
> +
> +       spin_lock_irqsave(&pgdat->__lruvec.lru_lock, *flagsp);
> +       return &pgdat->__lruvec;
> +}
> +
>  static inline struct mem_cgroup *
>  mem_cgroup_iter(struct mem_cgroup *root,
>                 struct mem_cgroup *prev,
> @@ -1126,6 +1164,10 @@ static inline void count_memcg_page_event(struct page *page,
>  void count_memcg_event_mm(struct mm_struct *mm, enum vm_event_item idx)
>  {
>  }
> +
> +static inline void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
> +{
> +}
>  #endif /* CONFIG_MEMCG */
>
>  /* idx can be of type enum memcg_stat_item or node_stat_item */
> @@ -1255,6 +1297,22 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
>         return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
>  }
>
> +static inline void unlock_page_lruvec(struct lruvec *lruvec)
> +{
> +       spin_unlock(&lruvec->lru_lock);
> +}
> +
> +static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
> +{
> +       spin_unlock_irq(&lruvec->lru_lock);
> +}
> +
> +static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
> +               unsigned long flags)
> +{
> +       spin_unlock_irqrestore(&lruvec->lru_lock, flags);
> +}
> +
>  #ifdef CONFIG_CGROUP_WRITEBACK
>
>  struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 14c668b7e793..30b961a9a749 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -249,6 +249,8 @@ enum lruvec_flags {
>  };
>
>  struct lruvec {
> +       /* per lruvec lru_lock for memcg */
> +       spinlock_t                      lru_lock;
>         struct list_head                lists[NR_LRU_LISTS];
>         /*
>          * These track the cost of reclaiming one LRU - file or anon -
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 2da2933fe56b..88bbd2e93895 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -787,7 +787,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
>         unsigned long nr_scanned = 0, nr_isolated = 0;
>         struct lruvec *lruvec;
>         unsigned long flags = 0;
> -       bool locked = false;
> +       struct lruvec *locked_lruvec = NULL;
>         struct page *page = NULL, *valid_page = NULL;
>         unsigned long start_pfn = low_pfn;
>         bool skip_on_failure = false;
> @@ -847,11 +847,21 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                  * contention, to give chance to IRQs. Abort completely if
>                  * a fatal signal is pending.
>                  */
> -               if (!(low_pfn % SWAP_CLUSTER_MAX)
> -                   && compact_unlock_should_abort(&pgdat->lru_lock,
> -                                           flags, &locked, cc)) {
> -                       low_pfn = 0;
> -                       goto fatal_pending;
> +               if (!(low_pfn % SWAP_CLUSTER_MAX)) {
> +                       if (locked_lruvec) {
> +                               unlock_page_lruvec_irqrestore(locked_lruvec,
> +                                                                       flags);
> +                               locked_lruvec = NULL;
> +                       }
> +
> +                       if (fatal_signal_pending(current)) {
> +                               cc->contended = true;
> +
> +                               low_pfn = 0;
> +                               goto fatal_pending;
> +                       }
> +
> +                       cond_resched();
>                 }
>
>                 if (!pfn_valid_within(low_pfn))

I'm noticing this patch introduces a bunch of noise. What is the
reason for getting rid of compact_unlock_should_abort? It seems like
you just open coded it here. If there is some sort of issue with it
then it might be better to replace it as part of a preparatory patch
before you introduce this one as changes like this make it harder to
review.

It might make more sense to look at modifying
compact_unlock_should_abort and compact_lock_irqsave (which always
returns true so should probably be a void) to address the deficiencies
they have that make them unusable for you.

> @@ -922,10 +932,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                          */
>                         if (unlikely(__PageMovable(page)) &&
>                                         !PageIsolated(page)) {
> -                               if (locked) {
> -                                       spin_unlock_irqrestore(&pgdat->lru_lock,
> -                                                                       flags);
> -                                       locked = false;
> +                               if (locked_lruvec) {
> +                                       unlock_page_lruvec_irqrestore(locked_lruvec, flags);
> +                                       locked_lruvec = NULL;
>                                 }
>
>                                 if (!isolate_movable_page(page, isolate_mode))
> @@ -966,10 +975,20 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                 if (!TestClearPageLRU(page))
>                         goto isolate_fail_put;
>
> +               rcu_read_lock();
> +               lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +
>                 /* If we already hold the lock, we can skip some rechecking */
> -               if (!locked) {
> -                       locked = compact_lock_irqsave(&pgdat->lru_lock,
> -                                                               &flags, cc);
> +               if (lruvec != locked_lruvec) {
> +                       if (locked_lruvec)
> +                               unlock_page_lruvec_irqrestore(locked_lruvec,
> +                                                                       flags);
> +
> +                       compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
> +                       locked_lruvec = lruvec;
> +                       rcu_read_unlock();
> +
> +                       lruvec_memcg_debug(lruvec, page);
>
>                         /* Try get exclusive access under lock */
>                         if (!skip_updated) {

So this bit makes things a bit complicated. From what I can can tell
the comment about exclusive access under the lock is supposed to apply
to the pageblock via the lru_lock. However you are having to retest
the lock for each page because it is possible the page was moved to
another memory cgroup while the lru_lock was released correct? So in
this case is the lru vector lock really providing any protection for
the skip_updated portion of this code block if the lock isn't
exclusive to the pageblock? In theory this would probably make more
sense to have protected the skip bits under the zone lock, but I
imagine that was avoided due to the additional overhead.

> @@ -988,9 +1007,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                                 SetPageLRU(page);
>                                 goto isolate_fail_put;
>                         }
> -               }
> -
> -               lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +               } else
> +                       rcu_read_unlock();
>
>                 /* The whole page is taken off the LRU; skip the tail pages. */
>                 if (PageCompound(page))
> @@ -1023,9 +1041,9 @@ static bool too_many_isolated(pg_data_t *pgdat)
>
>  isolate_fail_put:
>                 /* Avoid potential deadlock in freeing page under lru_lock */
> -               if (locked) {
> -                       spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> -                       locked = false;
> +               if (locked_lruvec) {
> +                       unlock_page_lruvec_irqrestore(locked_lruvec, flags);
> +                       locked_lruvec = NULL;
>                 }
>                 put_page(page);
>
> @@ -1039,9 +1057,10 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                  * page anyway.
>                  */
>                 if (nr_isolated) {
> -                       if (locked) {
> -                               spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> -                               locked = false;
> +                       if (locked_lruvec) {
> +                               unlock_page_lruvec_irqrestore(locked_lruvec,
> +                                                                       flags);
> +                               locked_lruvec = NULL;
>                         }
>                         putback_movable_pages(&cc->migratepages);
>                         cc->nr_migratepages = 0;
> @@ -1068,8 +1087,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
>         page = NULL;
>
>  isolate_abort:
> -       if (locked)
> -               spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +       if (locked_lruvec)
> +               unlock_page_lruvec_irqrestore(locked_lruvec, flags);
>         if (page) {
>                 SetPageLRU(page);
>                 put_page(page);

<snip>

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f77748adc340..168c1659e430 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1774,15 +1774,13 @@ int isolate_lru_page(struct page *page)
>         WARN_RATELIMIT(PageTail(page), "trying to isolate tail page");
>
>         if (TestClearPageLRU(page)) {
> -               pg_data_t *pgdat = page_pgdat(page);
>                 struct lruvec *lruvec;
>                 int lru = page_lru(page);
>
>                 get_page(page);
> -               lruvec = mem_cgroup_page_lruvec(page, pgdat);
> -               spin_lock_irq(&pgdat->lru_lock);
> +               lruvec = lock_page_lruvec_irq(page);
>                 del_page_from_lru_list(page, lruvec, lru);
> -               spin_unlock_irq(&pgdat->lru_lock);
> +               unlock_page_lruvec_irq(lruvec);
>                 ret = 0;
>         }
>
> @@ -1849,20 +1847,22 @@ static int too_many_isolated(struct pglist_data *pgdat, int file,
>  static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>                                                      struct list_head *list)
>  {
> -       struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>         int nr_pages, nr_moved = 0;
>         LIST_HEAD(pages_to_free);
>         struct page *page;
> +       struct lruvec *orig_lruvec = lruvec;
>         enum lru_list lru;
>
>         while (!list_empty(list)) {
> +               struct lruvec *new_lruvec = NULL;
> +
>                 page = lru_to_page(list);
>                 VM_BUG_ON_PAGE(PageLRU(page), page);
>                 list_del(&page->lru);
>                 if (unlikely(!page_evictable(page))) {
> -                       spin_unlock_irq(&pgdat->lru_lock);
> +                       spin_unlock_irq(&lruvec->lru_lock);
>                         putback_lru_page(page);
> -                       spin_lock_irq(&pgdat->lru_lock);
> +                       spin_lock_irq(&lruvec->lru_lock);
>                         continue;
>                 }
>
> @@ -1876,6 +1876,12 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>                  *                                        list_add(&page->lru,)
>                  *     list_add(&page->lru,) //corrupt
>                  */
> +               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> +               if (new_lruvec != lruvec) {
> +                       if (lruvec)
> +                               spin_unlock_irq(&lruvec->lru_lock);
> +                       lruvec = lock_page_lruvec_irq(page);
> +               }
>                 SetPageLRU(page);
>
>                 if (unlikely(put_page_testzero(page))) {

I was going through the code of the entire patch set and I noticed
these changes in move_pages_to_lru. What is the reason for adding the
new_lruvec logic? My understanding is that we are moving the pages to
the lruvec provided are we not?If so why do we need to add code to get
a new lruvec? The code itself seems to stand out from the rest of the
patch as it is introducing new code instead of replacing existing
locking code, and it doesn't match up with the description of what
this function is supposed to do since it changes the lruvec.

> @@ -1883,16 +1889,15 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>                         __ClearPageActive(page);
>
>                         if (unlikely(PageCompound(page))) {
> -                               spin_unlock_irq(&pgdat->lru_lock);
> +                               spin_unlock_irq(&lruvec->lru_lock);
>                                 destroy_compound_page(page);
> -                               spin_lock_irq(&pgdat->lru_lock);
> +                               spin_lock_irq(&lruvec->lru_lock);
>                         } else
>                                 list_add(&page->lru, &pages_to_free);
>
>                         continue;
>                 }
>
> -               lruvec = mem_cgroup_page_lruvec(page, pgdat);
>                 lru = page_lru(page);
>                 nr_pages = hpage_nr_pages(page);
>
> @@ -1902,6 +1907,11 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>                 if (PageActive(page))
>                         workingset_age_nonresident(lruvec, nr_pages);
>         }
> +       if (orig_lruvec != lruvec) {
> +               if (lruvec)
> +                       spin_unlock_irq(&lruvec->lru_lock);
> +               spin_lock_irq(&orig_lruvec->lru_lock);
> +       }
>
>         /*
>          * To save our caller's stack, now use input list for pages to free.
