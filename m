From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 04/11] mm: vmscan: rework move_pages_to_lru()
Date: Tue, 24 May 2022 15:38:50 -0400
Message-ID: <Yo00Svsy/N8cJVmf@cmpxchg.org>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-5-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OnMNwdiDuKNvcNvHgJhe6ilL5BSVkcDVAFFW/UQvNfs=;
        b=pSUp9QP4W736sqLANtAdsbjcRxz7NxrgIsEjTxS91pMbK6MTlMhrm614GZKG+ZIZbh
         iy9WT5WKW0//Z4XyhuoEObIzJK7/VSRFbhHydJajpTdSneWWzCXiZ+Qd92OzgcqAjq/B
         DgRjbCbFqtxfsgTgZLqSu5BOxuSvCQVg1SrGaDKURpJhCRAhkJm+k7oixIVzT3lJdFlx
         oTz3WPP00s/i7i+MIM5I+ZU01FbelOHQX9riGe2P9gCaRTQ0imjJ4ZWrUAmXI6xOYg56
         w43gFLQ9qfZxe34KG9XEHzI7kFN5BbtFfjsEea8+I/OaP6R5fmeQM7sMVnflF1nol3iw
         cwcA==
Content-Disposition: inline
In-Reply-To: <20220524060551.80037-5-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 02:05:44PM +0800, Muchun Song wrote:
> In the later patch, we will reparent the LRU pages. The pages moved to
> appropriate LRU list can be reparented during the process of the
> move_pages_to_lru(). So holding a lruvec lock by the caller is wrong, we
> should use the more general interface of folio_lruvec_relock_irq() to
> acquire the correct lruvec lock.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/vmscan.c | 49 +++++++++++++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1678802e03e7..761d5e0dd78d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2230,23 +2230,28 @@ static int too_many_isolated(struct pglist_data *pgdat, int file,
>   * move_pages_to_lru() moves pages from private @list to appropriate LRU list.
>   * On return, @list is reused as a list of pages to be freed by the caller.
>   *
> - * Returns the number of pages moved to the given lruvec.
> + * Returns the number of pages moved to the appropriate LRU list.
> + *
> + * Note: The caller must not hold any lruvec lock.
>   */
> -static unsigned int move_pages_to_lru(struct lruvec *lruvec,
> -				      struct list_head *list)
> +static unsigned int move_pages_to_lru(struct list_head *list)
>  {
> -	int nr_pages, nr_moved = 0;
> +	int nr_moved = 0;
> +	struct lruvec *lruvec = NULL;
>  	LIST_HEAD(pages_to_free);
> -	struct page *page;
>  
>  	while (!list_empty(list)) {
> -		page = lru_to_page(list);
> +		int nr_pages;
> +		struct folio *folio = lru_to_folio(list);
> +		struct page *page = &folio->page;
> +
> +		lruvec = folio_lruvec_relock_irq(folio, lruvec);
>  		VM_BUG_ON_PAGE(PageLRU(page), page);
>  		list_del(&page->lru);
>  		if (unlikely(!page_evictable(page))) {
> -			spin_unlock_irq(&lruvec->lru_lock);
> +			unlock_page_lruvec_irq(lruvec);

Better to stick with the opencoded unlock. It matches a bit better
with the locking function, compared to locking folio and unlocking
page...

Aside from that, this looks good:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
