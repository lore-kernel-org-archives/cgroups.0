From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v18 22/32] mm/vmscan: use relock for move_pages_to_lru
Date: Mon, 21 Sep 2020 22:44:16 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009212240370.6434@eggly.anvils>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com> <1598273705-69124-23-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=VqM0C5aizd06EEJhbPcKDGQSZnlrNdjhm1j3MXU1V80=;
        b=OCgfz6fy1qQPxVmz3FNoiB4+LRJSLY2XeCFt6IARQmhRwm/sfZYsUv+N4gUa7j3oe0
         iI8TK21X75WMXgA/oWIHyWGLTVX/UyWjTkPygXM01E7XHpWRo1ksBgMPlf6Dg2LTWkut
         8iVQ/GrKomUCJyx+l5lRaIE9kijzB/RlhSJMgIA5jx2wW0Ik0QWJxo3N068QOeg7LJ8A
         xca37W+dQsM7pfSykEykegXvuqOnWYf1COCWncsk7ZO8g3gHy7/n1mB0L71KWd2nAjAq
         FmIbVNw/01E9uWvCkYQKreyCjuFeQVtKvYJsbZ4UBJSf6QGj6yO5Kh/S9VcryWOQJlC5
         Vikw==
In-Reply-To: <1598273705-69124-23-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>

On Mon, 24 Aug 2020, Alex Shi wrote:

> From: Hugh Dickins <hughd@google.com>
> 
> Use the relock function to replace relocking action. And try to save few
> lock times.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

NAK. Who wrote this rubbish? Oh, did I? Maybe something you extracted
from my tarball. No, we don't need any of this now, as explained when
going through 20/32.

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  mm/vmscan.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2c94790d4cb1..04ef94190530 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1848,15 +1848,15 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  	enum lru_list lru;
>  
>  	while (!list_empty(list)) {
> -		struct lruvec *new_lruvec = NULL;
> -
>  		page = lru_to_page(list);
>  		VM_BUG_ON_PAGE(PageLRU(page), page);
>  		list_del(&page->lru);
>  		if (unlikely(!page_evictable(page))) {
> -			spin_unlock_irq(&lruvec->lru_lock);
> +			if (lruvec) {
> +				spin_unlock_irq(&lruvec->lru_lock);
> +				lruvec = NULL;
> +			}
>  			putback_lru_page(page);
> -			spin_lock_irq(&lruvec->lru_lock);
>  			continue;
>  		}
>  
> @@ -1871,12 +1871,7 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  		 *     list_add(&page->lru,)
>  		 *                                        list_add(&page->lru,)
>  		 */
> -		new_lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -		if (new_lruvec != lruvec) {
> -			if (lruvec)
> -				spin_unlock_irq(&lruvec->lru_lock);
> -			lruvec = lock_page_lruvec_irq(page);
> -		}
> +		lruvec = relock_page_lruvec_irq(page, lruvec);
>  		SetPageLRU(page);
>  
>  		if (unlikely(put_page_testzero(page))) {
> @@ -1885,8 +1880,8 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>  
>  			if (unlikely(PageCompound(page))) {
>  				spin_unlock_irq(&lruvec->lru_lock);
> +				lruvec = NULL;
>  				destroy_compound_page(page);
> -				spin_lock_irq(&lruvec->lru_lock);
>  			} else
>  				list_add(&page->lru, &pages_to_free);
>  
> -- 
> 1.8.3.1
