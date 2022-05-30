From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v5 02/11] mm: rename unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}
Date: Mon, 30 May 2022 15:49:10 +0800
Message-ID: <20220530074919.46352-3-songmuchun@bytedance.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qP3NYqmy/kFDq8fy7T/74NXJ0W9tdNYCsTtwUre3MFo=;
        b=2lWVMQ4OH/ac/xcyLrM2cbUXGSinjLfD4xqq9FUvko6fE3Ndz9Fwe10KdO/ZMwW3Gk
         7MlSYaSGBpbCqkL3KEJHSM1sVt4SWyXoo1O0/amdBG/7ZL3O0i3K1sD6L68KMKfFRLMA
         uXHJHC++Pv7FxsKTjboIcMFe5xETp4/Q26H3bQXUA9t9IzX1KeMFpjUDU/XeAyN6ZDsa
         iYr3PRXd+4StN2hEjFWb/eb+zQqvkhzzFZvg9sTQ/ttztnFqkbH/QGoL2nBQaBzi42cF
         hjMZvtcQadKm1UJTOGWbrWWCd8VwkzaH+Ghc+AqlzZxgGn/9JcFERz9GP4VCwzwjAXSh
         S5aQ==
In-Reply-To: <20220530074919.46352-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

It is weird to use folio_lruvec_lock() variants and unlock_page_lruvec() variants
together, e.g. locking folio and unlocking page.  So rename
unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/memcontrol.h | 10 +++++-----
 mm/compaction.c            | 12 ++++++------
 mm/huge_memory.c           |  2 +-
 mm/mlock.c                 |  2 +-
 mm/swap.c                  | 16 ++++++++--------
 mm/vmscan.c                |  4 ++--
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0833be256134..6d7f97cc3fd4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1538,17 +1538,17 @@ static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 	return mem_cgroup_lruvec(memcg, lruvec_pgdat(lruvec));
 }
 
-static inline void unlock_page_lruvec(struct lruvec *lruvec)
+static inline void lruvec_unlock(struct lruvec *lruvec)
 {
 	spin_unlock(&lruvec->lru_lock);
 }
 
-static inline void unlock_page_lruvec_irq(struct lruvec *lruvec)
+static inline void lruvec_unlock_irq(struct lruvec *lruvec)
 {
 	spin_unlock_irq(&lruvec->lru_lock);
 }
 
-static inline void unlock_page_lruvec_irqrestore(struct lruvec *lruvec,
+static inline void lruvec_unlock_irqrestore(struct lruvec *lruvec,
 		unsigned long flags)
 {
 	spin_unlock_irqrestore(&lruvec->lru_lock, flags);
@@ -1570,7 +1570,7 @@ static inline struct lruvec *folio_lruvec_relock_irq(struct folio *folio,
 		if (folio_matches_lruvec(folio, locked_lruvec))
 			return locked_lruvec;
 
-		unlock_page_lruvec_irq(locked_lruvec);
+		lruvec_unlock_irq(locked_lruvec);
 	}
 
 	return folio_lruvec_lock_irq(folio);
@@ -1584,7 +1584,7 @@ static inline struct lruvec *folio_lruvec_relock_irqsave(struct folio *folio,
 		if (folio_matches_lruvec(folio, locked_lruvec))
 			return locked_lruvec;
 
-		unlock_page_lruvec_irqrestore(locked_lruvec, *flags);
+		lruvec_unlock_irqrestore(locked_lruvec, *flags);
 	}
 
 	return folio_lruvec_lock_irqsave(folio, flags);
diff --git a/mm/compaction.c b/mm/compaction.c
index fe915db6149b..4f155df6b39c 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -874,7 +874,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 */
 		if (!(low_pfn % SWAP_CLUSTER_MAX)) {
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 
@@ -987,7 +987,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
 				if (locked) {
-					unlock_page_lruvec_irqrestore(locked, flags);
+					lruvec_unlock_irqrestore(locked, flags);
 					locked = NULL;
 				}
 
@@ -1070,7 +1070,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
 			if (locked)
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked = lruvec;
@@ -1129,7 +1129,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 isolate_fail_put:
 		/* Avoid potential deadlock in freeing page under lru_lock */
 		if (locked) {
-			unlock_page_lruvec_irqrestore(locked, flags);
+			lruvec_unlock_irqrestore(locked, flags);
 			locked = NULL;
 		}
 		put_page(page);
@@ -1145,7 +1145,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 */
 		if (nr_isolated) {
 			if (locked) {
-				unlock_page_lruvec_irqrestore(locked, flags);
+				lruvec_unlock_irqrestore(locked, flags);
 				locked = NULL;
 			}
 			putback_movable_pages(&cc->migratepages);
@@ -1177,7 +1177,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 isolate_abort:
 	if (locked)
-		unlock_page_lruvec_irqrestore(locked, flags);
+		lruvec_unlock_irqrestore(locked, flags);
 	if (page) {
 		SetPageLRU(page);
 		put_page(page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 910a138e9859..b17b9d25d045 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2404,7 +2404,7 @@ static void __split_huge_page(struct page *page, struct list_head *list,
 	}
 
 	ClearPageCompound(head);
-	unlock_page_lruvec(lruvec);
+	lruvec_unlock(lruvec);
 	/* Caller disabled irqs, so they are still disabled here */
 
 	split_page_owner(head, nr);
diff --git a/mm/mlock.c b/mm/mlock.c
index 716caf851043..6649f3dda56e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -205,7 +205,7 @@ static void mlock_pagevec(struct pagevec *pvec)
 	}
 
 	if (lruvec)
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
diff --git a/mm/swap.c b/mm/swap.c
index 7e320ec08c6a..0a8ee33116c5 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -87,7 +87,7 @@ static void __page_cache_release(struct page *page)
 		lruvec = folio_lruvec_lock_irqsave(folio, &flags);
 		del_page_from_lru_list(page, lruvec);
 		__clear_page_lru_flags(page);
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	}
 	/* See comment on PageMlocked in release_pages() */
 	if (unlikely(PageMlocked(page))) {
@@ -209,7 +209,7 @@ static void pagevec_lru_move_fn(struct pagevec *pvec,
 		SetPageLRU(page);
 	}
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
@@ -369,7 +369,7 @@ static void folio_activate(struct folio *folio)
 	if (folio_test_clear_lru(folio)) {
 		lruvec = folio_lruvec_lock_irq(folio);
 		__folio_activate(folio, lruvec);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		folio_set_lru(folio);
 	}
 }
@@ -915,7 +915,7 @@ void release_pages(struct page **pages, int nr)
 		 * same lruvec. The lock is held only if lruvec != NULL.
 		 */
 		if (lruvec && ++lock_batch == SWAP_CLUSTER_MAX) {
-			unlock_page_lruvec_irqrestore(lruvec, flags);
+			lruvec_unlock_irqrestore(lruvec, flags);
 			lruvec = NULL;
 		}
 
@@ -925,7 +925,7 @@ void release_pages(struct page **pages, int nr)
 
 		if (is_zone_device_page(page)) {
 			if (lruvec) {
-				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
 			if (put_devmap_managed_page(page))
@@ -940,7 +940,7 @@ void release_pages(struct page **pages, int nr)
 
 		if (PageCompound(page)) {
 			if (lruvec) {
-				unlock_page_lruvec_irqrestore(lruvec, flags);
+				lruvec_unlock_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
 			__put_compound_page(page);
@@ -974,7 +974,7 @@ void release_pages(struct page **pages, int nr)
 		list_add(&page->lru, &pages_to_free);
 	}
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_unref_page_list(&pages_to_free);
@@ -1060,7 +1060,7 @@ void __pagevec_lru_add(struct pagevec *pvec)
 		__pagevec_lru_add_fn(folio, lruvec);
 	}
 	if (lruvec)
-		unlock_page_lruvec_irqrestore(lruvec, flags);
+		lruvec_unlock_irqrestore(lruvec, flags);
 	release_pages(pvec->pages, pvec->nr);
 	pagevec_reinit(pvec);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8c6054e06087..a611ccf03c9b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2171,7 +2171,7 @@ int folio_isolate_lru(struct folio *folio)
 		folio_get(folio);
 		lruvec = folio_lruvec_lock_irq(folio);
 		lruvec_del_folio(lruvec, folio);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 		ret = 0;
 	}
 
@@ -4806,7 +4806,7 @@ void check_move_unevictable_pages(struct pagevec *pvec)
 	if (lruvec) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		unlock_page_lruvec_irq(lruvec);
+		lruvec_unlock_irq(lruvec);
 	} else if (pgscanned) {
 		count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
 	}
-- 
2.11.0

