From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 1/3] mm: check negative error of folio_isolate_lru() when failed to isolate a folio
Date: Tue, 14 Feb 2023 11:18:06 +0800
Message-ID: <ef7059c8442b7e1ee5f406523b79d24d19b050b6.1676342827.git.baolin.wang@linux.alibaba.com>
References: <cover.1676342827.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1676342827.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The folio_isolate_lru() will return a negative error if failed to isolate
a folio from its LRU list, thus better to check the negative error to
make the code more clear per Linus's suggestion[1].

No functional changes.

[1] https://lore.kernel.org/all/CAHk-=wiBrY+O-4=2mrbVyxR+hOqfdJ=Do6xoucfJ9_5az01L4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 mm/damon/paddr.c | 2 +-
 mm/gup.c         | 2 +-
 mm/khugepaged.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b4df9b9bcc0a..ebf3dd084af2 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -246,7 +246,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s)
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
-		if (folio_isolate_lru(folio)) {
+		if (folio_isolate_lru(folio) < 0) {
 			folio_put(folio);
 			continue;
 		}
diff --git a/mm/gup.c b/mm/gup.c
index b0885f70579c..7fdddd43663c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1939,7 +1939,7 @@ static unsigned long collect_longterm_unpinnable_pages(
 			drain_allow = false;
 		}
 
-		if (folio_isolate_lru(folio))
+		if (folio_isolate_lru(folio) < 0)
 			continue;
 
 		list_add_tail(&folio->lru, movable_page_list);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a5d32231bfad..463dfca4b841 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2047,7 +2047,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
-		if (folio_isolate_lru(folio)) {
+		if (folio_isolate_lru(folio) < 0) {
 			result = SCAN_DEL_PAGE_LRU;
 			goto out_unlock;
 		}
-- 
2.27.0

