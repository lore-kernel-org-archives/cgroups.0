From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer list
Date: Mon, 6 Jan 2020 08:18:34 -0800
Message-ID: <CAKgT0Uf+EP8yGf93=R3XK0Y=0To0KQDys0O1BkG-Odej3Rwj5A@mail.gmail.com>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1iBF+C1NHazjfiJGahas8jIgSGj241V/MA8/jj2HpLE=;
        b=ScZ+BLpeYEmcBri4/E40jt+m15BKdbAIG7h7sy3ejJj/Dtb+nL8mk9HYuTan58Ac5v
         1jtRC/XgW9iWes1rejXCb5Nkiv5JXH6T9ZGxBYCL+6tKO6G18SbfNq01Hee7NCjGU29q
         sPkjPpV3m1fQxCSNdaOmoqXu4lvyH7Q5dXDZKFCvLTwrQW1XaQf0NumtQUoDu2227ya2
         DfJoLQvdnFKa7/6WrrmLuPVLOmX1NyFUKfWqUg8DzsYodq7qhN3ILwABQCrq9awbO9fu
         r430448Ffc4Qp7BbEPtygBu1l6bcwp97AvALV4Cn3puvjnJCSlDYaTHUm59DJXzKmGPX
         vWyQ==
In-Reply-To: <20200103143407.1089-1-richardw.yang@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, vdavydov.dev@gmail.com, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Yang Shi <yang.shi@linux.alibaba.com>

On Fri, Jan 3, 2020 at 6:34 AM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> As all the other places, we grab the lock before manipulate the defer list.
> Current implementation may face a race condition.
>
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
>
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>
> ---
> I notice the difference during code reading and just confused about the
> difference. No specific test is done since limited knowledge about cgroup.
>
> Maybe I miss something important?
> ---
>  mm/memcontrol.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bc01423277c5..62b7ec34ef1a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5368,12 +5368,12 @@ static int mem_cgroup_move_account(struct page *page,
>         }
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +       spin_lock(&from->deferred_split_queue.split_queue_lock);
>         if (compound && !list_empty(page_deferred_list(page))) {
> -               spin_lock(&from->deferred_split_queue.split_queue_lock);
>                 list_del_init(page_deferred_list(page));
>                 from->deferred_split_queue.split_queue_len--;
> -               spin_unlock(&from->deferred_split_queue.split_queue_lock);
>         }
> +       spin_unlock(&from->deferred_split_queue.split_queue_lock);
>  #endif
>         /*
>          * It is safe to change page->mem_cgroup here because the page

So I suspect the lock placement has to do with the compound boolean
value passed to the function.

One thing you might want to do is pull the "if (compound)" check out
and place it outside of the spinlock check. It would then simplify
this signficantly so it is something like
if (compound) {
  spin_lock();
  list = page_deferred_list(page);
  if (!list_empty(list)) {
    list_del_init(list);
    from->..split_queue_len--;
  }
  spin_unlock();
}

Same for the block below. I would pull the check for compound outside
of the spinlock call since it is a value that shouldn't change and
would eliminate an unnecessary lock in the non-compound case.

> @@ -5385,13 +5385,13 @@ static int mem_cgroup_move_account(struct page *page,
>         page->mem_cgroup = to;
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +       spin_lock(&to->deferred_split_queue.split_queue_lock);
>         if (compound && list_empty(page_deferred_list(page))) {
> -               spin_lock(&to->deferred_split_queue.split_queue_lock);
>                 list_add_tail(page_deferred_list(page),
>                               &to->deferred_split_queue.split_queue);
>                 to->deferred_split_queue.split_queue_len++;
> -               spin_unlock(&to->deferred_split_queue.split_queue_lock);
>         }
> +       spin_unlock(&to->deferred_split_queue.split_queue_lock);
>  #endif
>
>         spin_unlock_irqrestore(&from->move_lock, flags);
> --
