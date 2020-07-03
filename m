From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH v14 15/20] mm/swap: serialize memcg changes during pagevec_lru_move_fn
Date: Fri, 3 Jul 2020 12:13:14 +0300
Message-ID: <CALYGNiOkA_ZsycF_hqm3XLk55Ek1Mo9w1gO=6EeE35fUtA0i_w@mail.gmail.com>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com> <1593752873-4493-16-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iaw9LIET2b5Zr3PfzFEZD0ZO7MflodPo5riog/VYOpY=;
        b=YpIy1IBvV/vLDmas280jG6wn7S0jnFsNNvzfC29z8poUfzNVniy27kGXdSPXMeuxQo
         9JSXKH42L1HWQIH+kXrA0YiI/7Zy401o50eq+uimBMyWhCYYRt+uQa9lR/eGlV42uabK
         mpvPUqYHyqrHmk7zLwDAln4Pr0T49Uc/f6p4N5Q+iN6sJwX1P4kCRJfrNMG2nUhf/nHL
         l+FEcYMwI/gtkC5uhtXAgzG4qm6YpjwREqczaUT2sqkIBVhrKlVRVqnIsFEpspNOeCLI
         ueS1v9GV7K3eTKXn1row8vxgATK6cOERngz1i7o3+hf+X25EKaGK0p1cFb/UagT0Ra2p
         jVUw==
In-Reply-To: <1593752873-4493-16-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, =?UTF-8?B?0JrQvtC90YHRgtCw0L3RgtC40L0g0KXQu9C10LHQvdC40LrQvtCy?= <khlebnikov@yandex-team.ru>, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, lkp@intel.com, linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, shakeelb@google.com, Joonsoo Kim <iamjoonsoo.kim@lge.com>, richard.weiyang@gmail.com

On Fri, Jul 3, 2020 at 8:09 AM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> Hugh Dickins' found a memcg change bug on original version:
> If we want to change the pgdat->lru_lock to memcg's lruvec lock, we have
> to serialize mem_cgroup_move_account during pagevec_lru_move_fn. The
> possible bad scenario would like:
>
>         cpu 0                                   cpu 1
> lruvec = mem_cgroup_page_lruvec()
>                                         if (!isolate_lru_page())
>                                                 mem_cgroup_move_account
>
> spin_lock_irqsave(&lruvec->lru_lock <== wrong lock.
>
> So we need the ClearPageLRU to block isolate_lru_page(), then serialize
> the memcg change here.
>
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/swap.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index b24d5f69b93a..55eb2c2eed03 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -203,7 +203,7 @@ int get_kernel_page(unsigned long start, int write, struct page **pages)
>  EXPORT_SYMBOL_GPL(get_kernel_page);
>
>  static void pagevec_lru_move_fn(struct pagevec *pvec,
> -       void (*move_fn)(struct page *page, struct lruvec *lruvec))
> +       void (*move_fn)(struct page *page, struct lruvec *lruvec), bool add)
>  {
>         int i;
>         struct pglist_data *pgdat = NULL;
> @@ -221,8 +221,15 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
>                         spin_lock_irqsave(&pgdat->lru_lock, flags);
>                 }
>
> +               /* new page add to lru or page moving between lru */
> +               if (!add && !TestClearPageLRU(page))
> +                       continue;
> +
>                 lruvec = mem_cgroup_page_lruvec(page, pgdat);
>                 (*move_fn)(page, lruvec);
> +
> +               if (!add)
> +                       SetPageLRU(page);
>         }
>         if (pgdat)
>                 spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> @@ -259,7 +266,7 @@ void rotate_reclaimable_page(struct page *page)
>                 local_lock_irqsave(&lru_rotate.lock, flags);
>                 pvec = this_cpu_ptr(&lru_rotate.pvec);
>                 if (!pagevec_add(pvec, page) || PageCompound(page))
> -                       pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
> +                       pagevec_lru_move_fn(pvec, pagevec_move_tail_fn, false);
>                 local_unlock_irqrestore(&lru_rotate.lock, flags);
>         }
>  }
> @@ -328,7 +335,7 @@ static void activate_page_drain(int cpu)
>         struct pagevec *pvec = &per_cpu(lru_pvecs.activate_page, cpu);
>
>         if (pagevec_count(pvec))
> -               pagevec_lru_move_fn(pvec, __activate_page);
> +               pagevec_lru_move_fn(pvec, __activate_page, false);
>  }
>
>  static bool need_activate_page_drain(int cpu)
> @@ -346,7 +353,7 @@ void activate_page(struct page *page)
>                 pvec = this_cpu_ptr(&lru_pvecs.activate_page);
>                 get_page(page);
>                 if (!pagevec_add(pvec, page) || PageCompound(page))
> -                       pagevec_lru_move_fn(pvec, __activate_page);
> +                       pagevec_lru_move_fn(pvec, __activate_page, false);
>                 local_unlock(&lru_pvecs.lock);
>         }
>  }
> @@ -621,21 +628,21 @@ void lru_add_drain_cpu(int cpu)
>
>                 /* No harm done if a racing interrupt already did this */
>                 local_lock_irqsave(&lru_rotate.lock, flags);
> -               pagevec_lru_move_fn(pvec, pagevec_move_tail_fn);
> +               pagevec_lru_move_fn(pvec, pagevec_move_tail_fn, false);
>                 local_unlock_irqrestore(&lru_rotate.lock, flags);
>         }
>
>         pvec = &per_cpu(lru_pvecs.lru_deactivate_file, cpu);
>         if (pagevec_count(pvec))
> -               pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
> +               pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, false);
>
>         pvec = &per_cpu(lru_pvecs.lru_deactivate, cpu);
>         if (pagevec_count(pvec))
> -               pagevec_lru_move_fn(pvec, lru_deactivate_fn);
> +               pagevec_lru_move_fn(pvec, lru_deactivate_fn, false);
>
>         pvec = &per_cpu(lru_pvecs.lru_lazyfree, cpu);
>         if (pagevec_count(pvec))
> -               pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
> +               pagevec_lru_move_fn(pvec, lru_lazyfree_fn, false);
>
>         activate_page_drain(cpu);
>  }
> @@ -664,7 +671,7 @@ void deactivate_file_page(struct page *page)
>                 pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate_file);
>
>                 if (!pagevec_add(pvec, page) || PageCompound(page))
> -                       pagevec_lru_move_fn(pvec, lru_deactivate_file_fn);
> +                       pagevec_lru_move_fn(pvec, lru_deactivate_file_fn, false);
>                 local_unlock(&lru_pvecs.lock);
>         }
>  }
> @@ -686,7 +693,7 @@ void deactivate_page(struct page *page)
>                 pvec = this_cpu_ptr(&lru_pvecs.lru_deactivate);
>                 get_page(page);
>                 if (!pagevec_add(pvec, page) || PageCompound(page))
> -                       pagevec_lru_move_fn(pvec, lru_deactivate_fn);
> +                       pagevec_lru_move_fn(pvec, lru_deactivate_fn, false);
>                 local_unlock(&lru_pvecs.lock);
>         }
>  }
> @@ -708,7 +715,7 @@ void mark_page_lazyfree(struct page *page)
>                 pvec = this_cpu_ptr(&lru_pvecs.lru_lazyfree);
>                 get_page(page);
>                 if (!pagevec_add(pvec, page) || PageCompound(page))
> -                       pagevec_lru_move_fn(pvec, lru_lazyfree_fn);
> +                       pagevec_lru_move_fn(pvec, lru_lazyfree_fn, false);
>                 local_unlock(&lru_pvecs.lock);
>         }
>  }
> @@ -976,7 +983,7 @@ static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec)
>   */
>  void __pagevec_lru_add(struct pagevec *pvec)
>  {
> -       pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn);
> +       pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, true);
>  }

It seems better to open code version in lru_add than adding a bool
argument which is true just for one user.

Also with this new lru protection logic lru_add could be optimized:
It could prepare a list of pages and under lru_lock do only list
splice and bumping counter.
Since PageLRU isn't set yet nobody could touch these pages in lru.
After that lru_add could iterate pages from first to last without
lru_lock to set PageLRU and drop reference.

So, lru_add will do O(1) operations under lru_lock regardless of the
count of pages it added.

Actually per-cpu vector for adding could be replaced with per-cpu
lists and\or per-lruvec atomic slist.
Thus incommig pages will be already in list structure rather than page vector.
This allows to accumulate more pages and offload adding to kswapd or
direct reclaim.

>
>  /**
> --
> 1.8.3.1
>
>
