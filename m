From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v14 07/20] mm/thp: narrow lru locking
Date: Mon, 6 Jul 2020 12:35:13 +0100
Message-ID: <20200706113513.GY25523@casper.infradead.org>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-8-git-send-email-alex.shi@linux.alibaba.com>
 <124eeef1-ff2b-609e-3bf6-a118100c3f2a@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=OEy4U14lLKI068FHS0JNccIDytAin8DP0F/8fksYMHM=; b=KYXVtEnDEU3QfsHNKDl8JD6cEA
        IdtyW0WG0Z/5mgR9zDgpmcd2IGC5N6d50cIM/Q3NuAxlEzPib6+8TwZ8YuBaOn/pi2sEhzNmR5hkh
        k5U2rRABYmgA/UOuXfSnde6iXrCiOgypj593SKiGNG1o73ZDYlrCYEDhvQL4K+FN08k+QOz9LIKEx
        +CHnrREONgkl9Ff10suBnwJn49Kb+Bp87ssbB+0smB+PwOaVVWwzHql4tVCNYUV7pG7Ha4pBv0xKN
        QslQOwWxYu8tcBZ+GfPPW/YqSwHaROA7+J57WrQ9xQR1mOtL8v1hBZlx+MKCGOrHOQ55gBh4dwUyZ
        4/1VaErA==;
Content-Disposition: inline
In-Reply-To: <124eeef1-ff2b-609e-3bf6-a118100c3f2a-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Jul 06, 2020 at 05:15:09PM +0800, Alex Shi wrote:
> Hi Kirill & Johannes & Matthew,
> 
> Would you like to give some comments or share your concern of this patchset,
> specialy for THP part? 

I don't have the brain space to understand this patch set fully at
the moment.  I'll note that the realtime folks are doing their best to
stamp out users of local_irq_disable(), so they won't be pleased to see
you adding a new one.  Also, you removed the comment explaining why the
lock needed to be taken.

> Many Thanks
> Alex
> 
> 在 2020/7/3 下午1:07, Alex Shi 写道:
> > lru_lock and page cache xa_lock have no reason with current sequence,
> > put them together isn't necessary. let's narrow the lru locking, but
> > left the local_irq_disable to block interrupt re-entry and statistic update.
> > 
> > Hugh Dickins point: split_huge_page_to_list() was already silly,to be
> > using the _irqsave variant: it's just been taking sleeping locks, so
> > would already be broken if entered with interrupts enabled.
> > so we can save passing flags argument down to __split_huge_page().
> > 
> > Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> > Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > ---
> >  mm/huge_memory.c | 24 ++++++++++++------------
> >  1 file changed, 12 insertions(+), 12 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index b18f21da4dac..607869330329 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2433,7 +2433,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
> >  }
> >  
> >  static void __split_huge_page(struct page *page, struct list_head *list,
> > -		pgoff_t end, unsigned long flags)
> > +			      pgoff_t end)
> >  {
> >  	struct page *head = compound_head(page);
> >  	pg_data_t *pgdat = page_pgdat(head);
> > @@ -2442,8 +2442,6 @@ static void __split_huge_page(struct page *page, struct list_head *list,
> >  	unsigned long offset = 0;
> >  	int i;
> >  
> > -	lruvec = mem_cgroup_page_lruvec(head, pgdat);
> > -
> >  	/* complete memcg works before add pages to LRU */
> >  	mem_cgroup_split_huge_fixup(head);
> >  
> > @@ -2455,6 +2453,11 @@ static void __split_huge_page(struct page *page, struct list_head *list,
> >  		xa_lock(&swap_cache->i_pages);
> >  	}
> >  
> > +	/* lock lru list/PageCompound, ref freezed by page_ref_freeze */
> > +	spin_lock(&pgdat->lru_lock);
> > +
> > +	lruvec = mem_cgroup_page_lruvec(head, pgdat);
> > +
> >  	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
> >  		__split_huge_page_tail(head, i, lruvec, list);
> >  		/* Some pages can be beyond i_size: drop them from page cache */
> > @@ -2474,6 +2477,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
> >  	}
> >  
> >  	ClearPageCompound(head);
> > +	spin_unlock(&pgdat->lru_lock);
> > +	/* Caller disabled irqs, so they are still disabled here */
> >  
> >  	split_page_owner(head, HPAGE_PMD_ORDER);
> >  
> > @@ -2491,8 +2496,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
> >  		page_ref_add(head, 2);
> >  		xa_unlock(&head->mapping->i_pages);
> >  	}
> > -
> > -	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
> > +	local_irq_enable();
> >  
> >  	remap_page(head);
> >  
> > @@ -2631,12 +2635,10 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
> >  int split_huge_page_to_list(struct page *page, struct list_head *list)
> >  {
> >  	struct page *head = compound_head(page);
> > -	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
> >  	struct deferred_split *ds_queue = get_deferred_split_queue(head);
> >  	struct anon_vma *anon_vma = NULL;
> >  	struct address_space *mapping = NULL;
> >  	int count, mapcount, extra_pins, ret;
> > -	unsigned long flags;
> >  	pgoff_t end;
> >  
> >  	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
> > @@ -2697,9 +2699,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
> >  	unmap_page(head);
> >  	VM_BUG_ON_PAGE(compound_mapcount(head), head);
> >  
> > -	/* prevent PageLRU to go away from under us, and freeze lru stats */
> > -	spin_lock_irqsave(&pgdata->lru_lock, flags);
> > -
> > +	local_irq_disable();
> >  	if (mapping) {
> >  		XA_STATE(xas, &mapping->i_pages, page_index(head));
> >  
> > @@ -2729,7 +2729,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
> >  				__dec_node_page_state(head, NR_FILE_THPS);
> >  		}
> >  
> > -		__split_huge_page(page, list, end, flags);
> > +		__split_huge_page(page, list, end);
> >  		if (PageSwapCache(head)) {
> >  			swp_entry_t entry = { .val = page_private(head) };
> >  
> > @@ -2748,7 +2748,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
> >  		spin_unlock(&ds_queue->split_queue_lock);
> >  fail:		if (mapping)
> >  			xa_unlock(&mapping->i_pages);
> > -		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
> > +		local_irq_enable();
> >  		remap_page(head);
> >  		ret = -EBUSY;
> >  	}
> > 
