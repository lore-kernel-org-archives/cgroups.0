From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v3 4/4] mm: change to return bool for isolate_movable_page()
Date: Wed, 15 Feb 2023 18:39:37 +0800
Message-ID: <cb877f73f4fff8d309611082ec740a7065b1ade0.1676424378.git.baolin.wang@linux.alibaba.com>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1676424378.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
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
Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/migrate.h |  6 +++---
 mm/compaction.c         |  2 +-
 mm/memory-failure.c     |  4 ++--
 mm/memory_hotplug.c     | 10 +++++-----
 mm/migrate.c            |  6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

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
index 5fc2dcf4e3ab..bcb0dc41c2f2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1668,18 +1668,18 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		 * We can skip free pages. And we can deal with pages on
 		 * LRU and non-lru movable pages.
 		 */
-		if (PageLRU(page)) {
+		if (PageLRU(page))
 			isolated = isolate_lru_page(page);
-			ret = isolated ? 0 : -EBUSY;
-		} else
-			ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (!ret) { /* Success */
+		else
+			isolated = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
+		if (isolated) { /* Success */
 			list_add_tail(&page->lru, &source);
 			if (!__PageMovable(page))
 				inc_node_page_state(page, NR_ISOLATED_ANON +
 						    page_is_file_lru(page));
 
 		} else {
+			ret = -EBUSY;
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n", pfn);
 				dump_page(page, "isolation failed");
diff --git a/mm/migrate.c b/mm/migrate.c
index 2db546a0618c..9a101c7bb8ff 100644
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

