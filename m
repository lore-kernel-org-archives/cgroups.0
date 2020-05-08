From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH 2/3] mm: swap: memcg: fix memcg stats for huge pages
Date: Fri,  8 May 2020 14:22:14 -0700
Message-ID: <20200508212215.181307-2-shakeelb@google.com>
References: <20200508212215.181307-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WB4fh0ll1orLfT6cXNAXpIF6IJgnNIJAflmvuUUH6tI=;
        b=ljlb+5JoPOLhwCwo/9ooaMm5dNWWqB4RKavWnR1bMTb4L6DZlaJkSQfWkg3sAAEQ0X
         UMnUuP9OvKrvFO2Zf1tnvuK0HExsQ2dYx49Deh2BpHI0OnP5ZatGHYAs8ZTI/yxrils3
         xzpe4ILlD48aErissngz/JZQjPXUgLkKPbNMlhHbgVIt6JvI2Qqhq9LILj81H24qLUpd
         2GqNHMP6geeEqMap9slI4hgNGU5PWE9SdVjpN1ZygLe6+JYzxYDnJcgw76g8ZJaiwYbx
         XGaBJ2xHrlPcPEipfB3nycm7Y2ZiWhkuNvSYmpS4fjdgG5Kmdhl2nIvXnPOUcLCgKgr5
         47gQ==
In-Reply-To: <20200508212215.181307-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yafang Shao <laoar.shao@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The commit 2262185c5b28 ("mm: per-cgroup memory reclaim stats") added
PGLAZYFREE, PGACTIVATE & PGDEACTIVATE stats for cgroups but missed
couple of places and PGLAZYFREE missed huge page handling. Fix that.
Also for PGLAZYFREE use the irq-unsafe function to update as the irq is
already disabled.

Fixes: 2262185c5b28 ("mm: per-cgroup memory reclaim stats")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/swap.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 3dbef6517cac..4eb179ee0b72 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -278,6 +278,7 @@ static void __activate_page(struct page *page, struct lruvec *lruvec,
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru);
 		SetPageActive(page);
@@ -285,7 +286,8 @@ static void __activate_page(struct page *page, struct lruvec *lruvec,
 		add_page_to_lru_list(page, lruvec, lru);
 		trace_mm_lru_activate(page);
 
-		__count_vm_events(PGACTIVATE, hpage_nr_pages(page));
+		__count_vm_events(PGACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
 		update_page_reclaim_stat(lruvec, file, 1);
 	}
 }
@@ -540,8 +542,10 @@ static void lru_deactivate_file_fn(struct page *page, struct lruvec *lruvec,
 		__count_vm_events(PGROTATED, nr_pages);
 	}
 
-	if (active)
+	if (active) {
 		__count_vm_events(PGDEACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
+	}
 	update_page_reclaim_stat(lruvec, file, 0);
 }
 
@@ -551,13 +555,15 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
 	if (PageLRU(page) && PageActive(page) && !PageUnevictable(page)) {
 		int file = page_is_file_lru(page);
 		int lru = page_lru_base_type(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
 		ClearPageActive(page);
 		ClearPageReferenced(page);
 		add_page_to_lru_list(page, lruvec, lru);
 
-		__count_vm_events(PGDEACTIVATE, hpage_nr_pages(page));
+		__count_vm_events(PGDEACTIVATE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
 		update_page_reclaim_stat(lruvec, file, 0);
 	}
 }
@@ -568,6 +574,7 @@ static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec,
 	if (PageLRU(page) && PageAnon(page) && PageSwapBacked(page) &&
 	    !PageSwapCache(page) && !PageUnevictable(page)) {
 		bool active = PageActive(page);
+		int nr_pages = hpage_nr_pages(page);
 
 		del_page_from_lru_list(page, lruvec,
 				       LRU_INACTIVE_ANON + active);
@@ -581,8 +588,8 @@ static void lru_lazyfree_fn(struct page *page, struct lruvec *lruvec,
 		ClearPageSwapBacked(page);
 		add_page_to_lru_list(page, lruvec, LRU_INACTIVE_FILE);
 
-		__count_vm_events(PGLAZYFREE, hpage_nr_pages(page));
-		count_memcg_page_event(page, PGLAZYFREE);
+		__count_vm_events(PGLAZYFREE, nr_pages);
+		__count_memcg_events(lruvec_memcg(lruvec), PGLAZYFREE, nr_pages);
 		update_page_reclaim_stat(lruvec, 1, 0);
 	}
 }
-- 
2.26.2.645.ge9eca65c58-goog

