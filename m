From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v17 03/21] mm/compaction: correct the comments of compact_defer_shift
Date: Mon, 27 Jul 2020 10:29:06 -0700
Message-ID: <CAKgT0UfmbdhpUdGy+4VircovmJfiJy9m-MN_o0LChNT_kWRUng@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-4-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Twl8egs2sgu9K2jUzyioOJdzChfT8oqMYRNtXj1w94Y=;
        b=bmEegtJgjmIbLBbTat5MprW8AbcHi/GCR+b/be88P4z6uYRhqOPQwZvY+KgtlwvHg1
         N4ICNnkrSuvMfHyrhCaMPTSaCWpTNZiYMoaBCFSEiX6+67oaI2o2Df46D+cTiuk6RKdH
         LWIB01sC9tVfimdUuCkacMamqOI4goVj7R8ybw+7+k22pVMpYzsI0LGnufsKU5FycBKV
         2q73J0Qm7SMd32tsPQMf3QShXIO6yNCb3aa4W9pF7X/T24ON0LbQvPOAuKLjAIkIiUYx
         ZyhLhQaLzj6rP7kU8egE6STMuJZQjb41Nkl75U7o8ci1ybC3TTzICtF1T3ozEhlXjbbt
         MncQ==
In-Reply-To: <1595681998-19193-4-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>

On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> There is no compact_defer_limit. It should be compact_defer_shift in
> use. and add compact_order_failed explanation.
>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/mmzone.h | 1 +
>  mm/compaction.c        | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f6f884970511..14c668b7e793 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -512,6 +512,7 @@ struct zone {
>          * On compaction failure, 1<<compact_defer_shift compactions
>          * are skipped before trying again. The number attempted since
>          * last failure is tracked with compact_considered.
> +        * compact_order_failed is the minimum compaction failed order.
>          */
>         unsigned int            compact_considered;
>         unsigned int            compact_defer_shift;
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 86375605faa9..cd1ef9e5e638 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -136,7 +136,7 @@ void __ClearPageMovable(struct page *page)
>
>  /*
>   * Compaction is deferred when compaction fails to result in a page
> - * allocation success. 1 << compact_defer_limit compactions are skipped up
> + * allocation success. compact_defer_shift++, compactions are skipped up
>   * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
>   */
>  void defer_compaction(struct zone *zone, int order)

So this doesn't read right. I wouldn't keep the "++," in the
explanation, and if we are going to refer to a limit of "1 <<
COMPACT_MAX_DEFER_SHIFT" then maybe this should be left as "1 <<
compact_defer_shift".
