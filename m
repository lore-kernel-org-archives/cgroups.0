From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v17 11/21] mm/lru: move lru_lock holding in func lru_note_cost_page
Date: Wed, 5 Aug 2020 14:18:28 -0700
Message-ID: <CAKgT0Udo=DSH76YF9L_qmWFNSCJW22UQaL57jHWnKstdB2wngg@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-12-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=47Asclv1FK7U2jk7VK/Qqzc/1uZms3QEdnET+4/Hxhw=;
        b=hOGXqAlmNmwjcpWgNq+i7sz0gXOY45BTpoSEyZ7rQgxc8KoTFIq72+Sp3FqRmWUGch
         BzMjQw9EsuXc1EkXuw4M/HNTKNKhWg44QfrlbEhDfVbFKVwxiTH5fO+RBDpeSKYxhAOr
         97nXaQN3SqulrQyeviEqOelMhLmtmdfPAGHC0nT6CaFiG+qOGEZpu2Ks27v8ughOlpC1
         us7d21TosVqDjmVTvwK4B6ovXoFxFbmAQXDdijY/4Ha+hwaSLqvZ1ShYcNjiOS3ASxsx
         nfMOwaEzMpqofoyw6UO9W6ksT52pUAYn7Fq1VrJHLjX1Fae7VbB0QTJ/W1+55pFwDJNQ
         CPqw==
In-Reply-To: <1595681998-19193-12-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Rong Chen <rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org> wrote:
>
> It's a clean up patch w/o function changes.
>
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Reviewed-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

> ---
>  mm/memory.c     | 3 ---
>  mm/swap.c       | 2 ++
>  mm/swap_state.c | 2 --
>  mm/workingset.c | 2 --
>  4 files changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 87ec87cdc1ff..dafc5585517e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3150,10 +3150,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                                  * XXX: Move to lru_cache_add() when it
>                                  * supports new vs putback
>                                  */
> -                               spin_lock_irq(&page_pgdat(page)->lru_lock);
>                                 lru_note_cost_page(page);
> -                               spin_unlock_irq(&page_pgdat(page)->lru_lock);
> -
>                                 lru_cache_add(page);
>                                 swap_readpage(page, true);
>                         }
> diff --git a/mm/swap.c b/mm/swap.c
> index dc8b02cdddcb..b88ca630db70 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -298,8 +298,10 @@ void lru_note_cost(struct lruvec *lruvec, bool file, unsigned int nr_pages)
>
>  void lru_note_cost_page(struct page *page)
>  {
> +       spin_lock_irq(&page_pgdat(page)->lru_lock);
>         lru_note_cost(mem_cgroup_page_lruvec(page, page_pgdat(page)),
>                       page_is_file_lru(page), hpage_nr_pages(page));
> +       spin_unlock_irq(&page_pgdat(page)->lru_lock);
>  }
>
>  static void __activate_page(struct page *page, struct lruvec *lruvec)
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 05889e8e3c97..080be52db6a8 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -440,9 +440,7 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>         }
>
>         /* XXX: Move to lru_cache_add() when it supports new vs putback */
> -       spin_lock_irq(&page_pgdat(page)->lru_lock);
>         lru_note_cost_page(page);
> -       spin_unlock_irq(&page_pgdat(page)->lru_lock);
>
>         /* Caller will initiate read into locked page */
>         SetPageWorkingset(page);
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 50b7937bab32..337d5b9ad132 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -372,9 +372,7 @@ void workingset_refault(struct page *page, void *shadow)
>         if (workingset) {
>                 SetPageWorkingset(page);
>                 /* XXX: Move to lru_cache_add() when it supports new vs putback */
> -               spin_lock_irq(&page_pgdat(page)->lru_lock);
>                 lru_note_cost_page(page);
> -               spin_unlock_irq(&page_pgdat(page)->lru_lock);
>                 inc_lruvec_state(lruvec, WORKINGSET_RESTORE);
>         }
>  out:
> --
> 1.8.3.1
>
