From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v17 00/21] per memcg lru lock
Date: Tue, 4 Aug 2020 16:37:14 +0800
Message-ID: <6f2cfd19-57eb-f3f8-f78f-b2fd98587b98@linux.alibaba.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1595681998-19193-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

From 0696a2a4a8ca5e9bf62f208126ea4af7727d2edc Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Date: Sat, 25 Jul 2020 22:31:03 +0800
Subject: [PATCH 1/3] mm/mlock: remove lru_lock on TestClearPageMlocked in
 munlock_vma_page

In the func munlock_vma_page, the page must be PageLocked as well as
pages in split_huge_page series funcs. Thus the PageLocked is enough
to serialize both funcs.

So we could relief the TestClearPageMlocked/hpage_nr_pages which are not
necessary under lru lock.

As to another munlock func __munlock_pagevec, which no PageLocked
protection and should remain lru protecting.

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/mlock.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 0448409184e3..46a05e6ec5ba 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -69,9 +69,9 @@ void clear_page_mlock(struct page *page)
 	 *
 	 * See __pagevec_lru_add_fn for more explanation.
 	 */
-	if (!isolate_lru_page(page)) {
+	if (!isolate_lru_page(page))
 		putback_lru_page(page);
-	} else {
+	else {
 		/*
 		 * We lost the race. the page already moved to evictable list.
 		 */
@@ -178,7 +178,6 @@ static void __munlock_isolation_failed(struct page *page)
 unsigned int munlock_vma_page(struct page *page)
 {
 	int nr_pages;
-	struct lruvec *lruvec;
 
 	/* For try_to_munlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
@@ -186,37 +185,22 @@ unsigned int munlock_vma_page(struct page *page)
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	/*
-	 * Serialize split tail pages in __split_huge_page_tail() which
-	 * might otherwise copy PageMlocked to part of the tail pages before
-	 * we clear it in the head page. It also stabilizes thp_nr_pages().
-	 * TestClearPageLRU can't be used here to block page isolation, since
-	 * out of lock clear_page_mlock may interfer PageLRU/PageMlocked
-	 * sequence, same as __pagevec_lru_add_fn, and lead the page place to
-	 * wrong lru list here. So relay on PageLocked to stop lruvec change
-	 * in mem_cgroup_move_account().
+	 * Serialize split tail pages in __split_huge_page_tail() by
+	 * lock_page(); Do TestClearPageMlocked/PageLRU sequence like
+	 * clear_page_mlock().
 	 */
-	lruvec = lock_page_lruvec_irq(page);
-
-	if (!TestClearPageMlocked(page)) {
+	if (!TestClearPageMlocked(page))
 		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
-		nr_pages = 1;
-		goto unlock_out;
-	}
+		return 0;
 
 	nr_pages = thp_nr_pages(page);
 	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 
-	if (__munlock_isolate_lru_page(page, lruvec, true)) {
-		unlock_page_lruvec_irq(lruvec);
+	if (!isolate_lru_page(page))
 		__munlock_isolated_page(page);
-		goto out;
-	}
-	__munlock_isolation_failed(page);
-
-unlock_out:
-	unlock_page_lruvec_irq(lruvec);
+	else
+		__munlock_isolation_failed(page);
 
-out:
 	return nr_pages - 1;
 }
 
@@ -305,6 +289,11 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 
 		/* block memcg change in mem_cgroup_move_account */
 		lock_page_memcg(page);
+		/*
+		 * Serialize split tail pages in __split_huge_page_tail() which
+		 * might otherwise copy PageMlocked to part of the tail pages
+		 * before we clear it in the head page.
+		 */
 		lruvec = relock_page_lruvec_irq(page, lruvec);
 		if (TestClearPageMlocked(page)) {
 			/*
-- 
1.8.3.1


