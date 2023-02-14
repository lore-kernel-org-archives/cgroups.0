From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 4/4] mm: change to return bool for isolate_movable_page()
Date: Tue, 14 Feb 2023 21:59:32 +0800
Message-ID: <57406039579e764fb6002648699d4896da56ba4a.1676382188.git.baolin.wang@linux.alibaba.com>
References: <cover.1676382188.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1676382188.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Now the isolate_movable_page() can only return 0 or -EBUSY, and no users
will care about the negative return value, thus we can convert the
isolate_movable_page() to return a boolean value to make the code more
clear when checking the movable page isolation state.

No functional changes intended.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 include/linux/migrate.h | 6 +++---
 mm/compaction.c         | 2 +-
 mm/memory-failure.c     | 4 ++--
 mm/memory_hotplug.c     | 4 ++--
 mm/migrate.c            | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index c88b96b48be7..6b252f519c86 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -71,7 +71,7 @@ extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
 		unsigned long private, enum migrate_mode mode, int reason,
 		unsigned int *ret_succeeded);
 extern struct page *alloc_migration_target(struct page *page, unsigned long private);
-extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
+extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
@@ -92,8 +92,8 @@ static inline int migrate_pages(struct list_head *l, new_page_t new,
 static inline struct page *alloc_migration_target(struct page *page,
 		unsigned long private)
 	{ return NULL; }
-static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
-	{ return -EBUSY; }
+static inline bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+	{ return false; }
 
 static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct folio *dst, struct folio *src)
diff --git a/mm/compaction.c b/mm/compaction.c
index d73578af44cc..ad7409f70519 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -976,7 +976,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					locked = NULL;
 				}
 
-				if (!isolate_movable_page(page, mode))
+				if (isolate_movable_page(page, mode))
 					goto isolate_success;
 			}
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 8604753bc644..a1ede7bdce95 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2515,8 +2515,8 @@ static bool isolate_page(struct page *page, struct list_head *pagelist)
 		if (lru)
 			isolated = isolate_lru_page(page);
 		else
-			isolated = !isolate_movable_page(page,
-							 ISOLATE_UNEVICTABLE);
+			isolated = isolate_movable_page(page,
+							ISOLATE_UNEVICTABLE);
 
 		if (isolated) {
 			list_add(&page->lru, pagelist);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 17ed80707518..e54c4aa69636 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1668,10 +1668,10 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		 * LRU and non-lru movable pages.
 		 */
 		if (PageLRU(page))
-			ret = !isolate_lru_page(page);
+			ret = isolate_lru_page(page);
 		else
 			ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (!ret) { /* Success */
+		if (ret) { /* Success */
 			list_add_tail(&page->lru, &source);
 			if (!__PageMovable(page))
 				inc_node_page_state(page, NR_ISOLATED_ANON +
diff --git a/mm/migrate.c b/mm/migrate.c
index c5136fa48638..b7982aa745b0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -58,7 +58,7 @@
 
 #include "internal.h"
 
-int isolate_movable_page(struct page *page, isolate_mode_t mode)
+bool isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
 	struct folio *folio = folio_get_nontail_page(page);
 	const struct movable_operations *mops;
@@ -119,14 +119,14 @@ int isolate_movable_page(struct page *page, isolate_mode_t mode)
 	folio_set_isolated(folio);
 	folio_unlock(folio);
 
-	return 0;
+	return true;
 
 out_no_isolated:
 	folio_unlock(folio);
 out_putfolio:
 	folio_put(folio);
 out:
-	return -EBUSY;
+	return false;
 }
 
 static void putback_movable_folio(struct folio *folio)
-- 
2.27.0

