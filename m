From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v17 13/21] mm/lru: introduce TestClearPageLRU
Date: Wed, 5 Aug 2020 15:43:26 -0700
Message-ID: <CAKgT0Ud1+FkJcTXR0MxZYFxd7mr=opdXfXKTqkmiu4NNMyT4bg@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
 <1595681998-19193-14-git-send-email-alex.shi@linux.alibaba.com> <9b906469-38fb-8a4e-9a47-d617c7669579@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfR6T7oCaeLyjQ9SxVMOY64V3krO/aimxcAQ4bPIbX8=;
        b=WX7ocpjDWB4JEf5Vxc+bT7cgMR54ylfB0nbKx/qzh7bkB0tA+cJZEHy8v92TB+FSli
         yAb8tqjCXpaKNxV3c4mVPitLtQ3GD8PsOmxbGmkwASJI3nHicBPfYsD/QCMGwO3JVlye
         Ww5LE/35K3MqDoMsJAWFZfJwev8RbOSsDnXI8ZTFYy9lUdHnRYwb7UCucAl4RI+tZulZ
         HCP2BE4fPKbsUQhGEXIVV4K9GsxbJ9Ut9j/UmvlFtSA8fRMx1FbumPmln8vOY+WnKQJ4
         jIcjtWftqgCVQ9Gdd6ewkRxrIktn3qEczHiAjDFDh1Qforkax2YUAkzOni17zqB6W3bY
         4M7g==
In-Reply-To: <9b906469-38fb-8a4e-9a47-d617c7669579@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Tue, Jul 28, 2020 at 8:53 PM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> rewrite the commit log.
>
> From 9310c359b0049e3cc9827b771dc583d504bbf022 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@linux.alibaba.com>
> Date: Sat, 25 Apr 2020 12:03:30 +0800
> Subject: [PATCH v17 13/23] mm/lru: introduce TestClearPageLRU
>
> Currently lru_lock still guards both lru list and page's lru bit, that's
> ok. but if we want to use specific lruvec lock on the page, we need to
> pin down the page's lruvec/memcg during locking. Just taking lruvec
> lock first may be undermined by the page's memcg charge/migration. To
> fix this problem, we could clear the lru bit out of locking and use
> it as pin down action to block the page isolation in memcg changing.
>
> So now a standard steps of page isolation is following:
>         1, get_page();         #pin the page avoid to be free
>         2, TestClearPageLRU(); #block other isolation like memcg change
>         3, spin_lock on lru_lock; #serialize lru list access
>         4, delete page from lru list;
> The step 2 could be optimzed/replaced in scenarios which page is
> unlikely be accessed or be moved between memcgs.
>
> This patch start with the first part: TestClearPageLRU, which combines
> PageLRU check and ClearPageLRU into a macro func TestClearPageLRU. This
> function will be used as page isolation precondition to prevent other
> isolations some where else. Then there are may !PageLRU page on lru
> list, need to remove BUG() checking accordingly.
>
> There 2 rules for lru bit now:
> 1, the lru bit still indicate if a page on lru list, just in some
>    temporary moment(isolating), the page may have no lru bit when
>    it's on lru list.  but the page still must be on lru list when the
>    lru bit set.
> 2, have to remove lru bit before delete it from lru list.
>
> Hugh Dickins pointed that when a page is in free path and no one is
> possible to take it, non atomic lru bit clearing is better, like in
> __page_cache_release and release_pages.
> And no need get_page() before lru bit clear in isolate_lru_page,
> since it '(1) Must be called with an elevated refcount on the page'.
>
> As Andrew Morton mentioned this change would dirty cacheline for page
> isn't on LRU. But the lost would be acceptable with Rong Chen
> <rong.a.chen@intel.com> report:
> https://lkml.org/lkml/2020/3/4/173
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  include/linux/page-flags.h |  1 +
>  mm/mlock.c                 |  3 +--
>  mm/swap.c                  |  6 ++----
>  mm/vmscan.c                | 18 +++++++-----------
>  4 files changed, 11 insertions(+), 17 deletions(-)
>

<snip>

> diff --git a/mm/swap.c b/mm/swap.c
> index f645965fde0e..5092fe9c8c47 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -83,10 +83,9 @@ static void __page_cache_release(struct page *page)
>                 struct lruvec *lruvec;
>                 unsigned long flags;
>
> +               __ClearPageLRU(page);
>                 spin_lock_irqsave(&pgdat->lru_lock, flags);
>                 lruvec = mem_cgroup_page_lruvec(page, pgdat);
> -               VM_BUG_ON_PAGE(!PageLRU(page), page);
> -               __ClearPageLRU(page);
>                 del_page_from_lru_list(page, lruvec, page_off_lru(page));
>                 spin_unlock_irqrestore(&pgdat->lru_lock, flags);
>         }
> @@ -878,9 +877,8 @@ void release_pages(struct page **pages, int nr)
>                                 spin_lock_irqsave(&locked_pgdat->lru_lock, flags);
>                         }
>
> -                       lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
> -                       VM_BUG_ON_PAGE(!PageLRU(page), page);
>                         __ClearPageLRU(page);
> +                       lruvec = mem_cgroup_page_lruvec(page, locked_pgdat);
>                         del_page_from_lru_list(page, lruvec, page_off_lru(page));
>                 }
>

The more I look at this piece it seems like this change wasn't really
necessary. If anything it seems like it could catch potential bugs as
it was testing for the PageLRU flag before and then clearing it
manually anyway. In addition it doesn't reduce the critical path by
any significant amount so I am not sure these changes are providing
any benefit.
