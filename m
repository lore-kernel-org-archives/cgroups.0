From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH v7 01/10] mm/vmscan: remove unnecessary lruvec adding
Date: Fri, 10 Jan 2020 11:39:58 +0300
Message-ID: <6c91fb0a-d4e0-d960-1cfd-62bef5cd15a5@yandex-team.ru>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-2-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1578645600; bh=jaVi2DcVyfdfNZXIP6KM4l6zW3qadoPbhC7P1cnSXTA=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=FBubMR+KQ0knT40UhvGjljtxUHp7ps+MArKaHtJ7QFqU2Hei2rVLpmHXKq5mOL+Hh
         uKDsUvMmjRXUwumg5BYr12IRS/Owqfyldw7i7LuiDic6SgPxTg9PVunNh6WOcwtce1
         CTTYlXplk9tD/r3lZFQBzqFTakkAtGzYYCDRrzlo=
In-Reply-To: <1577264666-246071-2-git-send-email-alex.shi@linux.alibaba.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: yun.wang@linux.alibaba.com

On 25/12/2019 12.04, Alex Shi wrote:
> We don't have to add a freeable page into lru and then remove from it.
> This change saves a couple of actions and makes the moving more clear.
> 
> The SetPageLRU needs to be kept here for list intergrity. Otherwise:
> 
>      #0 mave_pages_to_lru                #1 release_pages
>                                          if (put_page_testzero())
>      if (put_page_testzero())
> 	                                    !PageLRU //skip lru_lock
>                                                  list_add(&page->lru,);
>      else
>          list_add(&page->lru,) //corrupt
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: yun.wang@linux.alibaba.com
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   mm/vmscan.c | 16 +++++++---------
>   1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 572fb17c6273..8719361b47a0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1852,26 +1852,18 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,

Here is another cleanup: pass only pgdat as argument.

This function reavaluates lruvec for each page under lru lock.
Probably this is redundant for now but could be used in the future (or your patchset already use that).

>   	while (!list_empty(list)) {
>   		page = lru_to_page(list);
>   		VM_BUG_ON_PAGE(PageLRU(page), page);
> +		list_del(&page->lru);
>   		if (unlikely(!page_evictable(page))) {
> -			list_del(&page->lru);
>   			spin_unlock_irq(&pgdat->lru_lock);
>   			putback_lru_page(page);
>   			spin_lock_irq(&pgdat->lru_lock);
>   			continue;
>   		}
> -		lruvec = mem_cgroup_page_lruvec(page, pgdat);
> -

Please leave a comment that we must set PageLRU before dropping our page reference.

>   		SetPageLRU(page);
> -		lru = page_lru(page);
> -
> -		nr_pages = hpage_nr_pages(page);
> -		update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
> -		list_move(&page->lru, &lruvec->lists[lru]);
>   
>   		if (put_page_testzero(page)) {
>   			__ClearPageLRU(page);
>   			__ClearPageActive(page);
> -			del_page_from_lru_list(page, lruvec, lru);
>   
>   			if (unlikely(PageCompound(page))) {
>   				spin_unlock_irq(&pgdat->lru_lock);
> @@ -1880,6 +1872,12 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
>   			} else
>   				list_add(&page->lru, &pages_to_free);
>   		} else {
> +			lruvec = mem_cgroup_page_lruvec(page, pgdat);
> +			lru = page_lru(page);
> +			nr_pages = hpage_nr_pages(page);
> +
> +			update_lru_size(lruvec, lru, page_zonenum(page), nr_pages);
> +			list_add(&page->lru, &lruvec->lists[lru]);
>   			nr_moved += nr_pages;
>   		}

IMHO It looks better to in this way:

SetPageLRU()

if (unlikely(put_page_testzero())) {
  <free>
  continue;
}

<add>

>   	}
> 
