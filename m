From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v18 29/32] mm: Identify compound pages sooner in isolate_migratepages_block
Date: Mon, 24 Aug 2020 20:55:02 +0800
Message-ID: <1598273705-69124-30-git-send-email-alex.shi@linux.alibaba.com>
References: <1598273705-69124-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1598273705-69124-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>

From: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Since we are holding a reference to the page much sooner in
isolate_migratepages_block we can move the PageCompound check out of the
LRU locked section and instead just place it after get_page_unless_zero. By
doing this we can allow any of the items that might trigger a failure to
trigger a failure for the compound page rather than the order 0 page and as
a result we should be able to process the pageblock faster.

In addition by testing for PageCompound sooner we can avoid having the LRU
flag cleared and then reset in the exception case. As a result this should
prevent possible races where another thread might be attempting to pull the
LRU pages from the list.

Signed-off-by: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
---
 mm/compaction.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 6bf5ccd8fcf6..a0e48d079124 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -984,6 +984,24 @@ static bool too_many_isolated(pg_data_t *pgdat)
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
+		/*
+		 * Page is compound. We know the order before we know if it is
+		 * on the LRU so we cannot assume it is THP. However since the
+		 * page will have the LRU validated shortly we can use the value
+		 * to skip over this page for now or validate the LRU is set and
+		 * then isolate the entire compound page if we are isolating to
+		 * generate a CMA page.
+		 */
+		if (PageCompound(page)) {
+			const unsigned int order = compound_order(page);
+
+			if (likely(order < MAX_ORDER))
+				low_pfn += (1UL << order) - 1;
+
+			if (!cc->alloc_contig)
+				goto isolate_fail_put;
+		}
+
 		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
 			goto isolate_fail_put;
 
@@ -1009,23 +1027,8 @@ static bool too_many_isolated(pg_data_t *pgdat)
 				if (test_and_set_skip(cc, page, low_pfn))
 					goto isolate_abort;
 			}
-
-			/*
-			 * Page become compound since the non-locked check,
-			 * and it's on LRU. It can only be a THP so the order
-			 * is safe to read and it's 0 for tail pages.
-			 */
-			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
-				low_pfn += compound_nr(page) - 1;
-				SetPageLRU(page);
-				goto isolate_fail_put;
-			}
 		}
 
-		/* The whole page is taken off the LRU; skip the tail pages. */
-		if (PageCompound(page))
-			low_pfn += compound_nr(page) - 1;
-
 		/* Successfully isolated */
 		del_page_from_lru_list(page, lruvec, page_lru(page));
 		mod_node_page_state(page_pgdat(page),
-- 
1.8.3.1

