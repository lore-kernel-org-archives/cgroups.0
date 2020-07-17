From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v16 20/22] mm/vmscan: use relock for move_pages_to_lru
Date: Fri, 17 Jul 2020 14:44:14 -0700
Message-ID: <CAKgT0Ufp2FsJd+Lz9U2c_w5Eeb121xRg4SJ5Xoj2=9qZnVKkrA@mail.gmail.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com> <1594429136-20002-21-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Fd/5SIkVrVFZzPalYHXNTeKn+0gi9vnLo7/Yumj5M4=;
        b=bcKAE/Sf81eYZEfhBovzR8YAPYCTd4vV1lqFR9E9VoqmGNHRnfUkMDAduGb0PP8akQ
         sIlW/+OfHMBXiZosoLVNWKKIhZZ+lSCoSeecneDWd8o2XW60vFhgV379Zig5PvG5Uvwn
         FAYEykMn7Cm93tftDLUKMQicxkX74eQRjmgM+AJ0MfgC4qRz8mo8L379FYPq2kj/A3LY
         5EN8Cd8nRrLOiv6jwB1tAF8zlfSlmVAnyIzMIcrpfqZuoq0PMB4kH5NSnWFLfH+Z1Ik+
         fwM3jQYeDSTd8sllNRP5CAS3ccrRCFCNWwFvuh5/3k1slHFI8SbPsLoF4evxU2nHbRUH
         H1FA==
In-Reply-To: <1594429136-20002-21-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Jul 10, 2020 at 5:59 PM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> Use the relock function to replace relocking action. And try to save few
> lock times.
>
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> Cc: Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  mm/vmscan.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bdb53a678e7e..078a1640ec60 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1854,15 +1854,15 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>         enum lru_list lru;
>
>         while (!list_empty(list)) {
> -               struct lruvec *new_lruvec = NULL;
> -
>                 page = lru_to_page(list);
>                 VM_BUG_ON_PAGE(PageLRU(page), page);
>                 list_del(&page->lru);
>                 if (unlikely(!page_evictable(page))) {
> -                       spin_unlock_irq(&lruvec->lru_lock);
> +                       if (lruvec) {
> +                               spin_unlock_irq(&lruvec->lru_lock);
> +                               lruvec = NULL;
> +                       }
>                         putback_lru_page(page);
> -                       spin_lock_irq(&lruvec->lru_lock);
>                         continue;
>                 }
>
> @@ -1876,12 +1876,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>                  *                                        list_add(&page->lru,)
>                  *     list_add(&page->lru,) //corrupt
>                  */
> -               new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -               if (new_lruvec != lruvec) {
> -                       if (lruvec)
> -                               spin_unlock_irq(&lruvec->lru_lock);
> -                       lruvec = lock_page_lruvec_irq(page);
> -               }
> +               lruvec = relock_page_lruvec_irq(page, lruvec);
>                 SetPageLRU(page);
>
>                 if (unlikely(put_page_testzero(page))) {
> @@ -1890,8 +1885,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>
>                         if (unlikely(PageCompound(page))) {
>                                 spin_unlock_irq(&lruvec->lru_lock);
> +                               lruvec = NULL;
>                                 destroy_compound_page(page);
> -                               spin_lock_irq(&lruvec->lru_lock);
>                         } else
>                                 list_add(&page->lru, &pages_to_free);
>

It seems like this should just be rolled into patch 19. Otherwise if
you are wanting to consider it as a "further optimization" type patch
you might pull some of the optimizations you were pushing in patch 18
into this patch as well and just call it out as adding relocks where
there previously were none.
