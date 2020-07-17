From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v16 21/22] mm/pgdat: remove pgdat lru_lock
Date: Fri, 17 Jul 2020 14:09:56 -0700
Message-ID: <CAKgT0UeK3c4NjoJ7MQMxU20Bu0AZKZh73Cj4P_g5OSL6KaONhQ@mail.gmail.com>
References: <1594429136-20002-1-git-send-email-alex.shi@linux.alibaba.com> <1594429136-20002-22-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dGY2CcpG+3E/GgTnkS2Rd95XUJ3WTaSOrzDRZRkdebk=;
        b=sa1P3Kzy43hPp0azgBtrJI/pXdQyGU3ArG3VZQHof1cfxQQmHBeQQeVpshGq1qtzkK
         aBAQjNpjtj+EQMABp9exhFc8AUo0p2LhtVAG65w6G/tR2S5UGmVPeiKh+hajO6FDYAph
         U1KQA79kGahWeX4cDR3pNJ/b356kPljLVsr4WYt2pln96RFlzDzlY4wpXiUS3jg2Zx6j
         euuEe2heXStT+jZ8yGg5cLKlfGRrr5ecRH+A8kGeECQtWSPILkiLRM1rC0B8cs5TgewF
         zXwoYOXXzQZZf7DGH+xXYwv6Qwo8fh1NzT2bXAGvmyPwVpiw4RyiMBA4s/aKlvy9Mq8P
         COPA==
In-Reply-To: <1594429136-20002-22-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>

On Fri, Jul 10, 2020 at 5:59 PM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> Now pgdat.lru_lock was replaced by lruvec lock. It's not used anymore.
>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> ---
>  include/linux/mmzone.h | 1 -
>  mm/page_alloc.c        | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 36c1680efd90..8d7318ce5f62 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -735,7 +735,6 @@ struct deferred_split {
>
>         /* Write-intensive fields used by page reclaim */
>         ZONE_PADDING(_pad1_)
> -       spinlock_t              lru_lock;
>
>  #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
>         /*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e028b87ce294..4d7df42b32d6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6721,7 +6721,6 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
>         init_waitqueue_head(&pgdat->pfmemalloc_wait);
>
>         pgdat_page_ext_init(pgdat);
> -       spin_lock_init(&pgdat->lru_lock);
>         lruvec_init(&pgdat->__lruvec);
>  }
>

This patch would probably make more sense as part of patch 18 since
you removed all of the users of this field there.
