From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v21 13/19] mm/mlock: remove __munlock_isolate_lru_page
Date: Wed, 11 Nov 2020 14:07:16 +0100
Message-ID: <2f501777-1fdd-73ba-b693-a0ebcb9ad8a4@suse.cz>
References: <1604566549-62481-1-git-send-email-alex.shi@linux.alibaba.com>
 <1604566549-62481-14-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1604566549-62481-14-git-send-email-alex.shi@linux.alibaba.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi@linux.alibaba.com>, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, hannes@cmpxchg.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

On 11/5/20 9:55 AM, Alex Shi wrote:
> The func only has one caller, remove it to clean up code and simplify
> code.
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Vlastimil Babka <vbabka@suse.cz>

Nit below:

> ---
>   mm/mlock.c | 31 +++++++++----------------------
>   1 file changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 796c726a0407..d487aa864e86 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -106,26 +106,6 @@ void mlock_vma_page(struct page *page)
>   }
>   
>   /*
> - * Isolate a page from LRU with optional get_page() pin.
> - * Assumes lru_lock already held and page already pinned.
> - */
> -static bool __munlock_isolate_lru_page(struct page *page, bool getpage)
> -{
> -	if (PageLRU(page)) {
> -		struct lruvec *lruvec;
> -
> -		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
> -		if (getpage)
> -			get_page(page);
> -		ClearPageLRU(page);
> -		del_page_from_lru_list(page, lruvec, page_lru(page));
> -		return true;
> -	}
> -
> -	return false;
> -}
> -
> -/*
>    * Finish munlock after successful page isolation
>    *
>    * Page must be locked. This is a wrapper for try_to_munlock()
> @@ -296,9 +276,16 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
>   			 * We already have pin from follow_page_mask()
>   			 * so we can spare the get_page() here.
>   			 */
> -			if (__munlock_isolate_lru_page(page, false))
> +			if (PageLRU(page)) {
> +				struct lruvec *lruvec;
> +
> +				ClearPageLRU(page);
> +				lruvec = mem_cgroup_page_lruvec(page,
> +							page_pgdat(page));
> +				del_page_from_lru_list(page, lruvec,
> +							page_lru(page));
>   				continue;
> -			else
> +			} else
>   				__munlock_isolation_failed(page);

IIRC coding styles says that once the if () part uses brackets, the else part 
should too, even if it's single line.

>   		} else {
>   			delta_munlocked++;
> 

