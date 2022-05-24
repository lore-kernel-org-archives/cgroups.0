From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 04/11] mm: vmscan: rework move_pages_to_lru()
Date: Tue, 24 May 2022 15:52:22 -0400
Message-ID: <78de6197-7de6-9fe7-9567-1321c06c6e9b@redhat.com>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-5-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653421947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vsoL5BUtwGtn8srjaBAKLRmvlrQ5HvOClw2yb5AYOdQ=;
        b=UBrCsITgFApKa9lSS0hQz0i47swfTVDu5GcxRNYGStigCl6ZTpnmSx1OfqlQFsUD0GDdQi
        Vg1k0jFsrpZBUYRSWE89o55M8lWYacdCnj9cM0IQ8yeZIexOEjsh/CAFwQsYLtUvtTN26n
        9z5WiC38cZ3lPr8v2pjiFzyL6pvyrAE=
Content-Language: en-US
In-Reply-To: <20220524060551.80037-5-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On 5/24/22 02:05, Muchun Song wrote:
> In the later patch, we will reparent the LRU pages. The pages moved to
> appropriate LRU list can be reparented during the process of the
> move_pages_to_lru(). So holding a lruvec lock by the caller is wrong, we
> should use the more general interface of folio_lruvec_relock_irq() to
> acquire the correct lruvec lock.
>
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>   mm/vmscan.c | 49 +++++++++++++++++++++++++------------------------
>   1 file changed, 25 insertions(+), 24 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1678802e03e7..761d5e0dd78d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2230,23 +2230,28 @@ static int too_many_isolated(struct pglist_data *pgdat, int file,
>    * move_pages_to_lru() moves pages from private @list to appropriate LRU list.
>    * On return, @list is reused as a list of pages to be freed by the caller.
>    *
> - * Returns the number of pages moved to the given lruvec.
> + * Returns the number of pages moved to the appropriate LRU list.
> + *
> + * Note: The caller must not hold any lruvec lock.
>    */
> -static unsigned int move_pages_to_lru(struct lruvec *lruvec,
> -				      struct list_head *list)
> +static unsigned int move_pages_to_lru(struct list_head *list)
>   {
> -	int nr_pages, nr_moved = 0;
> +	int nr_moved = 0;
> +	struct lruvec *lruvec = NULL;
>   	LIST_HEAD(pages_to_free);
> -	struct page *page;
>   
>   	while (!list_empty(list)) {
> -		page = lru_to_page(list);
> +		int nr_pages;
> +		struct folio *folio = lru_to_folio(list);
> +		struct page *page = &folio->page;
> +
> +		lruvec = folio_lruvec_relock_irq(folio, lruvec);
>   		VM_BUG_ON_PAGE(PageLRU(page), page);
>   		list_del(&page->lru);
>   		if (unlikely(!page_evictable(page))) {
> -			spin_unlock_irq(&lruvec->lru_lock);
> +			unlock_page_lruvec_irq(lruvec);
>   			putback_lru_page(page);
> -			spin_lock_irq(&lruvec->lru_lock);
> +			lruvec = NULL;
>   			continue;
>   		}
>   
> @@ -2267,20 +2272,16 @@ static unsigned int move_pages_to_lru(struct lruvec *lruvec,
>   			__clear_page_lru_flags(page);
>   
>   			if (unlikely(PageCompound(page))) {
> -				spin_unlock_irq(&lruvec->lru_lock);
> +				unlock_page_lruvec_irq(lruvec);
>   				destroy_compound_page(page);
> -				spin_lock_irq(&lruvec->lru_lock);
> +				lruvec = NULL;
>   			} else
>   				list_add(&page->lru, &pages_to_free);
>   
>   			continue;
>   		}
>   
> -		/*
> -		 * All pages were isolated from the same lruvec (and isolation
> -		 * inhibits memcg migration).
> -		 */
> -		VM_BUG_ON_PAGE(!folio_matches_lruvec(page_folio(page), lruvec), page);
> +		VM_BUG_ON_PAGE(!folio_matches_lruvec(folio, lruvec), page);
>   		add_page_to_lru_list(page, lruvec);
>   		nr_pages = thp_nr_pages(page);
>   		nr_moved += nr_pages;
> @@ -2288,6 +2289,8 @@ static unsigned int move_pages_to_lru(struct lruvec *lruvec,
>   			workingset_age_nonresident(lruvec, nr_pages);
>   	}
>   
> +	if (lruvec)
> +		unlock_page_lruvec_irq(lruvec);
>   	/*
>   	 * To save our caller's stack, now use input list for pages to free.
>   	 */
> @@ -2359,16 +2362,16 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
>   
>   	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, &stat, false);
>   
> -	spin_lock_irq(&lruvec->lru_lock);
> -	move_pages_to_lru(lruvec, &page_list);
> +	move_pages_to_lru(&page_list);
>   
> +	local_irq_disable();
>   	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>   	item = current_is_kswapd() ? PGSTEAL_KSWAPD : PGSTEAL_DIRECT;
>   	if (!cgroup_reclaim(sc))
>   		__count_vm_events(item, nr_reclaimed);
>   	__count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
>   	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
> -	spin_unlock_irq(&lruvec->lru_lock);
> +	local_irq_enable();
>   
>   	lru_note_cost(lruvec, file, stat.nr_pageout);
>   	mem_cgroup_uncharge_list(&page_list);
> @@ -2498,18 +2501,16 @@ static void shrink_active_list(unsigned long nr_to_scan,
>   	/*
>   	 * Move pages back to the lru list.
>   	 */
> -	spin_lock_irq(&lruvec->lru_lock);
> -
> -	nr_activate = move_pages_to_lru(lruvec, &l_active);
> -	nr_deactivate = move_pages_to_lru(lruvec, &l_inactive);
> +	nr_activate = move_pages_to_lru(&l_active);
> +	nr_deactivate = move_pages_to_lru(&l_inactive);
>   	/* Keep all free pages in l_active list */
>   	list_splice(&l_inactive, &l_active);
>   
> +	local_irq_disable();
>   	__count_vm_events(PGDEACTIVATE, nr_deactivate);
>   	__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
> -
>   	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
> -	spin_unlock_irq(&lruvec->lru_lock);
> +	local_irq_enable();
>   
>   	mem_cgroup_uncharge_list(&l_active);
>   	free_unref_page_list(&l_active);

Note that the RT engineers will likely change the 
local_irq_disable()/local_irq_enable() to 
local_lock_irq()/local_unlock_irq().

Cheers,
Longman

