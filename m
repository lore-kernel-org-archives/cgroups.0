From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 18/21] mm/lru: introduce the relock_page_lruvec function
Date: Wed, 29 Jul 2020 10:52:01 -0700
Message-ID: <CAKgT0UdFDcz=CQ+6mzcjh-apwy3UyPqAuOozvYr+2PSCNQrENA@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-19-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VBlR6JvMKpFF4I6cEiozKbbb6b38RhwCuKSXFCxjOBY=;
        b=BbAS+8cKgeQXImpsn8VUTIj5E9jS7pOeOZZuJs7yJcBS3WYt4zxTCXJncgw9qrRlKZ
         JSEao8c1IRX7/KzDmjLH1TZkcv9XjoBA5hZNqnzhpmh7J1fbNQB9iaZY+vuk6kaVu2o1
         D6w18a83AFD7Qea2KzU0Z4CfRQrwxMEAoxO0pU+iGD7Khq+imB/4kFtt+Cro8gVrfer6
         PxXgXA/ElnRARXP39gBsugGIMwsIUcmfeTxCqavE0tWKC+RTdTO07VvLaWAj2brGnxTh
         mbGLFtEii9t0scIc1deLu+4xGFiwO86SGDUVoq68nY9E9bPs+NOmcwbuhimgb8dROhlP
         or8w==
In-Reply-To: <1595681998-19193-19-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> Use this new function to replace repeated same code, no func change.
>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
> Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/memcontrol.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  mm/mlock.c                 |  9 +--------
>  mm/swap.c                  | 33 +++++++--------------------------
>  mm/vmscan.c                |  8 +-------
>  4 files changed, 49 insertions(+), 41 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 258901021c6c..6e670f991b42 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1313,6 +1313,46 @@ static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
>         spin_unlock_irqrestore(&lruvec->lru_lock, flags);
>  }
>
> +/* Don't lock again iff page's lruvec locked */
> +static inline struct lruvec *relock_page_lruvec_irq(struct page *page,
> +               struct lruvec *locked_lruvec)
> +{
> +       struct pglist_data *pgdat = page_pgdat(page);
> +       bool locked;
> +
> +       rcu_read_lock();
> +       locked = mem_cgroup_page_lruvec(page, pgdat) == locked_lruvec;
> +       rcu_read_unlock();
> +
> +       if (locked)
> +               return locked_lruvec;
> +
> +       if (locked_lruvec)
> +               unlock_page_lruvec_irq(locked_lruvec);
> +
> +       return lock_page_lruvec_irq(page);
> +}
> +
> +/* Don't lock again iff page's lruvec locked */
> +static inline struct lruvec *relock_page_lruvec_irqsave(struct page *page,
> +               struct lruvec *locked_lruvec, unsigned long *flags)
> +{
> +       struct pglist_data *pgdat = page_pgdat(page);
> +       bool locked;
> +
> +       rcu_read_lock();
> +       locked = mem_cgroup_page_lruvec(page, pgdat) == locked_lruvec;
> +       rcu_read_unlock();
> +
> +       if (locked)
> +               return locked_lruvec;
> +
> +       if (locked_lruvec)
> +               unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
> +
> +       return lock_page_lruvec_irqsave(page, flags);
> +}
> +

So looking these over they seem to be pretty inefficient for what they
do. Basically in worst case (locked_lruvec == NULL) you end up calling
mem_cgoup_page_lruvec and all the rcu_read_lock/unlock a couple times
for a single page. It might make more sense to structure this like:
if (locked_lruvec) {
    if (lruvec_holds_page_lru_lock(page, locked_lruvec))
        return locked_lruvec;

    unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
}
return lock_page_lruvec_irqsave(page, flags);

The other piece that has me scratching my head is that I wonder if we
couldn't do this without needing the rcu_read_lock. For example, what
if we were to compare the page mem_cgroup pointer to the memcg back
pointer stored in the mem_cgroup_per_node? It seems like ordering
things this way would significantly reduce the overhead due to the
pointer chasing to see if the page is in the locked lruvec or not.

>  #ifdef CONFIG_CGROUP_WRITEBACK
>
>  struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb);
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 5d40d259a931..bc2fb3bfbe7a 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -303,17 +303,10 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
>         /* Phase 1: page isolation */
>         for (i = 0; i < nr; i++) {
>                 struct page *page = pvec->pages[i];
> -               struct lruvec *new_lruvec;
>
>                 /* block memcg change in mem_cgroup_move_account */
>                 lock_page_memcg(page);
> -               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -               if (new_lruvec != lruvec) {
> -                       if (lruvec)
> -                               unlock_page_lruvec_irq(lruvec);
> -                       lruvec = lock_page_lruvec_irq(page);
> -               }
> -
> +               lruvec = relock_page_lruvec_irq(page, lruvec);
>                 if (TestClearPageMlocked(page)) {
>                         /*
>                          * We already have pin from follow_page_mask()
> diff --git a/mm/swap.c b/mm/swap.c
> index 09edac441eb6..6d9c7288f7de 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -209,19 +209,12 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>
>         for (i = 0; i < pagevec_count(pvec); i++) {
>                 struct page *page = pvec->pages[i];
> -               struct lruvec *new_lruvec;
>
>                 /* block memcg migration during page moving between lru */
>                 if (!TestClearPageLRU(page))
>                         continue;
>
> -               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -               if (lruvec != new_lruvec) {
> -                       if (lruvec)
> -                               unlock_page_lruvec_irqrestore(lruvec, flags);
> -                       lruvec = lock_page_lruvec_irqsave(page, &flags);
> -               }
> -
> +               lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
>                 (*move_fn)(page, lruvec);
>
>                 SetPageLRU(page);
> @@ -864,17 +857,12 @@ void release_pages(struct page **pages, int nr)
>                 }
>
>                 if (PageLRU(page)) {
> -                       struct lruvec *new_lruvec;
> -
> -                       new_lruvec = mem_cgroup_page_lruvec(page,
> -                                                       page_pgdat(page));
> -                       if (new_lruvec != lruvec) {
> -                               if (lruvec)
> -                                       unlock_page_lruvec_irqrestore(lruvec,
> -                                                                       flags);
> +                       struct lruvec *prev_lruvec = lruvec;
> +
> +                       lruvec = relock_page_lruvec_irqsave(page, lruvec,
> +                                                                       &flags);
> +                       if (prev_lruvec != lruvec)
>                                 lock_batch = 0;
> -                               lruvec = lock_page_lruvec_irqsave(page, &flags);
> -                       }
>
>                         __ClearPageLRU(page);
>                         del_page_from_lru_list(page, lruvec, page_off_lru(page));
> @@ -980,15 +968,8 @@ void __pagevec_lru_add(struct pagevec *pvec)
>
>         for (i = 0; i < pagevec_count(pvec); i++) {
>                 struct page *page = pvec->pages[i];
> -               struct lruvec *new_lruvec;
> -
> -               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -               if (lruvec != new_lruvec) {
> -                       if (lruvec)
> -                               unlock_page_lruvec_irqrestore(lruvec, flags);
> -                       lruvec = lock_page_lruvec_irqsave(page, &flags);
> -               }
>
> +               lruvec = relock_page_lruvec_irqsave(page, lruvec, &flags);
>                 __pagevec_lru_add_fn(page, lruvec);
>         }
>         if (lruvec)
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 168c1659e430..bdb53a678e7e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4292,15 +4292,9 @@ void check_move_unevictable_pages(struct pagevec *pvec)
>
>         for (i = 0; i < pvec->nr; i++) {
>                 struct page *page = pvec->pages[i];
> -               struct lruvec *new_lruvec;
>
>                 pgscanned++;
> -               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -               if (lruvec != new_lruvec) {
> -                       if (lruvec)
> -                               unlock_page_lruvec_irq(lruvec);
> -                       lruvec = lock_page_lruvec_irq(page);
> -               }
> +               lruvec = relock_page_lruvec_irq(page, lruvec);
>
>                 if (!PageLRU(page) || !PageUnevictable(page))
>                         continue;
> --
> 1.8.3.1
>
