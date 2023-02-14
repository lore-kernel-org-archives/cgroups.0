From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 2/3] mm: check negative error of isolate_lru_page() when failed to isolate a page
Date: Tue, 14 Feb 2023 11:18:07 +0800
Message-ID: <fd5eff1f4f1225dd43748fa34c7e6c7c5f77f170.1676342827.git.baolin.wang@linux.alibaba.com>
References: <cover.1676342827.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1676342827.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Better to check the negative error of isolate_lru_page() when failed to
isolate a page from its LRU, which makes the code more clear.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/khugepaged.c     | 2 +-
 mm/memcontrol.c     | 2 +-
 mm/migrate.c        | 4 ++--
 mm/migrate_device.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 463dfca4b841..99a2d993b51c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -659,7 +659,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
 		 */
-		if (isolate_lru_page(page)) {
+		if (isolate_lru_page(page) < 0) {
 			unlock_page(page);
 			result = SCAN_DEL_PAGE_LRU;
 			goto out;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17335459d8dc..33cad66a4132 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6226,7 +6226,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 			 */
 			if (PageTransCompound(page))
 				goto put;
-			if (!device && isolate_lru_page(page))
+			if (!device && isolate_lru_page(page) < 0)
 				goto put;
 			if (!mem_cgroup_move_account(page, false,
 						mc.from, mc.to)) {
diff --git a/mm/migrate.c b/mm/migrate.c
index ef68a1aff35c..eaae39564f86 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2135,7 +2135,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
 
 		head = compound_head(page);
 		err = isolate_lru_page(head);
-		if (err)
+		if (err < 0)
 			goto out_putpage;
 
 		err = 1;
@@ -2541,7 +2541,7 @@ static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 		return 0;
 	}
 
-	if (isolate_lru_page(page))
+	if (isolate_lru_page(page) < 0)
 		return 0;
 
 	mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON + page_is_file_lru(page),
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 6c3740318a98..1ab56b5b7914 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -388,7 +388,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 				allow_drain = false;
 			}
 
-			if (isolate_lru_page(page)) {
+			if (isolate_lru_page(page) < 0) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
 				continue;
-- 
2.27.0

