From: Alexander Duyck <alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH v2 5/5] mm: Split move_pages_to_lru into 3 separate
 passes
Date: Tue, 18 Aug 2020 21:27:38 -0700
Message-ID: <20200819042738.23414.60815.stgit@localhost.localdomain>
References: <20200819041852.23414.95939.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=taoylAfZ50RvbeR+qDxRIBM5RKgvtzNS5VKzJspUyB8=;
        b=Z+DDR3MmkmAOpsWWDpyXeYNgIGzTgK9Ddb7UhBT/vJrDAZuGC7IlYskyQk03tzEygi
         hg0yvwJORukjN33wkxhvlIHH+zvaP6U6lypz2wcfStTBHY8CmTz2F7TgzrpOR/fJm1M7
         EFODaa5/wquuu3op5FFYJRBLf5S9RBmRBvBOB54DJqk3ofigrbivIJ1NXhgI5tnxk9EX
         VX77DTOK8ANaygFl9DWT0sOHN+dtc1RaB7H+Xn9h5/7jP/Epn+84BTlG6LRCCUFBnKKo
         Ikfqq6/wFEvz43BPxSR6OKSjvmmyvtPFx/O6FVNMW3b4ApIC1B4o5rqHt+Vy/0CELP6F
         R4ug==
In-Reply-To: <20200819041852.23414.95939.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

The current code for move_pages_to_lru is meant to release the LRU lock
every time it encounters an unevictable page or a compound page that must
be freed. This results in a fair amount of code bulk because the lruvec has
to be reacquired every time the lock is released and reacquired.

Instead of doing this I believe we can break the code up into 3 passes. The
first pass will identify the pages we can move to LRU and move those. In
addition it will sort the list out leaving the unevictable pages in the
list and moving those pages that have dropped to a reference count of 0 to
pages_to_free. The second pass will return the unevictable pages to the
LRU. The final pass will free any compound pages we have in the
pages_to_free list before we merge it back with the original list and
return from the function.

The advantage of doing it this way is that we only have to release the lock
between pass 1 and 2, and then we reacquire the lock after pass 3 after we
merge the pages_to_free back into the original list. As such we only have
to release the lock at most once in an entire call instead of having to
test to see if we need to relock with each page.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 mm/vmscan.c |   68 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3ebe3f9b653b..6a2bdbc1a9eb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1850,22 +1850,21 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 {
 	int nr_pages, nr_moved = 0;
 	LIST_HEAD(pages_to_free);
-	struct page *page;
-	struct lruvec *orig_lruvec = lruvec;
+	struct page *page, *next;
 	enum lru_list lru;
 
-	while (!list_empty(list)) {
-		page = lru_to_page(list);
+	list_for_each_entry_safe(page, next, list, lru) {
 		VM_BUG_ON_PAGE(PageLRU(page), page);
-		list_del(&page->lru);
-		if (unlikely(!page_evictable(page))) {
-			if (lruvec) {
-				spin_unlock_irq(&lruvec->lru_lock);
-				lruvec = NULL;
-			}
-			putback_lru_page(page);
+
+		/*
+		 * if page is unevictable leave it on the list to be returned
+		 * to the LRU after we have finished processing the other
+		 * entries in the list.
+		 */
+		if (unlikely(!page_evictable(page)))
 			continue;
-		}
+
+		list_del(&page->lru);
 
 		/*
 		 * The SetPageLRU needs to be kept here for list intergrity.
@@ -1878,20 +1877,14 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 		 *     list_add(&page->lru,)
 		 *                                        list_add(&page->lru,)
 		 */
-		lruvec = relock_page_lruvec_irq(page, lruvec);
 		SetPageLRU(page);
 
 		if (unlikely(put_page_testzero(page))) {
 			__ClearPageLRU(page);
 			__ClearPageActive(page);
 
-			if (unlikely(PageCompound(page))) {
-				spin_unlock_irq(&lruvec->lru_lock);
-				lruvec = NULL;
-				destroy_compound_page(page);
-			} else
-				list_add(&page->lru, &pages_to_free);
-
+			/* defer freeing until we can release lru_lock */
+			list_add(&page->lru, &pages_to_free);
 			continue;
 		}
 
@@ -1904,16 +1897,33 @@ static unsigned noinline_for_stack move_pages_to_lru(struct lruvec *lruvec,
 		if (PageActive(page))
 			workingset_age_nonresident(lruvec, nr_pages);
 	}
-	if (orig_lruvec != lruvec) {
-		if (lruvec)
-			spin_unlock_irq(&lruvec->lru_lock);
-		spin_lock_irq(&orig_lruvec->lru_lock);
-	}
 
-	/*
-	 * To save our caller's stack, now use input list for pages to free.
-	 */
-	list_splice(&pages_to_free, list);
+	if (unlikely(!list_empty(list) || !list_empty(&pages_to_free))) {
+		spin_unlock_irq(&lruvec->lru_lock);
+
+		/* return any unevictable pages to the LRU list */
+		while (!list_empty(list)) {
+			page = lru_to_page(list);
+			list_del(&page->lru);
+			putback_lru_page(page);
+		}
+
+		/*
+		 * To save our caller's stack use input
+		 * list for pages to free.
+		 */
+		list_splice(&pages_to_free, list);
+
+		/* free any compound pages we have in the list */
+		list_for_each_entry_safe(page, next, list, lru) {
+			if (likely(!PageCompound(page)))
+				continue;
+			list_del(&page->lru);
+			destroy_compound_page(page);
+		}
+
+		spin_lock_irq(&lruvec->lru_lock);
+	}
 
 	return nr_moved;
 }

