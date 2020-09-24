From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v19 06/20] mm/thp: narrow lru locking
Date: Thu, 24 Sep 2020 11:28:21 +0800
Message-ID: <1600918115-22007-7-git-send-email-alex.shi@linux.alibaba.com>
References: <1600918115-22007-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1600918115-22007-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aaron.lwe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

lru_lock and page cache xa_lock have no obvious reason to be taken
one way round or the other: until now, lru_lock has been taken before
page cache xa_lock, when splitting a THP; but nothing else takes them
together.  Reverse that ordering: let's narrow the lru locking - but
leave local_irq_disable to block interrupts throughout, like before.

Hugh Dickins point: split_huge_page_to_list() was already silly, to be
using the _irqsave variant: it's just been taking sleeping locks, so
would already be broken if entered with interrupts enabled.  So we
can save passing flags argument down to __split_huge_page().

Why change the lock ordering here? That was hard to decide. One reason:
when this series reaches per-memcg lru locking, it relies on the THP's
memcg to be stable when taking the lru_lock: that is now done after the
THP's refcount has been frozen, which ensures page memcg cannot change.

Another reason: previously, lock_page_memcg()'s move_lock was presumed
to nest inside lru_lock; but now lru_lock must nest inside (page cache
lock inside) move_lock, so it becomes possible to use lock_page_memcg()
to stabilize page memcg before taking its lru_lock.  That is not the
mechanism used in this series, but it is an option we want to keep open.

[Hugh Dickins: rewrite commit log]
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/huge_memory.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8b92cd197218..63af7611afaf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2402,7 +2402,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list,
-		pgoff_t end, unsigned long flags)
+		pgoff_t end)
 {
 	struct page *head = compound_head(page);
 	pg_data_t *pgdat = page_pgdat(head);
@@ -2411,8 +2411,6 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	unsigned long offset = 0;
 	int i;
 
-	lruvec = mem_cgroup_page_lruvec(head, pgdat);
-
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
@@ -2424,6 +2422,11 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	/* prevent PageLRU to go away from under us, and freeze lru stats */
+	spin_lock(&pgdat->lru_lock);
+
+	lruvec = mem_cgroup_page_lruvec(head, pgdat);
+
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
@@ -2443,6 +2446,8 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	}
 
 	ClearPageCompound(head);
+	spin_unlock(&pgdat->lru_lock);
+	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, HPAGE_PMD_ORDER);
 
@@ -2460,8 +2465,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 		page_ref_add(head, 2);
 		xa_unlock(&head->mapping->i_pages);
 	}
-
-	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	local_irq_enable();
 
 	remap_page(head);
 
@@ -2600,12 +2604,10 @@ bool can_split_huge_page(struct page *page, int *pextra_pins)
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head = compound_head(page);
-	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
-	unsigned long flags;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2666,9 +2668,8 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	unmap_page(head);
 	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lru_lock, flags);
-
+	/* block interrupt reentry in xa_lock and spinlock */
+	local_irq_disable();
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
@@ -2698,7 +2699,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 				__dec_node_page_state(head, NR_FILE_THPS);
 		}
 
-		__split_huge_page(page, list, end, flags);
+		__split_huge_page(page, list, end);
 		if (PageSwapCache(head)) {
 			swp_entry_t entry = { .val = page_private(head) };
 
@@ -2717,7 +2718,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
+		local_irq_enable();
 		remap_page(head);
 		ret = -EBUSY;
 	}
-- 
1.8.3.1

