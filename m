From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 14/21] mm/compaction: do page isolation first in compaction
Date: Thu, 6 Aug 2020 11:38:50 -0700
Message-ID: <CAKgT0UcbBv=QBK9ErqLKXoNLYxFz52L4fiiHy4h6zKdBs=YPOg@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-15-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GL3TKI9RGqTkRYjAtmDHCYyxcqr3PHgkwqSzQbwkm0M=;
        b=dF5oGek43ef27jbrXZKchR302KjjUZ6kdwDChDS98FOmymm2DDgexZ05AvipGa9Wzk
         8fJ3KFcznJ426qICF8mkjNVEYw4bc6NVjZs8KiklcivqawtfnpxsHQ97MSZAcMQv8Kar
         P63SyEpp4xQRElTHkieUq8VTWyn/RNpjY4HpKr3fY2kJi5fqAtCBd0d8PXMdjNxGZuqH
         aIRmZSHOSrkWBvkf26n36Pr3xBlCw93w1Kc4kFnWT1E5/v9/p2E6IdclAnihPLukq0PZ
         Yp5NZ+i7eRYpOZZR0L4MdNCb1L331EVQkI21LtGycsDTF1k7btR74O5KQQN27d9eZnrQ
         6V7A==
In-Reply-To: <1595681998-19193-15-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> Currently, compaction would get the lru_lock and then do page isolation
> which works fine with pgdat->lru_lock, since any page isoltion would
> compete for the lru_lock. If we want to change to memcg lru_lock, we
> have to isolate the page before getting lru_lock, thus isoltion would
> block page's memcg change which relay on page isoltion too. Then we
> could safely use per memcg lru_lock later.
>
> The new page isolation use previous introduced TestClearPageLRU() +
> pgdat lru locking which will be changed to memcg lru lock later.
>
> Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> fixed following bugs in this patch's
> early version:
>
> Fix lots of crashes under compaction load: isolate_migratepages_block()
> must clean up appropriately when rejecting a page, setting PageLRU again
> if it had been cleared; and a put_page() after get_page_unless_zero()
> cannot safely be done while holding locked_lruvec - it may turn out to
> be the final put_page(), which will take an lruvec lock when PageLRU.
> And move __isolate_lru_page_prepare back after get_page_unless_zero to
> make trylock_page() safe:
> trylock_page() is not safe to use at this time: its setting PG_locked
> can race with the page being freed or allocated ("Bad page"), and can
> also erase flags being set by one of those "sole owners" of a freshly
> allocated page who use non-atomic __SetPageFlag().
>
> Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> ---
>  include/linux/swap.h |  2 +-
>  mm/compaction.c      | 42 +++++++++++++++++++++++++++++++++---------
>  mm/vmscan.c          | 46 ++++++++++++++++++++++++++--------------------
>  3 files changed, 60 insertions(+), 30 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 2c29399b29a0..6d23d3beeff7 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -358,7 +358,7 @@ extern void lru_cache_add_active_or_unevictable(struct page *page,
>  extern unsigned long zone_reclaimable_pages(struct zone *zone);
>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>                                         gfp_t gfp_mask, nodemask_t *mask);
> -extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
> +extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
>  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>                                                   unsigned long nr_pages,
>                                                   gfp_t gfp_mask,
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f14780fc296a..2da2933fe56b 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -869,6 +869,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                 if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
>                         if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
>                                 low_pfn = end_pfn;
> +                               page = NULL;
>                                 goto isolate_abort;
>                         }
>                         valid_page = page;
> @@ -950,6 +951,21 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                 if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
>                         goto isolate_fail;
>
> +               /*
> +                * Be careful not to clear PageLRU until after we're
> +                * sure the page is not being freed elsewhere -- the
> +                * page release code relies on it.
> +                */
> +               if (unlikely(!get_page_unless_zero(page)))
> +                       goto isolate_fail;
> +
> +               if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
> +                       goto isolate_fail_put;
> +
> +               /* Try isolate the page */
> +               if (!TestClearPageLRU(page))
> +                       goto isolate_fail_put;
> +
>                 /* If we already hold the lock, we can skip some rechecking */
>                 if (!locked) {
>                         locked = compact_lock_irqsave(&pgdat->lru_lock,
> @@ -962,10 +978,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                                         goto isolate_abort;
>                         }
>
> -                       /* Recheck PageLRU and PageCompound under lock */
> -                       if (!PageLRU(page))
> -                               goto isolate_fail;
> -
>                         /*
>                          * Page become compound since the non-locked check,
>                          * and it's on LRU. It can only be a THP so the order
> @@ -973,16 +985,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                          */
>                         if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
>                                 low_pfn += compound_nr(page) - 1;
> -                               goto isolate_fail;
> +                               SetPageLRU(page);
> +                               goto isolate_fail_put;
>                         }
>                 }
>
>                 lruvec = mem_cgroup_page_lruvec(page, pgdat);
>
> -               /* Try isolate the page */
> -               if (__isolate_lru_page(page, isolate_mode) != 0)
> -                       goto isolate_fail;
> -
>                 /* The whole page is taken off the LRU; skip the tail pages. */
>                 if (PageCompound(page))
>                         low_pfn += compound_nr(page) - 1;
> @@ -1011,6 +1020,15 @@ static bool too_many_isolated(pg_data_t *pgdat)
>                 }
>
>                 continue;
> +
> +isolate_fail_put:
> +               /* Avoid potential deadlock in freeing page under lru_lock */
> +               if (locked) {
> +                       spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +                       locked = false;
> +               }
> +               put_page(page);
> +
>  isolate_fail:
>                 if (!skip_on_failure)
>                         continue;
> @@ -1047,9 +1065,15 @@ static bool too_many_isolated(pg_data_t *pgdat)
>         if (unlikely(low_pfn > end_pfn))
>                 low_pfn = end_pfn;
>
> +       page = NULL;
> +
>  isolate_abort:
>         if (locked)
>                 spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> +       if (page) {
> +               SetPageLRU(page);
> +               put_page(page);
> +       }
>
>         /*
>          * Updated the cached scanner pfn once the pageblock has been scanned

We should probably be calling SetPageLRU before we release the lru
lock instead of before. It might make sense to just call it before we
get here, similar to how you did in the isolate_fail_put case a few
lines later. Otherwise this seems to violate the rules you had set up
earlier where we were only going to be setting the LRU bit while
holding the LRU lock.
