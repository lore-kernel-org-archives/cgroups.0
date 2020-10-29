From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v20 16/20] mm/compaction: do page isolation first in compaction
Date: Thu, 29 Oct 2020 18:45:01 +0800
Message-ID: <1603968305-8026-17-git-send-email-alex.shi@linux.alibaba.com>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1603968305-8026-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Currently, compaction would get the lru_lock and then do page isolation
which works fine with pgdat->lru_lock, since any page isoltion would
compete for the lru_lock. If we want to change to memcg lru_lock, we
have to isolate the page before getting lru_lock, thus isoltion would
block page's memcg change which relay on page isoltion too. Then we
could safely use per memcg lru_lock later.

The new page isolation use previous introduced TestClearPageLRU() +
pgdat lru locking which will be changed to memcg lru lock later.

Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> fixed following bugs in this patch's
early version:

Fix lots of crashes under compaction load: isolate_migratepages_block()
must clean up appropriately when rejecting a page, setting PageLRU again
if it had been cleared; and a put_page() after get_page_unless_zero()
cannot safely be done while holding locked_lruvec - it may turn out to
be the final put_page(), which will take an lruvec lock when PageLRU.
And move __isolate_lru_page_prepare back after get_page_unless_zero to
make trylock_page() safe:
trylock_page() is not safe to use at this time: its setting PG_locked
can race with the page being freed or allocated ("Bad page"), and can
also erase flags being set by one of those "sole owners" of a freshly
allocated page who use non-atomic __SetPageFlag().

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 include/linux/swap.h |  2 +-
 mm/compaction.c      | 42 +++++++++++++++++++++++++++++++++---------
 mm/vmscan.c          | 43 ++++++++++++++++++++++---------------------
 3 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5e1e967c225f..596bc2f4d9b0 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -356,7 +356,7 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
+extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
diff --git a/mm/compaction.c b/mm/compaction.c
index 6e0ee5641788..75f7973605f4 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -886,6 +886,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
 			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
 				low_pfn = end_pfn;
+				page = NULL;
 				goto isolate_abort;
 			}
 			valid_page = page;
@@ -967,6 +968,21 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
 			goto isolate_fail;
 
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
+		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
+			goto isolate_fail_put;
+
+		/* Try isolate the page */
+		if (!TestClearPageLRU(page))
+			goto isolate_fail_put;
+
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!locked) {
 			locked = compact_lock_irqsave(&pgdat->lru_lock,
@@ -979,10 +995,6 @@ static bool too_many_isolated(pg_data_t *pgdat)
 					goto isolate_abort;
 			}
 
-			/* Recheck PageLRU and PageCompound under lock */
-			if (!PageLRU(page))
-				goto isolate_fail;
-
 			/*
 			 * Page become compound since the non-locked check,
 			 * and it's on LRU. It can only be a THP so the order
@@ -990,16 +1002,13 @@ static bool too_many_isolated(pg_data_t *pgdat)
 			 */
 			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn += compound_nr(page) - 1;
-				goto isolate_fail;
+				SetPageLRU(page);
+				goto isolate_fail_put;
 			}
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-		/* Try isolate the page */
-		if (__isolate_lru_page(page, isolate_mode) != 0)
-			goto isolate_fail;
-
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
 			low_pfn += compound_nr(page) - 1;
@@ -1028,6 +1037,15 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		}
 
 		continue;
+
+isolate_fail_put:
+		/* Avoid potential deadlock in freeing page under lru_lock */
+		if (locked) {
+			spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+			locked = false;
+		}
+		put_page(page);
+
 isolate_fail:
 		if (!skip_on_failure)
 			continue;
@@ -1064,9 +1082,15 @@ static bool too_many_isolated(pg_data_t *pgdat)
 	if (unlikely(low_pfn > end_pfn))
 		low_pfn = end_pfn;
 
+	page = NULL;
+
 isolate_abort:
 	if (locked)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (page) {
+		SetPageLRU(page);
+		put_page(page);
+	}
 
 	/*
 	 * Updated the cached scanner pfn once the pageblock has been scanned
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ce4ab932805c..e28df9cb5be3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1540,7 +1540,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
  *
  * returns 0 on success, -ve errno on failure.
  */
-int __isolate_lru_page(struct page *page, isolate_mode_t mode)
+int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 {
 	int ret = -EBUSY;
 
@@ -1592,22 +1592,9 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
 		return ret;
 
-	if (likely(get_page_unless_zero(page))) {
-		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
-		 */
-		if (TestClearPageLRU(page))
-			ret = 0;
-		else
-			put_page(page);
-	}
-
-	return ret;
+	return 0;
 }
 
-
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
  * be complete before mem_cgroup_update_lru_size due to a sanity check.
@@ -1687,20 +1674,34 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		 * only when the page is being freed somewhere else.
 		 */
 		scan += nr_pages;
-		switch (__isolate_lru_page(page, mode)) {
+		switch (__isolate_lru_page_prepare(page, mode)) {
 		case 0:
+			/*
+			 * Be careful not to clear PageLRU until after we're
+			 * sure the page is not being freed elsewhere -- the
+			 * page release code relies on it.
+			 */
+			if (unlikely(!get_page_unless_zero(page)))
+				goto busy;
+
+			if (!TestClearPageLRU(page)) {
+				/*
+				 * This page may in other isolation path,
+				 * but we still hold lru_lock.
+				 */
+				put_page(page);
+				goto busy;
+			}
+
 			nr_taken += nr_pages;
 			nr_zone_taken[page_zonenum(page)] += nr_pages;
 			list_move(&page->lru, dst);
 			break;
 
-		case -EBUSY:
+		default:
+busy:
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
-			continue;
-
-		default:
-			BUG();
 		}
 	}
 
-- 
1.8.3.1

