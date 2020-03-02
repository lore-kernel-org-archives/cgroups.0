From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v9 09/20] mm/mlock: ClearPageLRU before get lru lock in munlock page isolation
Date: Mon,  2 Mar 2020 19:00:19 +0800
Message-ID: <1583146830-169516-10-git-send-email-alex.shi@linux.alibaba.com>
References: <1583146830-169516-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1583146830-169516-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is one of effort to split the PageLRU clear from old page
isolation.

This patch move the lru_lock after TestClearPageLRU, which takes holding
PageLRU as precondition for page isolation, as a preparation for later
lru_lock replacment. So we have to unfold __munlock_isolate_lru_page.

__split_huge_page_refcount doesn't exist, but we still have to guard
PageMlocked in __split_huge_page_tail. That make code ugly.
Anyway we still remove 2 gotos.

[lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org: found a sleeping function bug ... at mm/rmap.c:1861]
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/mlock.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 03b3a5d99ad7..7ddc52ca14b1 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -181,6 +181,7 @@ static void __munlock_isolation_failed(struct page *page)
 unsigned int munlock_vma_page(struct page *page)
 {
 	int nr_pages;
+	bool clearlru = false;
 	pg_data_t *pgdat = page_pgdat(page);
 
 	/* For try_to_munlock() and to serialize with page migration */
@@ -189,32 +190,42 @@ unsigned int munlock_vma_page(struct page *page)
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	/*
-	 * Serialize with any parallel __split_huge_page_refcount() which
+	 * Serialize with any parallel __split_huge_page_tail() which
 	 * might otherwise copy PageMlocked to part of the tail pages before
 	 * we clear it in the head page. It also stabilizes hpage_nr_pages().
 	 */
+	get_page(page);
+	clearlru = TestClearPageLRU(page);
 	spin_lock_irq(&pgdat->lru_lock);
 
 	if (!TestClearPageMlocked(page)) {
-		/* Potentially, PTE-mapped THP: do not skip the rest PTEs */
-		nr_pages = 1;
-		goto unlock_out;
+		if (clearlru)
+			SetPageLRU(page);
+		/*
+		 * Potentially, PTE-mapped THP: do not skip the rest PTEs
+		 * Reuse lock as memory barrier for release_pages racing.
+		 */
+		spin_unlock_irq(&pgdat->lru_lock);
+		put_page(page);
+		return 0;
 	}
 
 	nr_pages = hpage_nr_pages(page);
 	__mod_zone_page_state(page_zone(page), NR_MLOCK, -nr_pages);
 
-	if (__munlock_isolate_lru_page(page, true)) {
+	if (clearlru) {
+		struct lruvec *lruvec;
+
+		lruvec = mem_cgroup_page_lruvec(page, page_pgdat(page));
+		del_page_from_lru_list(page, lruvec, page_lru(page));
 		spin_unlock_irq(&pgdat->lru_lock);
 		__munlock_isolated_page(page);
-		goto out;
+	} else {
+		spin_unlock_irq(&pgdat->lru_lock);
+		put_page(page);
+		__munlock_isolation_failed(page);
 	}
-	__munlock_isolation_failed(page);
-
-unlock_out:
-	spin_unlock_irq(&pgdat->lru_lock);
 
-out:
 	return nr_pages - 1;
 }
 
@@ -323,8 +334,8 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 		pagevec_add(&pvec_putback, pvec->pages[i]);
 		pvec->pages[i] = NULL;
 	}
-	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 	spin_unlock_irq(&zone->zone_pgdat->lru_lock);
+	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
 
 	/* Now we can release pins of pages that we are not munlocking */
 	pagevec_release(&pvec_putback);
-- 
1.8.3.1

