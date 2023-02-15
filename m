From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v3 2/4] mm: change to return bool for isolate_lru_page()
Date: Wed, 15 Feb 2023 18:39:35 +0800
Message-ID: <3074c1ab628d9dbf139b33f248a8bc253a3f95f0.1676424378.git.baolin.wang@linux.alibaba.com>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1676424378.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The isolate_lru_page() can only return 0 or -EBUSY, and most users did
not care about the negative error of isolate_lru_page(), except one user
in add_page_for_migration(). So we can convert the isolate_lru_page() to
return a boolean value, which can help to make the code more clear when
checking the return value of isolate_lru_page().

Also convert all users' logic of checking the isolation state.

No functional changes intended.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/folio-compat.c   | 12 +++---------
 mm/internal.h       |  2 +-
 mm/khugepaged.c     |  2 +-
 mm/memcontrol.c     |  4 ++--
 mm/memory-failure.c |  4 ++--
 mm/memory_hotplug.c |  8 +++++---
 mm/migrate.c        |  9 ++++++---
 mm/migrate_device.c |  2 +-
 8 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 540373cf904e..cabcd1de9ecb 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -113,17 +113,11 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
 
-int isolate_lru_page(struct page *page)
+bool isolate_lru_page(struct page *page)
 {
-	bool ret;
-
 	if (WARN_RATELIMIT(PageTail(page), "trying to isolate tail page"))
-		return -EBUSY;
-	ret = folio_isolate_lru((struct folio *)page);
-	if (ret)
-		return 0;
-
-	return -EBUSY;
+		return false;
+	return folio_isolate_lru((struct folio *)page);
 }
 
 void putback_lru_page(struct page *page)
diff --git a/mm/internal.h b/mm/internal.h
index 8645e8496537..fc01fd092ea5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -187,7 +187,7 @@ pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
 /*
  * in mm/vmscan.c:
  */
-int isolate_lru_page(struct page *page);
+bool isolate_lru_page(struct page *page);
 bool folio_isolate_lru(struct folio *folio);
 void putback_lru_page(struct page *page);
 void folio_putback_lru(struct folio *folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index cee659cfa3c1..8dbc39896811 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -659,7 +659,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
 		 */
-		if (isolate_lru_page(page)) {
+		if (!isolate_lru_page(page)) {
 			unlock_page(page);
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17335459d8dc..e8fd42be5fab 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6176,7 +6176,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
 		if (target_type == MC_TARGET_PAGE) {
 			page = target.page;
-			if (!isolate_lru_page(page)) {
+			if (isolate_lru_page(page)) {
 				if (!mem_cgroup_move_account(page, true,
 							     mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
@@ -6226,7 +6226,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 			 */
 			if (PageTransCompound(page))
 				goto put;
-			if (!device && isolate_lru_page(page))
+			if (!device && !isolate_lru_page(page))
 				goto put;
 			if (!mem_cgroup_move_account(page, false,
 						mc.from, mc.to)) {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index db85c2d37f70..e504362fdb23 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -846,7 +846,7 @@ static const char * const action_page_types[] = {
  */
 static int delete_from_lru_cache(struct page *p)
 {
-	if (!isolate_lru_page(p)) {
+	if (isolate_lru_page(p)) {
 		/*
 		 * Clear sensible page flags, so that the buddy system won't
 		 * complain when the page is unpoison-and-freed.
@@ -2513,7 +2513,7 @@ static bool isolate_page(struct page *page, struct list_head *pagelist)
 		bool lru = !__PageMovable(page);
 
 		if (lru)
-			isolated = !isolate_lru_page(page);
+			isolated = isolate_lru_page(page);
 		else
 			isolated = !isolate_movable_page(page,
 							 ISOLATE_UNEVICTABLE);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a1e8c3e9ab08..5fc2dcf4e3ab 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1632,6 +1632,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		struct folio *folio;
+		bool isolated;
 
 		if (!pfn_valid(pfn))
 			continue;
@@ -1667,9 +1668,10 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		 * We can skip free pages. And we can deal with pages on
 		 * LRU and non-lru movable pages.
 		 */
-		if (PageLRU(page))
-			ret = isolate_lru_page(page);
-		else
+		if (PageLRU(page)) {
+			isolated = isolate_lru_page(page);
+			ret = isolated ? 0 : -EBUSY;
+		} else
 			ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
 		if (!ret) { /* Success */
 			list_add_tail(&page->lru, &source);
diff --git a/mm/migrate.c b/mm/migrate.c
index ef68a1aff35c..53010a142e7f 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2132,11 +2132,14 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 		}
 	} else {
 		struct page *head;
+		bool isolated;
 
 		head = compound_head(page);
-		err = isolate_lru_page(head);
-		if (err)
+		isolated = isolate_lru_page(head);
+		if (!isolated) {
+			err = -EBUSY;
 			goto out_putpage;
+		}
 
 		err = 1;
 		list_add_tail(&head->lru, pagelist);
@@ -2541,7 +2544,7 @@ static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 		return 0;
 	}
 
-	if (isolate_lru_page(page))
+	if (!isolate_lru_page(page))
 		return 0;
 
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_is_file_lru(page),
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 6c3740318a98..d30c9de60b0d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -388,7 +388,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 				allow_drain = false;
 			}
 
-			if (isolate_lru_page(page)) {
+			if (!isolate_lru_page(page)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
 				continue;
-- 
2.27.0

