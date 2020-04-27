From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v10 04/15] mm/thp: move lru_add_page_tail func to huge_memory.c
Date: Mon, 27 Apr 2020 15:02:53 +0800
Message-ID: <1587970985-21629-5-git-send-email-alex.shi@linux.alibaba.com>
References: <1587970985-21629-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1587970985-21629-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

The func is only used in huge_memory.c, defining it in other file with a
CONFIG_TRANSPARENT_HUGEPAGE macro restrict just looks weird.

Let's move it close user.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 include/linux/swap.h |  4 ++--
 mm/huge_memory.c     | 35 +++++++++++++++++++++++++++++++++++
 mm/swap.c            | 41 +----------------------------------------
 3 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6ca3adf62fe0..4e13d0bb8e82 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -328,11 +328,11 @@ struct vma_swap_readahead {
 
 
 /* linux/mm/swap.c */
+extern void update_page_reclaim_stat(struct lruvec *lruvec,
+						int file, int rotated);
 extern void lru_cache_add(struct page *);
 extern void lru_cache_add_anon(struct page *page);
 extern void lru_cache_add_file(struct page *page);
-extern void lru_add_page_tail(struct page *page, struct page *page_tail,
-			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
 extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 35a716720e26..ea60340a14c8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2501,6 +2501,41 @@ static void remap_page(struct page *page)
 	}
 }
 
+void lru_add_page_tail(struct page *page, struct page *page_tail,
+		       struct lruvec *lruvec, struct list_head *list)
+{
+	const int file = 0;
+
+	VM_BUG_ON_PAGE(!PageHead(page), page);
+	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
+	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
+	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
+
+	if (!list)
+		SetPageLRU(page_tail);
+
+	if (likely(PageLRU(page)))
+		list_add_tail(&page_tail->lru, &page->lru);
+	else if (list) {
+		/* page reclaim is reclaiming a huge page */
+		get_page(page_tail);
+		list_add_tail(&page_tail->lru, list);
+	} else {
+		/*
+		 * Head page has not yet been counted, as an hpage,
+		 * so we must account for each subpage individually.
+		 *
+		 * Put page_tail on the list at the correct position
+		 * so they all end up in order.
+		 */
+		add_page_to_lru_list_tail(page_tail, lruvec,
+					  page_lru(page_tail));
+	}
+
+	if (!PageUnevictable(page))
+		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
+}
+
 static void __split_huge_page_tail(struct page *head, int tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
diff --git a/mm/swap.c b/mm/swap.c
index bf9a79fed62d..6203e35652f4 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -262,8 +262,7 @@ void rotate_reclaimable_page(struct page *page)
 	}
 }
 
-static void update_page_reclaim_stat(struct lruvec *lruvec,
-				     int file, int rotated)
+void update_page_reclaim_stat(struct lruvec *lruvec, int file, int rotated)
 {
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
@@ -885,44 +884,6 @@ void __pagevec_release(struct pagevec *pvec)
 }
 EXPORT_SYMBOL(__pagevec_release);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-/* used by __split_huge_page_refcount() */
-void lru_add_page_tail(struct page *page, struct page *page_tail,
-		       struct lruvec *lruvec, struct list_head *list)
-{
-	const int file = 0;
-
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
-	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
-	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
-
-	if (!list)
-		SetPageLRU(page_tail);
-
-	if (likely(PageLRU(page)))
-		list_add_tail(&page_tail->lru, &page->lru);
-	else if (list) {
-		/* page reclaim is reclaiming a huge page */
-		get_page(page_tail);
-		list_add_tail(&page_tail->lru, list);
-	} else {
-		/*
-		 * Head page has not yet been counted, as an hpage,
-		 * so we must account for each subpage individually.
-		 *
-		 * Put page_tail on the list at the correct position
-		 * so they all end up in order.
-		 */
-		add_page_to_lru_list_tail(page_tail, lruvec,
-					  page_lru(page_tail));
-	}
-
-	if (!PageUnevictable(page))
-		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 				 void *arg)
 {
-- 
1.8.3.1

