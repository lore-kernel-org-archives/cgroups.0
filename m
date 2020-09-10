From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v18 06/32] mm/thp: narrow lru locking
Date: Thu, 10 Sep 2020 14:49:23 +0100
Message-ID: <20200910134923.GR6583@casper.infradead.org>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
 <1598273705-69124-7-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8HnaJsrywNAsTbyAgR0uDLUkI/076f0nl1xcx0f5Xko=; b=AVDgGo0/6/PB8I5DLtMJL2binO
        pmOQFwK5wVGNZiNAEaWwYcL8vS/eMnTaPIZAY7mbv6nStP3R2yb3GXKw3Qof4jcmSlWeoHU+/82Bd
        0TBjzvJIvJc9SWg49AWb+7o7JjGt5K7abOf0Il9pg05LbGq1YrgXcbg2ZOL7iK1OafUcqQA5Oej0N
        Rzb00lRrkyeX+N9QqRfbzHBkWInN0t2a18twu+JQOaR6naObkQH/wPwnpfeKDHczznhDDNSnbqA1I
        Hp3PxF293vyIQQgKuyBlP0/cCZMpvlMZkU473U0yNovX0yMS07kGlvLPybyBzlNDYEBoRKOPENnzX
        TSCNEaRg==;
Content-Disposition: inline
In-Reply-To: <1598273705-69124-7-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 24, 2020 at 08:54:39PM +0800, Alex Shi wrote:
> lru_lock and page cache xa_lock have no reason with current sequence,
> put them together isn't necessary. let's narrow the lru locking, but
> left the local_irq_disable to block interrupt re-entry and statistic update.

What stats are you talking about here?

> +++ b/mm/huge_memory.c
> @@ -2397,7 +2397,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
>  }
>  
>  static void __split_huge_page(struct page *page, struct list_head *list,
> -		pgoff_t end, unsigned long flags)
> +			      pgoff_t end)

Please don't change this whitespace.  It's really annoying having to
adjust the whitespace when renaming a function.  Just two tabs indentation
to give a clear separation of arguments from code is fine.


How about this patch instead?  It occurred to me we already have
perfectly good infrastructure to track whether or not interrupts are
already disabled, and so we should use that instead of ensuring that
interrupts are disabled, or tracking that ourselves.

But I may have missed something else that's relying on having
interrupts disabled.  Please check carefully.

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2ccff8472cd4..74cae6c032f9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2376,17 +2376,16 @@ static void __split_huge_page_tail(struct page *head, int tail,
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list,
-		pgoff_t end, unsigned long flags)
+		pgoff_t end)
 {
 	struct page *head = compound_head(page);
 	pg_data_t *pgdat = page_pgdat(head);
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
+	unsigned long flags;
 	int i;
 
-	lruvec = mem_cgroup_page_lruvec(head, pgdat);
-
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
@@ -2395,9 +2394,13 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 
 		offset = swp_offset(entry);
 		swap_cache = swap_address_space(entry);
-		xa_lock(&swap_cache->i_pages);
+		xa_lock_irq(&swap_cache->i_pages);
 	}
 
+	/* prevent PageLRU to go away from under us, and freeze lru stats */
+	spin_lock_irqsave(&pgdat->lru_lock, flags);
+	lruvec = mem_cgroup_page_lruvec(head, pgdat);
+
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
@@ -2417,6 +2420,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	}
 
 	ClearPageCompound(head);
+	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 
 	split_page_owner(head, HPAGE_PMD_ORDER);
 
@@ -2425,18 +2429,16 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		/* Additional pin to swap cache */
 		if (PageSwapCache(head)) {
 			page_ref_add(head, 2);
-			xa_unlock(&swap_cache->i_pages);
+			xa_unlock_irq(&swap_cache->i_pages);
 		} else {
 			page_ref_inc(head);
 		}
 	} else {
 		/* Additional pin to page cache */
 		page_ref_add(head, 2);
-		xa_unlock(&head->mapping->i_pages);
+		xa_unlock_irq(&head->mapping->i_pages);
 	}
 
-	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-
 	remap_page(head);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
@@ -2574,7 +2576,6 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head = compound_head(page);
-	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
@@ -2640,9 +2641,6 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lru_lock, flags);
-
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
@@ -2650,13 +2648,13 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		 * Check if the head page is present in page cache.
 		 * We assume all tail are present too, if head is there.
 		 */
-		xa_lock(&mapping->i_pages);
+		xa_lock_irq(&mapping->i_pages);
 		if (xas_load(&xas) != head)
 			goto fail;
 	}
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock(&ds_queue->split_queue_lock);
+	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
 	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
@@ -2664,7 +2662,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 		if (mapping) {
 			if (PageSwapBacked(head))
 				__dec_node_page_state(head, NR_SHMEM_THPS);
@@ -2672,7 +2670,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 				__dec_node_page_state(head, NR_FILE_THPS);
 		}
 
-		__split_huge_page(page, list, end, flags);
+		__split_huge_page(page, list, end);
 		if (PageSwapCache(head)) {
 			swp_entry_t entry = { .val = page_private(head) };
 
@@ -2688,10 +2686,9 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 			dump_page(page, "total_mapcount(head) > 0");
 			BUG();
 		}
-		spin_unlock(&ds_queue->split_queue_lock);
+		spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 fail:		if (mapping)
-			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
+			xa_unlock_irq(&mapping->i_pages);
 		remap_page(head);
 		ret = -EBUSY;
 	}
